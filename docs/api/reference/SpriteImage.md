# SpriteImage

The picture data of a sprite

How to use it: [Sprites](../sprite.md).

What is drawn here is put on the screen with a SpriteInstance.

## Class methods

### SpriteImage.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; SpriteImage</code></pre>

Make an image (the size is in pixels)

**Takes keyword arguments**; the signature is positional because the type
engine has none.
```ruby
img = SpriteImage.new(gfx,
      width: 16, height: 16,
      transparent_color: 0x00,
      use_transparent: true)
```

## Instance methods

### SpriteImage#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Integer/">Integer</a></code></pre>

This image's number

What you hand to `FmrbGfx` directly.
```ruby
gfx.draw_image(img.id, x: 10, y: 20)
```

### SpriteImage#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Image width in pixels

```ruby
w = img.width
```

### SpriteImage#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Image height in pixels

```ruby
h = img.height
```

### SpriteImage#set_target

<pre class="fmrb-sig"><code>set_target() -&gt; void</code></pre>

Draw into this image from now on

**Remember to send it back.** `draw` does both ends for you.
```ruby
img.set_target
@gfx.fill_rect(0, 0, 8, 8, 0xFF)
img.reset_target
```

### SpriteImage#reset_target

<pre class="fmrb-sig"><code>reset_target() -&gt; void</code></pre>

Draw on the screen again

```ruby
img.reset_target
```

### SpriteImage#draw

<pre class="fmrb-sig"><code>draw() -&gt; void</code></pre>

Draw into this image (inside the block)

```ruby
img.draw do |g|
  g.fill_rect(0, 0, 16, 16,
              FmrbGfx::RED)
end
```

### SpriteImage#load_bmp

<pre class="fmrb-sig"><code>load_bmp(<a href="../String/">String</a> path) -&gt; void</code></pre>

Read a PNG or BMP into this image

A PNG (its colours become RGB332 by their top 3/3/2 bits; a transparent
pixel -- alpha below 128, tRNS -- becomes the transparent colour 0x01,
so an image made with transparent_color: 0x01 leaves it out) or an 8-bit
BMP whose pixel values are RGB332, told apart
by the first bytes. The name is from when it read BMP only. It is decoded
on the graphics side. A whole picture goes through `FmrbGfx#create_image`.
```ruby
img.load_bmp(
  "/usr/share/sprites/flappy/bird_up.png")
```

### SpriteImage#write_pixels

<pre class="fmrb-sig"><code>write_pixels(<a href="../String/">String</a> pixels) -&gt; void</code></pre>

Write RGB332 pixels into this image

pixels is width x height bytes, top row first. x:, y:, width:, height:
write a part only (the whole image by default). A picture made without
a file.
```ruby
img = SpriteImage.new(@gfx,
  width: 2, height: 2)
img.write_pixels("\xE0\x1C\x03\xFF")
```

### SpriteImage#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

Let go of this image

```ruby
img.destroy
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
