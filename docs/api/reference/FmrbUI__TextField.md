# FmrbUI::TextField

A one-line text field

How to use it: [UI Widgets](../ui.md).

Inherits from: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## Instance methods

### FmrbUI::TextField#field_text

<pre class="fmrb-sig"><code>field_text() -&gt; <a href="../String/">String</a></code></pre>

What has been typed

```ruby
s = field.field_text
```

### FmrbUI::TextField#focused?

<pre class="fmrb-sig"><code>focused?() -&gt; bool</code></pre>

Whether it has the focus

```ruby
draw_caret if field.focused?
```

### FmrbUI::TextField#set_field_text

<pre class="fmrb-sig"><code>set_field_text(<a href="../String/">String</a>? t) -&gt; void</code></pre>

Replace what is in the field

nil becomes an empty string. The field keeps a copy, so changing the
string you passed later does not change the field.
```ruby
field.set_field_text("untitled")
@ui.flush
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
