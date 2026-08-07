# Examples

An introduction to the apps bundled under `/app/`. Each one demonstrates specific APIs and features, so try running them first and use the source code as a reference when building your own apps.

Source file locations:

- On the device: `/app/<category>/<name>.app.rb`
- In the repository: `fmruby-core/flash/app/<category>/<name>.app.rb`
- Configuration: `<name>.app.toml`, next to it

A full list of what ships, including the BASIC and MicroPython samples, is in
[Default Apps](getting_started/default_apps.md).

## Demo (demo)

Sample apps that showcase basic features.

| App | Description | APIs Covered |
|---|---|---|
| `mruby.app.rb` | Minimal mruby verification sample | `FmrbApp`, `FmrbGfx` basics |
| `shapes.app.rb` | Comprehensive shape drawing demo (rectangles, circles, ellipses, triangles, arcs, text) | [`FmrbGfx`](api/fmrb_gfx.md) |
| `ja_text.app.rb` | Japanese text rendering. Switches between Default / misaki_8 / efontJA_12 / Mixed / Hybrid / Scaled | [`FmrbGfx#set_font`](api/fmrb_gfx.md#japanese-text-font-switching) |
| `p5_test.app.rb` | Demo of a Processing/p5.js-style drawing library (basic shapes / affine transforms / Bezier curves / text / blend / get_pixel) | [P5](api/p5.md) |
| `i2c_kbd.app.rb` | Reading input from an I2C keyboard (address `0x5F`) | [`I2C`](api/peripherals.md#i2c) + [Pub/Sub](api/pubsub.md) |
| `led_matrix.app.rb` | Controlling a WS2812B 8x8 RGB LED matrix + on-screen preview | [`RMT`](api/peripherals.md#rmt), Pub/Sub |
| `pub_demo.app.rb` + `sub_demo.app.rb` | Minimal inter-app Pub/Sub pair | [Pub/Sub](api/pubsub.md) |
| `lua.app.lua` | Lua VM verification | -- |
| `basic.app.bas` / `bounce.app.bas` | BASIC VM verification | -- |

## Debug (debug)

Verification apps under `/app/debug/`.

| App | Description | APIs Covered |
|---|---|---|
| `ntsc_color_test.app.rb` | NTSC color bar output test | [`FmrbGfx#set_output_level`/`set_chroma_level`](api/fmrb_gfx.md#ntsc-output-adjustment-esp32-only) |
| `sd_test.app.rb` | Writes to `/mnt/sd/sd_test.txt`, reads back, and compares. Press Space to re-run | [File I/O > File Namespace](api/filesystem.md#file-namespace) |
| `tile_map_test.app.rb` | Map rendering with TileMap + TileSheet + JSON | [TileMap / TileSheet](api/tilemap.md) |
| `draw_tile_test.app.rb` | Minimal verification of `FmrbGfx#draw_tile` | [FmrbGfx > draw_tile](api/fmrb_gfx.md#draw_tile-usage) |

## Games (game)

| App | Description | APIs Covered |
|---|---|---|
| `flappy.rb` | Flappy Bird-style game. Tap to fly up, avoid obstacles | `FmrbGfx`, [`FmrbAudio` (note_on/off)](api/audio.md), gamepad |
| `tetris.app.rb` | Tetris-style falling block puzzle. Arrow key controls | `FmrbGfx`, board drawing patterns |
| `shooter.app.rb` | Full-screen shooter | [`Sprite`](api/sprite.md), collision detection |
| `raycaster.app.rb` | Wolfenstein 3D-style pseudo-3D. Requires `large_memory = 1` | Fixed-point arithmetic, high-speed `FmrbGfx` rendering |
| `piano.app.rb` | A piano you can play with the keyboard | [`FmrbAudio#note_on/off`](api/audio.md#audio-synthesis-note_on--note_off) |
| `rpg_demo/` | JRPG-style sample. Assets bundled in `/app/<cat>/<bundle>/` format | [TileMap / TileSheet](api/tilemap.md), `FmrbApp.set_cursor_visible` |

## Tools (tool)

| App | Description | APIs Covered |
|---|---|---|
| `gpio_viewer.app.rb` | Visualizes the usage status of all GPIO pins | [`FmrbHw.pin_status`](api/const.md#fmrbhw) |
| `nsf_player.app.rb` | NSF file playback GUI (skip, track selection, pause) | [`FmrbAudio#play`](api/audio.md), file selection |
| `picorabbit.app.rb` | Markdown slide presentation player | `PicoRabbit` |
| `sprite_editor.app.rb` | Sprite editor. Draw pixel art and save as BMP | [`Sprite`](api/sprite.md), `BMP332` |

## Recommended Learning Order

1. Read `mruby.app.rb` to understand the basic structure
2. Check `shapes.app.rb` to learn how to use `FmrbGfx`
3. Try `pub_demo.app.rb` / `sub_demo.app.rb` for inter-app messaging
4. Explore `piano.app.rb` for the audio API
5. Study `flappy.rb` for combining drawing + audio + input
6. Examine `tetris.app.rb` for a stateful game
7. Analyze `raycaster.app.rb` for large-scale app structure and optimization

## Starting Points for Your Own Apps

- For a minimal starting point: `mruby.app.rb`
- For window + drawing: `shapes.app.rb`
- For making a game: `tetris.app.rb` or `flappy.rb`
- For working with hardware: `i2c_kbd.app.rb` or `led_matrix.app.rb`

See [Hello World](getting_started/hello_world.md) for how to start a new app.

## Related

- How to create apps: [Hello World](getting_started/hello_world.md)
- Icon files: [Image and Icon Files](file_formats/image_formats.md#icon-files)
- App configuration: [App Configuration File (.toml)](file_formats/app_toml.md)
