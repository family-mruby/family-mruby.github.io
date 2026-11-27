# Enumerable

Iteration helpers for anything with each

Included by `Array` and `Hash`, and the parent of `Range`. Listed here are `each`,
`each_with_index`, `map` and `to_a`. `map` builds a new array (`collect!`
changes the receiver).

## Instance methods

### Enumerable#each

<pre class="fmrb-sig"><code>each() { (untyped item) -&gt; untyped } -&gt; untyped</code></pre>

Run the block for each item

```ruby
obj.each { |v| p v }
```

### Enumerable#each_with_index

<pre class="fmrb-sig"><code>each_with_index() { (untyped item, <a href="../Integer/">Integer</a> index) -&gt; untyped } -&gt; untyped</code></pre>

Run the block with the item and its position

**The block takes two**: the value and its position.
```ruby
a.each_with_index do |v, i|
  draw(i, v)
end
```

### Enumerable#map

<pre class="fmrb-sig"><code>map() { (untyped item) -&gt; untyped } -&gt; <a href="../Array/">Array</a></code></pre>

Return an array of what the block gave back

It makes a new array; `collect!` rewrites in place.
```ruby
b = a.map { |v| v * 2 }
```

### Enumerable#to_a

<pre class="fmrb-sig"><code>to_a() -&gt; <a href="../Array/">Array</a></code></pre>

Turn it into an array

```ruby
a = obj.to_a
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
