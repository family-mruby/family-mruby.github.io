# Asterism::ROS::Client

A service client (from node.client)

How to use it: [Network](../network.md).

Call with call (waits for the answer) or call_async (returns a Call at once).

## Instance methods

### Asterism::ROS::Client#call_async

<pre class="fmrb-sig"><code>call_async(
  ?untyped req,
  ?request: untyped,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?,
  **untyped fields
) -&gt; <a href="../Asterism__ROS__Call/">Asterism::ROS::Call</a></code></pre>

Send a request and get a Call at once

The request and `timeout:` / `timeout_ms:` are as in Node#call (2 s
when left out). It does not wait: keep polling the node, look at
Call#done? and take value once it is true. Raises
Asterism::Zenoh::ClosedError when closed.
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

Send a request and wait for the response

Arguments as in call_async. Returns the response (`type::Response`).
**The app waits**, still answering this node's services meanwhile.
Raises Asterism::ROS::TimeoutError when nothing answers in time (or
nobody serves it).
```ruby
r = cli.call(a: 2, b: 3)
puts r.sum
```

### Asterism::ROS::Client#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Withdraw the client

Returns nil.
```ruby
cli.close
```

### Asterism::ROS::Client#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
return if cli.closed?
```

### Asterism::ROS::Client#session_closed?

<pre class="fmrb-sig"><code>session_closed?() -&gt; bool</code></pre>

Whether the session underneath is closed

```ruby
return if cli.session_closed?
```

### Asterism::ROS::Client#sequence

<pre class="fmrb-sig"><code>sequence() -&gt; <a href="../Integer/">Integer</a></code></pre>

The sequence number of the last request

```ruby
n = cli.sequence
```

### Asterism::ROS::Client#gid

<pre class="fmrb-sig"><code>gid() -&gt; <a href="../String/">String</a></code></pre>

The client's GID (16 bytes)

```ruby
g = cli.gid
```

### Asterism::ROS::Client#service_name

<pre class="fmrb-sig"><code>service_name() -&gt; <a href="../String/">String</a></code></pre>

The service's full name

```ruby
n = cli.service_name
```

### Asterism::ROS::Client#service_key

<pre class="fmrb-sig"><code>service_key() -&gt; <a href="../String/">String</a></code></pre>

The key the requests go on

```ruby
k = cli.service_key
```

### Asterism::ROS::Client#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

The liveliness key

```ruby
k = cli.token_key
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
