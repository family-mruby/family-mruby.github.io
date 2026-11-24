# Hash

A table that maps keys to values

Includes `Enumerable`. A missing key gives nil, not an exception, and a
default value cannot be given. A String key and a Symbol key are
different. `each_key` needs a block (this build has no Enumerator).

## Class methods

### Hash.new

<pre class="fmrb-sig"><code>new() -&gt; Hash</code></pre>

Make an empty hash

**No default can be given**; a missing key is always nil.
```ruby
h = Hash.new
h = {}
```

## Instance methods

### Hash#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

```ruby
if h == other
```

### Hash#[]

<pre class="fmrb-sig"><code>[](untyped key) -&gt; untyped</code></pre>

Get value for specified key

**A missing key gives nil**; it does not raise.
```ruby
h[:name]
h["name"]
```

### Hash#[]=

<pre class="fmrb-sig"><code>[]=(untyped key, untyped value) -&gt; self</code></pre>

Set value for specified key

**A String key and a Symbol key are different.** Mixing them loses the
value.
```ruby
h[:name] = "a"
```

### Hash#clear

<pre class="fmrb-sig"><code>clear() -&gt; Hash</code></pre>

Remove all elements from hash

```ruby
h.clear
```

### Hash#delete

<pre class="fmrb-sig"><code>delete(untyped key) -&gt; (untyped | nil)</code></pre>

Delete specified key

Returns what was there, or nil.
```ruby
v = h.delete(:name)
```

### Hash#each

<pre class="fmrb-sig"><code>each() { (untyped key, untyped value) -&gt; untyped } -&gt; self</code></pre>

Execute block for each key and value

**The block takes two**, the key and the value.
```ruby
h.each do |k, v|
  puts k.to_s + "=" + v.to_s
end
```

### Hash#each_key

<pre class="fmrb-sig"><code>each_key() { (untyped key) -&gt; untyped } -&gt; self</code></pre>

Call the block with each key

**A block is required** (without one it raises NotImplementedError; this build has
no Enumerator). Returns the hash itself.
```ruby
h.each_key { |k| p k }
```

### Hash#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

Check if hash is empty

```ruby
return if h.empty?
```

### Hash#has_key?

<pre class="fmrb-sig"><code>has_key?(untyped key) -&gt; bool</code></pre>

Check if specified key exists

How you tell a key holding nil from a key that is not there.
```ruby
if h.has_key?(:name)
```

### Hash#key?

<pre class="fmrb-sig"><code>key?(untyped key) -&gt; bool</code></pre>

Whether the key is present

The same as `has_key?`.
```ruby
@titles.key?(room)
```

### Hash#has_value?

<pre class="fmrb-sig"><code>has_value?(untyped value) -&gt; bool</code></pre>

Check if specified value exists

It walks the whole hash.
```ruby
if h.has_value?(v)
```

### Hash#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Return string representation for debugging

```ruby
p h
```

### Hash#key

<pre class="fmrb-sig"><code>key(untyped value) -&gt; (untyped | nil)</code></pre>

Look the key up from the value

Looks the key up from the value; nil when there is none.
```ruby
k = h.key(v)
```

### Hash#keys

<pre class="fmrb-sig"><code>keys() -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

Return all keys as array

It builds a new array.
```ruby
h.keys.each { |k| p k }
```

### Hash#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return number of elements in hash

```ruby
n = h.length
```

### Hash#merge

<pre class="fmrb-sig"><code>merge(Hash other) -&gt; self</code></pre>

Return new hash merged with another hash

**The other side wins on a shared key** -- what you want for overriding
settings.
```ruby
conf = defaults.merge(user)
```

### Hash#merge!

<pre class="fmrb-sig"><code>merge!(Hash other) -&gt; self</code></pre>

Merge hash destructively

Merges into this hash.
```ruby
conf.merge!(user)
```

### Hash#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; self</code></pre>

Return self as hash

Returns itself.
```ruby
h.to_h
```

### Hash#values

<pre class="fmrb-sig"><code>values() -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

Return all values as array

```ruby
h.values.each { |v| p v }
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
