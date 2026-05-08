# サンプル集

!!! info "工事中"
    このページは整備中です。

`flash/app/` 以下に同梱されているアプリの紹介です。各サンプルから学べる主要 API も記載予定。

## デモ (demo)

| アプリ | 内容 | 学べる API |
|---|---|---|
| `mruby.app.rb` | mruby の動作確認 | TODO |
| `shapes.app.rb` | 図形描画 | `FmrbGfx` |
| `i2c_kbd.app.rb` | I2C キーボード入力 | `I2C`, Pub/Sub |
| `led_matrix.app.rb` | LED マトリクス制御 | `RMT` |
| `pub_demo.app.rb` / `sub_demo.app.rb` | Pub/Sub のデモ | Pub/Sub |
| `lua.app.lua` | Lua の動作確認 | – |
| `basic.app.bas` / `bounce.app.bas` | BASIC の動作確認 | – |

TODO

## ゲーム (game)

| アプリ | 内容 | 学べる API |
|---|---|---|
| `flappy.rb` | Flappy Bird 風 | `FmrbGfx`, `FmrbAudio`, ゲームパッド |
| `tetris.app.rb` | テトリス風 | TODO |
| `shooter.app.rb` | シューティング | `Sprite` |
| `raycaster.app.rb` | 疑似 3D | `FmrbGfx` |
| `piano.app.rb` | ピアノ | `FmrbAudio.note_on/off` |

TODO

## ツール (tool)

| アプリ | 内容 | 学べる API |
|---|---|---|
| `gpio_viewer.app.rb` | GPIO 状態の可視化 | `FmrbHw.pin_status` |
| `nsf_player.app.rb` | NSF ファイル再生 | `FmrbAudio` |
| `picorabbit.app.rb` | スライド再生 | `PicoRabbit` |
| `sprite_editor.app.rb` | スプライトエディタ | `Sprite`, `BMP332` |

TODO
