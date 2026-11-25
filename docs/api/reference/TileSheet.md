# TileSheet

One picture with tiles laid side by side

How to use it: [Tile Maps](../tilemap.md).

Tiles are taken out by number and drawn.

## Class methods

### TileSheet.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbGfx/">FmrbGfx</a> gfx,
  <a href="../String/">String</a> path,
  cols: <a href="../Integer/">Integer</a>,
  ?rows: <a href="../Integer/">Integer</a>,
  ?tile_size: <a href="../Integer/">Integer</a>,
  ?source: <a href="../String/">String</a>
) -&gt; TileSheet</code></pre>

Load a sheet of tiles

Reads a grid of pictures from one PNG (or BMP).
**Takes keyword arguments** (cols: is required; `tile_size:` is 16 when left
out). path is on the graphics side: send it with
sync_file first. Without rows:, give source: the picture on this side,
whose header has the height.
```ruby
gfx.sync_file(src, dest: dst)
sheet = TileSheet.new(gfx, dst,
  cols: 8, source: src)
```

### TileSheet.picture_height

<pre class="fmrb-sig"><code>picture_height(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read a picture's height from its header

The height in pixels of a PNG or BMP file. 0 when it is neither or
cannot be read (no exception). `TileSheet.new` uses it to get the rows
from `source:`.
```ruby
h = TileSheet.picture_height(src)
rows = h / 16
```

## Instance methods

### TileSheet#image

<pre class="fmrb-sig"><code>image() -&gt; <a href="../SpriteImage/">SpriteImage</a></code></pre>

The sprite image behind it

```ruby
img = sheet.image
```

### TileSheet#cols

<pre class="fmrb-sig"><code>cols() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many tiles across

```ruby
n = sheet.cols
```

### TileSheet#rows

<pre class="fmrb-sig"><code>rows() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many tiles down

```ruby
n = sheet.rows
```

### TileSheet#tile_size

<pre class="fmrb-sig"><code>tile_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

One tile's size in pixels

```ruby
px = sheet.tile_size
```

### TileSheet#stamp

<pre class="fmrb-sig"><code>stamp(
  <a href="../Integer/">Integer</a>? index,
  dst_x: <a href="../Integer/">Integer</a>,
  dst_y: <a href="../Integer/">Integer</a>,
  ?clip_x: <a href="../Integer/">Integer</a>,
  ?clip_y: <a href="../Integer/">Integer</a>,
  ?clip_w: <a href="../Integer/">Integer</a>,
  ?clip_h: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

Stamp one numbered tile

The place is by keyword (dst_x:, dst_y:), from the origin; clip_x: and
its three companions narrow what is stamped. nil or a negative number
does nothing.
```ruby
sheet.stamp(3, dst_x: x, dst_y: y)
```

### TileSheet#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

Let go of the sheet

```ruby
sheet.destroy
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
