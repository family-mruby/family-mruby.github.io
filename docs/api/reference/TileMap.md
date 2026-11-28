# TileMap

The map itself

How to use it: [Tile Maps](../tilemap.md).

Reads the JSON that the web map editor writes out.

## Class methods

### TileMap.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> json_path) -&gt; TileMap</code></pre>

Load a map file

**Give it the `.map.bin`.** JSON works and is far slower on a device --
39 seconds against 55 milliseconds.
```ruby
map = TileMap.new("/app/img/world.map.bin")
```

## Instance methods

### TileMap#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

The map's width in tiles

```ruby
w = map.width
```

### TileMap#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

The map's height in tiles

```ruby
h = map.height
```

### TileMap#tile_size

<pre class="fmrb-sig"><code>tile_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

One tile's size in pixels

```ruby
px = map.tile_size
```

### TileMap#tilesheet_path

<pre class="fmrb-sig"><code>tilesheet_path() -&gt; <a href="../String/">String</a></code></pre>

The tile sheet it uses

```ruby
path = map.tilesheet_path
```

### TileMap#tilesheet_cols

<pre class="fmrb-sig"><code>tilesheet_cols() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many tiles across that sheet is

```ruby
n = map.tilesheet_cols
```

### TileMap#layers

<pre class="fmrb-sig"><code>layers() -&gt; <a href="../Array/">Array</a>?</code></pre>

The layers of the map

nil when read from a `.map.bin` (an Array only from JSON). Read the number of layers with `layer_count` and squares with `tile_at`.
```ruby
map.layers.length
```

### TileMap#layer_count

<pre class="fmrb-sig"><code>layer_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many layers the map has

Works for a `.map.bin` and for JSON. The `layer:` of `tile_at` runs from
0 to one less than this.
```ruby
n = map.layer_count
```

### TileMap#events

<pre class="fmrb-sig"><code>events() -&gt; <a href="../Array/">Array</a></code></pre>

The events placed on the map

```ruby
map.events.length
```

### TileMap#walkable_tiles

<pre class="fmrb-sig"><code>walkable_tiles() -&gt; <a href="../Array/">Array</a></code></pre>

Which tile numbers can be walked on

```ruby
map.walkable_tiles
```

### TileMap#spawn_x

<pre class="fmrb-sig"><code>spawn_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where the player starts

```ruby
@x = map.spawn_x
```

### TileMap#spawn_y

<pre class="fmrb-sig"><code>spawn_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where the player starts

```ruby
@y = map.spawn_y
```

### TileMap#tile_at

<pre class="fmrb-sig"><code>tile_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, ?layer: <a href="../Integer/">Integer</a>) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The tile number at that square

nil outside the map, on an empty square, or when the layer is missing.
The coordinates are **tiles**, not pixels. `layer:` (0 when left out)
picks the layer.
```ruby
t = map.tile_at(3, 5)
```

### TileMap#walkable?

<pre class="fmrb-sig"><code>walkable?(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

Whether that square can be walked on

```ruby
return unless map.walkable?(nx, ny)
```

### TileMap#event_at

<pre class="fmrb-sig"><code>event_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

The event on that square

```ruby
ev = map.event_at(@x, @y)
handle(ev) if ev
```

### TileMap#render

<pre class="fmrb-sig"><code>render(
  <a href="../TileSheet/">TileSheet</a> sheet,
  origin_x: <a href="../Integer/">Integer</a>,
  origin_y: <a href="../Integer/">Integer</a>,
  ?max_cols: <a href="../Integer/">Integer</a>,
  ?max_rows: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

Draw the whole map

Draws the whole map. For a large one use `render_view`, which draws only
what is on screen.
**`origin_x:` and `origin_y:` are required** (where the first tile lands on the canvas). `max_cols:` and `max_rows:` (the whole map when left out) clip the region.
```ruby
@map.render(@sheet,
            origin_x: 0, origin_y: 0)
```

### TileMap#render_view

<pre class="fmrb-sig"><code>render_view(
  <a href="../TileSheet/">TileSheet</a> sheet,
  origin_x: <a href="../Integer/">Integer</a>,
  origin_y: <a href="../Integer/">Integer</a>,
  view_x: <a href="../Integer/">Integer</a>,
  view_y: <a href="../Integer/">Integer</a>,
  view_w: <a href="../Integer/">Integer</a>,
  view_h: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

Draw only what is in sight

**Takes keyword arguments, all required.** `origin_x:` and `origin_y:`
are where the view's top-left lands on the canvas; `view_x:` and
`view_y:` are where that corner is on the map, in pixels.
```ruby
map.render_view(sheet,
  origin_x: 0, origin_y: 0,
  view_x: @cam_x, view_y: @cam_y,
  view_w: 320, view_h: 240)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
