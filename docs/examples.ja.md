# サンプル集

`flash/app/` 以下に同梱されているアプリの紹介です。それぞれが特定の API・機能を実演しているので、まず動かしてみて、ソースを読みながら自分のアプリを作る参考にしてください。

ソースファイルの場所:
- mruby アプリ: `fmruby-core/app/<カテゴリ>/<名前>.app.rb`
- 設定: 同じディレクトリの `<名前>.app.toml`

## デモ (demo)

基本機能を見せるサンプル群です。

| アプリ | 内容 | 学べる API |
|---|---|---|
| `mruby.app.rb` | mruby の動作確認・最小サンプル | `FmrbApp`, `FmrbGfx` 基本 |
| `shapes.app.rb` | 図形描画の総合デモ（矩形・円・楕円・三角形・円弧・テキスト） | [`FmrbGfx`](api/fmrb_gfx.md) |
| `ja_text.app.rb` | 日本語テキスト描画。Default / misaki_8 / efontJA_12 / Mixed / Hybrid / Scaled を切替 | [`FmrbGfx#set_font`](api/fmrb_gfx.md#日本語テキストフォント切替) |
| `p5_test.app.rb` | Processing/p5.js 風描画ライブラリのデモ（基本図形 / アフィン変換 / ベジエ / テキスト / blend / get_pixel） | [P5](api/p5.md) |
| `i2c_kbd.app.rb` | I2C キーボード（アドレス `0x5F`）からの入力読み取り | [`I2C`](api/peripherals.md#i2c) + [Pub/Sub](api/pubsub.md) |
| `led_matrix.app.rb` | WS2812B 8x8 RGB LED 行列の制御 + 画面プレビュー | [`RMT`](api/peripherals.md#rmt), Pub/Sub |
| `pub_demo.app.rb` + `sub_demo.app.rb` | アプリ間 Pub/Sub の最小ペア | [Pub/Sub](api/pubsub.md) |
| `lua.app.lua` | Lua VM の動作確認 | – |
| `basic.app.bas` / `bounce.app.bas` | BASIC VM の動作確認 | – |

## デバッグ (debug)

`flash/app/debug/` 配下の検証用アプリ。

| アプリ | 内容 | 学べる API |
|---|---|---|
| `ntsc_color_test.app.rb` | NTSC カラーバー出力テスト | [`FmrbGfx#set_output_level`/`set_chroma_level`](api/fmrb_gfx.md#ntsc-出力調整esp32-のみ) |
| `sd_test.app.rb` | SD カードへ `/mnt/sd/sd_test.txt` を書き → 読み → 比較。Space で再実行 | [ファイル・I/O ▸ ファイル名前空間](api/filesystem.md#ファイル名前空間) |

## ゲーム (game)

| アプリ | 内容 | 学べる API |
|---|---|---|
| `flappy.rb` | Flappy Bird 風ゲーム。タップで上昇、障害物を避ける | `FmrbGfx`, [`FmrbAudio` (note_on/off)](api/audio.md), ゲームパッド |
| `tetris.app.rb` | テトリス風落ちものパズル。矢印キー操作 | `FmrbGfx`, ボード描画パターン |
| `shooter.app.rb` | フルスクリーンシューティング | [`Sprite`](api/sprite.md), 当たり判定 |
| `raycaster.app.rb` | Wolfenstein 3D 風の擬似 3D。`large_memory = 1` を指定 | 固定小数点演算、`FmrbGfx` 高速描画 |
| `piano.app.rb` | キーボードで弾けるピアノ | [`FmrbAudio#note_on/off`](api/audio.md#音声合成-note_on--note_off) |

## ツール (tool)

| アプリ | 内容 | 学べる API |
|---|---|---|
| `gpio_viewer.app.rb` | 全 GPIO ピンの使用状態を可視化 | [`FmrbHw.pin_status`](api/const.md#fmrbhw) |
| `nsf_player.app.rb` | NSF ファイルの再生 GUI（曲送り、トラック選択、一時停止） | [`FmrbAudio#play`](api/audio.md), ファイル選択 |
| `picorabbit.app.rb` | Markdown 形式のスライド再生 | `PicoRabbit` |
| `sprite_editor.app.rb` | スプライトエディタ。ドット絵を描いて BMP に保存 | [`Sprite`](api/sprite.md), `BMP332` |

## 学習に最適な順番

1. **`mruby.app.rb`** を読んで基本構造を把握
2. **`shapes.app.rb`** で `FmrbGfx` の使い方を確認
3. **`pub_demo.app.rb` / `sub_demo.app.rb`** でアプリ間メッセージング
4. **`piano.app.rb`** で音声 API
5. **`flappy.rb`** で「描画 + 音 + 入力」の組み合わせ
6. **`tetris.app.rb`** で状態を持つゲーム
7. **`raycaster.app.rb`** で大規模アプリの構成と最適化

## 自分のアプリを書きたいときの起点

- 最小限から始めるなら `mruby.app.rb`
- ウィンドウ + 描画なら `shapes.app.rb`
- ゲームを作りたいなら `tetris.app.rb` または `flappy.rb`
- ハードウェアを触りたいなら `i2c_kbd.app.rb` または `led_matrix.app.rb`

新規アプリの始め方は [Hello World](getting_started/hello_world.md) を参照してください。

## 関連

- アプリの作り方 → [Hello World](getting_started/hello_world.md)
- アイコンファイル → [画像・アイコンファイル](file_formats/image_formats.md#アイコンファイル)
- アプリ設定 → [アプリ設定ファイル (.toml)](file_formats/app_toml.md)
