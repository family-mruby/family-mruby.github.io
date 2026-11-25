# Asterism::ROS::Publisher

A topic's publisher (from node.publisher)

How to use it: [Network](../network.md).

Send with `publish` or `<<`. A message is a message of the type, or a Hash of
its fields (a field left out takes its default).

## Instance methods

### Asterism::ROS::Publisher#publish

<pre class="fmrb-sig"><code>publish(untyped msg) -&gt; nil</code></pre>

Publish a message

msg is a message of the type or a Hash of its fields. It adds a
sequence number, the time and the GID. Raises
Asterism::Zenoh::ClosedError when closed.
```ruby
pub.publish({ data: "hi" })
```

### Asterism::ROS::Publisher#<<

<pre class="fmrb-sig"><code>&lt;&lt;(untyped msg) -&gt; Asterism::ROS::Publisher</code></pre>

Publish a message and return the publisher

```ruby
pub << { data: "hi" } << { data: "ho" }
```

### Asterism::ROS::Publisher#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Withdraw the publisher

Returns nil.
```ruby
pub.close
```

### Asterism::ROS::Publisher#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

The publisher's GID (16 bytes)

```ruby
g = pub.gid
```

### Asterism::ROS::Publisher#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

The sequence number of the last publish

```ruby
n = pub.sequence
```

### Asterism::ROS::Publisher#topic_key

<pre class="fmrb-sig"><code>topic_key() -&gt; <a href="../String/">String</a></code></pre>

The key the data goes on

```ruby
k = pub.topic_key
```

### Asterism::ROS::Publisher#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

The liveliness key

```ruby
k = pub.token_key
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
