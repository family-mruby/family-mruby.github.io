# TileRing

Redraws only what is in view

How to use it: [Tile Maps](../tilemap.md).

A mechanism for moving a wide map lightly.

## Class methods

### TileRing.new

<pre class="fmrb-sig"><code>new(
  <a href="../TileMap/">TileMap</a> map,
  <a href="../TileSheet/">TileSheet</a> sheet,
  tiles_w: <a href="../Integer/">Integer</a>,
  tiles_h: <a href="../Integer/">Integer</a>
) -&gt; TileRing</code></pre>

Make the ring buffer that scrolls

Uses a canvas a little larger than the view as a ring, stamping only the
columns that have just come into sight. **Modern only.**
**`tiles_w:` and `tiles_h:` are required** (the size of the ring canvas in tiles, at least the visible tiles + 1).
```ruby
ring = TileRing.new(map, sheet,
  tiles_w: 12, tiles_h: 12)
```

## Instance methods

### TileRing#buf_w

<pre class="fmrb-sig"><code>buf_w() -&gt; <a href="../Integer/">Integer</a></code></pre>

The buffer's width in pixels

```ruby
w = ring.buf_w
```

### TileRing#buf_h

<pre class="fmrb-sig"><code>buf_h() -&gt; <a href="../Integer/">Integer</a></code></pre>

The buffer's height in pixels

```ruby
h = ring.buf_h
```

### TileRing#ensure_view

<pre class="fmrb-sig"><code>ensure_view(
  <a href="../Integer/">Integer</a> view_x,
  <a href="../Integer/">Integer</a> view_y,
  <a href="../Integer/">Integer</a> view_w,
  <a href="../Integer/">Integer</a> view_h
) -&gt; bool</code></pre>

Stamp the columns that came into sight

**Call it every frame after moving.** It stamps only the columns that
have just come into sight, so a small step costs nothing. true when it
drew something, and then the ring's canvas must be presented or nothing
reaches the screen.
```ruby
ring.ensure_view(@cam_x, @cam_y,
                 320, 240)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
