# Asterism::ROS::Call

出したサービスの呼び出し (client.call_async の答え)

使い方は [ネットワーク](../network.md) のページにあります。

done? は待たない (Node#poll が進める)。value は答えが来るまで待つ。

## インスタンスメソッド

### Asterism::ROS::Call#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

答えが来たか (待たない)

```ruby
take(c.value) if c.done?
```

### Asterism::ROS::Call#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a></code></pre>

答え

`type::Response` を返す。待つ間はこのノードのサービスには答える。答えが無ければ Asterism::ROS::TimeoutError、セッションが閉じていれば
Asterism::Zenoh::ClosedError。
```ruby
r = c.value
```

### Asterism::ROS::Call#response

<pre class="fmrb-sig"><code>response() -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a>?</code></pre>

答え (待たずに見る)

```ruby
r = c.response
```

### Asterism::ROS::Call#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

要求の番号

```ruby
n = c.sequence
```

### Asterism::ROS::Call#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

答えまでの時間 (ms)

```ruby
ms = c.took_ms
```

### Asterism::ROS::Call#took

<pre class="fmrb-sig"><code>took() -&gt; <a href="../Float/">Float</a>?</code></pre>

答えまでの時間 (秒)

```ruby
s = c.took
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
