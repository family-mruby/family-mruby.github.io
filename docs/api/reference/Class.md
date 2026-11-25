# Class

A class itself; read its name

Only `name` is listed here (`obj.class.name`). `const_defined?` and
`remove_method`, which take a class as the receiver, are on `Module`;
the copy for `Object` is on `Object`.

## Instance methods

### Class#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

Return class name as string

```ruby
obj.class.name
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
