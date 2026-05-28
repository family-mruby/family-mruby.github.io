# Log

!!! note
    Under construction.

The `Log` module is an API for outputting logs from applications. Output logs are stored in the system's log buffer and also flow to UART and the console (if connected).

## Output Methods

```ruby
Log.error("something failed")
Log.warn("low battery")
Log.info("user clicked")
Log.debug("x=#{x}")
```

Short forms are also available:

```ruby
Log.e("err")
Log.w("warn")
Log.i("info")
Log.d("debug")
```

### Tagged Output (2-argument form)

You can pass a tag as the first argument and a message as the second.

```ruby
Log.info("MyApp", "started")
Log.error("Net", "connection refused")
```

| Method | Signature |
|---|---|
| `Log.error(msg)` / `Log.error(tag, msg)` | Error |
| `Log.warn(msg)` / `Log.warn(tag, msg)` | Warning |
| `Log.info(msg)` / `Log.info(tag, msg)` | Info |
| `Log.debug(msg)` / `Log.debug(tag, msg)` | Debug |
| `Log.e` / `Log.w` / `Log.i` / `Log.d` | Short forms of the above |

## Level Constants

| Constant | Value |
|---|---|
| `Log::LEVEL_NONE` | 0 |
| `Log::LEVEL_ERROR` | 1 |
| `Log::LEVEL_WARN` | 2 |
| `Log::LEVEL_INFO` | 3 |
| `Log::LEVEL_DEBUG` | 4 |
| `Log::LEVEL_VERBOSE` | 5 |

## Level Control

```ruby
Log.set_level(Log::LEVEL_INFO)             # Set overall level to INFO and above
Log.set_level_for_tag("MyApp", Log::LEVEL_DEBUG)  # Override per tag
```

| Method | Purpose |
|---|---|
| `Log.set_level(level)` | Set overall log level |
| `Log.set_level_for_tag(tag, level)` | Override level for a specific tag |

## Buffer Access

Logs are kept in a ring buffer and can be read back later. This is useful when writing apps like a Log Viewer.

| Method | Return Value |
|---|---|
| `Log.read_lines(max_lines = nil, level = nil)` | Array of lines |
| `Log.write_pos` | Current write position (sequence number) |
| `Log.set_buffer_level(level_str)` | Set the level retained in the buffer |
| `Log.buffer_level` | Get the buffer level |

```ruby
lines = Log.read_lines(20)   # Last 20 lines
lines.each { |line| puts line }
```

## Sample

```ruby
class MyApp < FmrbApp
  TAG = "MyApp"

  def on_create
    Log.info(TAG, "started, name=#{@name}")
  end

  def on_event(ev)
    super
    Log.debug(TAG, "event=#{ev[:type]}")
  end

  def on_destroy
    Log.info(TAG, "stopped")
  end
end
```

## Notes

!!! warning "Log output overhead"
    Using `Log.debug` in frequently called places like `on_update` consumes CPU and UART bandwidth. In production, it is recommended to limit logging to `LEVEL_INFO` and above.

!!! note
    `puts` / `print` (Kernel) output goes to the console (UART). In the long run, writing via `Log` is preferable, as it provides level control, tagging, and buffer access.

## Related

- Direct ESP_LOG output from the C side is not recommended (in the OS manifest, use the `fmrb_log.h` wrapper instead). From the Ruby side, always use `Log`.
