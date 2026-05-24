# Image and Icon Files

!!! note
    This page is under construction.


This page describes the image and icon formats supported by Family mruby, along with how to create and convert them.

| Format | Purpose | Related API |
|---|---|---|
| BMP (RGB332) | General image display and sprites | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | App icons (text format) | -- |
| PNG | Not supported | -- |

## BMP (RGB332)

The standard image format used by Family mruby is an 8-bit BMP with RGB332 color encoding.
Each pixel is 1 byte, with colors represented as R:3bit / G:3bit / B:2bit.

### Format Specification

The BMP file format uses a standard 8-bit palette BMP.

- BMP header
  - `BITMAPFILEHEADER`
  - `BITMAPINFOHEADER`
- 8-bit indexed BMP
- Palette is an RGB332 array
- Each pixel value is an RGB332 index value

### Creating on PC

Using GIMP / ImageMagick / Photoshop or similar:

1. Resize the image to the required dimensions
2. Convert to 8-bit / 256 colors
3. Save as BMP (8-bit indexed)

Then convert the palette to an RGB332 array.

### RGB332 Color Composition

| Component | Bits |
|---|---|
| Red | 3 bits |
| Green | 3 bits |
| Blue | 2 bits |

Total: 8 bits / 256 colors.

### Usage

```ruby
# Load as a sprite image (fast)
img = SpriteImage.new(@gfx, width: 32, height: 32,
                       transparent_color: 0, use_transparent: true)
img.load_bmp("/usr/share/sprite/player.bmp")

# Load and display as a regular image
ret = @gfx.create_image_from_file("/img.bmp")
@gfx.draw_image(ret[:id], 10, 20)

# Manipulate pixels from Ruby
data = File.open("/img.bmp", "r") { |f| f.read }
bmp = BMP332.parse(data)
# bmp[:width], bmp[:height], bmp[:pixels]
```

## Icon Files (.icon)

A text-based file format that defines icons displayed in the app launcher.

### Format

```
# <name> (<width>x<height>) color=0x<RGB332>
............
...111111...
..11111111..
.11111.1111.
111111..1111
.1111111111.
..11111111..
...111111...
....1111....
.....11.....
............
............
```

| Character | Meaning |
|---|---|
| `.` | Transparent (not drawn) |
| `1` | Pixel (filled with the specified color) |
| `#` | Comment line (color settings can be placed at the beginning) |

### Comment Line Metadata

- `color=0xNN` specifies the color (RGB332) for all pixels
- Defaults to white (`0xFF`) if omitted

### Recommended Size

The standard launcher icon size is 12 x 12 pixels.

### File Location

```
/usr/share/icon/<name>.icon
```

When referencing from `.toml`:

```toml
icon = "usr/share/icon/myapp.icon"
```

(No leading `/` is needed; use a relative path.)

### Sample

Apple-style icon (12 x 12, red):

```
# Apple (12x12) color=0xE0
......1.....
.....11.....
.....1......
....1......
...111111...
..11111111..
.111111111..
.111111111..
.111111111..
.111111111..
..11111111..
...111111...
```

### Default Icons

If `icon` is omitted in the `.toml`, a default icon is used based on the main file extension:

| Extension | Default Icon |
|---|---|
| `.rb` | `usr/share/icon/ruby.icon` |
| `.lua` | `usr/share/icon/lua.icon` |
| `.bas` | `usr/share/icon/basic.icon` |

## PNG

Direct display of PNG files is not supported. Convert to BMP332 format on your PC before writing to the device (use GIMP "Export" -> BMP, select 24-bit, then compress with a separate RGB332 conversion script).

## Related

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- Sprite editor: `flash/app/tool/sprite_editor.app.rb`
