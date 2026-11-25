# Asterism::Future

The answer of a no-wait call

How to use it: [Network](../network.md).

It arrives later.

## Instance methods

### Asterism::Future#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

Whether the answer came, or the time ran out (never waits)

Also true once the time ran out or the connection closed (value
raises then).
```ruby
if @call.done?
  take(@call.value)
end
```

### Asterism::Future#value

<pre class="fmrb-sig"><code>value() -&gt; untyped</code></pre>

The answer (raises what the call failed with)

Waits when called before done?. Raises Asterism::RemoteError (it
raised there) or Asterism::TimeoutError.
```ruby
begin
  n = @call.value
rescue ::Asterism::Error => e
  show(e.message)
end
```

### Asterism::Future#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Milliseconds from the call to its answer (nil until done)

```ruby
ms = @call.took_ms
```

### Asterism::Future#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

The object's path, "node/app/object"

```ruby
p = @call.path
```

### Asterism::Future#method_name

<pre class="fmrb-sig"><code>method_name() -&gt; <a href="../String/">String</a></code></pre>

The name of the method that was called

```ruby
m = @call.method_name
```

### Asterism::Future#took

<pre class="fmrb-sig"><code>took() -&gt; <a href="../Float/">Float</a>?</code></pre>

Seconds from the call to its answer (nil until done)

```ruby
s = @call.took
```

### Asterism::Future#raw_value

<pre class="fmrb-sig"><code>raw_value() -&gt; untyped</code></pre>

The decoded answer as it is

The answer as the Hash it came in ({"value" => ...} or
{"error" => ...}). Waits like value; Asterism::TimeoutError on a time
out, Asterism::Disconnected when closed, Asterism::Error for an
unreadable answer. Normally use value.
```ruby
raw = @call.raw_value
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
