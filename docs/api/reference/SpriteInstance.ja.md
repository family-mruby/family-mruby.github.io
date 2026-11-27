# SpriteInstance

画面に置いた一つのうごく絵

使い方は [スプライト](../sprite.md) のページにあります。

位置と、何枚目を見せるかを持つ。

## クラスメソッド

### SpriteInstance.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx, untyped images) -&gt; SpriteInstance</code></pre>

絵を画面に置く

images には SpriteImage を一枚渡すか、パラパラ漫画のように配列で何枚も渡します。何枚も渡したときは `frame=` で何枚目を見せるかを決められます。

```ruby
img = SpriteImage.new(gfx, width: 16, height: 16)
img.load_bmp("/app/img/player.png")
sp = SpriteInstance.new(gfx, img, x: 40, y: 80)
sp.move(48, 80)
```

## インスタンスメソッド

### SpriteInstance#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Integer/">Integer</a></code></pre>

この置いた絵の番号

```ruby
sp.id
```

### SpriteInstance#move

<pre class="fmrb-sig"><code>move(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; void</code></pre>

置いた絵を動かす

動かしたあとは **`gfx.present` が要る** — 合成はそのときに走る。
```ruby
sp.move(48, 80)
gfx.present
```

### SpriteInstance#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

この絵を片づける

```ruby
sp.destroy
```

### SpriteInstance#visible=

<pre class="fmrb-sig"><code>visible=(bool v) -&gt; void</code></pre>

見せるか隠すか

```ruby
sp.visible = false
```

### SpriteInstance#frame=

<pre class="fmrb-sig"><code>frame=(<a href="../Integer/">Integer</a> index) -&gt; void</code></pre>

何枚目の絵を見せるか (0 が 1 枚目)

何枚も渡して置いたときに、パラパラ漫画のこまを選ぶ。
```ruby
sp.frame = (sp.x / 4) % 2
```

### SpriteInstance#visible?

<pre class="fmrb-sig"><code>visible?() -&gt; bool</code></pre>

見えているか

```ruby
sp.visible = !sp.visible?
```

### SpriteInstance#x

<pre class="fmrb-sig"><code>x() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の x (Window の中)

```ruby
sp.move(sp.x + 4, sp.y)
```

### SpriteInstance#y

<pre class="fmrb-sig"><code>y() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の y (Window の中)

```ruby
sp.move(sp.x, sp.y + 4)
```

### SpriteInstance#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

幅 (1 枚目の絵)

```ruby
right = sp.x + sp.width
```

### SpriteInstance#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

高さ (1 枚目の絵)

```ruby
bottom = sp.y + sp.height
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
