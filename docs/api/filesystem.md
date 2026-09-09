# Files & I/O (File / Dir / IO)

API for file and directory operations. Provides the `File` / `Dir` / `IO` classes.

## File Namespace

Paths visible to users follow a Unix-style single namespace. Apps can pass root-relative paths like `/home/...` for internal storage, or `/mnt/sd/...` for SD card access, to `File.open` / `Dir.open`. The HAL resolves these to the actual mount points on both ESP32 and Linux.

| Path | Device | Purpose |
|---|---|---|
| `/...` (`/app`, `/home`, `/usr`, etc.) | Internal LittleFS (16MB) | System files, user apps, persistent data |
| `/mnt/sd/...` | SD card (FAT32) | Large data, music, images |

## `/home` is yours

`/home` starts empty, and nothing the machine ships with is ever written into it.
Everything that comes with the firmware lives outside it:

| Path | |
|---|---|
| `/app` | The installed apps. An app of your own goes in `/app/usr` so the launcher finds it |
| `/usr/share/samples/ruby` | Small Ruby programs to read |
| `/usr/share/samples/slides` | Slide decks for the presentation tool |
| `/usr/share/samples/services` | A service list and two service bodies to copy |
| `/usr/share/services` | The bodies of the [services](../file_formats/services.md) the machine runs |
| `/usr/share/sprites`, `sounds`, `music`, `backgrounds`, `icon`, `template` | What the bundled apps draw and play |
| `/etc` | Configuration that ships with the firmware |
| `/var/cache` | Caches the system rebuilds on its own |

To play with a sample, copy it into `/home` and edit your copy. The original is then still
there when you want to start again.

Your own settings follow the same split: the system's are in `/etc`, and yours sit beside
them in `/home` — `/home/colors.toml`, `/home/services.toml`, `/home/associations.toml` —
where they win over the shipped ones without replacing them.

One directory in `/home` is read by the system: any `.png` in `/home/backgrounds` is offered
as a wallpaper in Config, alongside the ones in `/usr/share/backgrounds`. Nothing else in
`/home` is scanned.

!!! warning "Re-flashing is a different matter"
    This is about what the running machine does. Writing the firmware from the browser
    installer replaces the whole filesystem, `/home` included. Copy out what you care
    about first — see [Firmware Update](../getting_started/firmware_update.md).

## File Class


### Class Methods

| Method | Purpose |
|---|---|
| `File.open(path, mode = "r", &block)` | Opens with a block for automatic close (recommended) |
| `File.new(path, mode = "r", perm = 0666)` | Opens a file (requires manual `close`) |
| `File.exist?(path)` / `File.exists?(path)` | Check existence |
| `File.file?(path)` | Check if it is a regular file |
| `File.directory?(path)` | Check if it is a directory |
| `File.size(path)` | Size in bytes |
| `File.delete(path)` / `File.unlink(path)` | Delete |
| `File.rename(old, new)` | Rename / move |
| `File.join(*names)` | Join path components |
| `File.expand_path(path, default_dir = ".")` | Expand to absolute path |
| `File.basename(path, suffix = "")` | Extract file name |
| `File.dirname(path, level = 1)` | Extract directory portion |
| `File.extname(path)` | Extract extension (including the leading `.`) |

### Mode Strings

| Mode | Meaning |
|---|---|
| `"r"` | Read (default) |
| `"w"` | Write (existing content is discarded) |
| `"a"` | Append |
| `"r+"` | Read and write |
| `"w+"` | Read and write (existing content is discarded) |

### Examples

```ruby
# Reading
text = File.open("/home/log.txt", "r") { |f| f.read }

# Writing
File.open("/home/score.txt", "w") do |f|
  f.write("score=#{@score}\n")
end

# Checking existence
if File.exist?("/usr/share/icon/ruby.icon")
  Log.info("icon found")
end

# Deleting
File.delete("/home/old.dat") if File.exist?("/home/old.dat")
```

## Dir Class

| Method | Purpose |
|---|---|
| `Dir.open(path)` | Open a directory |
| `dir.read` | Return the next entry name (`nil` at the end) |
| `dir.close` | Close |
| `dir.rewind` | Rewind to the beginning |
| `Dir.mkdir(path, mode = 0777)` | Create a directory |
| `Dir.rmdir(path)` | Remove a directory (must be empty) |
| `Dir.chdir(path)` | Change current directory |
| `Dir.getcwd` | Get current directory |

### Example: Listing Directory Entries

```ruby
def list_files(base_path)
  files = []
  dir = Dir.open(base_path)
  while (entry = dir.read)
    next if entry == "." || entry == ".."
    files << entry
  end
  dir.close
  files
rescue => e
  Log.warn("list_files failed: #{e.message}")
  []
end

list_files("/usr/share/sounds/nsf")
```

!!! note
    `Dir#seek` / `Dir#tell` return `ENOSYS` because the ESP32 VFS does not support them.

## IO Class

The parent class of `File`. Provides a common interface for low-level stream operations.

| Method | Purpose |
|---|---|
| `read(length = nil)` | Read the specified number of bytes (or until EOF) |
| `write(*args)` | Write (returns the number of bytes written) |
| `puts(*args)` | Output with newline |
| `print(*args)` | Output without newline |
| `close` | Close |
| `flush` | Flush buffer |

## Error Handling

File operations raise exceptions on failure (e.g. file not found, insufficient permissions). Use `rescue` to handle them.

```ruby
begin
  data = File.open(path, "r") { |f| f.read }
rescue => e
  Log.error("read failed: #{e.message}")
  return nil
end
```

## Related

- For limitations (such as no `binread`, file count limits, etc.), see [Limitations](../limitations.md)
- For transferring files from a PC via BLE, see [Console](../getting_started/console.md)
