# FmrbGfx

!!! info "工事中"
    このページは整備中です。

## 概要

`FmrbGfx` は描画用 API を提供するクラスです。`FmrbApp` 内では `@gfx` として参照できます。

!!! note "重要"
    描画コマンドはバッファに蓄積され、`@gfx.present` を呼んだタイミングでまとめて画面に反映されます。

## 図形描画

| メソッド | 用途 |
|---|---|
| `clear` | 画面クリア |
| `present` | バッファを画面に反映 |
| `fill_rect` / `draw_rect` | 矩形（塗りつぶし／枠） |
| `fill_round_rect` / `draw_round_rect` | 角丸矩形 |
| `draw_line` | 直線 |
| `fill_circle` / `draw_circle` | 円 |
| `fill_ellipse` / `draw_ellipse` | 楕円 |
| `fill_triangle` / `draw_triangle` | 三角形 |
| `fill_arc` / `draw_arc` | 円弧 |
| `blend_rect` | 半透明矩形 |

TODO

## テキスト描画

`draw_text`, `set_text_size`

TODO

## 画像転送

`transfer_file`, `create_image`, `draw_image`, `load_image`, `delete_image`, `file_status`

TODO

## サンプル

TODO
