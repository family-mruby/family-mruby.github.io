# FmrbHitMask

枠なし Window の当たりの形 (画素単位)

使い方は [スプライト](../sprite.md) のページにあります。

FmrbApp#hit_mask_from_art で作る。

## クラスメソッド

### FmrbHitMask.new

<pre class="fmrb-sig"><code>new(
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../String/">String</a> bits,
  ?<a href="../Integer/">Integer</a> scale
) -&gt; FmrbHitMask</code></pre>

マスクを作る (行ごとのビット列)

width x height マス。bits は 1 行 (width + 7) / 8 バイト、左のマスが上位ビット。立っているマスが当たる。
```ruby
m = FmrbHitMask.new(8, 1,
      "\xF0", 2)
```

### FmrbHitMask.from_art

<pre class="fmrb-sig"><code>from_art(
  <a href="../Array/">Array</a> rows,
  ?transparent: <a href="../String/">String</a>,
  ?scale: <a href="../Integer/">Integer</a>
) -&gt; FmrbHitMask</code></pre>

ドット絵の文字列から作る

```ruby
m = FmrbHitMask.from_art(ROWS,
      transparent: ".", scale: 3)
```

## インスタンスメソッド

### FmrbHitMask#set?

<pre class="fmrb-sig"><code>set?(<a href="../Integer/">Integer</a> cx, <a href="../Integer/">Integer</a> cy) -&gt; bool</code></pre>

マスが当たるか

```ruby
m.set?(3, 0)
```

### FmrbHitMask#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

幅 (マス)

```ruby
m.width
```

### FmrbHitMask#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

高さ (マス)

```ruby
m.height
```

### FmrbHitMask#scale

<pre class="fmrb-sig"><code>scale() -&gt; <a href="../Integer/">Integer</a></code></pre>

1 マスの画素数

```ruby
m.scale
```

### FmrbHitMask#bits

<pre class="fmrb-sig"><code>bits() -&gt; <a href="../String/">String</a></code></pre>

ビット列

```ruby
same = m.bits == old.bits
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
