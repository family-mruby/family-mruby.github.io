# Range

範囲 (1..3 や 1...3)

継承元: [`Enumerable`](Enumerable.md)

`each` でたどれる。`...` でも `last` は書いた方の端を返す (最後の要素ではない)。
`===` は `case` の `when` で使われる。ブロックを取るメソッドは 1 回約 0.4ms なので、重い所では `while` に書きかえる。

## クラスメソッド

### Range.new

<pre class="fmrb-sig"><code>new(untyped first, untyped last, ?bool exclude_end) -&gt; Range</code></pre>

範囲を作る

普通は `1..5` と書く。
```ruby
r = Range.new(1, 5)
```

## インスタンスメソッド

### Range#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

```ruby
if r == other
```

### Range#===

<pre class="fmrb-sig"><code>===(untyped object) -&gt; bool</code></pre>

範囲に含まれるかどうか

**case で使われる形**。
```ruby
case n
when 0..9 then digit
end
```

### Range#exclude_end?

<pre class="fmrb-sig"><code>exclude_end?() -&gt; bool</code></pre>

終わりの値を含まない範囲かどうか

`...` で作ったなら true。
```ruby
(0...3).exclude_end?  #=> true
```

### Range#first

<pre class="fmrb-sig"><code>first() -&gt; untyped</code></pre>

範囲の始まりの値を返す

```ruby
(1..5).first  #=> 1
```

### Range#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

中身が分かる形の文字列を返す

```ruby
p (1..5)
```

### Range#last

<pre class="fmrb-sig"><code>last() -&gt; untyped</code></pre>

範囲の終わりの値を返す

**`...` でも書いた方の端**が返る (最後の要素ではない)。
```ruby
(1...5).last  #=> 5
```

### Range#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

文字列にして返す

```ruby
(1..5).to_s
```

### Range#each

<pre class="fmrb-sig"><code>each() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

範囲の要素ごとにブロックを実行する

**ブロック呼び出しは 1 回 0.4ms**。重いところでは `while` に書きかえる。
```ruby
(0..7).each do |i|
  draw(i)
end
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
