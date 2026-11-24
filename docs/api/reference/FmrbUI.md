# FmrbUI

Widget container

## Class methods

### FmrbUI.new

```ruby
new(FmrbApp app) -> FmrbUI
```

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

```ruby
label(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?align: Symbol, ?text_size: Integer) -> FmrbUI::Label
```

Place a text label

align: chooses the alignment (:left / :center / :right, default :left).
text_size: enlarges this one widget's text (1-4); useful for a heading.
```ruby
@ui.label(:l_size, 4, 148, 60, 10,
          "Size")
```

### FmrbUI#button

```ruby
button(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?text_size: Integer, ?accent: Integer) -> FmrbUI::Button
```

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

```ruby
toggle(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?group: Symbol, ?on: bool, ?on_text: String, ?text_size: Integer, ?accent: Integer) -> FmrbUI::Toggle
```

Place an on/off toggle

Toggles sharing a group: name behave as radio buttons - only one is on.
on: true starts it on; on_text: gives it a different label when on.

### FmrbUI#stepper

```ruby
stepper(Symbol id, Integer x, Integer y, Integer w, Integer h, Integer value, Integer min, Integer max, ?Integer step, ?text_size: Integer) -> FmrbUI::Stepper
```

Place a value stepper

A "< value >" control. handle returns the id for either side, the value
stops at min / max, and pressing at the end returns nothing. An optional
last argument sets the step (default 1).

### FmrbUI#enum

```ruby
enum(Symbol id, Integer x, Integer y, Integer w, Integer h, Array[String] options) -> FmrbUI::Enum
```

Place a choice picker

A "< choice >" control over options. value is the chosen index and
option_text the string. It stops at the ends rather than wrapping, and
builds no string when moved, which makes it lighter than a Stepper.

### FmrbUI#option_text

```ruby
option_text(Symbol id) -> String?
```

The chosen string

What the Enum is showing. Its index is read with value.
```ruby
name = @ui.option_text(:mode)
```

### FmrbUI#text_field

```ruby
text_field(Symbol id, Integer x, Integer y, Integer w, Integer h, ?String text, ?max: Integer, ?text_size: Integer) -> FmrbUI::TextField
```

Place a one-line text field

Click to focus; keys go to whichever field has the focus. Enter makes
handle report the id, Escape drops the focus. The caret does not blink
(blinking would mean drawing every frame) and there are no arrow keys:
characters go on the end and backspace takes from the end.

### FmrbUI#field_text

```ruby
field_text(Symbol id) -> String?
```

What has been typed

```ruby
name = @ui.field_text(:name)
```

### FmrbUI#set_field_text

```ruby
set_field_text(Symbol id, String text) -> void
```

Replace what is in the field

```ruby
@ui.set_field_text(:name, "untitled")
```

### FmrbUI#focus

```ruby
focus(Symbol id) -> void
```

Give a widget the focus

nil takes the focus away, and so does anything that is not a text field.
```ruby
@ui.focus(:name)
@ui.focus(nil)
```

### FmrbUI#focused

```ruby
focused() -> Symbol?
```

Which widget has the focus

```ruby
return if @ui.focused == :name
```

### FmrbUI#handle

```ruby
handle(Hash[Symbol, untyped] ev) -> Symbol?
```

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

```ruby
flush() -> bool
```

Draw the changed widgets

Calls present once when anything was drawn and returns true; returns
false without drawing when nothing changed. Call it after drawing your
own picture so present happens only once.
```ruby
draw_picture
@gfx.present unless @ui.flush
```

### FmrbUI#invalidate_all

```ruby
invalidate_all() -> void
```

Mark every widget for redraw

Call it after clear_user_area or a resize.
```ruby
clear_user_area
@ui.invalidate_all
@ui.flush
```

### FmrbUI#find

```ruby
find(Symbol id) -> FmrbUI::Widget?
```

Find a widget by id

nil when there is none.
```ruby
w = @ui.find(:ok)
w.place(x, y, 60, 20) if w
```

### FmrbUI#move

```ruby
move(Symbol id, Integer x, Integer y, Integer w, Integer h) -> void
```

Move and resize a widget

Coordinates are user-area relative, as at creation time.
```ruby
@ui.move(:ok, 4, 60, 50, 16)
```

### FmrbUI#on?

```ruby
on?(Symbol id) -> bool
```

Whether the toggle is on

```ruby
save_backup if @ui.on?(:backup)
```

### FmrbUI#set_on

```ruby
set_on(Symbol id, bool on) -> void
```

Set a toggle from the app

For a grouped toggle, switching it on switches the rest of the group off.
```ruby
@ui.set_on(:on, true)
```

### FmrbUI#set_text

```ruby
set_text(Symbol id, String text) -> void
```

Change a widget's text

Does nothing when the text is unchanged; it re-measures and redraws only
when it actually changed.
```ruby
@ui.set_text(:near, "Back")
```

### FmrbUI#set_value

```ruby
set_value(Symbol id, Integer value) -> bool
```

Set a stepper value from the app

Clamped to min / max. Returns true only when the value actually changed.
```ruby
@ui.set_value(:sb, 3)
```

### FmrbUI#value

```ruby
value(Symbol id) -> Integer
```

Read the current stepper value

```ruby
n = @ui.value(:speed)
```

### FmrbUI#set_enabled

```ruby
set_enabled(Symbol id, bool flag) -> void
```

Enable or disable a widget

A disabled widget ignores clicks and draws its text dimmed.
```ruby
@ui.set_enabled(:export, false)
```

### FmrbUI#set_visible

```ruby
set_visible(Symbol id, bool flag) -> void
```

Show or hide a widget

The area of a hidden widget is repainted with the background color.
```ruby
@ui.set_visible(:inst, false)
```

### FmrbUI#widgets

```ruby
widgets() -> Array[FmrbUI::Widget]
```

The widgets placed so far

```ruby
@ui.widgets.length
```

---

*This page is generated from the API signatures of Family mruby (`sig/`) (fmruby-core api-site 45b8559c).*
