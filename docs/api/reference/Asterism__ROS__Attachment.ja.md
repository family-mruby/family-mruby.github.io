# Asterism::ROS::Attachment

送り手が付ける添え物

使い方は [ネットワーク](../network.md) のページにあります。

rmw_zenoh の受け手はこれが無い値を捨てる。受け取ったメッセージの
info として subscribe のブロックに渡る。

## クラスメソッド

### Asterism::ROS::Attachment.new

<pre class="fmrb-sig"><code>new(
  <a href="../Integer/">Integer</a> sequence,
  <a href="../Integer/">Integer</a> stamp_ns,
  <a href="../String/">String</a> gid
) -&gt; Asterism::ROS::Attachment</code></pre>

作る

sequence (番号)、stamp_ns (時刻。1970 年からのナノ秒)、gid (GID のバイト列)。
```ruby
a = Asterism::ROS::Attachment.new(
  1, 0, "x" * 16)
```

### Asterism::ROS::Attachment.decode

<pre class="fmrb-sig"><code>decode(<a href="../String/">String</a>? bytes) -&gt; Asterism::ROS::Attachment?</code></pre>

バイト列から読む

17 バイトに満たない・GID が足りないと nil。
```ruby
a = Asterism::ROS::Attachment.decode(b)
```

## インスタンスメソッド

### Asterism::ROS::Attachment#encode

<pre class="fmrb-sig"><code>encode() -&gt; <a href="../String/">String</a></code></pre>

バイト列にする

```ruby
b = a.encode
```

### Asterism::ROS::Attachment#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

番号

```ruby
n = a.sequence
```

### Asterism::ROS::Attachment#stamp_ns

<pre class="fmrb-sig"><code>stamp_ns() -&gt; <a href="../Integer/">Integer</a></code></pre>

送り手の時刻 (ns)

```ruby
t = a.stamp_ns
```

### Asterism::ROS::Attachment#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

送り手の GID

```ruby
g = a.gid
```

### Asterism::ROS::Attachment#deconstruct_keys

<pre class="fmrb-sig"><code>deconstruct_keys(untyped keys) -&gt; <a href="../Hash/">Hash</a></code></pre>

パターンマッチ用

```ruby
case a in { sequence: n } then n end
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
