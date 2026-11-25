# Asterism::AsyncProxy

The no-wait form of a proxy

How to use it: [Network](../network.md).

What Proxy#async answers. Calling a method gives back a Future.

## Instance methods

### Asterism::AsyncProxy#asterism_call

<pre class="fmrb-sig"><code>asterism_call(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  *untyped args,
  **untyped kw
) -&gt; <a href="../Asterism__Future/">Asterism::Future</a></code></pre>

Call a remote method by name, a Future at once

```ruby
f = board.async.asterism_call(
  "post", "hi")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
