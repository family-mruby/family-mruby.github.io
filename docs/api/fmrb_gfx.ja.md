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
| `draw_text(x, y, text, color [, bg_color])` | 第5引数を省略すると背景透過 |

## 画像 API

```ruby
# ファイル転送（PC → flash）
@gfx.transfer_file("local.bmp", "/flash/img.bmp")

# 画像のロードと描画
img = @gfx.create_image_from_file("/flash/img.bmp")
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
