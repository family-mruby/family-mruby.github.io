# Family mruby Documentation

<div align="center">
  <img src="/images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## What Family mruby is

A small computer that comes up as a Ruby development environment when you switch it on.

Plug in a keyboard and a mouse, connect a screen, and you get a desktop, a launcher, an
editor and a shell. What you write runs on the machine you wrote it on: no toolchain on a
PC, no cross-compiler, no flash-and-try cycle. Press `F5` in the editor and it runs.

<div align="center">
  <img src="/images/photo_editor_run.jpg" width="620" alt="The editor with flappy.app.rb open, and the game it started running in the next window">
  <br><em>The editor and an app it started, side by side on the real screen</em>
</div>

It is built on [PicoRuby](https://github.com/picoruby/picoruby), with an OS of our own on
top. Several apps run at once, each with its own memory.

## Four ways to run it

Version 2.1 runs in four places, and the same Ruby app runs in all of them.

| | What it is | How to get it | Screen | Sound | Network |
|---|---|---|---|---|---|
| Modern | M5Stack Tab5 (ESP32-P4 + ESP32-C6) | Buy one and flash it from a browser | Built-in 1280x720 panel | Built-in speaker | Wi-Fi and BLE together |
| Retro | narya-board (ESP32-S3 + ESP32-WROVER) | BOOTH, or build your own | NTSC composite out | 3.5mm line out | Wi-Fi or BLE, one at a time |
| Simulator | Linux (Docker) | Free, and needs no hardware | A window on your PC | Your PC's sound | Through the host |
| Studio | A browser (WebAssembly) | Open a URL | In the page, up to 852x480 | In the page | Fetching through the page only |

The machines proper are the two boards. The simulator is where this system is developed,
and an app written there behaves as it does on hardware. [Studio](getting_started/studio.md)
is the same firmware compiled to WebAssembly, so the desktop and the editor can be tried
with nothing at all.

A dedicated ESP32-P4 board (NARYA v4) is being designed; it is not part of this release.

## The two machines

|  | **Modern** | **Retro** |
|---|---|---|
| Hardware | [M5Stack Tab5](https://docs.m5stack.com/en/core/Tab5) | [narya-board](https://github.com/family-mruby/narya-board) (a board of our own) |
| Main chips | ESP32-P4 (dual-core RISC-V) + ESP32-C6 | ESP32-S3 + ESP32-WROVER |
| Screen | The built-in 1280x720 IPS panel (MIPI-DSI) | NTSC composite out, to a CRT or a capture device |
| Framebuffer | 426 x 240, scaled 3x to the panel | 320 x 240 |
| Sound | Built-in speaker and a headphone jack | 3.5mm line out |
| Input | USB keyboard and mouse, capacitive touch, the Tab5 Keyboard | USB keyboard and mouse |
| Network | Wi-Fi and BLE through the on-board ESP32-C6 | The ESP32-S3's own Wi-Fi and BLE |
| Also | Drive the screen from a browser over Wi-Fi, one GROVE port | RCA video out, two GROVE ports, a battery-backed clock |

Modern is the machine for making things. It is self-contained, its screen is its lid, and a
browser on your PC can drive it over Wi-Fi.

Retro is the machine for playing with. It puts real NTSC composite video on a CRT, 256
colours, and the four-voice sound that goes with them.

If you are not sure which to read about, start with
[Choose your hardware](getting_started/choose_hardware.md).

<div align="center">
  <img src="/images/photo_two_machines.jpg" width="700" alt="Retro on the left, Modern on the right, running the same shell">
  <br><em>Retro on the left (a narya-board on a monitor), Modern on the right (an M5Stack Tab5). The shell is the same one</em>
</div>

## What's new in 2.1

Colours you can change. The window frame, the desktop, the editor and the shell all take
their colours from the system theme now, and any of them can be overridden by name in
`/home/colors.toml`. The shell has a `color` command that writes it for you.
→ [Colours](file_formats/colors.md)

Things the machine does by itself. Modern runs a handful of small resident services: the
clock sets itself from the network, the machine publishes its own address, and anything can
be read aloud. They are listed in a file you can edit, and you can add your own.
→ [System Services](file_formats/services.md)

Your files, kept apart from ours. `/home` is yours and starts empty. The samples, sprites,
sounds and decks that ship with the firmware live under `/usr/share`, and nothing the machine
ships ever lands in `/home`.
→ [Files & I/O](api/filesystem.md#home-is-yours)

One table decides which app opens a file. A `.md` opens as a presentation, a `.nsf` in the
music player, a `.rb` runs. The table is a file, and any line of it can be overridden.
→ [File Associations](file_formats/associations.md)

A shop for apps. The App Store sits at the head of the launcher: it fetches a published
list over Wi-Fi, shows what fits on this machine, and installs into `/app/usr`, where the
launcher finds it. It runs on both boards and in the browser.
→ [Default Apps](getting_started/default_apps.md#always-there)

New apps. PicoRabbit presents a slide deck written in Markdown, Robo Explorer is a maze you
can only solve by writing the robot's brain, and Modern gains a video player, a microphone
spectrum and a readout of its motion sensor.
→ [Default Apps](getting_started/default_apps.md)

A desktop you can drive. The taskbar lists the open windows, the menu bar works from the
keyboard, `Ctrl+Tab` cycles through the desktop as well as the apps, and the mouse wheel
scrolls the editor, the shell, the log and the file dialogs.
→ [The Desktop](getting_started/desktop.md)

Files over Wi-Fi. The remote desktop can list, fetch, upload and delete files on the device,
so a program can go onto the machine without a cable.
→ [Remote Desktop](remote_desktop.md)

In a browser. The firmware is also compiled to WebAssembly, so the desktop, the editor and
the sound chip run in a browser tab with nothing installed. Files you make there stay in the
browser and can be carried out as an archive; files and folders can be dropped in, and a
folder on your disk can be linked so that what you edit outside reaches the machine.
→ [Family mruby Studio](getting_started/studio.md)

## Demo Video

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Getting the hardware

Modern runs on a stock [M5Stack Tab5](https://docs.m5stack.com/en/core/Tab5) — no
modification, no soldering. Flash it from your browser and it boots.

Retro needs the narya-board, available on [BOOTH](https://booth.pm/ja/items/8128031).
The schematics, Gerber data and BOM are all public, so you can also build a compatible
board yourself.

## Where to go next

- [Choose your hardware](getting_started/choose_hardware.md) — the differences that matter
- [Modern (M5Stack Tab5)](getting_started/modern.md) — from an unboxed Tab5 to the desktop
- [Setup (Retro)](getting_started/setup.md) — cabling and first boot on the narya-board
- [Hello World](getting_started/hello_world.md) — your first app
- [Connecting to Wi-Fi](getting_started/wifi.md) — remote desktop and networking
- [Simulator](getting_started/simulator.md) — run the whole system on Linux, no hardware needed
- [Family mruby Studio](getting_started/studio.md) — the same system in a browser tab
- [API Reference](api/index.md) — what your app can call

## Repositories

- [Firmware](https://github.com/family-mruby/family-mruby)
- [Board Data](https://github.com/family-mruby/narya-board)
- [Firmware Installer](https://github.com/family-mruby/family-mruby-installer)

## Development Background

Long ago, BASIC was often the first programming language that children encountered. Despite
its limitations, there were products like Family BASIC, which allowed BASIC programming not
only on PCs but also on platforms such as the MSX or the Famicom (NES). Many programmers
discovered the joy of programming through these environments.

Today, development environments for most programming languages are freely available and
easily installable on PCs. However, because so much is possible, beginners often don't know
where to start. Even reaching the point where you can make something slightly beyond "Hello
World," such as a simple game, can require a surprisingly high setup cost.

Family mruby was born from the desire to create an environment where you can build small
games and other applications using a scripting language on a single microcontroller --
bringing back the joy of simple, immediate programming.
