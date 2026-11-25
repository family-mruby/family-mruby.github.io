# NilClass

The type of nil, meaning no value

It counts as false. Test for it with `nil?`. `to_i` gives 0, `to_s`
gives an empty string, and `to_h` gives an empty Hash, so a value that
failed to read can still be added.

## Instance methods

### NilClass#!

<pre class="fmrb-sig"><code>!() -&gt; bool</code></pre>

Return logical NOT

nil is false, so this is always true.
```ruby
!nil  #=> true
```

### NilClass#&

<pre class="fmrb-sig"><code>&amp;(untyped other) -&gt; bool</code></pre>

Always returns false

```ruby
nil & true  #=> false
```

### NilClass#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

Equality as `case` uses it

```ruby
case v
when nil then missing
end
```

### NilClass#^

<pre class="fmrb-sig"><code>^(untyped other) -&gt; bool</code></pre>

Returns logical value of argument

```ruby
nil ^ true  #=> true
```

### NilClass#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Returns "nil"

```ruby
p nil  #=> nil
```

### NilClass#nil?

<pre class="fmrb-sig"><code>nil?() -&gt; bool</code></pre>

Returns true

**The way to test for nil.**
```ruby
return if v.nil?
```

### NilClass#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

Returns 0.0

```ruby
nil.to_f  #=> 0.0
```

### NilClass#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

Returns empty hash

```ruby
nil.to_h  #=> {}
```

### NilClass#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

Returns 0

**It becomes 0**, so a value that failed to read can still be added.
```ruby
nil.to_i  #=> 0
```

### NilClass#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

Returns empty string

**An empty string**, not "nil".
```ruby
nil.to_s  #=> ""
```

### NilClass#|

<pre class="fmrb-sig"><code>|(untyped other) -&gt; bool</code></pre>

Returns logical value of argument

```ruby
nil | true  #=> true
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
