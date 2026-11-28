# Exception

The base class of every exception

A bare `rescue => e` catches `StandardError` and its subclasses. Naming `Exception`
also catches running out of memory (`NoMemoryError`) and of stack (`SystemStackError`).

## Class methods

### Exception.new

<pre class="fmrb-sig"><code>new(?<a href="../String/">String</a> message) -&gt; Exception</code></pre>

Make an exception

Usually written `raise ArgumentError, "bad size"`; `new` is seldom called directly.
Without a text, `message` is the name of the class.

```ruby
e = RuntimeError.new("no map")
e.message   #=> "no map"
```

## Instance methods

### Exception#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

The exception's text

```ruby
begin
  Integer("x")
rescue => e
  show(e.message)
end
```

### Exception#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

The exception's text (same as message)

```ruby
puts e.to_s
```

### Exception#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

The text with the class name

Suited to a log line.

```ruby
Log.error(e.inspect)
```

### Exception#backtrace

<pre class="fmrb-sig"><code>backtrace() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]?</code></pre>

Where the exception was raised

An Array of "file:line" strings; nil or empty when the place is not known.

```ruby
bt = e.backtrace
Log.error(bt[0]) if bt && bt[0]
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
