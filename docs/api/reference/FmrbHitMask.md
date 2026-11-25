# FmrbHitMask

The hit shape of a frameless window, per pixel

How to use it: [Sprites](../sprite.md).

Made with FmrbApp#hit_mask_from_art.

## Class methods

### FmrbHitMask.new

<pre class="fmrb-sig"><code>new(
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../String/">String</a> bits,
  ?<a href="../Integer/">Integer</a> scale
) -&gt; FmrbHitMask</code></pre>

Make a mask (bits row by row)

width x height cells. bits: (width + 7) / 8 bytes per row, the leftmost
cell in the top bit. A set cell is hit.
```ruby
m = FmrbHitMask.new(8, 1,
      "\xF0", 2)
```

### FmrbHitMask.from_art

<pre class="fmrb-sig"><code>from_art(
  <a href="../Array/">Array</a> rows,
  ?transparent: <a href="../String/">String</a>,
  ?scale: <a href="../Integer/">Integer</a>
) -&gt; FmrbHitMask</code></pre>

Make one from dot-art strings

```ruby
m = FmrbHitMask.from_art(ROWS,
      transparent: ".", scale: 3)
```

## Instance methods

### FmrbHitMask#set?

<pre class="fmrb-sig"><code>set?(<a href="../Integer/">Integer</a> cx, <a href="../Integer/">Integer</a> cy) -&gt; bool</code></pre>

Whether the cell is hit

```ruby
m.set?(3, 0)
```

### FmrbHitMask#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Width in cells

```ruby
m.width
```

### FmrbHitMask#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Height in cells

```ruby
m.height
```

### FmrbHitMask#scale

<pre class="fmrb-sig"><code>scale() -&gt; <a href="../Integer/">Integer</a></code></pre>

Pixels per cell

```ruby
m.scale
```

### FmrbHitMask#bits

<pre class="fmrb-sig"><code>bits() -&gt; <a href="../String/">String</a></code></pre>

The bits

```ruby
same = m.bits == old.bits
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
