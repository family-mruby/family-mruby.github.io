# FmrbUI::Toggle

An on/off toggle

How to use it: [UI Widgets](../ui.md).

Inherits from: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## Instance methods

### FmrbUI::Toggle#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

The text shown when off

```ruby
s = toggle.text
```

### FmrbUI::Toggle#on_text

<pre class="fmrb-sig"><code>on_text() -&gt; <a href="../String/">String</a></code></pre>

The text shown when on

```ruby
s = toggle.on_text
```

### FmrbUI::Toggle#on?

<pre class="fmrb-sig"><code>on?() -&gt; bool</code></pre>

Whether it is on

```ruby
save if toggle.on?
```

### FmrbUI::Toggle#set_on

<pre class="fmrb-sig"><code>set_on(bool flag) -&gt; void</code></pre>

Switch it on or off

It does not count as a press: only the look and the state change.
```ruby
toggle.set_on(true)
@ui.flush
```

### FmrbUI::Toggle#group

<pre class="fmrb-sig"><code>group() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

The radio group name

Only one toggle in a group is on at a time.
```ruby
g = toggle.group
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
