# WebAssembly Apps (C, TinyGo, Rust, Zig)

!!! note "From 3.1.0"
    WebAssembly apps are in Family mruby from 3.1.0. They are experimental, and so is the
    SDK: names and shapes may still change.

Besides the languages the system carries an interpreter for (Ruby, MicroPython, BASIC and
Lua — see [Other Languages](index.md)), an app can be written in any of
**C, TinyGo, Rust and Zig** and compiled to WebAssembly on a PC. The firmware runs the
`.wasm` with [WAMR](https://github.com/bytecodealliance/wasm-micro-runtime) (its
interpreter), inside the same app shell Lua apps use: the system makes the window, draws its
frame and title bar, runs the loop and the timers, and the app implements a few hooks
(`on_create`, `on_update`, `on_event`, ...) and draws inside its window.

What a WebAssembly app may call — drawing, text and Japanese text, pictures, sound, files,
the log, the clocks, the app's own information and input — is the same set of functions
Ruby, Lua and MicroPython apps get. They are defined once, in the firmware's type
definitions (RBS), and every language's bindings are generated from there, with a thin
hand-written layer on top that makes them read naturally in that language.

## Where they run

| Machine | WebAssembly apps |
|---|---|
| Modern (M5Stack Tab5) and other ESP32-P4 boards | Yes |
| [The Linux program](../getting_started/linux.md) and the [simulator](../getting_started/simulator.md) | Yes |
| [Studio](../getting_started/studio.md) (the browser build) | Yes |
| Retro and the other ESP32-S3 boards (StickS3, AtomS3R) | Not yet. Starting one shows `wasm apps are not in this build` |

## Writing one: the SDK

The SDK lives in its own repository,
[family-mruby/family-mruby-sdk](https://github.com/family-mruby/family-mruby-sdk). Each
language takes it the way that language takes any library:

| Language | The SDK comes with | Build with |
|---|---|---|
| TinyGo | `go get` | `tinygo build` with the SDK's target file |
| Rust | `cargo` (a git dependency) | `cargo build --release` |
| Zig | `zig fetch` | `zig build` |
| C | two header files | `clang` or `zig cc`, one line |

Its [getting-started guide](https://github.com/family-mruby/family-mruby-sdk/blob/main/docs/getting_started.md)
([日本語](https://github.com/family-mruby/family-mruby-sdk/blob/main/docs/getting_started.ja.md))
goes from an empty PC to your app running on the simulator, on an ESP32-P4 board over Wi-Fi
and in the browser: the shape of an app and its hooks, the `.app.toml`, each language's
project and build, and a troubleshooting table. Start there; this page only gives the
outline.

An app is two files with the same base name, put in a directory under `/app`:

| File | What it is |
|---|---|
| `<name>.app.wasm` | The compiled app. The engine is chosen by the extension |
| `<name>.app.toml` | Its name in the launcher and its window, the same [App Config](../file_formats/app_toml.md) every app has |

The SDK writes its own version into the `.wasm` (a custom section named `fmrb.sdk`); there is
no version key to write in the `.app.toml`. Before an app starts, the firmware checks that
every function it imports exists. An app built with a newer SDK than the firmware is refused
with the function's name and the SDK version, in an error window and in the log, rather than
failing half-way.

## The samples on the machine

| Directory | In the launcher |
|---|---|
| `/app/tinygo` | TinyGo tour |
| `/app/rust` | Rust tour |
| `/app/zig` | Zig tour |
| `/app/c` | C tour |

Each **tour** is the same app in its language, with the same screens, down to the pixel. Its
ten pages: hello; shapes; text and Japanese text; a picture; sprites and tiles; sound, an
FMSQ tune and a WAV voice; files; lines drawn with the pointer and the keys typed; the app's
information and the clocks; the clipboard and the app's own wasm numbers. Keys 1-9 and 0 go
to a page. Open two side by side to compare how each language writes the same thing; the
sources are the SDK's `<language>/examples/tour` (the C one uses the SDK's helper header
`c/fmrb.h`).

Every directory also has `hello`, the smallest app (the one the SDK guide builds). It is
hidden from the launcher; start it from the [Shell](../getting_started/shell.md), for example
`run /app/tinygo/hello.app.wasm`. Each language has its own launcher icon, and a `.wasm`
whose `.app.toml` names none gets a WebAssembly icon.

## Trying an app in the browser

[Studio](../getting_started/studio.md) runs WebAssembly apps with the same WAMR, so an app can
be tried with nothing installed:

1. Put the two files in a folder named after the app (`hello/hello.app.wasm` and
   `hello/hello.app.toml`).
2. Drop the folder on the Studio page, or use **Add — Folder…** in the panel under the
   screen. A folder with an `.app.toml` at its top is installed under `/app/usr/<folder>/`.
3. Press **Reload** in the launcher's title bar (or `F5`) and double-click the app, or type
   `run /app/usr/hello/hello.app.wasm` in the Shell.

The log is the browser's developer console. `/app/usr` stays in the browser between visits;
after a rebuild, drop the folder again and the new files replace the old ones.

On an ESP32-P4 board the same two files can be sent over Wi-Fi and started without flashing
— see [Files, and apps, over Wi-Fi](../remote_desktop.md#files-and-apps-over-wi-fi).

## How the system treats them

- **Each app keeps to its own memory.** A WebAssembly app reaches only its own linear memory
  and the functions the firmware gives it. Its memory comes from the app's ordinary pool in
  64 KB pages and grows as it allocates; `large_memory = 1` in the `.app.toml` gives it more
  room where the machine has a larger pool.
- **A hook has to return.** One call to a hook may run 20,000,000 instructions; longer work
  belongs in several `on_update` calls. An app that goes over, or traps (an out-of-range
  index, a panic), is ended, and an error window gives the reason.
- **No WASI or libc I/O.** The firmware gives only its own `fmrb` functions; an app that
  imports anything else (for example `printf` from C's library) is refused at load.
- **What is running.** The Monitor app has a **WASM (WAMR)** page: whether the runtime is
  up, how many apps and modules it holds, its shared pool, and per app the memory pages, the
  `.wasm` size and how long its hooks take. `ps` in the Shell shows `wasm` in its ENGINE
  column. An app reads the same numbers with `FmrbApp.wasm_stats` and
  `FmrbApp.wasm_app_stats(pid)`.
- Log lines from the engine begin with `wasm:`; the app's own lines carry its name.

## Related

- [family-mruby-sdk](https://github.com/family-mruby/family-mruby-sdk) — the SDK, its guide
  and the tour's specification
- [Other Languages](index.md) — the other languages, including Lua
- [App Config (.app.toml)](../file_formats/app_toml.md)
- [Studio](../getting_started/studio.md)
