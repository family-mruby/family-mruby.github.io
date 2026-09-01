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

For detailed specifications, see [Image & Icon Files](../file_formats/image_formats.md#bmp-rgb332).

## Fmrb::Fft

A fast Fourier transform, with the engine chosen at run time. The microphone spectrum app
is what it was built for; anything that has to turn samples into frequencies can use it.

```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
mag = fft.forward(samples)              # size/2 little-endian int16 magnitudes
peak = Fmrb::Fft.peak_bin(mag)          # index of the loudest bin
hz = peak * rate / 512.0
fft.close
```

`size` is a power of two between 64 and 1024. `samples` is `size` int16 samples as a byte
String — the shape `FmrbAudio#mic_read` returns.

| Method | |
|---|---|
| `Fmrb::Fft.new(size: 512, backend: :ruby)` | Pick the engine |
| `forward(samples)` | One transform. Returns the magnitudes |
| `run(samples, iters)` | `iters` transforms of the same input, timed inside the engine: `[microseconds, magnitudes]` |
| `close` | Release it |
| `Fmrb::Fft.bin(mag, index)` | One magnitude out of the result |
| `Fmrb::Fft.peak_bin(mag)` | Index of the loudest |
| `Fmrb::Fft.sine(size:, cycles:, amp:)` | A synthetic input, so engines can be compared on the same waveform |
| `Fmrb::Fft.bench(size:, iters:, backend:, reps:)` | Time one engine |
| `Fmrb::Fft.available?(backend)` / `.q15?(backend)` | Whether this build has it, and whether it computes in fixed point |

The backends are `:ruby`, `:c`, `:c64`, `:dsp`, `:spinel` and the fixed-point `:ruby_q15`,
`:c_q15`, `:spinel_q15`. Which exist depends on the build, so ask `available?` rather than
assuming. The fixed-point ones differ from the floating ones by a few counts by
construction — comparing results across the two families needs that allowance.

## Related

- For direct binary operations, see [`File` / `IO`](filesystem.md)
- For I2C device usage, also see [Hardware Control > I2C](peripherals.md#i2c)
