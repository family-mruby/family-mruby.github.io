# FmrbGfx

`FmrbGfx` は描画 API を提供するクラスです。`FmrbApp` を継承したアプリでは `@gfx` として参照できます。

!!! warning "`present` を呼ぶまで画面に出ない"
    描画コマンドはすべてバッファに蓄積されます。**`@gfx.present` を呼んだタイミング** で fmruby-graphics-audio に転送され、画面に反映されます。

## 座標系・カラーモデル

- 座標系: 左上原点 (0, 0)、X が右方向、Y が下方向
- 色: **RGB332**（8bit、R:3 G:3 B:2）。`0x00`〜`0xFF` の整数で指定

`FmrbGfx::WHITE` などの定数を使うか、`FmrbGfx.rgb_to_332(r, g, b)` で 24bit 値から変換します。

### カラー定数

| 定数 | 値 |
|---|---|
| `FmrbGfx::BLACK` | `0x00` |
| `FmrbGfx::WHITE` | `0xFF` |
| `FmrbGfx::RED` | `0xE0` |
| `FmrbGfx::GREEN` | `0x1C` |
| `FmrbGfx::BLUE` | `0x03` |
| `FmrbGfx::YELLOW` | `0xFC` |
| `FmrbGfx::CYAN` | `0x1F` |
| `FmrbGfx::MAGENTA` | `0xE3` |
| `FmrbGfx::GRAY` | `0x6D` |

### 色変換

```ruby
FmrbGfx.rgb_to_332(255, 128, 0)  # → 0xF0 など
FmrbGfx.hsv_to_rgb(120, 255, 255) # → [r, g, b] (各 0..255)
```

## 制御メソッド

| メソッド | 用途 |
|---|---|
| `clear(color)` | 画面全体をクリア |
| `present` | バッファに蓄積した描画コマンドを画面に反映 |

## 基本図形

すべて末尾に `color`（RGB332）を取ります。

| メソッド | シグネチャ |
|---|---|
| `set_pixel` | `set_pixel(x, y, color)` |
| `draw_line` | `draw_line(x1, y1, x2, y2, color)` |
| `draw_rect` | `draw_rect(x, y, w, h, color)`（枠のみ） |
| `fill_rect` | `fill_rect(x, y, w, h, color)`（塗りつぶし） |
| `blend_rect` | `blend_rect(x, y, w, h, color, mode:)`（`mode: 0`=ADD, `1`=XOR） |
| `draw_circle` | `draw_circle(x, y, r, color)` |
| `fill_circle` | `fill_circle(x, y, r, color)` |
| `draw_ellipse` | `draw_ellipse(x, y, rx, ry, color)` |
| `fill_ellipse` | `fill_ellipse(x, y, rx, ry, color)` |
| `draw_round_rect` | `draw_round_rect(x, y, w, h, radius, color)` |
| `fill_round_rect` | `fill_round_rect(x, y, w, h, radius, color)` |
| `draw_triangle` | `draw_triangle(x0, y0, x1, y1, x2, y2, color)` |
| `fill_triangle` | `fill_triangle(x0, y0, x1, y1, x2, y2, color)` |
| `draw_arc` | `draw_arc(x, y, r0, r1, angle0, angle1, color)` |
| `fill_arc` | `fill_arc(x, y, r0, r1, angle0, angle1, color)` |

`draw_arc` / `fill_arc` の角度は整数（度数）。`r0` が内径、`r1` が外径。

## テキスト描画

```ruby
@gfx.set_text_size(2)             # 1〜4
@gfx.draw_text(10, 20, "Hello",
               FmrbGfx::BLACK)    # bg なし→透過
@gfx.draw_text(10, 40, "Hi",
               FmrbGfx::WHITE,
               FmrbGfx::BLUE)     # bg あり→不透明
```

| メソッド | 用途 |
|---|---|
| `set_text_size(size)` | テキストサイズ。`1`〜`4` |
| `draw_text(x, y, text, color [, bg_color], mixed: false)` | テキスト描画。`mixed: true` で ASCII/日本語ハイブリッド |
| `set_font(family, size = nil)` | フォント切替（後述） |
| `current_font` / `current_text_size` | 現在のフォント / サイズ（読み取り専用） |

## 日本語テキスト・フォント切替

`set_font(family, size)` で日本語フォントに切り替えると、UTF-8 文字列をそのまま描画できます。

```ruby
# 既定の ASCII フォント（Font0、6x8）
@gfx.set_font(:default)
@gfx.draw_text(10, 20, "Hello", FmrbGfx::BLACK)

# 日本語 8px（misaki_8、システム UI と揃う小さめ）
@gfx.set_font(:ja, 8)
@gfx.draw_text(10, 40, "こんにちは", FmrbGfx::BLACK)

# 日本語 12px（efontJA_12、読みやすい大きめ）
@gfx.set_font(:ja, 12)
@gfx.draw_text(10, 60, "ファミリーmruby", FmrbGfx::BLACK)
```

### 対応フォント

| `family` | `size` | 内容 |
|---|---|---|
| `:default` | （指定不可） | Font0 6x8 ASCII。起動時の既定 |
| `:ja` | `8` | **misaki_8** 8x8、システム UI と同サイズ |
| `:ja` | `12` | **efontJA_12** 12x12、読みやすい |

### ハイブリッド描画 (`mixed: true`)

ASCII と日本語が混ざった文字列を 1 回の `draw_text` で描けます。ASCII 部分は Font0 (6x8)、UTF-8 マルチバイト部分は misaki_8 (8x8) でレンダリングされます。

```ruby
@gfx.draw_text(10, 20, "puts 'こんにちは'",
               FmrbGfx::BLACK, mixed: true)
```

コード例や英日混在の UI 文字列に便利です。

!!! tip "`draw_window_frame` はフォントを保存・復元"
    `FmrbApp#draw_window_frame` はタイトルバーを必ず既定の 6x8 で描いてから **呼び出し前のフォント設定を復元** します。アプリ側で毎フレーム `set_font` を再指定する必要はありません。

!!! note "JA フォントの読み込みコスト"
    `set_font(:ja, ...)` 初回は WROVER 側でフォントデータを準備するため数十 ms 程度かかります。`on_create` 内で一度だけ呼ぶのが理想です。

### サンプル（日本語）

```ruby
class HelloJaApp < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    @gfx.set_font(:ja, 12)
    @gfx.draw_text(@user_area_x0 + 8, @user_area_y0 + 8,
                   "こんにちは、Family mruby!", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

HelloJaApp.new.start
```

`flash/app/demo/ja_text.app.rb` に各モード（default / 8px / 12px / Mixed / Hybrid / Scaled）を切り替えるサンプルがあります。

## 画像 API

```ruby
# ファイル転送（PC → flash）
@gfx.transfer_file("local.bmp", "/img.bmp")

# 画像のロードと描画
img = @gfx.create_image_from_file("/img.bmp")
@gfx.draw_image(img[:id], 10, 20)               # 等倍
@gfx.draw_image(img[:id], 10, 20, scale_x: 2.0,
                scale_y: 2.0)                   # 2倍
@gfx.delete_image(img[:id])
```

| メソッド | 戻り値 / 用途 |
|---|---|
| `transfer_file(src, dst)` | `true` 成功、失敗時は例外 |
| `file_status(path)` | `{exists:, size:}` |
| `create_image_from_file(path)` | `{id:, width:, height:}` または `nil` |
| `draw_image(id, x, y, scale_x: 1.0, scale_y: 1.0)` | 画像描画 |
| `delete_image(id)` | 解放 |

!!! note "対応画像形式"
    `create_image_from_file` は **RGB332 の BMP** に対応します。フォーマットの詳細は [画像・アイコンファイル](../file_formats/image_formats.md) を参照。

## NTSC 出力調整（ESP32 のみ）

| メソッド | 用途 | 範囲 |
|---|---|---|
| `set_output_level(level)` | 輝度全体 | 0..255 |
| `set_chroma_level(level)` | 彩度（カラーバースト振幅） | 0..255 |

CRT モニタでの色調整に使います（[NTSC 出力テスト](../examples.md) のサンプル参照）。

## サンプル: 図形を並べる

```ruby
class ShapesApp < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    x = @user_area_x0 + 5
    y = @user_area_y0 + 5
    @gfx.fill_rect(x, y, 30, 20, FmrbGfx::RED)
    @gfx.fill_circle(x + 60, y + 10, 10, FmrbGfx::GREEN)
    @gfx.draw_round_rect(x + 90, y, 30, 20, 4, FmrbGfx::BLUE)
    @gfx.draw_text(x, y + 30, "Shapes",
                   FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end

  def on_update
    500
  end
end

ShapesApp.new.start
```

## 注意事項

!!! warning "描画は present でまとめる"
    高頻度に呼び出される `on_update` 内では、複数の描画コマンドの後に **1 回だけ `present`** を呼ぶのが推奨です。コマンドごとに `present` すると UART 帯域を圧迫します。

!!! warning "ウィンドウ枠を侵さない"
    `@user_area_x0/y0/width/height` の範囲内で描画してください。タイトルバーや枠線を上書きすると見た目が崩れます。

## 関連

- スプライト・タイルマップは [Sprite](sprite.md)
- 動的な GUI を効率化する `GfxBlock` も [Sprite](sprite.md#gfxblock) に説明があります
