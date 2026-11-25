# FmrbUI::Widget

What every widget has

How to use it: [UI Widgets](../ui.md).

## Instance methods

### FmrbUI::Widget#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

This widget's id

```ruby
case w.id
when :ok then close
end
```

### FmrbUI::Widget#x

<pre class="fmrb-sig"><code>x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Left edge (canvas coordinates)

```ruby
left = w.x
```

### FmrbUI::Widget#y

<pre class="fmrb-sig"><code>y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Top edge (canvas coordinates)

```ruby
top = w.y
```

### FmrbUI::Widget#w

<pre class="fmrb-sig"><code>w() -&gt; <a href="../Integer/">Integer</a></code></pre>

Width in pixels

```ruby
width = w.w
```

### FmrbUI::Widget#h

<pre class="fmrb-sig"><code>h() -&gt; <a href="../Integer/">Integer</a></code></pre>

Height in pixels

```ruby
height = w.h
```

### FmrbUI::Widget#dirty

<pre class="fmrb-sig"><code>dirty() -&gt; bool</code></pre>

Whether the next flush redraws it

```ruby
@ui.flush if w.dirty
```

### FmrbUI::Widget#enabled

<pre class="fmrb-sig"><code>enabled() -&gt; bool</code></pre>

Whether it accepts clicks

```ruby
return unless w.enabled
```

### FmrbUI::Widget#visible

<pre class="fmrb-sig"><code>visible() -&gt; bool</code></pre>

Whether it is shown

```ruby
next unless w.visible
```

### FmrbUI::Widget#text_size

<pre class="fmrb-sig"><code>text_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

Text scale, fixed at creation

```ruby
s = w.text_size
```

### FmrbUI::Widget#hit?

<pre class="fmrb-sig"><code>hit?(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py) -&gt; bool</code></pre>

Whether the point is inside

```ruby
hit = w.hit?(ev[:x], ev[:y])
```

### FmrbUI::Widget#place

<pre class="fmrb-sig"><code>place(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Move and resize (canvas coordinates)

Moves a widget that already exists -- what you use to lay the
widgets out again after the window is resized.
```ruby
w.place(10, 40, 80, 20)
@ui.flush
```

### FmrbUI::Widget#bg

<pre class="fmrb-sig"><code>bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

The colour a widget paints inside itself

The box of a Label, the value field of a Stepper, the track of a
Scrollbar. A Button, Toggle and TextField do not use it. It is not the
colour of what is behind the widget.
```ruby
c = w.bg
```

### FmrbUI::Widget#bg=

<pre class="fmrb-sig"><code>bg=(<a href="../Integer/">Integer</a> c) -&gt; void</code></pre>

Change the colour a widget paints inside

The colour counts as the app's own and does not turn back into the
theme's after a move to another machine.
**It does not mark the widget for redraw**: call `@ui.invalidate_all`,
or wait until the widget changes.
```ruby
@ui.find(:title).bg = FmrbGfx::BLACK
@ui.invalidate_all
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
