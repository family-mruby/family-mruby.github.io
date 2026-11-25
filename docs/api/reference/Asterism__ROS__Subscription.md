# Asterism::ROS::Subscription

A topic's subscription

How to use it: [Network](../network.md).

Messages that arrive are queued; take them with each_pending. When made with
node.subscribe, Node#poll takes them out and hands them to the block.

## Instance methods

### Asterism::ROS::Subscription#each_pending

<pre class="fmrb-sig"><code>each_pending() { (<a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a> msg, <a href="../Asterism__ROS__Attachment/">Asterism::ROS::Attachment</a>? info) -&gt; untyped } -&gt; <a href="../Integer/">Integer</a>
each_pending() -&gt; <a href="../Array/">Array</a>[<a href="../Array/">Array</a>[untyped]]</code></pre>

Take the messages that have arrived

Yields each decoded message and its attachment, and returns how many.
Without a block, returns an Array of `[msg, info]`. The attachment is
an Asterism::ROS::Attachment (nil when none). A sample that does
not decode is counted (errors) and skipped.
```ruby
sub.each_pending do |m, info|
  got(m)
end
```

### Asterism::ROS::Subscription#pending

<pre class="fmrb-sig"><code>pending() -&gt; <a href="../Integer/">Integer</a></code></pre>

Messages waiting now

```ruby
n = sub.pending
```

### Asterism::ROS::Subscription#received

<pre class="fmrb-sig"><code>received() -&gt; <a href="../Integer/">Integer</a></code></pre>

Messages received so far

```ruby
n = sub.received
```

### Asterism::ROS::Subscription#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

Messages dropped because the queue was full

```ruby
n = sub.dropped
```

### Asterism::ROS::Subscription#errors

<pre class="fmrb-sig"><code>errors() -&gt; <a href="../Integer/">Integer</a></code></pre>

Messages that did not decode

```ruby
n = sub.errors
```

### Asterism::ROS::Subscription#handler

<pre class="fmrb-sig"><code>handler() -&gt; <a href="../Proc/">Proc</a>?</code></pre>

The block of node.subscribe (nil for node.subscription)

```ruby
b = sub.handler
```

### Asterism::ROS::Subscription#handler=

<pre class="fmrb-sig"><code>handler=(<a href="../Proc/">Proc</a>? blk) -&gt; <a href="../Proc/">Proc</a>?</code></pre>

Set the block that gets the messages

Changes where Node#poll hands the messages.
**Only a subscription made by node.subscribe** is served by Node#poll (take from one made by
node.subscription with each_pending).
```ruby
sub.handler = proc { |m, i| got(m) }
```

### Asterism::ROS::Subscription#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Stop receiving

Returns nil.
```ruby
sub.close
```

### Asterism::ROS::Subscription#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
return if sub.closed?
```

### Asterism::ROS::Subscription#topic_key

<pre class="fmrb-sig"><code>topic_key() -&gt; <a href="../String/">String</a></code></pre>

The key the data comes on

```ruby
k = sub.topic_key
```

### Asterism::ROS::Subscription#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

The liveliness key

```ruby
k = sub.token_key
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
