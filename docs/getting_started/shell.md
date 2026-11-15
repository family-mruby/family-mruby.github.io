# Shell Commands

The Shell is Family mruby's command line. Open it from the launcher, the desktop icon, or by
pressing `S` on the desktop; `help` lists the commands on the machine you are using.

Commands marked **(development version)** are on the development branch (and in
[Studio](studio.md)) but not in 3.0.0.

## Using the Shell

| Key | Effect |
|---|---|
| `Tab` | Completes a file or directory name |
| `↑` / `↓` | Earlier and later lines |
| `PgUp` / `PgDn`, mouse wheel | Scroll back through the output |
| `Ctrl` + `C` | Stops the script running in the Shell |
| `Ctrl` + `V` | Pastes the clipboard into the line |

Paths are relative to the current directory unless they start with `/`. There is no quoting:
an argument ends at a space.

## Files and directories

| Command | What it does | Example |
|---|---|---|
| `cd [path]` | Changes the current directory (`cd` alone goes to `/`) | `cd /home` |
| `pwd` | Prints the current directory | `pwd` |
| `ls [path]` | Lists a directory | `ls /app/demo` |
| `cat <file>` | Prints a file | `cat /etc/system_conf.toml` |
| `less <file>` | Shows a file a page at a time (`Space` / `b` page, `q` quits) | `less /usr/share/doc/kanji.md` |
| `mkdir <dir>` | Makes a directory | `mkdir /home/games` |
| `rm <path...>` | Removes files, and empty directories | `rm old.rb notes.txt` |
| `cp <src> <dst>` | Copies a file | `cp hello.rb /home/backup.rb` |
| `mv <src> <dst>` | Moves or renames a file | `mv draft.rb final.rb` |

## Writing and running code

| Command | What it does | Example |
|---|---|---|
| `edit [-f] <file>` | Opens a file in the editor, creating it if it does not exist. `-f` opens it fullscreen | `edit -f /home/hello.rb` |
| `create_app <name>` | Writes a ready-to-edit app, `/app/usr/<name>.app.rb` and `.app.toml` (see [Hello World](hello_world.md#shortcut-generate-a-template-with-create_app)) | `create_app my_clock` |
| `run <script> [args] [&]` | Runs a script. An app starts as an app; a plain `.rb` runs here and prints into the Shell. `&` runs it in the background as a job | `run /home/fib.rb 20` |
| `run <script> > <file>` | Writes the script's output to a file (`>>` appends, `<` feeds a file to it) | `run report.rb > /home/out.txt` |
| `open <file>` | Opens a file with the app its type is associated with ([File Associations](../file_formats/associations.md)) | `open /usr/share/samples/slides/demo.md` |
| `irb` | Interactive Ruby. `$shell` is this Shell app | `irb` |

## Apps, jobs and services

| Command | What it does | Example |
|---|---|---|
| `ps` | Lists the running tasks (PID, type, state, name), background jobs and services | `ps` |
| `kill <pid>` | Ends a user app, by its PID from `ps` | `kill 12` |
| `kill <service>` | Stops a [service](../file_formats/services.md) for this session | `kill hourly_chime` |
| `kill_job <id>` | Stops a background job, by its JOB id from `ps` | `kill_job 1` |
| `svc list` | Lists the background services | `svc list` |
| `svc start` / `svc stop <name>` | Starts or stops a service for this session | `svc start timesync` |
| `svc enable` / `svc disable <name>` | The same, and remembered across boots | `svc disable hourly_chime` |

## Moving apps and files between machines

These work with apps written to be moved (`movable = true`; see
[Moving a running app](../api/fmrb_app.md#moving-a-running-app)) and over
[Asterism](../api/network.md#asterism-objects-and-topics-across-machines). A machine is named
by its Asterism node ID, which `anodes` shows.

| Command | What it does | Example |
|---|---|---|
| `checkpoint [-r] <pid>` | Writes an app to an image, `/tmp/<name>.ckpt`, and closes it. `-r` starts it again at once | `checkpoint -r 14` |
| `restore <image>` | Starts an app from its image | `restore /tmp/counter.ckpt` |
| `amove <pid\|name> <node>` | Moves a running app to another machine. The name is the one `ps` shows. 3.0.0 has this as `move <pid> <node>` **(development version)** | `amove Counter fmruby-aaaaaa` |
| `anodes [list]` | The machines on Asterism now, with their names; this one is marked **(development version)** | `anodes` |
| `anodes info <node>` | One machine: its profile, its apps and their status, and whether it takes files and apps **(development version)** | `anodes info fmruby-aaaaaa` |
| `asend <node> <file> [-o] [-s]` | Sends a file to another machine's `/home/inbox/`. `-o` overwrites a file of the same name there (otherwise it gets a name of its own); `-s` (or `--sd`) puts it on that machine's SD card, in `/sd/inbox/` **(development version)** | `asend fmruby-aaaaaa /home/hello.rb` |
| `asend -c` | Stops the file being sent **(development version)** | `asend -c` |
| `asend -l` | Who may send files to this machine **(development version)** | `asend -l` |
| `asend on\|off` | Keeps this machine on the network for sending, so the window menu's **Send to** lists the machines at once; `asend` alone says whether it is on. `asend` and `amove` work without it **(development version)** | `asend on` |
| `areceive` | Whether this machine receives files and apps, and from whom **(development version)** | `areceive` |
| `areceive on\|off` | Starts or stops receiving **(development version)** | `areceive on` |
| `areceive allow\|deny <file\|checkpoint> <node>` | Lets a machine send files (`file`) or move apps (`checkpoint`) here, or takes that back. `*` stands for everyone on the network **(development version)** | `areceive allow file fmruby-aaaaaa` |

Moving an app works between machines on the same version.

### Who may send: `receive.toml`

A machine takes nothing until it is told to. Who may send is kept in
`/home/asterism/receive.toml`; while that file does not exist, the system's copy,
`/etc/asterism/receive.toml`, is read, which receives nothing. The first change from
`areceive` or the **Receiving** app (in `/app/tool`) writes the `/home` file, starting from
the `/etc` one:

```toml
enabled = true          # receive at all; off (or no line) takes nothing, whatever the lists say
send_enabled = false    # keep this machine on the network for Send to

[file]                  # who may put files in /home/inbox (and /sd/inbox)
from = ["fmruby-aaaaaa", "fmruby-*"]

[checkpoint]            # who may move apps here
from = ["*"]            # "*": everyone on the network
```

A list holds node IDs and patterns (`fmruby-*`). A router with access control must let the
sender through as well. When the machine is a member of a [console](console.md), a section the console writes
into the same file adds the senders chosen there; `areceive` shows it but leaves it alone.
Either switch on starts the transfer app at boot.

**(development version)** The `enabled` and `send_enabled` switches, the `/etc` copy, the
`[file]` list and the Receiving app are new. 3.0.0 reads only
`/home/asterism/receive.toml`, and only its `[checkpoint] from` list.

## Linux commands (the Linux program only)

In the [Linux program](linux.md) a line starting with `!` runs on Linux, in the Linux
directory matching the current one (`/mnt/host/src` is `~/src`). Elsewhere it answers that
the machine has no Linux.

| Command | What it does | Example |
|---|---|---|
| `!<command>` | Runs a Linux command; its output (with colours) comes into the Shell. `Ctrl` + `C` stops it | `!git status` |
| `!` | Opens the Linux shell; `exit` or `Ctrl` + `D` comes back | `!` |
| `Ctrl` + `Shift` + `V` | Pastes into the Linux command running | |

Full-screen programs such as `vim` and `top` are not supported (`TERM=dumb`).

## Other

| Command | What it does | Example |
|---|---|---|
| `color` | Shows the Shell's two colours | `color` |
| `color bg\|text <colour>` | Sets the background or text colour, by [name](../file_formats/color_names.md) or number (`0x1F`). Kept in `/home/colors.toml` | `color bg navy` |
| `color names` / `color reset` | Lists the colour names; goes back to the theme's colours | `color reset` |
| `logo` | Draws the PicoRuby logo | `logo` |
| `help` | Lists the commands | `help` |

## Related

- [Default Apps](default_apps.md)
- [The Linux Program](linux.md)
- [Moving a running app](../api/fmrb_app.md#moving-a-running-app)
