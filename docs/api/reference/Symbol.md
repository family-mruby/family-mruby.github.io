# Symbol

## Instance methods

### Symbol#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(Symbol | untyped other) -&gt; <a href="../Integer/">Integer</a></code></pre>

Compare symbols

```ruby
a <=> b
```

### Symbol#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

Two equal symbols are the same object, so this is cheap.
```ruby
if k == :name
```

### Symbol#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

Perform equality comparison (for case statements)

```ruby
case k
when :name then hit
end
```

### Symbol#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Return string representation for debugging

```ruby
p :name  #=> :name
```

### Symbol#to_sym

<pre class="fmrb-sig"><code>to_sym() -&gt; Symbol</code></pre>

Return self as symbol

Returns itself.
```ruby
:name.to_sym
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
