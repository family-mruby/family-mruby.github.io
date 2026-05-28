# Task / Machine

!!! note
    This page is under construction.

Low-level APIs for task control and system control. Derived from `picoruby-machine`.

## Task

A module for working with FreeRTOS tasks from Ruby.

| Method | Purpose |
|---|---|
| `Task.pass` | Yield control to the scheduler (gives other tasks an opportunity to run) |

Within `FmrbApp#main_loop`, `Task.pass` is called after `on_update`, allowing other apps and the kernel to run.

```ruby
loop do
  do_some_work
  Task.pass
end
```

## Machine

Provides clock, delay, system reset, memory information, and more.

### Delay

| Method | Purpose |
|---|---|
| `Machine.delay_ms(ms)` | Wait for `ms` milliseconds using FreeRTOS `vTaskDelay` (returns: `ms`) |
| `Machine.busy_wait_ms(ms)` | Precise wait using a busy loop |
| `Machine.sleep(sec)` | Sleep for the specified number of seconds. Between 2 and 86400 seconds |
| `Machine.deep_sleep(sec)` | Deep sleep (not implemented) |

!!! warning "`sleep_ms` pitfall"
    Kernel's `sleep` / `sleep_ms` may stall when used outside `_spin` (in an independent task) because tick does not advance. Use `Machine.delay_ms` for short waits. See [Limitations](../limitations.md) for details.

### Clock

| Method | Purpose |
|---|---|
| `Machine.set_hwclock(unix_timestamp)` | Set a UNIX timestamp on the hardware clock |
| `Machine.get_hwclock` | Returns `[tv_sec, tv_nsec]` |

Normally, `FmrbApp.set_wallclock(year, month, ...)` is easier to use, and it calls `Machine.set_hwclock` internally.

### Uptime Information

| Method | Return Value |
|---|---|
| `Machine.uptime_us` | Elapsed time since boot in microseconds |
| `Machine.board_millis` | Elapsed time since boot in milliseconds |
| `Machine.uptime_formatted` | String format (`"hhh:mm:ss"`) |
| `Machine.unique_id` | Device unique ID string |

### Memory and Diagnostics

| Method | Purpose |
|---|---|
| `Machine.read_memory(addr, size)` | Read memory contents at the specified address |
| `Machine.stack_usage` | Stack usage (in bytes) |

### System Control

| Method | Purpose |
|---|---|
| `Machine.exit(status = 0)` | Exit the program |
| `Machine._reboot` | System reboot (not supported on POSIX) |

## Examples

### Displaying Uptime

```ruby
class UptimeView < FmrbApp
  def on_create
    redraw
  end

  def on_update
    redraw
    1000   # Every 1 second
  end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Uptime: #{Machine.uptime_formatted}",
                   FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

UptimeView.new.start
```

### Short Delay

```ruby
# OK: Safe wait using FreeRTOS task
3.times do |i|
  Log.info("step #{i}")
  Machine.delay_ms(500)
end

# NG: Using sleep_ms outside _spin can cause it to stall
# sleep_ms(500)  <- This may hang in an independent task
```

## Related

- For lifecycle control (controlling wait time via `on_update` return value), see [FmrbApp](fmrb_app.md#ライフサイクル)
- For sleep-related limitations, see [Limitations](../limitations.md)
