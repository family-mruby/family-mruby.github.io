# API リファレンス 一覧

Family mruby が提供する Ruby 公開 API をすべて一覧します。各 API 名から詳細ページへ飛べます。

## 早見表

### アプリケーション

| クラス / モジュール | 役割 | 詳細 |
|---|---|---|
| `FmrbApp` | アプリ基底クラス。ライフサイクル、ウィンドウ、メッセージング | [FmrbApp](fmrb_app.md) |
| `FmrbGfx` | 図形・テキスト描画（`@gfx`） | [FmrbGfx](fmrb_gfx.md) |
| `SpriteImage` / `SpriteInstance` / `GfxBlock` | スプライト | [Sprite](sprite.md) |
| `TileSheet` / `TileMap` | タイルマップ描画 + fmrb_map JSON 読込 | [TileMap](tilemap.md) |
| `P5` | Processing/p5.js 風の描画 DSL（`require "p5"`） | [P5](p5.md) |
| `FmrbAudio` | BGM・効果音・音声合成（`@audio`） | [FmrbAudio](audio.md) |
| Pub/Sub (`subscribe` / `publish`) | アプリ間メッセージング | [Pub/Sub](pubsub.md) |

### ファイル・データ

| クラス / モジュール | 役割 | 詳細 |
|---|---|---|
| `IO` / `File` / `Dir` | ファイル・ディレクトリ操作 | [ファイル・I/O](filesystem.md) |
| `Log` | ロギング | [ログ](log.md) |
| `JSON` | JSON のパース・生成 | [ユーティリティ](utilities.md#json) |
| `MessagePack` | バイナリシリアライズ | [ユーティリティ](utilities.md#messagepack) |
| `BMP332` | RGB332 BMP 画像のパース | [ユーティリティ](utilities.md#bmp332) |
| `RX8900` | RTC（I2C 接続）ドライバ | [ユーティリティ](utilities.md#rx8900) |

### ハードウェア・システム

| クラス / モジュール | 役割 | 詳細 |
|---|---|---|
| `GPIO` | デジタル入出力 | [周辺機器](peripherals.md#gpio) |
| `I2C` | I2C 通信 | [周辺機器](peripherals.md#i2c) |
| `RMT` | RMT（赤外線・WS2812B など） | [周辺機器](peripherals.md#rmt) |
| `FmrbConst` | システム定数（バージョン、テーマ色、PROC_ID 等） | [定数・システム情報](const.md) |
| `FmrbHw` | ピン使用状況の問い合わせ | [定数・システム情報](const.md#fmrbhw) |
| `Task` | タスク制御 | [Task / Machine](system.md#task) |
| `Machine` | システム制御（時計・遅延・リセット等） | [Task / Machine](system.md#machine) |

## メソッド横断索引

### `FmrbApp` (ライフサイクル・ウィンドウ・メッセージング)

| メソッド | 概要 |
|---|---|
| `initialize` | フレームワーク初期化（`@gfx`, `@user_area_*` 等を準備） |
| `on_create` | アプリ起動時に1回呼ばれる（初期化処理） |
| `on_update` | フレームごとに呼ばれる（戻り値=次回までの待機 ms） |
| `on_event(ev)` | キーボード／マウス／ゲームパッド／HID 受信時 |
| `on_suspend` / `on_resume` | フルスクリーンアプリへの入替時 |
| `on_destroy` | 終了時に1回呼ばれる |
| `start` / `stop` / `destroy` | 実行制御 |
| `subscribe(topic)` / `unsubscribe(topic)` / `publish(topic, data)` | Pub/Sub |
| `send_message(dest_pid, msg_type, data)` | 直接メッセージ送信 |
| `set_window_position(x, y)` | ウィンドウ位置 |
| `draw_window_frame` / `draw_scrollbar` / `scrollbar_hit` | ウィンドウ装飾 |
| `request_file_select(mode)` | ファイル選択ダイアログ |
| `request_reload` | アプリ再読み込み |
| `ev_ctrl?(ev)` / `ev_shift?(ev)` / `ev_alt?(ev)` | 修飾キー判定 |

### `FmrbGfx` (描画)

| メソッド | 概要 |
|---|---|
| `clear(color)` / `present` | クリア／フレーム反映 |
| `set_pixel(x, y, color)` | 1ピクセル描画 |
| `draw_line(x1, y1, x2, y2, color)` | 直線 |
| `draw_rect` / `fill_rect(x, y, w, h, color)` | 矩形 |
| `draw_round_rect` / `fill_round_rect(x, y, w, h, r, color)` | 角丸矩形 |
| `draw_circle` / `fill_circle(x, y, r, color)` | 円 |
| `draw_ellipse` / `fill_ellipse(x, y, rx, ry, color)` | 楕円 |
| `draw_triangle` / `fill_triangle(x0,y0,x1,y1,x2,y2,color)` | 三角形 |
| `draw_arc` / `fill_arc(x, y, r0, r1, ang0, ang1, color)` | 円弧 |
| `blend_rect(x, y, w, h, color, mode:)` | 半透明矩形 (mode: 0=ADD, 1=XOR) |
| `set_text_size(size)` | テキストサイズ (1〜4) |
| `draw_text(x, y, text, color [, bg_color])` | 文字描画 |
| `FmrbGfx.hsv_to_rgb(h, s, v)` | 色変換 |
| `FmrbGfx.rgb_to_332(r, g, b)` | 24bit→RGB332 |
| `set_output_level(0..255)` / `set_chroma_level(0..255)` | NTSC 出力調整 |

カラー定数: `BLACK 0x00 / WHITE 0xFF / RED 0xE0 / GREEN 0x1C / BLUE 0x03 / YELLOW 0xFC / CYAN 0x1F / MAGENTA 0xE3 / GRAY 0x6D`

### `SpriteImage` / `SpriteInstance` / `GfxBlock`

| クラス | 主要メソッド |
|---|---|
| `SpriteImage` | `new(gfx, w, h, trans_color, use_trans:)` / `load_bmp(path)` / `set_target` / `reset_target` / `destroy` |
| `SpriteInstance` | `new(gfx, frame_images, x, y, z_order)` / `move(x, y)` / `visible=` / `frame=` / `destroy` |
| `GfxBlock` | `new(gfx, **kwargs) { |r, **kwargs| ... }` / `draw(**kwargs)` / `destroy` |

### `FmrbAudio` (`@audio`)

| メソッド | 概要 |
|---|---|
| `play(path, track: 0)` | ファイル再生 |
| `stop` / `pause` / `resume` | 再生制御 |
| `load_fmsq(slot_id, binary)` | FMSQ をスロットに読込 |
| `play_slot(slot_id)` | スロット再生 |
| `note_on(channel, freq, volume=10, duty=2, sweep=0)` | 音声合成 |
| `note_off(channel)` | 停止 |

### Pub/Sub

`subscribe(topic)` / `unsubscribe(topic)` / `publish(topic, data=nil)` / `send_message(dest_pid, msg_type, data)`

メッセージは `on_event` ではなく **`_handle_system_control(msg)` から `on_control(msg)` 経由** で受信。詳細は [Pub/Sub](pubsub.md) 参照。

### `IO` / `File` / `Dir`

`File.open(path, mode, &block)`、`File.exist?` / `file?` / `directory?` / `size` / `delete`、`Dir.open(path)` / `Dir.read` / `Dir.mkdir` 等。

### `Log`

`Log.error(msg)` / `Log.warn(msg)` / `Log.info(msg)` / `Log.debug(msg)` （または `e` / `w` / `i` / `d`、2引数版でタグ指定可）

### `GPIO` / `I2C` / `RMT`

| API | シグネチャ |
|---|---|
| `GPIO.new(pin, flags)` | `flags` = `GPIO::IN`, `GPIO::OUT`, `GPIO::PULL_UP` 等の OR |
| `I2C.new(unit:, frequency: 100_000, sda_pin:, scl_pin:, timeout: 500)` | `unit:` は `"ESP32_I2C0"` など |
| `RMT.new(pin, t0h_ns:, t0l_ns:, t1h_ns:, t1l_ns:, reset_ns:)` | NRZ 符号化タイミング |

### `FmrbConst` / `FmrbHw`

主要定数: `PLATFORM`、`PROC_ID_KERNEL` 等、`MSG_TYPE_*`、`OS_VERSION`、`MAC_ADDRESS`、`THEME_*`。
`FmrbHw.pin_status(pin)` / `pin_available?(pin)` / `pin_status_all` / `pin_count`。

### `Task` / `Machine`

`Task.pass`、`Machine.delay_ms(ms)`、`Machine.uptime_us`、`Machine.set_hwclock(epoch)`、`Machine._reboot`。

!!! warning
    `sleep` (Kernel) は `_spin` 外で tick が進まず止まることがあります。短時間の待機は **`Machine.delay_ms`** を使ってください（[制約事項](../limitations.md) 参照）。

## 主要インスタンス変数（`FmrbApp` 継承時）

| 変数 | 内容 |
|---|---|
| `@gfx` | `FmrbGfx` インスタンス（headless 時は `nil`） |
| `@bg_gfx` | デスクトップ背景キャンバス用（通常 `nil`） |
| `@audio` | `FmrbAudio` インスタンス |
| `@name` | アプリ表示名（`.toml` の `app_screen_name`） |
| `@platform` | `:esp32` / `:linux` |
| `@fullscreen` | フルスクリーンモード判定 |
| `@window_width` / `@window_height` | ウィンドウ全体のサイズ |
| `@pos_x` / `@pos_y` | ウィンドウ左上座標 |
| `@user_area_x0` / `@user_area_y0` / `@user_area_x1` / `@user_area_y1` | アプリ描画可能領域の境界 |
| `@user_area_width` / `@user_area_height` | 描画可能領域のサイズ |
| `@canvas` | キャンバス ID（C 内部用） |

`@user_area_*` はタイトルバーや枠線を除いた **アプリが自由に描いてよい領域** の座標。`@fullscreen` の場合は全画面が `@user_area_*`。

## 座標系・色フォーマット

- 座標系: **左上原点 (0, 0)**、X 右方向 / Y 下方向
- 色: **RGB332**（8bit, R:3 G:3 B:2）。`FmrbGfx::WHITE` などの定数か `FmrbGfx.rgb_to_332(r, g, b)` で生成

## 描画の流れ

```
描画コマンド (fill_rect 等)
  ↓ バッファに蓄積
@gfx.present
  ↓ 画面に反映
```

!!! warning "`present` を呼ばないと表示されない"
    描画系メソッドは **`@gfx.present` を呼ぶまで画面に出ません**。`SpriteInstance#move` 等のスプライト操作も `present` のタイミングで合成されます。
