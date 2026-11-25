# Fmrb::Raycast

Ray casting over a grid map

(Wolfenstein 3D style.) **Every value is an**
**integer**: one cell is 256 in fixed point, **angles are whole degrees**, and one cast fires
**40 rays** across a 60-degree field of view. The result is a distance, a wall value and a
face per ray. The backends are `:ruby` and `:spinel` (the same calculation as native code).
```ruby
rc = Fmrb::Raycast.new
rc.set_map(MAP, 12, 12)
rc.cast(px, py, deg)
d = rc.dist(20)
```

## Class methods

### Fmrb::Raycast.new

<pre class="fmrb-sig"><code>new(?backend: <a href="../Symbol/">Symbol</a>) -&gt; Fmrb::Raycast</code></pre>

Make a caster

`backend:` (`:ruby` when left out) is `:ruby` or `:spinel`; anything else is an ArgumentError
("unknown raycast backend: x"). **A build without `:spinel` raises RuntimeError**, so check
`Fmrb::Raycast.available?(:spinel)` first. `:spinel` is one per machine and **held by the app**
**that opened it first**; a second app silently gets `:ruby` (see `backend`).
```ruby
rc = Fmrb::Raycast.new(backend: :ruby)
```

### Fmrb::Raycast.available?

<pre class="fmrb-sig"><code>available?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

Whether this build has a backend

`:ruby` is always true, `:spinel` only in a build that has it, any other name false.
```ruby
Fmrb::Raycast.available?(:spinel)
```

### Fmrb::Raycast.micros

<pre class="fmrb-sig"><code>micros() -&gt; <a href="../Integer/">Integer</a></code></pre>

The clock both backends are timed with (microseconds)

Use differences. The same clock as the time `cast` returns.
```ruby
t = Fmrb::Raycast.micros
```

### Fmrb::Raycast.unpack

<pre class="fmrb-sig"><code>unpack(<a href="../String/">String</a> buf) -&gt; <a href="../Array/">Array</a>[<a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, <a href="../Integer/">Integer</a>]]</code></pre>

Turn a packed result into an Array of Hashes

One `{ dist:, wall:, side: }` per ray. It makes a Hash per ray, so it is heavy and not for
each frame's drawing (read `dist`, `wall` and `side`). It takes the 6-bytes-per-ray form.
```ruby
Fmrb::Raycast.unpack(buf)
```

## Instance methods

### Fmrb::Raycast#backend

<pre class="fmrb-sig"><code>backend() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

The backend actually casting

```ruby
rc.backend   #=> :ruby
```

### Fmrb::Raycast#set_map

<pre class="fmrb-sig"><code>set_map(<a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>?] | <a href="../String/">String</a> cells, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; nil</code></pre>

Hand over the map

`cells` is **an Array of Integers, one per cell** (row by row from the top left, w * h of
them), or a String with one byte per cell. A value is 0..255 (cut to 8 bits, nil is 0).
**0 is empty; anything else is a wall and its value comes back from `wall`.** **Outside the**
**map counts as a wall (value 1).** `w` and `h` are the width and height in cells. Returns
nil. **Call it once before `cast`.**

A map `:spinel` cannot take (a size of 0 or less, a cell count that does not match) raises
RuntimeError or ArgumentError ("map dimensions must be positive", "need n map cells, got n bytes").
```ruby
rc.set_map([1,1,1, 1,0,1, 1,1,1], 3, 3)
```

### Fmrb::Raycast#cast

<pre class="fmrb-sig"><code>cast(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py, <a href="../Integer/">Integer</a> pa) -&gt; <a href="../Integer/">Integer</a></code></pre>

Cast one frame of rays

`px` and `py` are the position (**one cell is 256 in fixed point**; `cell * 256 + 128` is
the middle of a cell), `pa` the heading (whole degrees; over 360 or negative is fine).
**Returns the time taken in microseconds.** The result is read with `dist`, `wall` and
`side`, not from the return value. Before `set_map` it raises RuntimeError ("set_map has
not been called").
```ruby
us = rc.cast(px, py, deg)
```

### Fmrb::Raycast#rays

<pre class="fmrb-sig"><code>rays() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many rays the last cast gave

0 before the first `cast`. Normally 40.
```ruby
rc.rays   #=> 40
```

### Fmrb::Raycast#dist

<pre class="fmrb-sig"><code>dist(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

Distance to the wall ray i hit

An integer in fixed point (256 = one cell). **Already corrected to the distance**
**perpendicular to the view** (no fisheye). At least 1, never 0. 0 before `cast`. `i` runs from
0 up to under `rays` (outside it raises NoMethodError).
```ruby
h = 6000 / rc.dist(i)
```

### Fmrb::Raycast#wall

<pre class="fmrb-sig"><code>wall(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

The wall value ray i hit

The map's value. **0 means the ray ran out of its 24 steps without a hit.** 0 before `cast`.
```ruby
rc.wall(i)
```

### Fmrb::Raycast#side

<pre class="fmrb-sig"><code>side(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

Which face ray i hit

0 is a vertical face, 1 a horizontal one. Use it to shade the two apart. 0 before `cast`.
```ruby
dark = rc.side(i) == 1
```

### Fmrb::Raycast#fp_sin

<pre class="fmrb-sig"><code>fp_sin(<a href="../Integer/">Integer</a> deg) -&gt; <a href="../Integer/">Integer</a></code></pre>

Fixed-point sine of whole degrees

The result is -256..256 (256 = 1.0). Negative and over-360 degrees are fine. **The same**
**on either backend**, so use it for movement and placement.
```ruby
dy = rc.fp_sin(deg) * 8 / 256
```

### Fmrb::Raycast#fp_cos

<pre class="fmrb-sig"><code>fp_cos(<a href="../Integer/">Integer</a> deg) -&gt; <a href="../Integer/">Integer</a></code></pre>

Fixed-point cosine of whole degrees

The same form as `fp_sin` (-256..256).
```ruby
dx = rc.fp_cos(deg) * 8 / 256
```

### Fmrb::Raycast#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Be done with it

Gives up the Spinel instance (nothing for `:ruby`) and drops the map. Returns nil.
**Call it when the app ends if you used `:spinel`.**
```ruby
rc.close
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
