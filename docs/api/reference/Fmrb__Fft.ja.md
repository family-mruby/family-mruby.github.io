# Fmrb::Fft

音のスペクトルを計算する

使い方は [ユーティリティ](../utilities.md) のページにあります。

**16 ビット整数のバイト列** (リトルエンディアン) を渡し、**同じ形のバイト列で大きさ (振幅)** が返る。方式 (`backend:`) は `:ruby`・`:c`・`:dsp`・`:spinel`・`:c64` と、整数だけの `:ruby_q15`・`:c_q15`・
`:spinel_q15`。**どれも同じ入出力**で、速さと入るビルドが違う。
```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
mag = fft.forward(pcm)
Fmrb::Fft.bin(mag, 8)
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`BACKENDS`</span> | `Array[Symbol]` | 方式の名前の一覧 |
| <span class="fmrb-name">`Q15_BACKENDS`</span> | `Array[Symbol]` | 整数だけで計算する方式 |

## クラスメソッド

### Fmrb::Fft.new

<pre class="fmrb-sig"><code>new(?size: <a href="../Integer/">Integer</a>, ?backend: <a href="../Symbol/">Symbol</a>) -&gt; Fmrb::Fft</code></pre>

変換を用意する

`size:` (省略すると 512) は **64〜1024 の 2 の冪**、`backend:` (省略すると `:ruby`)。知らない方式や大きさは ArgumentError ("unknown FFT backend: x"・"FFT size must be a power of
two in 64..1024: n")。**入っていない方式は先に `Fmrb::Fft.available?` で調べる**。

`:spinel`・`:spinel_q15` は端末に 1 つだけの実体で、**最初に開いたアプリが持つ**。2 つ目のアプリは黙って `:ruby`・`:ruby_q15` になる (`backend` で分かる)。ビルドに無いと RuntimeError。使い終わったら `close`。
```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
```

### Fmrb::Fft.available?

<pre class="fmrb-sig"><code>available?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

方式がこのビルドに入っているか

`:ruby`・`:c`・`:c64` とその Q15 版はいつも true。**`:dsp` は esp-dsp のある実機のビルドだけ**、
`:spinel` 系は Spinel の FFT を入れたビルドだけ。知らない名前は false。
```ruby
Fmrb::Fft.available?(:dsp)
```

### Fmrb::Fft.q15?

<pre class="fmrb-sig"><code>q15?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

整数だけの方式か

```ruby
Fmrb::Fft.q15?(:c_q15)   #=> true
```

### Fmrb::Fft.micros

<pre class="fmrb-sig"><code>micros() -&gt; <a href="../Integer/">Integer</a></code></pre>

全方式で共通の時計 (マイクロ秒)

差を取って使う。
```ruby
t = Fmrb::Fft.micros
```

### Fmrb::Fft.spinel_total_us

<pre class="fmrb-sig"><code>spinel_total_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

Spinel の呼び出しの全体にかかった時間

直前の `:spinel` 系の呼び出し全体 (サンプルを渡す・結果を戻す・最初の表作りまで) のマイクロ秒。`run` が返す変換だけの時間との差が、境界を越える費用。
```ruby
Fmrb::Fft.spinel_total_us
```

### Fmrb::Fft.sine

<pre class="fmrb-sig"><code>sine(?size: <a href="../Integer/">Integer</a>, ?cycles: <a href="../Integer/">Integer</a>, ?amp: <a href="../Integer/">Integer</a>) -&gt; <a href="../String/">String</a></code></pre>

試験用の正弦波を作る

`cycles:` 周期 (省略すると 8) を `size:` 個 (省略すると 512) に入れた、振幅 `amp:` (省略すると 12000)
の 16 ビット整数のバイト列。変換するとピークが `cycles` 番に立つ。
```ruby
pcm = Fmrb::Fft.sine(size: 512, cycles: 8)
```

### Fmrb::Fft.bin

<pre class="fmrb-sig"><code>bin(<a href="../String/">String</a> mag, <a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

大きさのバイト列から 1 つ読む

`index` 番の値 (0〜32767)。**範囲外は 0** (例外にならない)。
```ruby
h = Fmrb::Fft.bin(mag, 8)
```

### Fmrb::Fft.peak_bin

<pre class="fmrb-sig"><code>peak_bin(<a href="../String/">String</a> mag) -&gt; <a href="../Integer/">Integer</a></code></pre>

いちばん大きい番号

0 番 (直流分) も数える。同じ大きさなら小さい番号。
```ruby
Fmrb::Fft.peak_bin(mag)   #=> 8
```

### Fmrb::Fft.bench

<pre class="fmrb-sig"><code>bench(
  ?size: <a href="../Integer/">Integer</a>,
  ?iters: <a href="../Integer/">Integer</a>,
  ?backend: <a href="../Symbol/">Symbol</a>,
  ?reps: <a href="../Integer/">Integer</a>,
  ?samples: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped]</code></pre>

1 つの方式を計る

`size:` (512)・`iters:` (100)・`backend:` (`:c`)・`reps:` (5)・`samples:` (省略すると
`sine`) の省略値で、`reps` 回 `iters` 回ずつ回す。結果は Hash:
`:backend` (頼んだ方式)・`:ran_on` (動いた方式)・`:size`・`:iters`・`:reps`・`:us_avg`
(1 回の平均、Float)・`:us_min` (最良の回の 1 回あたり)・`:mag`・`:peak_bin`。方式が使えないと `new` と同じ例外。
```ruby
r = Fmrb::Fft.bench(backend: :c)
r[:us_avg]
```

## インスタンスメソッド

### Fmrb::Fft#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

変換の大きさ

```ruby
fft.size   #=> 512
```

### Fmrb::Fft#backend

<pre class="fmrb-sig"><code>backend() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

実際に動いている方式

頼んだ方式と違うことがある (Spinel を別のアプリが持っているとき)。
```ruby
fft.backend   #=> :c
```

### Fmrb::Fft#forward

<pre class="fmrb-sig"><code>forward(<a href="../String/">String</a> samples) -&gt; <a href="../String/">String</a></code></pre>

1 回変換して大きさのバイト列を返す

`samples` は **`size` 個の 16 ビット整数のリトルエンディアンのバイト列** (`size * 2` バイト)。返りは size/2 個の 16 ビット整数 (リトルエンディアン) で、**ハン窓をかけ、2/size に**
**正規化し、32767 で頭打ち**。0 番は直流分で最大になりやすい。読むには `Fmrb::Fft.bin`。

`:c` 系は**短いと ArgumentError** ("need 512 int16 samples, got n bytes")。**`:ruby` 系は足りない**
**所を 0 として黙って進める**。
```ruby
mag = fft.forward(pcm)
```

### Fmrb::Fft#run

<pre class="fmrb-sig"><code>run(<a href="../String/">String</a> samples, <a href="../Integer/">Integer</a> iters) -&gt; [ <a href="../Integer/">Integer</a>, <a href="../String/">String</a> ]</code></pre>

同じ入力を iters 回変換して時間を測る

`[マイクロ秒, 大きさのバイト列]` を返す。時間は**エンジンの中で測った変換だけ**の合計
(呼び出しの費用を含まない)。`iters` は 1 以上 (`:c` 系は 0 以下で ArgumentError)。
**アプリが毎フレームの変換に使っている形**。
```ruby
us, mag = fft.run(pcm, 1)
```

### Fmrb::Fft#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

使い終わる

`:spinel` 系の実体を手放す (ほかの方式では何もしない)。nil を返す。
**`:spinel` 系を使ったら、アプリを終えるときに呼ぶ**。
```ruby
fft.close
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
