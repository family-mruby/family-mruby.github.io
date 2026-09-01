# Family mruby Studio

The whole Family mruby machine, running in your browser. The firmware —
FreeRTOS kernel, Ruby VM, desktop, editor and sound — is compiled to
WebAssembly, so what boots here is the same OS the boards run, drawing the
same pixels. Nothing to install, no board required.

## Starting

Open the following URL and click the screen — the click is the power switch,
and it is also what lets the browser make sound, so you will hear the boot
jingle.

[https://family-mruby.github.io/studio/](/studio/)

On your very first visit the page reloads itself once (it installs a small
service worker that provides the isolation WebAssembly threads need). That is
normal.

## Requirements

- A recent Chrome or Firefox on a PC with a keyboard
- Safari is untested; phones and tablets are not supported (the machine wants
  a keyboard)

## What you can do

- Use the desktop: the top-left menu opens the launcher, the editor, the file
  manager and the rest; apps run side by side
- Write and run Ruby in the editor, with Japanese input
  (`Ctrl+Space` toggles kana, typed as romaji)
- Play the bundled apps and hear the internal sound chip
- Pick a theme (the web default is a neon look of its own; Classic is the
  device palette), a screen size up to 852x480, and a zoom — a larger screen
  means more room, not bigger pixels
- Go full screen. Where the browser allows it the machine keeps `Esc` for
  itself; where it does not, `Esc` leaves full screen instead of reaching the
  app

Theme and resolution are applied at boot, so changing one reloads the page.

## Your files

What you write is kept. Everything under `/home` — the programs you save,
your colours, your service list — stays in this browser between visits, and
goes nowhere else: it never leaves the machine you are reading this on.

The buttons under the screen download all of it as a single `.tar`, restore
it from that file, or erase it. Downloading is worth doing for anything you
care about: a private window keeps nothing, a browser may reclaim the space
after a long absence, and if you open the page twice only the first tab
saves. The same file restores your work here, or in another browser.

Everything outside `/home` is built fresh every time. Files written anywhere
else, and `/tmp` above all, are gone on the next reload.

## Limits

- No network access from inside the machine (yet)
- This is the Modern-family machine; boards are still where the hardware fun
  is — see [Getting Started](choose_hardware.md)
