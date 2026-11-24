# FmrbConst

Constants for the machine, the build, keys and the theme.

Values are fixed when the VM starts and do not change while an app runs.
**Constants that differ by machine or build** (`BOARD`, `PLATFORM`,
`HW_FAMILY`, `CHIP_*`, `FLASH_SIZE_MB` and others) say so in their notes.

`KEY_*` are USB HID Usage IDs. Compare them with `ev[:scancode]` to get the
same answer on every machine. `ev[:keycode]` differs by machine for
character keys (ASCII on SDL).
```ruby
if ev[:scancode] == FmrbConst::KEY_ESC
  stop
end
```

## Constants

| Name | Type | What it is |
|---|---|---|
| `KEY_A` | `Integer` | A key (HID 0x04) |
| `KEY_B` | `Integer` | B key (HID 0x05) |
| `KEY_C` | `Integer` | C key (HID 0x06) |
| `KEY_D` | `Integer` | D key (HID 0x07) |
| `KEY_E` | `Integer` | E key (HID 0x08) |
| `KEY_F` | `Integer` | F key (HID 0x09) |
| `KEY_G` | `Integer` | G key (HID 0x0A) |
| `KEY_H` | `Integer` | H key (HID 0x0B) |
| `KEY_I` | `Integer` | I key (HID 0x0C) |
| `KEY_J` | `Integer` | J key (HID 0x0D) |
| `KEY_K` | `Integer` | K key (HID 0x0E) |
| `KEY_L` | `Integer` | L key (HID 0x0F) |
| `KEY_M` | `Integer` | M key (HID 0x10) |
| `KEY_N` | `Integer` | N key (HID 0x11) |
| `KEY_O` | `Integer` | O key (HID 0x12) |
| `KEY_P` | `Integer` | P key (HID 0x13) |
| `KEY_Q` | `Integer` | Q key (HID 0x14) |
| `KEY_R` | `Integer` | R key (HID 0x15) |
| `KEY_S` | `Integer` | S key (HID 0x16) |
| `KEY_T` | `Integer` | T key (HID 0x17) |
| `KEY_U` | `Integer` | U key (HID 0x18) |
| `KEY_V` | `Integer` | V key (HID 0x19) |
| `KEY_W` | `Integer` | W key (HID 0x1A) |
| `KEY_X` | `Integer` | X key (HID 0x1B) |
| `KEY_Y` | `Integer` | Y key (HID 0x1C) |
| `KEY_Z` | `Integer` | Z key (HID 0x1D) |
| `KEY_1` | `Integer` | 1 key (number row) (HID 0x1E) |
| `KEY_2` | `Integer` | 2 key (number row) (HID 0x1F) |
| `KEY_3` | `Integer` | 3 key (number row) (HID 0x20) |
| `KEY_4` | `Integer` | 4 key (number row) (HID 0x21) |
| `KEY_5` | `Integer` | 5 key (number row) (HID 0x22) |
| `KEY_6` | `Integer` | 6 key (number row) (HID 0x23) |
| `KEY_7` | `Integer` | 7 key (number row) (HID 0x24) |
| `KEY_8` | `Integer` | 8 key (number row) (HID 0x25) |
| `KEY_9` | `Integer` | 9 key (number row) (HID 0x26) |
| `KEY_0` | `Integer` | 0 key (number row) (HID 0x27) |
| `KEY_ENTER` | `Integer` | Enter (HID 0x28) |
| `KEY_ESC` | `Integer` | Escape (HID 0x29) |
| `KEY_BACKSPACE` | `Integer` | Backspace (HID 0x2A) |
| `KEY_TAB` | `Integer` | Tab (HID 0x2B) |
| `KEY_SPACE` | `Integer` | Space (HID 0x2C) |
| `KEY_MINUS` | `Integer` | - (minus) key (HID 0x2D) |
| `KEY_EQUAL` | `Integer` | = key (US layout name) (HID 0x2E) |
| `KEY_LBRACKET` | `Integer` | [ key (US layout name) (HID 0x2F) |
| `KEY_RBRACKET` | `Integer` | ] key (US layout name) (HID 0x30) |
| `KEY_BACKSLASH` | `Integer` | \ key (US layout name) (HID 0x31) |
| `KEY_SEMICOLON` | `Integer` | ; key (US layout name) (HID 0x33) |
| `KEY_QUOTE` | `Integer` | ' key (US layout name) (HID 0x34) |
| `KEY_GRAVE` | `Integer` | ` key (US layout name) (HID 0x35) |
| `KEY_COMMA` | `Integer` | comma key (HID 0x36) |
| `KEY_PERIOD` | `Integer` | period key (HID 0x37) |
| `KEY_SLASH` | `Integer` | / key (HID 0x38) |
| `KEY_CAPSLOCK` | `Integer` | Caps Lock (HID 0x39) |
| `KEY_F1` | `Integer` | F1 key (HID 0x3A) |
| `KEY_F2` | `Integer` | F2 key (HID 0x3B) |
| `KEY_F3` | `Integer` | F3 key (HID 0x3C) |
| `KEY_F4` | `Integer` | F4 key (HID 0x3D) |
| `KEY_F5` | `Integer` | F5 key (HID 0x3E) |
| `KEY_F6` | `Integer` | F6 key (HID 0x3F) |
| `KEY_F7` | `Integer` | F7 key (HID 0x40) |
| `KEY_F8` | `Integer` | F8 key (HID 0x41) |
| `KEY_F9` | `Integer` | F9 key (HID 0x42) |
| `KEY_F10` | `Integer` | F10 key (HID 0x43) |
| `KEY_F11` | `Integer` | F11 key (HID 0x44) |
| `KEY_F12` | `Integer` | F12 key (HID 0x45) |
| `KEY_PRINTSCREEN` | `Integer` | Print Screen (HID 0x46) |
| `KEY_SCROLLLOCK` | `Integer` | Scroll Lock (HID 0x47) |
| `KEY_PAUSE` | `Integer` | Pause (HID 0x48) |
| `KEY_INSERT` | `Integer` | Insert (HID 0x49) |
| `KEY_HOME` | `Integer` | Home (HID 0x4A) |
| `KEY_PGUP` | `Integer` | Page Up (HID 0x4B) |
| `KEY_DELETE` | `Integer` | Delete (HID 0x4C) |
| `KEY_END` | `Integer` | End (HID 0x4D) |
| `KEY_PGDN` | `Integer` | Page Down (HID 0x4E) |
| `KEY_RIGHT` | `Integer` | Right arrow (HID 0x4F) |
| `KEY_LEFT` | `Integer` | Left arrow (HID 0x50) |
| `KEY_DOWN` | `Integer` | Down arrow (HID 0x51) |
| `KEY_UP` | `Integer` | Up arrow (HID 0x52) |
| `KEY_NUMLOCK` | `Integer` | Num Lock (HID 0x53) |
| `KEY_LCTRL` | `Integer` | Left Ctrl (HID 0xE0) |
| `KEY_LSHIFT` | `Integer` | Left Shift (HID 0xE1) |
| `KEY_LALT` | `Integer` | Left Alt (HID 0xE2) |
| `KEY_LMETA` | `Integer` | Left Meta (HID 0xE3) |
| `KEY_RCTRL` | `Integer` | Right Ctrl (HID 0xE4) |
| `KEY_RSHIFT` | `Integer` | Right Shift (HID 0xE5) |
| `KEY_RALT` | `Integer` | Right Alt (HID 0xE6) |
| `KEY_RMETA` | `Integer` | Right Meta (HID 0xE7) |
| `MOD_LSHIFT` | `Integer` | ---- 修飾キーのマスク (ev[:modifier] と & で比べる) ---- |
| `MOD_RSHIFT` | `Integer` | Modifier mask: Right Shift (0x02) |
| `MOD_LCTRL` | `Integer` | Modifier mask: Left Ctrl (0x04) |
| `MOD_RCTRL` | `Integer` | Modifier mask: Right Ctrl (0x08) |
| `MOD_LALT` | `Integer` | Modifier mask: Left Alt (0x10) |
| `MOD_RALT` | `Integer` | Modifier mask: Right Alt (0x20) |
| `MOD_SHIFT` | `Integer` | Modifier mask: either Shift (0x03) |
| `MOD_CTRL` | `Integer` | Modifier mask: either Ctrl (0x0C) |
| `MOD_ALT` | `Integer` | Modifier mask: either Alt (0x30) |
| `GP_SQUARE` | `Integer` | ---- ゲームパッド (ボタンの番号と軸の番号) ---- |
| `GP_CROSS` | `Integer` | Button index 1: Cross |
| `GP_CIRCLE` | `Integer` | Button index 2: Circle |
| `GP_TRIANGLE` | `Integer` | Button index 3: Triangle |
| `GP_L1` | `Integer` | Button index 4: L1 |
| `GP_R1` | `Integer` | Button index 5: R1 |
| `GP_L2` | `Integer` | Button index 6: L2 |
| `GP_R2` | `Integer` | Button index 7: R2 |
| `GP_SELECT` | `Integer` | Button index 8: Select |
| `GP_START` | `Integer` | Button index 9: Start |
| `GP_L3` | `Integer` | Button index 10: Left stick click |
| `GP_R3` | `Integer` | Button index 11: Right stick click |
| `GP_UP` | `Integer` | Button index 12: D-pad up |
| `GP_DOWN` | `Integer` | Button index 13: D-pad down |
| `GP_LEFT` | `Integer` | Button index 14: D-pad left |
| `GP_RIGHT` | `Integer` | Button index 15: D-pad right |
| `GP_AXIS_LX` | `Integer` | Axis index 0: Left stick X (ev[:axis]) |
| `GP_AXIS_LY` | `Integer` | Axis index 1: Left stick Y (ev[:axis]) |
| `GP_AXIS_RX` | `Integer` | Axis index 2: Right stick X (ev[:axis]) |
| `GP_AXIS_RY` | `Integer` | Axis index 3: Right stick Y (ev[:axis]) |
| `THEME_DESKTOP_BG` | `Integer` | ---- テーマの色 (RGB332) ---- |
| `THEME_MENU_BG` | `Integer` | Menu background (RGB332; set in [theme]) |
| `THEME_WINDOW_BG` | `Integer` | Window background (RGB332; set in [theme]) |
| `THEME_TEXT` | `Integer` | Text colour (RGB332; set in [theme]) |
| `THEME_TEXT_LIGHT` | `Integer` | Light text colour (RGB332; set in [theme]) |
| `THEME_HIGHLIGHT` | `Integer` | Highlight colour (RGB332; set in [theme]) |
| `THEME_BORDER` | `Integer` | Border colour (RGB332; set in [theme]) |
| `THEME_BUTTON` | `Integer` | Button colour (RGB332; set in [theme]) |
| `THEME_DIR_COLOR` | `Integer` | Directory colour (RGB332; set in [theme]) |
| `WHEEL_LINES` | `Integer` | Rows one wheel notch scrolls (3 by default) |
| `PLATFORM` | `String` | ---- 機種・ビルド ---- |
| `BOARD` | `String` | Board name; differs per machine |
| `NATIVE` | `bool` | true on the native Linux program |
| `HW_FAMILY` | `String` | "modern"/"mini"/"retro" (sim: the one imitated) |
| `FONT_JA` | `bool` | true when the build has the Japanese fonts |
| `HAS_WIFI` | `bool` | true on a WiFi-capable machine (the sim too) |
| `LANGUAGE` | `String` | UI language, "ja" or "en" |
| `OS_VERSION` | `String` | The OS (core) version string |
| `GA_VERSION` | `String` | The graphics-audio version string |
| `LINK_VERSION` | `Integer` | Version of the link between core and graphics-audio |
| `BUILD_DATE` | `String` | When the firmware was built |
| `IDF_VERSION` | `String` | ESP-IDF version ("-" on linux) |
| `MAC_ADDRESS` | `String` | BLE MAC read at start-up ("-" on linux) |
| `CHIP_MODEL` | `String` | Chip name ("linux" on linux) |
| `CHIP_REVISION` | `String` | Chip revision like "v0.2" ("-" on linux) |
| `CHIP_CORES` | `Integer` | Number of chip cores (0 on linux) |
| `FLASH_SIZE_MB` | `Integer` | Flash size in MB (0 on linux) |
| `PSRAM_SIZE_MB` | `Integer` | PSRAM size in MB (0 when none, and on linux) |
| `RESET_REASON` | `String` | Last reset reason ("-" on linux) |
| `PROC_ID_KERNEL` | `Integer` | ---- アプリの番号・状態・メッセージの種類 ---- |
| `PROC_ID_HOST` | `Integer` | Process ID of the Host (1) |
| `PROC_ID_SYSTEM_APP` | `Integer` | Process ID of the system app (2) |
| `PROC_ID_USER_APP0` | `Integer` | Process ID of user app slot 0 (4) |
| `PROC_ID_USER_APP1` | `Integer` | Process ID of user app slot 1 (5) |
| `PROC_ID_USER_APP2` | `Integer` | Process ID of user app slot 2 (6) |
| `PROC_ID_USER_APP3` | `Integer` | Process ID of user app slot 3 (7) |
| `PROC_ID_USER_APP4` | `Integer` | Process ID of user app slot 4 (8) |
| `PROC_STATE_FREE` | `Integer` | App state: free (0) |
| `PROC_STATE_INIT` | `Integer` | App state: initialising (1) |
| `PROC_STATE_RUNNING` | `Integer` | App state: running (2) |
| `PROC_STATE_SUSPENDED` | `Integer` | App state: suspended (3) |
| `PROC_STATE_STOPPING` | `Integer` | App state: stopping (4) |
| `MSG_TYPE_APP_CONTROL` | `Integer` | Message type: app control (0) |
| `MSG_TYPE_APP_GFX` | `Integer` | Message type: drawing commands (1) |
| `MSG_TYPE_APP_AUDIO` | `Integer` | Message type: audio commands (2) |
| `MSG_TYPE_HID_EVENT` | `Integer` | Message type: input events (3) |

## Class methods

### FmrbConst.bt_mac

```ruby
bt_mac() -> String
```

The BLE address of this machine

**Some machines only know it after start-up** (when the radio is a separate chip it is unknown until BLE syncs).
Returns "-" while unknown and on linux. `MAC_ADDRESS` is the start-up value.
```ruby
FmrbConst.bt_mac   #=> "AA:BB:CC:DD:EE:FF"
```

---

*This page is generated from the API signatures of Family mruby (`sig/`) (fmruby-core api-site 45b8559c).*
