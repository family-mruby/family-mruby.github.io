# Fmrb::Raycast

格子の地図を、壁までの距離で見る (Wolfenstein 3D 風)。

**値は全部整数** (小数は使わない)。1 マス = 256 の固定小数、**角度は度 (整数)**、1 回で **40 本**の光線を、視野 60 度に並べて撃つ。結果は光線ごとの距離・壁の種類・面。方式は `:ruby` と
`:spinel` (同じ計算を ネイティブコードにしたもの)。
```ruby
rc = Fmrb::Raycast.new
rc.set_map(MAP, 12, 12)
rc.cast(px, py, deg)
d = rc.dist(20)
```

## クラスメソッド

### Fmrb::Raycast.new

<pre class="fmrb-sig"><code>new(?backend: <a href="../Symbol/">Symbol</a>) -&gt; Fmrb::Raycast</code></pre>

光線を作る

`backend:` (省略すると `:ruby`) は `:ruby` か `:spinel`。ほかは ArgumentError
("unknown raycast backend: x")。**`:spinel` が入っていないビルドでは RuntimeError** なので、先に `Fmrb::Raycast.available?(:spinel)`。`:spinel` は端末に 1 つで**最初に開いたアプリが持つ**。
2 つ目のアプリは黙って `:ruby` になる (`backend` で分かる)。
```ruby
rc = Fmrb::Raycast.new(backend: :ruby)
```

### Fmrb::Raycast.available?

<pre class="fmrb-sig"><code>available?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

方式がこのビルドに入っているか

`:ruby` はいつも true。`:spinel` は入ったビルドだけ。それ以外の名前は false。
```ruby
Fmrb::Raycast.available?(:spinel)
```

### Fmrb::Raycast.micros

<pre class="fmrb-sig"><code>micros() -&gt; <a href="../Integer/">Integer</a></code></pre>

方式を問わない時計 (マイクロ秒)

差を取って使う。`cast` が返す時間と同じ時計。
```ruby
t = Fmrb::Raycast.micros
```

### Fmrb::Raycast.unpack

<pre class="fmrb-sig"><code>unpack(<a href="../String/">String</a> buf) -&gt; <a href="../Array/">Array</a>[<a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, <a href="../Integer/">Integer</a>]]</code></pre>

結果のバイト列を Hash の Array にする

光線ごとに `{ dist:, wall:, side: }`。光線 1 本ごとに Hash を作るので重く、毎フレームの描画には使わない (`dist`・`wall`・`side` を読む)。1 本 6 バイトの形のバイト列を受ける。
```ruby
Fmrb::Raycast.unpack(buf)
```

## インスタンスメソッド

### Fmrb::Raycast#backend

<pre class="fmrb-sig"><code>backend() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

実際に撃っている方式

```ruby
rc.backend   #=> :ruby
```

### Fmrb::Raycast#set_map

<pre class="fmrb-sig"><code>set_map(<a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>?] | <a href="../String/">String</a> cells, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; nil</code></pre>

地図を渡す

`cells` は **1 マス 1 値の Integer の Array** (左上から行ごと、w * h 個) か、1 マス 1 バイトの
String。値は 0〜255 (下 8 ビットに丸める、nil は 0)。**0 は何もない**、**0 以外は壁で、その値が**
**`wall` に返る**。**地図の外は壁 (値 1)** として扱う。`w`・`h` は幅と高さ (マス)。nil を返す。
**`cast` の前に 1 回呼ぶ**。

`:spinel` で渡せない地図 (大きさが 0 以下、マス数が合わない) は RuntimeError か ArgumentError
("map dimensions must be positive"・"need n map cells, got n bytes")。
```ruby
rc.set_map([1,1,1, 1,0,1, 1,1,1], 3, 3)
```

### Fmrb::Raycast#cast

<pre class="fmrb-sig"><code>cast(<a href="../Integer/">Integer</a> px, <a href="../Integer/">Integer</a> py, <a href="../Integer/">Integer</a> pa) -&gt; <a href="../Integer/">Integer</a></code></pre>

1 フレーム分の光線を撃つ

`px`・`py` は位置 (**1 マス = 256 の固定小数**、ふつうは `マス * 256 + 128` で真ん中)、
`pa` は向き (度、整数。360 を超えても負でもよい)。**かかった時間 (マイクロ秒) を返す**。結果は戻り値でなく、`dist`・`wall`・`side` で読む。`set_map` の前は RuntimeError ("set_map has not
been called")。
```ruby
us = rc.cast(px, py, deg)
```

### Fmrb::Raycast#rays

<pre class="fmrb-sig"><code>rays() -&gt; <a href="../Integer/">Integer</a></code></pre>

直前の `cast` の光線の数

最初の `cast` の前は 0。ふだんは 40。
```ruby
rc.rays   #=> 40
```

### Fmrb::Raycast#dist

<pre class="fmrb-sig"><code>dist(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

光線 i が壁に当たるまでの距離

固定小数 (256 = 1 マス) の整数。**視線に直角な距離に直してある** (魚眼にならない)。
0 に落ちず最小 1。`cast` の前は 0。`i` は 0 から `rays` 未満 (範囲外は NoMethodError)。
```ruby
h = 6000 / rc.dist(i)
```

### Fmrb::Raycast#wall

<pre class="fmrb-sig"><code>wall(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

光線 i が当たった壁の値

地図の値。**0 は歩数 (24 マス) の上限まで進んで当たらなかった**こと。`cast` の前は 0。
```ruby
rc.wall(i)
```

### Fmrb::Raycast#side

<pre class="fmrb-sig"><code>side(<a href="../Integer/">Integer</a> i) -&gt; <a href="../Integer/">Integer</a></code></pre>

光線 i が当たった面

0 は縦の面、1 は横の面。面ごとに明るさを変えるのに使う。`cast` の前は 0。
```ruby
dark = rc.side(i) == 1
```

### Fmrb::Raycast#fp_sin

<pre class="fmrb-sig"><code>fp_sin(<a href="../Integer/">Integer</a> deg) -&gt; <a href="../Integer/">Integer</a></code></pre>

整数の正弦 (度)

結果は -256〜256 (256 = 1.0)。負の度も 360 を超える度もよい。**どちらの方式で撃っていても**
**同じ値**なので、移動や置き場所の計算に使う。
```ruby
dy = rc.fp_sin(deg) * 8 / 256
```

### Fmrb::Raycast#fp_cos

<pre class="fmrb-sig"><code>fp_cos(<a href="../Integer/">Integer</a> deg) -&gt; <a href="../Integer/">Integer</a></code></pre>

整数の余弦 (度)

`fp_sin` と同じ形 (-256〜256)。
```ruby
dx = rc.fp_cos(deg) * 8 / 256
```

### Fmrb::Raycast#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

使い終わる

`:spinel` の実体を手放し (ほかの方式では何もしない)、持っていた地図を捨てる。nil を返す。
**`:spinel` を使ったら、アプリを終えるときに呼ぶ**。
```ruby
rc.close
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
