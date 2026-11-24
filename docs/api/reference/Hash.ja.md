# Hash

印 (キー) で値を引く表

`Enumerable` を取り込む。無い印は nil で、例外にならず、既定値は渡せない。
String の印と Symbol の印は別物。`each_key` はブロックが要る (この版は Enumerator を持たない)。

## クラスメソッド

### Hash.new

<pre class="fmrb-sig"><code>new() -&gt; Hash</code></pre>

空の Hash を作る

**既定値は渡せない** (無い印はいつも nil)。
```ruby
h = Hash.new
h = {}
```

## インスタンスメソッド

### Hash#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

```ruby
if h == other
```

### Hash#[]

<pre class="fmrb-sig"><code>[](untyped key) -&gt; untyped</code></pre>

そのキーの値を返す

**無い印は nil**。落ちない。
```ruby
h[:name]
h["name"]
```

### Hash#[]=

<pre class="fmrb-sig"><code>[]=(untyped key, untyped value) -&gt; self</code></pre>

そのキーに値を入れる

**印は文字列と Symbol で別物**。混ぜると引けなくなる。
```ruby
h[:name] = "a"
```

### Hash#clear

<pre class="fmrb-sig"><code>clear() -&gt; Hash</code></pre>

ハッシュを空にする

```ruby
h.clear
```

### Hash#delete

<pre class="fmrb-sig"><code>delete(untyped key) -&gt; (untyped | nil)</code></pre>

そのキーを消す

消した値が返る。無ければ nil。
```ruby
v = h.delete(:name)
```

### Hash#each

<pre class="fmrb-sig"><code>each() { (untyped key, untyped value) -&gt; untyped } -&gt; self</code></pre>

キーと値の組ごとにブロックを実行する

**ブロックは印と値の 2 つ**を受け取る。
```ruby
h.each do |k, v|
  puts k.to_s + "=" + v.to_s
end
```

### Hash#each_key

<pre class="fmrb-sig"><code>each_key() { (untyped key) -&gt; untyped } -&gt; self</code></pre>

キーを 1 つずつ渡す

**ブロックが要る** (無いと NotImplementedError。この版は Enumerator を持たない)。自分自身を返す。
```ruby
h.each_key { |k| p k }
```

### Hash#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

ハッシュが空かどうか

```ruby
return if h.empty?
```

### Hash#has_key?

<pre class="fmrb-sig"><code>has_key?(untyped key) -&gt; bool</code></pre>

そのキーがあるかどうか

**値が nil の印**と、印が無いのを見分けるときに使う。
```ruby
if h.has_key?(:name)
```

### Hash#key?

<pre class="fmrb-sig"><code>key?(untyped key) -&gt; bool</code></pre>

そのキーがあるか

`has_key?` と同じ。
```ruby
@titles.key?(room)
```

### Hash#has_value?

<pre class="fmrb-sig"><code>has_value?(untyped value) -&gt; bool</code></pre>

その値があるかどうか

全部見るので重い。
```ruby
if h.has_value?(v)
```

### Hash#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

中身が分かる形の文字列を返す

```ruby
p h
```

### Hash#key

<pre class="fmrb-sig"><code>key(untyped value) -&gt; (untyped | nil)</code></pre>

値から印を逆に引く

値から印を逆に引く。無ければ nil。
```ruby
k = h.key(v)
```

### Hash#keys

<pre class="fmrb-sig"><code>keys() -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

キーを全部配列で返す

**新しい配列ができる**。
```ruby
h.keys.each { |k| p k }
```

### Hash#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

要素の数を返す

```ruby
n = h.length
```

### Hash#merge

<pre class="fmrb-sig"><code>merge(Hash other) -&gt; self</code></pre>

他のハッシュと合わせた新しいハッシュを返す

**同じ印は相手が勝つ**。設定の上書きに使う。
```ruby
conf = defaults.merge(user)
```

### Hash#merge!

<pre class="fmrb-sig"><code>merge!(Hash other) -&gt; self</code></pre>

自分に他のハッシュを取り込む

**自分に混ぜる**。
```ruby
conf.merge!(user)
```

### Hash#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; self</code></pre>

自分自身をハッシュとして返す

そのまま返る。
```ruby
h.to_h
```

### Hash#values

<pre class="fmrb-sig"><code>values() -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

値を全部配列で返す

```ruby
h.values.each { |v| p v }
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
