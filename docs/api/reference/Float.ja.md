# Float

小数 (浮動小数点数)

`Integer` との四則・比較ができる。**小数どうしを `==` で比べない** (差の大きさで比べる)。
0.0 で割っても落ちず Infinity になる。`to_i` は切り捨てで、`round` は四捨五入。

## インスタンスメソッド

### Float#%

<pre class="fmrb-sig"><code>%(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

割ったあまりを求める

```ruby
5.5 % 2.0  #=> 1.5
```

### Float#*

<pre class="fmrb-sig"><code>*(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

かけ算をする

```ruby
x * 0.5
```

### Float#**

<pre class="fmrb-sig"><code>**(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

べき乗を求める

```ruby
2.0 ** 0.5
```

### Float#+

<pre class="fmrb-sig"><code>+(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

足し算をする

```ruby
x + 1.0
```

### Float#+@

<pre class="fmrb-sig"><code>+@() -&gt; Float</code></pre>

自分自身を返す (単項プラス)

```ruby
+x
```

### Float#-

<pre class="fmrb-sig"><code>-(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

引き算をする

```ruby
x - 1.0
```

### Float#-@

<pre class="fmrb-sig"><code>-@() -&gt; Float</code></pre>

符号を反転する (単項マイナス)

```ruby
-x
```

### Float#/

<pre class="fmrb-sig"><code>/(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

割り算をする

**0.0 で割っても落ちない** (Infinity になる)。
```ruby
x / 2.0
```

### Float#<

<pre class="fmrb-sig"><code>&lt;(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

より小さいかどうか

```ruby
if x < 1.0
```

### Float#<=

<pre class="fmrb-sig"><code>&lt;=(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

以下かどうか

```ruby
if x <= 1.0
```

### Float#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(<a href="../Integer/">Integer</a> | Float other) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

大小を比べて -1 / 0 / 1 を返す

```ruby
a <=> b
```

### Float#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

**小数どうしを == で比べない**。計算のたびに端が狂うので、差の大きさで比べる。
```ruby
(a - b).abs < 0.001
```

### Float#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

case での等しさを判定する

```ruby
case x
when 1.0 then hit
end
```

### Float#>

<pre class="fmrb-sig"><code>&gt;(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

より大きいかどうか

```ruby
if x > 0.0
```

### Float#>=

<pre class="fmrb-sig"><code>&gt;=(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

以上かどうか

```ruby
if x >= 0.0
```

### Float#abs

<pre class="fmrb-sig"><code>abs() -&gt; Float</code></pre>

絶対値を返す

```ruby
d = (a - b).abs
```

### Float#round

<pre class="fmrb-sig"><code>round(?<a href="../Integer/">Integer</a> ndigits) -&gt; (<a href="../Integer/">Integer</a> | Float)</code></pre>

四捨五入する

**ndigits を省くか 0 以下なら Integer、1 以上なら Float** を返す。ndigits が負なら
10 の位から丸める (`1234.5.round(-2)` は 1200)。**半分は 0 から遠い方へ**
(`2.5.round` は 3、`-2.5.round` は -3)。nan や無限大は FloatDomainError。
```ruby
3.14159.round(2)   #=> 3.14
2.5.round          #=> 3
```

### Float#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; Float</code></pre>

自分自身を小数として返す

そのまま返る。
```ruby
x.to_f
```

### Float#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

小数点以下を捨てて整数にする

**切り捨て**で、四捨五入ではない。負の数は 0 に近づく。
```ruby
1.9.to_i   #=> 1
(-1.9).to_i #=> -1
```

### Float#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

文字列に変える

```ruby
x.to_s
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
