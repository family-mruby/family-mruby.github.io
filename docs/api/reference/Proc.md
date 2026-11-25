# Proc

A block held as a value

Normally made with `proc` or `->` and run with `call` (or `.()`). Under
Spinel it **cannot capture an outer local**, so pass what a stored Proc
needs as arguments.

## Class methods

### Proc.new

<pre class="fmrb-sig"><code>new() { (untyped argument) -&gt; untyped } -&gt; Proc</code></pre>

Make a Proc

Normally made with `proc` or `->`.
```ruby
f = Proc.new { |v| v * 2 }
```

## Instance methods

### Proc#call

<pre class="fmrb-sig"><code>call(*untyped arguments) -&gt; untyped</code></pre>

Call Proc

Can also be written `.()`.
```ruby
f.call(3)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
