# Asterism::Proxy

Stand-in for an object on another machine

How to use it: [Network](../network.md).

What conn[path] answers. Call the published methods like ordinary
methods (`board.post("hi")`). A call waits for the answer.

## Instance methods

### Asterism::Proxy#async

<pre class="fmrb-sig"><code>async() -&gt; <a href="../Asterism__AsyncProxy/">Asterism::AsyncProxy</a></code></pre>

The same object, with calls that do not wait

Each call returns an Asterism::Future at once. Look at done? in
every update and take value once it is true.
```ruby
@call = @board.async.post("hi")
# on_update:
if @call && @call.done?
  n = @call.value
  @call = nil
end
```

### Asterism::Proxy#asterism_call

<pre class="fmrb-sig"><code>asterism_call(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  *untyped args,
  **untyped kw
) -&gt; untyped</code></pre>

Call a remote method by its name

Normally just write `board.post("hi")`. For names Ruby cannot write
or that Object already has (class, display, ...).
```ruby
v = board.asterism_call("post", "hi")
```

### Asterism::Proxy#asterism_path

<pre class="fmrb-sig"><code>asterism_path() -&gt; <a href="../String/">String</a></code></pre>

The path, "node/app/object"

```ruby
node = px.asterism_path.split("/")[0]
```

### Asterism::Proxy#remote_methods

<pre class="fmrb-sig"><code>remote_methods() -&gt; <a href="../Array/">Array</a>[<a href="../Symbol/">Symbol</a>]</code></pre>

The exposed methods (asks the other machine once)

Waits for the answer; raises Asterism::Error without one.
```ruby
names = board.remote_methods
```

### Asterism::Proxy#asterism_connection

<pre class="fmrb-sig"><code>asterism_connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

The connection the calls go out on

```ruby
c = board.asterism_connection
```

### Asterism::Proxy#asterism_meta

<pre class="fmrb-sig"><code>asterism_meta() -&gt; <a href="../Hash/">Hash</a></code></pre>

The meta of the object (asked once, then kept)

`{"methods" => [{"name" => ..., "arity" => ...}, ...]}`. The first
call asks the other machine and waits. Raises Asterism::TimeoutError
or Asterism::RemoteError ("no_object") without an answer,
Asterism::Disconnected when closed.
```ruby
m = board.asterism_meta
```

### Asterism::Proxy#asterism_refresh

<pre class="fmrb-sig"><code>asterism_refresh() -&gt; Asterism::Proxy</code></pre>

Forget the kept meta (the object may be exposed again)

The next asterism_meta or remote_methods asks again. Returns itself.
```ruby
board.asterism_refresh
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
