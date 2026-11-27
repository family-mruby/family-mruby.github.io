# Asterism::Error

Parent of every Asterism failure

How to use it: [Network](../network.md).

`rescue ::Asterism::Error` catches them all.

## Instance methods

### Asterism::Error#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

What went wrong

```ruby
rescue ::Asterism::Error => e
  show(e.message)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
