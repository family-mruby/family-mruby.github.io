# Asterism::ROS::Message

メッセージの土台 (生成した型の親)

使い方は [ネットワーク](../network.md) のページにあります。

型ごとに ROS_NAME・欄ごとの読み書きができる。欄は Hash か型の `new(欄: 値)` で渡せる (書かない欄は既定の値、知らない欄は ArgumentError)。パターンマッチでも読める (`case m in { x: }`)。

## クラスメソッド

### Asterism::ROS::Message.from

<pre class="fmrb-sig"><code>from(untyped v) -&gt; Asterism::ROS::Message</code></pre>

メッセージにする

nil は全部既定、Hash は欄 (キーは Symbol か String。書かない欄は既定、知らない欄は ArgumentError)、同じ型のメッセージならそのまま返す。
Hash でもメッセージでもなければ TypeError。生成した型 (`require_type` が返す)
のクラスメソッド。
```ruby
t = Asterism::ROS.require_type(
  "std_msgs/msg/String")
m = t.from({ data: "hi" })
```

### Asterism::ROS::Message.encode

<pre class="fmrb-sig"><code>encode(untyped msg) -&gt; <a href="../String/">String</a></code></pre>

CDR のバイト列にする

```ruby
b = t.encode({ data: "hi" })
```

### Asterism::ROS::Message.decode

<pre class="fmrb-sig"><code>decode(<a href="../String/">String</a> bytes) -&gt; Asterism::ROS::Message</code></pre>

CDR のバイト列から読む

形が合わないと Asterism::CDR::DecodeError。
```ruby
m = t.decode(b)
```

## インスタンスメソッド

### Asterism::ROS::Message#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

欄の Hash にする

```ruby
h = m.to_h
```

### Asterism::ROS::Message#deconstruct_keys

<pre class="fmrb-sig"><code>deconstruct_keys(untyped keys) -&gt; <a href="../Hash/">Hash</a></code></pre>

パターンマッチ用

入れ子のメッセージはメッセージのまま。
```ruby
case m in { data: d } then show(d) end
```

### Asterism::ROS::Message#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

同じ型で欄が同じか

```ruby
same = m1 == m2
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
