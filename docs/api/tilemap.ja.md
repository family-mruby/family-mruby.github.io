# TileSheet / TileMap

タイルベースのマップ描画を簡単に書くためのライブラリ。RPG のような格子状の世界、敷き詰めた背景、ステージ式パズルなどに向きます。

| クラス | 役割 |
|---|---|
| `TileSheet` | タイル画像（タイルが並んだ 1 枚の BMP）をラップ。1 タイル単位で `stamp` できる |
| `TileMap` | `fmrb_map` JSON ファイルを読み込み、レイヤごとに `TileSheet#stamp` を呼んで描画 |

両クラスとも `picoruby-fmrb-app` に組み込みで、追加の `require` は不要です。

## TileSheet

BMP 形式のタイルシート画像（連続したタイルが格子状に並んだ画像）を扱います。

### コンストラクタ

```ruby
TileSheet.new(gfx, path, cols:, rows: nil, tile_size: 16)
```

| 引数 | 用途 |
|---|---|
| `gfx` | `FmrbGfx` インスタンス |
| `path` | **WROVER 側にすでに転送された** BMP のパス（`@gfx.transfer_file` で送る） |
| `cols:` | シートの列数（タイル単位） |
| `rows:` | 行数。`nil` なら BMP のサイズから自動推定（8bit BMP 前提） |
| `tile_size:` | 1 タイルのピクセル幅・高さ（既定: 16） |

内部で透過色 `0` の `SpriteImage` を作り、BMP を `load_bmp` します。

### メソッド

| メソッド | 用途 |
|---|---|
| `stamp(index, dst_x:, dst_y:)` | タイル番号 `index`（行優先: `row * cols + col`）をキャンバスにスタンプ。`nil` や負の値は no-op（マップの空セル用） |
| `destroy` | 内部 SpriteImage を解放 |

| 属性 | 内容 |
|---|---|
| `image` | 内部 SpriteImage |
| `cols` / `rows` | タイル数 |
| `tile_size` | ピクセルサイズ |

### サンプル

```ruby
@gfx.transfer_file("/usr/share/sprites/tilesheet.bmp",
                   "/usr/share/sprites/tilesheet.bmp")
sheet = TileSheet.new(@gfx,
                       "/usr/share/sprites/tilesheet.bmp",
                       cols: 4, tile_size: 16)
sheet.stamp(0, dst_x: 0,  dst_y: 0)   # 0 番目のタイルを左上に
sheet.stamp(5, dst_x: 16, dst_y: 0)   # 5 番目のタイルを右に
```

## TileMap

`fmrb_map` v1 形式の JSON ファイルを読み込み、レイヤごとにタイルを敷き詰めます。

### コンストラクタ

```ruby
TileMap.new(json_path)
```

`json_path` は **core 側 (内蔵 flash) の JSON パス**。WROVER 側ではないことに注意。

### メソッド

| メソッド | 用途 |
|---|---|
| `render(sheet, origin_x:, origin_y:, max_cols: nil, max_rows: nil)` | 全レイヤを描画。`origin_*` は左上タイルの描画位置。`max_cols/rows` で表示範囲をクリップ（マップが画面より大きいときのビューポート用） |
| `event_at(x, y)` | タイル座標 (x, y) のイベント Hash を返す。なければ `nil` |

| 属性 | 内容 |
|---|---|
| `width` / `height` | マップの幅・高さ（タイル単位） |
| `tile_size` | 1 タイルのピクセルサイズ |
| `tilesheet_path` | 使用するタイルシートのパス |
| `tilesheet_cols` | タイルシートの列数 |
| `layers` | レイヤ配列 |
| `events` | イベント配列 |

### サンプル

```ruby
map = TileMap.new("/app/game/rpg_demo/world.map.json")
# シートは map.tilesheet_path / map.tilesheet_cols を使って構築
sheet = TileSheet.new(@gfx, map.tilesheet_path, cols: map.tilesheet_cols)

# 11x11 タイル分のビューポートに描画
map.render(sheet, origin_x: 16, origin_y: 16, max_cols: 11, max_rows: 11)
@gfx.present
```

## fmrb_map JSON 形式 (v1)

```json
{
  "format": "fmrb_map",
  "version": 1,
  "width": 20,
  "height": 15,
  "tile_size": 16,
  "tilesheet": "/usr/share/sprites/tilesheet.bmp",
  "tilesheet_cols": 4,
  "layers": [
    { "name": "ground", "data": [[0, 0, 1, ...], [...], ...] },
    { "name": "objects", "data": [[null, null, 5, ...], [...], ...] }
  ],
  "events": [
    { "x": 4, "y": 6, "kind": "talk", "text": "こんにちは" }
  ]
}
```

| キー | 内容 |
|---|---|
| `format` | 固定で `"fmrb_map"` |
| `version` | 1 |
| `width` / `height` | マップサイズ（タイル単位） |
| `tile_size` | 1 タイルピクセル数 |
| `tilesheet` | 使用するシートの WROVER 側パス |
| `tilesheet_cols` | シートの列数 |
| `layers[]` | 各レイヤ。`data` は 2次元配列（`[row][col]` → タイル番号、`null` で空） |
| `events[]` | 任意イベント。`event_at(x, y)` で取得 |

## マップを作るツール

タイルシートとマップは **Web ツール** で作成できます（`fmruby-core/tool/web/` に同梱）:

- **スプライトエディタ**: 16x16 RGB332 タイルを並べた BMP を作る
- **マップエディタ**: タイル配置 + イベント編集 → `fmrb_map` JSON エクスポート

`ruby web_server.rb` で起動して `http://localhost:8080` から使えます（[コンソール](../getting_started/console.md) と同じサーバ）。

## サンプル: 簡単な RPG

`flash/app/game/rpg_demo/` に完全な RPG デモがあります。フルスクリーンで:

- 左 176x176（11x11 タイル）: `TileMap` + `TileSheet` で描画したフィールド
- 右 128x240: プレイヤー座標 / 直前イベントの表示パネル
- プレイヤーは別 BMP（16x16）を `SpriteInstance` で矢印キー / D-pad 操作

このディレクトリには `.app.rb` / `.app.toml` と一緒に `world.bmp`、`world.map.json`、`player.bmp` が同梱されています。ランチャーは **3 階層スキャン** で `/app/<category>/<bundle>/*.app.toml` も拾うので、アプリと一緒にアセットを置けます。

## 関連

- [FmrbGfx ▸ `draw_tile`](fmrb_gfx.md#画像-api) — 低レベルなタイル描画 API
- [Sprite](sprite.md) — SpriteImage / SpriteInstance / GfxBlock
- [アプリ設定 (.toml)](../file_formats/app_toml.md) — アプリ単位の設定
