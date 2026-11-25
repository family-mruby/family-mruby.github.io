# Asterism::SharedSession

Extended onto each connection's session

How to use it: [Network](../network.md).

Attached to connection.session so that a close from anything but the connection
is ignored. Apps do not use it directly.

## Instance methods

### Asterism::SharedSession#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

A close from anyone but the connection does nothing

Warns once and returns nil. Connection#close is what closes it.
```ruby
conn.session.close  # does nothing
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
