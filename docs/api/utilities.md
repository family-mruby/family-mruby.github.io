# Utilities (JSON / MessagePack / BMP332)

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
text = File.open("/home/conf.json", "r") { |f| f.read }
conf = ::JSON.parse(text)
Log.info("user=#{conf["user"]}")

File.open("/home/conf.json", "w") do |f|
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
    For normal image display, `SpriteImage#load_bmp` or `FmrbGfx#create_image_from_file` is faster because decoding is done entirely on the graphics side. Use `BMP332.parse` when you need to work with the pixel array on the Ruby side (editing, inspection).

For detailed specifications, see [Image & Icon Files](../file_formats/image_formats.md#bmp).

## Related

- For direct binary operations, see [`File` / `IO`](filesystem.md)
- For I2C device usage, also see [Hardware Control > I2C](peripherals.md#i2c)
