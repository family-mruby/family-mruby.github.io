# Integer

整数

整数どうしの割り算は切り捨て (小数がほしければどちらかを `Float` に)。`times`・`downto` はブロック呼び出しが 1 回約 0.4ms なので、回数の多い所では `while` に書く。
`chr` は 0 から 255 の 1 バイト文字を返す。

## インスタンスメソッド

### Integer#%

<pre class="fmrb-sig"><code>%(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

割ったあまりを求める

**割った余り**。輪にして数えるときに使う。
```ruby
i = (i + 1) % 8
```

### Integer#&

<pre class="fmrb-sig"><code>&amp;(Integer other) -&gt; Integer</code></pre>

ビットごとの論理積を求める

ビットの and。旗を調べるのに使う。
```ruby
if flags & 0x04 != 0
```

### Integer#*

<pre class="fmrb-sig"><code>*(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

かけ算をする

**小数を掛けると小数になる**。
```ruby
n * 2
n * 1.5  # Float
```

### Integer#**

<pre class="fmrb-sig"><code>**(Integer | <a href="../Float/">Float</a> other) -&gt; Integer</code></pre>

べき乗を求める

```ruby
2 ** 8  #=> 256
```

### Integer#+

<pre class="fmrb-sig"><code>+(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

足し算をする

```ruby
n + 1
```

### Integer#+@

<pre class="fmrb-sig"><code>+@() -&gt; Integer</code></pre>

自分自身を返す (単項プラス)

そのまま返る。
```ruby
+n
```

### Integer#-

<pre class="fmrb-sig"><code>-(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

引き算をする

```ruby
n - 1
```

### Integer#-@

<pre class="fmrb-sig"><code>-@() -&gt; Integer</code></pre>

符号を反転する (単項マイナス)

```ruby
-n
```

### Integer#/

<pre class="fmrb-sig"><code>/(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

割り算をする

**整数どうしは切り捨て**。小数がほしければどちらかを Float にする。
```ruby
7 / 2      #=> 3
7 / 2.0    #=> 3.5
```

### Integer#<

<pre class="fmrb-sig"><code>&lt;(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

より小さいかどうか

```ruby
if x < w
```

### Integer#<<

<pre class="fmrb-sig"><code>&lt;&lt;(Integer other) -&gt; Integer</code></pre>

ビットを左にずらす

**左にずらす** = 2 のべき乗を掛ける。旗を作るのに使う。
```ruby
1 << 3  #=> 8
```

### Integer#<=

<pre class="fmrb-sig"><code>&lt;=(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

以下かどうか

```ruby
if x <= w
```

### Integer#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(Integer | untyped other) -&gt; Integer</code></pre>

大小を比べて -1 / 0 / 1 を返す

```ruby
a <=> b  #=> -1, 0, 1
```

### Integer#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

```ruby
if n == 0
```

### Integer#>

<pre class="fmrb-sig"><code>&gt;(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

より大きいかどうか

```ruby
if n > 0
```

### Integer#>=

<pre class="fmrb-sig"><code>&gt;=(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

以上かどうか

```ruby
if n >= 0
```

### Integer#>>

<pre class="fmrb-sig"><code>&gt;&gt;(Integer other) -&gt; Integer</code></pre>

ビットを右にずらす

**右にずらす** = 2 のべき乗で割る (切り捨て)。バイトを取り出すのに使う。
```ruby
(v >> 8) & 0xFF
```

### Integer#^

<pre class="fmrb-sig"><code>^(Integer other) -&gt; Integer</code></pre>

ビットごとの排他的論理和を求める

ビットの xor。反転に使う。
```ruby
v ^ 0xFF
```

### Integer#[]

<pre class="fmrb-sig"><code>[](untyped index) -&gt; Integer</code></pre>

その位置のビットを返す

そのビットが 0 か 1 か。
```ruby
v[0]  # 一番下のビット
```

### Integer#abs

<pre class="fmrb-sig"><code>abs() -&gt; Integer</code></pre>

絶対値を返す

```ruby
d = (a - b).abs
```

### Integer#round

<pre class="fmrb-sig"><code>round(?Integer ndigits) -&gt; Integer</code></pre>

桁を丸める

**ndigits を省くか 0 以上なら自分自身**を返す。負なら 10 の位から丸めた Integer
(`1234.round(-2)` は 1200)。丸めたい桁が大きすぎると 0。
```ruby
1234.round(-2)   #=> 1200
```

### Integer#chr

<pre class="fmrb-sig"><code>chr() -&gt; <a href="../String/">String</a></code></pre>

文字コードに対応する 1 文字を返す

**0 から 255** の 1 バイト文字。
```ruby
65.chr  #=> "A"
```

### Integer#downto

<pre class="fmrb-sig"><code>downto(Integer limit) { (Integer block_limit) -&gt; untyped } -&gt; Integer</code></pre>

自分から引数まで 1 ずつ減らして実行

後ろから消していくときに使う。
```ruby
(a.length - 1).downto(0) do |i|
  a.delete_at(i) if drop?(a[i])
end
```

### Integer#times

<pre class="fmrb-sig"><code>times() { (Integer index) -&gt; untyped } -&gt; Integer</code></pre>

自分の回数だけブロックを実行する

**ブロック呼び出しは 1 回 0.4ms**。回数が多いところでは `while` に書きかえると効く。
```ruby
8.times do |i|
  draw(i)
end
```

### Integer#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

小数に変える

割り算の前に小数へ移すときに使う。
```ruby
r = a.to_f / b
```

### Integer#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; Integer</code></pre>

自分自身を整数として返す

そのまま返る。
```ruby
n.to_i
```

### Integer#to_s

<pre class="fmrb-sig"><code>to_s(?Integer base) -&gt; <a href="../String/">String</a></code></pre>

文字列に変える。基数は引数で指定

**基数を渡せる**。ログに 16 進で出すときに使う。
```ruby
255.to_s      #=> "255"
255.to_s(16)  #=> "ff"
```

### Integer#|

<pre class="fmrb-sig"><code>|(Integer other) -&gt; Integer</code></pre>

ビットごとの論理和を求める

ビットの or。旗を立てるのに使う。
```ruby
flags = flags | 0x04
```

### Integer#~

<pre class="fmrb-sig"><code>~() -&gt; Integer</code></pre>

ビットを反転する

**ビットをぜんぶ反転**する。旗を下ろすのに使う。
```ruby
flags = flags & ~0x04
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
