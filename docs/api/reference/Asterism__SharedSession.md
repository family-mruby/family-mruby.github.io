# Asterism::SharedSession

Extended onto each connection's session

How to use it: [Network](../network.md).

connection.session に付いて、接続以外からの close を無視させる。アプリが直接使うことはない。

## Instance methods

### Asterism::SharedSession#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

A close from anyone but the connection does nothing

Warns once and returns nil. Connection#close is what closes it.
```ruby
conn.session.close  # does nothing
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
