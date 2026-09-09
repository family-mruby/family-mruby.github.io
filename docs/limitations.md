# Limitations

## Security

**Nothing on this machine is access-controlled.** The network features were built for a
hobby machine on a home network, and they assume everyone who can reach the device is
welcome to use it.

| | |
|---|---|
| **Remote desktop** | No authentication. Anyone on the same network can open the address, watch the screen and send keyboard and mouse input — that is, operate the machine |
| **The file and app endpoints beside it** | Also unauthenticated, and in the released build. Anyone who can reach the remote desktop can also list, read, write and delete files, and start or stop apps |
| **BLE console and debug service** | No pairing, no bonding, no encryption (deliberately, because pairing breaks Web Bluetooth on Windows). Anyone in radio range can read and write files, read the log, and start or stop apps |
| **Remote debugger over TCP** | No authentication. It listens on all interfaces |
| **Wi-Fi credentials** | Stored in plain text in `/etc/wifi.toml` on the device |
| **Service keys** | An API key given to the speech service sits in plain text in `services.toml`, and the development build serves `/home` over HTTP |
| **Apps** | An app you download runs with the same rights as any other. There is no sandbox between apps and the filesystem |

Use these features only on a network you trust, and at your own risk. Do not forward a port
to the device from the internet. Wi-Fi can be kept off at boot with `wifi_auto_start` in
Config, and on Retro BLE likewise with `ble_auto_start`; on Modern BLE always starts at
boot and cannot be stopped while the machine is on.

## Differences from R2P2

Family mruby is based only on the core part of PicoRuby, and some gems used in PicoRuby's official R2P2 have been independently rewritten.
As a result, there may be differences in the available classes and method behavior.

## Differences Between PicoRuby and CRuby

PicoRuby is based on mruby, so some methods that are standard in CRuby may not be available.

## Heap Size

Each Family mruby app runs as an independent Ruby VM, with its own heap and stack allocated on PSRAM.

| Item | Retro | Modern | Studio |
|---|---|---|---|
| Standard app heap | 500 KB | 1024 KB | 1536 KB |
| Heap with `large_memory = 1` | 1024 KB | 2048 KB | 3072 KB |
| User app slots | 5, and how many fill depends on the memory the machine has. `max_apps` in [system_conf.toml](file_formats/system_conf.md) lowers it | | |

You can check heap usage in the Monitor app.

## Language support status

| Language | Status |
|---|---|
| Ruby (PicoRuby) | The main language. Everything documented here |
| MicroPython | Usable, with real limits: one Python app at a time, no writing files, strings that are bytes, and a smaller standard library. Drawing, sprites and sound are there. See [MicroPython and BASIC](other_languages.md) |
| BASIC | Feature-complete as of 2.0. Every known difference from Family BASIC V3 is catalogued. See [MicroPython and BASIC](other_languages.md) |
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
| Battery-backed clock | Present (RX8130). The `timesync` [service](file_formats/services.md) sets it from the network once the machine is online; **Set Clock** is the manual way |

| Mouse wheel | A USB mouse's wheel works only for a device named in [`/etc/hid_devices.toml`](file_formats/hid_devices.md#the-wheel). Plug the mouse in and the log prints the line to add |

### Retro (narya-board)

| | |
|---|---|
| Wi-Fi and BLE | One radio, one at a time. Running the BLE console means Wi-Fi will not start, and vice versa |
| Touch | No touch panel. A USB mouse is the pointer |
| Remote desktop | Not available |
| Firmware | Two chips to flash, and both must be on the same version or the system will not boot |
| Resident services | Not carried in the Retro firmware. The clock, network and speech services are Modern only |
| WAV playback | `play_wav` returns `false`. The audio is at the far end of a serial link, and shipping a clip across it before a note could sound is too slow to be worth it |
| Mouse wheel | The same per-device rule as Modern |

### Studio (the browser build)

| | |
|---|---|
| Network | `FmrbNet.request` fetches through the browser, so a server that refuses cross-origin requests cannot be read. Sockets — `Net::HTTP`, WebSocket — are not there |
| Files | `/home` and `/app/usr` are kept in the browser and nowhere else, and so are the settings. Everything outside them is built fresh on every reload. Download the archive to keep anything |
| Browsers | Desktop Chrome and Firefox. Safari is untested; phones and tablets are not a target, because the machine wants a keyboard |
| One tab | Open the page twice and only the first tab saves |

See [Family mruby Studio](getting_started/studio.md).
