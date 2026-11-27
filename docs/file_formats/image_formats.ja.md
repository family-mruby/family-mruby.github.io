# 画像・アイコンファイル

Family mruby が対応する画像・アイコン形式と、その作成・変換方法を説明します。

| 形式 | 用途 | 関連 API |
|---|---|---|
| PNG | 1 枚の絵の表示、スプライト、タイルシート、壁紙、ランチャーのアイコン | [`FmrbGfx#create_image`](../api/fmrb_gfx.md#画像) / [SpriteImage](../api/sprite.md#spriteimage) |
| BMP (RGB332) | スプライトとタイルシート、Ruby で画素を編集するとき | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | アプリアイコン（テキスト形式） | – |

## PNG

`FmrbGfx#create_image` と `load_image` は PNG を受けます。開発中の版では `SpriteImage#load_bmp`
(と、それを使う `TileSheet`) も PNG を読めます。BMP とは先頭のバイトで見分けます。色は赤・緑・青の
上位 3/3/2 ビットを残して RGB332 になり、透明はスプライトの `transparent_color` で決まります
(PNG のアルファではありません)。

システムに同梱の素材 (スプライト、タイルシート、壁紙、ランチャーのアイコン) は、使う色だけの
パレットを持つ PNG (1・2・4・8 ビット/画素) です。同じ絵の 8 ビットの BMP と比べて 1/10〜1/60 の
大きさで、小さいものはファイルシステムの 1 つのエントリに収まります。パレットの色が RGB332 を
8 ビットに広げた値なら、読み込んだ結果は元の RGB332 の値そのものになります。

[スプライトエディタ](#関連) が開いて保存できるのは、今も BMP だけです。

## BMP (RGB332)

Family mruby が読む BMP は、RGB332 配列を使用した 8bit BMP です。

1 ピクセルは 1 バイトで、各ピクセル値そのものを RGB332 色値として扱います。

- R: 3bit
- G: 3bit
- B: 2bit

合計 256 色を表現できます。

### フォーマット仕様

BMP ファイル形式としては、標準的な 8bit indexed BMP を使用します。

- BMP ヘッダ
  - `BITMAPFILEHEADER`
  - `BITMAPINFOHEADER`
- 8bit indexed BMP
- 256 色パレット
- パレット内容は RGB332 配列
- 各ピクセル値は RGB332 色値として扱われる

BMP 内のパレットは、PC 上の画像ビューア互換性のために含まれています。  
Family mruby 側ではパレット参照は行わず、ピクセル値を直接 RGB332 色値として扱います。

### RGB332 の色構成

| 要素 | bit数 |
|---|---|
| Red | 3bit |
| Green | 3bit |
| Blue | 2bit |

合計 8bit / 256 色です。

## アイコンファイル (.icon)

アプリのランチャーに表示するアイコンを定義する テキスト形式 のファイルです。

### 形式

```
# <名前> (<幅>x<高さ>) color=0x<RGB332>
............
...111111...
..11111111..
.11111.1111.
111111..1111
.1111111111.
..11111111..
...111111...
....1111....
.....11.....
............
............
```

| 文字 | 意味 |
|---|---|
| `.` | 透明（描画しない） |
| `1` | ピクセル（指定色で塗る） |
| `#` | コメント行（先頭に色設定が書ける） |

### コメント行のメタ情報

- `color=0xNN` で全ピクセルの色（RGB332）を指定
- 省略時は白 (`0xFF`)

### 推奨サイズ

ランチャーアイコンの標準サイズは 12 × 12 ピクセル

### 配置先

```
/usr/share/icon/<name>.icon
```

`.toml` で参照する際は:

```toml
icon = "/usr/share/icon/myapp.icon"
```
### 既定アイコン

`.toml` で `icon` を省略すると、本体ファイルの拡張子に応じた既定アイコンが使われます:

| 拡張子 | 既定アイコン |
|---|---|
| `.rb` | `/usr/share/icon/ruby.icon` |
| `.lua` | `/usr/share/icon/lua.icon` |
| `.bas` | `/usr/share/icon/basic.icon` |
| `.py` | `/usr/share/icon/python.icon` |
| `.wasm` | `/usr/share/icon/wasm.icon` |

[WebAssembly のアプリ](../languages/wasm.md) は、ふつうは言語のアイコン (`c.icon`・`tinygo.icon`・
`rust.icon`・`zig.icon`) を指定します。

### ランチャーが読むもの

`.icon` のテキストは元のデータです。ランチャーが読むのはその隣の絵 (`<名前>.png`、PNG が無ければ
`<名前>.bmp`) で、12x12 の格子を 2 倍の大きさで描いたものです。自分のアイコンを作るときは、
fmruby-core の `tools/gen_icon_png.rb` (か `rake icons`) で `.icon` から PNG を作り、2 つを並べて
置きます **(開発版)**。

## 関連

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- スプライトエディタ: `/app/tool/sprite_editor.app.rb`
