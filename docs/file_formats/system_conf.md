# System Configuration (`/etc/system_conf.toml`, `/etc/wifi.toml`)

Two files in `/etc` decide how the system starts and behaves. Both are TOML, both live on the
device's flash, and both can be edited with the on-device editor.

| File | Holds |
|---|---|
| `/etc/system_conf.toml` | Screen, input, theme, autostart, shortcuts, remote desktop |
| `/etc/wifi.toml` | Your network's name and password |

!!! warning "Flashing replaces them"
    Writing firmware rewrites the whole flash image, `/etc` included. Copy anything you have
    customised off the device first — see [Console](../getting_started/console.md).

## Editing

**From the Config dialog.** The system menu → **Config** covers the settings people actually
change (below), and writes them back line by line, so your comments and everything else in
the file survive. On hardware it also offers **Save & Reboot**, because several of these only
take effect at startup.

**From the editor.** For anything the dialog does not offer, open the file in the
**Editor**, change it, save, and reboot from **Reset**.

## `/etc/system_conf.toml`

### Display

| Key | Type | Meaning |
|---|---|---|
| `system_name` | string | Name shown at boot and in About |
| `display_width` / `display_height` | int | Framebuffer size. 426 x 240 on Modern, 320 x 240 on Retro |
| `display_margin_x` / `display_margin_y` | int | Pixels to keep clear at the edges. Retro needs a margin because a CRT hides the border under overscan; Modern shows the whole framebuffer, so both are 0 |
| `default_user_app_width` / `default_user_app_height` | int | Window size an app gets when its `.app.toml` does not say |
| `display_mode` | string | Which display driver to use (below) |

`display_mode` is one of `ntsc_ipc` (Retro, composite video via the second chip),
`tab5_dsi` (Modern, the built-in panel), `sdl2` (the Linux simulator), `spi_direct`,
`atom_display`, `headless`.

!!! warning "A typo here is silent"
    An unrecognised `display_mode` falls back to `ntsc_ipc` without complaining. If a Modern
    board reports `ntsc_ipc` in its boot log, the value is misspelt.

### Input

| Key | Type | Meaning |
|---|---|---|
| `keyboard_layout` | `"jp"` / `"us"` | Which keyboard you have. Get this wrong and the symbols land in the wrong places |
| `mouse_scale_x` / `mouse_scale_y` | float | Pointer speed. 0.5 halves it, 2.0 doubles it |

### System

| Key | Type | Default | Meaning |
|---|---|---|---|
| `language` | `"en"` / `"ja"` | `"en"` | UI language. Apps that provide `app_screen_name_<lang>` follow it |
| `timezone` | string | | POSIX timezone, e.g. `JST-9`, `UTC`, `EST5` |
| `debug_mode` | bool | `true` | Extra logging |
| `ble_auto_start` | bool | `true` | Start BLE at boot |
| `wifi_auto_start` | bool | `false` | Start Wi-Fi at boot |

!!! note "On Retro these two conflict"
    The ESP32-S3 has one radio. If `ble_auto_start` is true, Wi-Fi will not start no matter
    what `wifi_auto_start` says. Modern's ESP32-C6 runs both. See
    [Connecting to Wi-Fi](../getting_started/wifi.md).

### `[theme]`

Nine colours, each an RGB332 byte:

```toml
[theme]
desktop_bg = 0xF6
menu_bg    = 0xC5
window_bg  = 0xFF
text       = 0x00
text_light = 0xFF
highlight  = 0xEE
border     = 0x60
button     = 0x60
dir_color  = 0x03
```

The Config dialog offers three presets — `light`, `dark`, `classic` — and expands the one you
pick into these nine entries on save. Edit them by hand for anything else.

Apps can read the same values as `FmrbConst::THEME_*`, so a well-behaved app follows the
system theme. See [Constants & System Info](../api/const.md).

### `[[shortcuts]]`

Single letters that start an app from the desktop:

```toml
[[shortcuts]]
key = "l"
app = "launcher"

[[shortcuts]]
key = "e"
app = "default/editor"

[[shortcuts]]
key = "n"
app = "app/tool/nsf_player.app.rb"
```

`app` is either a built-in name (`launcher`, `file_manager`, `log_viewer`), a system app path
(`default/shell`, `default/editor`), or a path to a file. See
[The Desktop](../getting_started/desktop.md).

### `[[sync_files]]`

Files the core copies to the graphics side at boot, for assets that have to live over there:

```toml
[[sync_files]]
src  = "/usr/share/sounds/nsf/test.nsf"
dest = "/flash/data/test.nsf"
```

The copy is skipped when the destination already matches, so this costs nothing on a normal
boot.

### `[remote_desktop]`

**Modern only.** Serving the device's screen over Wi-Fi:

```toml
[remote_desktop]
enable = true
mode = "h264"              # "h264" or "mjpeg"
fps_cap = 15
jpeg_quality = 80
h264_bitrate_kbps = 1000
h264_gop = 30
```

Each key is explained in [Remote Desktop](../remote_desktop.md).

## `/etc/wifi.toml`

```toml
[wifi]
enable = true
ssid = "your-ssid"
password = "your-password"
hostname = "fmruby"
```

| Key | Meaning |
|---|---|
| `enable` | `false` keeps the credentials but does not connect |
| `ssid` / `password` | Your network. 2.4 GHz only |
| `hostname` | mDNS name. `fmruby` makes the device `fmruby.local` |

**Released firmware ships without this file** — a public build cannot carry your password —
so you create it once on the device. Full instructions are in
[Connecting to Wi-Fi](../getting_started/wifi.md).

!!! note "It is not in the repository either"
    `flash/etc/wifi.toml` is in `.gitignore`, so credentials never reach a commit. If you
    build the firmware yourself, put yours in `config/wifi_p4.toml` and the build copies it
    into the image.

## Related

- [The Desktop](../getting_started/desktop.md) — the Config dialog and what it changes
- [Connecting to Wi-Fi](../getting_started/wifi.md)
- [App Config (.app.toml)](app_toml.md) — per-app settings, a different file
- [Constants & System Info](../api/const.md) — reading these values from an app
