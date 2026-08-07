# Limitations

## Differences from R2P2

Family mruby is based only on the core part of PicoRuby, and some gems used in PicoRuby's official R2P2 have been independently rewritten.
As a result, there may be differences in the available classes and method behavior.

## Differences Between PicoRuby and CRuby

PicoRuby is based on mruby, so some methods that are standard in CRuby may not be available.

## Heap Size

Each Family mruby app runs as an independent Ruby VM, with its own heap and stack allocated on PSRAM.

| Item | Guideline / Limit |
|---|---|
| Standard app heap | 500 KB |
| Heap with `large_memory = 1` | 1000 KB |
| Number of concurrent apps | 3 |

You can check heap usage in the Monitor app.

## Language support status

| Language | Status |
|---|---|
| Ruby (PicoRuby) | The main language. Everything documented here |
| BASIC | Feature-complete as of 2.0. Every known difference from Family BASIC V3 is catalogued. See [BASIC and MicroPython](other_languages.md) |
| MicroPython | Usable, with real limits: one Python app at a time, built-in modules only, no `open()`, 256 KB heap. See [BASIC and MicroPython](other_languages.md) |
| Lua | A concept implementation. Not suitable for building a substantial application |

## Waiting inside an app

Prefer `Machine.delay_ms`, which is FreeRTOS `vTaskDelay` underneath:

```ruby
Machine.delay_ms(500)
```

Better still, do not block at all: return the number of milliseconds until you want to be
called again from `on_update`, and let the message pump do the waiting. An app that blocks
processes no events while it does.

!!! note "This was worse before 2.0"
    In 1.0 the tick that drives PicoRuby's task switching had to be disabled: calling it
    from outside the VM corrupted the VM stack. That is fixed — ticks are now accumulated
    by a signal source and applied at one point in the scheduler — and the Task feature
    works. The `Machine.delay_ms` recommendation above is about not blocking, not about the
    old corruption.

## File System Limitations

| Item | Details |
|---|---|
| Maximum file size | Within LittleFS limits (a few MB recommended) |
| Maximum path length | `FmrbConst::MAX_PATH_LEN` |
| File names | ASCII recommended. Avoid Japanese characters and special symbols |
| `Dir#seek` / `Dir#tell` | Not supported (`ENOSYS`). Use `rewind` and count from the beginning |

## Inter-App Message Size Limit

The payload for [Pub/Sub](api/pubsub.md) `publish` / `send_message` is limited to 176 bytes after MessagePack encoding. If you exceed this limit, consider transferring data via files or splitting it across multiple messages.

## Machine-specific limitations

Most limits apply to both machines. These do not.

### Modern (M5Stack Tab5)

| | |
|---|---|
| microSD | The slot is not wired up in the firmware yet. Internal flash only |
| Video out | The built-in panel is the only output. No composite video |
| GROVE | One port, not two |
| Battery-backed clock | Present (RX8130), but set the time once from **Set Clock** |

### Retro (narya-board)

| | |
|---|---|
| Wi-Fi and BLE | One radio, one at a time. Running the BLE console means Wi-Fi will not start, and vice versa |
| Touch | No touch panel. A USB mouse is the pointer |
| Remote desktop | Not available |
| Firmware | Two chips to flash, and both must be on the same version or the system will not boot |
