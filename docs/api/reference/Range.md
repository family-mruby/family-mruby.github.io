# Range

A range such as 1..3 or 1...3

Inherits from: [`Enumerable`](Enumerable.md)

Walk it with `each`. Even for `...`, `last` returns the end as written
(not the last element). `===` is what `case ... when` uses. A block
call costs about 0.4ms, so in a hot loop rewrite it as `while`.

## Class methods

### Range.new

<pre class="fmrb-sig"><code>new(untyped first, untyped last, ?bool exclude_end) -&gt; Range</code></pre>

Make a Range

Normally written `1..5`.
```ruby
r = Range.new(1, 5)
```

## Instance methods

### Range#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

```ruby
if r == other
```

### Range#===

<pre class="fmrb-sig"><code>===(untyped object) -&gt; bool</code></pre>

Check if value is included in range

**The form `case` uses.**
```ruby
case n
when 0..9 then digit
end
```

### Range#exclude_end?

<pre class="fmrb-sig"><code>exclude_end?() -&gt; bool</code></pre>

Check if end value is excluded

true when it was made with `...`.
```ruby
(0...3).exclude_end?  #=> true
```

### Range#first

<pre class="fmrb-sig"><code>first() -&gt; untyped</code></pre>

Return start value of range

```ruby
(1..5).first  #=> 1
```

### Range#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Return string representation for debugging

```ruby
p (1..5)
```

### Range#last

<pre class="fmrb-sig"><code>last() -&gt; untyped</code></pre>

Return end value of range

**The end as written**, even for `...` -- not the last element.
```ruby
(1...5).last  #=> 5
```

### Range#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

Return string representation

```ruby
(1..5).to_s
```

### Range#each

<pre class="fmrb-sig"><code>each() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

Execute block for each element in range

**A block call costs about 0.4ms**; rewrite a hot loop as `while`.
```ruby
(0..7).each do |i|
  draw(i)
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
