# FmrbUI::Widget

部品に共通のところ

使い方は [UI 部品](../ui.md) のページにあります。

## インスタンスメソッド

### FmrbUI::Widget#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

この部品の名前

```ruby
case w.id
when :ok then close
end
```

### FmrbUI::Widget#x

<pre class="fmrb-sig"><code>x() -&gt; <a href="../Integer/">Integer</a></code></pre>

左端の位置 (画面の座標)

```ruby
left = w.x
```

### FmrbUI::Widget#y

<pre class="fmrb-sig"><code>y() -&gt; <a href="../Integer/">Integer</a></code></pre>

上端の位置 (画面の座標)

```ruby
top = w.y
```

### FmrbUI::Widget#w

<pre class="fmrb-sig"><code>w() -&gt; <a href="../Integer/">Integer</a></code></pre>

横幅 (ドット)

```ruby
width = w.w
```

### FmrbUI::Widget#h

<pre class="fmrb-sig"><code>h() -&gt; <a href="../Integer/">Integer</a></code></pre>

高さ (ドット)

```ruby
height = w.h
```

### FmrbUI::Widget#dirty

<pre class="fmrb-sig"><code>dirty() -&gt; bool</code></pre>

次の flush で描き直すか

```ruby
@ui.flush if w.dirty
```

### FmrbUI::Widget#enabled

<pre class="fmrb-sig"><code>enabled() -&gt; bool</code></pre>

使えるかどうか

```ruby
return unless w.enabled
```

### FmrbUI::Widget#visible

<pre class="fmrb-sig"><code>visible() -&gt; bool</code></pre>

出ているかどうか

```ruby
next unless w.visible
```

### FmrbUI::Widget#text_size

<pre class="fmrb-sig"><code>text_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

文字の大きさ (作ったときに決まる)

```ruby
s = w.text_size
```

### FmrbUI::Widget#hit?

<pre class="fmrb-sig"><code>hit?(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py) -&gt; bool</code></pre>

その点がこの部品の上か

```ruby
hit = w.hit?(ev[:x], ev[:y])
```

### FmrbUI::Widget#place

<pre class="fmrb-sig"><code>place(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

置き直す (画面の座標)

**作ったあとに動かす**ときに使う。大きさを変えた Window に部品を並べ直すのはこれ。
```ruby
w.place(10, 40, 80, 20)
@ui.flush
```

### FmrbUI::Widget#bg

<pre class="fmrb-sig"><code>bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

部品が自分の中を塗る色

Label の箱・Stepper の値の欄・Scrollbar の溝の色。Button・Toggle・
TextField は使いません。**背後の色ではありません**。
```ruby
c = w.bg
```

### FmrbUI::Widget#bg=

<pre class="fmrb-sig"><code>bg=(<a href="../Integer/">Integer</a> c) -&gt; void</code></pre>

部品の中の色を変える

**自前の色として扱われ**、アプリを別の端末へ移してもテーマの色には戻りません。**描き直しの印は付かない**ので、`@ui.invalidate_all` か、その部品が変わるときに描かれます。
```ruby
@ui.find(:title).bg = FmrbGfx::BLACK
@ui.invalidate_all
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
