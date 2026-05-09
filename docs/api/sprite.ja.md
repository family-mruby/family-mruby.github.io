# Sprite

スプライト・タイルマップ系の API をまとめたページです。

| クラス | 役割 |
|---|---|
| `SpriteImage` | スプライトの画像バッファ（再利用可能なピクセルデータ） |
| `SpriteInstance` | 画面に配置されるスプライトインスタンス（位置、フレーム、可視） |
| `GfxBlock` | 描画コマンド列を **WROVER 側にバイトコードとしてキャッシュ** し、可変パラメータだけを再送信する仕組み |

!!! warning "`@gfx.present` を呼ぶ"
    `SpriteInstance#move`・`visible=`・`frame=` の後は **`@gfx.present` を呼んで** ください。スプライトの合成 (composite) は `present` のタイミングで実行されます。

## SpriteImage

画像バッファを保持するクラスです。`SpriteInstance` から参照されます。

### コンストラクタ

```ruby
SpriteImage.new(gfx,
                width:,
                height:,
                transparent_color: 0,
                use_transparent: false)
```

| 引数 | 説明 |
|---|---|
| `gfx` | 親の `FmrbGfx` インスタンス |
| `width:` / `height:` | ピクセル単位 |
| `transparent_color:` | 透過色のキー（RGB332） |
| `use_transparent:` | `true` のとき `transparent_color` を透明として描画 |

### メソッド

| メソッド | 用途 |
|---|---|
| `set_target` | 以降の `@gfx.fill_rect` などをこの画像に描画 |
| `reset_target` | 描画先を画面キャンバスに戻す |
| `draw { |gfx| ... }` | ブロック内のみこの画像を描画先にする糖衣 |
| `load_bmp(path)` | BMP ファイルを画像へ読み込み（**WROVER 側でデコード**、高速） |
| `destroy` | リソース解放 |

| 属性 | 内容 |
|---|---|
| `id` | スプライト画像 ID |
| `width` / `height` | サイズ |

### サンプル

```ruby
img = SpriteImage.new(@gfx, width: 32, height: 32,
                       transparent_color: 0, use_transparent: true)
img.draw do |g|
  g.fill_rect(0, 0, 32, 32, FmrbGfx::BLACK)  # 透過扱い
  g.fill_circle(16, 16, 12, FmrbGfx::RED)
end
# あるいは BMP から読み込み
img2 = SpriteImage.new(@gfx, width: 16, height: 16)
img2.load_bmp("/flash/usr/share/sprite/player.bmp")
```

## SpriteInstance

画面上のスプライト位置・アニメーションを管理します。

### コンストラクタ

```ruby
SpriteInstance.new(gfx,
                   images,    # SpriteImage または Array
                   x:, y:,
                   z: 0)
```

`images` に複数の `SpriteImage` を渡すとアニメーションフレームになります。

### メソッド

| メソッド | 用途 |
|---|---|
| `move(x, y)` | 位置を変更 |
| `visible = bool` | 表示／非表示 |
| `frame = index` | アニメーションフレーム番号 |
| `destroy` | リソース解放 |

### サンプル: アニメーションするスプライト

```ruby
class SpriteApp < FmrbApp
  def on_create
    frames = []
    3.times do |i|
      img = SpriteImage.new(@gfx, width: 16, height: 16,
                              transparent_color: 0, use_transparent: true)
      img.draw do |g|
        g.fill_rect(0, 0, 16, 16, FmrbGfx::BLACK)
        g.fill_circle(8, 8, 4 + i * 2, FmrbGfx::YELLOW)
      end
      frames << img
    end
    @sprite = SpriteInstance.new(@gfx, frames,
                                  x: @user_area_x0 + 50,
                                  y: @user_area_y0 + 30, z: 1)
    @frame = 0
  end

  def on_update
    @frame = (@frame + 1) % 3
    @sprite.frame = @frame
    @gfx.present  # 重要
    150
  end
end

SpriteApp.new.start
```

## GfxBlock

繰り返し再描画する UI（ウィンドウ枠、スクロールバーのつまみ、HUD 等）を高速化するための **ブロックバイトコード** です。

仕組み:

1. 渡したブロックを 2 回評価して、変化する整数引数を「レジスタ」として検出
2. 描画コマンド列を WROVER 側にコンパイル・キャッシュ
3. `draw(**kwargs)` 呼び出しでは **変化したレジスタの値だけを送信** して再実行

これにより、毎フレーム数十個の描画コマンドを送るより遥かに省帯域になります（`FmrbApp` 自身がウィンドウ枠の描画にこれを使っています）。

### 制約

| 制約 | 内容 |
|---|---|
| ブロックは **同じ命令列** を出す必要あり | `if` で命令数を変えるのは不可。ループ内の固定回数は OK |
| **String 引数は固定** | `draw_text` の文字列は `new` 時に固定される |
| **Integer / Float のみ** kwargs にできる | `Boolean` は不可 |
| 最大 **16 レジスタ** | 可変パラメータの総数 |
| ペイロード上限 | コンパイル後 **220 バイト** （UART 単一フレーム制限） |

### 利用可能な描画 DSL

| メソッド | シグネチャ |
|---|---|
| `clear(color)` | – |
| `draw_rect` / `fill_rect` | `(x, y, w, h, color)` |
| `draw_round_rect` / `fill_round_rect` | `(x, y, w, h, r, color)` |
| `draw_line` | `(x0, y0, x1, y1, color)` |
| `fill_circle` | `(x, y, r, color)` |
| `draw_text` | `(x, y, str, color)` （`str` は固定文字列） |

### サンプル: バッテリーゲージ

```ruby
class BatteryGauge < FmrbApp
  def on_create
    x = @user_area_x0 + 5
    y = @user_area_y0 + 5
    @gauge = GfxBlock.new(@gfx, fill: 50) do |r, fill:|
      r.draw_rect(x, y, 60, 12, FmrbGfx::WHITE)
      r.fill_rect(x + 1, y + 1, fill, 10, FmrbGfx::GREEN)
    end
    @level = 50
  end

  def on_update
    @level = (@level + 5) % 60
    @gauge.draw(fill: @level)
    @gfx.present
    300
  end

  def on_destroy
    @gauge.destroy if @gauge
  end
end

BatteryGauge.new.start
```

### 例外

| 例外 | 発生条件 |
|---|---|
| `GfxBlock::StructureError` | 1 回目と 2 回目の評価で命令列が異なる |
| `GfxBlock::TooManyRegsError` | 可変パラメータ数が 17 個以上 |
| `GfxBlock::UnsupportedKwargError` | kwarg に `Integer` / `Float` / `String` 以外を渡した |
| `GfxBlock::PayloadTooLargeError` | コンパイル後ペイロードが 220 バイト超 |

!!! tip "GfxBlock を使うべき場面"
    - 毎フレーム同じ構造の図形を描く（HUD、バー、フレーム等）
    - 可変なのは座標や色だけで命令列は固定
    - 1 回の `present` で大量の描画コマンドを送りたい

    対して、形が変わる UI や条件分岐の多い描画では普通の `FmrbGfx` メソッドを使います。
