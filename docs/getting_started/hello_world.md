# Hello World

Run a minimal GUI app that displays "Hello, mruby!" on screen, and learn the workflow for writing your own apps.

!!! note "This page covers a GUI app example"
    Family mruby apps fall into two main categories: GUI apps that draw to the screen, and headless apps that run in the background without a display. This page walks through a minimal GUI app.
    Headless apps are not yet supported, but you can run scripts from the Shell app.

## Minimal app structure

A Family mruby app consists of a pair of 2 files.

```
hello.app.rb       # App body (Ruby)
hello.app.toml     # Configuration file
```

Place both files under `/app/<directory-of-your-choice>/`, then rescan from the launcher ([described below](#reflecting-changes-in-the-launcher)) or restart the board, and the app icon will appear.

## Step 1: A minimal app that just displays text

Start with an app that simply puts text on screen, without worrying about window management.

### `.rb` file

```ruby
# hello.app.rb
class HelloApp < FmrbApp
  def on_create
    @gfx.clear(FmrbGfx::BLACK)
    @gfx.draw_text(0, 0, "Hello, mruby!", FmrbGfx::WHITE)
    @gfx.present
  end
end

HelloApp.new.start
```

Code explanation

| Code | Role |
|---|---|
| `class HelloApp < FmrbApp` | App class that inherits from `FmrbApp` |
| `on_create` | Initialization called once at startup |
| `@gfx.clear(...)` | Fills the entire canvas with black |
| `@gfx.draw_text(0, 0, ...)` | Draws text at the top-left corner (0, 0) of the window |
| `@gfx.present` | Flushes the buffer to the screen (required) |
| `HelloApp.new.start` | Runs the app |


!!! warning "This sample does not allow closing the window"
    `@gfx.clear` fills the entire canvas including the title bar. The title bar and close button drawn by the `FmrbApp` base class at startup are overwritten and disappear, so the close button is no longer visible on screen.
    The next sample adds window frame drawing.

### `.app.toml` file

Create `hello.app.toml` in the same directory:

```toml
app_handle_name = "hello"
app_screen_name = "Hello"
default_window_mode = "window"
default_window_width = 160
default_window_height = 60
default_window_pos_x = 30
default_window_pos_y = 40
```

| Key | Purpose |
|---|---|
| `app_handle_name` | Internal handle name (should match the base name of the `.rb` file) |
| `app_screen_name` | Display name shown in the launcher and title bar |
| `default_window_mode` | `"window"` / `"fullwindow"` / `"fullscreen"` |
| `default_window_width/height` | Window size (px) |
| `default_window_pos_x/y` | Top-left coordinates of the window |

See [App configuration file (.toml)](../file_formats/app_toml.md) for a full list of keys.

## Step 2: Displaying the window frame

To make a practical GUI app, you need to keep the title bar and close button visible by paying attention to the following:

1. Fill only the app's drawable area (user area) instead of the entire window (so the title bar and border are not erased)
2. Call `draw_window_frame` after drawing (to re-render the title bar provided by the base class)

```ruby
# hello.app.rb (Step 2)
class HelloApp < FmrbApp
  def on_create
    redraw
  end

  def on_update
    500
  end

  def redraw
    clear_user_area(FmrbGfx::WHITE)   # Fill user area with white
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello, mruby!", FmrbGfx::BLACK)
    draw_window_frame                  # Redraw title bar and border
    @gfx.present # Flush to screen
  end
end

HelloApp.new.start
```

| Change | Reason |
|---|---|
| `@gfx.clear(FmrbGfx::BLACK)` to `clear_user_area(FmrbGfx::WHITE)` | Limits the drawing range to the user area, protecting the title bar. Background changed to white |
| Text color from `WHITE` to `BLACK` | Better readability on a white background |
| Added `draw_window_frame` | Redraws the frame provided by the base class. The close button becomes visible |
| Drawing logic extracted into `redraw` | Organized for easier redraws later |

!!! tip "`clear_user_area(color)` helper"
    `FmrbApp` provides a `clear_user_area(color = FmrbGfx::BLACK)` helper, which is syntactic sugar for `@gfx.fill_rect(@user_area_x0, @user_area_y0, @user_area_width, @user_area_height, color)`. To specify a color, pass it like `clear_user_area(FmrbGfx::BLUE)`.

With this:

- You can close the app by clicking the X button in the top-right of the title bar
- You can reload (`request_reload`) by right-clicking the title bar
- The drawing area stays within `@user_area_*` and does not interfere with the frame

!!! tip "What are @user_area_* variables?"
    `@user_area_x0`, `y0`, `x1`, `y1`, `width`, `height` are the coordinates of the area where the app is free to draw, excluding the title bar and borders. In `@fullscreen` mode, this covers the entire screen. See [FmrbApp > Key instance variables](../api/fmrb_app.md#主要インスタンス変数) for details.

## Transferring files to the board

Transfer the `hello.app.rb` and `hello.app.toml` files written on your PC to `/app/myapps/` on the board.

The standard transfer method is the Console (a web tool via BLE). See [Console](console.md) for details.

Directory layout after transfer:

```
/app/
├── demo/
├── game/
├── tool/
└── myapps/         ← Directory you create
    ├── hello.app.rb
    └── hello.app.toml
```


## Launching and displaying on screen

1. After the file transfer is complete, open the launcher and right-click to rescan (or restart the board)
2. The title bar shows "Rescanning..." — wait 1-2 seconds and the new "Hello" app icon will appear
3. Double-click the icon (or click with the mouse then press Enter)
4. "Hello, mruby!" is displayed on screen

With the Step 2 version, you can close the app by clicking the X button on the right side of the title bar.

## Editing and reloading

When you want to update an app:

1. Edit `hello.app.rb` on your PC
2. Re-upload via the Console (overwrite with the same name)
3. Right-click the app's title bar — a confirmation dialog appears and the app reloads

Since it restarts on a per-file basis, you can develop without waiting for a full reboot.

## Shortcut: Generate a template with `create_app`

Writing `.rb` and `.toml` files from scratch every time is tedious. The Family mruby shell has a `create_app` command that generates a complete set of template files based on Step 2 in one shot.

### Usage

Launch Shell from the launcher and run:

```
> create_app my_clock
Created: /app/usr/my_clock.app.rb
Created: /app/usr/my_clock.app.toml
Tip: edit it with `edit /app/usr/my_clock.app.rb`
```

This creates:

- `/app/usr/my_clock.app.rb` — Based on Step 2 (includes `clear_user_area` + `draw_window_frame`, with templates for all `on_*` lifecycle methods)
- `/app/usr/my_clock.app.toml` — Standard-sized window configuration

These 2 files are generated. They become visible after following "Reflecting changes in the launcher" below.

### Reflecting changes in the launcher

The launcher scans and fixes the app list at startup, so newly added files do not appear automatically. To trigger a rescan:

1. Open the launcher (menu bar: `Family mruby` > `Launcher`)
2. Right-click inside the launcher window
3. The title bar briefly changes to "Rescanning..." (indicating the request was accepted)
4. Wait 1-2 seconds (rescanning `/app/` in the background)
5. The title returns to "Launcher" and the new app icon has been added

!!! tip "A restart also reflects changes"
    Instead of the right-click rescan, restarting the board (unplug and replug USB) triggers a scan at boot that automatically adds apps to the launcher. The right-click method is more convenient when you want to move quickly.

!!! note "Icon images are cached"
    Existing icons (`ruby.icon` / `lua.icon` / `basic.icon`, etc.) use the cache already uploaded to the WROVER side, so they are not re-uploaded. The rescan time is mainly the cost of reading `.toml` files under `/app/`.

### Naming conventions

`<name>` must contain only lowercase alphanumeric characters and underscores, starting with a letter. Examples:

| Input | Generated class name | Display name |
|---|---|---|
| `hello` | `HelloApp` | `Hello` |
| `my_clock` | `MyClockApp` | `My Clock` |
| `snake01` | `Snake01App` | `Snake01` |

The class name is generated by converting snake_case to CamelCase with an `App` suffix, and the display name (`app_screen_name`) is generated in Title Case.

### Destination directory

Templates are placed in `/app/usr/` (created automatically). This is a dedicated directory for user-created apps, separate from categories like `demo`/`game`/`tool`.

### Existing file protection

If a file with the same name already exists, the command stops with an error (to prevent accidental overwrites). To continue, either delete the file with `rm` or choose a different name.

### Customizing the template

The template files themselves are located in `/usr/share/template/`:

```
/usr/share/template/app.rb.template
/usr/share/template/app.toml.template
```

Editing these files directly lets you customize the output of subsequent `create_app` calls to your preference. Placeholders:

| Placeholder | Meaning |
|---|---|
| `{{name}}` | Name in snake_case |
| `{{class}}` | Class name in CamelCase (with `App` suffix) |
| `{{title}}` | Display name in Title Case |

## Next steps

- Try drawing shapes: [FmrbGfx](../api/fmrb_gfx.md)
- Add event handling: [FmrbApp > Event handling](../api/fmrb_app.md#イベントハンドリング-on_eventev)
- Read existing samples: [Sample collection](../examples.md)

## Troubleshooting checklist

### Icon does not appear in the launcher

- Did you right-click in the launcher to rescan? (see [Reflecting changes in the launcher](#reflecting-changes-in-the-launcher))
- Is the `.toml` file in the same directory as the `.rb` file?
- Is `app_screen_name` specified in the `.toml`?
- Have you set `launcher_visible = false`?
- Is the file located under `/app/<dir>/`?

### App starts but closes immediately

- It may be crashing due to an exception. Check the logs:
    - Add `Log.info` in `on_create` to verify progress
    - Call `FmrbApp._get_last_error` from another app to check the most recent error

### Nothing appears on screen

- Check that `@gfx.present` is being called
- Check that drawing coordinates are within the `@user_area_x0 / y0 / width / height` range

### Close button is not visible

- `@gfx.clear` is erasing the entire canvas. Instead, fill within the `@user_area_*` range as in Step 2 and call `draw_window_frame`

See [Limitations](../limitations.md) for more details.
