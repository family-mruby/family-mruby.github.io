# The Linux Program

Family mruby also runs as one ordinary program on a Linux PC. It is the same system as on the
boards — the desktop, the editor, the shell, the bundled apps, the Ruby API — with Modern's
screen scaled up to fill the display. Picked at the login screen, it *is* the desktop: the
PC's own applications (a terminal, a browser) open as Family mruby windows beside your apps.

Items marked **(development version)** are on the development branch and in neither 3.0.0
nor its packages yet; they come with the next release.

## Installing

The package is a `.deb` attached to each [release on GitHub](https://github.com/family-mruby/family-mruby/releases).

| Package | For | Status |
|---|---|---|
| amd64 | A PC with **Ubuntu 26.04 or newer** (or a distribution with the same wlroots 0.19) | Attached to 3.0.0 |
| arm64 | Small arm64 Linux machines that use M5Stack's APPLaunch launcher (the Cardputer Zero), with an entry for the built-in screen and one for HDMI | **(development version)**. Built, not yet checked on that hardware |

Install it with apt, which pulls in the libraries it needs:

```bash
sudo apt install ./family-mruby_<version>_amd64.deb
```

apt also offers a few recommended packages. They are optional; without one, only its
feature is missing:

| Package | What it adds |
|---|---|
| `xwayland` | X11 applications (Wayland ones run without it) |
| `swaylock` | **Lock** in the power menu, and locking on suspend or lid close |
| `xdg-desktop-portal-wlr` | Sharing or recording the screen from a browser's video call |
| `fcitx5`, `fcitx5-mozc` (suggested) | Japanese kana–kanji input for Linux applications and Family mruby apps alike. Without them Family mruby's own kana input is used |

## What it installs and how it runs

| Path | What it is |
|---|---|
| `/usr/bin/family-mruby` | The program |
| `/usr/bin/family-mruby-session` | The login-screen session: starts the program and watches it |
| `/usr/share/wayland-sessions/family-mruby.desktop` | The **Family mruby** entry at the login screen |
| `/usr/share/family-mruby/root/` | The system's files (`/app`, `/usr`, `/etc` as shipped, the machine definitions), read-only |

In the login-screen session the program is **its own Wayland compositor**: it takes the
screen, keyboard, touchpad and mouse itself, draws the Family mruby screen at a whole-number
scale, and lays the Linux applications' windows over it at the display's full resolution.
Each Linux window gets a Family mruby title bar, frame and close button, and stacks, moves
and resizes with the other windows. Family mruby's sound goes through PipeWire or
PulseAudio.

If the program crashes, the session starts it again and says so in a notice; after the
fourth crash within a minute it gives up and the login screen comes back. The session's own
log is `~/.local/state/family-mruby/session.log`.

## First start

1. Log out. At the login screen, choose the **Family mruby** session (in the session menu of
   the display manager) and log in.
2. The Family mruby desktop comes up, in English. Change the language, the timezone and the
   rest under **Config** in the system menu, as on a board.
3. The keyboard layout follows Linux's (`keyboard_layout = "auto"`).

To try it without leaving your usual desktop, run it in a terminal instead:

```bash
family-mruby                         # in a window (the sdl machine definition)
family-mruby --machine linux_pc_wl   # as a compositor nested in the current desktop
```

## Machine definitions

How the program runs — which screen, input and sound to use, the screen size, the kind of
desktop — is chosen by a **machine definition**, a small TOML file. The packaged ones are in
`/usr/share/family-mruby/root/machines/`:

| Name | What it is |
|---|---|
| `sdl` | A window on an existing desktop. The default when no `--machine` is given |
| `linux_pc_wl` | The program as the Wayland compositor. What the login-screen session uses |
| `linux_pc` | An older way of being the session: one fullscreen window inside the `cage` compositor |
| `linux_pc_drm` | Straight on the display hardware (DRM/KMS) from a text console, no compositor |
| `cardputer_zero`, `cardputer_zero_hdmi` | The arm64 package's two launchers (the 320x170 built-in screen with a keyboard-only desktop, and HDMI) |

`--machine` takes a name or a path to your own file, and `--set key=value` changes one field
(`--set display.rotate=90`). A definition whose screen, input or sound cannot be opened is
refused with the reason (exit code 3) rather than quietly falling back to something else.

## Settings

### The login-screen session

The session reads `/etc/default/family-mruby-session` (a shell fragment; create it as root
if it is not there):

```sh
ROTATE=90                     # 0, 90, 180 or 270: turn a display mounted sideways
FMRB_ARGS="--set display.look=crt"   # more arguments for the program
```

In a virtual machine the session draws without the GPU (`WLR_RENDERER=pixman`) and draws the
pointer itself, because a virtual display adapter rarely gives the compositor a GPU it can
use. Setting `WLR_RENDERER=gles2` in the file tries the GPU anyway.

### The CRT look **(development version)**

The whole screen — Linux windows included — can be drawn as a CRT, with scanlines, a shadow
mask, glow, curvature and a vignette, plus NTSC colour bleed, flicker and noise. It needs the
GPU. Open **Display...** from the system menu: switch between Sharp and CRT, set each effect
from 0 to 100, or press **Standard** or **Strong** for a ready-made set. The choice applies
at once and is kept in `/etc/system_conf.toml` (`[crt]`), where it wins over `FMRB_ARGS`.

### The power menu

The button at the right end of the menu bar holds what the PC offers, each asking before it
acts:

| Entry | What it does |
|---|---|
| Lock | Locks the screen (needs `swaylock`; it asks for your Linux password) |
| Suspend | Suspends the PC |
| Log Out | Ends the session and returns to the login screen. Linux applications started inside are asked to close first, and ended if they are still there after a few seconds. The name is **(development version)**: 3.0.0 calls the same entry **Exit** |
| Restart | Restarts the PC |
| Power off | Shuts the PC down |

In the `sdl` window the menu has only **Exit**, which ends the program.

### Linux applications in the launcher

The launcher has a **Linux** section (the penguin) listing the applications installed on the
PC — what their `.desktop` files in `/usr/share/applications` and
`~/.local/share/applications` describe. Open the section, double-click an application, and
`..` goes back. Its right-click menu puts an application on the desktop, like a Family mruby
app. X11 applications start Xwayland the first time one is opened.

Window keys on the PC:

| Key or action | Effect |
|---|---|
| Double-click a title bar | Maximize, or restore |
| `Super` + arrows | Lay the window out: left or right half, maximize, restore |
| `Ctrl` + `Tab`, `Ctrl` + `,` | Always go to Family mruby, even when a Linux window has the keyboard |

### Opening files with Linux applications

The File Manager opens what Family mruby can open as it always does; any other kind of file
goes to Linux's default application for it. Right-click a file for **Open in Linux app**,
which lists the applications that take that type. The [file associations](../file_formats/associations.md)
table can name a Linux application as the target, too.

### Linux commands in the Shell

A line starting with `!` runs as a Linux command, in the Linux directory that matches the
Shell's current one (`/mnt/host/src` is `~/src`):

```
> !git status
> !ls -l
> !
```

`!` alone opens the Linux shell (bash, or sh) inside the Shell; `exit` or `Ctrl` + `D` comes
back. `Ctrl` + `C` stops the running command and `Ctrl` + `Shift` + `V` pastes into it.
Output colours are shown; full-screen programs such as `vim` or `top` are not supported.
See [Shell Commands](shell.md).

### Where your files are

Family mruby sees one filesystem, as on a board, but each top-level place is kept somewhere
on the PC:

| Inside Family mruby | On the PC |
|---|---|
| `/home`, `/etc`, `/app/usr` | `~/.local/share/family-mruby/` (`home/`, `etc/`, `app/usr/`) — yours, kept across updates |
| `/tmp`, `/var`, `/cache`, `/data` | `~/.cache/family-mruby/` — can be deleted; it is rebuilt |
| `/app`, `/usr`, `/lib`, `/help` … | `/usr/share/family-mruby/root/` — read-only; replaced by a package update |
| `/mnt/host` | Your Linux home directory, read and write |
| `/mnt/root` | Linux's `/`, read-only |

`/etc` is copied from the system's on the first start. After an update, settings that are
new in the package are added to it, and nothing you set is changed. Unlike a board, flashing
a new release does not wipe `/home`: installing a newer `.deb` leaves it as it is.

### Wi-Fi, Bluetooth, sound and notifications

Where NetworkManager and BlueZ are running (as on a usual Ubuntu desktop), Family mruby's
settings window drives them:

- **Wi-Fi** — the Network dialog's **Wi-Fi...** opens it: the networks in reach, Connect and
  Disconnect. A password goes to NetworkManager, which keeps it as its own tools do.
- **Bluetooth** — from the system menu: turn the adapter on or off, connect and disconnect
  devices paired before. Pairing a new device is done in Linux's own tool.
- **Volume** — the menu bar's speaker and Config's volume move the PC's output volume
  (PipeWire or PulseAudio), and so do the volume keys.
- **Notifications** from Linux applications show at the top right.

Without NetworkManager or BlueZ the network status still shows, and those pages are not there.

### Asterism

The package has no router set. Put the router in `/home/asterism/config.toml` as on a board
(see [Network](../api/network.md#asterism-objects-and-topics-across-machines)). A router
with TLS (`tls/...`) and the credentials `.tar` from the console work from the PC too
**(development version)**.

## Touchpad and touch screen **(development version)**

In the compositor session a tap on the touchpad clicks (one finger left, two right; tap and
drag to drag), two-finger scrolling scrolls by wheel steps, and a touch screen clicks and
drags where it is touched, rotated with `ROTATE`. In 3.0.0 the touchpad clicks only when
pressed down, and touch screens are not taken.

## Limits

- **Screen.** Family mruby's own screen is the display's resolution divided by two
  (1280x800 gives 640x400); a portrait or small display gets 426x240. Scaling is by whole
  numbers only, with black around. A fullscreen app shows Modern's 426x240 (or 640x360 for a
  high-resolution app) at the largest whole scale. One display only.
- **Linux windows** cannot go fullscreen on their own; maximize is the largest they get.
- **Shell's `!`** handles lines and colours only (`TERM=dumb`).
- **No SD card.** `/mnt/sd` and `/sd` do not exist; use `/mnt/host`.
- **No hardware pins.** GPIO, I2C, the GROVE port and the boards' sensors are not there.
- **Retro** (the two-chip machine) is not available as a Linux program; the
  [simulator](../tools/simulator.md) covers it.
- **Security.** Every Family mruby app may start Linux programs, run Linux commands and read
  and write your home directory through `/mnt/host` — with your Linux user's rights. Any
  Wayland application in the session can capture the screen and type into the focused
  window, as under X11. The remote debugger is off in the package; when turned on
  (`debugd = true` in `/etc/system_conf.toml`) it listens on 127.0.0.1 only. See also
  [Limitations](../limitations.md#security).

## Related

- [Choose your hardware](choose_hardware.md#other-ways-to-run-it)
- [Shell Commands](shell.md)
- [The Desktop](desktop.md)
- [Release Notes](../releases.md)
