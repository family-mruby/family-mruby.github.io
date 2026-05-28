# FmrbApp

!!! note
    Under construction.

`FmrbApp` is the application base class for Family mruby. User apps must inherit from `FmrbApp` and implement lifecycle methods.

## Minimal Example

```ruby
class MyApp < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello, mruby!", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end

  def on_update
    100  # Wait 100ms
  end
end

MyApp.new.start
```

Window size and other settings are specified in a `.toml` file (see [App Configuration File (.toml)](../file_formats/app_toml.md)).

## Lifecycle

| Method | When Called | Return Value Meaning |
|---|---|---|
| `on_create` | Once when the app starts | Any (ignored) |
| `on_update` | Repeatedly within the main loop | Wait time in milliseconds until the next `on_update`. Default 330ms |
| `on_event(ev)` | On keyboard / mouse / gamepad / HID input | Any |
| `on_suspend` | When switching to a fullscreen app | Any |
| `on_resume` | When returning from a suspended state | Any |
| `on_destroy` | Once when the app exits | Any |

```
start
  +-- on_create
       +-- main_loop:
            +-- on_update  -> wait for return value ms via _spin
            +-- _spin dispatches on_event(ev), _handle_system_control(msg)
            +-- repeats until @running becomes false
  +-- destroy -> on_destroy
```

!!! note "`on_update` return value"
    A short value (10-30ms) increases the frame rate but consumes more CPU. For games, 16-33ms is a good target; for static UIs, 100-500ms is appropriate.

## Event Handling (`on_event(ev)`)

`ev` is a Hash, and you determine the event type with `ev[:type]`.

### Keyboard

```ruby
def on_event(ev)
  case ev[:type]
  when :key_down
    keycode  = ev[:keycode]    # Character code (platform-dependent)
    scancode = ev[:scancode]   # USB HID Usage ID (platform-independent)
    modifier = ev[:modifier]   # Modifier key bits (see below)
    char     = ev[:character]  # Character (if available)
    Log.info("key down: #{char.inspect}")
  when :key_up
    # ...
  end
end
```

Modifier key bits (`ev[:modifier]`) layout:

| Bit | Value | Meaning |
|---|---|---|
| 0 | 0x01 | LSHIFT |
| 1 | 0x02 | RSHIFT |
| 2 | 0x04 | LCTRL |
| 3 | 0x08 | RCTRL |
| 4 | 0x10 | LALT |
| 5 | 0x20 | RALT |

Helper methods are provided:

```ruby
ev_ctrl?(ev)   # Ctrl is pressed
ev_shift?(ev)  # Shift is pressed
ev_alt?(ev)    # Alt is pressed
```

!!! note
    Use `scancode` when identifying character keys. `keycode` values vary between platforms (e.g. SDL2 returns ASCII values).

!!! tip "`FmrbConst::KEY_*` / `MOD_*` constants"
    Since `scancode` values are USB HID Usage IDs, you can use constants like `FmrbConst::KEY_ESC` instead of writing raw values like `0x29` (ESC). Modifier key mask constants such as `FmrbConst::MOD_CTRL` are also available. See [Constants > KEY_* / MOD_*](const.md#入力デバイス-キーボード-key_) for a full list.

### Mouse

```ruby
when :mouse_down, :mouse_up
  ev[:button]  # 1=left, 2=middle, 3=right
  ev[:x]       # X coordinate within the window
  ev[:y]       # Y coordinate within the window
when :mouse_move
  ev[:x], ev[:y]
```

Clicks on the title bar (left-click to close / right-click to reload) are already handled by the base class, so these actions work even if the subclass does not call `super`.

### Gamepad

```ruby
when :gamepad_down, :gamepad_up
  ev[:gamepad_id]  # 0 and above
  ev[:button]      # 0..15
when :gamepad_axis
  ev[:gamepad_id]
  ev[:axis]        # 0..5
  ev[:value]       # Axis value
```

!!! tip "`FmrbConst::GP_*` constants"
    Button numbers have constants like `FmrbConst::GP_SQUARE` / `GP_CROSS` / `GP_START`, and axis numbers have `GP_AXIS_LX` / `GP_AXIS_LY`, etc. See [Constants > GP_*](const.md#入力デバイス-ゲームパッド-gp_) for details.

## Window Operations

| Method | Purpose |
|---|---|
| `set_window_position(x, y)` | Change the window position |
| `draw_window_frame` | Draw the window frame (title bar + border). Reuses a `GfxBlock` managed by the base class |
| `clear_user_area(color = FmrbGfx::BLACK)` | Fill the drawable area (excluding title bar and border) with the specified color |
| `draw_scrollbar(scroll, total, visible, x=..., y=..., w=..., h=...)` | Draw a scrollbar |
| `scrollbar_hit(click_x, click_y, x=..., y=..., w=..., h=...)` | Scrollbar hit detection (returns `:up` / `:down` / `nil`) |
| `request_file_select(mode = "open")` | Invoke the system file selection dialog |
| `request_reload` | Reload the script (automatically called on title bar right-click) |

!!! tip "Use `clear_user_area` instead of `@gfx.clear`"
    `@gfx.clear(color)` fills the entire canvas, which also erases the title bar and close button. To preserve the window frame, use `clear_user_area(color)` instead.

## Messaging

| Method | Purpose |
|---|---|
| `subscribe(topic)` / `unsubscribe(topic)` | Subscribe to a topic |
| `publish(topic, data=nil)` | Send to a topic |
| `send_message(dest_pid, msg_type, data)` | Direct message to the kernel or a specific app. `data` is automatically serialized via MessagePack |

For details and receive handlers, see [Pub/Sub](pubsub.md).

## Execution Control

| Method | Purpose |
|---|---|
| `start` | Sets `@running = true` and starts the event loop (`on_create` is called) |
| `stop` | Sets `@running = false` (proceeds to `destroy` after the next `_spin`) |
| `destroy` | Notifies the kernel of exit, calls `@gfx.destroy`, `on_destroy`, `_cleanup` |

Normally, writing just `MyApp.new.start` is sufficient.

## Key Instance Variables

| Variable | Description |
|---|---|
| `@gfx` | `FmrbGfx` instance (drawing API; `nil` in headless mode) |
| `@audio` | `FmrbAudio` instance |
| `@name` | App display name (from `.toml` `app_screen_name`) |
| `@platform` | `:esp32` or `:linux` |
| `@fullscreen` | `true` if in fullscreen mode |
| `@window_width` / `@window_height` | Overall window size |
| `@pos_x` / `@pos_y` | Absolute coordinates of the window's top-left corner |
| `@user_area_x0` / `@user_area_y0` / `@user_area_x1` / `@user_area_y1` | Boundaries of the drawable area, excluding title bar and borders |
| `@user_area_width` / `@user_area_height` | Size of the drawable area |
| `@running` | `true` while the app is running |
| `@suspended` | `true` while suspended |

!!! tip "Drawing within the window frame"
    In windowed mode with a title bar, always draw within the `@user_area_*` bounds. Start from `@user_area_x0`, `@user_area_y0` and stay within `@user_area_width` and `@user_area_height`.

## File and Directory Paths

Pass root-relative paths (e.g. `/data/foo.txt`) or SD card paths like `/mnt/sd/...` directly to `File.open` / `Dir.open`. See [File & I/O > File Namespace](filesystem.md#ファイル名前空間) for details.

## Class Methods

| Method | Purpose |
|---|---|
| `FmrbApp.ps` | Array of Hash showing all process states (id, name, state, vm_type, mem_*, stack_water, etc.) |
| `FmrbApp.config(section)` | Read a specified section from the app's `.toml` |
| `FmrbApp.wallclock` | Current time (`{year, month, day, hour, minute, second}`) |
| `FmrbApp.set_wallclock(year, month, day, hour, minute, second)` | Set RTC / system time |
| `FmrbApp.gfx_stats` | Drawing statistics `{cmds:, presents:}` |
| `FmrbApp.sys_pool_info` | System memory pool information |
| `FmrbApp.heap_info` | ESP-IDF heap info (`free`, `total`, `min_free`, `largest_block`, etc.) |
| `FmrbApp.enable_cursor` | Show mouse cursor (delayed until the first mouse movement) |
| `FmrbApp.set_cursor_visible(visible)` | Immediately show/hide cursor. Useful for hiding in fullscreen games and restoring on exit |
| `FmrbApp._get_last_error` | Last app error (returns `{name:, error:}` if present) |

## Constants

| Constant | Value | Purpose |
|---|---|---|
| `TITLE_BAR_H` | 11 | Title bar height (px) |
| `CORNER_R` | 4 | Window corner radius |
| `TRANSPARENT_COLOR` | 0x01 | Transparent color (passes through during compositing) |
| `SCROLLBAR_W` | 10 | Scrollbar width |
| `SCROLLBAR_BTN_H` | 10 | Scrollbar button height |

## Example: Increment a Counter on Button Press

```ruby
class CounterApp < FmrbApp
  def on_create
    @count = 0
    redraw
  end

  def on_event(ev)
    super  # Inherit close button handling
    if ev[:type] == :mouse_down && ev[:button] == 1
      @count += 1
      redraw
    elsif ev[:type] == :key_down && ev[:character] == "r"
      @count = 0
      redraw
    end
  end

  def on_update
    300
  end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Count: #{@count}", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

CounterApp.new.start
```
