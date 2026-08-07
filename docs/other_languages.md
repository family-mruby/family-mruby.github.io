# BASIC and MicroPython

Ruby is the language Family mruby is built around, but it is not the only one that runs on
it. As of 2.0 there are four: **Ruby**, **BASIC**, **MicroPython** and **Lua**.

They are not modes you switch into. A `.bas` file and a `.py` file sit in the launcher next
to the Ruby apps, start the same way, and run at the same time as each other.

| Extension | Runs on | Notes |
|---|---|---|
| `.rb` | PicoRuby | The main language. Everything in the [API Reference](api/index.md) |
| `.bas` | FMRuby BASIC | Family BASIC compatible. Its own text screen and sprites |
| `.py` | MicroPython | Same app framework as Ruby. One Python app at a time |
| `.lua` | Lua 5.4 | |

---

# FMRuby BASIC

A BASIC interpreter built to be compatible with **Family BASIC** — the BASIC that shipped
for the Famicom — down to its screen, its sprites and its sound statements.

This is not Ruby with a BASIC syntax on top: it is a separate interpreter written in C++,
with Family BASIC's semantics, its 28 x 24 character screen, and its `PLAY` / `BEEP` sound.

## Running a BASIC program

### Write it in the editor and press F5

The quickest route. Open the **Editor**, type the program, press `F5`.

- If the file has no name yet you will be asked for one. Save it under **`/home` or
  `/app`** — programs elsewhere will not run
- `Ctrl` + `Q` returns you to the editor from a running program, even a fullscreen one.
  Then `F5` runs it again

### Put it in the launcher

Drop a `.toml` next to the `.bas` with the same name:

```
/app/basic/mygame.app.bas
/app/basic/mygame.app.toml
```

```toml
app_handle_name = "mygame"
app_screen_name = "My Game"
app_screen_name_ja = "マイゲーム"
# .bas starts fullscreen unless you ask for a window:
#default_window_mode = "window"
```

The launcher builds its list when the desktop starts, so **right-click inside the launcher**
to rescan after adding a file.

A `.bas` without a `.toml` still runs from `F5` or from the shell; it just uses the filename
as its name.

## The screen

Family BASIC's screen is fixed at **28 characters by 24 lines (224 x 192 pixels)**. Started
fullscreen, it is centred and the surrounding area is filled with black — the same shape the
original had.

## What is in it

The language core, the text screen, sprites with automatic movement, controller input,
`PLAY` and `BEEP`, character tables and palette selection, error handling and `SAVE` are all
implemented. Several sample programs ship in `/app/basic`: a scrolling kana screen, dodge,
shoot, maze, music and hit demos.

## Compatibility

Every known difference from Family BASIC V3 is written down and classified — resolved,
deliberate difference, waiting on measured data, or out of scope. Some deliberate choices
worth knowing:

- `IF expr THEN stmt` skips the `:` statements after it when the condition is false (the
  Microsoft-family behaviour)
- `PLAY` is asynchronous, so music continues while the program runs
- `LOAD` / `LOAD?` do nothing inside a program — on the original they were direct-mode
  commands. `SAVE` is implemented
- `Ctrl` + `Q` stops a running program. The original had no way out of a fullscreen program

## Its MML is not the MIDI MML

BASIC's `PLAY` uses Family BASIC's MML syntax. The [MIDI](api/midi.md) layer has its own MML
for Ruby apps. They are separate implementations and the dialects differ — do not copy a
string from one to the other and expect it to play.

---

# MicroPython

A `.py` file is an app like any other. It uses the same framework Ruby apps use — subclass
`FmrbApp`, override the lifecycle methods, start it:

```python
class PythonDemoApp(FmrbApp):
    def on_create(self):
        Log.info("started on " + self.platform)
        self.draw_window_frame()

    def on_update(self):
        return 500          # ms until the next turn

    def on_event(self, ev):
        super().on_event(ev)
        if ev.get("type") == "mouse_up" and ev.get("button") == 1:
            self.next_page()

app = PythonDemoApp()
app.start()
```

Windows, events and drawing are reachable through the built-in `_fmrb` module, wrapped in
the `FmrbApp` class you subclass.

The demo is `/app/demo/python.app.py`.

## Limitations

MicroPython's design pushes back in a few places, and these are worth knowing before you
start:

**One Python app at a time.** MicroPython keeps its entire VM state in globals, so unlike
mruby and Lua it cannot be instantiated twice. Starting a second one is refused at spawn
with "Another Python app is already running." Ruby, Lua and BASIC apps are unaffected and can
run alongside it.

**Imports are built-in modules only.** There is no import from the filesystem — `import
mymodule` fails. Keep an app to one file.

Available: `array`, `builtins`, `collections`, `gc`, `io`, `math`, `micropython`, `struct`,
`sys`.

**Not** available: `time`, `json`, `os`, `re`, `random`, `binascii`, `hashlib`, `heapq`,
`deflate` — those live in MicroPython's `extmod/`, which this build does not include. For
waiting, return a delay from `on_update` rather than sleeping.

**No REPL and no threads.**

**`open()` always fails.** File access goes through the framework, not through Python's own
file layer.

**256 KB of heap per app**, fixed.

---

## Which one to reach for

- **Ruby** for anything that needs the full API — networking, MIDI, sprites, the peripheral
  bus. This is the language the system is designed around
- **BASIC** if you want the Family BASIC experience, or you are following a listing from a
  magazine of the era
- **MicroPython** if Python is what you know. Expect a smaller standard library than you are
  used to
- **Lua** for a small, fast script

## Related

- [Default Apps](getting_started/default_apps.md) — the samples in each language
- [App Config (.app.toml)](file_formats/app_toml.md)
- [API Reference](api/index.md) — the Ruby API the other languages mirror
