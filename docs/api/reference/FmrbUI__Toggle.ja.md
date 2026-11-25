# FmrbUI::Toggle

入切の切替

使い方は [UI 部品](../ui.md) のページにあります。

継承元: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## インスタンスメソッド

### FmrbUI::Toggle#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

切のときの文字

```ruby
s = toggle.text
```

### FmrbUI::Toggle#on_text

<pre class="fmrb-sig"><code>on_text() -&gt; <a href="../String/">String</a></code></pre>

入のときの文字

```ruby
s = toggle.on_text
```

### FmrbUI::Toggle#on?

<pre class="fmrb-sig"><code>on?() -&gt; bool</code></pre>

入かどうか

```ruby
save if toggle.on?
```

### FmrbUI::Toggle#set_on

<pre class="fmrb-sig"><code>set_on(bool flag) -&gt; void</code></pre>

入切を変える

**押されたことにはならない** — 見た目と状態だけ変わる。
```ruby
toggle.set_on(true)
@ui.flush
```

### FmrbUI::Toggle#group

<pre class="fmrb-sig"><code>group() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

同じ一つだけ入にする仲間の名前

同じ名前の仲間のうち一つだけが入になる。
```ruby
g = toggle.group
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
