# Asterism::ROS::Client

サービスの Client (node.client の答え)

使い方は [ネットワーク](../network.md) のページにあります。

呼ぶのは call (答えを待つ) か call_async (すぐ Call が返る)。

## インスタンスメソッド

### Asterism::ROS::Client#call_async

<pre class="fmrb-sig"><code>call_async(
  ?untyped req,
  ?request: untyped,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?,
  **untyped fields
) -&gt; <a href="../Asterism__ROS__Call/">Asterism::ROS::Call</a></code></pre>

要求を送ってすぐ戻る

要求の渡し方と `timeout:`・`timeout_ms:` は Node#call と同じ
(省略すると 2 秒)。待たないので、Node#poll を回しながら
Call#done? を見て、true になったら value を取る。閉じていると
Asterism::Zenoh::ClosedError。
```ruby
c = cli.call_async(a: 2, b: 3)
# later: c.value if c.done?
```

### Asterism::ROS::Client#call

<pre class="fmrb-sig"><code>call(
  ?untyped req,
  ?request: untyped,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?,
  **untyped fields
) -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a></code></pre>

要求を送って答えを待つ

渡し方は call_async と同じ。答え (`type::Response`) を返す。
**待つ間アプリは止まる**が、このノードのサービスには答える。時間内に答えが無い (または誰も提供していない) と Asterism::ROS::TimeoutError。
```ruby
r = cli.call(a: 2, b: 3)
puts r.sum
```

### Asterism::ROS::Client#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じる

nil を返す。
```ruby
cli.close
```

### Asterism::ROS::Client#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

閉じたか

```ruby
return if cli.closed?
```

### Asterism::ROS::Client#session_closed?

<pre class="fmrb-sig"><code>session_closed?() -&gt; bool</code></pre>

セッションが閉じたか

```ruby
return if cli.session_closed?
```

### Asterism::ROS::Client#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

出した要求の数

```ruby
n = cli.sequence
```

### Asterism::ROS::Client#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

このクライアントの GID

```ruby
g = cli.gid
```

### Asterism::ROS::Client#service_name

<pre class="fmrb-sig"><code>service_name() -&gt; <a href="../String/">String</a></code></pre>

サービスの完全な名前

```ruby
n = cli.service_name
```

### Asterism::ROS::Client#service_key

<pre class="fmrb-sig"><code>service_key() -&gt; <a href="../String/">String</a></code></pre>

サービスのキー

```ruby
k = cli.service_key
```

### Asterism::ROS::Client#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

liveliness のキー

```ruby
k = cli.token_key
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
