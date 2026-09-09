# Release Notes

What each release changed, newest first. Firmware comes from the
[installer](https://family-mruby.github.io/family-mruby-installer/); the version a machine
is running is in the system menu under About. [Studio](getting_started/studio.md) always
runs the newest one.

Every release replaces the whole flash image, `/home` included. Copy anything you want to
keep off the device before flashing — see [Console](getting_started/console.md).

## 2.1.0 — 2026-09-09

Applies to Modern, Retro, the simulator and Studio.

### New

- **Family mruby Studio.** The firmware is compiled to WebAssembly and published, so the
  desktop, the editor and the sound chip run in a browser tab with nothing installed.
  → [Studio](getting_started/studio.md)
- **The App Store.** It heads the launcher, fetches a published list over Wi-Fi, shows what
  fits on this machine and installs into `/app/usr`. On both boards and in the browser.
- **System services (Modern).** Small resident jobs: the clock sets itself from the network,
  the machine publishes its own address, and text can be read aloud. The list is a file you
  can edit. → [System Services](file_formats/services.md)
- **Colours you can change.** The window frame, the desktop, the editor and the shell take
  their colours from the system theme, and any of them can be overridden by name in
  `/home/colors.toml`. The shell has a `color` command that writes it for you.
  → [Colours](file_formats/colors.md)
- **One table decides which app opens a file.** A `.md` opens as a presentation, a `.nsf` in
  the music player, a `.rb` runs. → [File Associations](file_formats/associations.md)
- **New apps.** PicoRabbit presents a slide deck written in Markdown, Robo Explorer is a maze
  you solve by writing the robot's brain, and Modern gains a video player, a microphone
  spectrum and a readout of its motion sensor. → [Default Apps](getting_started/default_apps.md)
- **Japanese in the editor.** Kana input with `Ctrl` + `Space`, kanji on screen, and an editor
  that takes the whole screen.
- **Help on every method.** `F1` in the editor answers for all 577 of them, in two layers.
- **UI widgets.** Buttons, lists, checkboxes and the rest, for apps that want them.
  → [UI Widgets](api/ui.md)
- **`FmrbNet.request`.** Fetch something without stopping the app, with the same code on a
  board and in the browser. → [Network](api/network.md#fetching-without-stopping-fmrbnetrequest)
- **The mouse wheel.** The editor, the shell, the log and the file dialogs scroll with it.
- **Files and apps over Wi-Fi on Retro too.** `/fs` and `/app` answer on both machines now;
  only the screen is Modern's. → [Remote Desktop](remote_desktop.md#on-retro)
- **Each board names itself.** `fmruby-XXXXXX.local`, after its own MAC, and `fmruby.local`
  still answers. → [Connecting to Wi-Fi](getting_started/wifi.md#the-name-the-board-answers-to)
- **`boot_splash` and `startup_app`.** Skip the logo and the jingle, or open one app as soon
  as the desktop is up. → [The Desktop](getting_started/desktop.md#what-happens-before-the-desktop)
- **WAV playback (Modern).** `play_wav` mixes a file on top of the sound chip.
- **`/home` is yours.** The samples, sprites, sounds and decks moved to `/usr/share`, and
  `/home` ships empty. → [Files & I/O](api/filesystem.md#home-is-yours)

### Changed

- `on_event` no longer needs `super(ev)`. The base class keeps its own state in `@_`-prefixed
  names, and `@running` / `@name` are read through `running?` / `name`. Apps written against
  2.0 keep working: an old `super(ev)` reaches an empty method.
  → [FmrbApp](api/fmrb_app.md#what-the-app-can-read)
- The theme presets are `light`, `dark` and `cyberpunk`. `classic` is gone; what it named is
  `light`.
- The falling-block sample is BlockGame. Only the name changed.
- `flappy.rb` is `flappy.app.rb`, like every other app.
- Studio no longer offers colours on the page. Pick a theme in Config, inside the machine.
- Modern's app pool is 1024 KB, and 2048 KB with `large_memory = 1`. Retro is unchanged.
  → [Limitations](limitations.md#heap-size)
- `app_spawn_margin_kb` decides how much internal RAM a start has to leave for the rest of
  the machine. → [System Configuration](file_formats/system_conf.md)

### Updating

!!! warning "Retro has to be flashed on both chips"
    The protocol between the two chips went from 4 to 5, and the check is strict: a 2.0.x
    `fmruby-graphics-audio` against a 2.1.0 `fmruby-core` does not boot. Flash both from the
    [installer](https://family-mruby.github.io/family-mruby-installer/).
    → [Firmware Update](getting_started/firmware_update.md)

Modern is one chip and needs only the Tab5 firmware.

## 2.0.1 — 2026-08-08

A maintenance release. The flash image stopped carrying the caches a development machine
leaves behind, `[[launcher_exclude]]` hides whole app categories from the launcher, and
Retro's desktop wallpaper reaches the WROVER as it already did in the simulator.

Both chips are at protocol 4, as in 2.0.0, so a 2.0.0 board can take this on one chip.

## 2.0.0 — 2026-08-07

The release that added the second machine.

### New

- **Modern (ESP32-P4).** A stock M5Stack Tab5, flashed from the browser, with its own panel,
  speaker, touch screen and Wi-Fi. → [Modern](getting_started/modern.md)
- **Remote desktop.** The Tab5 serves its screen over Wi-Fi, and a browser on the same
  network drives it with a PC keyboard and mouse. → [Remote Desktop](remote_desktop.md)
- **FMRuby BASIC.** A Family BASIC-compatible interpreter with its own text screen, sprites
  and sound. → [MicroPython and BASIC](other_languages.md)
- **MicroPython.** A `.py` file runs as an ordinary app.
- **MIDI.** Serial MIDI out on the Tab5's GROVE port, MML from Ruby, and a player for
  standard MIDI files. → [MIDI](api/midi.md)
- **A debugger on the device.** Breakpoints and variables from the editor, and the same
  session over BLE or TCP from a PC. → [Debugging](debugging.md)
- **`Ctrl` + `Tab`.** Switch between the running apps, and park a fullscreen one where it
  stands. → [The Desktop](getting_started/desktop.md)
- **Per-app stack size.** `task_stack_kb` in `.app.toml`, for an app that needs more than the
  default. → [App Config](file_formats/app_toml.md)
- The Spinel ahead-of-time compiler became the standard engine for the kernel and the
  desktop, and the boot scan went from 13 s to 7.8 s.
- The filesystem took its current shape: `/app`, `/usr/share`, `/etc`, `/var` — `/data` is
  gone.
- Two fingers on the Tab5's touch screen are a right click.

### Updating

Retro has to be flashed on both chips: the protocol between them went from 3 to 4.

## 1.0.0 — 2026-05-19

The first release. Retro (the narya-board) with the desktop, the launcher, the editor, the
shell, tile maps and rounded windows, plus the sprite and map editors that run in a browser
on the PC side.
