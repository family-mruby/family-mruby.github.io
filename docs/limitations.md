# Limitations

!!! note
    This page is under construction.

This page summarizes constraints, differences from standard Ruby, and common pitfalls that users are likely to encounter when writing apps. If your app is not behaving as expected, check here first.

## Memory and PSRAM Constraints

Each Family mruby app runs as an independent Ruby VM, with its own heap and stack allocated on PSRAM.

| Item | Guideline / Limit |
|---|---|
| Standard app heap | A few hundred KB |
| Heap with `large_memory = 1` | Larger allocation (several MB) |
| Number of concurrent apps | Depends on available memory. Decreases when `large_memory` is enabled |
| Message payload | Up to 176 bytes (after MessagePack encoding) |

### Working with Large Data

- Store images and audio as files on flash / SD, and open them when needed
- When exchanging data between apps, either `publish` the file path or write to a file and read from it

### Checking Memory Usage

```ruby
info = FmrbApp.heap_info
Log.info("free=#{info[:free]} largest_block=#{info[:largest_block]}")
```

You can also check the overall pool status with `FmrbApp.sys_pool_info`.

### PSRAM Stack and DMA

There is a hardware constraint that prevents PSRAM regions from being passed directly to DMA (for SPI flash and some peripherals). Family mruby internally uses SRAM-backed buffers through a mechanism called `hw_proxy`, but keep this in mind if you write your own C extensions.

## Differences Between PicoRuby and CRuby

Differences that are easy to trip over when assuming "it should work just like regular Ruby":

### `File.binread` / `File.read` (class methods) are not available

PicoRuby does not have the `File.binread` or `File.read(path)` shortcuts.

```ruby
# NG (raises an exception)
data = File.binread("/img.bmp")

# OK
data = File.open("/img.bmp", "r") { |f| f.read }
```

### Parallel assignment with array elements

Parallel assignments that include array elements on the left-hand side, such as `a[i], a[j] = a[j], a[i]`, may not work correctly in PicoRuby.

```ruby
# Risky: may produce incorrect results
a[i], a[j] = a[j], a[i]

# Safe: swap using a temporary variable
tmp = a[i]
a[i] = a[j]
a[j] = tmp
```

### Use `::JSON.parse` when using JSON

The JSON library is available, but writing `JSON.parse` inside a class causes PicoRuby's constant lookup to search for `JSON` within the class first, which fails. It is safer to prefix with `::` as in `::JSON.parse(...)`. See [Utilities > JSON](api/utilities.md#json) for details.

### IO Behavior

- The concepts of `STDIN` / `STDOUT` are generally not available (use drawing APIs when not in headless mode)
- `Kernel#puts` / `print` output to the console (UART), but using [`Log`](api/log.md) is recommended for the long term

## Task / sleep Pitfalls

### `sleep_ms` may hang

The Kernel `sleep_ms` (provided by PicoRuby) may stop progressing outside of `_spin` (i.e., in independent tasks outside the `FmrbApp` main loop) because ticks do not advance.

```ruby
# NG: may hang inside an independent task
sleep_ms(500)

# OK: based on FreeRTOS vTaskDelay
Machine.delay_ms(500)
```

Within a normal `on_update`, the standard approach is to specify the wait time via the return value of `on_update`:

```ruby
def on_update
  do_work
  100   # wait 100ms until the next on_update
end
```

### When to Use `Task.pass`

When running long loops, insert `Task.pass` to yield control to other tasks.

```ruby
1000.times do |i|
  heavy_compute(i)
  Task.pass if i % 10 == 0
end
```

## File System Limitations

| Item | Details |
|---|---|
| Maximum file size | Within LittleFS limits (a few MB recommended) |
| Maximum path length | `FmrbConst::MAX_PATH_LEN` |
| File names | ASCII recommended. Avoid Japanese characters and special symbols |
| `Dir#seek` / `Dir#tell` | Not supported (`ENOSYS`). Use `rewind` and count from the beginning |

## mruby Tick

`mruby_tick_task` is disabled; Ruby tasks only progress within the `_spin` loop.

- The frequency at which `on_update` is called depends on the argument to `_spin(timeout_ms)`
- Running Ruby code from an independent task (equivalent to `Thread`) exposes the `sleep_ms` issue described above

There are no issues as long as you follow the standard pattern of inheriting from `FmrbApp` and implementing `on_update`.

## Graphics Constraints

### Nothing is displayed without calling `@gfx.present`

```ruby
@gfx.fill_rect(...)
@gfx.draw_text(...)
@gfx.present       # nothing appears without this
```

You also need to call `present` after sprite operations (such as `SpriteInstance#move`), because compositing happens at the time `present` is called.

### `GfxBlock` Constraints

`GfxBlock` caches drawing command sequences as bytecode on the WROVER side, so the number of instructions within a block must not change.

```ruby
# NG: number of instructions changes based on kwargs
GfxBlock.new(@gfx, n: 5) do |r, n:|
  n.times { r.fill_rect(0, 0, 5, 5, 0xFF) }
end

# OK: number of instructions is fixed, only coordinates change
GfxBlock.new(@gfx, x: 0) do |r, x:|
  r.fill_rect(x, 0, 5, 5, 0xFF)
end
```

See [Sprite > GfxBlock](api/sprite.md#gfxblock) for details.

## Inter-App Message Size Limit

The payload for [Pub/Sub](api/pubsub.md) `publish` / `send_message` is limited to 176 bytes after MessagePack encoding. If you exceed this limit, consider transferring data via files or splitting it across multiple messages.

## File Selection Dialog Limitation

`request_file_select(mode)` can only be called from one app at a time. If multiple apps try to open it simultaneously, the kernel will reject the request.

## Related

- Lifecycle details: [FmrbApp](api/fmrb_app.md)
- Proper waiting methods: [Task / Machine](api/system.md)
- Memory visualization: `FmrbApp.heap_info` / `FmrbApp.sys_pool_info` ([FmrbApp](api/fmrb_app.md#class-methods))
