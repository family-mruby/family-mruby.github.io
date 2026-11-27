# FmrbGfx

A canvas: shapes, text, images, sprites

How to use it: [Drawing](../fmrb_gfx.md).

An app does not make one; it uses the `gfx` (`@gfx`) that `FmrbApp`
prepares. The origin (0, 0) is the top-left of the area the app owns, and
colours are RGB332 numbers (`FmrbGfx::RED` and so on). The drawing
methods return the canvas itself, so calls chain. **Drawing alone shows nothing**:
call `present` once at the end of a frame.

Methods to read first: `clear`, `fill_rect`, `draw_text`, `draw_image`,
`present`.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`FONT_METRICS`</span> | `Hash[Array[untyped], font_metrics]` | Character widths and line height of each font |
| <span class="fmrb-name">`BLACK`</span> | [`Integer`](Integer.md) | black (RGB332) |
| <span class="fmrb-name">`WHITE`</span> | [`Integer`](Integer.md) | white (RGB332) |
| <span class="fmrb-name">`RED`</span> | [`Integer`](Integer.md) | red (RGB332) |
| <span class="fmrb-name">`GREEN`</span> | [`Integer`](Integer.md) | green (RGB332) |
| <span class="fmrb-name">`BLUE`</span> | [`Integer`](Integer.md) | blue (RGB332) |
| <span class="fmrb-name">`YELLOW`</span> | [`Integer`](Integer.md) | yellow (RGB332) |
| <span class="fmrb-name">`CYAN`</span> | [`Integer`](Integer.md) | cyan (RGB332) |
| <span class="fmrb-name">`MAGENTA`</span> | [`Integer`](Integer.md) | magenta (RGB332) |
| <span class="fmrb-name">`GRAY`</span> | [`Integer`](Integer.md) | gray (RGB332) |
| <span class="fmrb-name">`COLOR_BLACK`</span> | [`Integer`](Integer.md) | black (RGB332) |
| <span class="fmrb-name">`COLOR_WHITE`</span> | [`Integer`](Integer.md) | white (RGB332) |
| <span class="fmrb-name">`COLOR_RED`</span> | [`Integer`](Integer.md) | red (RGB332) |
| <span class="fmrb-name">`COLOR_GREEN`</span> | [`Integer`](Integer.md) | green (RGB332) |
| <span class="fmrb-name">`COLOR_BLUE`</span> | [`Integer`](Integer.md) | blue (RGB332) |
| <span class="fmrb-name">`COLOR_YELLOW`</span> | [`Integer`](Integer.md) | yellow (RGB332) |
| <span class="fmrb-name">`COLOR_CYAN`</span> | [`Integer`](Integer.md) | cyan (RGB332) |
| <span class="fmrb-name">`COLOR_MAGENTA`</span> | [`Integer`](Integer.md) | magenta (RGB332) |
| <span class="fmrb-name">`COLOR_GRAY`</span> | [`Integer`](Integer.md) | gray (RGB332) |
| <span class="fmrb-name">`BLEND_ADD`</span> | [`Integer`](Integer.md) | additive blend (for blend_rect) |
| <span class="fmrb-name">`BLEND_XOR`</span> | [`Integer`](Integer.md) | XOR blend (for blend_rect) |

## Types

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`image_info`</span> | `{ id: uint16, width: uint16, height: uint16 }` | An image's number and size, from create_image |
| <span class="fmrb-name">`file_info`</span> | `{ exists: bool, size: uint32 }` | A file on the graphics side, from file_status |
| <span class="fmrb-name">`composite_region`</span> | `{ src_x: int16, src_y: int16, dst_x: int16, dst_y: int16, w: int16, h: int16, transparent: bool }` | One composited rectangle |
| <span class="fmrb-name">`video_info`</span> | `{ width: uint16, height: uint16 }` | A video's size, from video_open_raw |
| <span class="fmrb-name">`video_status`</span> | `{ state: uint8, shown: uint32, dropped: uint32 }` | The video player's state |
| <span class="fmrb-name">`picture_info`</span> | `{ width: uint16, height: uint16, format: uint8, bytes: uint32, mtime: uint32 }` | A picture file's size and kind, from picture_info |
| <span class="fmrb-name">`font_metrics`</span> | `{ char_w: Integer, half_w: Integer, kana_w: Integer, line_h: Integer }` | One font's sizes in pixels, in FONT_METRICS |

## Class methods

### FmrbGfx.rgb_to_332

<pre class="fmrb-sig"><code>rgb_to_332(<a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> g, <a href="../Integer/">Integer</a> b) -&gt; <a href="../Integer/">Integer</a></code></pre>

Make a colour from red, green and blue

Packs three 0-255 values into one byte: three bits of red, three of green,
two of blue, so nearby colours collapse onto the same value and fine
gradients do not survive.

Avoid combinations that come out as 0x01. The desktop uses 0x01 as its
transparency key, so a window painted with it shows through.
```ruby
FmrbGfx.rgb_to_332(255, 0, 0)  #=> 224
```

### FmrbGfx.video_control

<pre class="fmrb-sig"><code>video_control(:play | :pause | :stop | :rewind action) -&gt; video_status?</code></pre>

Play, pause, stop or rewind the video

There is one player. Acts on the video video_open opened and returns its state afterwards (nil
when there is no answer). :stop closes the file; the canvas keeps the last
picture. The wrappers are FmrbVideo's play, pause, stop and rewind.
```ruby
FmrbGfx.video_control(:play)
```

### FmrbGfx.video_status

<pre class="fmrb-sig"><code>video_status() -&gt; video_status?</code></pre>

The video player's state

{state:, shown:, dropped:}, or nil when there is no answer. state is 0
idle, 1 playing, 2 paused, 3 finished; shown and dropped count frames.
The wrapper is FmrbVideo#status.
```ruby
st = FmrbGfx.video_status
```

### FmrbGfx.hsv_to_rgb

<pre class="fmrb-sig"><code>hsv_to_rgb(<a href="../Integer/">Integer</a> h, <a href="../Integer/">Integer</a> s, <a href="../Integer/">Integer</a> v) -&gt; <a href="../Array/">Array</a></code></pre>

Make a colour from hue, saturation and value

h is 0-360, s and v are 0-255. It returns [r, g, b], which is not a colour
yet -- pass it through rgb_to_332.

```ruby
r, g, b = FmrbGfx.hsv_to_rgb(hue, 255, 255)
color = FmrbGfx.rgb_to_332(r, g, b)
```

## Instance methods

### FmrbGfx#canvas_id

<pre class="fmrb-sig"><code>canvas_id() -&gt; <a href="../Integer/">Integer</a></code></pre>

The canvas number

```ruby
id = gfx.canvas_id
```

### FmrbGfx#canvas_width

<pre class="fmrb-sig"><code>canvas_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Canvas width in pixels

The width of the whole canvas. A windowed app may only draw inside its
area (area_width, the same as @user_area_width), which is not the same
thing; for a fullscreen app the two agree.
```ruby
w = @gfx.canvas_width
```

### FmrbGfx#area_width

<pre class="fmrb-sig"><code>area_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Width of the area drawn in

How far from the origin there is to draw in. For the app's gfx it is
@user_area_width.
```ruby
w = @gfx.area_width
```

### FmrbGfx#area_height

<pre class="fmrb-sig"><code>area_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Height of the area drawn in

How far from the origin there is to draw down. The pair of `area_width`; for the app's gfx it is @user_area_height.
```ruby
@gfx.fill_rect(0, 0, @gfx.area_width,
                @gfx.area_height, 0)
```

### FmrbGfx#origin_x

<pre class="fmrb-sig"><code>origin_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where the origin is on the canvas (x)

Every coordinate drawn is added to it on its way to the canvas (the
firmware adds it): 1 for a framed window's gfx, 0 for window_gfx and the
rest. While drawing into a sprite image it is not added to what is drawn,
but it still is to sprite coordinates (set_sprite_clip, SpriteInstance).
```ruby
FmrbApp.set_text_cursor(
  @gfx.origin_x + x,
  @gfx.origin_y + y, 12)
```

### FmrbGfx#origin_y

<pre class="fmrb-sig"><code>origin_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Where the origin is on the canvas (y)

The vertical pair of `origin_x`: the y of the origin that is added to every coordinate on its way to the canvas. 1 for a framed window's gfx, 0 for window_gfx and the rest.
```ruby
FmrbApp.set_text_cursor(
  @gfx.origin_x + x,
  @gfx.origin_y + y, 12)
```

### FmrbGfx#canvas_height

<pre class="fmrb-sig"><code>canvas_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Canvas height in pixels

```ruby
h = gfx.canvas_height
```

### FmrbGfx#current_font

<pre class="fmrb-sig"><code>current_font() -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

The font in use now

The `[family, size]` array `set_font` actually chose (`[:default]` for
`:default`). It is the key of `FmrbGfx::FONT_METRICS`.
```ruby
saved = gfx.current_font
gfx.set_font(:ja)
gfx.set_font(*saved)
```

### FmrbGfx#current_text_size

<pre class="fmrb-sig"><code>current_text_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

The text scale in use now

```ruby
n = gfx.current_text_size
```

### FmrbGfx#clear

<pre class="fmrb-sig"><code>clear(<a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

Paint the whole canvas one colour

Fills the whole canvas. In a windowed app that erases the title bar and
frame the app drew itself; to clear only the inside of the window use
FmrbApp#clear_user_area, which redraws the frame and marks any attached
FmrbUI widgets for redraw.

For a fullscreen app clear is the right call, and faster than a fill_rect
over the same area.
```ruby
@gfx.clear(FmrbGfx::BLACK)
@gfx.present
```

### FmrbGfx#set_pixel

<pre class="fmrb-sig"><code>set_pixel(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

Set one pixel

```ruby
gfx.set_pixel(10, 20,
              FmrbGfx::WHITE)
```

### FmrbGfx#get_pixel

<pre class="fmrb-sig"><code>get_pixel(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read one pixel's colour

A synchronous round trip to the graphics side. Not something to do per
pixel in a loop scanning the screen.

Outside the canvas it returns 0, which is also black -- the return value
does not tell the two apart.
```ruby
c = @gfx.get_pixel(60, 40)
# 0 outside the canvas
```

### FmrbGfx#draw_line

<pre class="fmrb-sig"><code>draw_line(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw a straight line

```ruby
gfx.draw_line(0, 0, 100, 60,
              FmrbGfx::WHITE)
```

### FmrbGfx#draw_thick_line

<pre class="fmrb-sig"><code>draw_thick_line(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> thickness,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw a line with a thickness

The graphics side has no thick-line primitive, so this stacks thickness
one-pixel lines side by side. The cost grows with the thickness, which
shows if thick lines are drawn every frame.
```ruby
@gfx.draw_thick_line(10, 10, 60, 40,
                    2, FmrbGfx::WHITE)
```

### FmrbGfx#draw_rect

<pre class="fmrb-sig"><code>draw_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw the outline of a rectangle

(x, y) is the top-left corner, w the width, h the height. It draws the
outline only, so whatever is underneath stays visible inside. Use
`fill_rect` to colour the inside too.

```ruby
gfx.draw_rect(10, 10, 100, 50,
              FmrbGfx::WHITE)  # frame
gfx.fill_rect(12, 12, 96, 46,
              FmrbGfx::BLUE)   # inside
gfx.present
```

### FmrbGfx#fill_rect

<pre class="fmrb-sig"><code>fill_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Fill a rectangle

(x, y) is the top-left corner, w the width, h the height, and the inside
is filled. To wipe the whole canvas, `clear` is faster.

For something that moves,
**paint over where it was in the background colour first**,
then draw it at the new place, and it leaves no trail.

```ruby
class MyApp < FmrbApp
  def on_update
    # erase the old place
    gfx.fill_rect(@x, 100, 16, 16,
                  FmrbGfx::BLACK)
    @x = @x + 2
    # draw at the new one
    gfx.fill_rect(@x, 100, 16, 16,
                  FmrbGfx::RED)
    gfx.present
  end
end
```

### FmrbGfx#blend_rect

<pre class="fmrb-sig"><code>blend_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> mode
) -&gt; FmrbGfx</code></pre>

Fill a rectangle blended with what is under it

The last argument is the blend mode -- FmrbGfx::BLEND_ADD or
FmrbGfx::BLEND_XOR -- not an opacity. Additive reads as a glow; XOR
inverts what is underneath.

```ruby
gfx.fill_rect(0, 0, 64, 64, FmrbGfx::BLUE)
gfx.blend_rect(16, 16, 32, 32,
               FmrbGfx::RED, FmrbGfx::BLEND_ADD)
```

### FmrbGfx#draw_round_rect

<pre class="fmrb-sig"><code>draw_round_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> r,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw a rounded rectangle outline

```ruby
gfx.draw_round_rect(10, 10, 80, 40,
                    6, theme_fg)
```

### FmrbGfx#fill_round_rect

<pre class="fmrb-sig"><code>fill_round_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> r,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Fill a rounded rectangle

```ruby
gfx.fill_round_rect(10, 10, 80, 40,
                    6, theme_bg)
```

### FmrbGfx#draw_button

<pre class="fmrb-sig"><code>draw_button(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> label,
  <a href="../Integer/">Integer</a> fill,
  <a href="../Integer/">Integer</a> fg
) -&gt; FmrbGfx</code></pre>

Draw the picture of a rounded button

Fills it with fill and centres label in fg with the current font.
**Only the picture**: it has no click target. On a screen redrawn every time,
pair it with FmrbUI::HitAreas#add. An eighth argument sets the corner
radius (default 3).

```ruby
@gfx.draw_button(x, y, 60, 16, "OK",
  theme_accent, theme_fg_light)
@hits.add(:ok, x, y, 60, 16)
```

### FmrbGfx#draw_circle

<pre class="fmrb-sig"><code>draw_circle(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

Draw a circle outline

```ruby
gfx.draw_circle(50, 30, 20,
                FmrbGfx::WHITE)
```

### FmrbGfx#fill_circle

<pre class="fmrb-sig"><code>fill_circle(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

Fill a circle

```ruby
gfx.fill_circle(50, 30, 20,
                FmrbGfx::YELLOW)
```

### FmrbGfx#draw_ellipse

<pre class="fmrb-sig"><code>draw_ellipse(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> rx,
  <a href="../Integer/">Integer</a> ry,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw an ellipse outline

```ruby
gfx.draw_ellipse(50, 30, 30, 15,
                 FmrbGfx::WHITE)
```

### FmrbGfx#fill_ellipse

<pre class="fmrb-sig"><code>fill_ellipse(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> rx,
  <a href="../Integer/">Integer</a> ry,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Fill an ellipse

```ruby
gfx.fill_ellipse(50, 30, 30, 15,
                 FmrbGfx::CYAN)
```

### FmrbGfx#draw_triangle

<pre class="fmrb-sig"><code>draw_triangle(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> x2,
  <a href="../Integer/">Integer</a> y2,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw a triangle outline

```ruby
gfx.draw_triangle(50, 10, 20, 50,
                  80, 50,
                  FmrbGfx::WHITE)
```

### FmrbGfx#fill_triangle

<pre class="fmrb-sig"><code>fill_triangle(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> x2,
  <a href="../Integer/">Integer</a> y2,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Fill a triangle

```ruby
gfx.fill_triangle(50, 10, 20, 50,
                  80, 50,
                  FmrbGfx::GREEN)
```

### FmrbGfx#draw_arc

<pre class="fmrb-sig"><code>draw_arc(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> r0,
  <a href="../Integer/">Integer</a> r1,
  <a href="../Integer/">Integer</a> angle0,
  <a href="../Integer/">Integer</a> angle1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Draw an arc

Angles are integer degrees. r0 is the inner radius and r1 the outer one,
so a non-zero r0 gives part of a ring; r0 of 0 gives the outline of a
pie slice.
```ruby
@gfx.draw_arc(80, 60, 35, 45, 0, 360,
              FmrbGfx::WHITE)
```

### FmrbGfx#fill_arc

<pre class="fmrb-sig"><code>fill_arc(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> r0,
  <a href="../Integer/">Integer</a> r1,
  <a href="../Integer/">Integer</a> angle0,
  <a href="../Integer/">Integer</a> angle1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

Fill a wedge of a circle

Angles are integer degrees. r0 is the inner radius and r1 the outer one:
r0 of 0 fills a pie slice, a non-zero r0 fills part of a ring -- which is
how a gauge or a pie chart is drawn.
```ruby
@gfx.fill_arc(80, 60, 0, 50, 0, 120,
             FmrbGfx::BLUE)
```

### FmrbGfx#draw_text

<pre class="fmrb-sig"><code>draw_text(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> color,
  ?<a href="../Integer/">Integer</a>? bg_color,
  ?mixed: bool
) -&gt; FmrbGfx</code></pre>

draw a string

(x, y) is the **top-left** corner of the string. The screen's top-left is
(0, 0): x grows to the right and y grows downwards.
color is an RGB332 value -- a named one such as `FmrbGfx::WHITE`, or any
colour made with `FmrbGfx.rgb_to_332(255, 0, 0)`.

Nothing appears on the screen until `present` is called.
A fifth argument paints the background of the characters in that colour
(none when left out). `mixed: true` draws ASCII with the 6x8 font and
Japanese with the 8x8 one, whatever font is selected.

```ruby
class MyApp < FmrbApp
  def on_update
    gfx.clear(FmrbGfx::BLACK)
    gfx.draw_text(10, 20, "hello", FmrbGfx::WHITE)
    gfx.present
  end
end
```

### FmrbGfx#draw_text_raw

<pre class="fmrb-sig"><code>draw_text_raw(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color,
  bool mixed
) -&gt; FmrbGfx</code></pre>

draw_text with nothing left out

The simple form, with no argument left out, for where speed matters
(drawing many times a frame). A negative bg_color leaves the background
alone; mixed true draws ASCII in 6x8 and the rest in misaki 8 (draw_text's
mixed: true). The wrapper is draw_text.
```ruby
gfx.draw_text_raw(10, 20, "hi",
  FmrbGfx::WHITE, -1, false)
```

### FmrbGfx#set_font

<pre class="fmrb-sig"><code>set_font(<a href="../Symbol/">Symbol</a> family, ?<a href="../Integer/">Integer</a> size) -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

Choose the font and size

family is :default (6x8 ASCII), :ja (Japanese) or :ja_bold (:ja in bold).
size is the height in pixels: 8, 12 and 16 for :ja, 12 for :ja_bold.
Which faces exist differs by machine (Retro stops at 12), so asking for a
size or a weight it has not got gets you the nearest one. What comes back
is the [family, size] actually chosen -- which is also how you find out
that bold was unavailable and you should thicken the text yourself.
```ruby
got = gfx.set_font(:ja, 12)
```

### FmrbGfx#set_font_raw

<pre class="fmrb-sig"><code>set_font_raw(:default | :ja | :ja_bold family, <a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

set_font with nothing left out

The simple form, with no argument left out. It does not pick the nearest
face this machine has, so a size it lacks is an error (:ja takes 8, 12
and 16, :ja_bold 12; :default ignores size). current_font is left as it
is. The wrapper is set_font.
```ruby
gfx.set_font_raw(:ja, 12)
```

### FmrbGfx#set_text_size

<pre class="fmrb-sig"><code>set_text_size(<a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

Set the text scale

Scales the selected font by an integer factor. It is the same glyphs
enlarged, so the edges get blocky. text_width reports the width after the
multiplier.
```ruby
@gfx.set_text_size(2)
@gfx.draw_text(4, 4, "BIG", 0xFF)
@gfx.set_text_size(1)
```

### FmrbGfx#set_text_size_raw

<pre class="fmrb-sig"><code>set_text_size_raw(<a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

set_text_size without the wrapper

Only sends the scale (1 to 4) to the graphics side; current_text_size and
what text_width measures stay as they were. The wrapper is set_text_size.
```ruby
gfx.set_text_size_raw(2)
```

### FmrbGfx#text_width

<pre class="fmrb-sig"><code>text_width(<a href="../String/">String</a> text) -&gt; <a href="../Integer/">Integer</a></code></pre>

Measure how wide text would be

Measured with the font set_font selected and the multiplier set_text_size
set, so measure again after changing either. It walks the UTF-8, so a
mixed Japanese and ASCII string gives a real pixel width rather than a
character count.

```ruby
w = gfx.text_width(text)
x = (gfx.area_width - w) / 2
gfx.draw_text(x, 20, text, FmrbGfx::WHITE)
```

### FmrbGfx#font_height

<pre class="fmrb-sig"><code>font_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

The height of one line

The height of the font currently selected -- the spacing to use when
stacking lines. It changes with the font.
```ruby
y += @gfx.font_height + 2
```

### FmrbGfx#draw_wallclock

<pre class="fmrb-sig"><code>draw_wallclock(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color
) -&gt; bool</code></pre>

Draw the time now

The time is formatted inside the call, so calling it every second
allocates nothing. A negative bg_color leaves the background as it is.
```ruby
gfx.draw_wallclock(300, 2,
                   theme_fg, theme_bg)
```

### FmrbGfx#draw_free_iram

<pre class="fmrb-sig"><code>draw_free_iram(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color
) -&gt; bool</code></pre>

Draw how much memory is free

Fetching and formatting both happen inside. Where no figure can be
read, it draws dashes. A negative bg_color leaves the background as it is.
```ruby
gfx.draw_free_iram(360, 2,
                   theme_fg, theme_bg)
```

### FmrbGfx#load_image

<pre class="fmrb-sig"><code>load_image(<a href="../String/">String</a> path) -&gt; void</code></pre>

Load an image file and place it

Does sync_file, create_image, draw_image, present and delete_image in one
call -- enough when a picture just has to appear.

coord: takes [x, y] or :center; left out, it draws at the top left. Not
something to call every frame: it builds and throws away the image each
time.

```ruby
gfx.load_image("/home/pic.png", coord: :center)
```

### FmrbGfx#create_image

<pre class="fmrb-sig"><code>create_image(<a href="../String/">String</a> path) -&gt; image_info?</code></pre>

Make an image from a file

Takes a PNG. Sprite artwork (an RGB332 PNG or BMP) goes through
SpriteImage#load_bmp instead. Handing a BMP to this does not raise: you
get an empty screen-sized image and nothing appears.

The graphics side reads its own filesystem, so send the file with
sync_file first. Returns {id:, width:, height:}, or nil when it could not
be read.

```ruby
path = "/home/pic.png"
gfx.sync_file(path)
img = gfx.create_image(path)
gfx.draw_image(img[:id], x: 0, y: 0) if img
```

### FmrbGfx#draw_image

<pre class="fmrb-sig"><code>draw_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

Draw an image you made

Position and scale are keyword arguments (x:, y:, scale_x:, scale_y:).
A scale_y of 0.0 means "the same as scale_x".

```ruby
gfx.draw_image(id, x: 10, y: 20)
gfx.draw_image(id, x: 10, y: 20,
               scale_x: 2.0)   # both axes doubled
```

### FmrbGfx#draw_image_raw

<pre class="fmrb-sig"><code>draw_image_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Float/">Float</a> scale_x,
  <a href="../Float/">Float</a> scale_y
) -&gt; FmrbGfx</code></pre>

draw_image with nothing left out

The simple form, with no argument left out. A scale_y of 0.0 means the
same as scale_x. The wrapper is draw_image.
```ruby
gfx.draw_image_raw(id, 10, 20,
                   1.0, 0.0)
```

### FmrbGfx#delete_image

<pre class="fmrb-sig"><code>delete_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

Let go of an image you made

An image is a resource on the graphics side, and there is a limited
number of them, so release one when it is done with. The system reclaims
them when the app exits, so a missing cleanup at exit does not leak.
```ruby
@gfx.delete_image(@image[:id])
```

### FmrbGfx#draw_tile

<pre class="fmrb-sig"><code>draw_tile(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h
) -&gt; FmrbGfx</code></pre>

Draw one piece cut out of an image

Stamps part of a SpriteImage straight onto the canvas. No SpriteInstance
is created, which suits the things that do not move -- terrain, a
background. The destination is passed by keyword (dst_x:, dst_y:).

A SpriteImage made with use_transparent: true keeps its transparent
colour transparent here. TileMap is the higher-level way to lay a whole
map out.

scale: draws it at another size. 2 to 32 turns each pixel into a
scale x scale block (scale: 2 is twice the size); -2 to -32 draws
1/|scale| of it (scale: -4 is a quarter, taking the top-left pixel of
each block). It goes through draw_tile_scaled_raw.

```ruby
sheet.load_bmp("/cache/app/x/tiles.png")
gfx.draw_tile(sheet.id, 0, 0, 16, 16,
              dst_x: 32, dst_y: 16)
gfx.draw_tile(sheet.id, 0, 0, 16, 16,
  dst_x: 0, dst_y: 40, scale: 3)
```

### FmrbGfx#draw_tile_raw

<pre class="fmrb-sig"><code>draw_tile_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> dst_x,
  <a href="../Integer/">Integer</a> dst_y
) -&gt; FmrbGfx</code></pre>

draw_tile with nothing left out

The destination as plain arguments rather than keywords. The wrapper is
draw_tile.
```ruby
gfx.draw_tile_raw(sheet.id, 0, 0,
                  16, 16, 32, 16)
```

### FmrbGfx#draw_tile_scaled_raw

<pre class="fmrb-sig"><code>draw_tile_scaled_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> dst_x,
  <a href="../Integer/">Integer</a> dst_y,
  <a href="../Integer/">Integer</a> scale,
  <a href="../Integer/">Integer</a> clip_x,
  <a href="../Integer/">Integer</a> clip_y,
  <a href="../Integer/">Integer</a> clip_w,
  <a href="../Integer/">Integer</a> clip_h
) -&gt; FmrbGfx</code></pre>

draw_tile drawn larger or smaller

A scale of 1 to 32 turns each pixel into a scale x scale block; -2 to -32
draws 1/|scale| of the size (the top-left pixel of each block; 0 and -1
are 1). Out of range is ERR_ARG. The destination is cut to the clip rect
(from the origin; none when clip_w or clip_h is 0) and to the canvas. The
transparent colour is skipped as in draw_tile. The wrapper is draw_tile's
scale:.
```ruby
gfx.draw_tile_scaled_raw(id, 0, 0,
  16, 16, 40, 20, 2, 0, 0, 0, 0)
```

### FmrbGfx#picture_info

<pre class="fmrb-sig"><code>picture_info(<a href="../String/">String</a> path) -&gt; picture_info?</code></pre>

Read a picture file's width and height

Reads only the head of a PNG or an 8-bit BMP; nothing is decoded (the
same C as BMP332.info). The result is {width:, height:, format:, bytes:,
mtime:}: format is 1 for PNG, 2 for BMP; bytes is the file's size and
mtime when it was written (0 on a file system that keeps no time). nil
when it is not there or cannot be read. The file is the app's own (it
need not have been sent to the display side).
```ruby
info = gfx.picture_info("/home/a.png")
w = info[:width] if info
```

### FmrbGfx#draw_picture

<pre class="fmrb-sig"><code>draw_picture(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

Draw a picture file, reading it in the first time

Just hand the path (or put_picture's name). A picture is read into a
sprite image on the display side the first time; this FmrbGfx keeps up
to picture_limit of them (8 unless set), letting the least recently
drawn go first. A file written again (another size or time) is read
again the next time it is drawn (looked at once a second at most). They
all go when the app ends.

- scale: 1 to 32 turns each pixel into scale x scale; -2 to -32 draws
  1/|scale| of the size
- checker: true lays the checkerboard under the transparent parts
  (draw_checker)
- clip: [x, y, w, h] draws only inside that rect

false when it cannot be drawn (nothing raises); picture_error says why.
A picture past 65,536 pixels is refused. A file past 65,536 bytes is
read on the app side (BMP332.load: in the VM pool while it is read) and
its pixels put. Transparent is the colour 0x01 (a PNG's alpha and tRNS).
```ruby
gfx.draw_picture("/home/stamps/a.png",
  10, 20, scale: 2)
gfx.draw_picture(path, 0, 0,
  scale: -2, checker: true)
```

### FmrbGfx#picture_size

<pre class="fmrb-sig"><code>picture_size(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]?</code></pre>

A picture's width and height, as [w, h]

From the store when the picture is there, else from the file's head
(picture_info); nothing goes to the display side. nil when it is not a
picture.
```ruby
w, h = gfx.picture_size("/home/a.png")
```

### FmrbGfx#put_picture

<pre class="fmrb-sig"><code>put_picture(
  <a href="../String/">String</a> name,
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../String/">String</a> pixels
) -&gt; bool</code></pre>

Put RGB332 pixels in the picture store by name

pixels is width x height bytes, top row first; 0x01 is transparent.
Draw it with draw_picture(name, ...). Putting the same name again
writes the pixels again. No file is involved. false when there is no
room.
```ruby
gfx.put_picture("mine", 16, 16, px)
gfx.draw_picture("mine", 0, 0,
  scale: 4)
```

### FmrbGfx#release_picture

<pre class="fmrb-sig"><code>release_picture(<a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

Let go of one picture in the picture store

```ruby
gfx.release_picture("/home/a.png")
```

### FmrbGfx#release_pictures

<pre class="fmrb-sig"><code>release_pictures() -&gt; FmrbGfx</code></pre>

Let go of every picture in the picture store

Not needed when the app ends (the pictures go with the canvas). For
letting go of pictures no longer drawn, all at once.
```ruby
gfx.release_pictures
```

### FmrbGfx#picture_limit=

<pre class="fmrb-sig"><code>picture_limit=(<a href="../Integer/">Integer</a> n) -&gt; <a href="../Integer/">Integer</a></code></pre>

How many pictures the picture store keeps

8 unless set; fewer lets the oldest go now. The display side's sprite
images are limited for the whole machine (64 and 256 KB on the sim and
Retro, 160 on P4).
```ruby
gfx.picture_limit = 16
```

### FmrbGfx#picture_error

<pre class="fmrb-sig"><code>picture_error() -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

Why the last picture could not be drawn

:unreadable (not there, not a picture), :too_big (past 65,536 pixels),
:no_room (no room on the display side), :not_sent (could not be sent
there). nil after one that worked.
```ruby
unless gfx.draw_picture(path, 0, 0)
  Log.info(gfx.picture_error.to_s)
end
```

### FmrbGfx#draw_checker

<pre class="fmrb-sig"><code>draw_checker(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; FmrbGfx</code></pre>

Draw the checkerboard that stands for transparency

White and light grey cells (cell: px, 4 unless given) over
(x, y, w, h); clip: [x, y, w, h] cuts it. One strip is made on the
display side and stamped, height / (cell x 2) commands.
```ruby
gfx.draw_checker(0, 0, 64, 64)
gfx.draw_checker(0, 0, 64, 64,
  cell: 2)
```

### FmrbGfx#create_mask

<pre class="fmrb-sig"><code>create_mask(<a href="../Integer/">Integer</a> width, <a href="../Integer/">Integer</a> height, bin data) -&gt; <a href="../Integer/">Integer</a></code></pre>

Make a mask

data is one bit per pixel: ceil(width / 8) bytes per row, most significant
bit leftmost. Only the pixels whose bit is set are drawn.

Returns a mask_id for draw_image_masked; release it with delete_mask.
```ruby
mask = @gfx.create_mask(48, 48, bits)
# bits: 6 bytes x 48 rows
```

### FmrbGfx#delete_mask

<pre class="fmrb-sig"><code>delete_mask(<a href="../Integer/">Integer</a> mask_id) -&gt; FmrbGfx</code></pre>

Let go of a mask

```ruby
gfx.delete_mask(@mask_id)
```

### FmrbGfx#draw_image_masked

<pre class="fmrb-sig"><code>draw_image_masked(<a href="../Integer/">Integer</a> image_id, <a href="../Integer/">Integer</a> mask_id) -&gt; FmrbGfx</code></pre>

Draw an image through a mask

Copies a SpriteImage onto the canvas only where the mask's bits are set.
The position is passed by keyword (x:, y:): the image's (xx, yy) lands at
(x + xx, y + yy).
```ruby
@gfx.draw_image_masked(sid, mask,
                       x: 20, y: 30)
```

### FmrbGfx#draw_image_masked_raw

<pre class="fmrb-sig"><code>draw_image_masked_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> mask_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y
) -&gt; FmrbGfx</code></pre>

draw_image_masked, plain arguments

The position as plain arguments rather than keywords. The wrapper is
draw_image_masked.
```ruby
gfx.draw_image_masked_raw(img.id,
  @mask_id, 10, 20)
```

### FmrbGfx#present

<pre class="fmrb-sig"><code>present() -&gt; FmrbGfx</code></pre>

show what has been drawn

Drawing methods only queue commands; nothing reaches the screen until
present sends them. Sprite compositing also happens at present, so it is
needed after SpriteInstance#move or visible= as well.

Call it once at the end of a frame. Calling it after every shape costs a
whole-screen transfer each time.

```ruby
gfx.clear(FmrbGfx::BLACK)
gfx.draw_text(10, 10, "hi", FmrbGfx::WHITE)
gfx.present   # now it appears
```

### FmrbGfx#present_raw

<pre class="fmrb-sig"><code>present_raw(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, bool positioned) -&gt; FmrbGfx</code></pre>

present with nothing left out

With positioned false the canvas goes where the window is (x and y are
not used); with true it goes to (x, y) on the screen. The wrapper is
present (present(x, y) gives a position).
```ruby
gfx.present_raw(0, 0, false)
```

### FmrbGfx#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; FmrbGfx</code></pre>

Let go of this canvas

Throws away a canvas made by the app. They go on their own when the
app ends, so this is for one that is finished with early.
```ruby
g = create_canvas_gfx(width: 64,
                     height: 64)
g.destroy
```

### FmrbGfx#set_viewport

<pre class="fmrb-sig"><code>set_viewport(
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h
) -&gt; FmrbGfx</code></pre>

Shift what part of the canvas is shown

Moves a viewport smaller than the canvas across it. The canvas is treated
as a torus, so the source rectangle wraps at the edges: with a canvas a
little larger than the viewport, stamping only the newly exposed tiles as
it moves scrolls an arbitrarily large world without redrawing it.

Modern (ESP32-P4) only; the Retro backend ignores the command. Gate it on
FmrbConst::CHIP_MODEL == "ESP32-P4".
```ruby
@map_gfx.set_viewport(vx % bw, vy % bh,
                      160, 120)
```

### FmrbGfx#clear_viewport

<pre class="fmrb-sig"><code>clear_viewport() -&gt; FmrbGfx</code></pre>

Put the shown part back

Undo set_viewport: the whole canvas is composited again. Modern
(ESP32-P4) only, as set_viewport is.
```ruby
@map_gfx.set_viewport(8, 0, 160, 120)
@map_gfx.clear_viewport
```

### FmrbGfx#set_composite_regions

<pre class="fmrb-sig"><code>set_composite_regions(<a href="../Array/">Array</a>[<a href="../Hash/">Hash</a>] regions) -&gt; FmrbGfx</code></pre>

Set the regions that are composited

Says which rectangles of the canvas are composited and how. It is the
optimisation for a rounded window, where only the corners need
transparency and the middle can take the fast path. Eight at most; nil or
[] restores the default of the whole canvas.

For a windowed app the system sets this from rounded_corners in the
.app.toml, so calling it directly is rarely needed.
```ruby
@gfx.set_composite_regions([
  { dst_x: 0, dst_y: 0, w: 100,
    h: 20, transparent: false }
])
```

### FmrbGfx#set_composite_regions_raw

<pre class="fmrb-sig"><code>set_composite_regions_raw(<a href="../Array/">Array</a>[composite_region] regions) -&gt; FmrbGfx</code></pre>

set_composite_regions, every field given

Every field of each rectangle written out: src_x, src_y, dst_x, dst_y,
w, h and transparent. An empty array restores the default (the whole
canvas). The wrapper is set_composite_regions.
```ruby
gfx.set_composite_regions_raw([
  { src_x: 0, src_y: 0, dst_x: 0,
    dst_y: 0, w: 8, h: 8,
    transparent: true }])
```

### FmrbGfx#set_sprite_clip

<pre class="fmrb-sig"><code>set_sprite_clip(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; FmrbGfx</code></pre>

limit where sprites may appear

Sprites are composited on top of everything drawn into the canvas, so
without a clip they paint over the window frame and title bar. This
confines them to the given rect, in the same coordinates as
SpriteInstance#move (from the origin, also while drawing into a sprite
image).

Windowed apps start with their user area set, so calling this is only
needed to narrow it further - e.g. to keep sprites out of a score bar.
```ruby
# reserve the top 10px for the score; sprites stay below it
@gfx.set_sprite_clip(0, 10,
  @user_area_width,
  @user_area_height - 10)
```

### FmrbGfx#clear_sprite_clip

<pre class="fmrb-sig"><code>clear_sprite_clip() -&gt; FmrbGfx</code></pre>

let sprites use the whole canvas

```ruby
gfx.clear_sprite_clip
```

### FmrbGfx#create_sprite_image

<pre class="fmrb-sig"><code>create_sprite_image(
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../Integer/">Integer</a> transparent_color,
  bool use_transparent
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Make a sprite image

Makes a width x height image on the graphics side and returns its
number. With use_transparent,
the pixels of transparent_color are see-through. The wrapper is
SpriteImage.new.
```ruby
id = gfx.create_sprite_image(16, 16,
                             0x00, true)
```

### FmrbGfx#delete_sprite_image

<pre class="fmrb-sig"><code>delete_sprite_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

Let go of a sprite image

The wrapper is SpriteImage#destroy.
```ruby
gfx.delete_sprite_image(id)
```

### FmrbGfx#load_sprite_image

<pre class="fmrb-sig"><code>load_sprite_image(<a href="../Integer/">Integer</a> image_id, <a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

Read a PNG or BMP into a sprite image

Takes a path on the graphics side (send it there with sync_file first),
which decodes it. A PNG's transparent pixels (alpha below 128, tRNS)
become the transparent colour 0x01. The wrapper is SpriteImage#load_bmp.
```ruby
gfx.load_sprite_image(id,
  "/cache/app/x/bird.png")
```

### FmrbGfx#write_sprite_image

<pre class="fmrb-sig"><code>write_sprite_image(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  bin pixels
) -&gt; FmrbGfx</code></pre>

Write RGB332 pixels into a sprite image

pixels is w * h bytes, top row first, written from (x, y) of the image;
what falls outside it is dropped. Up to 65,536 pixels a call (more is
ERR_ARG). It travels with the drawing commands, so a draw_tile asked for
earlier still draws the image as it was. The wrapper is
SpriteImage#write_pixels.
```ruby
gfx.write_sprite_image(img.id, 0, 0,
  16, 16, pixels)
```

### FmrbGfx#set_sprite_image_target

<pre class="fmrb-sig"><code>set_sprite_image_target(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

Draw into a sprite image

What is drawn next goes into that image, in its own coordinates (no
origin added); 0 goes back to the canvas. The wrappers are SpriteImage#set_target, #reset_target and
#draw.
```ruby
gfx.set_sprite_image_target(id)
gfx.fill_rect(0, 0, 16, 16, FmrbGfx::RED)
gfx.set_sprite_image_target(0)
```

### FmrbGfx#create_sprite_instance

<pre class="fmrb-sig"><code>create_sprite_instance(
  <a href="../Array/">Array</a>[uint16] image_ids,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> z
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Place sprite images on the canvas

Returns the placed sprite's number. image_ids are the frames of a flip
book (1 to 8). The position is from
the origin, also while drawing into a sprite image; a larger z is nearer.
The wrapper is SpriteInstance.new.
```ruby
sp = gfx.create_sprite_instance(
  [id1, id2], 40, 80, 0)
```

### FmrbGfx#delete_sprite_instance

<pre class="fmrb-sig"><code>delete_sprite_instance(<a href="../Integer/">Integer</a> instance_id) -&gt; FmrbGfx</code></pre>

Let go of a placed sprite

The wrapper is SpriteInstance#destroy.
```ruby
gfx.delete_sprite_instance(sp)
```

### FmrbGfx#move_sprite

<pre class="fmrb-sig"><code>move_sprite(<a href="../Integer/">Integer</a> instance_id, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; FmrbGfx</code></pre>

Move a placed sprite

From the origin. The compositing happens at the next present. The wrapper
is SpriteInstance#move, which also moves a frameless window's hit shape
when the sprite is marked for it.
```ruby
gfx.move_sprite(sp, 48, 80)
gfx.present
```

### FmrbGfx#set_sprite_visible

<pre class="fmrb-sig"><code>set_sprite_visible(<a href="../Integer/">Integer</a> instance_id, bool visible) -&gt; FmrbGfx</code></pre>

Show or hide a placed sprite

The wrapper is SpriteInstance#visible=.
```ruby
gfx.set_sprite_visible(sp, false)
```

### FmrbGfx#set_sprite_frame

<pre class="fmrb-sig"><code>set_sprite_frame(<a href="../Integer/">Integer</a> instance_id, <a href="../Integer/">Integer</a> frame) -&gt; FmrbGfx</code></pre>

Which frame a placed sprite shows

0 is the first. The wrapper is SpriteInstance#frame=.
```ruby
gfx.set_sprite_frame(sp, 1)
```

### FmrbGfx#delete_all_sprites

<pre class="fmrb-sig"><code>delete_all_sprites() -&gt; FmrbGfx</code></pre>

Let go of every sprite on this canvas

The placed sprites and their images both go.
```ruby
gfx.delete_all_sprites
```

### FmrbGfx#video_open

<pre class="fmrb-sig"><code>video_open(<a href="../String/">String</a> path) -&gt; <a href="../FmrbVideo/">FmrbVideo</a>?</code></pre>

Play a motion-JPEG file into the canvas (Modern)

Position and speed are keyword arguments (x:, y:, fps:, loop:). It opens
paused; play the FmrbVideo it gives back. nil where it cannot be played
(Retro, the sim). Do not draw inside the picture while it plays.
```ruby
v = gfx.video_open("/home/a.mjpeg",
                   x: 0, y: 0, fps: 15)
v.play if v
```

### FmrbGfx#video_open_raw

<pre class="fmrb-sig"><code>video_open_raw(
  <a href="../String/">String</a> path,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> fps,
  bool loop
) -&gt; video_info?</code></pre>

video_open with nothing left out

The simple form, with no argument left out. It returns the video's
{width:, height:}, or nil when it cannot be played; FmrbGfx.video_control
plays and stops it. The wrapper is video_open.
```ruby
info = gfx.video_open_raw(path,
         0, 0, 15, false)
```

### FmrbGfx#export_frame

<pre class="fmrb-sig"><code>export_frame(<a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

Write the presented picture to a file

Writes what the last present showed to a file on the graphics side
(Tab5 a JPEG, the sim a BMP; Retro cannot). It does not present, so
present first. It does not wait for the write.
```ruby
gfx.present
gfx.export_frame("/home/shot.jpg")
```

### FmrbGfx#set_output_level

<pre class="fmrb-sig"><code>set_output_level(<a href="../Integer/">Integer</a> level) -&gt; FmrbGfx</code></pre>

Set the video brightness

Sets the brightness of Retro's composite video signal. It does nothing on
Modern. For when a CRT's own controls do not get there.
```ruby
@gfx.set_output_level(200)
```

### FmrbGfx#set_chroma_level

<pre class="fmrb-sig"><code>set_chroma_level(<a href="../Integer/">Integer</a> level) -&gt; FmrbGfx</code></pre>

Set the colour depth of the video

Sets the saturation of Retro's composite video -- the colour burst
amplitude. It does nothing on Modern; 0 gives a black-and-white picture.
```ruby
@gfx.set_chroma_level(128)
@gfx.set_chroma_level(0)  # b/w
```

### FmrbGfx#sync_file

<pre class="fmrb-sig"><code>sync_file(<a href="../String/">String</a> path, ?dest: <a href="../String/">String</a>) -&gt; bool</code></pre>

Send an image or sound file across

The graphics side reads its own filesystem, so an asset has to be put
there first. This compares size and CRC32 and transfers only when they
differ, so it is fine to call on every start.

Deciding with file_status[:exists] instead -- "it is there, skip it" --
leaves an edited asset stale for ever. Use this one for assets.

```ruby
gfx.sync_file("/home/bird.png",
              dest: "/cache/app/x/bird.png")
```

### FmrbGfx#sync_file_raw

<pre class="fmrb-sig"><code>sync_file_raw(<a href="../String/">String</a> path, <a href="../String/">String</a> dest) -&gt; bool</code></pre>

sync_file with nothing left out

The destination cannot be left out. The wrapper is sync_file (without
dest: it uses the same path).
```ruby
gfx.sync_file_raw(path, path)
```

### FmrbGfx#transfer_file

<pre class="fmrb-sig"><code>transfer_file(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Send a file again whatever happens

Transfers unconditionally, without looking at what is already there.
sync_file is the usual choice; this one is for when the destination is
known to need rewriting.
```ruby
@gfx.transfer_file("/data/a.bmp")
```

### FmrbGfx#transfer_file_raw

<pre class="fmrb-sig"><code>transfer_file_raw(<a href="../String/">String</a> path, <a href="../String/">String</a> dest) -&gt; bool</code></pre>

transfer_file with nothing left out

The destination cannot be left out. The wrapper is transfer_file.
```ruby
gfx.transfer_file_raw(path, path)
```

### FmrbGfx#file_status

<pre class="fmrb-sig"><code>file_status(<a href="../String/">String</a> path) -&gt; file_info</code></pre>

Whether the file arrived

Whether the graphics side has the file, and how big it is: {exists:, size:}.

Do not use it to decide whether to send an asset. exists stays true after
the contents change, so an edited asset would stay stale; leave that
decision to sync_file.
```ruby
st = @gfx.file_status("/data/a.bmp")
st[:exists]
st[:size]
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
