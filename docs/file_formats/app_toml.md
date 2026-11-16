# App Config File (.app.toml)

!!! note
    This page is about per-app settings. For the system's own settings —
    `/etc/system_conf.toml` and `/etc/wifi.toml` — see
    [System Configuration](system_conf.md).

A Family mruby app consists of an `.app.rb` main file paired with an `.app.toml` file of the same name. The `.app.toml` file specifies the app name, window settings, and other options. A Ruby app can instead carry the same keys in a `#---fmrb` comment at the top of the `.rb` ([below](#metadata-in-the-rb-file)), and can use both.

## File Naming Rules

```
<app_handle_name>.app.rb       # App main file
<app_handle_name>.app.toml     # Config file
```

Example:

```
my_clock.app.rb
my_clock.app.toml
```

Place the pair under `/app/<category>/` (where `category` is any subdirectory such as `demo`, `game`, `tool`, etc.).


!!! note "When the `.toml` is required"
    Launching a file directly — double-clicking it in the File Manager — needs the matching
    `.app.toml`; without it the spawn is refused and the desktop says why. Running from the
    editor with `F5`, or from the shell, works without one; the filename becomes the app name.

| Language | Extension |
|---|---|
| mruby | `.app.rb` |
| Lua | `.app.lua` |
| BASIC | `.app.bas` |
| MicroPython | `.app.py` |
| WebAssembly (C, TinyGo, Rust, Zig) | `.app.wasm` — see [WebAssembly Apps](../wasm_apps.md) **(development version)** |

## Key Reference

| Key | Type | Required | Default | Purpose |
|---|---|---|---|---|
| `app_handle_name` | string | Optional | (none) | A handle name, conventionally the base name of the main file. The system does not read it |
| `app_screen_name` | string | Optional | the file name | Display name shown on-screen and in the launcher |
| `class` | string | Optional | (none) | The class to start (`"MyApp"`). Without it, the one `FmrbApp` subclass the file defines is started (a subclass that is the parent of another is not counted). Needed when a file defines more than one |
| `default_window_mode` | string | Optional | `"window"` | `"window"` / `"fullscreen"` / `"background"` |
| `default_window_width` | integer | Optional | `100` | Window width (px) |
| `default_window_height` | integer | Optional | `100` | Window height (px) |
| `default_window_pos_x` | integer | Optional | `50` | Window top-left X coordinate |
| `default_window_pos_y` | integer | Optional | `50` | Window top-left Y coordinate |
| `resizable` | integer (0/1) | Optional | `0` | Set to `1` to allow user resizing |
| `min_window_width` | integer | Optional | `0` | Smallest width the user may resize to. `0` uses the system default (64) |
| `min_window_height` | integer | Optional | `0` | Smallest height the user may resize to. `0` uses the system default (64) |
| `large_memory` | integer (0/1) | Optional | `0` | Set to `1` to allocate a larger heap (for memory-intensive apps) |
| `launcher_visible` | bool / string | Optional | `true` | Set to `false` or `0` to hide the app from the launcher |
| `rounded_corners` | bool / string | Optional | `true` | Set to `false` to disable window corner transparency (optimization to gain fps) |
| `app_screen_name_<lang>` | string | Optional | (none) | Localized display name, e.g. `app_screen_name_ja`. Used when the system language matches; otherwise `app_screen_name` |
| `task_stack_kb` | integer | Optional | 16 | The app task's C stack, in KB. Raise it only if the app hits a stack protection fault. Clamped to 16-64 |
| `fullscreen_switchable` | integer (0/1) | Optional | `0` | Set to `1` if a fullscreen app can be parked and restored on `Ctrl` + `Tab` (it must rebuild its canvas in `on_resume`) |
| `fullscreen_hires` | bool | Optional | `false` | Let a fullscreen app run at 640x360 while it is fullscreen (Modern and the browser build). The size arrives in `on_resize` |
| `window_frame` | string | Optional | `"normal"` | `"none"` for a window with no frame, title bar or close button ([below](#frameless-windows)) |
| `window_drag` | string | Optional | `"title"` (framed), `"anywhere"` (frameless) | Where the window can be grabbed and moved: `"title"`, `"anywhere"` or `"none"` |
| `single_instance` | bool | Optional | `false` | Refuse a second copy of the same file |
| `exclusive_group` | string | Optional | (none) | Refuse to start while another app with the same name (up to 15 bytes) runs, for apps that share a single resource |
| `movable` | bool | Optional | `false` | The app may be written to an image and moved to another machine ([Moving a running app](../api/fmrb_app.md#moving-a-running-app)) |
| `requires` | array | Optional | (none) | Method names a movable app cannot go on without; it is not moved to a build that lacks them |
| `screens` / `needs_pointer` | array / bool | Optional | (none) | For the keyboard-only desktop of the Linux program (320x170): the screen shapes the app can draw (`["426x240", "320x170"]`), and `needs_pointer = false` when it works without a mouse. Write them before the first `[table]` |
| `icon` | string | Optional | (default per extension) | Icon file path (`.icon` format) |

## Window Modes

| Mode | Behavior | Size / Position |
|---|---|---|
| `window` | Window with title bar | Uses `default_window_*` values |
| `fullscreen` | Occupies the entire screen (other apps are suspended) | Size matches screen resolution; position is fixed at `(0, 0)` |
| `background` | Headless: no window, runs in the background (`@gfx` is `nil`) | Not applicable |

In `fullscreen` mode the app's area is the entire screen. In `window` mode it is the area inside the title bar (11px) and borders. Either way `@gfx` draws from its top-left as (0, 0), and its size is `@user_area_width` × `@user_area_height`.

A fullscreen app can also declare `fullscreen_switchable = 1`, which lets the user park it
with `Ctrl` + `Tab` and come back to it later. See
[The Desktop > Switching between apps](../getting_started/desktop.md#switching-between-apps).

## Minimal Example

```toml
app_handle_name = "hello"
app_screen_name = "Hello"
default_window_mode = "window"
default_window_width = 160
default_window_height = 80
default_window_pos_x = 20
default_window_pos_y = 30
```

Corresponding Ruby file:

```ruby
# /app/demo/hello.app.rb
class HelloApp < FmrbApp
  def on_create
    clear_user_area
    @gfx.draw_text(4, 4, "Hello!", theme_fg)
    @gfx.present
  end

  def on_update; 500; end
end
```

There is no start code at the end of the file: the runtime starts the `FmrbApp` subclass the
file defines.

## Metadata in the `.rb` file

The same keys can go in a comment at the top of the `.rb`, so a one-file app needs no
`.app.toml`. The block sits within the first 512 bytes, before the first line of code, and
is TOML with `# ` in front of each line:

```ruby
#---fmrb
# app_screen_name = "Hello"
# default_window_width = 200
# default_window_height = 120
#---
class HelloApp < FmrbApp
```

- When both are there they are merged key by key, and **a key in the `.app.toml` wins**: the
  comment can hold the defaults and the `.app.toml` override some of them.
- Only `.rb` files are read this way (`.lua`, `.bas` and `.py` use other comment marks).
- The launcher lists an `.app.rb` that has only the comment too.
- An app distributed through the App Store needs an `.app.toml`: its `app_id` and the other
  installation keys are read from there.
- From Ruby, `FmrbApp.app_meta(path)` returns an app file's merged metadata as a Hash of Strings.

## Frameless Windows

```toml
window_frame = "none"
```

A window with no frame, title bar or close button, for an avatar or a mascot. The app's area
is the whole window and its ground is transparent, so only what the app draws shows. The
window is moved by dragging it anywhere (`window_drag = "anywhere"`, the default here); a
press that does not move is a click, and holding still for a second is a long press. A right
click or a long press calls `on_frameless_right_click(ev)`, which by default opens the window
menu (Send to, Reload, Close); Ctrl+Q also closes it.

By default the whole rectangle of the window takes clicks. To let clicks through where
nothing is drawn, declare the shape: `set_hit_shape([[x, y, w, h], ...])`,
`set_hit_mask(hit_mask_from_art(rows, transparent: ".", scale: 3), x, y)` or
`add_hit_sprite(sprite)`. A press outside it reaches the window behind. The sample is
`/app/demo/avatar.app.rb`.

## Fullscreen App Example

```toml
app_handle_name = "shooter"
app_screen_name = "Shooter"
default_window_mode = "fullscreen"
```

In `fullscreen` mode, window size and position are ignored.

## When Large Memory Is Needed

Setting `large_memory = 1` selects a larger memory pool slot at startup. Currently only one slot is available.

## Specifying an Icon

```toml
icon = "usr/share/icon/blockgame.icon"
```

- Place the file under `/usr/share/icon/`
- The format is a text-based format. See [Image and Icon Files](image_formats.md#icon-files-icon) for details
- If `icon` is omitted, a default icon based on the main file extension is used (`.rb` -> ruby, `.lua` -> lua, `.bas` -> basic, `.py` -> python, `.wasm` -> wasm)

## Hiding from the Launcher

You can hide development or debug apps by setting `launcher_visible = false`.

```toml
launcher_visible = false
```

## Resizable Windows

```toml
resizable = 1
```

Set to `1` to enable resizing. The base class calls `on_resize(w, h)`, so override it in your subclass to handle redrawing.

## App Placement

```
/app/
├── demo/                   # Samples and demos
├── game/                   # Games
│   └── rpg_demo/           # Assets can be placed alongside the app
│       ├── rpg_demo.app.rb
│       ├── rpg_demo.app.toml
│       ├── world.bmp
│       └── world.map.json
├── tool/                   # Tools
└── (any name)/
    ├── myapp.app.rb
    └── myapp.app.toml
```

The launcher scans subdirectories directly under `/app` to detect `.app.toml` files. It also scans one level deeper (`/app/<category>/<bundle>/*.app.toml`), so you can group images, maps, and other assets together with the app in the same directory.

!!! note "Scanning happens only at startup"
    The app list is scanned once at system startup. After adding a new app via `create_app` or BLE, open the launcher and right-click to rescan, or restart the device (see [Hello World - Reflecting changes in the launcher](../getting_started/hello_world.md#reflecting-changes-in-the-launcher)).

## Related

- For how to create apps, see [Hello World](../getting_started/hello_world.md)
- For how to create icon files, see [Image and Icon Files](image_formats.md#icon-files-icon)
