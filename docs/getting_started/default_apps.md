# Default Apps

Everything below ships on the device. Open the Launcher from the system menu (or press
`L` on the desktop) and double-click an icon.

<div align="center">
  <img src="../../images/tab5_launcher.png" width="600" alt="The launcher">
</div>

!!! tip "The list is built at boot"
    The launcher scans for apps once, when the desktop starts. After you add a file,
    **right-click inside the launcher window** to rescan.

Apps live under `/app`, grouped into directories. What follows is grouped the same way.

## Always there

These are not in the launcher grid — they are the system's own apps, reachable from the
system menu or by pressing a letter on the desktop.

| App | Key | What it does |
|---|---|---|
| Launcher | `L` | The app grid |
| Shell | `S` | A command line |
| Editor | `E` | Write, run (`F5`) and debug your code |
| File Manager | | Browse the flash filesystem |
| Log Viewer | | The system log |
| Monitor | | Running tasks and memory |
| HID Inspector | `I` | Works out the report layout of a misbehaving USB mouse and writes it to [`/etc/hid_devices.toml`](../file_formats/hid_devices.md) |

## Demos — `/app/demo`

| App | What it shows |
|---|---|
| **Ruby app demo** | The Ruby app framework, as a starting point to copy |
| **Python** | The same, written in MicroPython |
| **Lua app demo** | The same, in Lua |
| **BASIC app demo** | A BASIC program launched as an ordinary app |
| **Shapes** | Drawing primitives |
| **Bounce** | Sprite movement |
| **P5 Test** | The [P5](../api/p5.md) drawing API |
| **JA Text** | Japanese text rendering with the bundled fonts |
| **Kamon** | Generates Japanese family crests from five motifs with rotational symmetry |
| **Weather** | Fetches a forecast over HTTPS and draws it — the [network API](../api/network.md) end to end |
| **MIDI APU** | Plays the built-in sound chip through the [MIDI](../api/midi.md) layer, switchable to an external instrument |
| **MML** | The same tune on the APU or an external instrument, written as MML text |
| **StackChan** | A parametric face with expressions and emotes |
| **StackChan Remote** | The same face, driven over [pub/sub](../api/pubsub.md) |
| **PubDemo** / **SubDemo** | A publisher and a subscriber, to run together |
| **LED Matrix** | Drives a WS2812B matrix from the GROVE port |
| **I2C Kbd** | Reads an I2C keyboard |

## Games — `/app/game`

| App | |
|---|---|
| **RPG Demo** | A tile world with smooth scrolling, collisions, BGM and sound effects |
| **Raycaster** | A Wolfenstein-style first-person demo. Keyboard or gamepad |
| **Tetris** | |
| **Shooter** | |
| **Piano** | Play the sound chip from the keyboard |

<div align="center">
  <img src="../../images/tab5_rpg_demo.png" width="600" alt="The RPG demo running on a Tab5">
</div>

## Tools — `/app/tool`

| App | What it does |
|---|---|
| **SMF Player** | Plays standard MIDI files, with a file list. Songs are in `/usr/share/sounds/midi` |
| **NSF Player** | Plays NSF (Famicom sound) files from `/usr/share/sounds/nsf` |
| **Sprite Editor** | Edits a 16x16 RGB332 tile sheet: load a BMP, pick a tile, edit pixels, save back |
| **PicoRabbit** | A fullscreen presentation tool, reading PicoRabbit-compatible Markdown |
| **GPIO Viewer** | Live pin status for every GPIO, colour-coded by what is using it |
| **Net Test** | Exercises the networking API piece by piece. Useful when something will not connect |

## BASIC samples — `/app/basic`

Six programs in [FMRuby BASIC](../other_languages.md), runnable and readable:

| App | |
|---|---|
| **Kana** | The character screen and kana rendering |
| **Dodge** | Avoid the obstacles |
| **Shoot** | A shooting game |
| **Maze** | |
| **Music** | `PLAY` and `BEEP` |
| **Hit** | Collision detection |

## Test and diagnostic apps

`/app/debug` and `/app/test` hold apps that exist to exercise or break something on purpose
— an app that raises, one that fails to compile, one that saturates the input queue, MIDI
timing benchmarks, an NTSC colour chart, SD card and tile-map checks. They are shipped
because they are useful when a device misbehaves, not because they do anything for you day
to day.

## Machine-specific apps

Most apps run on both machines. A few depend on hardware only one of them has:

| App | Note |
|---|---|
| **NTSC Test** | Retro only — it adjusts the composite video output |
| **SD Test** | Retro only — Modern's microSD is not wired up in the firmware yet |
| **Weather**, **Net Test** | Need Wi-Fi configured. See [Network](../api/network.md) |
| **LED Matrix**, **I2C Kbd** | Need something wired to the GROVE port |

## Related

- [Hello World](hello_world.md) — write your own
- [App Config (.app.toml)](../file_formats/app_toml.md) — how an app gets into the launcher
- [Examples](../examples.md) — annotated code
