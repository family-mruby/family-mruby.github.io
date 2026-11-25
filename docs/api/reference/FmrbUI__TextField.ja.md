# FmrbUI::TextField

1 行の文字入力欄

使い方は [UI 部品](../ui.md) のページにあります。

継承元: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## インスタンスメソッド

### FmrbUI::TextField#field_text

<pre class="fmrb-sig"><code>field_text() -&gt; <a href="../String/">String</a></code></pre>

打たれている文字

```ruby
s = field.field_text
```

### FmrbUI::TextField#focused?

<pre class="fmrb-sig"><code>focused?() -&gt; bool</code></pre>

焦点があるか

```ruby
draw_caret if field.focused?
```

### FmrbUI::TextField#set_field_text

<pre class="fmrb-sig"><code>set_field_text(<a href="../String/">String</a>? t) -&gt; void</code></pre>

文字を入れ直す

nil は空の文字列になります。渡した文字列は写して持つので、あとで渡した側を書き換えても欄は変わりません。
```ruby
field.set_field_text("untitled")
@ui.flush
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
