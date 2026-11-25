# FmrbText

Fit and wrap a text in pixels

How to use it: [Drawing](../fmrb_gfx.md).

Mixed into FmrbGfx, so call it on @gfx. Widths are measured with the
font and text size selected at the time of the call (the same numbers as
text_width). It remembers nothing. Implemented in
lib/gems/picoruby-fmrb-app/mrblib/fmrb-text.rb.

```ruby
s = @gfx.fit_text(name, 80)
@gfx.draw_text(x, y, s, theme_fg)
```

## Instance methods

### FmrbText#fit_text

<pre class="fmrb-sig"><code>fit_text(
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> width,
  ?<a href="../String/">String</a> mark,
  ?<a href="../Integer/">Integer</a>? mark_w,
  ?<a href="../Symbol/">Symbol</a>? family
) -&gt; <a href="../String/">String</a></code></pre>

Cut a text to fit a width in pixels

**A text that fits comes back unchanged.** Only when it has to be cut
is the third argument appended as a mark ("…", ".."), with room kept
for it; without a mark the text is just cut. The fourth argument is the
mark's width in pixels (nil measures it), the fifth the font to measure
with (nil means the current one).

```ruby
@gfx.fit_text(title, 100)
@gfx.fit_text(title, 100, "…")
@gfx.fit_text(name, w, "..", nil,
              :default)
```

### FmrbText#wrap_text

<pre class="fmrb-sig"><code>wrap_text(<a href="../String/">String</a> text, <a href="../Integer/">Integer</a> width) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

Wrap a text into at most two lines

Answers an array of one or two strings. The break goes at the last
space of the first line when the rest then fits on one line; otherwise
at the width, and a second line still too long ends in "…". For three
lines or more, cut one line at a time with fit_text.

```ruby
lines = @gfx.wrap_text(msg, 120)
```

### FmrbText#draw_text_lines

<pre class="fmrb-sig"><code>draw_text_lines(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> line_h
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Draw a text wrapped into lines

Draws the lines of wrap_text downwards, line_h apart, and answers the y
under the last one.

```ruby
y = @gfx.draw_text_lines(x, y, msg,
      120, theme_fg, 15)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
