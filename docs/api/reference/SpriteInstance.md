# SpriteInstance

One sprite placed on the screen

How to use it: [Sprites](../sprite.md).

It holds a position and which frame to show.

## Class methods

### SpriteInstance.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx, untyped images) -&gt; SpriteInstance</code></pre>

Place an image on the screen

Give images one SpriteImage, or an array of them like the frames of a
flip book. With several, `frame=` says which one is shown.

```ruby
img = SpriteImage.new(gfx, width: 16, height: 16)
img.load_bmp("/app/img/player.png")
sp = SpriteInstance.new(gfx, img, x: 40, y: 80)
sp.move(48, 80)
```

## Instance methods

### SpriteInstance#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Integer/">Integer</a></code></pre>

This placed sprite's number

```ruby
sp.id
```

### SpriteInstance#move

<pre class="fmrb-sig"><code>move(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; void</code></pre>

Move the placed sprite

**`gfx.present` is needed afterwards**; the compositing happens there.
```ruby
sp.move(48, 80)
gfx.present
```

### SpriteInstance#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

Let go of this sprite

```ruby
sp.destroy
```

### SpriteInstance#visible=

<pre class="fmrb-sig"><code>visible=(bool v) -&gt; void</code></pre>

Show or hide it

```ruby
sp.visible = false
```

### SpriteInstance#frame=

<pre class="fmrb-sig"><code>frame=(<a href="../Integer/">Integer</a> index) -&gt; void</code></pre>

Which frame to show (0 is the first)

Picks the frame of a flip book, when it was placed with several images.
```ruby
sp.frame = (sp.x / 4) % 2
```

### SpriteInstance#visible?

<pre class="fmrb-sig"><code>visible?() -&gt; bool</code></pre>

Whether it is shown

```ruby
sp.visible = !sp.visible?
```

### SpriteInstance#x

<pre class="fmrb-sig"><code>x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where it is now: x (window coordinates)

```ruby
sp.move(sp.x + 4, sp.y)
```

### SpriteInstance#y

<pre class="fmrb-sig"><code>y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where it is now: y (window coordinates)

```ruby
sp.move(sp.x, sp.y + 4)
```

### SpriteInstance#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Width (of the first image)

```ruby
right = sp.x + sp.width
```

### SpriteInstance#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Height (of the first image)

```ruby
bottom = sp.y + sp.height
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
