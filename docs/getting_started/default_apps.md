# Default Apps

!!! note
    This page is under revision.


Family mruby comes with built-in apps for common tasks. You can use these apps to develop your own applications.

## How to Launch

| Location | Apps |
|---|---|
| Launcher icons (menu bar -> `Launcher`) | Shell, Editor |
| Menu bar (top-left `Family mruby` drop-down) | Launcher, File Manager, Log Viewer, Monitor, Set Clock, Config, About |

## Shell

A terminal for file operations, script execution, and interactive use. It is based on R2P2 but has its own implementation.

| Category | Commands |
|---|---|
| Directory | `cd [path]` / `pwd` / `ls [path]` |
| File viewing | `cat <file>` / `less <file>` |
| File operations | `mkdir <dir>` / `rm <path...>` / `cp <src> <dst>` / `mv <src> <dst>` |
| Editing | `edit <file>` (launches Editor) |
| App creation | `create_app <name>` (see [Hello World](hello_world.md#shortcut-generate-a-template-with-create_app)) |
| Execution | `run <script>` / `run <script> &` (background) / `run <script> > <file>` (output redirect) |
| Interactive Ruby | `irb` |
| Processes | `ps` / `kill_job <id>` |
| Help | `help` |

Tab completion and history navigation with the up/down arrow keys are available in the shell.

### `less` Controls

After opening a file with `less <file>`:

| Key | Action |
|---|---|
| `Space` / `PgDn` / `j` | Forward one page |
| `b` / `PgUp` / `k` | Back one page |
| `g` | Go to beginning |
| `G` | Go to end |
| `?` | Toggle key list display |
| `q` / `ESC` | Quit |

## FM-Editor

An MS-DOS-style text editor. It features Ruby syntax highlighting, selection, copy and paste, search, and other standard editing capabilities.

- Launch: type `edit foo.app.rb` in the shell, or open an empty file from the Editor icon in the launcher
- Hotkeys are shown as yellow characters in the menus

### Menus

The menu bar can be opened with Alt + the initial letter. In an open drop-down, select items with the arrow keys + Enter, or press the initial letter (yellow character) of each item to execute it directly. Press ESC to close.

| Menu | Open with | Items |
|---|---|---|
| File | `Alt+F` | Open / Save / Save as / Exit |
| Edit | `Alt+E` | Cut / Copy / Paste / Select All |
| Search | `Alt+S` | Find (modal dialog) |
| Highlight | `Alt+H` | Syntax highlighting ON/OFF toggle |

### Main Keyboard Shortcuts

| Action | Key |
|---|---|
| Save | `Ctrl+S` |
| Exit (prompts if unsaved) | `Ctrl+X` |
| Copy | `Ctrl+C` |
| Paste | `Ctrl+V` |
| Select all | `Ctrl+A` |
| Open search dialog | `Alt+S` |
| Find next | `F3` |
| Highlight ON/OFF | `Alt+H` |
| Range selection | `Shift + arrow keys` |

### Selection and Clipboard

Selecting a range with `Shift + arrow keys` displays a light-blue highlight (multi-line selections wrap). The selected range can be:

- Replaced or deleted with `Backspace` / `Delete` / `Enter`
- Replaced with typed characters
- Copied with `Ctrl+C` and pasted with `Ctrl+V`

The clipboard is internal to the editor (separate from the OS clipboard).

### Search

`Alt+S` opens the `Find` dialog. Type a string and press `Enter` to jump to the next match. When the end of the file is reached, the search wraps around to the beginning. Press `F3` to find the next occurrence using the previous query.

### Syntax Highlighting

Syntax highlighting is enabled automatically when a Ruby file is opened. For files larger than 1 KB, it is turned off automatically to reduce load. You can toggle it manually with `Alt+H`.

### Development Flow

The basic workflow is to edit a template generated with `create_app` in the Editor, then reload by right-clicking:

```
Shell> create_app my_app
Shell> edit /app/usr/my_app.app.rb     # Launch Editor
(Edit) -> Ctrl+S (Save) -> Ctrl+X (Exit)
Launch the my_app icon in the launcher / if already running, right-click the title bar -> Reload
```

## File Manager

Browse and manage files under `/` or `/mnt/sd/` in a tree view. While the console (via BLE) is operated from a PC, the File Manager is operated directly on the device.

## Log Viewer

Displays system-wide log output in real time.

- Color-coded by level (ERROR=red / WARN=yellow / INFO=gray / DEBUG=dark gray)
- Switch display level from the toolbar (`E/W/I` or `E/W/I/D`)
- Ideal for checking output from `Log.info` and similar calls in your own apps

## Monitor

A monitor that visualizes system status. Switch pages with `<` / `>` at the bottom.

- Page 1: Heap usage bars (each memory pool, IRAM, PSRAM)
- Page 2: Graphics statistics (commands/sec, presents/sec, last 30 seconds)

Useful for diagnosing when an app is sluggish or unresponsive.

## Set Clock

A dialog for manually setting the RTC time. Enter year, month, day, hour, minute, and second to apply.

Normally the onboard RX8900 RTC keeps time, but this is available for initial setup or correcting clock drift.

## Config

An app for changing system-wide settings (theme color, display margins, etc.).

## About

A dialog that displays system information such as the OS version, GA-side firmware version, IDF version, and MAC address.

## Choosing the Right File Operations Tool

| Tool | Location | Primary Use |
|---|---|---|
| Shell `ls` / `cd` etc. | Shell on the device | Batch operations via scripts, for command-line users |
| File Manager | Menu on the device | GUI file browsing (local) |
| Console (BLE) | Browser on PC | File transfer and log display from PC ([guide](console.md)) |

## Related

- [Hello World](hello_world.md) -- Write your first app with Shell + create_app
- [Console](console.md) -- File transfer / log display from PC
- [Log API](../api/log.md) -- Output API such as Log.info (visible in Log Viewer)
