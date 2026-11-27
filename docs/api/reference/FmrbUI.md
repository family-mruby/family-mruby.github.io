# FmrbUI

Widget container

How to use it: [UI Widgets](../ui.md).

## Class methods

### FmrbUI.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbApp/">FmrbApp</a> app,
  ?bg: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?bg_painter: untyped
) -&gt; FmrbUI</code></pre>

Create the widget box

Pass the app itself (FmrbApp). The canvas and the user-area origin are
read from it.

bg: is the colour a widget paints inside itself - a Label's box, a
Stepper's value field, a Scrollbar's track. It defaults to the window
background; an app that clears its user area to something darker passes
that colour instead. Left out, it becomes the window background of the
machine an app is moved to (a colour passed is kept).

bg_painter: is who repaints the ground where a widget used to be. Left
out, the hole is filled with bg:, which is right while the ground is one
colour. Where it is a picture - wallpaper, a border, a rounded corner -
pass an object answering paint_bg_rect(gfx, x, y, w, h), usually self.
That method draws the rectangle and nothing else: no present, no
allocation, and it puts back any text size or font it changed. The name
is fixed.

text_size: is the default scale for the widgets made from here on (1
unless given). A single widget can override it with its own text_size:.
The size is fixed when the widget is made and never follows the size the
app happens to be in, and flush hands the app's size back afterwards.

## Instance methods

### FmrbUI#label

<pre class="fmrb-sig"><code>label(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?align: <a href="../Symbol/">Symbol</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Label/">FmrbUI::Label</a></code></pre>

Place a text label

align: chooses the alignment (:left / :center / :right, default :left).
text_size: enlarges this one widget's text (1-4); useful for a heading.
```ruby
@ui.label(:l_size, 4, 148, 60, 10,
          "Size")
```

### FmrbUI#button

<pre class="fmrb-sig"><code>button(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?accent: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Button/">FmrbUI::Button</a></code></pre>

Place a push button

Inverted while held; handle returns the id when the button is released
on top of it. Releasing outside does nothing. text_size: enlarges the
label (1-4), as on every widget.

accent: paints the button in that RGB332 colour instead of the theme's.
Reserve it for the few controls whose colour carries meaning - a confirm
dialog's Yes, a transport's Stop. On a Toggle it is the on colour.
```ruby
@ui.button(:start, 4, 20, 60, 16,
           "Start")
```

### FmrbUI#toggle

<pre class="fmrb-sig"><code>toggle(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?group: <a href="../Symbol/">Symbol</a>,
  ?on: bool,
  ?on_text: <a href="../String/">String</a>,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?accent: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Toggle/">FmrbUI::Toggle</a></code></pre>

Place an on/off toggle

Toggles sharing a group: name behave as radio buttons - only one is on.
on: true starts it on; on_text: gives it a different label when on.

### FmrbUI#stepper

<pre class="fmrb-sig"><code>stepper(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> value,
  <a href="../Integer/">Integer</a> min,
  <a href="../Integer/">Integer</a> max,
  ?<a href="../Integer/">Integer</a> step,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Stepper/">FmrbUI::Stepper</a></code></pre>

Place a value stepper

A "< value >" control. handle returns the id for either side, the value
stops at min / max, and pressing at the end returns nothing. An optional
last argument sets the step (default 1).

### FmrbUI#enum

<pre class="fmrb-sig"><code>enum(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Array/">Array</a>[<a href="../String/">String</a>] options,
  ?index: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Enum/">FmrbUI::Enum</a></code></pre>

Place a choice picker

A "< choice >" control over options. value is the chosen index and
option_text the string. It stops at the ends rather than wrapping, and
builds no string when moved, which makes it lighter than a Stepper.
`index:` (0 when left out) is the choice shown first, `text_size:` the
text scale of this widget alone. options is read, never written.

### FmrbUI#scrollbar

<pre class="fmrb-sig"><code>scrollbar(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> total,
  <a href="../Integer/">Integer</a> visible,
  ?<a href="../Integer/">Integer</a> scroll
) -&gt; <a href="../FmrbUI__Scrollbar/">FmrbUI::Scrollbar</a></code></pre>

Place a vertical scrollbar

x, y, w, h are the bar itself, not the list it scrolls (10 wide is the
usual). total (how many there are), visible (how many fit) and scroll
(the position; 0 when left out) are all it needs.
**The app owns the position.** Push it in with `set_value` when keys move
it, call `set_range` when the count changes, and read it back with
`value` after the bar is pressed. The wheel is not answered here (use
`wheel_rows`).

**handle returns the id on the press** (not the release), once for a
held press. One press moves one step, and a press at an end returns
nothing. `direction` says which way a held bar goes; the app does the
repeating. While everything fits (total at most visible) it draws
nothing and **clicks pass through to the list behind**. It is meant to
be made in on_create (making allocates; an app whose window resizes
builds it again in on_resize).
```ruby
@ui.scrollbar(:sb, w - 10, y, 10, h,
              0, rows, 0)
# ...
@ui.set_range(:sb, @files.size, rows)
@ui.set_value(:sb, @scroll)
```

### FmrbUI#option_text

<pre class="fmrb-sig"><code>option_text(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

The chosen string

What the Enum is showing. Its index is read with value.
```ruby
name = @ui.option_text(:mode)
```

### FmrbUI#text_field

<pre class="fmrb-sig"><code>text_field(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  ?<a href="../String/">String</a> text,
  ?max: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__TextField/">FmrbUI::TextField</a></code></pre>

Place a one-line text field

Click to focus; keys go to whichever field has the focus. Enter makes
handle report the id, Escape drops the focus. The caret does not blink
(blinking would mean drawing every frame) and there are no arrow keys:
characters go on the end and backspace takes from the end.

### FmrbUI#field_text

<pre class="fmrb-sig"><code>field_text(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

What has been typed

```ruby
name = @ui.field_text(:name)
```

### FmrbUI#set_field_text

<pre class="fmrb-sig"><code>set_field_text(<a href="../Symbol/">Symbol</a> id, <a href="../String/">String</a> text) -&gt; void</code></pre>

Replace what is in the field

```ruby
@ui.set_field_text(:name, "untitled")
```

### FmrbUI#focus

<pre class="fmrb-sig"><code>focus(<a href="../Symbol/">Symbol</a> id) -&gt; void</code></pre>

Give a widget the focus

nil takes the focus away, and so does anything that is not a text field.
```ruby
@ui.focus(:name)
@ui.focus(nil)
```

### FmrbUI#focused

<pre class="fmrb-sig"><code>focused() -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

Which widget has the focus

```ruby
return if @ui.focused == :name
```

### FmrbUI#handle

<pre class="fmrb-sig"><code>handle(<a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped] ev) -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

Feed one event

Returns the id of the widget whose operation completed, or nil. A press
only updates the pressed look and returns nil; the id comes when the
button is released over the same widget. mouse_move does nothing.
```ruby
case @ui.handle(ev)
when :start then start_game
end
```

### FmrbUI#flush

<pre class="fmrb-sig"><code>flush() -&gt; bool</code></pre>

Draw the changed widgets

Calls present once when anything was drawn and returns true; returns
false without drawing when nothing changed. Call it after drawing your
own picture so present happens only once.
```ruby
draw_picture
@gfx.present unless @ui.flush
```

### FmrbUI#invalidate_all

<pre class="fmrb-sig"><code>invalidate_all() -&gt; void</code></pre>

Mark every widget for redraw

Call it after clear_user_area or a resize.
```ruby
clear_user_area
@ui.invalidate_all
@ui.flush
```

### FmrbUI#find

<pre class="fmrb-sig"><code>find(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../FmrbUI__Widget/">FmrbUI::Widget</a>?</code></pre>

Find a widget by id

nil when there is none.
```ruby
w = @ui.find(:ok)
w.place(x, y, 60, 20) if w
```

### FmrbUI#move

<pre class="fmrb-sig"><code>move(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Move and resize a widget

Coordinates are user-area relative, as at creation time.
```ruby
@ui.move(:ok, 4, 60, 50, 16)
```

### FmrbUI#on?

<pre class="fmrb-sig"><code>on?(<a href="../Symbol/">Symbol</a> id) -&gt; bool</code></pre>

Whether the toggle is on

```ruby
save_backup if @ui.on?(:backup)
```

### FmrbUI#set_on

<pre class="fmrb-sig"><code>set_on(<a href="../Symbol/">Symbol</a> id, bool on) -&gt; void</code></pre>

Set a toggle from the app

For a grouped toggle, switching it on switches the rest of the group off.
```ruby
@ui.set_on(:on, true)
```

### FmrbUI#set_text

<pre class="fmrb-sig"><code>set_text(<a href="../Symbol/">Symbol</a> id, <a href="../String/">String</a> text) -&gt; void</code></pre>

Change a widget's text

Does nothing when the text is unchanged; it re-measures and redraws only
when it actually changed.
```ruby
@ui.set_text(:near, "Back")
```

### FmrbUI#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> value) -&gt; bool</code></pre>

Set a stepper value from the app

Clamped to min / max. Returns true only when the value actually changed.
```ruby
@ui.set_value(:sb, 3)
```

### FmrbUI#value

<pre class="fmrb-sig"><code>value(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read the current stepper value

```ruby
n = @ui.value(:speed)
```

### FmrbUI#set_enabled

<pre class="fmrb-sig"><code>set_enabled(<a href="../Symbol/">Symbol</a> id, bool flag) -&gt; void</code></pre>

Enable or disable a widget

A disabled widget ignores clicks and draws its text dimmed.
```ruby
@ui.set_enabled(:export, false)
```

### FmrbUI#set_visible

<pre class="fmrb-sig"><code>set_visible(<a href="../Symbol/">Symbol</a> id, bool flag) -&gt; void</code></pre>

Show or hide a widget

The area of a hidden widget is repainted with the background color.
```ruby
@ui.set_visible(:inst, false)
```

### FmrbUI#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> min, <a href="../Integer/">Integer</a> max) -&gt; void</code></pre>

Change a widget's range

**The two numbers mean different things.** A Stepper (and Enum) takes
`(min, max)`, a Scrollbar `(total, visible)`. The value is pulled inside
the new range. The same range does nothing, an unknown id does nothing
(it always returns nil), and other widgets ignore it.
```ruby
@ui.set_range(:track, 1, total)    # Stepper
@ui.set_range(:sb, @files.size, 8) # Scrollbar
```

### FmrbUI#direction

<pre class="fmrb-sig"><code>direction(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

Which way a scrollbar is held

-1 while held up, 1 held down, 0 when not held (and for an unknown id).
Read it after handle returns the id to drive the repeat.
```ruby
if @ui.handle(ev) == :sb
  d = @ui.direction(:sb)
  @scroll_hold = d
end
```

### FmrbUI#bg

<pre class="fmrb-sig"><code>bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

The colour behind the widgets

```ruby
c = @ui.bg
```

### FmrbUI#bg=

<pre class="fmrb-sig"><code>bg=(<a href="../Integer/">Integer</a> c) -&gt; void</code></pre>

Change the colour behind the widgets

Changes what **widgets made afterwards, and the hole left by a hidden one**,
are painted with, and **the widgets that already exist too**: each one whose
colour was copied from here when it was made takes the new one and is
redrawn at the next flush. A widget given its own colour with its `bg=`
keeps it. The colour counts as the app's own and does not turn back into
the theme's after a move to another machine. The ground outside the
widgets is the app's to repaint.
```ruby
@ui.bg = @bg_col
@ui.flush
```

### FmrbUI#widgets

<pre class="fmrb-sig"><code>widgets() -&gt; <a href="../Array/">Array</a>[<a href="../FmrbUI__Widget/">FmrbUI::Widget</a>]</code></pre>

The widgets placed so far

```ruby
@ui.widgets.length
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
