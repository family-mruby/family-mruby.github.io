# Asterism::ROS::Timer

一定間隔のブロック (node.every の答え)

使い方は [ネットワーク](../network.md) のページにあります。

ブロックは Node#poll の中で呼ばれる。cancel で止める。

## インスタンスメソッド

### Asterism::ROS::Timer#cancel

<pre class="fmrb-sig"><code>cancel() -&gt; nil</code></pre>

止める

nil を返す。
```ruby
t.cancel
```

### Asterism::ROS::Timer#period

<pre class="fmrb-sig"><code>period() -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

周期 (秒)

```ruby
s = t.period
```

### Asterism::ROS::Timer#period_ms

<pre class="fmrb-sig"><code>period_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

周期 (ms)

```ruby
ms = t.period_ms
```

### Asterism::ROS::Timer#fired

<pre class="fmrb-sig"><code>fired() -&gt; <a href="../Integer/">Integer</a></code></pre>

動いた回数

```ruby
n = t.fired
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
