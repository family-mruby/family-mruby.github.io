# MessagePack

MessagePack で値をバイト列にし、戻す

使い方は [ユーティリティ](../utilities.md) のページにあります。

`pack` で Ruby の値を String (バイト列) にし、`unpack` で値に戻す。`dump`・`load` は同じものの別名。
```ruby
bin = MessagePack.pack({ "a" => [1, 2] })
MessagePack.unpack(bin)   #=> {"a"=>[1, 2]}
```

## クラスメソッド

### MessagePack.pack

<pre class="fmrb-sig"><code>pack(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

値をバイト列にする

書けるのは nil・true・false・Integer (64 ビットまで)・Float (常に倍精度)・String・Symbol・
Array・Hash。**Symbol は文字列として書く**ので、戻すと String になる (Hash のキーも同じ)。
`String#b` などでバイナリ印の付いた String は bin 型、普通の String は str 型で書く。

書けない型 (Range・独自のクラスなど) は RuntimeError ("Failed to pack object to msgpack")。
```ruby
bin = MessagePack.pack({ cmd: "go" })
```

### MessagePack.unpack

<pre class="fmrb-sig"><code>unpack(<a href="../String/">String</a> binary) -&gt; untyped</code></pre>

バイト列を値に戻す

渡す String は**ちょうど 1 つの値**。余りのバイトがある・途中で切れている・空・
ext 型や 2^63 以上の整数を含む、は RuntimeError ("Failed to unpack msgpack data")。
bin 型はバイナリ印の付いた String で戻る。
```ruby
v = MessagePack.unpack(bin)
```

### MessagePack.dump

<pre class="fmrb-sig"><code>dump(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

pack の別名

```ruby
bin = MessagePack.dump([1, 2])
```

### MessagePack.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> binary) -&gt; untyped</code></pre>

unpack の別名

```ruby
v = MessagePack.load(bin)
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
