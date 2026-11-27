# Lua

A `.lua` app runs on a shell the system provides in C: the system makes the window, draws its
frame and runs the loop, and the app only defines functions. The shape follows the Ruby app's:

```lua
local seconds = 0

function on_create()            -- once, after the window is made
  FmrbApp.clear_user_area()     -- the area in the theme colour, frame redrawn
  gfx:draw_text(2, 2, "Hello", FmrbApp.THEME_TEXT)
  gfx:present()
end

function on_update()            -- called again after the ms it returns (330 if not a number)
  seconds = seconds + 1
  return 1000
end

function on_event(ev)           -- one input at a time
  if ev.type == "key_down" and ev.character == string.byte("q") then
    FmrbApp.stop()
  end
end
```

- The top level of the file runs once first, to define functions and variables; `gfx` does
  not exist yet there. A file that defines none of `on_create`, `on_update` and `on_event`
  does not start, and an error window says so.
- Optional: `on_destroy`, `on_suspend` / `on_resume`, `on_resize(w, h)` (after the shell has
  repainted the area and the frame) and `on_quit_request` (Ctrl+Q; closes when absent).
- An error in a function shows an error window with the message and traceback, and the app
  ends. Do not wait long inside a function: return the wait from `on_update`. A function that
  does not return for a second is cut off by the close button and by kill.
- `gfx` draws with (0, 0) at the top-left inside the frame, as a Ruby app's `@gfx` does, and
  has the methods of Ruby's `FmrbGfx` with the same names and argument order:
  `fill_rect(x, y, w, h, c)`, `draw_line`, `fill_circle`, `draw_ellipse`, `draw_arc` and the
  rest, `draw_text(x, y, text, c [, bg [, mixed]])`, `set_font(family [, size])`,
  `present()`. Ruby's Symbols are strings (`gfx:set_font("ja", 12)`) and records are tables.
  `gfx:clear(c)` wipes the whole canvas, frame included; `FmrbApp.clear_user_area([c])` wipes
  the area and redraws the frame.
- Sizes are functions, read when called: `FmrbApp.user_area_width()` /
  `user_area_height()` for the area, `FmrbApp.window_width()` / `window_height()` for the
  window.
- Beside drawing, Lua has what Ruby apps have: `FmrbAudio.new()` and `audio:note_on(...)`,
  `audio:play_wav(path)` and the rest; `Log.info(msg)`; `FmrbApp.clipboard()`,
  `FmrbApp.uptime_ms()`, `FmrbApp.wallclock()`; the window's state and requests
  (`FmrbApp.fullscreen()`, `FmrbApp.request_fullscreen(on)` ...); and whole files through
  `FmrbFile` (`FmrbFile.read(path)`, `FmrbFile.exist(path)` ...). A Ruby method ending in `?`
  drops it in Lua.
- `ev` has the same keys as in Ruby, with `ev.type` a string: `"key_down"`, `"key_up"`,
  `"mouse_down"`, `"mouse_up"`, `"mouse_move"`, `"mouse_wheel"`, `"gamepad_down"`,
  `"gamepad_up"`, `"gamepad_axis"`, `"kana_mode"`. Mouse events carry `x` / `y` (the area)
  and `wx` / `wy` (the window). The close button, the title bar's window menu and dragging
  are handled for the app.
- Colours are `FmrbGfx.BLACK` and the other constants, and the theme's
  `FmrbApp.THEME_WINDOW_BG`, `THEME_TEXT`, `THEME_BORDER` and the rest.

The sample is `/app/lua/lua.app.lua`.
