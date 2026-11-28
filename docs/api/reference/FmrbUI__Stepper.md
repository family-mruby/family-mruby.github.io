# FmrbUI::Stepper

A value stepper

How to use it: [UI Widgets](../ui.md).

Inherits from: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## Instance methods

### FmrbUI::Stepper#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Integer/">Integer</a></code></pre>

The current value

```ruby
n = stepper.value
```

### FmrbUI::Stepper#min

<pre class="fmrb-sig"><code>min() -&gt; <a href="../Integer/">Integer</a></code></pre>

The lowest value

```ruby
lo = stepper.min
```

### FmrbUI::Stepper#max

<pre class="fmrb-sig"><code>max() -&gt; <a href="../Integer/">Integer</a></code></pre>

The highest value

```ruby
hi = stepper.max
```

### FmrbUI::Stepper#step

<pre class="fmrb-sig"><code>step() -&gt; <a href="../Integer/">Integer</a></code></pre>

How much one press moves the value

```ruby
d = stepper.step
```

### FmrbUI::Stepper#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

The text shown

```ruby
s = stepper.text
```

### FmrbUI::Stepper#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Integer/">Integer</a> v) -&gt; bool</code></pre>

Set the value

Clamped to min / max. Returns true only when the value actually changed.
```ruby
st = @ui.stepper(:size, 4, 26, 108,
                 14, 5, 1, 9)
st.set_value(7)   #=> true
```

### FmrbUI::Stepper#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Integer/">Integer</a> min, <a href="../Integer/">Integer</a> max) -&gt; void</code></pre>

Change the lowest and highest values

**The current value is pulled inside the new range.** The same range
does nothing. For a range the data decides, like the tracks in a loaded
file.
```ruby
@track_st.set_range(1, total)
```

### FmrbUI::Stepper#suffix=

<pre class="fmrb-sig"><code>suffix=(<a href="../String/">String</a> s) -&gt; void</code></pre>

Unit appended after the number

Set it once, right after creating the stepper (e.g. "%").
```ruby
st.suffix = "%"
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
