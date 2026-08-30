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
  device palette) and a screen size up to 852x480 — a larger screen means more
  room, not bigger pixels

## Limits

- Files you create live in browser memory and are gone on reload —
  copy anything you care about out through the editor before leaving
- No network access from inside the machine (yet)
- This is the Modern-family machine; boards are still where the hardware fun
  is — see [Getting Started](choose_hardware.md)
