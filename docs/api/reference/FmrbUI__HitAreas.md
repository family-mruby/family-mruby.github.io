# FmrbUI::HitAreas

Click targets of a screen redrawn every time

How to use it: [UI Widgets](../ui.md).

For screens drawn whole every time, like a game table: clear before
drawing, add each target as it is drawn, and look a click up with id_at.
**It draws nothing** (the button picture is FmrbGfx#draw_button). Do not
mix it with the FmrbUI widgets; the app acts on the press.

```ruby
@hits = FmrbUI::HitAreas.new

@hits.clear
@gfx.draw_button(x, y, 60, 16, "OK",
  theme_accent, theme_fg_light)
@hits.add(:ok, x, y, 60, 16)

id = @hits.id_at(ev[:x], ev[:y])
```

## Class methods

### FmrbUI::HitAreas.new

<pre class="fmrb-sig"><code>new() -&gt; FmrbUI::HitAreas</code></pre>

Create an empty list

```ruby
@hits = FmrbUI::HitAreas.new
```

## Instance methods

### FmrbUI::HitAreas#clear

<pre class="fmrb-sig"><code>clear() -&gt; FmrbUI::HitAreas</code></pre>

Empty the list

```ruby
@hits.clear
```

### FmrbUI::HitAreas#add

<pre class="fmrb-sig"><code>add(
  untyped id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  ?untyped data
) -&gt; FmrbUI::HitAreas</code></pre>

Add a click target

A sixth argument, data, comes back in the result of at (a mahjong tile,
say). A target lasts until the next clear.

```ruby
@hits.add(:ok, x, y, 60, 16)
@hits.add(:tile, x, y, 16, 24, t)
```

### FmrbUI::HitAreas#at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Array/">Array</a>?</code></pre>

The target at a point

Answers [id, x, y, w, h, data] or nil. Where targets overlap,
**the one added first wins**.

```ruby
b = @hits.at(ev[:x], ev[:y])
tile = b[5] if b
```

### FmrbUI::HitAreas#id_at

<pre class="fmrb-sig"><code>id_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; untyped</code></pre>

The id of the target at a point

nil when there is none; where targets overlap, the one added first.

```ruby
case @hits.id_at(ev[:x], ev[:y])
when :ok then close
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
