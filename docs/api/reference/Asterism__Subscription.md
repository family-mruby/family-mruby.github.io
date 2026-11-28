# Asterism::Subscription

A topic being subscribed to

How to use it: [Network](../network.md).

What conn.subscribe answers.

## Instance methods

### Asterism::Subscription#close

<pre class="fmrb-sig"><code>close() -&gt; bool</code></pre>

Stop receiving

```ruby
@sub.close
```

### Asterism::Subscription#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
@sub.closed?
```

### Asterism::Subscription#received

<pre class="fmrb-sig"><code>received() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many values came so far

```ruby
n = @sub.received
```

### Asterism::Subscription#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

The path it receives ("<node>/<app>/<topic>")

```ruby
p = @sub.path
```

### Asterism::Subscription#connection

<pre class="fmrb-sig"><code>connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

The connection it belongs to

```ruby
c = @sub.connection
```

### Asterism::Subscription#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

Values the queue had no room for

Values dropped because more than `depth:` came between two updates.
```ruby
warn_gap if @sub.dropped > 0
```

### Asterism::Subscription#malformed

<pre class="fmrb-sig"><code>malformed() -&gt; <a href="../Integer/">Integer</a></code></pre>

Values left out because they were not MessagePack

Values left out: no encoding, and not one MessagePack value.
```ruby
bad = @sub.malformed
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
