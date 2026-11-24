# Asterism::ROS::Call

A service call on its way

How to use it: [Network](../network.md).

done? は待たない (Node#poll が進める)。value は答えが来るまで待つ。

## Instance methods

### Asterism::ROS::Call#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

Whether the response came, the time ran out or nobody serves it

```ruby
take(c.value) if c.done?
```

### Asterism::ROS::Call#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a></code></pre>

The response (waits until done)

Returns the `type::Response`. It answers this node's services while it
waits. Raises Asterism::ROS::TimeoutError without an answer,
Asterism::Zenoh::ClosedError when the session is closed.
```ruby
r = c.value
```

### Asterism::ROS::Call#response

<pre class="fmrb-sig"><code>response() -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a>?</code></pre>

The response so far (nil until it came)

```ruby
r = c.response
```

### Asterism::ROS::Call#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

The request's sequence number

```ruby
n = c.sequence
```

### Asterism::ROS::Call#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Milliseconds from the request to the end (nil until done)

```ruby
ms = c.took_ms
```

### Asterism::ROS::Call#took

<pre class="fmrb-sig"><code>took() -&gt; <a href="../Float/">Float</a>?</code></pre>

Seconds from the request to the end (nil until done)

```ruby
s = c.took
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
