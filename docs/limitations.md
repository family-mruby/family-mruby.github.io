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

## Lua and BASIC Support Status

The current Lua and BASIC support is a concept implementation and is not suitable for building full-fledged applications.

## Task / sleep Constraints

In the current version, calling the tick processing (`mrb_tick`) needed for PicoRuby's task switching from a context outside the mruby VM can corrupt the VM stack, so it is temporarily disabled. As a result, the following constraints apply.

Tick handling is planned to be addressed in the future.

### `sleep_ms` may hang

The Kernel `sleep_ms` (provided by PicoRuby) may stop progressing outside of `_spin` (i.e., in independent tasks outside the `FmrbApp` main loop) because ticks do not advance.

Use `Machine.delay_ms` instead.

```ruby
# NG: may hang inside an independent task
sleep_ms(500)

# OK: based on FreeRTOS vTaskDelay
Machine.delay_ms(500)
```

### Task feature constraints

Since `mrb_tick` is called within `on_update`, it is possible to drive the Task feature by looping `on_update` at a high frequency, but this may cause unexpected behavior.
(The Editor and Shell apps make use of the Task feature.)

## File System Limitations

| Item | Details |
|---|---|
| Maximum file size | Within LittleFS limits (a few MB recommended) |
| Maximum path length | `FmrbConst::MAX_PATH_LEN` |
| File names | ASCII recommended. Avoid Japanese characters and special symbols |
| `Dir#seek` / `Dir#tell` | Not supported (`ENOSYS`). Use `rewind` and count from the beginning |

## Inter-App Message Size Limit

The payload for [Pub/Sub](api/pubsub.md) `publish` / `send_message` is limited to 176 bytes after MessagePack encoding. If you exceed this limit, consider transferring data via files or splitting it across multiple messages.
