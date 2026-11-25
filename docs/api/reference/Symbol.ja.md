# Symbol

名前を表す Symbol (:name)

同じ名前は同じ物なので、比べるのは速い。ここに載せているのは `<=>`・`==`・
`===`・`inspect`・`to_sym`。Hash の印には String と別物として扱われる。

## インスタンスメソッド

### Symbol#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(Symbol | untyped other) -&gt; <a href="../Integer/">Integer</a></code></pre>

シンボルを比べる

```ruby
a <=> b
```

### Symbol#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

**同じ印は同じ物**なので、比べるのは速い。
```ruby
if k == :name
```

### Symbol#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

case での等しさを判定する

```ruby
case k
when :name then hit
end
```

### Symbol#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

中身が分かる形の文字列を返す

```ruby
p :name  #=> :name
```

### Symbol#to_sym

<pre class="fmrb-sig"><code>to_sym() -&gt; Symbol</code></pre>

自分自身をシンボルとして返す

そのまま返る。
```ruby
:name.to_sym
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
