# Family mruby Documentation

<div align="center">
  <img src="../images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## What is Family mruby?

Family mruby is a small computer that boots straight into a Ruby programming environment.

Plug in a keyboard and a mouse, connect a screen, and you get a desktop, a launcher, an
editor, and a shell — all running on a single microcontroller. Everything you write runs
on the same machine you write it on. There is no PC toolchain in the loop, no cross
compiler, no flashing cycle: press F5 in the editor and your program starts.

It is built on [PicoRuby](https://github.com/picoruby/picoruby) and ships with its own
multitasking OS, so several apps can run side by side, each in its own isolated heap.

## Two machines, one system

Version 2.0 runs on two very different pieces of hardware. The same Ruby app runs on both.

|  | **Modern** | **Retro** |
|---|---|---|
| Hardware | [M5Stack Tab5](https://docs.m5stack.com/en/core/Tab5) | [narya-board](https://github.com/family-mruby/narya-board) (dedicated board) |
| Main chip | ESP32-P4 (dual-core RISC-V) + ESP32-C6 | ESP32-S3 + ESP32-WROVER |
| Screen | Built-in 1280x720 IPS panel, MIPI-DSI | NTSC composite out, to a CRT or a capture device |
| Framebuffer | 426 x 240, scaled 3x onto the panel | 320 x 240 |
| Sound | Built-in speaker, headphone jack | 3.5 mm line out |
| Input | USB keyboard & mouse, capacitive touch, Tab5 Keyboard | USB keyboard & mouse |
| Network | Wi-Fi / BLE via the on-board ESP32-C6 | Wi-Fi / BLE on the ESP32-S3 |
| Extras | Browser remote desktop over Wi-Fi, GROVE port | RCA video, 2x GROVE, battery-backed RTC |

**Modern** is the machine you build things on: it is self-contained, it has a screen in the
lid, and you can drive its desktop from a browser on your PC over Wi-Fi.

**Retro** is the machine you play on: real NTSC composite video into a CRT, the 256-colour
picture and the NES-style 4-channel sound chip that goes with it.

Not sure which to read? See [Choose your hardware](getting_started/choose_hardware.md).

<div align="center">
  <img src="../images/tab5_desktop.png" width="640" alt="The Family mruby desktop on an M5Stack Tab5">
  <br><em>The desktop, running on an M5Stack Tab5</em>
</div>

## What's new in 2.0

**A second machine.** Family mruby now runs on the M5Stack Tab5 — one ESP32-P4 doing
graphics, sound, input and the OS by itself, with capacitive touch, the Tab5 Keyboard,
Japanese fonts, and the built-in speaker.
→ [Modern (M5Stack Tab5)](getting_started/modern.md)

**Your screen, in a browser.** Modern serves its own desktop over Wi-Fi. Open the device's
address on your PC and you can watch it and drive it with your PC's keyboard and mouse.
→ [Remote Desktop](remote_desktop.md)

**Ruby on the network.** A CRuby-shaped networking API — `Net::HTTP`, WebSocket and TLS —
so an app can talk to the internet in a few lines. Works on both machines.
→ [Network](api/network.md)

**Music out.** A MIDI layer that plays through the built-in sound chip *or* out of the
GROVE port to an external synth, an SMF (standard MIDI file) player, and MML for Ruby apps.
→ [MIDI](api/midi.md)

**Two more languages.** `.bas` files run on FMRuby BASIC, a Family BASIC-compatible
interpreter with its own text screen and sprites. `.py` files run on an embedded
MicroPython. Both launch as ordinary apps, next to the Ruby ones.
→ [BASIC and MicroPython](other_languages.md)

**Debugging that reaches the device.** Set breakpoints from VS Code over TCP or BLE, or use
the debugger built into the on-device editor.
→ [Debugging](debugging.md)

**A faster, quieter system.** The kernel is now ahead-of-time compiled to native code, which
cut input latency; the desktop boot dropped from about 20 seconds to about 6; and the
desktop no longer allocates in its steady state, so it stops stealing time from the app you
are actually running.

## Demo Video

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Getting the hardware

**Modern** runs on a stock [M5Stack Tab5](https://docs.m5stack.com/en/core/Tab5) — no
modification, no soldering. Flash it from your browser and it boots.

**Retro** needs the narya-board, available on [BOOTH](https://booth.pm/ja/items/8128031).
The schematics, Gerber data and BOM are all public, so you can also build a compatible
board yourself.

## Where to go next

- [Choose your hardware](getting_started/choose_hardware.md) — the differences that matter
- [Modern (M5Stack Tab5)](getting_started/modern.md) — from an unboxed Tab5 to the desktop
- [Setup (Retro)](getting_started/setup.md) — cabling and first boot on the narya-board
- [Hello World](getting_started/hello_world.md) — your first app
- [Simulator](getting_started/simulator.md) — run the whole system on Linux, no hardware needed
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
