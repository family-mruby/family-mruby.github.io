# Utilities (JSON / MessagePack / BMP332 / RX8900)

!!! note
    Under construction.

A collection of general-purpose utility APIs.

## JSON

JSON string parsing and generation. Used for configuration files, map data, communication with web tools, and more.

### Methods

| Method | Purpose |
|---|---|
| `JSON.parse(string)` | Convert a JSON string to a Hash / Array |
| `JSON.generate(obj)` / `JSON.dump(obj)` | Convert a Ruby object to a JSON string |

### Example

```ruby
text = File.open("/data/conf.json", "r") { |f| f.read }
conf = ::JSON.parse(text)
Log.info("user=#{conf["user"]}")

File.open("/data/conf.json", "w") do |f|
  f.write(::JSON.generate({"user" => "kishima", "score" => 100}))
end
```

!!! warning "Use `::JSON`"
    Writing `JSON.parse(...)` inside a class may cause picoruby's constant lookup to interpret `JSON` as a class-level constant, which fails if not found. Prefix with `::` to explicitly refer to the top level: `::JSON.parse(...)`.

[TileMap](tilemap.md) uses `JSON.parse` internally to read map files.

## MessagePack

Binary data serialization. Used internally by `publish` and `send_message`, but also available for user apps.

### Methods

| Method | Purpose |
|---|---|
| `MessagePack.pack(obj)` | Serialize to binary (returns a `String`) |
| `MessagePack.unpack(binary)` | Deserialize |

### Supported Ruby Types

`Hash`, `Array`, `Integer`, `Float`, `String`, `Boolean`, `nil`

### Example: Saving Settings to a File

```ruby
config = {"score" => 100, "name" => "Player1", "options" => [1, 2, 3]}

# Save
File.open("/save.dat", "w") do |f|
  f.write(MessagePack.pack(config))
end

# Load
data = File.open("/save.dat", "r") { |f| f.read }
restored = MessagePack.unpack(data)
Log.info("score = #{restored["score"]}")
```

!!! tip "More efficient than JSON"
    For data with many numbers and booleans, MessagePack produces smaller output and parses faster. Since Family mruby does not bundle a JSON library with picoruby, MessagePack is the standard format for saving structured data.

## BMP332

Parses RGB332 format BMP image data.

### Methods

| Method | Purpose |
|---|---|
| `BMP332.parse(binary)` | Parse from binary data |

Returns the following Hash:

```ruby
{
  width:  Integer,
  height: Integer,
  pixels: String   # RGB332 pixel array (width * height bytes)
}
```

### Example

```ruby
data = File.open("/img.bmp", "r") { |f| f.read }
bmp = BMP332.parse(data)
Log.info("size: #{bmp[:width]}x#{bmp[:height]}")

# For displaying images, SpriteImage#load_bmp is faster
```

!!! note
    For normal image display, `SpriteImage#load_bmp` or `FmrbGfx#create_image_from_file` is faster because decoding is done entirely on the WROVER side. Use `BMP332.parse` when you need to work with the pixel array on the Ruby side (editing, inspection).

For detailed specifications, see [Image & Icon Files](../file_formats/image_formats.md#bmp).

## RX8900

A driver for the I2C-connected RTC (Real Time Clock) IC. Allows accessing the on-board clock from Ruby.

I2C address: fixed at `0x32`

### Constructor

```ruby
RX8900.new(i2c)
```

Argument: an `I2C` instance (see [Peripherals > I2C](peripherals.md#i2c))

### Methods

| Method | Return Value / Purpose |
|---|---|
| `init` | RTC initialization (WEEK ALARM mode, 1Hz FOUT output, etc.) |
| `read_time` | `{year:, month:, day:, hour:, minute:, second:, wday:}` |
| `write_time(hash)` | Write a time value |
| `sync_system_clock` | Sync the RTC to the system epoch. Returns `true` on success |
| `temperature` | Temperature sensor value (Celsius `Float`) |
| `vlf?` | Low battery flag. If `true`, clock data may have been lost |

### Example: Clock Sync at Startup

```ruby
class ClockSyncApp < FmrbApp
  def on_create
    i2c = I2C.new(unit: "ESP32_I2C0")
    rtc = RX8900.new(i2c)
    if rtc.vlf?
      Log.warn("RTC battery low; resetting")
      rtc.write_time(year: 2026, month: 1, day: 1,
                     hour: 0, minute: 0, second: 0, wday: 4)
    end
    rtc.sync_system_clock
    now = rtc.read_time
    Log.info("time: #{now[:year]}-#{now[:month]}-#{now[:day]} #{now[:hour]}:#{now[:minute]}")
  end
end

ClockSyncApp.new.start
```

!!! note
    You can also get and set the time via `FmrbApp.wallclock` / `FmrbApp.set_wallclock`. These go through the system clock (POSIX epoch) and also sync with the RTC. For everyday "get the current time" use cases, `FmrbApp.wallclock` is more convenient.

## Related

- For direct binary operations, see [`File` / `IO`](filesystem.md)
- For I2C device usage, also see [Peripherals > I2C](peripherals.md#i2c)
