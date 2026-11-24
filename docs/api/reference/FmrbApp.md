# FmrbApp

How to use it: [Application](../fmrb_app.md), [Inter-App Messaging](../pubsub.md).

## Types

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`wallclock`</span> | `{ year: uint16, month: uint8, day: uint8, hour: uint8, minute: uint8, second: uint8 }` | The date and time, from wallclock |
| <span class="fmrb-name">`sys_pool_info`</span> | `{ total: uint32, used: uint32, free: uint32, used_blocks: uint32, free_blocks: uint32 }` | The system pool, from sys_pool_info |
| <span class="fmrb-name">`gfx_stats`</span> | `{ cmds: uint32, presents: uint32 }` | The frames sent, from gfx_stats |
| <span class="fmrb-name">`wasm_stats`</span> | `{ running: uint8, apps: uint8, modules: uint8, natives: uint16, pool_total: uint32, pool_used: uint32, pool_high: uint32, traps: uint32 }` | The wasm runtime, from wasm_stats |
| <span class="fmrb-name">`wasm_app_stats`</span> | `{ pages: uint32, max_pages: uint32, binary_size: uint32, hook_us: uint32, hook_max_us: uint32, calls: uint32 }` | One wasm app, from wasm_app_stats |
| <span class="fmrb-name">`event`</span> | `{ type: :key_down \| :key_up \| :mouse_down \| :mouse_up \| :mouse_move \| :mouse_wheel \| :gamepad_down \| :gamepad_up \| :gamepad_axis \| :kana_mode, x: int32, y: int32, wx: int32, wy: int32, button: int32, keycode: int32, scancode: int32, modifier: int32, character: int32, delta: int32, gamepad_id: int32, axis: int32, value: int32, mode: int32 }` | One input event, as on_event gets it |

## Class methods

### FmrbApp.language

<pre class="fmrb-sig"><code>language() -&gt; <a href="../String/">String</a></code></pre>

The language now, "ja" or "en"

```ruby
if FmrbApp.language == "ja"
```

### FmrbApp.clipboard

<pre class="fmrb-sig"><code>clipboard() -&gt; <a href="../String/">String</a></code></pre>

The text on the clipboard

One clipboard shared by every app; `""` when empty.
On the PC and in the browser, text copied there too.
Given a number, at most that many bytes, never
cutting a character.
```ruby
text = FmrbApp.clipboard
```

### FmrbApp.clipboard_raw

<pre class="fmrb-sig"><code>clipboard_raw(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../String/">String</a></code></pre>

clipboard with nothing left out

The simple form, with no argument left out. limit 0 gives all of it; above
0, at most that many bytes, never cutting a character. The wrapper is
clipboard (limit left out is 0).
```ruby
text = FmrbApp.clipboard_raw(0)
```

### FmrbApp.set_clipboard

<pre class="fmrb-sig"><code>set_clipboard(<a href="../String/">String</a> text) -&gt; bool</code></pre>

Put text on the clipboard

Over 64 KB it is not put there, and the answer is
false.
```ruby
FmrbApp.set_clipboard("hello")
```

### FmrbApp.clipboard_gen

<pre class="fmrb-sig"><code>clipboard_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the clipboard changed

To tell a change without reading the text.
```ruby
g = FmrbApp.clipboard_gen
```

### FmrbApp.notify

<pre class="fmrb-sig"><code>notify(<a href="../String/">String</a> summary, <a href="../String/">String</a> body) -&gt; bool</code></pre>

Show a small notice at the top right

It goes after a few seconds: the app's name, the
text and the body (two lines at most). Only the PC
shows them; elsewhere nothing shows and the answer
is false.
```ruby
FmrbApp.notify("Saved", "/home/a.txt")
```

### FmrbApp.notify_raw

<pre class="fmrb-sig"><code>notify_raw(<a href="../String/">String</a> summary, <a href="../String/">String</a> body) -&gt; bool</code></pre>

notify with nothing left out

The simple form. The wrapper is notify (body left out is "").
```ruby
FmrbApp.notify_raw("Saved", "")
```

### FmrbApp.ps

<pre class="fmrb-sig"><code>ps() -&gt; <a href="../Array/">Array</a></code></pre>

The apps that are running

Every running app, each a Hash with its name and pid.
```ruby
FmrbApp.ps.each do |a|
  Log.info("#{a[:pid]} #{a[:name]}")
end
```

### FmrbApp.ps_gen

<pre class="fmrb-sig"><code>ps_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the app list changed

A number that changes whenever the list does.
**Call `ps` only when it moves** and the list is not rebuilt every frame.
```ruby
gen = FmrbApp.ps_gen
list = FmrbApp.ps if gen != @gen
```

### FmrbApp.checkpoint

<pre class="fmrb-sig"><code>checkpoint(<a href="../Integer/">Integer</a> pid) -&gt; <a href="../String/">String</a>?</code></pre>

Write another app to an image

Asks for app pid to be stopped, written to an image and closed (the
shell's `checkpoint`); `restart: true` starts it again at once. nil when
asked, else a String saying why not. The answer arrives later at
`on_control` as
`{"cmd" => "checkpoint_result", "pid", "ok", "path" or "reason"}`.
```ruby
FmrbApp.checkpoint(5,
                   restart: true)
```

### FmrbApp.move

<pre class="fmrb-sig"><code>move(<a href="../Integer/">Integer</a> pid, <a href="../String/">String</a> to) -&gt; <a href="../String/">String</a>?</code></pre>

Move another app to another machine

Asks for app pid to be moved to the Asterism machine `to` (its node ID;
the shell's `move`). nil when asked, else a String saying why not. The
answer arrives later at `on_control` as `{"cmd" =>
"checkpoint_result", "pid", "ok", "to", "there" and "missing" or
"reason"}`.
```ruby
FmrbApp.move(5, "fmruby-abcdef")
```

### FmrbApp.heap_info

<pre class="fmrb-sig"><code>heap_info() -&gt; <a href="../Hash/">Hash</a></code></pre>

How much memory is free

```ruby
h = FmrbApp.heap_info
Log.info("#{h[:free]} free")
```

### FmrbApp.pool_usage

<pre class="fmrb-sig"><code>pool_usage() -&gt; <a href="../Integer/">Integer</a></code></pre>

How much of its own memory is used

```ruby
pct = FmrbApp.pool_usage
```

### FmrbApp.pool_used

<pre class="fmrb-sig"><code>pool_used() -&gt; <a href="../Integer/">Integer</a></code></pre>

How much of its own memory is used, in bytes

-1 when it cannot be read. Use it where the percent is too coarse: one
percent of the desktop's 1536KB pool is 15KB. Subtract across a piece of
work and you have the garbage it made.
```ruby
before = FmrbApp.pool_used
scan_everything
kb = (FmrbApp.pool_used - before) / 1024
```

### FmrbApp.sys_pool_info

<pre class="fmrb-sig"><code>sys_pool_info() -&gt; sys_pool_info</code></pre>

The whole machine's memory

```ruby
i = FmrbApp.sys_pool_info
```

### FmrbApp.config

<pre class="fmrb-sig"><code>config(<a href="../String/">String</a> section_name) -&gt; <a href="../Array/">Array</a>?</code></pre>

Read a settings file

Reads a section of `system_conf.toml`, or nil if it is not there.
```ruby
rows = FmrbApp.config("theme")
```

### FmrbApp.uptime_us

<pre class="fmrb-sig"><code>uptime_us() -&gt; int64</code></pre>

Microseconds since power-on

```ruby
t0 = FmrbApp.uptime_us
work
us = FmrbApp.uptime_us - t0
```

### FmrbApp.uptime_ms

<pre class="fmrb-sig"><code>uptime_ms() -&gt; int64</code></pre>

Milliseconds since power-on

```ruby
t0 = FmrbApp.uptime_ms
```

### FmrbApp.wallclock

<pre class="fmrb-sig"><code>wallclock() -&gt; wallclock?</code></pre>

The date and time now

The date and time now, or nil when the clock has never been set.
```ruby
t = FmrbApp.wallclock
Log.info("#{t[:hour]}") if t
```

### FmrbApp.gfx_stats

<pre class="fmrb-sig"><code>gfx_stats() -&gt; gfx_stats</code></pre>

A tally of the frames sent

```ruby
s = FmrbApp.gfx_stats
```

### FmrbApp.wasm_stats

<pre class="fmrb-sig"><code>wasm_stats() -&gt; wasm_stats</code></pre>

How the wasm runtime is doing

The runtime wasm apps run on (WAMR). running is 1 while it is up (while
any wasm app runs), apps the apps using it, modules the modules loaded,
natives the boundary's functions the firmware gives. pool_* is the shared
pool every wasm app takes from (bytes; high is the most since boot), traps
the calls that trapped (or ran too long) since boot. All 0 on a machine
without wasm apps (the ESP32-S3).
```ruby
w = FmrbApp.wasm_stats
Log.info("#{w[:pool_used]} of #{w[:pool_total]}") if w[:running] == 1
```

### FmrbApp.wasm_app_stats

<pre class="fmrb-sig"><code>wasm_app_stats(<a href="../Integer/">Integer</a> pid) -&gt; wasm_app_stats?</code></pre>

How one wasm app is doing

The wasm app pid, or nil when pid is not one. pages is its linear memory
now and max_pages the most it may grow to (64 KB pages), binary_size its
.wasm, hook_us how long the last hook call (on_update and the others)
took and hook_max_us the longest (microseconds), calls the hook calls so
far.
```ruby
s = FmrbApp.wasm_app_stats(pid)
Log.info("#{s[:pages]}/#{s[:max_pages]} pages") if s
```

### FmrbApp.enable_cursor

<pre class="fmrb-sig"><code>enable_cursor() -&gt; void</code></pre>

Show the mouse pointer

Shows the mouse pointer; the desktop does this at boot.
```ruby
FmrbApp.enable_cursor
```

### FmrbApp.set_cursor_visible

<pre class="fmrb-sig"><code>set_cursor_visible(bool visible) -&gt; void</code></pre>

Show or hide the mouse pointer

```ruby
FmrbApp.set_cursor_visible(false)
```

### FmrbApp.set_kana_mode

<pre class="fmrb-sig"><code>set_kana_mode(<a href="../Integer/">Integer</a> mode) -&gt; void</code></pre>

Switch kana input (0 off 1 hira 2 kata)

0 for ASCII, 1 for hiragana, 2 for katakana.
```ruby
FmrbApp.set_kana_mode(1)
```

### FmrbApp.set_text_cursor

<pre class="fmrb-sig"><code>set_text_cursor(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Tell where the text cursor is (for a PC IME)

Apps that take text call this whenever they draw their cursor: x, y in
canvas coordinates (the top-left of the cell), h the line's height;
h = 0 says no text is taken now. A PC's IME (fcitx5 and the like) shows
the text being composed and its candidates there. Nothing on the devices.
```ruby
FmrbApp.set_text_cursor(x, y, 12)
```

### FmrbApp.audio_muted?

<pre class="fmrb-sig"><code>audio_muted?() -&gt; bool</code></pre>

Whether the machine is muted

```ruby
FmrbApp.audio_muted?
```

### FmrbApp.path_read_only?

<pre class="fmrb-sig"><code>path_read_only?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether the entry cannot be deleted or renamed

True for the tree of the PC build's distribution and for /mnt/root. Always false on a
device, the simulation and the browser build. Meant to be asked before deleting
(File Manager).
```ruby
FmrbApp.path_read_only?("/mnt/root/etc/hostname")
```

### FmrbApp.app_meta

<pre class="fmrb-sig"><code>app_meta(<a href="../String/">String</a> path) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>]?</code></pre>

An app's settings (.app.toml and comment)

Reads the .app.toml and the `#---fmrb`
comment at the top of the .rb together;
a key both set takes the .app.toml's
value. Keys and values are Strings (an
array's items joined by a space). nil
for a file with neither (not an app).
```ruby
m = FmrbApp.app_meta(
  "/app/game/flappy.app.rb")
m["app_screen_name"] if m
```

### FmrbApp.free_bytes

<pre class="fmrb-sig"><code>free_bytes(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

How many more bytes can be written where the path lives

/tmp: what is left of the RAM filesystem; elsewhere: the free space of
the filesystem under it. nil when it cannot be known (the browser's /home).
```ruby
FmrbApp.free_bytes("/tmp")
```

### FmrbApp.audio_volume

<pre class="fmrb-sig"><code>audio_volume() -&gt; <a href="../Integer/">Integer</a></code></pre>

The machine's volume (0-10)

```ruby
FmrbApp.audio_volume
```

### FmrbApp.wifi_connected?

<pre class="fmrb-sig"><code>wifi_connected?() -&gt; bool</code></pre>

Whether WiFi is connected

```ruby
if FmrbApp.wifi_connected?
```

### FmrbApp.wifi_info

<pre class="fmrb-sig"><code>wifi_info() -&gt; <a href="../Hash/">Hash</a>?</code></pre>

How WiFi is doing

**nil on Retro.** Modern reports its WiFi, Linux the host's network.
```ruby
i = FmrbApp.wifi_info
Log.info(i[:ip]) if i
```

### FmrbApp.usb_devices

<pre class="fmrb-sig"><code>usb_devices() -&gt; <a href="../Array/">Array</a></code></pre>

The USB devices attached

```ruby
FmrbApp.usb_devices.each do |d|
  Log.info(d[:type])
end
```

### FmrbApp.hid_raw_subscribe

<pre class="fmrb-sig"><code>hid_raw_subscribe(<a href="../Integer/">Integer</a> slot) -&gt; bool</code></pre>

Start receiving raw USB input

Raw reports from that slot start arriving at `on_control`. The HID
Inspector is what uses this.
```ruby
FmrbApp.hid_raw_subscribe(slot)
```

### FmrbApp.hid_raw_unsubscribe

<pre class="fmrb-sig"><code>hid_raw_unsubscribe(<a href="../Integer/">Integer</a> slot) -&gt; bool</code></pre>

Stop receiving raw USB input

```ruby
FmrbApp.hid_raw_unsubscribe(1)
```

### FmrbApp.pid

<pre class="fmrb-sig"><code>pid() -&gt; <a href="../Integer/">Integer</a></code></pre>

This app's own pid

The number `ps` reports as :id; for leaving itself out of the list.
```ruby
me = FmrbApp.pid
```

### FmrbApp.script_path

<pre class="fmrb-sig"><code>script_path() -&gt; <a href="../String/">String</a></code></pre>

The file this app was started from

"" for an app built into the firmware.
```ruby
FmrbApp.script_path
```

### FmrbApp.gc

<pre class="fmrb-sig"><code>gc() -&gt; void</code></pre>

Collect this app's garbage now

```ruby
FmrbApp.gc
```

### FmrbApp.battery_level

<pre class="fmrb-sig"><code>battery_level() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The battery's charge in percent

nil where there is no battery value.
```ruby
FmrbApp.battery_level
```

### FmrbApp.battery_charging?

<pre class="fmrb-sig"><code>battery_charging?() -&gt; bool</code></pre>

Whether the battery is charging

```ruby
FmrbApp.battery_charging?
```

### FmrbApp.crt_state

<pre class="fmrb-sig"><code>crt_state() -&gt; <a href="../String/">String</a></code></pre>

The CRT look now

"" where it cannot be drawn, else "crt" or "sharp" and the eight
strengths, e.g. "crt,55,30,30,15,40,0,0,0".
```ruby
FmrbApp.crt_state != ""
# true where the look can be drawn
```

### FmrbApp.linux_available?

<pre class="fmrb-sig"><code>linux_available?() -&gt; bool</code></pre>

Whether Linux commands run here

true on the native program and in the simulation.
```ruby
FmrbApp.linux_available?
```

### FmrbApp.linux_start

<pre class="fmrb-sig"><code>linux_start(
  <a href="../String/">String</a>? cmd,
  <a href="../String/">String</a> cwd,
  <a href="../Integer/">Integer</a> cols,
  <a href="../Integer/">Integer</a> rows
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Start a Linux command in a terminal

Answers a handle; raises when it cannot start. A nil cmd is a shell.
```ruby
h = FmrbApp.linux_start("ls",
      "/home", 80, 24)
```

### FmrbApp.linux_read

<pre class="fmrb-sig"><code>linux_read(<a href="../Integer/">Integer</a> h) -&gt; <a href="../String/">String</a>?</code></pre>

Read a Linux command's output

"" when there is none yet, nil once it ended. Never waits.
```ruby
s = FmrbApp.linux_read(h)
```

### FmrbApp.linux_write

<pre class="fmrb-sig"><code>linux_write(<a href="../Integer/">Integer</a> h, <a href="../String/">String</a> data) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write to a Linux command

```ruby
FmrbApp.linux_write(h, "q")
```

### FmrbApp.linux_signal

<pre class="fmrb-sig"><code>linux_signal(<a href="../Integer/">Integer</a> h, <a href="../Symbol/">Symbol</a> sig) -&gt; bool</code></pre>

Send a signal to a Linux command

:int, :term, :kill or :hup.
```ruby
FmrbApp.linux_signal(h, :int)
```

### FmrbApp.linux_exit_code

<pre class="fmrb-sig"><code>linux_exit_code(<a href="../Integer/">Integer</a> h) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

A Linux command's exit code

nil while it runs.
```ruby
code = FmrbApp.linux_exit_code(h)
# nil while it is still running
```

### FmrbApp.linux_resize

<pre class="fmrb-sig"><code>linux_resize(<a href="../Integer/">Integer</a> h, <a href="../Integer/">Integer</a> cols, <a href="../Integer/">Integer</a> rows) -&gt; bool</code></pre>

Resize a Linux command's terminal

```ruby
FmrbApp.linux_resize(h, 80, 24)
```

### FmrbApp.linux_close

<pre class="fmrb-sig"><code>linux_close(<a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Close a Linux command

Ends it if it still runs; never waits.
```ruby
FmrbApp.linux_close(h)
# h comes from FmrbApp.linux_start
```

## Instance methods

### FmrbApp#gfx

<pre class="fmrb-sig"><code>gfx() -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

The canvas to draw on

(0, 0) is the top-left of the area the app owns (the user area): inside
the frame of a framed window, the window's top-left when it has no frame
or is fullscreen. A mouse event's ev[:x] is in the same place.
```ruby
gfx.fill_rect(0, 0, 10, 10,
              theme_fg)
gfx.present
```

### FmrbApp#window_gfx

<pre class="fmrb-sig"><code>window_gfx() -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

Draws on the whole window, frame too

A second drawer whose origin is the window's top-left: for drawing
outside the area, such as a frame or a title of the app's own. The font
belongs to the canvas, so call set_font on gfx.
```ruby
window_gfx.fill_rect(0, 0,
  window_width, 11, theme_accent)
```

### FmrbApp#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The app's name

```ruby
Log.info("#{name} started")
```

### FmrbApp#running?

<pre class="fmrb-sig"><code>running?() -&gt; bool</code></pre>

Whether it is still running

```ruby
stop unless running
```

### FmrbApp#window_width

<pre class="fmrb-sig"><code>window_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window width in pixels

The window including its border. What can be drawn in is
`@user_area_width`.
```ruby
w = window_width
```

### FmrbApp#window_height

<pre class="fmrb-sig"><code>window_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window height in pixels

```ruby
h = window_height
```

### FmrbApp#pos_x

<pre class="fmrb-sig"><code>pos_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Left edge of the window

```ruby
x = pos_x
```

### FmrbApp#pos_y

<pre class="fmrb-sig"><code>pos_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Top edge of the window

```ruby
y = pos_y
```

### FmrbApp#user_area_width

<pre class="fmrb-sig"><code>user_area_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Width of the area the app owns

Inside the frame (the whole window when it has none or is fullscreen);
gfx's (0, 0) is its top-left.
```ruby
w = user_area_width
```

### FmrbApp#user_area_height

<pre class="fmrb-sig"><code>user_area_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Height of the area the app owns

```ruby
h = user_area_height
```

### FmrbApp#platform

<pre class="fmrb-sig"><code>platform() -&gt; (:esp32 | :linux)</code></pre>

Which machine this is

Either `:esp32` or `:linux` (a Symbol). The browser build says `:linux`
too; tell it apart with `FmrbConst::BOARD == "wasm"`. In an app moved to
another machine it is the machine where it now runs.
```ruby
if platform == :esp32
```

### FmrbApp#fullscreen?

<pre class="fmrb-sig"><code>fullscreen?() -&gt; bool</code></pre>

Whether it fills the screen

```ruby
draw_window_frame unless fullscreen
```

### FmrbApp#rounded_corners?

<pre class="fmrb-sig"><code>rounded_corners?() -&gt; bool</code></pre>

Whether the corners are rounded

```ruby
r = rounded_corners ? 6 : 0
```

### FmrbApp#closable?

<pre class="fmrb-sig"><code>closable?() -&gt; bool</code></pre>

Whether the close button ends it

```ruby
show_close_button if closable
```

### FmrbApp#closable=

<pre class="fmrb-sig"><code>closable=(bool v) -&gt; void</code></pre>

Decide whether the close button ends it

An app that owns the whole screen (the desktop) sets `false`, because its
top-right corner is ordinary UI. The setting is read for **a click on the**
**close button only**; with `false` pressing the corner does not `stop`.
```ruby
def on_create
  self.closable = false
end
```

### FmrbApp#frameless?

<pre class="fmrb-sig"><code>frameless?() -&gt; bool</code></pre>

Whether the window has no frame

No frame, title bar or close button: the user area is the whole window and
its ground is the colour key (.app.toml window_frame = "none").
```ruby
bg = frameless? ? nil : theme_bg
```

### FmrbApp#resizable?

<pre class="fmrb-sig"><code>resizable?() -&gt; bool</code></pre>

Whether the window resizes from its corner

The app's .app.toml resizable; the frame shows the mark at the corner.
```ruby
pad = resizable? ? 9 : 0
```

### FmrbApp#resize_corner

<pre class="fmrb-sig"><code>resize_corner() -&gt; <a href="../Integer/">Integer</a></code></pre>

Pixels to keep free at the bottom-right

How many pixels an app that draws into the bottom-right corner (a status
line, a scrollbar) keeps free at the right and bottom. 9 for a window
that can be resized, covering the mark and the grab area, and **0 for a**
**fullscreen or fixed-size window**; it is asked each time.
```ruby
right = @area_w - resize_corner - 2
```

### FmrbApp#on_create

<pre class="fmrb-sig"><code>on_create() -&gt; void</code></pre>

Called once as it starts

The screen and the window are ready by the time this runs. Set up the
first frame and whatever state the app will keep.

A file only defines the class; it needs no starting code at the end.
Once the file has been read, the class is made and started.

```ruby
class MyApp < FmrbApp
  def on_create
    @n = 0
    clear_user_area
    gfx.present
  end
end
```

### FmrbApp#on_update

<pre class="fmrb-sig"><code>on_update() -&gt; void</code></pre>

called every frame; draw here

Called over and over while the app runs. Draw one frame's worth of graphics
here; movement comes from changing the position a little on each call.

Blocking in here blocks the other apps too, so
**never wait long in this method**. Use `set_timer` when something has to happen later.

```ruby
class MyApp < FmrbApp
  def on_create
    @x = 0
  end

  def on_update
    @x = (@x + 1) % window_width
    gfx.clear(FmrbGfx::BLACK)
    gfx.fill_circle(@x, 60, 8,
                    FmrbGfx::YELLOW)
    gfx.present
  end
end
```

### FmrbApp#on_destroy

<pre class="fmrb-sig"><code>on_destroy() -&gt; void</code></pre>

Called once as it ends

Called once, just before the app ends: close files, save what should be
saved.

It runs only on an orderly exit. An app that dies on an exception never
gets here, so anything that must not be lost should be written out
before then.
```ruby
def on_destroy
  Log.info("MyApp: bye")
end
```

### FmrbApp#on_suspend

<pre class="fmrb-sig"><code>on_suspend() -&gt; void</code></pre>

Called when the screen goes to another app

Called when another app comes to the front. This app keeps running; only
its screen goes away. Nobody is looking at what it draws, so this is
where to stop an expensive animation or a sound.
```ruby
def on_suspend
  @paused = true
end
```

### FmrbApp#on_resume

<pre class="fmrb-sig"><code>on_resume() -&gt; void</code></pre>

Called when the screen comes back

Called when this app gets the screen back. What was on it is gone;
redraw here.
```ruby
def on_resume
  @paused = false
  draw_screen
end
```

### FmrbApp#on_checkpoint

<pre class="fmrb-sig"><code>on_checkpoint() -&gt; void</code></pre>

Called once the app is written to an image

Called once the image is written, just before the app closes. The app
moved rather than ended, so `on_destroy` does not come. What is done here
is not in the image. Only an app on mruby whose `.app.toml` says
`movable = true` can be written (doc/checkpoint/movable_apps.md).
```ruby
def on_checkpoint
  Log.info("written to an image")
end
```

### FmrbApp#on_restore

<pre class="fmrb-sig"><code>on_restore() -&gt; void</code></pre>

Called when started from an image

Called in an app started from an image, just before it goes on from where
it was written. Its instance variables, Tasks and timers are back as they
were. The base has made its window again (the same place, size and frame,
its fonts and `GfxBlock`s) and subscribed to its topics again, and the
keyboard comes to it. **What was drawn does not come back**: the window
is an empty frame, so an app that draws only when something happens
draws here (one that draws everything in `on_update` need not). Make
again here what the app itself made outside the VM (sprites, images). An
app holding a file open cannot be written to an image.
Moved to a machine with another screen (Retro and Modern), the window may
be made smaller to fit it, or a fullscreen app gets that screen's size:
`on_resize` then comes before `on_restore`, as after a resize.
The build it moved to may lack a method not common to every machine:
check with `respond_to?` or rescue NoMethodError (gather the differences
in a small object of the app's own and absorb them there with
`respond_to?` or `method_missing`; adding `method_missing` to a built-in
class such as `Array` is not recommended). The arriving side tells the
names it lacks in its log and its answer, and does not refuse. A method
the app cannot go on without goes in its `.app.toml` as
`requires = ["name"]`: it is not moved to a build without it.
See doc/checkpoint/movable_apps.md.
```ruby
def on_restore
  draw_screen
end
```

### FmrbApp#on_checkpoint_refused

<pre class="fmrb-sig"><code>on_checkpoint_refused(<a href="../String/">String</a> reason) -&gt; void</code></pre>

Called when its own image is refused

Called with the reason when the image asked for with
`checkpoint` could not be written. The app goes on.
```ruby
def on_checkpoint_refused(reason)
  Log.info("refused: #{reason}")
end
```

### FmrbApp#on_event

<pre class="fmrb-sig"><code>on_event(event ev) -&gt; void</code></pre>

called on key and mouse input

ev is a Hash describing the input. Four fields cover most uses:

- `ev[:type]` -- what happened: `:key_down`, `:mouse_up` and so on
- `ev[:scancode]` -- the key's number. **Look at this, not the character**
  (kana input delivers the same numbers)
- `ev[:x]` `ev[:y]` -- where the mouse is (from the area's top-left,
  as gfx draws; from the window's: `ev[:wx]` `ev[:wy]`)

Use `ev_ctrl?(ev)` and friends to see whether Ctrl or Shift was held.

```ruby
class MyApp < FmrbApp
  def on_event(ev)
    return unless
      ev[:type] == :key_down
    case ev[:scancode]
    when 0x4F then @x += 4  # right
    when 0x50 then @x -= 4  # left
    end
  end
end
```

### FmrbApp#on_resize

<pre class="fmrb-sig"><code>on_resize(<a href="../Integer/">Integer</a> new_width, <a href="../Integer/">Integer</a> new_height) -&gt; void</code></pre>

Called when the window is resized

Called when the window changes size, and when it enters or leaves full
screen.

**FmrbUI widgets stay where they were built**, so a resize means building
them again. Redraw the frame too.

```ruby
def on_resize(w, h)
  detach_ui(@ui) if @ui
  @ui = FmrbUI.new(self)
  build_widgets
  redraw
end
```

### FmrbApp#on_quit_request

<pre class="fmrb-sig"><code>on_quit_request() -&gt; void</code></pre>

Called when it is asked to close

Called by the close button and Ctrl+Q. **Left alone, the app just ends.**
Override it to ask about unsaved work.
```ruby
def on_quit_request
  if @modified
    ask_save
  else
    stop
  end
end
```

### FmrbApp#on_frameless_right_click

<pre class="fmrb-sig"><code>on_frameless_right_click(event ev) -&gt; void</code></pre>

Right click or long press, frameless

Called on a right click on a frameless window (on its release), and on a
left press held still for a second (ev[:type] is :long_press, the way on
a touch screen). The default opens the window menu (request_window_menu:
Send to, Reload, Close). An app that uses the right button overrides it
with an empty method (or calls super(ev) to have the menu too); a right
click reaches on_event either way, a long press does not.
```ruby
def on_frameless_right_click(ev)
end
```

### FmrbApp#set_hit_shape

<pre class="fmrb-sig"><code>set_hit_shape(<a href="../Array/">Array</a> rects) -&gt; bool</code></pre>

Hit shape: rectangles (frameless window)

A frameless window takes a press only inside the union of these
rectangles, its mask and its marked sprites; elsewhere the press goes to
what is behind. Nothing declared: the whole window. Window coordinates;
`[]` drops the rectangles. A move carries them along.
```ruby
set_hit_shape([[0, 0, 40, 30],
               [10, 30, 20, 8]])
```

### FmrbApp#set_hit_mask

<pre class="fmrb-sig"><code>set_hit_mask(<a href="../FmrbHitMask/">FmrbHitMask</a>? mask, ?<a href="../Integer/">Integer</a> x, ?<a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

Hit shape: a mask (FmrbHitMask)

Its top-left at (x, y); nil drops it.
```ruby
m = hit_mask_from_art(ROWS,
      transparent: ".", scale: 3)
set_hit_mask(m, 36, 38)
```

### FmrbApp#hit_mask_from_art

<pre class="fmrb-sig"><code>hit_mask_from_art(
  <a href="../Array/">Array</a> rows,
  ?transparent: <a href="../String/">String</a>,
  ?scale: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbHitMask/">FmrbHitMask</a></code></pre>

A hit mask from dot-art strings

One ASCII character per cell; every character not in transparent is
hit. A cell is scale x scale pixels.
```ruby
m = hit_mask_from_art(
      ["..XX..", ".XXXX."],
      transparent: ".", scale: 2)
```

### FmrbApp#add_hit_sprite

<pre class="fmrb-sig"><code>add_hit_sprite(<a href="../SpriteInstance/">SpriteInstance</a> sprite, ?<a href="../FmrbHitMask/">FmrbHitMask</a>? mask) -&gt; bool</code></pre>

Mark a sprite as part of the hit shape

The sprite's rectangle (or the mask given, over its top-left) is hit
wherever the sprite is, while it is visible. After a move, on_restore
marks the sprites it makes again.
```ruby
add_hit_sprite(@player)
```

### FmrbApp#remove_hit_sprite

<pre class="fmrb-sig"><code>remove_hit_sprite(<a href="../SpriteInstance/">SpriteInstance</a> sprite) -&gt; void</code></pre>

Unmark a sprite

```ruby
remove_hit_sprite(@player)
```

### FmrbApp#clear_hit_shape

<pre class="fmrb-sig"><code>clear_hit_shape() -&gt; bool</code></pre>

Back to the window rectangle

```ruby
clear_hit_shape
```

### FmrbApp#start

<pre class="fmrb-sig"><code>start() -&gt; void</code></pre>

Start the app running

Calls `on_create`, runs the app's loop, and cleans up when it ends.

An app file does not call it: once the file has been read, the FmrbApp
subclass it defines is made and this is called: the one `class = "MyApp"`
in the .app.toml (or the `#---fmrb` header) names, or else the only one.
When none can be picked, the error window says why.
```ruby
MyApp.new.start
```

### FmrbApp#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

Stop the app

Leaves the loop and ends.
**Only an ending that goes through here counts as an orderly one**,
which is how the kernel tells it from a crash.
```ruby
stop
```

### FmrbApp#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

Let go of what it used

Cleanup. `start` calls it at the end, so an app rarely calls it itself.

### FmrbApp#request_reload

<pre class="fmrb-sig"><code>request_reload() -&gt; void</code></pre>

Ask to be loaded again

Asks for a file-based app to be started again from the rewritten file.
The window menu's Reload asks the same.
```ruby
request_reload
```

### FmrbApp#request_window_menu

<pre class="fmrb-sig"><code>request_window_menu(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; void</code></pre>

Open this window's menu

Asks the desktop for this window's menu at (x, y) of the window: Send to
(a movable app), Reload (an app started from a file), Close. A right
click on the title bar, and on a frameless window the default right
click and long press, call this.
```ruby
request_window_menu(ev[:wx], ev[:wy])
```

### FmrbApp#request_close_confirm

<pre class="fmrb-sig"><code>request_close_confirm() -&gt; void</code></pre>

Ask "Close <app>?" on the desktop

Asks the desktop to show "Close <app>?". Yes calls on_quit_request; No
or a click outside does nothing.
```ruby
request_close_confirm
```

### FmrbApp#main_loop

<pre class="fmrb-sig"><code>main_loop() -&gt; void</code></pre>

The body that is called over and over

What `start` runs. There is rarely a reason to call it directly.

### FmrbApp#draw_window_frame

<pre class="fmrb-sig"><code>draw_window_frame() -&gt; void</code></pre>

Redraw the frame and the title

Draws the title bar, the border and the close button. Does nothing in
full screen.

**Usually there is no need to call it.** The base draws the frame when
the app starts, and clear_user_area draws it again after painting the
area. After a resize, redrawing from clear_user_area in on_resize brings
the frame along. Call it only after drawing over the frame's edge (when
the area was painted with fill_rect instead of clear_user_area, say).

The title bar uses the default font, but the font in force before the
call is put back, so `set_font(:ja)` does not have to be re-applied
every frame.
```ruby
@gfx.clear(FmrbGfx::BLACK)
draw_window_frame
@gfx.present
```

### FmrbApp#clear_user_area

<pre class="fmrb-sig"><code>clear_user_area() -&gt; void</code></pre>

theme page colour by default

Wipes the user area only -- and puts the frame back, and marks any FmrbUI
widget standing in the wiped area for redrawing. In a windowed app this
is what to use, not `gfx.clear`.

`gfx.clear` paints the whole canvas, taking the title bar and the border
with it.
```ruby
clear_user_area
@gfx.draw_text(4, 4, "Hi", theme_fg)
@gfx.present
```

### FmrbApp#clear_user_area_raw

<pre class="fmrb-sig"><code>clear_user_area_raw(<a href="../Integer/">Integer</a> color) -&gt; void</code></pre>

clear_user_area with nothing left out

The simple form. A negative color is the theme's page colour (the colour
key on a frameless window). The wrapper is clear_user_area (no colour is
the same as a negative one).
```ruby
clear_user_area_raw(-1)
```

### FmrbApp#detach_ui

<pre class="fmrb-sig"><code>detach_ui(<a href="../FmrbUI/">FmrbUI</a> ui) -&gt; void</code></pre>

Detach a widget box

Called by an app whose window can be resized, before it builds its
widgets again, to drop the old `FmrbUI`. Left attached, `clear_user_area`
keeps repainting it at the old coordinates. (A new `FmrbUI` attaches
itself.)
```ruby
def on_resize(w, h)
  detach_ui(@ui) if @ui
  @ui = FmrbUI.new(self)
  build_widgets
end
```

### FmrbApp#draw_resize_mark

<pre class="fmrb-sig"><code>draw_resize_mark(<a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Draw the resize mark

Draws a triangle in the title bar colour in the bottom-right corner of a
w x h window. `draw_window_frame` draws it for a resizable window, so **only**
**an app that draws its own frame calls it**, before the border. It draws
on `window_gfx`, so it does not work for an app with no canvas.
```ruby
draw_resize_mark(w, h)
```

### FmrbApp#theme_bg

<pre class="fmrb-sig"><code>theme_bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

page background from the system theme

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_bg)
```

### FmrbApp#theme_fg

<pre class="fmrb-sig"><code>theme_fg() -&gt; <a href="../Integer/">Integer</a></code></pre>

ink for text on theme_bg

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_fg)
```

### FmrbApp#theme_accent

<pre class="fmrb-sig"><code>theme_accent() -&gt; <a href="../Integer/">Integer</a></code></pre>

selection / emphasis colour

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_accent)
```

### FmrbApp#theme_border

<pre class="fmrb-sig"><code>theme_border() -&gt; <a href="../Integer/">Integer</a></code></pre>

rules, boxes, muted text

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_border)
```

### FmrbApp#theme_fg_light

<pre class="fmrb-sig"><code>theme_fg_light() -&gt; <a href="../Integer/">Integer</a></code></pre>

ink on accent or button backgrounds

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_fg_light)
```

### FmrbApp#draw_scrollbar

<pre class="fmrb-sig"><code>draw_scrollbar(<a href="../Integer/">Integer</a> scroll, <a href="../Integer/">Integer</a> total, <a href="../Integer/">Integer</a> visible) -&gt; void</code></pre>

Draw a scrollbar down the right edge

Draws the bar down the right edge. **The position stays yours** -- this
only paints it.
```ruby
draw_scrollbar(@scroll,
               @lines.size,
               visible_rows)
```

### FmrbApp#scrollbar_hit

<pre class="fmrb-sig"><code>scrollbar_hit(<a href="../Integer/">Integer</a> click_x, <a href="../Integer/">Integer</a> click_y) -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

Work out where the scrollbar was pressed

Where a click landed on the bar, or nil if it missed.
```ruby
case scrollbar_hit(ev[:x], ev[:y])
when :up   then @scroll -= 1
when :down then @scroll += 1
end
```

### FmrbApp#wheel_rows

<pre class="fmrb-sig"><code>wheel_rows(event ev) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Rows the wheel asks for

**Signed**; positive scrolls toward the start of a list (the wheel pushed
away). **nil** when the event is not a wheel, or its delta is 0. The rows
per notch is the machine's setting (`wheel_lines` in system_conf.toml),
not the app's. The scrollbar widget does not answer the wheel.
```ruby
rows = wheel_rows(ev)
@scroll -= rows if rows
```

### FmrbApp#wheel_notches

<pre class="fmrb-sig"><code>wheel_notches(event ev) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Wheel notches

The raw notch count, signed as `wheel_rows`. For a list whose rows are
not text rows (a row of tiles). nil when the event is not a wheel.
```ruby
n = wheel_notches(ev)
```

### FmrbApp#set_window_position

<pre class="fmrb-sig"><code>set_window_position(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; FmrbApp</code></pre>

Move the window

```ruby
set_window_position(20, 40)
```

### FmrbApp#request_fullscreen

<pre class="fmrb-sig"><code>request_fullscreen(bool on) -&gt; void</code></pre>

Ask to go full screen or come back

Asks to switch between full screen and a window.
**Nothing changes immediately** -- the VM keeps running and the answer arrives as
`on_resize`, by which time `fullscreen` and the user area are the new
ones.

Redraw in `on_resize`, not here.
```ruby
request_fullscreen(true)
```

### FmrbApp#toggle_fullscreen

<pre class="fmrb-sig"><code>toggle_fullscreen() -&gt; void</code></pre>

Switch between full screen and window

Switches between full screen and a window.
**The answer arrives as `on_resize`**, as with `request_fullscreen`.
```ruby
toggle_fullscreen if sc == 0x44
# 0x44 is F11
```

### FmrbApp#create_canvas_gfx

<pre class="fmrb-sig"><code>create_canvas_gfx(<a href="../Integer/">Integer</a> width, <a href="../Integer/">Integer</a> height) -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

Make a second canvas of its own

Makes another canvas owned by this app and returns an FmrbGfx bound to
it. It is deleted when the app ends, a crash included.

**It takes keyword arguments** -- the signature above is written
positionally because the type engine has no keywords. The real call is:

```ruby
g = create_canvas_gfx(
  width: 200, height: 100)
g.present(20, 40)
```

**Meant for fullscreen apps.** The window manager does not follow extra
canvases across a change of focus.

### FmrbApp#delete_canvas_gfx

<pre class="fmrb-sig"><code>delete_canvas_gfx(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; void</code></pre>

Let go of a canvas it made

```ruby
delete_canvas_gfx(@layer)
```

### FmrbApp#app_settings

<pre class="fmrb-sig"><code>app_settings() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

Read the app's own settings file

Returns `/home/<app_handle_name>.toml` as a Hash with String keys.
**It is `{}` when there is no file or it is not TOML** (the latter is
logged).
```ruby
city = app_settings["city"]
```

### FmrbApp#save_app_settings

<pre class="fmrb-sig"><code>save_app_settings(<a href="../Hash/">Hash</a>[untyped, untyped] values) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

Rewrite keys in the settings file

values is a Hash of key => value. **Only the lines of the keys given**
are rewritten and the rest stay as they are (the file is made when it is
missing). A key is `"city"` or `"section.key"`, and a nil value removes
it.

**It returns the Hash read back after writing, and nil when it could not**
**write, the read-back differs, or the file is not TOML** (the file is not
touched then; `FmrbToml.error` says why).
```ruby
save_app_settings({ "city" => name })
```

### FmrbApp#app_settings_path

<pre class="fmrb-sig"><code>app_settings_path() -&gt; <a href="../String/">String</a></code></pre>

Where the settings file is

```ruby
app_settings_path   #=> "/home/weather.toml"
```

### FmrbApp#app_handle_name

<pre class="fmrb-sig"><code>app_handle_name() -&gt; <a href="../String/">String</a></code></pre>

The app's handle name

The `app_handle_name` of the `.app.toml`, else the file name without
`.app.rb` (`step_sensor` for `/app/test/step_sensor.app.rb`), else `name`.
```ruby
app_handle_name   #=> "step_sensor"
```

### FmrbApp#app_state

<pre class="fmrb-sig"><code>app_state(?<a href="../String/">String</a> who) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

Read what the app remembered (lost on restart)

Returns `/tmp/<who>.state.toml` as a Hash with String keys. **It is gone**
**after a restart** (power on a device, the program on a PC, the page in a
browser), so the user's settings belong in `app_settings`. Only strings,
integers and true/false are kept. `who` (`app_handle_name` when left out)
is for a part of a program that keeps its own state. `{}` when the file
is missing or not TOML.
```ruby
dir = app_state("file_manager")["dir"]
```

### FmrbApp#save_app_state

<pre class="fmrb-sig"><code>save_app_state(<a href="../Hash/">Hash</a>[untyped, untyped] values, ?<a href="../String/">String</a> who) -&gt; bool</code></pre>

Remember for the next opening (lost on reboot)

Merges values into what was read and writes it. **Nothing is written when**
**no value changed.** Values that are not a string, integer or true/false
are **skipped silently**. Returns true when the file holds the values
(written now or already the same) and false when it could not be written.
```ruby
save_app_state({ "dir" => "/home" })
```

### FmrbApp#app_state_path

<pre class="fmrb-sig"><code>app_state_path(?<a href="../String/">String</a> who) -&gt; <a href="../String/">String</a></code></pre>

Where the remembered values are kept

```ruby
app_state_path   #=> "/tmp/weather.state.toml"
```

### FmrbApp#ev_ctrl?

<pre class="fmrb-sig"><code>ev_ctrl?(event ev) -&gt; bool</code></pre>

Whether Ctrl was held

Whether Ctrl was held; either side counts.

Match letter keys on **`ev[:scancode]`**. `ev[:keycode]` differs between
platforms (SDL values on Linux), while the scancode is the same USB HID
number everywhere.

```ruby
# Ctrl+S
if ev_ctrl?(ev) &&
   ev[:scancode] == 0x16
```

### FmrbApp#ev_shift?

<pre class="fmrb-sig"><code>ev_shift?(event ev) -&gt; bool</code></pre>

Whether Shift was held

```ruby
if ev_shift?(ev)
```

### FmrbApp#ev_alt?

<pre class="fmrb-sig"><code>ev_alt?(event ev) -&gt; bool</code></pre>

Whether Alt was held

```ruby
if ev_alt?(ev)
```

### FmrbApp#set_timer

<pre class="fmrb-sig"><code>set_timer(<a href="../Integer/">Integer</a> interval) -&gt; <a href="../Integer/">Integer</a></code></pre>

Ask to be called on a timer

Calls the block once, interval milliseconds later.
**It does not repeat** -- call `set_timer` again inside the block for that.

The moment it fires is rounded to the app loop's own tick, so it is not
accurate to the millisecond. The return value is the id `clear_timer`
takes.

Under Spinel a stored block **cannot capture an outer local variable**
(instance variables and constants are fine).

```ruby
@id = set_timer(500) { blink }
```

### FmrbApp#clear_timer

<pre class="fmrb-sig"><code>clear_timer(<a href="../Integer/">Integer</a> timer_id) -&gt; void</code></pre>

Stop a timer

Stops the timer whose id `set_timer` returned.
```ruby
@id = set_timer(500) { blink }
clear_timer(@id)
```

### FmrbApp#request_early_update

<pre class="fmrb-sig"><code>request_early_update() -&gt; void</code></pre>

End the wait now

**Call it from inside on_control or on_event.** It ends the wait so the
loop reaches `on_update` at once; use it when a message shows the app has
to act sooner than planned. **From on_update it does nothing**, because the
next wait is worked out there anyway.
```ruby
def on_control(msg)
  @due = Machine.board_millis + 200
  request_early_update
end
```

### FmrbApp#subscribe

<pre class="fmrb-sig"><code>subscribe(<a href="../String/">String</a> topic) -&gt; void</code></pre>

Start receiving a kind of notice

What is published under that name starts arriving at `on_control`.
```ruby
subscribe("clock/hour")
```

### FmrbApp#unsubscribe

<pre class="fmrb-sig"><code>unsubscribe(<a href="../String/">String</a> topic) -&gt; void</code></pre>

Stop receiving a kind of notice

```ruby
unsubscribe("clock/hour")
```

### FmrbApp#publish

<pre class="fmrb-sig"><code>publish(<a href="../String/">String</a> topic, ?untyped data) -&gt; void</code></pre>

Send a notice to everyone

Sends data to every app subscribed to that topic.

**One message carries at most 176 bytes.** For anything larger, write it
to `/tmp` and publish the path instead (`/tmp` lives in memory and is
gone on the next boot).
```ruby
publish("my_topic", { "n" => 1 })
```

### FmrbApp#send_message

<pre class="fmrb-sig"><code>send_message(<a href="../Integer/">Integer</a> dest_pid, <a href="../Integer/">Integer</a> msg_type, untyped data) -&gt; bool</code></pre>

Send a message to another app

Sends straight to one process (dest_pid). data is any value MessagePack
can pack (usually a Hash), and **the packed size may be 176 bytes at most**,
the same limit as `publish`. msg_type is `FmrbConst::MSG_TYPE_APP_CONTROL`.

**It returns true when sent, and false when the target has no queue**
**(wrong pid, already ended) or does not take it within one second** (also
logged). Over 176 bytes raises ArgumentError. The sender's pid is not put
in the message; add it yourself when you want a reply
(`"re" => FmrbApp.pid`).

The receiver reads only a Hash whose `"cmd"` is a String. The cmd names
the base owns (`resize`, `moved`, `suspend`, `resume`, `stop`,
`quit_request`, ...) are handled by the base, and **any other cmd reaches**
**`on_control` as the Hash** (if defined). A Hash without `"cmd"`, or
anything that is not a Hash, is dropped silently.
```ruby
send_message(pid,
  FmrbConst::MSG_TYPE_APP_CONTROL,
  { "cmd" => "hello",
    "re" => FmrbApp.pid })
```

### FmrbApp#sync_file

<pre class="fmrb-sig"><code>sync_file(<a href="../String/">String</a> path, ?dest: <a href="../String/">String</a>) -&gt; bool</code></pre>

Put a file on the graphics side

The same transfer as `FmrbGfx#sync_file`, for an app **with no canvas**.
It compares size and CRC32 and sends only when they differ. `dest:` (the
same path when left out) is the place on the graphics side. true on
success, false on failure.
```ruby
sync_file("/home/a.wav",
          dest: "/cache/a.wav")
```

### FmrbApp#request_file_select

<pre class="fmrb-sig"><code>request_file_select(<a href="../String/">String</a> mode, ?dir: <a href="../String/">String</a>) -&gt; void</code></pre>

Ask for a file chooser

Asks for the file dialog; the chosen path arrives at `on_control`.
Pass "open" or "save". dir: names the folder it opens in (one that does
not exist gives way to its nearest parent that does; left out, the
dialog opens where it always has).
```ruby
request_file_select("open")
request_file_select("save", dir: "/home/stamps")
```

### FmrbApp#request_file_select_raw

<pre class="fmrb-sig"><code>request_file_select_raw(<a href="../String/">String</a> mode) -&gt; void</code></pre>

request_file_select with nothing left out

The simple form. The wrapper is request_file_select (mode left out is
"open").
```ruby
request_file_select_raw("save")
```

### FmrbApp#request_run

<pre class="fmrb-sig"><code>request_run(<a href="../String/">String</a> path) -&gt; void</code></pre>

Run a file as an app

```ruby
request_run("/app/usr/mine.app.rb")
```

### FmrbApp#request_run_raw

<pre class="fmrb-sig"><code>request_run_raw(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> prev_pid) -&gt; void</code></pre>

request_run with nothing left out

The simple form. prev_pid is the app an earlier request started, which
the kernel stops first; negative for none. The wrapper is request_run
(prev_pid left out is none). The answer arrives at on_control as
run_result.
```ruby
request_run_raw("/app/usr/mine.app.rb", -1)
```

### FmrbApp#checkpoint

<pre class="fmrb-sig"><code>checkpoint() -&gt; <a href="../String/">String</a>?</code></pre>

Write this app to an image and close

Asks for this app to be stopped, written to an image
(`/tmp/<name>.ckpt`) and closed. The image is written at the break after
the message wait, so **asking from `on_event` or `on_update` is fine**.
Once written the app closes after `on_checkpoint`; given `restart: true`
the image is started again at once (`on_restore`). A refusal arrives as
`on_checkpoint_refused`. nil when asked, else a String saying why not.
```ruby
why = checkpoint(restart: true)
Log.warn(why) if why
```

### FmrbApp#move_to

<pre class="fmrb-sig"><code>move_to(<a href="../String/">String</a> to) -&gt; <a href="../String/">String</a>?</code></pre>

Move this app to another machine

Asks for this app to be moved to the Asterism machine `to` (its node
ID). The kernel asks that machine first whether it has the methods the
app calls, writes the image, carries it and closes the app here once it
is up there (`on_checkpoint` last here, `on_restore` there). When it
stays (refused, no answer), `on_checkpoint_refused` says why and the app
goes on. nil when asked, else a String saying why not.
```ruby
why = move_to("fmruby-abcdef")
Log.warn(why) if why
```

### FmrbApp#idle_gc=

<pre class="fmrb-sig"><code>idle_gc=(bool enable) -&gt; void</code></pre>

Collect garbage while idle

Set `true` in an app that has to keep a rhythm (playing a song,
animating). Collection runs **in small steps while the app waits**, so the
stops of 100 ms or more in the middle of a phrase become rare. **The**
**generational mode goes off and does not come back**, and a message waits
until the running step ends. Where it is unavailable it logs and leaves
everything as it was, with `idle_gc` still false.
```ruby
def on_create
  self.idle_gc = true
end
```

### FmrbApp#idle_gc

<pre class="fmrb-sig"><code>idle_gc() -&gt; bool</code></pre>

Whether to tidy up when idle

Whether the app collects garbage while it has nothing to do.
```ruby
idle_gc   #=> false (not asked for yet)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
