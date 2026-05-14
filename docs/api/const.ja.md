# 定数・システム情報 (FmrbConst / FmrbHw)

## FmrbConst

システム全体で参照される定数を提供するモジュールです。

### プラットフォーム情報

| 定数 | 値 |
|---|---|
| `FmrbConst::PLATFORM` | `"linux"` または `"esp32"` |
| `FmrbConst::OS_VERSION` | OS バージョン文字列 |
| `FmrbConst::GA_VERSION` | fmruby-graphics-audio 側のバージョン |
| `FmrbConst::LINK_VERSION` | UART リンクプロトコルバージョン |
| `FmrbConst::IDF_VERSION` | ESP-IDF のバージョン |

### ハードウェア情報

| 定数 | 内容 |
|---|---|
| `FmrbConst::MAC_ADDRESS` | MAC アドレス文字列 |
| `FmrbConst::CHIP_MODEL` | 例: `"ESP32-S3"` |
| `FmrbConst::CHIP_REVISION` | リビジョン番号 |
| `FmrbConst::CHIP_CORES` | コア数 |
| `FmrbConst::FLASH_SIZE_MB` | フラッシュ容量 (MB) |
| `FmrbConst::PSRAM_SIZE_MB` | PSRAM 容量 (MB) |
| `FmrbConst::RESET_REASON` | 直前のリセット理由 |

### プロセス管理

| 定数 | 用途 |
|---|---|
| `FmrbConst::PROC_ID_KERNEL` | カーネルプロセス ID |
| `FmrbConst::PROC_ID_HOST` | ホストプロセス ID |
| `FmrbConst::PROC_ID_SYSTEM_APP` | システムアプリ ID |
| `FmrbConst::PROC_ID_USER_APP0` / `USER_APP1` / `USER_APP2` | ユーザーアプリスロット |

#### プロセス状態

| 定数 |
|---|
| `PROC_STATE_FREE` |
| `PROC_STATE_INIT` |
| `PROC_STATE_RUNNING` |
| `PROC_STATE_SUSPENDED` |
| `PROC_STATE_STOPPING` |

### メッセージング

| 定数 | 用途 |
|---|---|
| `MSG_TYPE_APP_CONTROL` | アプリ制御メッセージ |
| `MSG_TYPE_APP_GFX` | グラフィックメッセージ |
| `MSG_TYPE_APP_AUDIO` | オーディオメッセージ |
| `MSG_TYPE_HID_EVENT` | HID イベント（キーボード等） |

#### アプリ制御コマンド

| 定数 |
|---|
| `APP_CTRL_SPAWN` |
| `APP_CTRL_KILL` |
| `APP_CTRL_SUSPEND` |
| `APP_CTRL_RESUME` |

### テーマ色（システム共通の配色）

| 定数 | 用途 |
|---|---|
| `THEME_DESKTOP_BG` | デスクトップ背景 |
| `THEME_MENU_BG` | メニュー背景 |
| `THEME_WINDOW_BG` | ウィンドウ背景 |
| `THEME_TEXT` | 通常テキスト |
| `THEME_TEXT_LIGHT` | 薄テキスト |
| `THEME_HIGHLIGHT` | 強調 |
| `THEME_BORDER` | 枠線 |
| `THEME_BUTTON` | ボタン |

これらはすべて RGB332 値です。アプリの UI を OS の配色に合わせたい場合に使います。

### 入力デバイス: キーボード (`KEY_*`)

USB HID Usage ID。`on_event(ev)` の `ev[:scancode]` と比較します。

| カテゴリ | 定数 |
|---|---|
| 英字 | `KEY_A` .. `KEY_Z` |
| 数字 | `KEY_1` .. `KEY_9`, `KEY_0` |
| 制御 | `KEY_ENTER`, `KEY_ESC`, `KEY_BACKSPACE`, `KEY_TAB`, `KEY_SPACE` |
| 記号 | `KEY_MINUS`, `KEY_EQUAL`, `KEY_LBRACKET`, `KEY_RBRACKET`, `KEY_BACKSLASH`, `KEY_SEMICOLON`, `KEY_QUOTE`, `KEY_GRAVE`, `KEY_COMMA`, `KEY_PERIOD`, `KEY_SLASH` |
| ロック | `KEY_CAPSLOCK`, `KEY_SCROLLLOCK`, `KEY_NUMLOCK` |
| ファンクション | `KEY_F1` .. `KEY_F12` |
| 編集 | `KEY_INSERT`, `KEY_HOME`, `KEY_PGUP`, `KEY_DELETE`, `KEY_END`, `KEY_PGDN` |
| 矢印 | `KEY_LEFT`, `KEY_RIGHT`, `KEY_UP`, `KEY_DOWN` |
| その他 | `KEY_PRINTSCREEN`, `KEY_PAUSE` |
| 修飾キー（個別） | `KEY_LCTRL`, `KEY_LSHIFT`, `KEY_LALT`, `KEY_LGUI`, `KEY_RCTRL`, `KEY_RSHIFT`, `KEY_RALT`, `KEY_RGUI` |

### 入力デバイス: 修飾キーマスク (`MOD_*`)

`on_event(ev)` の `ev[:modifier]` と AND を取って判定します。

| 定数 | ビット | 意味 |
|---|---|---|
| `MOD_LCTRL` | 0x01 | 左 Ctrl |
| `MOD_LSHIFT` | 0x02 | 左 Shift |
| `MOD_LALT` | 0x04 | 左 Alt |
| `MOD_LGUI` | 0x08 | 左 GUI (Win / Cmd) |
| `MOD_RCTRL` | 0x10 | 右 Ctrl |
| `MOD_RSHIFT` | 0x20 | 右 Shift |
| `MOD_RALT` | 0x40 | 右 Alt |
| `MOD_RGUI` | 0x80 | 右 GUI |
| `MOD_CTRL` | 0x11 | 左右 Ctrl 合成 (`MOD_LCTRL | MOD_RCTRL`) |
| `MOD_SHIFT` | 0x22 | 左右 Shift 合成 |
| `MOD_ALT` | 0x44 | 左右 Alt 合成 |
| `MOD_GUI` | 0x88 | 左右 GUI 合成 |

!!! tip "`ev_ctrl?(ev)` / `ev_shift?(ev)` / `ev_alt?(ev)`"
    `FmrbApp` のヘルパでも判定できます。MOD_* を直接使うのは特殊なケースだけで、通常はこちらを使ってください。

### 入力デバイス: ゲームパッド (`GP_*`)

`on_event(ev)` で `ev[:type] == :gamepad_down` / `:gamepad_up` のとき `ev[:button]` がボタン番号、`:gamepad_axis` のとき `ev[:axis]` が軸番号です。

#### ボタン

| 定数 | 値 | 意味 |
|---|---|---|
| `GP_SQUARE` | 0 | □ |
| `GP_CROSS` | 1 | × |
| `GP_CIRCLE` | 2 | ○ |
| `GP_TRIANGLE` | 3 | △ |
| `GP_L1` | 4 | 左ショルダー |
| `GP_R1` | 5 | 右ショルダー |
| `GP_L2` | 6 | 左トリガー |
| `GP_R2` | 7 | 右トリガー |
| `GP_SELECT` | 8 | Select |
| `GP_START` | 9 | Start |
| `GP_L3` | 10 | 左スティック押し込み |
| `GP_R3` | 11 | 右スティック押し込み |
| `GP_UP` | 12 | 十字キー上 |
| `GP_DOWN` | 13 | 十字キー下 |
| `GP_LEFT` | 14 | 十字キー左 |
| `GP_RIGHT` | 15 | 十字キー右 |

#### 軸

| 定数 | 値 | 意味 |
|---|---|---|
| `GP_AXIS_LX` | 0 | 左スティック X |
| `GP_AXIS_LY` | 1 | 左スティック Y |
| `GP_AXIS_RX` | 2 | 右スティック X |
| `GP_AXIS_RY` | 3 | 右スティック Y |

### サンプル: キー判定

```ruby
def on_event(ev)
  super
  if ev[:type] == :key_down
    case ev[:scancode]
    when FmrbConst::KEY_LEFT  then @x -= 4
    when FmrbConst::KEY_RIGHT then @x += 4
    when FmrbConst::KEY_SPACE then shoot
    when FmrbConst::KEY_ESC   then stop
    end
    if (ev[:modifier] || 0) & FmrbConst::MOD_CTRL != 0 &&
       ev[:scancode] == FmrbConst::KEY_S
      save_state
    end
  elsif ev[:type] == :gamepad_down
    case ev[:button]
    when FmrbConst::GP_CROSS  then jump
    when FmrbConst::GP_START  then pause
    end
  end
end
```

### その他

| 定数 | 内容 |
|---|---|
| `MAX_PATH_LEN` | パスの最大長 |

### サンプル: バージョンと環境を表示

```ruby
class SysInfo < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    x = @user_area_x0 + 4
    y = @user_area_y0 + 4
    @gfx.draw_text(x, y,      "OS: #{FmrbConst::OS_VERSION}", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 10, "Chip: #{FmrbConst::CHIP_MODEL}", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 20, "PSRAM: #{FmrbConst::PSRAM_SIZE_MB}MB", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 30, "MAC: #{FmrbConst::MAC_ADDRESS}", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

SysInfo.new.start
```

## FmrbHw

ハードウェアリソース（特に GPIO ピン）の使用状況を問い合わせるモジュールです。

| メソッド | 戻り値 |
|---|---|
| `FmrbHw.pin_status(pin)` | ピンの使用状態（`Integer`、0=未使用、その他=用途別の識別子） |
| `FmrbHw.pin_available?(pin)` | 未使用なら `true` |
| `FmrbHw.pin_status_all` | `Array<Integer>`（インデックス=ピン番号、値=状態） |
| `FmrbHw.pin_count` | ピン総数 |

`pin_status` の値は内部識別子で、0 = 未使用、それ以外 = 「GPIO」「I2C」「UART」など別機能で使用中、を意味します。

### サンプル: 全ピンを表示

```ruby
status = FmrbHw.pin_status_all
status.each_with_index do |s, i|
  Log.info("pin #{i}: #{s == 0 ? 'free' : 'used'}")
end
```

### サンプル: 使う前にチェック

```ruby
PIN = 10
unless FmrbHw.pin_available?(PIN)
  Log.error("Pin #{PIN} is in use (status=#{FmrbHw.pin_status(PIN)})")
  return
end
gpio = GPIO.new(PIN, GPIO::OUT)
```

`tool/gpio_viewer.app.rb` に GUI でピン状態を可視化するサンプルがあります。

## 関連

- ピン仕様（電気的特性、外部接続）は [ハードウェア](../hardware.md) を参照
- GPIO の使い方は [周辺機器](peripherals.md#gpio) を参照
