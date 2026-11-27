# Limitations

## Security

**Nothing on this machine is access-controlled.** The network features were built for a
hobby machine on a home network, and they assume everyone who can reach the device is
welcome to use it.

| | |
|---|---|
| **Remote desktop** | No authentication. Anyone on the same network can open the address, watch the screen and send keyboard and mouse input — that is, operate the machine |
| **The file and app endpoints beside it** | Also unauthenticated, and in the released build. Anyone who can reach the remote desktop can also list, read, write and delete files, and start or stop apps |
| **BLE console and debug service** | Starts at boot by default on Retro and on Modern (Tab5, NARYA v4); turn it off with the BLE Auto Start setting (`ble_auto_start`). The headless AtomS3R and StickS3 run it only in setup mode. While it runs it uses no pairing, no bonding and no encryption (deliberately, because pairing breaks Web Bluetooth on Windows): anyone in radio range can connect, look at running apps and their variables, start or stop them, read the log, and read and write ordinary files. It cannot be stopped without a reboot |
| **Remote debugger over TCP** | No authentication. It listens on all interfaces |
| **Wi-Fi credentials** | Stored in plain text on the device, in `/home/wifi.toml` (what the Wi-Fi page writes) or `/etc/wifi.toml`. 3.0.0's remote file services do not serve them over HTTP. In the development version they do: the file endpoints reach every path, keys and passwords included, so that `/home` can be backed up and restored over Wi-Fi. Over BLE they are readable only while BLE Setup is open on the machine |
| **Service keys** | An API key for the speech service sits in plain text in `/home/secrets.toml`, kept like the Wi-Fi password: in the development version the file endpoints serve it over HTTP too, as they serve the rest of `/home` |
| **Apps** | An app you download runs with the same rights as any other. There is no sandbox between apps and the filesystem |

Use these features only on a network you trust, and at your own risk. Do not forward a port
to the device from the internet. Wi-Fi can be kept off at boot with `wifi_auto_start` in
Config, and BLE likewise with `ble_auto_start` (BLE Auto Start); once BLE is running it
cannot be stopped without a reboot.

## Differences from R2P2

Family mruby is based only on the core part of PicoRuby, and some gems used in PicoRuby's official R2P2 have been independently rewritten.
As a result, there may be differences in the available classes and method behavior.

## Differences Between PicoRuby and CRuby

PicoRuby is based on mruby, so some methods that are standard in CRuby may not be available.

## Heap Size

Each Family mruby app runs as an independent Ruby VM, with its own heap and stack allocated on PSRAM.

| Item | Retro, StickS3, AtomS3R | Modern | Linux simulator, Linux program | Studio |
|---|---|---|---|---|
| Standard app heap | 500 KB | 1024 KB | 1536 KB | 1536 KB |
| Heap with `large_memory = 1` | 1024 KB | 2048 KB | 3072 KB | 3072 KB |
| User apps at a time | 3 | 5 | 5 | 5 |
| `large_memory` apps at a time | 2 | 1 | 1 | 1 |

`max_apps` in [system_conf.toml](file_formats/system_conf.md) lowers the number of user
apps. The pool does not grow: an app runs out when no single free block is large enough,
which can happen well before the total is used up. The Linux builds are 64-bit and need
about 1.5 times the room for the same script, so they are about as tight as Modern; Studio
is looser than any board, so check a large app on a board too.

You can check heap usage in the Monitor app.

## Language support status

| Language | Status |
|---|---|
| Ruby (PicoRuby) | The main language. Everything documented here |
| MicroPython | Usable, with real limits: one Python app at a time, files read and written only whole (`FmrbFile`), strings that are bytes, and a smaller standard library. Drawing, sprites and sound are there. See [MicroPython](languages/micropython.md) |
| BASIC | Feature-complete as of 2.0. Every known difference from Family BASIC V3 is catalogued. See [FMRuby BASIC](languages/basic.md) |
| Lua | A concept implementation. Not suitable for building a substantial application |
| C, TinyGo, Rust, Zig | As [WebAssembly apps](languages/wasm.md), experimental, in the development version. Not on the ESP32-S3 boards (Retro, StickS3, AtomS3R). The SDK's names and shapes may still change |

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
| microSD | Read and written through the P4's SDMMC host, at `/mnt/sd` (also `/sd`). There is no card-detect line, so a card is assumed to be in |
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

### Headless boards (M5Stack StickS3, AtomS3R)

| | |
|---|---|
| Desktop | None. The board runs the one app named in `startup_app` (Welcome, as shipped) on its small screen (StickS3 240 x 135, AtomS3R 128 x 128) |
| Setting up Wi-Fi | Over BLE from the [Family mruby Console](getting_started/console.md): power on with the button held to enter setup mode. With no Wi-Fi settings at all the board starts in setup mode by itself. BLE runs only in setup mode |
| Apps at a time | Three, as on Retro (see [Heap Size](#heap-size)) |

### Studio (the browser build)

| | |
|---|---|
| Network | `FmrbNet.request` fetches through the browser, so a server that refuses cross-origin requests cannot be read. Sockets — `Net::HTTP`, WebSocket — are not there |
| Files | `/home` and `/app/usr` are kept in the browser and nowhere else, and so are the settings. Everything outside them is built fresh on every reload. Download the archive to keep anything |
| Browsers | Desktop Chrome and Firefox. Safari is untested; phones and tablets are not a target, because the machine wants a keyboard |
| One tab | Open the page twice and only the first tab saves |

See [Family mruby Studio](getting_started/studio.md).
