# Asterism::ROS::Attachment

The attachment of a sample: sequence, time, publisher GID

How to use it: [Network](../network.md).

A reader on rmw_zenoh drops a sample without one. For a received message it is
handed to the subscribe block as info.

## Class methods

### Asterism::ROS::Attachment.new

<pre class="fmrb-sig"><code>new(
  <a href="../Integer/">Integer</a> sequence,
  <a href="../Integer/">Integer</a> stamp_ns,
  <a href="../String/">String</a> gid
) -&gt; Asterism::ROS::Attachment</code></pre>

Make an attachment

sequence (the number), stamp_ns (nanoseconds since 1970), gid (the
GID bytes).
```ruby
a = Asterism::ROS::Attachment.new(
  1, 0, "x" * 16)
```

### Asterism::ROS::Attachment.decode

<pre class="fmrb-sig"><code>decode(<a href="../String/">String</a>? bytes) -&gt; Asterism::ROS::Attachment?</code></pre>

Read an attachment from its bytes (nil when it is not one)

nil when fewer than 17 bytes or the GID is cut short.
```ruby
a = Asterism::ROS::Attachment.decode(b)
```

## Instance methods

### Asterism::ROS::Attachment#encode

<pre class="fmrb-sig"><code>encode() -&gt; <a href="../String/">String</a></code></pre>

The bytes that go on the wire

```ruby
b = a.encode
```

### Asterism::ROS::Attachment#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

The sequence number

```ruby
n = a.sequence
```

### Asterism::ROS::Attachment#stamp_ns

<pre class="fmrb-sig"><code>stamp_ns() -&gt; <a href="../Integer/">Integer</a></code></pre>

The source time in nanoseconds since 1970

```ruby
t = a.stamp_ns
```

### Asterism::ROS::Attachment#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

The publisher's GID

```ruby
g = a.gid
```

### Asterism::ROS::Attachment#deconstruct_keys

<pre class="fmrb-sig"><code>deconstruct_keys(untyped keys) -&gt; <a href="../Hash/">Hash</a></code></pre>

For pattern matching: {sequence:, stamp_ns:, gid:}

```ruby
case a in { sequence: n } then n end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
