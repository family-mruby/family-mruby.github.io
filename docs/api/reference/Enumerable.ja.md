# Enumerable

each を持つものに混ぜる繰り返しの道具

`Array`・`Hash` が取り込み、`Range` が継承している。ここに載せているのは `each`・
`each_with_index`・`map`・`to_a`。`map` は新しい配列を作る (自分を書き換えるのは `collect!`)。

## インスタンスメソッド

### Enumerable#each

<pre class="fmrb-sig"><code>each() { (untyped item) -&gt; untyped } -&gt; untyped</code></pre>

要素ごとにブロックを実行する

```ruby
obj.each { |v| p v }
```

### Enumerable#each_with_index

<pre class="fmrb-sig"><code>each_with_index() { (untyped item, <a href="../Integer/">Integer</a> index) -&gt; untyped } -&gt; untyped</code></pre>

要素と番号でブロックを実行する

**ブロックは値と番号の 2 つ**を受け取る。
```ruby
a.each_with_index do |v, i|
  draw(i, v)
end
```

### Enumerable#map

<pre class="fmrb-sig"><code>map() { (untyped item) -&gt; untyped } -&gt; <a href="../Array/">Array</a></code></pre>

要素ごとの結果を集めた配列を返す

**新しい配列ができる**。自分を書き換えるなら `collect!`。
```ruby
b = a.map { |v| v * 2 }
```

### Enumerable#to_a

<pre class="fmrb-sig"><code>to_a() -&gt; <a href="../Array/">Array</a></code></pre>

配列にする

```ruby
a = obj.to_a
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
