# Image and Icon Files

This page describes the image and icon formats supported by Family mruby, along with how to create and convert them.

| Format | Purpose | Related API |
|---|---|---|
| BMP (RGB332) | General image display and sprites | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | App icons (text format) | -- |

## BMP (RGB332)

The standard image format used by Family mruby is an 8-bit BMP using RGB332 color encoding.

Each pixel is 1 byte, and each pixel value is treated directly as an RGB332 color value.

- R: 3 bits
- G: 3 bits
- B: 2 bits

A total of 256 colors can be represented.

### Format Specification

The BMP file format uses a standard 8-bit indexed BMP.

- BMP header
  - `BITMAPFILEHEADER`
  - `BITMAPINFOHEADER`
- 8-bit indexed BMP
- 256-color palette
- Palette contents are an RGB332 array
- Each pixel value is treated as an RGB332 color value

The palette in the BMP is included for compatibility with PC image viewers.  
Family mruby does not reference the palette; it treats pixel values directly as RGB332 color values.

### RGB332 Color Composition

| Component | Bits |
|---|---|
| Red | 3 bits |
| Green | 3 bits |
| Blue | 2 bits |

Total: 8 bits / 256 colors.

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
icon = "/usr/share/icon/myapp.icon"
```

### Default Icons

If `icon` is omitted in the `.toml`, a default icon is used based on the main file extension:

| Extension | Default Icon |
|---|---|
| `.rb` | `/usr/share/icon/ruby.icon` |
| `.lua` | `/usr/share/icon/lua.icon` |
| `.bas` | `/usr/share/icon/basic.icon` |

## Related

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- Sprite editor: `flash/app/tool/sprite_editor.app.rb`
