# Constants and System Info (FmrbConst / FmrbHw)

!!! note
    This page is under construction.

## FmrbConst

A module that provides constants referenced throughout the system.

### Platform Information

| Constant | Value |
|---|---|
| `FmrbConst::PLATFORM` | `"linux"` or `"esp32"` |
| `FmrbConst::OS_VERSION` | OS version string |
| `FmrbConst::GA_VERSION` | fmruby-graphics-audio version |
| `FmrbConst::LINK_VERSION` | UART link protocol version |
| `FmrbConst::IDF_VERSION` | ESP-IDF version |

### Hardware Information

| Constant | Description |
|---|---|
| `FmrbConst::MAC_ADDRESS` | MAC address string |
| `FmrbConst::CHIP_MODEL` | e.g. `"ESP32-S3"` |
| `FmrbConst::CHIP_REVISION` | Revision number |
| `FmrbConst::CHIP_CORES` | Number of cores |
| `FmrbConst::FLASH_SIZE_MB` | Flash capacity (MB) |
| `FmrbConst::PSRAM_SIZE_MB` | PSRAM capacity (MB) |
| `FmrbConst::RESET_REASON` | Reason for the last reset |

### Process Management

| Constant | Purpose |
|---|---|
| `FmrbConst::PROC_ID_KERNEL` | Kernel process ID |
| `FmrbConst::PROC_ID_HOST` | Host process ID |
| `FmrbConst::PROC_ID_SYSTEM_APP` | System app ID |
| `FmrbConst::PROC_ID_USER_APP0` / `USER_APP1` / `USER_APP2` | User app slots |

#### Process States

| Constant |
|---|
| `PROC_STATE_FREE` |
| `PROC_STATE_INIT` |
| `PROC_STATE_RUNNING` |
| `PROC_STATE_SUSPENDED` |
| `PROC_STATE_STOPPING` |

### Messaging

| Constant | Purpose |
|---|---|
| `MSG_TYPE_APP_CONTROL` | App control message |
| `MSG_TYPE_APP_GFX` | Graphics message |
| `MSG_TYPE_APP_AUDIO` | Audio message |
| `MSG_TYPE_HID_EVENT` | HID event (keyboard, etc.) |

#### App Control Commands

| Constant |
|---|
| `APP_CTRL_SPAWN` |
| `APP_CTRL_KILL` |
| `APP_CTRL_SUSPEND` |
| `APP_CTRL_RESUME` |

### Theme Colors (System-wide Color Scheme)

| Constant | Purpose |
|---|---|
| `THEME_DESKTOP_BG` | Desktop background |
| `THEME_MENU_BG` | Menu background |
| `THEME_WINDOW_BG` | Window background |
| `THEME_TEXT` | Normal text |
| `THEME_TEXT_LIGHT` | Light text |
| `THEME_HIGHLIGHT` | Highlight |
| `THEME_BORDER` | Border |
| `THEME_BUTTON` | Button |

These are all RGB332 values. Use them when you want your app's UI to match the OS color scheme.

### Input Device: Keyboard (`KEY_*`)

USB HID Usage IDs. Compare with `ev[:scancode]` in `on_event(ev)`.

| Category | Constants |
|---|---|
| Letters | `KEY_A` .. `KEY_Z` |
| Numbers | `KEY_1` .. `KEY_9`, `KEY_0` |
| Control | `KEY_ENTER`, `KEY_ESC`, `KEY_BACKSPACE`, `KEY_TAB`, `KEY_SPACE` |
| Symbols | `KEY_MINUS`, `KEY_EQUAL`, `KEY_LBRACKET`, `KEY_RBRACKET`, `KEY_BACKSLASH`, `KEY_SEMICOLON`, `KEY_QUOTE`, `KEY_GRAVE`, `KEY_COMMA`, `KEY_PERIOD`, `KEY_SLASH` |
| Locks | `KEY_CAPSLOCK`, `KEY_SCROLLLOCK`, `KEY_NUMLOCK` |
| Function | `KEY_F1` .. `KEY_F12` |
| Editing | `KEY_INSERT`, `KEY_HOME`, `KEY_PGUP`, `KEY_DELETE`, `KEY_END`, `KEY_PGDN` |
| Arrow | `KEY_LEFT`, `KEY_RIGHT`, `KEY_UP`, `KEY_DOWN` |
| Other | `KEY_PRINTSCREEN`, `KEY_PAUSE` |
| Modifier keys (individual) | `KEY_LCTRL`, `KEY_LSHIFT`, `KEY_LALT`, `KEY_LGUI`, `KEY_RCTRL`, `KEY_RSHIFT`, `KEY_RALT`, `KEY_RGUI` |

### Input Device: Modifier Key Masks (`MOD_*`)

Use bitwise AND with `ev[:modifier]` in `on_event(ev)` to check modifier state.

| Constant | Bit | Meaning |
|---|---|---|
| `MOD_LCTRL` | 0x01 | Left Ctrl |
| `MOD_LSHIFT` | 0x02 | Left Shift |
| `MOD_LALT` | 0x04 | Left Alt |
| `MOD_LGUI` | 0x08 | Left GUI (Win / Cmd) |
| `MOD_RCTRL` | 0x10 | Right Ctrl |
| `MOD_RSHIFT` | 0x20 | Right Shift |
| `MOD_RALT` | 0x40 | Right Alt |
| `MOD_RGUI` | 0x80 | Right GUI |
| `MOD_CTRL` | 0x11 | Combined left/right Ctrl (`MOD_LCTRL | MOD_RCTRL`) |
| `MOD_SHIFT` | 0x22 | Combined left/right Shift |
| `MOD_ALT` | 0x44 | Combined left/right Alt |
| `MOD_GUI` | 0x88 | Combined left/right GUI |

!!! tip "`ev_ctrl?(ev)` / `ev_shift?(ev)` / `ev_alt?(ev)`"
    You can also check modifiers using `FmrbApp` helpers. Using `MOD_*` directly is only needed for special cases; normally use the helpers instead.

### Input Device: Gamepad (`GP_*`)

In `on_event(ev)`, when `ev[:type] == :gamepad_down` / `:gamepad_up`, `ev[:button]` holds the button number. When `ev[:type] == :gamepad_axis`, `ev[:axis]` holds the axis number.

#### Buttons

| Constant | Value | Meaning |
|---|---|---|
| `GP_SQUARE` | 0 | Square |
| `GP_CROSS` | 1 | Cross |
| `GP_CIRCLE` | 2 | Circle |
| `GP_TRIANGLE` | 3 | Triangle |
| `GP_L1` | 4 | Left shoulder |
| `GP_R1` | 5 | Right shoulder |
| `GP_L2` | 6 | Left trigger |
| `GP_R2` | 7 | Right trigger |
| `GP_SELECT` | 8 | Select |
| `GP_START` | 9 | Start |
| `GP_L3` | 10 | Left stick press |
| `GP_R3` | 11 | Right stick press |
| `GP_UP` | 12 | D-pad up |
| `GP_DOWN` | 13 | D-pad down |
| `GP_LEFT` | 14 | D-pad left |
| `GP_RIGHT` | 15 | D-pad right |

#### Axes

| Constant | Value | Meaning |
|---|---|---|
| `GP_AXIS_LX` | 0 | Left stick X |
| `GP_AXIS_LY` | 1 | Left stick Y |
| `GP_AXIS_RX` | 2 | Right stick X |
| `GP_AXIS_RY` | 3 | Right stick Y |

### Sample: Key Detection

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

### Other

| Constant | Description |
|---|---|
| `MAX_PATH_LEN` | Maximum path length |

### Sample: Display Version and Environment

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

A module for querying the usage status of hardware resources (especially GPIO pins).

| Method | Return Value |
|---|---|
| `FmrbHw.pin_status(pin)` | Pin usage state (`Integer`, 0 = unused, other = usage-specific identifier) |
| `FmrbHw.pin_available?(pin)` | `true` if unused |
| `FmrbHw.pin_status_all` | `Array<Integer>` (index = pin number, value = status) |
| `FmrbHw.pin_count` | Total number of pins |

The value from `pin_status` is an internal identifier: 0 = unused, anything else = in use by another function such as "GPIO", "I2C", "UART", etc.

### Sample: Display All Pins

```ruby
status = FmrbHw.pin_status_all
status.each_with_index do |s, i|
  Log.info("pin #{i}: #{s == 0 ? 'free' : 'used'}")
end
```

### Sample: Check Before Use

```ruby
PIN = 10
unless FmrbHw.pin_available?(PIN)
  Log.error("Pin #{PIN} is in use (status=#{FmrbHw.pin_status(PIN)})")
  return
end
gpio = GPIO.new(PIN, GPIO::OUT)
```

There is a sample in `tool/gpio_viewer.app.rb` that visualizes pin states with a GUI.

## Related

- For pin specifications (electrical characteristics, external connections), see [Hardware](../hardware.md)
- For GPIO usage, see [Peripherals](peripherals.md#gpio)
