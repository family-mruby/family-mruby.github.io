# The Desktop

The desktop is the same on both machines: a menu bar across the top, the wallpaper below it,
and windows on top of that.

<div align="center">
  <img src="../../images/tab5_desktop.png" width="640" alt="The desktop">
</div>

## The menu bar

Everything the system wants to tell you lives in this 13-pixel strip.

```
┌─────────────────────────────────────────────────────────────────────┐
│ Family mruby  ▪▪            137KB  B  ▂▄▆   08/07 21:04:11          │
└─────────────────────────────────────────────────────────────────────┘
  ↑             ↑             ↑      ↑  ↑     ↑
  system menu   running apps  RAM    BLE Wi-Fi clock
```

### Family mruby

Click it for the system menu. See [the list below](#the-system-menu).

### Running apps (the taskbar)

Each running app gets a small square, in the order they started, immediately right of the
title. This is the taskbar.

- **The letter** is the first character of the app's name
- **The colour** is the language it runs on:

    | Colour | Language |
    |---|---|
    | Red | Ruby (mruby) |
    | Blue | Lua |
    | Green | BASIC |
    | Yellow | MicroPython |
    | Gray | Native C |

- **A white border** marks the app that currently has keyboard focus
- **Click a square** to bring that app to the front and give it the keyboard

An app parked by `Ctrl` + `Tab` (see [below](#switching-between-apps)) stays in the taskbar
while it is frozen, so you can always click your way back to it.

### Free internal RAM

The figure on the right — `137KB` in the example — is the **free internal RAM**, not the
total free memory.

This is the number worth watching. Apps get their heaps from PSRAM, which is plentiful, but
every running app also costs roughly 25 KB of internal RAM for its task and buffers, and
internal RAM is what runs out first. The readout answers "can I open one more app?" at a
glance.

The Linux simulator has no such limit and shows `---KB`.

### BLE

| Appearance | Meaning |
|---|---|
| Nothing | BLE is off |
| Gray box, white `B` | BLE is on, waiting for something to connect |
| White box, inverted `B` | A client is connected — the [web console](console.md), typically |

Start and stop BLE from the system menu; `ble_auto_start` in **Config** decides whether it
comes up at boot.

### Wi-Fi

Signal bars, just left of the clock.

| Appearance | Meaning |
|---|---|
| White bars | Connected |
| Gray bars with a red slash | Not connected |
| Nothing | This build has no Wi-Fi |

**Click the bars** to open the Network dialog, which shows the address the device was given.
See [Connecting to Wi-Fi](wifi.md).

### Clock

Date and time. Set it from **Set Clock**; the timezone is a separate setting under
**Config**.

## The system menu

<div align="center">
  <img src="../../images/tab5_menu.png" width="600" alt="The system menu">
</div>

| Item | What it does |
|---|---|
| Launcher | The grid of installed apps |
| File Manager | Browse the flash filesystem |
| Log Viewer | The system log |
| Monitor | Running tasks and memory |
| Set Clock | Date and time |
| Config | Language, keyboard layout, pointer speed, theme, timezone, Wi-Fi and BLE autostart, display margins |
| Storage | Clear cached files |
| Network | Wi-Fi state, address, hostname |
| About | Version and chip information |
| Reset | Reboot |

Whatever **Config** changes is written back into `/etc/system_conf.toml`, keeping your
comments and other settings intact. On hardware the dialog offers **Save & Reboot** for the
settings that only take effect at startup.

## The launcher

<div align="center">
  <img src="../../images/tab5_launcher.png" width="600" alt="The launcher">
</div>

Double-click an icon to start an app. Arrow keys move the selection and `Enter` starts it.

!!! tip "The list is built once, at boot"
    The launcher scans the filesystem when the desktop starts. After you add an app,
    **right-click inside the launcher window** to rescan — otherwise your new app will not
    appear until the next reboot.

## Windows

| Action | How |
|---|---|
| Move | Drag the title bar |
| Focus | Click anywhere in the window, or click its taskbar square |
| Close | The button in the title bar, or `Ctrl` + `Q` |
| Resize | Drag the corner — only for apps that declare `resizable` |

A click is decided on release, with a small movement tolerance, so a slightly shaky press
does not turn into a drag.

## Keys

### Always

| Key | Effect |
|---|---|
| `Ctrl` + `Q` | Close the app in the foreground, including a fullscreen one |
| `Ctrl` + `Tab` | Switch between running apps |

Both are handled before the event reaches any app, so they work even when a fullscreen app
has the whole screen.

### On the desktop

With no app focused and no dialog open, a single letter starts an app:

| Key | Starts |
|---|---|
| `L` | Launcher |
| `S` | Shell |
| `E` | Editor |
| `N` | NSF player |
| `I` | HID Inspector |

That list is the `[[shortcuts]]` section of `/etc/system_conf.toml`. Add your own by naming
the app's path.

## Switching between apps

`Ctrl` + `Tab` does one of two things, depending on what is in front.

### Windowed apps: cycle

It moves round-robin through the running apps, skipping the desktop. The window comes to the
front **and takes the keyboard**, so you can `Ctrl` + `Tab` from the editor to your app, type
into it, and `Ctrl` + `Tab` back to keep editing.

### A fullscreen app: park it

Pressing `Ctrl` + `Tab` inside a fullscreen app **parks** it: the app freezes exactly where
it is, its canvas is hidden, and the desktop and the other apps come back.

Parking is a freeze, not a restart. The app's state and the contents of its canvas are kept,
so returning to it — by cycling round to it again, or by clicking its taskbar square —
restores the screen it had. It does not have to redraw from scratch, and it does not lose
your place.

!!! note "An app has to opt in"
    Only an app that declares `fullscreen_switchable = 1` in its
    [`.app.toml`](../file_formats/app_toml.md) can be parked. Others ignore `Ctrl` + `Tab`
    while fullscreen.

    The declaration means "it is fine to freeze me mid-run". An app that leaves the sound
    chip playing should not declare it: frozen or not, the sound keeps going.

The bundled presentation tool, PicoRabbit, declares it — so you can leave a slide, go do
something else, and come back to the same slide.

## Related

- [Modern (M5Stack Tab5)](modern.md) / [Setup (Retro)](setup.md)
- [Default Apps](default_apps.md) — what is in the launcher
- [System Configuration](../file_formats/system_conf.md) — what Config writes, and everything it does not offer
- [App Config (.app.toml)](../file_formats/app_toml.md) — how your app declares its window
- [Connecting to Wi-Fi](wifi.md)
