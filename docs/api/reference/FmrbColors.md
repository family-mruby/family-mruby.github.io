# FmrbColors

The colour-name table, and /home/colors.toml

A colour is **an RGB332 integer, 0..255**. The names are the web's, mapped onto the 256
colours (a list of 101, plus aliases that land on the same colour). /home/colors.toml holds
only what an app overrides: a missing file, section or key means "use the theme".
```ruby
bg = FmrbColors.by_name("navy")   #=> 2
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PATH`</span> | [`String`](String.md) | The overrides file |

## Class methods

### FmrbColors.shade

<pre class="fmrb-sig"><code>shade(<a href="../Integer/">Integer</a> color, ?<a href="../Integer/">Integer</a>? avoid) -&gt; <a href="../Integer/">Integer</a></code></pre>

A step darker than a theme colour

Down two of the seven red/green steps and one of the three blue ones. When the result would
be 0x01 (the desktop's transparent key), the colour itself or `avoid`, it goes the other way.
For a bar that must not merge with its neighbour.
```ruby
bar = FmrbColors.shade(
  FmrbConst::THEME_MENU_BG, bg)
```

### FmrbColors.by_name

<pre class="fmrb-sig"><code>by_name(<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Look a colour up by name

The name must be **lowercase** and in the list or the aliases. Otherwise nil.
```ruby
FmrbColors.by_name("black")   #=> 0
```

### FmrbColors.name_of

<pre class="fmrb-sig"><code>name_of(<a href="../Integer/">Integer</a> value) -&gt; <a href="../String/">String</a>?</code></pre>

The name to show for a colour

nil for a colour without a name. An alias is never returned, only the list's name.
```ruby
FmrbColors.name_of(0)   #=> "black"
```

### FmrbColors.name_at

<pre class="fmrb-sig"><code>name_at(<a href="../Integer/">Integer</a> index) -&gt; <a href="../String/">String</a>?</code></pre>

The nth name in the list

From 0. nil out of range.
```ruby
FmrbColors.name_at(0)   #=> "black"
```

### FmrbColors.palette_size

<pre class="fmrb-sig"><code>palette_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many names the list holds

```ruby
FmrbColors.palette_size.times { |i| p FmrbColors.name_at(i) }
```

### FmrbColors.palette_value

<pre class="fmrb-sig"><code>palette_value(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The nth colour of the list

From 0. nil out of range. Same order as `name_at`.
```ruby
FmrbColors.palette_value(0)   #=> 0
```

### FmrbColors.to_color

<pre class="fmrb-sig"><code>to_color(<a href="../String/">String</a> text) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Turn text into a colour

`"0x24"` (hex), `"36"` (decimal), `"black"` or `"\"black\""` (a name) become 0..255.
**Anything else is nil**, so a typo leaves the theme colour (it never paints black).
A hex or decimal above 255 is cut to its low 8 bits.
```ruby
FmrbColors.to_color("0x1C")   #=> 28
```

### FmrbColors.to_text

<pre class="fmrb-sig"><code>to_text(<a href="../Integer/">Integer</a> value) -&gt; <a href="../String/">String</a></code></pre>

The text to write back for a colour

Its name when it has one, otherwise the `"0x1C"` form.
```ruby
FmrbColors.to_text(28)   #=> "0x1C" or a name
```

### FmrbColors.section

<pre class="fmrb-sig"><code>section(<a href="../String/">String</a> name) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../Integer/">Integer</a>]</code></pre>

Read one section's overrides

Returns `{ "bg" => 36, ... }`. **A missing file or section, non-TOML text, a non-colour value**
give an empty Hash or are skipped; nothing raises. An integer is
cut to 8 bits (a negative one is skipped), a string goes through `to_color`.
```ruby
c = FmrbColors.section("editor")
bg = c["bg"] || FmrbConst::THEME_WINDOW_BG
```

### FmrbColors.set

<pre class="fmrb-sig"><code>set(<a href="../String/">String</a> section, <a href="../String/">String</a> key, <a href="../Integer/">Integer</a>? value) -&gt; bool</code></pre>

Write one override

Writes a colour to key `key` of section `section`. **A nil value removes the key** (back
to the theme). It writes as `FmrbToml.update` does (other lines and comments stay). true
when the file holds it now, false when it could not be written or the file is not TOML.
```ruby
FmrbColors.set("shell", "bg", 0x24)
```

### FmrbColors.clear

<pre class="fmrb-sig"><code>clear(<a href="../String/">String</a> section) -&gt; bool</code></pre>

Remove a whole section

Drops the heading and everything up to the next section, then rewrites the file. true when
there is no file, false when the write fails. **Other sections are kept, but the file is rewritten whole.**
```ruby
FmrbColors.clear("shell")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
