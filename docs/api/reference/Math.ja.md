# Math

三角関数・指数・対数などの数学関数

引数は Integer でも Float でもよく、結果は必ず Float。数でないもの (nil や文字列) を渡すと TypeError。**定義域の外の値は `Math::DomainError`** が出る
(関数ごとに長文に書いた)。
```ruby
Math.sqrt(2)   #=> 1.4142135623730951
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PI`</span> | [`Float`](Float.md) | 円周率 |
| <span class="fmrb-name">`E`</span> | [`Float`](Float.md) | 自然対数の底 |

## クラスメソッド

### Math.sin

<pre class="fmrb-sig"><code>sin(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

正弦 (ラジアン)

```ruby
y = Math.sin(t) * 20
```

### Math.cos

<pre class="fmrb-sig"><code>cos(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

余弦 (ラジアン)

```ruby
x = Math.cos(t) * 20
```

### Math.tan

<pre class="fmrb-sig"><code>tan(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

正接 (ラジアン)

```ruby
Math.tan(Math::PI / 4)
```

### Math.asin

<pre class="fmrb-sig"><code>asin(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆正弦

結果は -PI/2 から PI/2。**x が -1 から 1 の外だと DomainError**。
```ruby
Math.asin(0.5)   #=> 0.5235987755982989
```

### Math.acos

<pre class="fmrb-sig"><code>acos(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆余弦

結果は 0 から PI。**x が -1 から 1 の外だと DomainError**。
```ruby
Math.acos(0.5)   #=> 1.0471975511965979
```

### Math.atan

<pre class="fmrb-sig"><code>atan(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆正接

```ruby
Math.atan(1)   #=> 0.7853981633974483
```

### Math.atan2

<pre class="fmrb-sig"><code>atan2(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> y, <a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

y と x から角度を求める

**引数は y が先、x が後**。結果は -PI から PI。
```ruby
a = Math.atan2(dy, dx)
```

### Math.sinh

<pre class="fmrb-sig"><code>sinh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

双曲線正弦

```ruby
Math.sinh(1)
```

### Math.cosh

<pre class="fmrb-sig"><code>cosh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

双曲線余弦

```ruby
Math.cosh(1)
```

### Math.tanh

<pre class="fmrb-sig"><code>tanh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

双曲線正接

```ruby
Math.tanh(1)
```

### Math.asinh

<pre class="fmrb-sig"><code>asinh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆双曲線正弦

```ruby
Math.asinh(1)
```

### Math.acosh

<pre class="fmrb-sig"><code>acosh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆双曲線余弦

**x が 1 より小さいと DomainError**。
```ruby
Math.acosh(2)
```

### Math.atanh

<pre class="fmrb-sig"><code>atanh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

逆双曲線正接

**x が -1 から 1 の外だと DomainError**。
```ruby
Math.atanh(0.5)
```

### Math.exp

<pre class="fmrb-sig"><code>exp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

e の x 乗

```ruby
Math.exp(1)   #=> 2.718281828459045
```

### Math.expm1

<pre class="fmrb-sig"><code>expm1(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

exp(x) - 1

```ruby
Math.expm1(0.001)
```

### Math.log1p

<pre class="fmrb-sig"><code>log1p(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

log(1 + x)

**x が -1 より小さいと DomainError**。
```ruby
Math.log1p(0.001)
```

### Math.log

<pre class="fmrb-sig"><code>log(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x, ?<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> base) -&gt; <a href="../Float/">Float</a></code></pre>

自然対数。底を渡せば対数の底になる

底を省くと自然対数 (底 e)。渡すと log(x) / log(base) を返す。
`base` (省略すると e)。
**x が負、または base が負だと DomainError** (0 と 1 は C の log にそのまま渡る)。
```ruby
Math.log(8, 2)   #=> 3.0
```

### Math.log2

<pre class="fmrb-sig"><code>log2(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

2 を底とする対数

**x が負だと DomainError**。
```ruby
Math.log2(8)   #=> 3.0
```

### Math.log10

<pre class="fmrb-sig"><code>log10(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

10 を底とする対数

**x が負だと DomainError**。
```ruby
Math.log10(1000)   #=> 3.0
```

### Math.sqrt

<pre class="fmrb-sig"><code>sqrt(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

平方根

**x が負だと DomainError** (複素数は返さない)。
```ruby
Math.sqrt(dx * dx + dy * dy)
```

### Math.cbrt

<pre class="fmrb-sig"><code>cbrt(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

立方根

```ruby
Math.cbrt(27)   #=> 3.0
```

### Math.frexp

<pre class="fmrb-sig"><code>frexp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Array/">Array</a>[<a href="../Float/">Float</a> | <a href="../Integer/">Integer</a>]</code></pre>

仮数と指数に分ける

[仮数 (Float), 指数 (Integer)] の配列を返す。x = 仮数 * 2 の指数乗。
```ruby
f, e = Math.frexp(1234)
#=> f = 0.6025390625, e = 11
```

### Math.ldexp

<pre class="fmrb-sig"><code>ldexp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> fraction, <a href="../Integer/">Integer</a> exponent) -&gt; <a href="../Float/">Float</a></code></pre>

仮数 * 2 ** 指数を求める

```ruby
Math.ldexp(0.5, 3)   #=> 4.0
```

### Math.hypot

<pre class="fmrb-sig"><code>hypot(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x, <a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> y) -&gt; <a href="../Float/">Float</a></code></pre>

直角三角形の斜辺の長さ

```ruby
Math.hypot(3, 4)   #=> 5.0
```

### Math.erf

<pre class="fmrb-sig"><code>erf(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

誤差関数

```ruby
Math.erf(1)
```

### Math.erfc

<pre class="fmrb-sig"><code>erfc(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

相補誤差関数

```ruby
Math.erfc(1)
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
