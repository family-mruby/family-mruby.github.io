# FmrbUI::Scrollbar

縦のスクロールバー

使い方は [UI 部品](../ui.md) のページにあります。

継承元: [`FmrbUI::Widget`](FmrbUI__Widget.md)

一覧のことは何も知らず、全部の数・見える数・今の位置の 3 つの整数だけで動きます。位置を持つのはアプリで、バーは写しです。`FmrbUI#scrollbar` で作り、値の出し入れは `FmrbUI#set_value` / `set_range` でもできます。

## インスタンスメソッド

### FmrbUI::Scrollbar#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の位置

```ruby
@scroll = bar.value
```

### FmrbUI::Scrollbar#total

<pre class="fmrb-sig"><code>total() -&gt; <a href="../Integer/">Integer</a></code></pre>

全部の数

```ruby
n = bar.total
```

### FmrbUI::Scrollbar#visible_count

<pre class="fmrb-sig"><code>visible_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

一度に見える数

```ruby
rows = bar.visible_count
```

### FmrbUI::Scrollbar#active?

<pre class="fmrb-sig"><code>active?() -&gt; bool</code></pre>

バーが出ているか

全部が見えている間は偽で、何も描かず、クリックも通します。
```ruby
draw_hint unless bar.active?
```

### FmrbUI::Scrollbar#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Integer/">Integer</a> v) -&gt; bool</code></pre>

位置を入れる

0 から (total - visible) の間へ収めます。**位置が変わったときだけ true**
を返します (同じ位置なら false)。
```ruby
bar.set_value(@scroll)
```

### FmrbUI::Scrollbar#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Integer/">Integer</a> total, <a href="../Integer/">Integer</a> visible) -&gt; void</code></pre>

全部の数と見える数を入れ直す

**Stepper の set_range とは違い、引数は (total, visible)** です。位置は新しい範囲の中へ引き戻されます。
```ruby
bar.set_range(@files.size, 8)
```

### FmrbUI::Scrollbar#hit?

<pre class="fmrb-sig"><code>hit?(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py) -&gt; bool</code></pre>

その点がバーの上か

**バーが出ていないとき (全部が見えている間) は偽**です。点が重なっていても同じで、一覧へクリックを通すための振る舞いです。
```ruby
on_bar = @ui.find(:sb).hit?(x, y)
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
