# FmrbConst

端末・ビルド・キー・テーマの定数の入れもの

使い方は [定数・システム情報](../const.md) のページにあります。

値は VM を起こすときに決まり、アプリが走っている間は変わらない。
**機種やビルドで値が変わるもの** (`BOARD`・`PLATFORM`・`HW_FAMILY`・`CHIP_*`・
`FLASH_SIZE_MB` ほか) は、各定数の説明に書いた。

キーの番号 (`KEY_*`) は USB HID の Usage ID。イベントの `ev[:scancode]` と比べると、機種によらず同じ値で判定できる。`ev[:keycode]` は文字キーだと機種で値が違う (SDL では ASCII)。
```ruby
if ev[:scancode] == FmrbConst::KEY_ESC
  stop
end
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`KEY_A`</span> | [`Integer`](Integer.md) | A キー (HID 0x04) |
| <span class="fmrb-name">`KEY_B`</span> | [`Integer`](Integer.md) | B キー (HID 0x05) |
| <span class="fmrb-name">`KEY_C`</span> | [`Integer`](Integer.md) | C キー (HID 0x06) |
| <span class="fmrb-name">`KEY_D`</span> | [`Integer`](Integer.md) | D キー (HID 0x07) |
| <span class="fmrb-name">`KEY_E`</span> | [`Integer`](Integer.md) | E キー (HID 0x08) |
| <span class="fmrb-name">`KEY_F`</span> | [`Integer`](Integer.md) | F キー (HID 0x09) |
| <span class="fmrb-name">`KEY_G`</span> | [`Integer`](Integer.md) | G キー (HID 0x0A) |
| <span class="fmrb-name">`KEY_H`</span> | [`Integer`](Integer.md) | H キー (HID 0x0B) |
| <span class="fmrb-name">`KEY_I`</span> | [`Integer`](Integer.md) | I キー (HID 0x0C) |
| <span class="fmrb-name">`KEY_J`</span> | [`Integer`](Integer.md) | J キー (HID 0x0D) |
| <span class="fmrb-name">`KEY_K`</span> | [`Integer`](Integer.md) | K キー (HID 0x0E) |
| <span class="fmrb-name">`KEY_L`</span> | [`Integer`](Integer.md) | L キー (HID 0x0F) |
| <span class="fmrb-name">`KEY_M`</span> | [`Integer`](Integer.md) | M キー (HID 0x10) |
| <span class="fmrb-name">`KEY_N`</span> | [`Integer`](Integer.md) | N キー (HID 0x11) |
| <span class="fmrb-name">`KEY_O`</span> | [`Integer`](Integer.md) | O キー (HID 0x12) |
| <span class="fmrb-name">`KEY_P`</span> | [`Integer`](Integer.md) | P キー (HID 0x13) |
| <span class="fmrb-name">`KEY_Q`</span> | [`Integer`](Integer.md) | Q キー (HID 0x14) |
| <span class="fmrb-name">`KEY_R`</span> | [`Integer`](Integer.md) | R キー (HID 0x15) |
| <span class="fmrb-name">`KEY_S`</span> | [`Integer`](Integer.md) | S キー (HID 0x16) |
| <span class="fmrb-name">`KEY_T`</span> | [`Integer`](Integer.md) | T キー (HID 0x17) |
| <span class="fmrb-name">`KEY_U`</span> | [`Integer`](Integer.md) | U キー (HID 0x18) |
| <span class="fmrb-name">`KEY_V`</span> | [`Integer`](Integer.md) | V キー (HID 0x19) |
| <span class="fmrb-name">`KEY_W`</span> | [`Integer`](Integer.md) | W キー (HID 0x1A) |
| <span class="fmrb-name">`KEY_X`</span> | [`Integer`](Integer.md) | X キー (HID 0x1B) |
| <span class="fmrb-name">`KEY_Y`</span> | [`Integer`](Integer.md) | Y キー (HID 0x1C) |
| <span class="fmrb-name">`KEY_Z`</span> | [`Integer`](Integer.md) | Z キー (HID 0x1D) |
| <span class="fmrb-name">`KEY_1`</span> | [`Integer`](Integer.md) | 1 キー (上の数字の列) (HID 0x1E) |
| <span class="fmrb-name">`KEY_2`</span> | [`Integer`](Integer.md) | 2 キー (上の数字の列) (HID 0x1F) |
| <span class="fmrb-name">`KEY_3`</span> | [`Integer`](Integer.md) | 3 キー (上の数字の列) (HID 0x20) |
| <span class="fmrb-name">`KEY_4`</span> | [`Integer`](Integer.md) | 4 キー (上の数字の列) (HID 0x21) |
| <span class="fmrb-name">`KEY_5`</span> | [`Integer`](Integer.md) | 5 キー (上の数字の列) (HID 0x22) |
| <span class="fmrb-name">`KEY_6`</span> | [`Integer`](Integer.md) | 6 キー (上の数字の列) (HID 0x23) |
| <span class="fmrb-name">`KEY_7`</span> | [`Integer`](Integer.md) | 7 キー (上の数字の列) (HID 0x24) |
| <span class="fmrb-name">`KEY_8`</span> | [`Integer`](Integer.md) | 8 キー (上の数字の列) (HID 0x25) |
| <span class="fmrb-name">`KEY_9`</span> | [`Integer`](Integer.md) | 9 キー (上の数字の列) (HID 0x26) |
| <span class="fmrb-name">`KEY_0`</span> | [`Integer`](Integer.md) | 0 キー (上の数字の列) (HID 0x27) |
| <span class="fmrb-name">`KEY_ENTER`</span> | [`Integer`](Integer.md) | Enter (HID 0x28) |
| <span class="fmrb-name">`KEY_ESC`</span> | [`Integer`](Integer.md) | Esc (HID 0x29) |
| <span class="fmrb-name">`KEY_BACKSPACE`</span> | [`Integer`](Integer.md) | BackSpace (HID 0x2A) |
| <span class="fmrb-name">`KEY_TAB`</span> | [`Integer`](Integer.md) | Tab (HID 0x2B) |
| <span class="fmrb-name">`KEY_SPACE`</span> | [`Integer`](Integer.md) | スペース (HID 0x2C) |
| <span class="fmrb-name">`KEY_MINUS`</span> | [`Integer`](Integer.md) | - キー (HID 0x2D) |
| <span class="fmrb-name">`KEY_EQUAL`</span> | [`Integer`](Integer.md) | = キー (US 配列の名前) (HID 0x2E) |
| <span class="fmrb-name">`KEY_LBRACKET`</span> | [`Integer`](Integer.md) | [ キー (US 配列の名前) (HID 0x2F) |
| <span class="fmrb-name">`KEY_RBRACKET`</span> | [`Integer`](Integer.md) | ] キー (US 配列の名前) (HID 0x30) |
| <span class="fmrb-name">`KEY_BACKSLASH`</span> | [`Integer`](Integer.md) | \ キー (US 配列の名前) (HID 0x31) |
| <span class="fmrb-name">`KEY_SEMICOLON`</span> | [`Integer`](Integer.md) | ; キー (US 配列の名前) (HID 0x33) |
| <span class="fmrb-name">`KEY_QUOTE`</span> | [`Integer`](Integer.md) | ' キー (US 配列の名前) (HID 0x34) |
| <span class="fmrb-name">`KEY_GRAVE`</span> | [`Integer`](Integer.md) | ` キー (US 配列の名前) (HID 0x35) |
| <span class="fmrb-name">`KEY_COMMA`</span> | [`Integer`](Integer.md) | , キー (HID 0x36) |
| <span class="fmrb-name">`KEY_PERIOD`</span> | [`Integer`](Integer.md) | . キー (HID 0x37) |
| <span class="fmrb-name">`KEY_SLASH`</span> | [`Integer`](Integer.md) | / キー (HID 0x38) |
| <span class="fmrb-name">`KEY_CAPSLOCK`</span> | [`Integer`](Integer.md) | CapsLock (HID 0x39) |
| <span class="fmrb-name">`KEY_F1`</span> | [`Integer`](Integer.md) | F1 キー (HID 0x3A) |
| <span class="fmrb-name">`KEY_F2`</span> | [`Integer`](Integer.md) | F2 キー (HID 0x3B) |
| <span class="fmrb-name">`KEY_F3`</span> | [`Integer`](Integer.md) | F3 キー (HID 0x3C) |
| <span class="fmrb-name">`KEY_F4`</span> | [`Integer`](Integer.md) | F4 キー (HID 0x3D) |
| <span class="fmrb-name">`KEY_F5`</span> | [`Integer`](Integer.md) | F5 キー (HID 0x3E) |
| <span class="fmrb-name">`KEY_F6`</span> | [`Integer`](Integer.md) | F6 キー (HID 0x3F) |
| <span class="fmrb-name">`KEY_F7`</span> | [`Integer`](Integer.md) | F7 キー (HID 0x40) |
| <span class="fmrb-name">`KEY_F8`</span> | [`Integer`](Integer.md) | F8 キー (HID 0x41) |
| <span class="fmrb-name">`KEY_F9`</span> | [`Integer`](Integer.md) | F9 キー (HID 0x42) |
| <span class="fmrb-name">`KEY_F10`</span> | [`Integer`](Integer.md) | F10 キー (HID 0x43) |
| <span class="fmrb-name">`KEY_F11`</span> | [`Integer`](Integer.md) | F11 キー (HID 0x44) |
| <span class="fmrb-name">`KEY_F12`</span> | [`Integer`](Integer.md) | F12 キー (HID 0x45) |
| <span class="fmrb-name">`KEY_PRINTSCREEN`</span> | [`Integer`](Integer.md) | PrintScreen (HID 0x46) |
| <span class="fmrb-name">`KEY_SCROLLLOCK`</span> | [`Integer`](Integer.md) | ScrollLock (HID 0x47) |
| <span class="fmrb-name">`KEY_PAUSE`</span> | [`Integer`](Integer.md) | Pause (HID 0x48) |
| <span class="fmrb-name">`KEY_INSERT`</span> | [`Integer`](Integer.md) | Insert (HID 0x49) |
| <span class="fmrb-name">`KEY_HOME`</span> | [`Integer`](Integer.md) | Home (HID 0x4A) |
| <span class="fmrb-name">`KEY_PGUP`</span> | [`Integer`](Integer.md) | PageUp (HID 0x4B) |
| <span class="fmrb-name">`KEY_DELETE`</span> | [`Integer`](Integer.md) | Delete (HID 0x4C) |
| <span class="fmrb-name">`KEY_END`</span> | [`Integer`](Integer.md) | End (HID 0x4D) |
| <span class="fmrb-name">`KEY_PGDN`</span> | [`Integer`](Integer.md) | PageDown (HID 0x4E) |
| <span class="fmrb-name">`KEY_RIGHT`</span> | [`Integer`](Integer.md) | 右矢印 (HID 0x4F) |
| <span class="fmrb-name">`KEY_LEFT`</span> | [`Integer`](Integer.md) | 左矢印 (HID 0x50) |
| <span class="fmrb-name">`KEY_DOWN`</span> | [`Integer`](Integer.md) | 下矢印 (HID 0x51) |
| <span class="fmrb-name">`KEY_UP`</span> | [`Integer`](Integer.md) | 上矢印 (HID 0x52) |
| <span class="fmrb-name">`KEY_NUMLOCK`</span> | [`Integer`](Integer.md) | NumLock (HID 0x53) |
| <span class="fmrb-name">`KEY_LCTRL`</span> | [`Integer`](Integer.md) | 左 Ctrl (HID 0xE0) |
| <span class="fmrb-name">`KEY_LSHIFT`</span> | [`Integer`](Integer.md) | 左 Shift (HID 0xE1) |
| <span class="fmrb-name">`KEY_LALT`</span> | [`Integer`](Integer.md) | 左 Alt (HID 0xE2) |
| <span class="fmrb-name">`KEY_LMETA`</span> | [`Integer`](Integer.md) | 左 Meta (HID 0xE3) |
| <span class="fmrb-name">`KEY_RCTRL`</span> | [`Integer`](Integer.md) | 右 Ctrl (HID 0xE4) |
| <span class="fmrb-name">`KEY_RSHIFT`</span> | [`Integer`](Integer.md) | 右 Shift (HID 0xE5) |
| <span class="fmrb-name">`KEY_RALT`</span> | [`Integer`](Integer.md) | 右 Alt (HID 0xE6) |
| <span class="fmrb-name">`KEY_RMETA`</span> | [`Integer`](Integer.md) | 右 Meta (HID 0xE7) |
| <span class="fmrb-name">`MOD_LSHIFT`</span> | [`Integer`](Integer.md) | 左 Shift のマスク (0x01) |
| <span class="fmrb-name">`MOD_RSHIFT`</span> | [`Integer`](Integer.md) | 右 Shift のマスク (0x02) |
| <span class="fmrb-name">`MOD_LCTRL`</span> | [`Integer`](Integer.md) | 左 Ctrl のマスク (0x04) |
| <span class="fmrb-name">`MOD_RCTRL`</span> | [`Integer`](Integer.md) | 右 Ctrl のマスク (0x08) |
| <span class="fmrb-name">`MOD_LALT`</span> | [`Integer`](Integer.md) | 左 Alt のマスク (0x10) |
| <span class="fmrb-name">`MOD_RALT`</span> | [`Integer`](Integer.md) | 右 Alt のマスク (0x20) |
| <span class="fmrb-name">`MOD_SHIFT`</span> | [`Integer`](Integer.md) | 左右どちらかの Shift のマスク (0x03) |
| <span class="fmrb-name">`MOD_CTRL`</span> | [`Integer`](Integer.md) | 左右どちらかの Ctrl のマスク (0x0C) |
| <span class="fmrb-name">`MOD_ALT`</span> | [`Integer`](Integer.md) | 左右どちらかの Alt のマスク (0x30) |
| <span class="fmrb-name">`GP_SQUARE`</span> | [`Integer`](Integer.md) | ボタン番号 0: 四角 |
| <span class="fmrb-name">`GP_CROSS`</span> | [`Integer`](Integer.md) | ボタン番号 1: バツ |
| <span class="fmrb-name">`GP_CIRCLE`</span> | [`Integer`](Integer.md) | ボタン番号 2: 丸 |
| <span class="fmrb-name">`GP_TRIANGLE`</span> | [`Integer`](Integer.md) | ボタン番号 3: 三角 |
| <span class="fmrb-name">`GP_L1`</span> | [`Integer`](Integer.md) | ボタン番号 4: L1 |
| <span class="fmrb-name">`GP_R1`</span> | [`Integer`](Integer.md) | ボタン番号 5: R1 |
| <span class="fmrb-name">`GP_L2`</span> | [`Integer`](Integer.md) | ボタン番号 6: L2 |
| <span class="fmrb-name">`GP_R2`</span> | [`Integer`](Integer.md) | ボタン番号 7: R2 |
| <span class="fmrb-name">`GP_SELECT`</span> | [`Integer`](Integer.md) | ボタン番号 8: Select |
| <span class="fmrb-name">`GP_START`</span> | [`Integer`](Integer.md) | ボタン番号 9: Start |
| <span class="fmrb-name">`GP_L3`</span> | [`Integer`](Integer.md) | ボタン番号 10: 左スティックの押し込み |
| <span class="fmrb-name">`GP_R3`</span> | [`Integer`](Integer.md) | ボタン番号 11: 右スティックの押し込み |
| <span class="fmrb-name">`GP_UP`</span> | [`Integer`](Integer.md) | ボタン番号 12: 十字キーの上 |
| <span class="fmrb-name">`GP_DOWN`</span> | [`Integer`](Integer.md) | ボタン番号 13: 十字キーの下 |
| <span class="fmrb-name">`GP_LEFT`</span> | [`Integer`](Integer.md) | ボタン番号 14: 十字キーの左 |
| <span class="fmrb-name">`GP_RIGHT`</span> | [`Integer`](Integer.md) | ボタン番号 15: 十字キーの右 |
| <span class="fmrb-name">`GP_AXIS_LX`</span> | [`Integer`](Integer.md) | 軸番号 0: 左スティックの横 (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_LY`</span> | [`Integer`](Integer.md) | 軸番号 1: 左スティックの縦 (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_RX`</span> | [`Integer`](Integer.md) | 軸番号 2: 右スティックの横 (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_RY`</span> | [`Integer`](Integer.md) | 軸番号 3: 右スティックの縦 (ev[:axis]) |
| <span class="fmrb-name">`THEME_DESKTOP_BG`</span> | [`Integer`](Integer.md) | デスクトップの背景 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_MENU_BG`</span> | [`Integer`](Integer.md) | メニューの背景 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_WINDOW_BG`</span> | [`Integer`](Integer.md) | Window の背景 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_TEXT`</span> | [`Integer`](Integer.md) | 文字の色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_TEXT_LIGHT`</span> | [`Integer`](Integer.md) | 淡い文字の色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_HIGHLIGHT`</span> | [`Integer`](Integer.md) | 選択の強調色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_BORDER`</span> | [`Integer`](Integer.md) | 枠の色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_BUTTON`</span> | [`Integer`](Integer.md) | ボタンの色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`THEME_DIR_COLOR`</span> | [`Integer`](Integer.md) | 一覧のディレクトリ色 (RGB332。[theme] で設定) |
| <span class="fmrb-name">`WHEEL_LINES`</span> | [`Integer`](Integer.md) | ホイール 1 目盛りで進む行数 (既定 3) |
| <span class="fmrb-name">`PLATFORM`</span> | [`String`](String.md) | "esp32" か "linux" (sim 等は linux) |
| <span class="fmrb-name">`BOARD`</span> | [`String`](String.md) | 端末の名前 (機種ごとに違う) |
| <span class="fmrb-name">`NATIVE`</span> | `bool` | ネイティブ版 (Linux の 1 プロセス) なら true |
| <span class="fmrb-name">`HW_FAMILY`</span> | [`String`](String.md) | "modern"・"mini"・"retro" (sim は模した機種) |
| <span class="fmrb-name">`FONT_JA`</span> | `bool` | 日本語フォントを積んだビルドなら true |
| <span class="fmrb-name">`HAS_WIFI`</span> | `bool` | WiFi を使える端末なら true (sim も true) |
| <span class="fmrb-name">`LANGUAGE`</span> | [`String`](String.md) | 表示の言語 ("ja" か "en") |
| <span class="fmrb-name">`OS_VERSION`</span> | [`String`](String.md) | OS (core) の版の文字列 |
| <span class="fmrb-name">`GA_VERSION`</span> | [`String`](String.md) | graphics-audio の版の文字列 |
| <span class="fmrb-name">`LINK_VERSION`</span> | [`Integer`](Integer.md) | core と graphics-audio をつなぐ線の版 |
| <span class="fmrb-name">`BUILD_DATE`</span> | [`String`](String.md) | ファームを作った日時 |
| <span class="fmrb-name">`IDF_VERSION`</span> | [`String`](String.md) | ESP-IDF の版 (linux では "-") |
| <span class="fmrb-name">`MAC_ADDRESS`</span> | [`String`](String.md) | 起動時の BLE の MAC (linux では "-") |
| <span class="fmrb-name">`CHIP_MODEL`</span> | [`String`](String.md) | チップの名前 (linux では "linux") |
| <span class="fmrb-name">`CHIP_REVISION`</span> | [`String`](String.md) | チップのリビジョン ("v0.2" の形。linux では "-") |
| <span class="fmrb-name">`CHIP_CORES`</span> | [`Integer`](Integer.md) | チップのコア数 (linux では 0) |
| <span class="fmrb-name">`FLASH_SIZE_MB`</span> | [`Integer`](Integer.md) | フラッシュの大きさ MB (linux では 0) |
| <span class="fmrb-name">`PSRAM_SIZE_MB`</span> | [`Integer`](Integer.md) | PSRAM の大きさ MB (無ければ 0。linux では 0) |
| <span class="fmrb-name">`RESET_REASON`</span> | [`String`](String.md) | 直前のリセットの理由 (linux では "-") |
| <span class="fmrb-name">`PROC_ID_KERNEL`</span> | [`Integer`](Integer.md) | Kernel のプロセス番号 (0) |
| <span class="fmrb-name">`PROC_ID_HOST`</span> | [`Integer`](Integer.md) | Host のプロセス番号 (1) |
| <span class="fmrb-name">`PROC_ID_SYSTEM_APP`</span> | [`Integer`](Integer.md) | システムアプリのプロセス番号 (2) |
| <span class="fmrb-name">`PROC_ID_USER_APP0`</span> | [`Integer`](Integer.md) | ユーザアプリの枠 0 のプロセス番号 (4) |
| <span class="fmrb-name">`PROC_ID_USER_APP1`</span> | [`Integer`](Integer.md) | ユーザアプリの枠 1 のプロセス番号 (5) |
| <span class="fmrb-name">`PROC_ID_USER_APP2`</span> | [`Integer`](Integer.md) | ユーザアプリの枠 2 のプロセス番号 (6) |
| <span class="fmrb-name">`PROC_ID_USER_APP3`</span> | [`Integer`](Integer.md) | ユーザアプリの枠 3 のプロセス番号 (7) |
| <span class="fmrb-name">`PROC_ID_USER_APP4`</span> | [`Integer`](Integer.md) | ユーザアプリの枠 4 のプロセス番号 (8) |
| <span class="fmrb-name">`PROC_STATE_FREE`</span> | [`Integer`](Integer.md) | アプリの状態: 空き (0) |
| <span class="fmrb-name">`PROC_STATE_INIT`</span> | [`Integer`](Integer.md) | アプリの状態: 起動の準備中 (1) |
| <span class="fmrb-name">`PROC_STATE_RUNNING`</span> | [`Integer`](Integer.md) | アプリの状態: 実行中 (2) |
| <span class="fmrb-name">`PROC_STATE_SUSPENDED`</span> | [`Integer`](Integer.md) | アプリの状態: 一時停止 (3) |
| <span class="fmrb-name">`PROC_STATE_STOPPING`</span> | [`Integer`](Integer.md) | アプリの状態: 終了中 (4) |
| <span class="fmrb-name">`MSG_TYPE_APP_CONTROL`</span> | [`Integer`](Integer.md) | メッセージの種類: アプリの制御 (0) |
| <span class="fmrb-name">`MSG_TYPE_APP_GFX`</span> | [`Integer`](Integer.md) | メッセージの種類: 描画の命令 (1) |
| <span class="fmrb-name">`MSG_TYPE_APP_AUDIO`</span> | [`Integer`](Integer.md) | メッセージの種類: 音の命令 (2) |
| <span class="fmrb-name">`MSG_TYPE_HID_EVENT`</span> | [`Integer`](Integer.md) | メッセージの種類: 入力イベント (3) |

## クラスメソッド

### FmrbConst.bt_mac

<pre class="fmrb-sig"><code>bt_mac() -&gt; <a href="../String/">String</a></code></pre>

実行中の端末の BLE アドレスを返す

**起動後に値が決まる端末がある** (無線が別チップの機種は、BLE がつながるまで分からない)。分からない間と linux では "-" を返す。起動時の値で足りるなら `MAC_ADDRESS`。
```ruby
FmrbConst.bt_mac   #=> "AA:BB:CC:DD:EE:FF"
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
