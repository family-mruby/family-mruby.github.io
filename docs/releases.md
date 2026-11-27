# Release Notes

What each release changed, newest first. Firmware comes from the
[installer](https://family-mruby.github.io/family-mruby-installer/); the version a machine
is running is in the system menu under About. [Studio](getting_started/studio.md) always
runs the newest one.

Every release replaces the whole flash image, `/home` included. Copy anything you want to
keep off the device before flashing — see [Console](getting_started/console.md).

## In development (after 3.0.0)

Not in a release yet: this is what the development branch — and [Studio](getting_started/studio.md),
which is built from it — does now. These pages describe it.

### Changed: writing an app

Apps written for 3.0.0 need small changes:

- **No start code at the end of the file.** The runtime starts the `FmrbApp` subclass the
  file defines; delete the trailing `MyApp.new.start` (and its `begin`/`rescue`). A file with
  more than one subclass names the one to start with `class = "MyApp"` in its metadata. A file
  where none can be picked, or an exception while starting, shows the reason in an error
  window. → [Hello World](getting_started/hello_world.md)
- **`@gfx` draws from the top-left of the app's own area.** Inside the frame of a framed
  window, the window's top-left without a frame, the screen's in fullscreen. `@user_area_x0`
  and `@user_area_y0` are gone: drop the `@user_area_x0 +` additions. Mouse `ev[:x]` /
  `ev[:y]`, sprites and UI widgets use the same origin; `ev[:wx]` / `ev[:wy]` and `window_gfx`
  are there for the window's own coordinates. → [Drawing](api/fmrb_gfx.md#coordinate-system)
- **System methods moved to `FmrbSystem`.** The 34 class methods that change the machine
  (`reboot`, `set_wallclock`, the Wi-Fi, BLE, power and volume settings ...) are
  `FmrbSystem.<name>` now; `FmrbApp.<name>` keeps the ones an app reads.
  → [Application](api/fmrb_app.md#system-settings-fmrbsystem)
- `clear_time` is `clear_timer`.
- **Metadata in the `.rb`.** The `.app.toml` keys can also go in a `#---fmrb` comment at the
  top of the file; with both, a key in the `.app.toml` wins.
  → [App Config](file_formats/app_toml.md#metadata-in-the-rb-file)
- **Lua apps** run on a shell the system provides: define `on_create` / `on_update` /
  `on_event` and draw with the global `gfx`. → [Lua](languages/lua.md)
- **Lua and MicroPython follow Ruby's argument order.** Lua's `gfx:draw_text` is
  `(x, y, text, color)`, and the sizes are functions: `FmrbApp.user_area_width()`,
  `user_area_height()`, `window_width()`, `window_height()`. In MicroPython,
  `_fmrb.read_file` and `_fmrb.file_size` gave way to `FmrbFile`, and `gfx.clear()` needs its
  colour. → [Other languages](languages/index.md)

### New

- **Kanji conversion** in kana input, with a dictionary on the SD card.
  → [The Desktop](getting_started/desktop.md#kana-input)
- **Wi-Fi from the screen.** The Network dialog opens a Wi-Fi page: pick a network, type the
  password; up to five are remembered and the strongest in reach is joined.
  → [Connecting to Wi-Fi](getting_started/wifi.md)
- **The window menu.** Right-click a title bar for Send to, Reload and Close.
- **Frameless windows** (`window_frame = "none"`), with the Avatar sample.
  → [App Config](file_formats/app_toml.md#frameless-windows)
- **Asterism wire protocol 2** (the asterism gem 0.14.0): connections are objects, topics
  carry declared types, and a shared place holds data with no single owner. Not compatible
  with 3.0.0 on the wire. → [Network](api/network.md#asterism-objects-and-topics-across-machines)
- **Sending files and apps between machines** over Asterism, with the Receiving app deciding
  whether, and from whom, this machine takes them. In the Shell, `move` is now `amove`, beside
  `asend`, `anodes` and `areceive`. → [Shell Commands](getting_started/shell.md#moving-apps-and-files-between-machines)
- **The Linux program**: a CRT look for the whole screen, Log Out in the power menu, touchpad
  taps and touch screens, routers with TLS, and an arm64 package.
  → [The Linux Program](getting_started/linux.md)
- **WebAssembly apps.** Apps written in C, TinyGo, Rust or Zig and compiled to WebAssembly
  run on WAMR on the ESP32-P4 boards, the Linux program, the simulator and Studio (not on
  the ESP32-S3 boards), with the same functions Ruby apps have. The SDK is
  [family-mruby-sdk](https://github.com/family-mruby/family-mruby-sdk); the same tour app in
  each language ships under `/app/tinygo`, `/app/rust`, `/app/zig` and `/app/c`, and an app
  dropped on the Studio page runs there. → [WebAssembly Apps](languages/wasm.md)
- **One definition for every language.** The functions apps call are generated from the
  firmware's type definitions for Ruby, Lua, MicroPython and WebAssembly alike. Lua gained
  sound, the log, the clipboard, the clocks, the window's state and files; MicroPython gained
  the rest of `FmrbGfx` (arcs, `get_pixel`, masks, `blend_rect` ...), `FmrbApp.uptime_ms()`
  and 64-bit integers. → [Other languages](languages/index.md)
- **`FmrbFile`**: read, write, append, list and delete whole files by path, the same in every
  language. → [Files & I/O](api/filesystem.md#whole-files-by-path-fmrbfile)
- **A new boot.** The logo comes on like a CRT television, over a chord that rises a fifth,
  and the desktop is up in about 1.2 seconds instead of 2.7.
  → [The Desktop](getting_started/desktop.md#what-happens-before-the-desktop)
- The error window closes with `Return` or `Esc` as well as a click. The Monitor has a page
  for the WebAssembly runtime, `ps` in the Shell has an ENGINE column, and the launcher has an
  icon per language.
- **Smaller storage.** Sprites, tile sheets, wallpapers and icons are palette PNGs
  (`SpriteImage#load_bmp` and `TileSheet` read PNG as well as BMP), and the voices are
  IMA-ADPCM WAVs, which `play_wav` plays. On the ESP32-P4 boards the Japanese fonts moved to a
  partition of their own. → [Image & Icon Files](file_formats/image_formats.md),
  [Sound](api/audio.md#playing-a-recording-play_wav), [Hardware](hardware.md#storage-modern)
- **`/home` over Wi-Fi.** The file endpoints reach every path, keys included, so `/home` can
  be backed up before flashing and put back after.
  → [Remote Desktop](remote_desktop.md#files-and-apps-over-wi-fi),
  [Security](limitations.md#security)
- `/app/test` and Walk Scroller are left out of every board's image and the public browser
  build; they can be sent to a board over Wi-Fi.

## 3.0.0 — 2026-11-07

Applies to Modern, Retro, the headless boards, the Linux program and Studio.

### New

- **The Linux program.** Family mruby as one program on a Linux PC: an amd64 `.deb` on the
  GitHub release (Ubuntu 26.04 or newer), chosen at the login screen.
  → [The Linux Program](getting_started/linux.md)
- **Headless boards.** M5Stack StickS3 and AtomS3R run a single app on an Asterism network,
  flashed from the Web Installer.
- **Moving a running app.** An app that declares `movable = true` can be written to an image
  and carried on from it, on the same machine or another one.
  → [Application](api/fmrb_app.md#moving-a-running-app)
- **Asterism.** Machines on one network call each other's Ruby objects, with a game host for
  shared tables: Hide Jong (mahjong), Othello and a drawing board.
  → [Default Apps](getting_started/default_apps.md#games--appgame)
- **A high-resolution fullscreen.** An app with `fullscreen_hires = true` runs at 640x360 while
  it is fullscreen on Modern and in Studio.
- **Mute and volume.** A speaker in the menu bar mutes the whole machine with one click, and
  Config has a volume from 0 to 10. Both are remembered, on every machine and in Studio.
  → [The Desktop](getting_started/desktop.md#sound)
- **Icons on the desktop.** The Launcher, the Editor, the Shell, the File Manager and a few
  apps sit on the wallpaper; the launcher's right-click menu adds and removes them.
  → [The Desktop](getting_started/desktop.md#icons-on-the-desktop)
- **A power button** at the right end of the menu bar. Reset moved there from the system
  menu.
- **BLE Setup.** A few minutes, opened on the machine, in which the web console may read and
  write the Wi-Fi and Asterism settings and the keys; outside it they are never read
  remotely. The speech service's API key moved from the service list to `/home/secrets.toml`.
  → [System Services](file_formats/services.md#speech)
- **The editor's font.** View → Font picks 8, 12 or 16 pixels, kept in `/home/editor.toml`.
- **One clipboard** for every app, joined to the PC's in the Linux program and to the page's in
  Studio. `FmrbApp.clipboard` / `FmrbApp.set_clipboard`.
- **Small helpers for app screens.** `fit_text`, `wrap_text`, `draw_text_lines` and
  `draw_button` on `@gfx`, and `FmrbUI::HitAreas` for a screen drawn whole.
  → [Drawing](api/fmrb_gfx.md#fitting-text-into-a-width), [UI Widgets](api/ui.md#click-targets-for-a-screen-drawn-whole-fmrbuihitareas)
- **Settings and state for apps.** `app_settings` (in `/home`) and `app_state` (in `/tmp`); the
  File Manager reopens in the folder it was closed in.
  → [Application](api/fmrb_app.md#settings-and-remembered-state)
- `FmrbAudio#main_volume=` sets the volume of the music alone. → [Sound](api/audio.md#the-musics-own-volume)
- Resizable windows show a triangle in the bottom-right corner to drag. The File Manager asks
  before it deletes.
- The launcher's rescan is a **Reload** button in its title bar (or `F5`).

### Changed

- **App memory on the ESP32-S3 boards.** Three pools in all — one ordinary and two large — so
  three user apps run at a time. → [Limitations](limitations.md#heap-size)
- The Wi-Fi settings are read from `/home/wifi.toml` first, then `/etc/wifi.toml`.
- HTTPS on the boards trusts a trimmed set of root certificates instead of the full bundle.

### Updating

The core and the graphics-audio firmware must be the same version: on Retro, flash both
chips. The kanji dictionary for the development branch's kanji conversion is not part of
3.0.0.

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
  and sound. → [FMRuby BASIC](languages/basic.md)
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
