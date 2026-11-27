# Image and Icon Files

This page describes the image and icon formats supported by Family mruby, along with how to create and convert them.

| Format | Purpose | Related API |
|---|---|---|
| PNG | Pictures drawn whole; sprites, tile sheets, wallpapers and launcher icons | [`FmrbGfx#create_image`](../api/fmrb_gfx.md#images) / [SpriteImage](../api/sprite.md#spriteimage) |
| BMP (RGB332) | Sprites and tile sheets, and pixels to edit in Ruby | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | App icons (text format) | -- |

## PNG

`FmrbGfx#create_image` and `load_image` take a PNG. In the development version
`SpriteImage#load_bmp` (and so `TileSheet`) reads one too, telling it from a BMP by the first
bytes: the colours become RGB332 by keeping the top 3/3/2 bits of red, green and blue, and
transparency is the sprite's `transparent_color`, not the PNG's alpha.

The artwork that ships with the system — sprites, tile sheets, wallpapers and launcher
icons — is PNG with a palette of only the colours it uses, at 1, 2, 4 or 8 bits per pixel.
That is a tenth to a sixtieth of the size of the same picture as an 8-bit BMP, and a small
one fits inside a single filesystem entry. A PNG whose palette entries are RGB332 colours
spread to 8 bits per channel comes back as exactly those RGB332 values.

The [sprite editor](#related) still opens and saves BMP only.

## BMP (RGB332)

The BMP that Family mruby reads is an 8-bit BMP using RGB332 color encoding.

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
| `.py` | `/usr/share/icon/python.icon` |
| `.wasm` | `/usr/share/icon/wasm.icon` |

A [WebAssembly app](../languages/wasm.md) usually names its language's icon instead:
`c.icon`, `tinygo.icon`, `rust.icon` or `zig.icon`.

### What the launcher loads

The `.icon` text is the source. The launcher loads the picture beside it — `<name>.png`,
or `<name>.bmp` where there is no PNG — which is the 12x12 grid drawn at twice the size.
For an icon of your own, make the PNG from the `.icon` with fmruby-core's
`tools/gen_icon_png.rb` (or `rake icons` there) and put both side by side **(development
version)**.

## Related

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- Sprite editor: `/app/tool/sprite_editor.app.rb`
