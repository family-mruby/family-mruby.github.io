# FmrbUI::Scrollbar

A vertical scrollbar

How to use it: [UI Widgets](../ui.md).

Inherits from: [`FmrbUI::Widget`](FmrbUI__Widget.md)

It knows nothing about the list: three integers (how many there are, how
many fit, where we are) are all it needs. The app owns the position and the
bar is a view of it. Made with `FmrbUI#scrollbar`; the value can also be
pushed in with `FmrbUI#set_value` / `set_range`.

## Instance methods

### FmrbUI::Scrollbar#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Integer/">Integer</a></code></pre>

The current position

```ruby
@scroll = bar.value
```

### FmrbUI::Scrollbar#total

<pre class="fmrb-sig"><code>total() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many there are

```ruby
n = bar.total
```

### FmrbUI::Scrollbar#visible_count

<pre class="fmrb-sig"><code>visible_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many fit

```ruby
rows = bar.visible_count
```

### FmrbUI::Scrollbar#active?

<pre class="fmrb-sig"><code>active?() -&gt; bool</code></pre>

Whether the bar is in use

False while everything fits: nothing is drawn and clicks pass through.
```ruby
draw_hint unless bar.active?
```

### FmrbUI::Scrollbar#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Integer/">Integer</a> v) -&gt; bool</code></pre>

Set the position

Clamped to 0 .. (total - visible). Returns true only when the position
actually changed (false when it was already there).
```ruby
bar.set_value(@scroll)
```

### FmrbUI::Scrollbar#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Integer/">Integer</a> total, <a href="../Integer/">Integer</a> visible) -&gt; void</code></pre>

Change how many there are and fit

**Unlike a Stepper's set_range the arguments are (total, visible).** The
position is pulled inside the new range.
```ruby
bar.set_range(@files.size, 8)
```

### FmrbUI::Scrollbar#hit?

<pre class="fmrb-sig"><code>hit?(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py) -&gt; bool</code></pre>

Whether the point is on the bar

**False while the bar is not in use (everything fits)**, even over its
rectangle, so the click goes to the list behind.
```ruby
on_bar = @ui.find(:sb).hit?(x, y)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
