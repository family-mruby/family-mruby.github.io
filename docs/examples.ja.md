# サンプル集

`/app` 以下に同梱されているアプリの紹介です。それぞれが API の特定の部分を使っているので、
まず動かしてみて、自分のアプリを書くときにソースを読んでください。

ソースの場所:

- 実機上: `/app/<カテゴリ>/<名前>.app.rb`
- リポジトリ: `fmruby-core/flash/app/<カテゴリ>/<名前>.app.rb`
- 設定: 同じ場所の `<名前>.app.toml`

言語を問わない全体の一覧は [標準アプリ](getting_started/default_apps.md) にあります。

## Ruby のデモ — `/app/demo`

| アプリ | 見どころ | API |
|---|---|---|
| `picoruby.app.rb` | 枠組みが持つ描画・フォント・スプライト・音・P5 を 1 ページずつ全部。最初に読むもの | [`FmrbGfx`](api/fmrb_gfx.md)、[スプライト](api/sprite.md)、[P5](api/p5.md)、[`FmrbAudio`](api/audio.md)、[`FmrbUI`](api/ui.md) |
| `kamon.app.rb` | 5 つの部品から家紋を作ります。組み合わせは部品のパネルで選びます | [`FmrbUI`](api/ui.md)、`FmrbGfx` |
| `piano.app.rb` | 1 オクターブをキーボードで弾きます。チャンネルとスイープはパネルで | [`FmrbAudio#note_on` / `note_off`](api/audio.md#音声合成-note_on--note_off) |
| `mml.app.rb` | 同じ曲を内蔵音源か外部音源で。MML のテキストをファイルから読みます | [MIDI](api/midi.md)、MML |
| `midi_apu.app.rb` | 内蔵音源を MIDI 層から鳴らします | [MIDI](api/midi.md) |
| `weather.app.rb` | HTTPS で予報を取って描きます。ネットワーク API の一通り | [ネットワーク](api/network.md) |
| `pub_demo.app.rb` + `sub_demo.app.rb` | 送る側と受ける側の最小の組。2 つ一緒に動かします | [Pub/Sub](api/pubsub.md) |
| `stackchan.app.rb` + `stackchan_remote.app.rb` | 表情を持つ顔と、それを別のアプリから動かす側 | `FmrbGfx`、[Pub/Sub](api/pubsub.md) |
| `led_matrix.app.rb` | GROVE 端子の WS2812B 8x8 行列。画面にも同じものを出します | [`RMT`](api/peripherals.md#rmt) |
| `i2c_kbd.app.rb` | アドレス `0x5F` の I2C キーボード | [`I2C`](api/peripherals.md#i2c)、[Pub/Sub](api/pubsub.md) |

## Python — `/app/python`

| アプリ | 見どころ |
|---|---|
| `python.app.py` | `picoruby.app.rb` の双子。ページも同じで、MicroPython で書かれています |
| `pybench.app.py` | Python のアプリが 1 フレームで何をこなせるか。ゲームの書き方を決める 3 つのコスト |

## ゲーム — `/app/game`

| アプリ | 見どころ | API |
|---|---|---|
| `flappy.rb` | ボタン 1 つ。背景つきで、効果音は音源から | `FmrbGfx`、[`FmrbAudio`](api/audio.md)、ゲームパッド |
| `tetris.app.rb` | 状態を持つゲーム。BGM と効果音つき。矢印キーと `Space` | `FmrbGfx`、[`FmrbAudio`](api/audio.md) |
| `shooter.app.rb` | スプライト、急降下する編隊、面の間のボス | [スプライト](api/sprite.md)、当たり判定 |
| `rpg_demo/` | 滑らかにスクロールするタイルの世界。当たり判定、BGM、効果音。素材はアプリ自身のディレクトリに置いてあります | [タイルマップ](api/tilemap.md)、`FmrbApp.set_cursor_visible` |
| `raycaster.app.rb` | 疑似 3D の一人称視点。`large_memory = 1` が要ります | 固定小数点、速い `FmrbGfx` |
| `robo_explorer/` | 直接は遊べない迷路。ロボットは配信された命令にだけ従います。操縦は別のアプリで、あなたが書くのは `my_pilot.rb` です | [Pub/Sub](api/pubsub.md) |
| `breakout/breakout.app.py` | Python のサンプルゲーム。スプライト、タイル、日本語、主音源の曲と副音源の効果音 | Python の枠組み |

## 道具 — `/app/tool`

| アプリ | 見どころ | API |
|---|---|---|
| `picorabbit.app.rb` | Markdown の資料を全画面で発表し、1 枚ずつ画像に書き出します | `FmrbGfx#export_frame`、[スプライト](api/sprite.md) |
| `nsf_player.app.rb` | NSF の再生。曲の選択と、部品で作った操作パネル | [`FmrbAudio#play`](api/audio.md)、[`FmrbUI`](api/ui.md) |
| `smf_player.app.rb` | 標準 MIDI ファイルを内蔵音源か外部音源で | [MIDI](api/midi.md)、[`FmrbUI`](api/ui.md) |
| `sprite_editor.app.rb` | 16x16 の RGB332 タイル表。BMP を読み、点を打ち、書き戻します | [スプライト](api/sprite.md)、`BMP332` |
| `gpio_viewer.app.rb` | 全 GPIO を、何が使っているかで色分けして表示します | [`FmrbHw.pin_status`](api/const.md#fmrbhw) |

## Modern 専用 — `/app/modern`

| アプリ | 見どころ | API |
|---|---|---|
| `mic_spectrum.app.rb` | マイクの標本化も変換も描画も、全部この機械の上で | `Fmrb::Fft`、[`FmrbAudio`](api/audio.md#マイク-modern-のみ) |
| `video_play.app.rb` | Motion JPEG を窓の中で再生します | [`FmrbGfx#video_open`](api/fmrb_gfx.md#動画-modern-のみ) |
| `imu.app.rb` | 6 軸センサを水準器として表示します | [`I2C`](api/peripherals.md#i2c) |

`/app/debug` と `/app/test` も入っていますが、わざと壊すためのもので、ランチャーにも
出ません。写して使うサンプルではありません。

## 関連

- [Hello World](getting_started/hello_world.md) — 新しいアプリを始める
- [アプリ設定ファイル (.app.toml)](file_formats/app_toml.md)
- [画像・アイコンファイル](file_formats/image_formats.md#アイコンファイル-icon)
