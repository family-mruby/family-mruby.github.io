# Asterism::ROS::Publisher

トピックに出す口 (node.publisher の答え)

使い方は [ネットワーク](../network.md) のページにあります。

出すのは `publish` か `<<`。メッセージは型のメッセージか、欄の Hash
(書かなかった欄は既定の値)。

## インスタンスメソッド

### Asterism::ROS::Publisher#publish

<pre class="fmrb-sig"><code>publish(untyped msg) -&gt; nil</code></pre>

メッセージを出す

msg は型のメッセージか欄の Hash。送る番号と時刻と GID を付ける。閉じていると Asterism::Zenoh::ClosedError。
```ruby
pub.publish({ data: "hi" })
```

### Asterism::ROS::Publisher#<<

<pre class="fmrb-sig"><code>&lt;&lt;(untyped msg) -&gt; Asterism::ROS::Publisher</code></pre>

メッセージを出す (つないで書ける)

```ruby
pub << { data: "hi" } << { data: "ho" }
```

### Asterism::ROS::Publisher#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じる

nil を返す。
```ruby
pub.close
```

### Asterism::ROS::Publisher#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

この口の GID

```ruby
g = pub.gid
```

### Asterism::ROS::Publisher#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

出した数

```ruby
n = pub.sequence
```

### Asterism::ROS::Publisher#topic_key

<pre class="fmrb-sig"><code>topic_key() -&gt; <a href="../String/">String</a></code></pre>

データのキー

```ruby
k = pub.topic_key
```

### Asterism::ROS::Publisher#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

liveliness のキー

```ruby
k = pub.token_key
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
