# SpriteImage

うごく絵の中身

使い方は [スプライト](../sprite.md) のページにあります。

ここに描いた絵を SpriteInstance で画面に置く。

## クラスメソッド

### SpriteImage.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; SpriteImage</code></pre>

絵を作る (大きさはドット)

**キーワード引数で呼ぶ** (上の形は型推論の都合)。
```ruby
img = SpriteImage.new(gfx,
      width: 16, height: 16,
      transparent_color: 0x00,
      use_transparent: true)
```

## インスタンスメソッド

### SpriteImage#id

<pre class="fmrb-sig"><code>id() -&gt; <a href="../Integer/">Integer</a></code></pre>

この絵の番号

FmrbGfx に直接渡すときに使う。
```ruby
gfx.draw_image(img.id, x: 10, y: 20)
```

### SpriteImage#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

絵の横幅 (ドット)

```ruby
w = img.width
```

### SpriteImage#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

絵の高さ (ドット)

```ruby
h = img.height
```

### SpriteImage#set_target

<pre class="fmrb-sig"><code>set_target() -&gt; void</code></pre>

これから描く先をこの絵にする

**戻すのを忘れない**。普通は `draw` を使えば前後の向け替えが要らない。
```ruby
img.set_target
@gfx.fill_rect(0, 0, 8, 8, 0xFF)
img.reset_target
```

### SpriteImage#reset_target

<pre class="fmrb-sig"><code>reset_target() -&gt; void</code></pre>

描く先を画面に戻す

```ruby
img.reset_target
```

### SpriteImage#draw

<pre class="fmrb-sig"><code>draw() -&gt; void</code></pre>

この絵に描く (ブロックの中で描く)

```ruby
img.draw do |g|
  g.fill_rect(0, 0, 16, 16,
              FmrbGfx::RED)
end
```

### SpriteImage#load_bmp

<pre class="fmrb-sig"><code>load_bmp(<a href="../String/">String</a> path) -&gt; void</code></pre>

絵 (PNG か BMP) をこの絵に読み込む

PNG (色は上位の 3/3/2 ビットで RGB332 になる。透明な点 (α が 128
未満、tRNS) は透明色 0x01 になるので、transparent_color: 0x01 で作った絵なら抜ける) か、画素の値が RGB332 の 8 bit BMP。先頭のバイトで見分ける。名前は BMP しか読めなかった頃のまま。展開は描画側でやる。一枚絵は
`FmrbGfx#create_image` の方。
```ruby
img.load_bmp(
  "/usr/share/sprites/flappy/bird_up.png")
```

### SpriteImage#write_pixels

<pre class="fmrb-sig"><code>write_pixels(<a href="../String/">String</a> pixels) -&gt; void</code></pre>

画素 (RGB332) をこの絵に書く

pixels は幅 x 高さ バイト (上の行から)。x:, y:, width:, height: で一部だけ書ける (既定は絵の全体)。ファイルを経ずに絵を作れる。
```ruby
img = SpriteImage.new(@gfx,
  width: 2, height: 2)
img.write_pixels("\xE0\x1C\x03\xFF")
```

### SpriteImage#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

この絵を片づける

```ruby
img.destroy
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
