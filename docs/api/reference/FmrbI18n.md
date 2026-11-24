# FmrbI18n

Switch the display between Japanese and English

## Class methods

### FmrbI18n.add

<pre class="fmrb-sig"><code>add(<a href="../Hash/">Hash</a> table) -&gt; void</code></pre>

Add a table of words

Each app adds its own table. Existing keys are left alone, so this table
and the desktop's live side by side.
```ruby
FmrbI18n.add(
  "en" => { save: "Save" },
  "ja" => { save: "保存" })
```

### FmrbI18n.lang

<pre class="fmrb-sig"><code>lang() -&gt; <a href="../String/">String</a></code></pre>

The language now, "ja" or "en"

An app moved to another machine speaks the language of that machine.
```ruby
if FmrbI18n.lang == "ja"
  draw_ja
end
```

### FmrbI18n.t

<pre class="fmrb-sig"><code>t(<a href="../Symbol/">Symbol</a> key) -&gt; <a href="../String/">String</a></code></pre>

Look a key up in the language now

An unknown key comes back as its own name instead of raising.
```ruby
@ui.set_text(:save, FmrbI18n.t(:save))
```

### FmrbI18n.text_width

<pre class="fmrb-sig"><code>text_width(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

Measure how wide text would be

A Japanese character is two cells wide, so `length` will not do. Use this
to right-align or centre.
```ruby
w = FmrbI18n.text_width(s)
gfx.draw_text(320 - w, y, s)
```

### FmrbI18n.truncate_to

<pre class="fmrb-sig"><code>truncate_to(<a href="../String/">String</a> str, <a href="../Integer/">Integer</a> max_px, ?<a href="../String/">String</a> ellipsis) -&gt; <a href="../String/">String</a></code></pre>

Cut it down to what fits the width

Never cuts a character in half.
When it cuts it appends `ellipsis` (`".."` when left out, 12 pixels), and
that counts inside max_px. `""` appends nothing. Text that fits comes
back as it is.
```ruby
s = FmrbI18n.truncate_to(name, 120)
```

### FmrbI18n.strings

<pre class="fmrb-sig"><code>strings() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../Hash/">Hash</a>[untyped, <a href="../String/">String</a>]]</code></pre>

The table of words itself

The table of words as a Hash of language to key to text, `add` writes into
it. It starts as `{ "en" => {}, "ja" => {} }`, made the first time it is
asked for.
```ruby
FmrbI18n.strings["ja"][:save]
```

### FmrbI18n.forget

<pre class="fmrb-sig"><code>forget() -&gt; nil</code></pre>

Forget the language resolved so far

The next `lang` reads the machine's setting again. For an app moved to
another machine **the base calls it itself**, so an ordinary app does not.
It always returns nil.
```ruby
FmrbI18n.forget
```

### FmrbI18n.half_kana?

<pre class="fmrb-sig"><code>half_kana?(<a href="../String/">String</a> str, <a href="../Integer/">Integer</a> i, <a href="../Integer/">Integer</a> n) -&gt; bool</code></pre>

Whether it is a half-width katakana

True when the 3 bytes from byte `i` are a half-width katakana (U+FF61 to
U+FF9F). **`i` is a byte position, not a character one**, and
**`n` is the string's byte size** (`bytesize`). False when fewer than 3 bytes are
left. `text_width` uses it to count half-width kana as 4 pixels.
```ruby
s = "ｱ"
FmrbI18n.half_kana?(s, 0, s.bytesize)
#=> true
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
