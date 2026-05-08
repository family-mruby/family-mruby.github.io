# Sprite

!!! info "工事中"
    このページは整備中です。

## 概要

スプライト・タイルマップ系の API です。

| クラス | 役割 |
|---|---|
| `SpriteImage` | スプライトの元画像（ROM）を管理 |
| `SpriteInstance` | 画面上に配置されるスプライト個別インスタンス |
| `GfxBlock` | タイルマップ（背景）描画 |

## SpriteImage

`new`, `set_target`, `reset_target`, `load_bmp`, `destroy`

TODO

## SpriteInstance

`new`, `move`, `visible=`, `frame=`, `destroy`

!!! warning "`@gfx.present` を忘れない"
    `SpriteInstance#move` などの後は `@gfx.present` を呼ぶ必要があります。`present` のタイミングで合成 (composite) が走ります。

TODO

## GfxBlock

`new`, `draw(**kwargs)`, `destroy`

TODO

## サンプル

TODO
