# FmrbConst

端末・ビルド・キー・テーマの値をまとめた定数の入れもの。

値は VM を起こすときに決まり、アプリが走っている間は変わらない。
**機種やビルドで値が変わるもの** (`BOARD`・`PLATFORM`・`HW_FAMILY`・`CHIP_*`・
`FLASH_SIZE_MB` ほか) は、各定数の説明に書いた。

キーの番号 (`KEY_*`) は USB HID の Usage ID。イベントの `ev[:scancode]` と
比べると、機種によらず同じ値で判定できる。`ev[:keycode]` は文字キーだと
機種で値が違う (SDL では ASCII)。
```ruby
if ev[:scancode] == FmrbConst::KEY_ESC
  stop
end
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| `KEY_A` | `Integer` | A キー (HID 0x04) |
| `KEY_B` | `Integer` | B キー (HID 0x05) |
| `KEY_C` | `Integer` | C キー (HID 0x06) |
| `KEY_D` | `Integer` | D キー (HID 0x07) |
| `KEY_E` | `Integer` | E キー (HID 0x08) |
| `KEY_F` | `Integer` | F キー (HID 0x09) |
| `KEY_G` | `Integer` | G キー (HID 0x0A) |
| `KEY_H` | `Integer` | H キー (HID 0x0B) |
| `KEY_I` | `Integer` | I キー (HID 0x0C) |
| `KEY_J` | `Integer` | J キー (HID 0x0D) |
| `KEY_K` | `Integer` | K キー (HID 0x0E) |
| `KEY_L` | `Integer` | L キー (HID 0x0F) |
| `KEY_M` | `Integer` | M キー (HID 0x10) |
| `KEY_N` | `Integer` | N キー (HID 0x11) |
| `KEY_O` | `Integer` | O キー (HID 0x12) |
| `KEY_P` | `Integer` | P キー (HID 0x13) |
| `KEY_Q` | `Integer` | Q キー (HID 0x14) |
| `KEY_R` | `Integer` | R キー (HID 0x15) |
| `KEY_S` | `Integer` | S キー (HID 0x16) |
| `KEY_T` | `Integer` | T キー (HID 0x17) |
| `KEY_U` | `Integer` | U キー (HID 0x18) |
| `KEY_V` | `Integer` | V キー (HID 0x19) |
| `KEY_W` | `Integer` | W キー (HID 0x1A) |
| `KEY_X` | `Integer` | X キー (HID 0x1B) |
| `KEY_Y` | `Integer` | Y キー (HID 0x1C) |
| `KEY_Z` | `Integer` | Z キー (HID 0x1D) |
| `KEY_1` | `Integer` | 1 キー (上の数字の列) (HID 0x1E) |
| `KEY_2` | `Integer` | 2 キー (上の数字の列) (HID 0x1F) |
| `KEY_3` | `Integer` | 3 キー (上の数字の列) (HID 0x20) |
| `KEY_4` | `Integer` | 4 キー (上の数字の列) (HID 0x21) |
| `KEY_5` | `Integer` | 5 キー (上の数字の列) (HID 0x22) |
| `KEY_6` | `Integer` | 6 キー (上の数字の列) (HID 0x23) |
| `KEY_7` | `Integer` | 7 キー (上の数字の列) (HID 0x24) |
| `KEY_8` | `Integer` | 8 キー (上の数字の列) (HID 0x25) |
| `KEY_9` | `Integer` | 9 キー (上の数字の列) (HID 0x26) |
| `KEY_0` | `Integer` | 0 キー (上の数字の列) (HID 0x27) |
| `KEY_ENTER` | `Integer` | Enter (HID 0x28) |
| `KEY_ESC` | `Integer` | Esc (HID 0x29) |
| `KEY_BACKSPACE` | `Integer` | BackSpace (HID 0x2A) |
| `KEY_TAB` | `Integer` | Tab (HID 0x2B) |
| `KEY_SPACE` | `Integer` | スペース (HID 0x2C) |
| `KEY_MINUS` | `Integer` | - キー (HID 0x2D) |
| `KEY_EQUAL` | `Integer` | = キー (US 配列の名前) (HID 0x2E) |
| `KEY_LBRACKET` | `Integer` | [ キー (US 配列の名前) (HID 0x2F) |
| `KEY_RBRACKET` | `Integer` | ] キー (US 配列の名前) (HID 0x30) |
| `KEY_BACKSLASH` | `Integer` | \ キー (US 配列の名前) (HID 0x31) |
| `KEY_SEMICOLON` | `Integer` | ; キー (US 配列の名前) (HID 0x33) |
| `KEY_QUOTE` | `Integer` | ' キー (US 配列の名前) (HID 0x34) |
| `KEY_GRAVE` | `Integer` | ` キー (US 配列の名前) (HID 0x35) |
| `KEY_COMMA` | `Integer` | , キー (HID 0x36) |
| `KEY_PERIOD` | `Integer` | . キー (HID 0x37) |
| `KEY_SLASH` | `Integer` | / キー (HID 0x38) |
| `KEY_CAPSLOCK` | `Integer` | CapsLock (HID 0x39) |
| `KEY_F1` | `Integer` | F1 キー (HID 0x3A) |
| `KEY_F2` | `Integer` | F2 キー (HID 0x3B) |
| `KEY_F3` | `Integer` | F3 キー (HID 0x3C) |
| `KEY_F4` | `Integer` | F4 キー (HID 0x3D) |
| `KEY_F5` | `Integer` | F5 キー (HID 0x3E) |
| `KEY_F6` | `Integer` | F6 キー (HID 0x3F) |
| `KEY_F7` | `Integer` | F7 キー (HID 0x40) |
| `KEY_F8` | `Integer` | F8 キー (HID 0x41) |
| `KEY_F9` | `Integer` | F9 キー (HID 0x42) |
| `KEY_F10` | `Integer` | F10 キー (HID 0x43) |
| `KEY_F11` | `Integer` | F11 キー (HID 0x44) |
| `KEY_F12` | `Integer` | F12 キー (HID 0x45) |
| `KEY_PRINTSCREEN` | `Integer` | PrintScreen (HID 0x46) |
| `KEY_SCROLLLOCK` | `Integer` | ScrollLock (HID 0x47) |
| `KEY_PAUSE` | `Integer` | Pause (HID 0x48) |
| `KEY_INSERT` | `Integer` | Insert (HID 0x49) |
| `KEY_HOME` | `Integer` | Home (HID 0x4A) |
| `KEY_PGUP` | `Integer` | PageUp (HID 0x4B) |
| `KEY_DELETE` | `Integer` | Delete (HID 0x4C) |
| `KEY_END` | `Integer` | End (HID 0x4D) |
| `KEY_PGDN` | `Integer` | PageDown (HID 0x4E) |
| `KEY_RIGHT` | `Integer` | 右矢印 (HID 0x4F) |
| `KEY_LEFT` | `Integer` | 左矢印 (HID 0x50) |
| `KEY_DOWN` | `Integer` | 下矢印 (HID 0x51) |
| `KEY_UP` | `Integer` | 上矢印 (HID 0x52) |
| `KEY_NUMLOCK` | `Integer` | NumLock (HID 0x53) |
| `KEY_LCTRL` | `Integer` | 左 Ctrl (HID 0xE0) |
| `KEY_LSHIFT` | `Integer` | 左 Shift (HID 0xE1) |
| `KEY_LALT` | `Integer` | 左 Alt (HID 0xE2) |
| `KEY_LMETA` | `Integer` | 左 Meta (HID 0xE3) |
| `KEY_RCTRL` | `Integer` | 右 Ctrl (HID 0xE4) |
| `KEY_RSHIFT` | `Integer` | 右 Shift (HID 0xE5) |
| `KEY_RALT` | `Integer` | 右 Alt (HID 0xE6) |
| `KEY_RMETA` | `Integer` | 右 Meta (HID 0xE7) |
| `MOD_LSHIFT` | `Integer` | ---- 修飾キーのマスク (ev[:modifier] と & で比べる) ---- |
| `MOD_RSHIFT` | `Integer` | 右 Shift のマスク (0x02) |
| `MOD_LCTRL` | `Integer` | 左 Ctrl のマスク (0x04) |
| `MOD_RCTRL` | `Integer` | 右 Ctrl のマスク (0x08) |
| `MOD_LALT` | `Integer` | 左 Alt のマスク (0x10) |
| `MOD_RALT` | `Integer` | 右 Alt のマスク (0x20) |
| `MOD_SHIFT` | `Integer` | 左右どちらかの Shift のマスク (0x03) |
| `MOD_CTRL` | `Integer` | 左右どちらかの Ctrl のマスク (0x0C) |
| `MOD_ALT` | `Integer` | 左右どちらかの Alt のマスク (0x30) |
| `GP_SQUARE` | `Integer` | ---- ゲームパッド (ボタンの番号と軸の番号) ---- |
| `GP_CROSS` | `Integer` | ボタン番号 1: バツ |
| `GP_CIRCLE` | `Integer` | ボタン番号 2: 丸 |
| `GP_TRIANGLE` | `Integer` | ボタン番号 3: 三角 |
| `GP_L1` | `Integer` | ボタン番号 4: L1 |
| `GP_R1` | `Integer` | ボタン番号 5: R1 |
| `GP_L2` | `Integer` | ボタン番号 6: L2 |
| `GP_R2` | `Integer` | ボタン番号 7: R2 |
| `GP_SELECT` | `Integer` | ボタン番号 8: Select |
| `GP_START` | `Integer` | ボタン番号 9: Start |
| `GP_L3` | `Integer` | ボタン番号 10: 左スティックの押し込み |
| `GP_R3` | `Integer` | ボタン番号 11: 右スティックの押し込み |
| `GP_UP` | `Integer` | ボタン番号 12: 十字キーの上 |
| `GP_DOWN` | `Integer` | ボタン番号 13: 十字キーの下 |
| `GP_LEFT` | `Integer` | ボタン番号 14: 十字キーの左 |
| `GP_RIGHT` | `Integer` | ボタン番号 15: 十字キーの右 |
| `GP_AXIS_LX` | `Integer` | 軸番号 0: 左スティックの横 (ev[:axis]) |
| `GP_AXIS_LY` | `Integer` | 軸番号 1: 左スティックの縦 (ev[:axis]) |
| `GP_AXIS_RX` | `Integer` | 軸番号 2: 右スティックの横 (ev[:axis]) |
| `GP_AXIS_RY` | `Integer` | 軸番号 3: 右スティックの縦 (ev[:axis]) |
| `THEME_DESKTOP_BG` | `Integer` | ---- テーマの色 (RGB332) ---- |
| `THEME_MENU_BG` | `Integer` | メニューの背景 (RGB332。[theme] で設定) |
| `THEME_WINDOW_BG` | `Integer` | Window の背景 (RGB332。[theme] で設定) |
| `THEME_TEXT` | `Integer` | 文字の色 (RGB332。[theme] で設定) |
| `THEME_TEXT_LIGHT` | `Integer` | 淡い文字の色 (RGB332。[theme] で設定) |
| `THEME_HIGHLIGHT` | `Integer` | 選択の強調色 (RGB332。[theme] で設定) |
| `THEME_BORDER` | `Integer` | 枠の色 (RGB332。[theme] で設定) |
| `THEME_BUTTON` | `Integer` | ボタンの色 (RGB332。[theme] で設定) |
| `THEME_DIR_COLOR` | `Integer` | 一覧のディレクトリ色 (RGB332。[theme] で設定) |
| `WHEEL_LINES` | `Integer` | ホイール 1 目盛りで進む行数 (既定 3) |
| `PLATFORM` | `String` | ---- 機種・ビルド ---- |
| `BOARD` | `String` | 端末の名前 (機種ごとに違う) |
| `NATIVE` | `bool` | ネイティブ版 (Linux の 1 プロセス) なら true |
| `HW_FAMILY` | `String` | "modern"・"mini"・"retro" (sim は模した機種) |
| `FONT_JA` | `bool` | 日本語フォントを積んだビルドなら true |
| `HAS_WIFI` | `bool` | WiFi を使える端末なら true (sim も true) |
| `LANGUAGE` | `String` | 表示の言語 ("ja" か "en") |
| `OS_VERSION` | `String` | OS (core) の版の文字列 |
| `GA_VERSION` | `String` | graphics-audio の版の文字列 |
| `LINK_VERSION` | `Integer` | core と graphics-audio をつなぐ線の版 |
| `BUILD_DATE` | `String` | ファームを作った日時 |
| `IDF_VERSION` | `String` | ESP-IDF の版 (linux では "-") |
| `MAC_ADDRESS` | `String` | 起動時の BLE の MAC (linux では "-") |
| `CHIP_MODEL` | `String` | チップの名前 (linux では "linux") |
| `CHIP_REVISION` | `String` | チップのリビジョン ("v0.2" の形。linux では "-") |
| `CHIP_CORES` | `Integer` | チップのコア数 (linux では 0) |
| `FLASH_SIZE_MB` | `Integer` | フラッシュの大きさ MB (linux では 0) |
| `PSRAM_SIZE_MB` | `Integer` | PSRAM の大きさ MB (無ければ 0。linux では 0) |
| `RESET_REASON` | `String` | 直前のリセットの理由 (linux では "-") |
| `PROC_ID_KERNEL` | `Integer` | ---- アプリの番号・状態・メッセージの種類 ---- |
| `PROC_ID_HOST` | `Integer` | Host のプロセス番号 (1) |
| `PROC_ID_SYSTEM_APP` | `Integer` | システムアプリのプロセス番号 (2) |
| `PROC_ID_USER_APP0` | `Integer` | ユーザアプリの枠 0 のプロセス番号 (4) |
| `PROC_ID_USER_APP1` | `Integer` | ユーザアプリの枠 1 のプロセス番号 (5) |
| `PROC_ID_USER_APP2` | `Integer` | ユーザアプリの枠 2 のプロセス番号 (6) |
| `PROC_ID_USER_APP3` | `Integer` | ユーザアプリの枠 3 のプロセス番号 (7) |
| `PROC_ID_USER_APP4` | `Integer` | ユーザアプリの枠 4 のプロセス番号 (8) |
| `PROC_STATE_FREE` | `Integer` | アプリの状態: 空き (0) |
| `PROC_STATE_INIT` | `Integer` | アプリの状態: 起動の準備中 (1) |
| `PROC_STATE_RUNNING` | `Integer` | アプリの状態: 実行中 (2) |
| `PROC_STATE_SUSPENDED` | `Integer` | アプリの状態: 一時停止 (3) |
| `PROC_STATE_STOPPING` | `Integer` | アプリの状態: 終了中 (4) |
| `MSG_TYPE_APP_CONTROL` | `Integer` | メッセージの種類: アプリの制御 (0) |
| `MSG_TYPE_APP_GFX` | `Integer` | メッセージの種類: 描画の命令 (1) |
| `MSG_TYPE_APP_AUDIO` | `Integer` | メッセージの種類: 音の命令 (2) |
| `MSG_TYPE_HID_EVENT` | `Integer` | メッセージの種類: 入力イベント (3) |

## クラスメソッド

### FmrbConst.bt_mac

```ruby
bt_mac() -> String
```

実行中の端末の BLE アドレスを返す

**起動後に値が決まる端末がある** (無線が別チップの機種は、BLE がつながるまで分からない)。
分からない間と linux では "-" を返す。起動時の値で足りるなら `MAC_ADDRESS`。
```ruby
FmrbConst.bt_mac   #=> "AA:BB:CC:DD:EE:FF"
```

---

*このページは Family mruby の API の型定義 (`sig/`) から自動で作っています (fmruby-core api-site 45b8559c).*
