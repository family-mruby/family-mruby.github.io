# App Config File (.app.toml)

!!! note
    This page is about **per-app** settings. For the system's own settings —
    `/etc/system_conf.toml` and `/etc/wifi.toml` — see
    [System Configuration](system_conf.md).

A Family mruby app consists of an `.app.rb` main file paired with an `.app.toml` file of the same name. The `.app.toml` file specifies the app name, window settings, and other options.

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

## Key Reference

| Key | Type | Required | Default | Purpose |
|---|---|---|---|---|
| `app_handle_name` | string | Recommended | (none) | Internal handle name for the app. Should match the base name of the main file |
| `app_screen_name` | string | Optional | `nil` | Display name shown on-screen and in the launcher |
| `default_window_mode` | string | Optional | `"window"` | `"window"` / `"fullwindow"` / `"fullscreen"` |
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
| `icon` | string | Optional | (default per extension) | Icon file path (`.icon` format) |

## Window Modes

| Mode | Behavior | Size / Position |
|---|---|---|
| `window` | Window with title bar | Uses `default_window_*` values |
| `fullwindow` | Full window without title bar | Uses `default_window_*` values |
| `fullscreen` | Occupies the entire screen (other apps are suspended) | Size matches screen resolution; position is fixed at `(0, 0)` |
| `background` | Not supported: headless (no display) | Not applicable |

In `fullscreen` mode, `@user_area_*` refers to the entire screen. In `window` mode, `@user_area_*` is the area excluding the title bar (11px) and borders.

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
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello!", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end

  def on_update; 500; end
end

HelloApp.new.start
```

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
icon = "usr/share/icon/tetris.icon"
```

- Place the file under `/usr/share/icon/`
- The format is a text-based format. See [Image and Icon Files](image_formats.md#icon-files-icon) for details
- If `icon` is omitted, a default icon based on the main file extension is used (`.rb` -> ruby, `.lua` -> lua, `.bas` -> basic)

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
