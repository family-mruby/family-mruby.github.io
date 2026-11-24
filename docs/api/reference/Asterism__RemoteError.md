# Asterism::RemoteError

相手のメソッドが例外を出した・呼べなかった

How to use it: [Network](../network.md).

Inherits from: [`Asterism::Error`](Asterism__Error.md)

## Class methods

### Asterism::RemoteError.new

<pre class="fmrb-sig"><code>new(
  <a href="../String/">String</a> remote_class,
  <a href="../String/">String</a> remote_message,
  ?<a href="../String/">String</a>? remote_kind
) -&gt; Asterism::RemoteError</code></pre>

Make one (the answers of the other machine are turned into these)

```ruby
e = Asterism::RemoteError.new(
  "NameError", "x", "no_object")
```

## Instance methods

### Asterism::RemoteError#remote_class

<pre class="fmrb-sig"><code>remote_class() -&gt; <a href="../String/">String</a></code></pre>

The class name of the error over there

```ruby
rescue ::Asterism::RemoteError => e
  show(e.remote_class)
```

### Asterism::RemoteError#remote_message

<pre class="fmrb-sig"><code>remote_message() -&gt; <a href="../String/">String</a></code></pre>

The error's message over there

```ruby
show(e.remote_message)
```

### Asterism::RemoteError#remote_kind

<pre class="fmrb-sig"><code>remote_kind() -&gt; <a href="../String/">String</a>?</code></pre>

What happened ("raised", "not_exposed", "arguments", ...)

"raised": the method raised. "not_exposed": not an exposed method.
"no_object": no such object. "arguments": wrong number of
arguments. "unsendable": it returned a value that cannot travel.
```ruby
if e.remote_kind == "not_exposed"
  show("not callable")
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
