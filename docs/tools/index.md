# Tools

The tools for working on a Family mruby machine from outside it: seeing its screen, moving
files and apps onto it, stopping an app to look inside, and running the whole system without
a board.

## Tools that reach a device

| Tool | What it does | Modern | Retro | Headless boards | Linux | Browser | Connection |
|---|---|---|---|---|---|---|---|
| [Remote Desktop](remote_desktop.md) | The screen in a browser on your PC, driven with the PC's keyboard and mouse | Yes | — | — | — | — | Wi-Fi |
| [Files and apps over Wi-Fi](remote_desktop.md#files-and-apps-over-wi-fi) | The `fmrb_rd_*.rb` tools: put and get files, launch and kill apps, back up `/home` | Yes | Yes | Development builds only | — | — | Wi-Fi |
| [Editor debugger](debugging.md#on-the-device-the-editors-debugger) | Breakpoints, stepping and variables in the on-device editor | Builds with the mruby editor | Builds with the mruby editor | — | Builds with the mruby editor | — | None |
| [Remote debugger](debugging.md#from-your-pc-the-remote-debugger) | The same, driven from a PC: a command-line client and a DAP adapter for VS Code and other editors | Yes | Yes | Setup mode only | Yes | — | BLE (boards), TCP (Linux) |
| [Family mruby Console](console.md) | Files, the live log, sprite and map editing and a debug panel, in a browser | Yes | Yes | Setup mode only | — | — | BLE (Web Bluetooth) |

- **Modern** is the M5Stack Tab5 and the P4-Nano; **Retro** is the ESP32-S3 board with the
  WROVER graphics chip; the **headless boards** are the AtomS3R and the StickS3. **Linux** is
  the [simulator](simulator.md) and [the Linux program](../getting_started/linux.md);
  **Browser** is [Family mruby Studio](../getting_started/studio.md).
- **Release builds** (what the Web Installer writes) keep the Wi-Fi tools closed until the
  owner turns on Config's Remote control row and pairs the PC — see
  [Who can connect](remote_desktop.md#who-can-connect). The headless boards have no Config,
  so on them the Wi-Fi tools answer only in a development build.
- **The editor debugger** is not in the editor the Web Installer writes, which is built with
  Spinel — see [Debugging](debugging.md).
- **Retro has one radio**, so Wi-Fi and BLE are a choice there; Modern runs both at once.
- **The headless boards** run BLE only in setup mode, which is how their Wi-Fi and Asterism
  settings get onto them.

None of the BLE or TCP services ask for a password. See
[Security](../limitations.md#security) before using them on a network you do not control.

## Running Family mruby without a board

| | What it is | Needs |
|---|---|---|
| [Simulator](simulator.md) | The whole system in a Docker container, shown through a VNC viewer in your browser | Docker on a PC |
| [Family mruby Studio](../getting_started/studio.md) | The firmware compiled to WebAssembly, running in a browser tab | A recent Chrome or Firefox |
| [The Linux Program](../getting_started/linux.md) | Family mruby as one ordinary program on a Linux PC, or as its desktop | A Linux PC |

Studio and the Linux program are described in [Getting Started](../getting_started/choose_hardware.md#other-ways-to-run-it).
