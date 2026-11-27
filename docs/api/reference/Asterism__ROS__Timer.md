# Asterism::ROS::Timer

A repeating timer (from node.every)

How to use it: [Network](../network.md).

The block runs inside Node#poll. Stop it with cancel.

## Instance methods

### Asterism::ROS::Timer#cancel

<pre class="fmrb-sig"><code>cancel() -&gt; nil</code></pre>

Stop the timer

Returns nil.
```ruby
t.cancel
```

### Asterism::ROS::Timer#period

<pre class="fmrb-sig"><code>period() -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

The period in seconds

```ruby
s = t.period
```

### Asterism::ROS::Timer#period_ms

<pre class="fmrb-sig"><code>period_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

The period in milliseconds

```ruby
ms = t.period_ms
```

### Asterism::ROS::Timer#fired

<pre class="fmrb-sig"><code>fired() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the block ran

```ruby
n = t.fired
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
