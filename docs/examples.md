# Examples

An introduction to the apps bundled under `/app`. Each one exercises a particular part of
the API, so run it first and then read its source when you write your own.

Where the source is:

- On the device: `/app/<category>/<name>.app.rb`
- In the repository: `fmruby-core/flash/app/<category>/<name>.app.rb`
- Its configuration: `<name>.app.toml`, beside it

A full list of what ships, in every language, is in
[Default Apps](getting_started/default_apps.md).

## Ruby demos — `/app/demo`

| App | What it shows | API |
|---|---|---|
| `picoruby.app.rb` | Every drawing, font, sprite, sound and P5 feature the framework has, one page at a time. The first one to read | [`FmrbGfx`](api/fmrb_gfx.md), [Sprites](api/sprite.md), [P5](api/p5.md), [`FmrbAudio`](api/audio.md), [`FmrbUI`](api/ui.md) |
| `kamon.app.rb` | Japanese family crests from five motifs, with a panel of widgets to compose them | [`FmrbUI`](api/ui.md), `FmrbGfx` |
| `piano.app.rb` | An octave played from the keyboard, with the channel and the sweep on a panel | [`FmrbAudio#note_on` / `note_off`](api/audio.md#tone-synthesis-note_on--note_off) |
| `mml.app.rb` | The same tune on the internal chip or an external instrument, written as MML and loaded from a file | [MIDI](api/midi.md), MML |
| `midi_apu.app.rb` | The internal chip driven through the MIDI layer | [MIDI](api/midi.md) |
| `weather.app.rb` | A forecast fetched over HTTPS and drawn. The network API end to end | [Network](api/network.md) |
| `pub_demo.app.rb` + `sub_demo.app.rb` | The smallest publisher and subscriber, to run together | [Pub/Sub](api/pubsub.md) |
| `stackchan.app.rb` + `stackchan_remote.app.rb` | A parametric face, and the same face driven from another app | `FmrbGfx`, [Pub/Sub](api/pubsub.md) |
| `led_matrix.app.rb` | A WS2812B 8x8 matrix on the GROVE port, with a preview on screen | [`RMT`](api/peripherals.md#rmt) |
| `i2c_kbd.app.rb` | An I2C keyboard at address `0x5F` | [`I2C`](api/peripherals.md#i2c), [Pub/Sub](api/pubsub.md) |

## Python — `/app/python`

| App | What it shows |
|---|---|
| `python.app.py` | The twin of `picoruby.app.rb`, page for page, in MicroPython |
| `pybench.app.py` | What fits in one frame of a Python app — the three costs that decide how a game is written |

## Games — `/app/game`

| App | What it shows | API |
|---|---|---|
| `flappy.rb` | One button, scenery behind the game, and effects on the sound chip | `FmrbGfx`, [`FmrbAudio`](api/audio.md), gamepad |
| `blockgame.app.rb` | A stateful game with BGM and effects. Arrow keys, `Space` to drop | `FmrbGfx`, [`FmrbAudio`](api/audio.md) |
| `shooter.app.rb` | Sprites, a diving formation, and a boss between the waves | [Sprites](api/sprite.md), collision |
| `rpg_demo/` | A tile world that scrolls, with collisions, BGM and effects. Assets live in the app's own directory | [Tile Maps](api/tilemap.md), `FmrbApp.set_cursor_visible` |
| `raycaster.app.rb` | A pseudo-3D first-person view. Needs `large_memory = 1` | Fixed-point arithmetic, fast `FmrbGfx` |
| `robo_explorer/` | A maze the app will not let you play: the robot only obeys commands published to it. The pilot is a second app, and the part you write is `my_pilot.rb` | [Pub/Sub](api/pubsub.md) |
| `breakout/breakout.app.py` | The Python sample game: sprites, tiles, Japanese text, a tune on one sound chip instance and effects on the other | The Python framework |

## Tools — `/app/tool`

| App | What it shows | API |
|---|---|---|
| `picorabbit.app.rb` | A Markdown deck presented fullscreen, and exported as one picture per slide | `FmrbGfx#export_frame`, [Sprites](api/sprite.md) |
| `nsf_player.app.rb` | Playing NSF files, with track selection and a transport built from widgets | [`FmrbAudio#play`](api/audio.md), [`FmrbUI`](api/ui.md) |
| `smf_player.app.rb` | Standard MIDI files, on the internal chip or an external instrument | [MIDI](api/midi.md), [`FmrbUI`](api/ui.md) |
| `sprite_editor.app.rb` | A 16x16 RGB332 tile sheet: load a BMP, edit pixels, save it back | [Sprites](api/sprite.md), `BMP332` |
| `gpio_viewer.app.rb` | Every GPIO pin, coloured by what is using it | [`FmrbHw.pin_status`](api/const.md#fmrbhw) |

## Modern only — `/app/modern`

| App | What it shows | API |
|---|---|---|
| `mic_spectrum.app.rb` | The microphone sampled, transformed and drawn, all on the machine | `Fmrb::Fft`, [`FmrbAudio`](api/audio.md#the-microphone-modern-only) |
| `video_play.app.rb` | A Motion JPEG file playing inside a window | [`FmrbGfx#video_open`](api/fmrb_gfx.md#video-modern-only) |
| `imu.app.rb` | The six-axis sensor as a bubble level | [`I2C`](api/peripherals.md#i2c) |

`/app/debug` and `/app/test` also ship, but they exist to break things on purpose and are
hidden from the launcher. They are not examples to copy.

## Related

- [Hello World](getting_started/hello_world.md) — starting a new app
- [App Config (.app.toml)](file_formats/app_toml.md)
- [Image & Icon Files](file_formats/image_formats.md#icon-files-icon)
