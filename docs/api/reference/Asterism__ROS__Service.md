# Asterism::ROS::Service

A served service (from node.service)

How to use it: [Network](../network.md).

Node#poll answers the requests by calling handle_pending. Without a node you
may call handle_pending yourself.

## Instance methods

### Asterism::ROS::Service#handle_pending

<pre class="fmrb-sig"><code>handle_pending() -&gt; <a href="../Integer/">Integer</a></code></pre>

Answer the requests waiting now

Decodes each request to the type's Request, calls the block given to
node.service and sends the answer. A request that does not decode, or
has no attachment, is counted (errors) and not answered. A request
whose block raised ends unanswered and the exception comes out
here. Returns how many were answered.
```ruby
n = srv.handle_pending
```

### Asterism::ROS::Service#handled

<pre class="fmrb-sig"><code>handled() -&gt; <a href="../Integer/">Integer</a></code></pre>

Requests answered so far

```ruby
n = srv.handled
```

### Asterism::ROS::Service#errors

<pre class="fmrb-sig"><code>errors() -&gt; <a href="../Integer/">Integer</a></code></pre>

Requests that could not be taken

```ruby
n = srv.errors
```

### Asterism::ROS::Service#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Withdraw the service

Returns nil.
```ruby
srv.close
```

### Asterism::ROS::Service#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
return if srv.closed?
```

### Asterism::ROS::Service#service_key

<pre class="fmrb-sig"><code>service_key() -&gt; <a href="../String/">String</a></code></pre>

The key the service is served on

```ruby
k = srv.service_key
```

### Asterism::ROS::Service#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

The liveliness key

```ruby
k = srv.token_key
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
