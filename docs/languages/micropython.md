# MicroPython

A `.py` file is an app like any other. It uses the same framework Ruby apps use — subclass
`FmrbApp`, override the lifecycle methods, start it. Unlike a Ruby file, a Python file still
ends with the line that starts the app:

```python
class PythonDemoApp(FmrbApp):
    def on_create(self):
        Log.info("started on " + self.platform)
        self.clear_user_area()   # (0, 0) is the top-left inside the frame, as in Ruby
        self.gfx.present()

    def on_update(self):
        return 500          # ms until the next turn

    def on_event(self, ev):
        if ev.get("type") == "mouse_up" and ev.get("button") == 1:
            self.next_page()

PythonDemoApp().start()
```

Windows, events and drawing are reachable through the built-in `_fmrb` module, wrapped in
the framework classes an app subclasses. `FmrbApp`, `FmrbGfx`, `FmrbAudio`, `FmrbFile`,
`SpriteImage`, `SpriteInstance` and `Log` are already in the app's namespace — there is
nothing to import for them.

The demos are `/app/python/python.app.py` (the twin of the PicoRuby demo, page by page) and
`/app/game/breakout/breakout.app.py`, a whole game: sprites for the things that move, tiles
for the things that do not, Japanese text, a tune on the main sound chip with effects on
the other. Robo Explorer has a Python pilot as well.

## Where it differs from Ruby

| | Ruby | Python |
|---|---|---|
| Time | `Machine.board_millis` | `ticks_ms()`, or `FmrbApp.uptime_ms()` |
| A query method | `FmrbFile.exist?(path)` | `FmrbFile.exist(path)` — the `?` is dropped |
| String length | `String#length` counts characters | `len()` counts **bytes** |
| Another file | `require "/app/..."` | `import mymodule` — beside the app, or `/usr/lib/python` |
| The framework, from that file | Visible | **Not visible**. Pass what it needs as arguments |
| A timer's callback | A block | A function: `self.set_timer(500, self.blink)` |

Splitting an app across files works, but the framework classes live in the app's namespace
and not in the module's:

```python
# in the app
import mypanel
mypanel.draw(self, state)

# in mypanel.py
def draw(app, state):
    app.gfx.draw_text(...)   # reached through the app, not named directly
```

One file is limited to 64 KB.

## Sound

The sound chip is reached through `FmrbAudio`, the same shape as in Ruby. A tune goes on
the main instance and short effects on the other, so an effect does not stop the music:

```python
audio = FmrbAudio(self)
audio.load_fmsq_file(1, "/cache/app/mygame/bgm.fmsq")   # sync_file it across first
audio.play_slot(1, FmrbAudio.MAIN)
audio.note_on(FmrbAudio.CH_PULSE2, 988, 12, 2, 0)       # an effect, on the other
```

Time an effect's end by `ticks_ms()`, not by counting frames: a heavy frame stretches the
sound.

The rest of Ruby's `FmrbAudio` is there too: `stop`, `pause`, `resume`, `nsf_status()` (a
dict or `None`), `set_main_volume(percent)` (Ruby's `main_volume =`), `play_wav(path)`,
`stop_wav()` and `load_fmsq(slot, data)`. `Log.info` and its siblings put the app's name at
the head of the line, as they do in Ruby.

## Drawing

`FmrbGfx` has every drawing method Ruby's has, with the same names and argument order:
the shapes including arcs, ellipses and triangles, `get_pixel`, `blend_rect`, images and
masks, the viewport and sprite clipping, `file_status`, `FmrbGfx.rgb_to_332` and the rest.
The ones with optional arguments (`present`, `draw_text`, `set_font`, `draw_image`,
`draw_tile`, `sync_file`, ...) take them as Python defaults:

```python
self.gfx.set_font(FmrbGfx.FONT_JA, 12)
self.gfx.draw_text(4, 4, "こんにちは", FmrbGfx.BLACK)
self.gfx.draw_text(4, 20, "mixed 日本語", FmrbGfx.BLACK, mixed=True)
```

`clear` has no default: pass the colour (`self.gfx.clear(FmrbGfx.BLACK)`). `canvas_id`,
`origin_x`, `origin_y`, `area_width` and `area_height` are read-only properties.

## Limitations

MicroPython's design pushes back in a few places, and these are worth knowing before you
start:

One Python app at a time. MicroPython keeps its entire VM state in globals, so unlike mruby
and Lua it cannot be instantiated twice. Starting a second one is refused at spawn with
"Another Python app is already running." Ruby, Lua and BASIC apps are unaffected and can run
alongside it.

Built-in modules only. `array`, `builtins`, `collections`, `gc`, `io`, `math`,
`micropython`, `struct`, `sys` and `random` are in. `time`, `json`, `os`, `re`, `binascii`,
`hashlib`, `heapq` and `deflate` are not — they live in MicroPython's `extmod/`, which this
build does not carry. For waiting, return a delay from `on_update` rather than sleeping.
(`random` is seeded from the clock, so a run differs from the last; call `random.seed(n)`
to repeat one.)

Files are read and written whole, through `FmrbFile`, the same module Ruby apps have.
`FmrbFile.read(path)` returns the whole file as `bytes` (or `None`), and `write`, `append`,
`exist`, `size`, `delete`, `mkdir` and `list(dir)` take a path — see
[Files & I/O](../api/filesystem.md#whole-files-by-path-fmrbfile). There is no reading a file a
piece at a time: `open()` exists but raises `OSError`, because failing out loud beats being
silently absent. `io.StringIO` and the rest of the in-memory objects work.

Integers go up to 64 bits, so `FmrbApp.uptime_us()` keeps counting past the 18 minutes a
small integer holds on the ESP32; anything wider raises `OverflowError`.

Strings are bytes. This build has no Unicode strings, so `len("日本語")` is 9 and indexing
is by byte. For a width in pixels use `FmrbGfx.text_width`, which walks the UTF-8.

No REPL and no threads. Creating tasks is the system's job, not a guest VM's; use a
generator for concurrency inside an app.

256 KB of heap per app, fixed. Running out raises `MemoryError`, and an uncaught one ends
the app with a traceback in the log, exactly as running out of memory does in Ruby.

A force-stop skips `on_destroy`. Stopping an app that is inside a long Python loop unwinds
the bytecode, so neither `destroy` nor `on_destroy` runs. Resources are reclaimed by the C
side either way, but an app cannot rely on `on_destroy` to save anything — do that at a
boundary in `on_update`. Lua behaves the same way.

Not provided: tile map classes (`draw_tile` is there — lay them out yourself), `load_image`
(write it as `sync_file`, `create_image` and `draw_image`), video, `GfxBlock`, extra
canvases, the p5 layer, the microphone and MIDI out.
