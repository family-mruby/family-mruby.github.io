# NilClass

nil の型。「値が無い」を表す

偽として扱われる。`nil?` で調べる。`to_i` は 0、`to_f` は 0.0、`to_s` は空文字列、
`to_h` は空の Hash になるので、読めなかった値をそのまま足せる。

## インスタンスメソッド

### NilClass#!

<pre class="fmrb-sig"><code>!() -&gt; bool</code></pre>

真偽を反転する

nil は偽なので必ず true。
```ruby
!nil  #=> true
```

### NilClass#&

<pre class="fmrb-sig"><code>&amp;(untyped other) -&gt; bool</code></pre>

常に false を返す

```ruby
nil & true  #=> false
```

### NilClass#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

case での等しさを判定する

```ruby
case v
when nil then missing
end
```

### NilClass#^

<pre class="fmrb-sig"><code>^(untyped other) -&gt; bool</code></pre>

引数の真偽を返す

```ruby
nil ^ true  #=> true
```

### NilClass#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

"nil" という文字列を返す

```ruby
p nil  #=> nil
```

### NilClass#nil?

<pre class="fmrb-sig"><code>nil?() -&gt; bool</code></pre>

常に true を返す

**nil かどうかを調べる書き方**。
```ruby
return if v.nil?
```

### NilClass#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

0.0 を返す

```ruby
nil.to_f  #=> 0.0
```

### NilClass#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

空のハッシュを返す

```ruby
nil.to_h  #=> {}
```

### NilClass#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

0 を返す

**0 になる**ので、読めなかった値をそのまま足せる。
```ruby
nil.to_i  #=> 0
```

### NilClass#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

空の文字列を返す

**空文字列**になる。"nil" ではない。
```ruby
nil.to_s  #=> ""
```

### NilClass#|

<pre class="fmrb-sig"><code>|(untyped other) -&gt; bool</code></pre>

引数の真偽を返す

```ruby
nil | true  #=> true
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
