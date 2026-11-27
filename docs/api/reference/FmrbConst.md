# FmrbConst

Constants: machine, build, keys, theme

How to use it: [Constants & System Info](../const.md).

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
| <span class="fmrb-name">`KEY_A`</span> | [`Integer`](Integer.md) | A key (HID 0x04) |
| <span class="fmrb-name">`KEY_B`</span> | [`Integer`](Integer.md) | B key (HID 0x05) |
| <span class="fmrb-name">`KEY_C`</span> | [`Integer`](Integer.md) | C key (HID 0x06) |
| <span class="fmrb-name">`KEY_D`</span> | [`Integer`](Integer.md) | D key (HID 0x07) |
| <span class="fmrb-name">`KEY_E`</span> | [`Integer`](Integer.md) | E key (HID 0x08) |
| <span class="fmrb-name">`KEY_F`</span> | [`Integer`](Integer.md) | F key (HID 0x09) |
| <span class="fmrb-name">`KEY_G`</span> | [`Integer`](Integer.md) | G key (HID 0x0A) |
| <span class="fmrb-name">`KEY_H`</span> | [`Integer`](Integer.md) | H key (HID 0x0B) |
| <span class="fmrb-name">`KEY_I`</span> | [`Integer`](Integer.md) | I key (HID 0x0C) |
| <span class="fmrb-name">`KEY_J`</span> | [`Integer`](Integer.md) | J key (HID 0x0D) |
| <span class="fmrb-name">`KEY_K`</span> | [`Integer`](Integer.md) | K key (HID 0x0E) |
| <span class="fmrb-name">`KEY_L`</span> | [`Integer`](Integer.md) | L key (HID 0x0F) |
| <span class="fmrb-name">`KEY_M`</span> | [`Integer`](Integer.md) | M key (HID 0x10) |
| <span class="fmrb-name">`KEY_N`</span> | [`Integer`](Integer.md) | N key (HID 0x11) |
| <span class="fmrb-name">`KEY_O`</span> | [`Integer`](Integer.md) | O key (HID 0x12) |
| <span class="fmrb-name">`KEY_P`</span> | [`Integer`](Integer.md) | P key (HID 0x13) |
| <span class="fmrb-name">`KEY_Q`</span> | [`Integer`](Integer.md) | Q key (HID 0x14) |
| <span class="fmrb-name">`KEY_R`</span> | [`Integer`](Integer.md) | R key (HID 0x15) |
| <span class="fmrb-name">`KEY_S`</span> | [`Integer`](Integer.md) | S key (HID 0x16) |
| <span class="fmrb-name">`KEY_T`</span> | [`Integer`](Integer.md) | T key (HID 0x17) |
| <span class="fmrb-name">`KEY_U`</span> | [`Integer`](Integer.md) | U key (HID 0x18) |
| <span class="fmrb-name">`KEY_V`</span> | [`Integer`](Integer.md) | V key (HID 0x19) |
| <span class="fmrb-name">`KEY_W`</span> | [`Integer`](Integer.md) | W key (HID 0x1A) |
| <span class="fmrb-name">`KEY_X`</span> | [`Integer`](Integer.md) | X key (HID 0x1B) |
| <span class="fmrb-name">`KEY_Y`</span> | [`Integer`](Integer.md) | Y key (HID 0x1C) |
| <span class="fmrb-name">`KEY_Z`</span> | [`Integer`](Integer.md) | Z key (HID 0x1D) |
| <span class="fmrb-name">`KEY_1`</span> | [`Integer`](Integer.md) | 1 key (number row) (HID 0x1E) |
| <span class="fmrb-name">`KEY_2`</span> | [`Integer`](Integer.md) | 2 key (number row) (HID 0x1F) |
| <span class="fmrb-name">`KEY_3`</span> | [`Integer`](Integer.md) | 3 key (number row) (HID 0x20) |
| <span class="fmrb-name">`KEY_4`</span> | [`Integer`](Integer.md) | 4 key (number row) (HID 0x21) |
| <span class="fmrb-name">`KEY_5`</span> | [`Integer`](Integer.md) | 5 key (number row) (HID 0x22) |
| <span class="fmrb-name">`KEY_6`</span> | [`Integer`](Integer.md) | 6 key (number row) (HID 0x23) |
| <span class="fmrb-name">`KEY_7`</span> | [`Integer`](Integer.md) | 7 key (number row) (HID 0x24) |
| <span class="fmrb-name">`KEY_8`</span> | [`Integer`](Integer.md) | 8 key (number row) (HID 0x25) |
| <span class="fmrb-name">`KEY_9`</span> | [`Integer`](Integer.md) | 9 key (number row) (HID 0x26) |
| <span class="fmrb-name">`KEY_0`</span> | [`Integer`](Integer.md) | 0 key (number row) (HID 0x27) |
| <span class="fmrb-name">`KEY_ENTER`</span> | [`Integer`](Integer.md) | Enter (HID 0x28) |
| <span class="fmrb-name">`KEY_ESC`</span> | [`Integer`](Integer.md) | Escape (HID 0x29) |
| <span class="fmrb-name">`KEY_BACKSPACE`</span> | [`Integer`](Integer.md) | Backspace (HID 0x2A) |
| <span class="fmrb-name">`KEY_TAB`</span> | [`Integer`](Integer.md) | Tab (HID 0x2B) |
| <span class="fmrb-name">`KEY_SPACE`</span> | [`Integer`](Integer.md) | Space (HID 0x2C) |
| <span class="fmrb-name">`KEY_MINUS`</span> | [`Integer`](Integer.md) | - (minus) key (HID 0x2D) |
| <span class="fmrb-name">`KEY_EQUAL`</span> | [`Integer`](Integer.md) | = key (US layout name) (HID 0x2E) |
| <span class="fmrb-name">`KEY_LBRACKET`</span> | [`Integer`](Integer.md) | [ key (US layout name) (HID 0x2F) |
| <span class="fmrb-name">`KEY_RBRACKET`</span> | [`Integer`](Integer.md) | ] key (US layout name) (HID 0x30) |
| <span class="fmrb-name">`KEY_BACKSLASH`</span> | [`Integer`](Integer.md) | \ key (US layout name) (HID 0x31) |
| <span class="fmrb-name">`KEY_SEMICOLON`</span> | [`Integer`](Integer.md) | ; key (US layout name) (HID 0x33) |
| <span class="fmrb-name">`KEY_QUOTE`</span> | [`Integer`](Integer.md) | ' key (US layout name) (HID 0x34) |
| <span class="fmrb-name">`KEY_GRAVE`</span> | [`Integer`](Integer.md) | ` key (US layout name) (HID 0x35) |
| <span class="fmrb-name">`KEY_COMMA`</span> | [`Integer`](Integer.md) | comma key (HID 0x36) |
| <span class="fmrb-name">`KEY_PERIOD`</span> | [`Integer`](Integer.md) | period key (HID 0x37) |
| <span class="fmrb-name">`KEY_SLASH`</span> | [`Integer`](Integer.md) | / key (HID 0x38) |
| <span class="fmrb-name">`KEY_CAPSLOCK`</span> | [`Integer`](Integer.md) | Caps Lock (HID 0x39) |
| <span class="fmrb-name">`KEY_F1`</span> | [`Integer`](Integer.md) | F1 key (HID 0x3A) |
| <span class="fmrb-name">`KEY_F2`</span> | [`Integer`](Integer.md) | F2 key (HID 0x3B) |
| <span class="fmrb-name">`KEY_F3`</span> | [`Integer`](Integer.md) | F3 key (HID 0x3C) |
| <span class="fmrb-name">`KEY_F4`</span> | [`Integer`](Integer.md) | F4 key (HID 0x3D) |
| <span class="fmrb-name">`KEY_F5`</span> | [`Integer`](Integer.md) | F5 key (HID 0x3E) |
| <span class="fmrb-name">`KEY_F6`</span> | [`Integer`](Integer.md) | F6 key (HID 0x3F) |
| <span class="fmrb-name">`KEY_F7`</span> | [`Integer`](Integer.md) | F7 key (HID 0x40) |
| <span class="fmrb-name">`KEY_F8`</span> | [`Integer`](Integer.md) | F8 key (HID 0x41) |
| <span class="fmrb-name">`KEY_F9`</span> | [`Integer`](Integer.md) | F9 key (HID 0x42) |
| <span class="fmrb-name">`KEY_F10`</span> | [`Integer`](Integer.md) | F10 key (HID 0x43) |
| <span class="fmrb-name">`KEY_F11`</span> | [`Integer`](Integer.md) | F11 key (HID 0x44) |
| <span class="fmrb-name">`KEY_F12`</span> | [`Integer`](Integer.md) | F12 key (HID 0x45) |
| <span class="fmrb-name">`KEY_PRINTSCREEN`</span> | [`Integer`](Integer.md) | Print Screen (HID 0x46) |
| <span class="fmrb-name">`KEY_SCROLLLOCK`</span> | [`Integer`](Integer.md) | Scroll Lock (HID 0x47) |
| <span class="fmrb-name">`KEY_PAUSE`</span> | [`Integer`](Integer.md) | Pause (HID 0x48) |
| <span class="fmrb-name">`KEY_INSERT`</span> | [`Integer`](Integer.md) | Insert (HID 0x49) |
| <span class="fmrb-name">`KEY_HOME`</span> | [`Integer`](Integer.md) | Home (HID 0x4A) |
| <span class="fmrb-name">`KEY_PGUP`</span> | [`Integer`](Integer.md) | Page Up (HID 0x4B) |
| <span class="fmrb-name">`KEY_DELETE`</span> | [`Integer`](Integer.md) | Delete (HID 0x4C) |
| <span class="fmrb-name">`KEY_END`</span> | [`Integer`](Integer.md) | End (HID 0x4D) |
| <span class="fmrb-name">`KEY_PGDN`</span> | [`Integer`](Integer.md) | Page Down (HID 0x4E) |
| <span class="fmrb-name">`KEY_RIGHT`</span> | [`Integer`](Integer.md) | Right arrow (HID 0x4F) |
| <span class="fmrb-name">`KEY_LEFT`</span> | [`Integer`](Integer.md) | Left arrow (HID 0x50) |
| <span class="fmrb-name">`KEY_DOWN`</span> | [`Integer`](Integer.md) | Down arrow (HID 0x51) |
| <span class="fmrb-name">`KEY_UP`</span> | [`Integer`](Integer.md) | Up arrow (HID 0x52) |
| <span class="fmrb-name">`KEY_NUMLOCK`</span> | [`Integer`](Integer.md) | Num Lock (HID 0x53) |
| <span class="fmrb-name">`KEY_LCTRL`</span> | [`Integer`](Integer.md) | Left Ctrl (HID 0xE0) |
| <span class="fmrb-name">`KEY_LSHIFT`</span> | [`Integer`](Integer.md) | Left Shift (HID 0xE1) |
| <span class="fmrb-name">`KEY_LALT`</span> | [`Integer`](Integer.md) | Left Alt (HID 0xE2) |
| <span class="fmrb-name">`KEY_LMETA`</span> | [`Integer`](Integer.md) | Left Meta (HID 0xE3) |
| <span class="fmrb-name">`KEY_RCTRL`</span> | [`Integer`](Integer.md) | Right Ctrl (HID 0xE4) |
| <span class="fmrb-name">`KEY_RSHIFT`</span> | [`Integer`](Integer.md) | Right Shift (HID 0xE5) |
| <span class="fmrb-name">`KEY_RALT`</span> | [`Integer`](Integer.md) | Right Alt (HID 0xE6) |
| <span class="fmrb-name">`KEY_RMETA`</span> | [`Integer`](Integer.md) | Right Meta (HID 0xE7) |
| <span class="fmrb-name">`MOD_LSHIFT`</span> | [`Integer`](Integer.md) | Modifier mask: Left Shift (0x01) |
| <span class="fmrb-name">`MOD_RSHIFT`</span> | [`Integer`](Integer.md) | Modifier mask: Right Shift (0x02) |
| <span class="fmrb-name">`MOD_LCTRL`</span> | [`Integer`](Integer.md) | Modifier mask: Left Ctrl (0x04) |
| <span class="fmrb-name">`MOD_RCTRL`</span> | [`Integer`](Integer.md) | Modifier mask: Right Ctrl (0x08) |
| <span class="fmrb-name">`MOD_LALT`</span> | [`Integer`](Integer.md) | Modifier mask: Left Alt (0x10) |
| <span class="fmrb-name">`MOD_RALT`</span> | [`Integer`](Integer.md) | Modifier mask: Right Alt (0x20) |
| <span class="fmrb-name">`MOD_SHIFT`</span> | [`Integer`](Integer.md) | Modifier mask: either Shift (0x03) |
| <span class="fmrb-name">`MOD_CTRL`</span> | [`Integer`](Integer.md) | Modifier mask: either Ctrl (0x0C) |
| <span class="fmrb-name">`MOD_ALT`</span> | [`Integer`](Integer.md) | Modifier mask: either Alt (0x30) |
| <span class="fmrb-name">`GP_SQUARE`</span> | [`Integer`](Integer.md) | Button index 0: Square |
| <span class="fmrb-name">`GP_CROSS`</span> | [`Integer`](Integer.md) | Button index 1: Cross |
| <span class="fmrb-name">`GP_CIRCLE`</span> | [`Integer`](Integer.md) | Button index 2: Circle |
| <span class="fmrb-name">`GP_TRIANGLE`</span> | [`Integer`](Integer.md) | Button index 3: Triangle |
| <span class="fmrb-name">`GP_L1`</span> | [`Integer`](Integer.md) | Button index 4: L1 |
| <span class="fmrb-name">`GP_R1`</span> | [`Integer`](Integer.md) | Button index 5: R1 |
| <span class="fmrb-name">`GP_L2`</span> | [`Integer`](Integer.md) | Button index 6: L2 |
| <span class="fmrb-name">`GP_R2`</span> | [`Integer`](Integer.md) | Button index 7: R2 |
| <span class="fmrb-name">`GP_SELECT`</span> | [`Integer`](Integer.md) | Button index 8: Select |
| <span class="fmrb-name">`GP_START`</span> | [`Integer`](Integer.md) | Button index 9: Start |
| <span class="fmrb-name">`GP_L3`</span> | [`Integer`](Integer.md) | Button index 10: Left stick click |
| <span class="fmrb-name">`GP_R3`</span> | [`Integer`](Integer.md) | Button index 11: Right stick click |
| <span class="fmrb-name">`GP_UP`</span> | [`Integer`](Integer.md) | Button index 12: D-pad up |
| <span class="fmrb-name">`GP_DOWN`</span> | [`Integer`](Integer.md) | Button index 13: D-pad down |
| <span class="fmrb-name">`GP_LEFT`</span> | [`Integer`](Integer.md) | Button index 14: D-pad left |
| <span class="fmrb-name">`GP_RIGHT`</span> | [`Integer`](Integer.md) | Button index 15: D-pad right |
| <span class="fmrb-name">`GP_AXIS_LX`</span> | [`Integer`](Integer.md) | Axis index 0: Left stick X (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_LY`</span> | [`Integer`](Integer.md) | Axis index 1: Left stick Y (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_RX`</span> | [`Integer`](Integer.md) | Axis index 2: Right stick X (ev[:axis]) |
| <span class="fmrb-name">`GP_AXIS_RY`</span> | [`Integer`](Integer.md) | Axis index 3: Right stick Y (ev[:axis]) |
| <span class="fmrb-name">`THEME_DESKTOP_BG`</span> | [`Integer`](Integer.md) | Desktop background (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_MENU_BG`</span> | [`Integer`](Integer.md) | Menu background (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_WINDOW_BG`</span> | [`Integer`](Integer.md) | Window background (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_TEXT`</span> | [`Integer`](Integer.md) | Text colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_TEXT_LIGHT`</span> | [`Integer`](Integer.md) | Light text colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_HIGHLIGHT`</span> | [`Integer`](Integer.md) | Highlight colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_BORDER`</span> | [`Integer`](Integer.md) | Border colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_BUTTON`</span> | [`Integer`](Integer.md) | Button colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`THEME_DIR_COLOR`</span> | [`Integer`](Integer.md) | Directory colour (RGB332; set in [theme]) |
| <span class="fmrb-name">`WHEEL_LINES`</span> | [`Integer`](Integer.md) | Rows one wheel notch scrolls (3 by default) |
| <span class="fmrb-name">`PLATFORM`</span> | [`String`](String.md) | "esp32" or "linux" (sim etc. are linux) |
| <span class="fmrb-name">`BOARD`</span> | [`String`](String.md) | Board name; differs per machine |
| <span class="fmrb-name">`NATIVE`</span> | `bool` | true on the native Linux program |
| <span class="fmrb-name">`HW_FAMILY`</span> | [`String`](String.md) | "modern"/"mini"/"retro" (sim: the one imitated) |
| <span class="fmrb-name">`FONT_JA`</span> | `bool` | true when the build has the Japanese fonts |
| <span class="fmrb-name">`HAS_WIFI`</span> | `bool` | true on a WiFi-capable machine (the sim too) |
| <span class="fmrb-name">`LANGUAGE`</span> | [`String`](String.md) | UI language, "ja" or "en" |
| <span class="fmrb-name">`OS_VERSION`</span> | [`String`](String.md) | The OS (core) version string |
| <span class="fmrb-name">`GA_VERSION`</span> | [`String`](String.md) | The graphics-audio version string |
| <span class="fmrb-name">`LINK_VERSION`</span> | [`Integer`](Integer.md) | Version of the link between core and graphics-audio |
| <span class="fmrb-name">`BUILD_DATE`</span> | [`String`](String.md) | When the firmware was built |
| <span class="fmrb-name">`IDF_VERSION`</span> | [`String`](String.md) | ESP-IDF version ("-" on linux) |
| <span class="fmrb-name">`MAC_ADDRESS`</span> | [`String`](String.md) | BLE MAC read at start-up ("-" on linux) |
| <span class="fmrb-name">`CHIP_MODEL`</span> | [`String`](String.md) | Chip name ("linux" on linux) |
| <span class="fmrb-name">`CHIP_REVISION`</span> | [`String`](String.md) | Chip revision like "v0.2" ("-" on linux) |
| <span class="fmrb-name">`CHIP_CORES`</span> | [`Integer`](Integer.md) | Number of chip cores (0 on linux) |
| <span class="fmrb-name">`FLASH_SIZE_MB`</span> | [`Integer`](Integer.md) | Flash size in MB (0 on linux) |
| <span class="fmrb-name">`PSRAM_SIZE_MB`</span> | [`Integer`](Integer.md) | PSRAM size in MB (0 when none, and on linux) |
| <span class="fmrb-name">`RESET_REASON`</span> | [`String`](String.md) | Last reset reason ("-" on linux) |
| <span class="fmrb-name">`PROC_ID_KERNEL`</span> | [`Integer`](Integer.md) | Process ID of the Kernel (0) |
| <span class="fmrb-name">`PROC_ID_HOST`</span> | [`Integer`](Integer.md) | Process ID of the Host (1) |
| <span class="fmrb-name">`PROC_ID_SYSTEM_APP`</span> | [`Integer`](Integer.md) | Process ID of the system app (2) |
| <span class="fmrb-name">`PROC_ID_USER_APP0`</span> | [`Integer`](Integer.md) | Process ID of user app slot 0 (4) |
| <span class="fmrb-name">`PROC_ID_USER_APP1`</span> | [`Integer`](Integer.md) | Process ID of user app slot 1 (5) |
| <span class="fmrb-name">`PROC_ID_USER_APP2`</span> | [`Integer`](Integer.md) | Process ID of user app slot 2 (6) |
| <span class="fmrb-name">`PROC_ID_USER_APP3`</span> | [`Integer`](Integer.md) | Process ID of user app slot 3 (7) |
| <span class="fmrb-name">`PROC_ID_USER_APP4`</span> | [`Integer`](Integer.md) | Process ID of user app slot 4 (8) |
| <span class="fmrb-name">`PROC_STATE_FREE`</span> | [`Integer`](Integer.md) | App state: free (0) |
| <span class="fmrb-name">`PROC_STATE_INIT`</span> | [`Integer`](Integer.md) | App state: initialising (1) |
| <span class="fmrb-name">`PROC_STATE_RUNNING`</span> | [`Integer`](Integer.md) | App state: running (2) |
| <span class="fmrb-name">`PROC_STATE_SUSPENDED`</span> | [`Integer`](Integer.md) | App state: suspended (3) |
| <span class="fmrb-name">`PROC_STATE_STOPPING`</span> | [`Integer`](Integer.md) | App state: stopping (4) |
| <span class="fmrb-name">`MSG_TYPE_APP_CONTROL`</span> | [`Integer`](Integer.md) | Message type: app control (0) |
| <span class="fmrb-name">`MSG_TYPE_APP_GFX`</span> | [`Integer`](Integer.md) | Message type: drawing commands (1) |
| <span class="fmrb-name">`MSG_TYPE_APP_AUDIO`</span> | [`Integer`](Integer.md) | Message type: audio commands (2) |
| <span class="fmrb-name">`MSG_TYPE_HID_EVENT`</span> | [`Integer`](Integer.md) | Message type: input events (3) |

## Class methods

### FmrbConst.bt_mac

<pre class="fmrb-sig"><code>bt_mac() -&gt; <a href="../String/">String</a></code></pre>

The BLE address of this machine

**Some machines only know it after start-up** (when the radio is a separate chip it is unknown until BLE syncs).
Returns "-" while unknown and on linux. `MAC_ADDRESS` is the start-up value.
```ruby
FmrbConst.bt_mac   #=> "AA:BB:CC:DD:EE:FF"
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
