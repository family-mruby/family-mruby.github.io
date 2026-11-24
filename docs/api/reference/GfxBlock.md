# GfxBlock

A draft for drawing the same shape over and over

How to use it: [Sprites](../sprite.md).

Swap only the numbers and draw it as many times as you like.

## Class methods

### GfxBlock.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; GfxBlock</code></pre>

Make a drawing to replay (the block says how)

Builds a drawing once and replays it with different numbers, which beats
sending the commands from Ruby each time.

**The block cannot capture an outer local** (Spinel). Pass what it needs
as an argument to `draw`.
```ruby
@blk = GfxBlock.new(gfx) do |g, w, h|
  g.draw_rect(0, 0, w, h,
              FmrbGfx::WHITE)
end
```

## Instance methods

### GfxBlock#draw

<pre class="fmrb-sig"><code>draw() -&gt; void</code></pre>

Replay it with different numbers

```ruby
@blk.draw(w: 100, h: 40)
```

### GfxBlock#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

Let go of the drawing

```ruby
@blk.destroy
```

### GfxBlock#destroyed?

<pre class="fmrb-sig"><code>destroyed?() -&gt; bool</code></pre>

Whether it has been let go of

```ruby
return if @blk.destroyed?
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
