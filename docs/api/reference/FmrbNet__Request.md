# FmrbNet::Request

One fetch (what FmrbNet.request returns)

How to use it: [Network](../network.md).

Check `done?` in `on_update`, and once it is true read `ok?` and `body`.
```ruby
if @req && @req.done?
  use(@req.body) if @req.ok?
  @req = nil
end
```

## Instance methods

### FmrbNet::Request#url

<pre class="fmrb-sig"><code>url() -&gt; <a href="../String/">String</a></code></pre>

The URL asked for

```ruby
@req.url
```

### FmrbNet::Request#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

Whether it has finished

true after a failure too. **The result (`status`, `body`, `error`) is settled when `done?`**
**first sees the end**, so read it only after `done?` is true.
```ruby
return unless @req.done?
```

### FmrbNet::Request#ok?

<pre class="fmrb-sig"><code>ok?() -&gt; bool</code></pre>

Succeeded (HTTP 2xx)

false when it has not finished (it calls `done?`) and when there is an `error`.
```ruby
@req.ok?
```

### FmrbNet::Request#status

<pre class="fmrb-sig"><code>status() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The HTTP status code

nil until it finishes, and after a failed connection.
```ruby
@req.status   #=> 200
```

### FmrbNet::Request#body

<pre class="fmrb-sig"><code>body() -&gt; <a href="../String/">String</a>?</code></pre>

The body that came back

nil until it finishes, and after a failure.
```ruby
text = @req.body
```

### FmrbNet::Request#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

Why it failed

nil on success. A short text: could not reach, no answer, `cancel`led ("cancelled"), and so on.
```ruby
Log.warn(@req.error) if @req.error
```

### FmrbNet::Request#cancel

<pre class="fmrb-sig"><code>cancel() -&gt; nil</code></pre>

Stop caring about the answer

Safe to call more than once. From then on `done?` is true and `error` is "cancelled"
(an earlier reason stays). Returns nil.
```ruby
@req.cancel
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
