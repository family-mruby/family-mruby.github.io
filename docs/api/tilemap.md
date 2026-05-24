# TileSheet / TileMap

A library for easily writing tile-based map rendering. Suitable for RPG-style grid worlds, tiled backgrounds, stage-based puzzles, and more.

| Class | Role |
|---|---|
| `TileSheet` | Wraps a tile image (a single BMP with tiles arranged in a grid). Can `stamp` individual tiles |
| `TileMap` | Loads an `fmrb_map` JSON file and draws tiles layer by layer using `TileSheet#stamp` |

Both classes are built into `picoruby-fmrb-app` and require no additional `require`.

## TileSheet

Handles BMP tile sheet images (images with consecutive tiles arranged in a grid).

### Constructor

```ruby
TileSheet.new(gfx, path, cols:, rows: nil, tile_size: 16)
```

| Argument | Purpose |
|---|---|
| `gfx` | `FmrbGfx` instance |
| `path` | Path to a BMP already transferred to the WROVER side (use `@gfx.transfer_file` to send it) |
| `cols:` | Number of columns in the sheet (in tiles) |
| `rows:` | Number of rows. If `nil`, automatically estimated from the BMP size (assumes 8-bit BMP) |
| `tile_size:` | Pixel width and height of a single tile (default: 16) |

Internally creates a `SpriteImage` with transparent color `0` and calls `load_bmp`.

### Methods

| Method | Purpose |
|---|---|
| `stamp(index, dst_x:, dst_y:)` | Stamp tile number `index` (row-major: `row * cols + col`) onto the canvas. `nil` or negative values are no-ops (for empty map cells) |
| `destroy` | Release the internal SpriteImage |

| Attribute | Description |
|---|---|
| `image` | Internal SpriteImage |
| `cols` / `rows` | Tile counts |
| `tile_size` | Pixel size |

### Example

```ruby
@gfx.transfer_file("/usr/share/sprites/tilesheet.bmp",
                   "/usr/share/sprites/tilesheet.bmp")
sheet = TileSheet.new(@gfx,
                       "/usr/share/sprites/tilesheet.bmp",
                       cols: 4, tile_size: 16)
sheet.stamp(0, dst_x: 0,  dst_y: 0)   # Stamp tile 0 at the top-left
sheet.stamp(5, dst_x: 16, dst_y: 0)   # Stamp tile 5 to the right
```

## TileMap

Loads an `fmrb_map` v1 format JSON file and lays out tiles for each layer.

### Constructor

```ruby
TileMap.new(json_path)
```

`json_path` is a JSON path on the core side (internal flash). Note that this is not on the WROVER side.

### Methods

| Method | Purpose |
|---|---|
| `render(sheet, origin_x:, origin_y:, max_cols: nil, max_rows: nil)` | Draw all layers. `origin_*` is the drawing position for the top-left tile. `max_cols/rows` clips the display range (for viewporting when the map is larger than the screen) |
| `event_at(x, y)` | Return the event Hash at tile coordinates (x, y). Returns `nil` if none |

| Attribute | Description |
|---|---|
| `width` / `height` | Map width and height (in tiles) |
| `tile_size` | Pixel size of a single tile |
| `tilesheet_path` | Path of the tile sheet to use |
| `tilesheet_cols` | Number of columns in the tile sheet |
| `layers` | Layer array |
| `events` | Event array |

### Example

```ruby
map = TileMap.new("/app/game/rpg_demo/world.map.json")
# Build the sheet using map.tilesheet_path / map.tilesheet_cols
sheet = TileSheet.new(@gfx, map.tilesheet_path, cols: map.tilesheet_cols)

# Render into an 11x11 tile viewport
map.render(sheet, origin_x: 16, origin_y: 16, max_cols: 11, max_rows: 11)
@gfx.present
```

## fmrb_map JSON Format (v1)

```json
{
  "format": "fmrb_map",
  "version": 1,
  "width": 20,
  "height": 15,
  "tile_size": 16,
  "tilesheet": "/usr/share/sprites/tilesheet.bmp",
  "tilesheet_cols": 4,
  "layers": [
    { "name": "ground", "data": [[0, 0, 1, ...], [...], ...] },
    { "name": "objects", "data": [[null, null, 5, ...], [...], ...] }
  ],
  "events": [
    { "x": 4, "y": 6, "kind": "talk", "text": "こんにちは" }
  ]
}
```

| Key | Description |
|---|---|
| `format` | Fixed as `"fmrb_map"` |
| `version` | 1 |
| `width` / `height` | Map size (in tiles) |
| `tile_size` | Pixel size of a single tile |
| `tilesheet` | WROVER-side path of the sheet to use |
| `tilesheet_cols` | Number of columns in the sheet |
| `layers[]` | Each layer. `data` is a 2D array (`[row][col]` -> tile number, `null` for empty) |
| `events[]` | Arbitrary events. Retrieved via `event_at(x, y)` |

## Map Creation Tools

Tile sheets and maps can be created with web tools (bundled in `fmruby-core/tool/web/`):

- Sprite Editor: Create a BMP with 16x16 RGB332 tiles arranged in a grid
- Map Editor: Place tiles + edit events -> export as `fmrb_map` JSON

Start with `ruby web_server.rb` and access `http://localhost:8080` (same server as the [Console](../getting_started/console.md)).

## Example: Simple RPG

A complete RPG demo is available in `flash/app/game/rpg_demo/`. In fullscreen:

- Left 176x176 (11x11 tiles): Field drawn with `TileMap` + `TileSheet`
- Right 128x240: Panel displaying player coordinates / last event
- Player is a separate BMP (16x16) controlled via `SpriteInstance` with arrow keys / D-pad

This directory includes `.app.rb` / `.app.toml` along with `world.bmp`, `world.map.json`, and `player.bmp`. The launcher performs a 3-level scan so it also picks up `/app/<category>/<bundle>/*.app.toml`, allowing you to keep assets alongside the app.

## Related

- [FmrbGfx > `draw_tile`](fmrb_gfx.md#画像-api) -- Low-level tile drawing API
- [Sprite](sprite.md) -- SpriteImage / SpriteInstance / GfxBlock
- [App Configuration (.toml)](../file_formats/app_toml.md) -- Per-app settings
