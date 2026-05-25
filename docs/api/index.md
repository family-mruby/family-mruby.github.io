# API Reference Overview

!!! note
    This page is under construction.

Lists all public Ruby APIs provided by Family mruby. Click each API name to jump to its detail page.

## Quick Reference

### Application

| Class / Module | Role | Details |
|---|---|---|
| `FmrbApp` | Application base class. Lifecycle, window, messaging | [FmrbApp](fmrb_app.md) |
| `FmrbGfx` | Shape and text drawing (`@gfx`) | [FmrbGfx](fmrb_gfx.md) |
| `SpriteImage` / `SpriteInstance` / `GfxBlock` | Sprites | [Sprite](sprite.md) |
| `TileSheet` / `TileMap` | Tile map rendering + fmrb_map JSON loading | [TileMap](tilemap.md) |
| `P5` | Processing/p5.js-style drawing DSL (`require "p5"`) | [P5](p5.md) |
| `FmrbAudio` | BGM, sound effects, tone synthesis (`@audio`) | [FmrbAudio](audio.md) |
| Pub/Sub (`subscribe` / `publish`) | Inter-app messaging | [Pub/Sub](pubsub.md) |

### Files and Data

| Class / Module | Role | Details |
|---|---|---|
| `IO` / `File` / `Dir` | File and directory operations | [File & I/O](filesystem.md) |
| `Log` | Logging | [Log](log.md) |
| `JSON` | JSON parsing and generation | [Utilities](utilities.md#json) |
| `MessagePack` | Binary serialization | [Utilities](utilities.md#messagepack) |
| `BMP332` | RGB332 BMP image parsing | [Utilities](utilities.md#bmp332) |
| `RX8900` | RTC (I2C-connected) driver | [Utilities](utilities.md#rx8900) |

### Hardware and System

| Class / Module | Role | Details |
|---|---|---|
| `GPIO` | Digital I/O | [Peripherals](peripherals.md#gpio) |
| `I2C` | I2C communication | [Peripherals](peripherals.md#i2c) |
| `RMT` | RMT (infrared, WS2812B, etc.) | [Peripherals](peripherals.md#rmt) |
| `FmrbConst` | System constants (version, theme colors, PROC_ID, etc.) | [Constants & System Info](const.md) |
| `FmrbHw` | Pin usage queries | [Constants & System Info](const.md#fmrbhw) |
| `Task` | Task control | [Task / Machine](system.md#task) |
| `Machine` | System control (clock, delay, reset, etc.) | [Task / Machine](system.md#machine) |

## Cross-Method Index

### `FmrbApp` (Lifecycle, Window, Messaging)

| Method | Summary |
|---|---|
| `initialize` | Framework initialization (prepares `@gfx`, `@user_area_*`, etc.) |
| `on_create` | Called once when the app starts (initialization logic) |
| `on_update` | Called every frame (return value = wait time in ms until next call) |
| `on_event(ev)` | Called on keyboard / mouse / gamepad / HID input |
| `on_suspend` / `on_resume` | Called when switching to/from a fullscreen app |
| `on_destroy` | Called once when the app exits |
| `start` / `stop` / `destroy` | Execution control |
| `subscribe(topic)` / `unsubscribe(topic)` / `publish(topic, data)` | Pub/Sub |
| `send_message(dest_pid, msg_type, data)` | Direct message sending |
| `set_window_position(x, y)` | Window position |
| `draw_window_frame` / `draw_scrollbar` / `scrollbar_hit` | Window decorations |
| `request_file_select(mode)` | File selection dialog |
| `request_reload` | Reload the app |
| `ev_ctrl?(ev)` / `ev_shift?(ev)` / `ev_alt?(ev)` | Modifier key checks |

### `FmrbGfx` (Drawing)

| Method | Summary |
|---|---|
| `clear(color)` / `present` | Clear / commit frame |
| `set_pixel(x, y, color)` | Draw a single pixel |
| `draw_line(x1, y1, x2, y2, color)` | Line |
| `draw_rect` / `fill_rect(x, y, w, h, color)` | Rectangle |
| `draw_round_rect` / `fill_round_rect(x, y, w, h, r, color)` | Rounded rectangle |
| `draw_circle` / `fill_circle(x, y, r, color)` | Circle |
| `draw_ellipse` / `fill_ellipse(x, y, rx, ry, color)` | Ellipse |
| `draw_triangle` / `fill_triangle(x0,y0,x1,y1,x2,y2,color)` | Triangle |
| `draw_arc` / `fill_arc(x, y, r0, r1, ang0, ang1, color)` | Arc |
| `blend_rect(x, y, w, h, color, mode:)` | Semi-transparent rectangle (mode: 0=ADD, 1=XOR) |
| `set_text_size(size)` | Text size (1 to 4) |
| `draw_text(x, y, text, color [, bg_color])` | Text drawing |
| `FmrbGfx.hsv_to_rgb(h, s, v)` | Color conversion |
| `FmrbGfx.rgb_to_332(r, g, b)` | 24-bit to RGB332 |
| `set_output_level(0..255)` / `set_chroma_level(0..255)` | NTSC output adjustment |

Color constants: `BLACK 0x00 / WHITE 0xFF / RED 0xE0 / GREEN 0x1C / BLUE 0x03 / YELLOW 0xFC / CYAN 0x1F / MAGENTA 0xE3 / GRAY 0x6D`

### `SpriteImage` / `SpriteInstance` / `GfxBlock`

| Class | Key Methods |
|---|---|
| `SpriteImage` | `new(gfx, w, h, trans_color, use_trans:)` / `load_bmp(path)` / `set_target` / `reset_target` / `destroy` |
| `SpriteInstance` | `new(gfx, frame_images, x, y, z_order)` / `move(x, y)` / `visible=` / `frame=` / `destroy` |
| `GfxBlock` | `new(gfx, kwargs) { |r, kwargs| ... }` / `draw(**kwargs)` / `destroy` |

### `FmrbAudio` (`@audio`)

| Method | Summary |
|---|---|
| `play(path, track: 0)` | Play a file |
| `stop` / `pause` / `resume` | Playback control |
| `load_fmsq(slot_id, binary)` | Load FMSQ into a slot |
| `play_slot(slot_id)` | Play a slot |
| `note_on(channel, freq, volume=10, duty=2, sweep=0)` | Tone synthesis |
| `note_off(channel)` | Stop tone |

### Pub/Sub

`subscribe(topic)` / `unsubscribe(topic)` / `publish(topic, data=nil)` / `send_message(dest_pid, msg_type, data)`

Messages are received via `_handle_system_control(msg)` through `on_control(msg)`, not `on_event`. See [Pub/Sub](pubsub.md) for details.

### `IO` / `File` / `Dir`

`File.open(path, mode, &block)`, `File.exist?` / `file?` / `directory?` / `size` / `delete`, `Dir.open(path)` / `Dir.read` / `Dir.mkdir`, etc.

### `Log`

`Log.error(msg)` / `Log.warn(msg)` / `Log.info(msg)` / `Log.debug(msg)` (or shorthand `e` / `w` / `i` / `d`; two-argument form allows specifying a tag)

### `GPIO` / `I2C` / `RMT`

| API | Signature |
|---|---|
| `GPIO.new(pin, flags)` | `flags` = OR combination of `GPIO::IN`, `GPIO::OUT`, `GPIO::PULL_UP`, etc. |
| `I2C.new(unit:, frequency: 100_000, sda_pin:, scl_pin:, timeout: 500)` | `unit:` is e.g. `"ESP32_I2C0"` |
| `RMT.new(pin, t0h_ns:, t0l_ns:, t1h_ns:, t1l_ns:, reset_ns:)` | NRZ encoding timing |

### `FmrbConst` / `FmrbHw`

Key constants: `PLATFORM`, `PROC_ID_KERNEL`, etc., `MSG_TYPE_*`, `OS_VERSION`, `MAC_ADDRESS`, `THEME_*`.
`FmrbHw.pin_status(pin)` / `pin_available?(pin)` / `pin_status_all` / `pin_count`.

### `Task` / `Machine`

`Task.pass`, `Machine.delay_ms(ms)`, `Machine.uptime_us`, `Machine.set_hwclock(epoch)`, `Machine._reboot`.

!!! warning
    `sleep` (Kernel) may stall when used outside `_spin` because tick does not advance. Use `Machine.delay_ms` for short waits (see [Limitations](../limitations.md)).

## Key Instance Variables (when inheriting `FmrbApp`)

| Variable | Description |
|---|---|
| `@gfx` | `FmrbGfx` instance |
| `@canvas` | Canvas ID |
| `@audio` | `FmrbAudio` instance |
| `@name` | App display name (from `.toml` `app_screen_name`) |
| `@platform` | `:esp32` / `:linux` |
| `@fullscreen` | Whether the app is in fullscreen mode |
| `@window_width` / `@window_height` | Overall window size |
| `@user_area_x0` / `@user_area_y0` / `@user_area_x1` / `@user_area_y1` | Boundaries of the drawable area for the app (window coordinate system) |
| `@user_area_width` / `@user_area_height` | Size of the drawable area |
| `@pos_x` / `@pos_y` | Top-left coordinates of the window (screen coordinate system). Changes when the window is moved |

In `@fullscreen` mode, `(@pos_x, @pos_y)` is `(0, 0)`, pointing at the top-left of the screen.

## Coordinate System and Color Format

- Coordinate system: origin at top-left (0, 0), X increases rightward, Y increases downward
- Color: RGB332 (8-bit, R:3 G:3 B:2). Use constants like `FmrbGfx::WHITE` or generate with `FmrbGfx.rgb_to_332(r, g, b)`

## Drawing Flow

```
Drawing commands (fill_rect, etc.)
  | Accumulated in buffer
@gfx.present
  | Applied to screen
```

!!! warning "Nothing appears until `present` is called"
    Drawing methods are not displayed on screen until `@gfx.present` is called. Sprite operations such as `SpriteInstance#move` are also composited at the `present` timing.
