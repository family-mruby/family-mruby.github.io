# Array

## クラスメソッド

### Array.new

<pre class="fmrb-sig"><code>new(?<a href="../Integer/">Integer</a> size, ?untyped object) -&gt; Array</code></pre>

配列を作る

**大きさを決めて確保しておく**と、伸ばしながら使うより速い。
2 つめは中身の初期値。
```ruby
a = Array.new
b = Array.new(16, 0)
```

## インスタンスメソッド

### Array#[]=

<pre class="fmrb-sig"><code>[]=(<a href="../Integer/">Integer</a> index, untyped value) -&gt; untyped
[]=(<a href="../Integer/">Integer</a> start, <a href="../Integer/">Integer</a> length, untyped value) -&gt; untyped</code></pre>

その位置に要素を入れる

**a[i], a[j] = a[j], a[i] は動かない** (picoruby の既知の穴)。入れかえは一時変数で書く。
```ruby
a[0] = 1
t = a[i]; a[i] = a[j]; a[j] = t
```

### Array#[]

<pre class="fmrb-sig"><code>[](<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

その位置の要素を返す

**負の数は末尾から**。範囲の外は nil で、例外にはならない。
```ruby
a[0]
a[-1]
```

### Array#&

<pre class="fmrb-sig"><code>&amp;(Array other) -&gt; self</code></pre>

両方にあるものだけの配列

両方にあるものだけを集める。
```ruby
[1, 2, 3] & [2, 3, 4]  #=> [2, 3]
```

### Array#+

<pre class="fmrb-sig"><code>+(Array other) -&gt; Array</code></pre>

配列をつなげる

**新しい配列ができる**。継ぎ足すだけなら `push`。
```ruby
c = a + b
```

### Array#-

<pre class="fmrb-sig"><code>-(Array other) -&gt; self</code></pre>

指定の要素を除いた配列を返す

相手にあるものを取り除く。
```ruby
[1, 2, 3] - [2]  #=> [1, 3]
```

### Array#push

<pre class="fmrb-sig"><code>push(untyped object) -&gt; Array</code></pre>

末尾に要素を足す

`<<` と同じ。自分が返るのでつなげられる。
```ruby
a.push(1)
a << 1
```

### Array#all?

<pre class="fmrb-sig"><code>all?(*untyped patterns) -&gt; bool
all?(*untyped patterns) { (untyped element) -&gt; untyped } -&gt; bool</code></pre>

ぜんぶ真かどうか

```ruby
ok = a.all? { |v| v > 0 }
```

### Array#at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

その位置の要素を返す

`[]` と同じ。
```ruby
a.at(2)
```

### Array#clear

<pre class="fmrb-sig"><code>clear() -&gt; Array</code></pre>

配列を空にする

**同じ配列を空にする**ので、他から持たれていても効く。
```ruby
a.clear
```

### Array#collect!

<pre class="fmrb-sig"><code>collect!() { (untyped element) -&gt; untyped } -&gt; Array[untyped]</code></pre>

要素ごとの結果で自分を置き換える

**自分を書き換える**。新しい配列は作らない。
```ruby
a.collect! { |v| v * 2 }
```

### Array#count

<pre class="fmrb-sig"><code>count() -&gt; <a href="../Integer/">Integer</a></code></pre>

要素の数を返す

`length` と同じ。
```ruby
n = a.count
```

### Array#delete_at

<pre class="fmrb-sig"><code>delete_at(<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

その位置の要素を消す

**後ろが詰まる**ので、回しながら消すと飛ばす。後ろから消す。
```ruby
v = a.delete_at(0)
```

### Array#delete_if

<pre class="fmrb-sig"><code>delete_if() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

ブロックが真になる要素を消す

```ruby
a.delete_if { |v| v.nil? }
```

### Array#each

<pre class="fmrb-sig"><code>each() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

要素ごとにブロックを実行する

**ブロック呼び出しは 1 回 0.4ms**。毎フレーム回る所では `while` と添字で書く方が速い。
```ruby
a.each do |v|
  draw(v)
end
```

### Array#each_index

<pre class="fmrb-sig"><code>each_index() { (<a href="../Integer/">Integer</a> index) -&gt; untyped } -&gt; self</code></pre>

添字ごとにブロックを実行する

```ruby
a.each_index { |i| p i }
```

### Array#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

配列が空かどうか

```ruby
return if a.empty?
```

### Array#first

<pre class="fmrb-sig"><code>first() -&gt; untyped</code></pre>

先頭の要素を返す

空なら nil。
```ruby
v = a.first
```

### Array#include?

<pre class="fmrb-sig"><code>include?(untyped object) -&gt; bool</code></pre>

その要素を含むかどうか

**前から順に見る**ので、長い配列では重い。回数が多いなら Hash を使う。
```ruby
if a.include?(v)
```

### Array#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

中身が分かる形の文字列を返す

```ruby
p a
```

### Array#join

<pre class="fmrb-sig"><code>join(?<a href="../String/">String</a> separator) -&gt; <a href="../String/">String</a></code></pre>

要素をつないだ文字列を返す

```ruby
a.join(", ")
```

### Array#last

<pre class="fmrb-sig"><code>last() -&gt; untyped</code></pre>

末尾の要素を返す

空なら nil。
```ruby
v = a.last
```

### Array#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

要素の数を返す

```ruby
n = a.length
```

### Array#max

<pre class="fmrb-sig"><code>max() -&gt; untyped
max() { (untyped left, untyped right) -&gt; untyped } -&gt; untyped</code></pre>

一番大きい要素

空なら nil。
```ruby
v = a.max
```

### Array#min

<pre class="fmrb-sig"><code>min() -&gt; untyped
min() { (untyped left, untyped right) -&gt; untyped } -&gt; untyped</code></pre>

一番小さい要素

空なら nil。
```ruby
v = a.min
```

### Array#pop

<pre class="fmrb-sig"><code>pop(?<a href="../Integer/">Integer</a> count) -&gt; (untyped | self)</code></pre>

末尾の要素を取り出す

**末尾から**取り出す。数を渡すとその数だけ配列で返る。
```ruby
v = a.pop
vs = a.pop(2)
```

### Array#reject

<pre class="fmrb-sig"><code>reject() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

ブロックが真の要素を除いた配列を返す

**真になったものを捨てる**。残したいものを書くなら `all?` ではなく条件を反転する。
```ruby
a.reject { |v| v < 0 }
```

### Array#reject!

<pre class="fmrb-sig"><code>reject!() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

ブロックが真の要素を自分から消す

**自分を書き換える**。
```ruby
a.reject! { |v| v.nil? }
```

### Array#select

<pre class="fmrb-sig"><code>select() { (untyped element) -&gt; untyped } -&gt; Array[untyped]</code></pre>

当てはまる要素だけを新しい配列で返す

ブロックが真を返した要素を集めた**新しい配列**を返す (もとの配列は変わらない)。
**ブロックが要る** (無いと NotImplementedError。この版は Enumerator を持たない)。
```ruby
ids = ids.select { |i| ok?(i) }
```

### Array#shift

<pre class="fmrb-sig"><code>shift(?<a href="../Integer/">Integer</a> count) -&gt; (untyped | self)</code></pre>

先頭の要素を取り出す

**先頭から**取り出す。待ち行列に使う。
```ruby
v = a.shift
```

### Array#sort

<pre class="fmrb-sig"><code>sort() -&gt; self
sort() { (untyped left, untyped right) -&gt; untyped } -&gt; self</code></pre>

並べ替えた配列を返す

**比べられないものが混ざると落ちる** (数と文字列など)。
```ruby
b = a.sort
```

### Array#sort!

<pre class="fmrb-sig"><code>sort!() -&gt; self
sort!() { (untyped left, untyped right) -&gt; untyped } -&gt; self</code></pre>

自分自身を並べ替える

**自分を並べ替える**。
```ruby
a.sort!
```

### Array#slice

<pre class="fmrb-sig"><code>slice(untyped index_or_range) -&gt; untyped</code></pre>

部分配列を返す

```ruby
a.slice(1, 2)
```

### Array#uniq

<pre class="fmrb-sig"><code>uniq() -&gt; self</code></pre>

重複を取り除いた配列を返す

**同じものを 1 つに**。順は最初に出た方が残る。
```ruby
b = a.uniq
```

### Array#uniq!

<pre class="fmrb-sig"><code>uniq!() -&gt; self</code></pre>

重複を自分から取り除く

**変わらなければ nil**。
```ruby
a.uniq!
```

### Array#unshift

<pre class="fmrb-sig"><code>unshift(untyped object) -&gt; Array</code></pre>

先頭に要素を足す

**先頭に足す**ので、後ろがぜんぶずれる。
```ruby
a.unshift(0)
```

### Array#|

<pre class="fmrb-sig"><code>|(Array other) -&gt; Array</code></pre>

つないで重複を消した配列

つないで重複を消す。
```ruby
[1, 2] | [2, 3]  #=> [1, 2, 3]
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
