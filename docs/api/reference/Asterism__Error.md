# Asterism::Error

やり取りの失敗の元 (rescue ::Asterism::Error で全部受かる)

How to use it: [Network](../network.md).

## Instance methods

### Asterism::Error#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

What went wrong

```ruby
rescue ::Asterism::Error => e
  show(e.message)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
