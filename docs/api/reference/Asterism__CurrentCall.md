# Asterism::CurrentCall

The call being answered now

How to use it: [Network](../network.md).

What conn.current_call answers.

## Instance methods

### Asterism::CurrentCall#from

<pre class="fmrb-sig"><code>from() -&gt; <a href="../String/">String</a></code></pre>

The calling machine's node ID

```ruby
who = @link.conn.current_call.from
```

### Asterism::CurrentCall#object

<pre class="fmrb-sig"><code>object() -&gt; <a href="../String/">String</a></code></pre>

The exposed object's name

```ruby
o = call.object
```

### Asterism::CurrentCall#method

<pre class="fmrb-sig"><code>method() -&gt; <a href="../String/">String</a></code></pre>

The method's name

```ruby
m = call.method
```

### Asterism::CurrentCall#verified

<pre class="fmrb-sig"><code>verified() -&gt; (:claimed | :local)</code></pre>

How far the caller's name is checked

:claimed is the name the caller gave itself (the router's access
control is what makes it binding). :local is a call from this same
app.
```ruby
trust = conn.current_call.verified
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
