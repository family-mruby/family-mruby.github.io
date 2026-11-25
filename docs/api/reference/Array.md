# Array

An ordered list of elements

Includes `Enumerable`. Here `a[i], a[j] = a[j], a[i]` does not work (swap
through a temporary). A block call costs about 0.4ms, so in a per-frame
loop write `while` instead. The methods listed are the ones apps use,
such as `push`, `each` and `include?`.

## Class methods

### Array.new

<pre class="fmrb-sig"><code>new(?<a href="../Integer/">Integer</a> size, ?untyped object) -&gt; Array</code></pre>

Make an array

Reserving the size up front beats growing it item by item. The second
argument fills it.
```ruby
a = Array.new
b = Array.new(16, 0)
```

## Instance methods

### Array#[]=

<pre class="fmrb-sig"><code>[]=(<a href="../Integer/">Integer</a> index, untyped value) -&gt; untyped
[]=(<a href="../Integer/">Integer</a> start, <a href="../Integer/">Integer</a> length, untyped value) -&gt; untyped</code></pre>

Set element at specified position

**`a[i], a[j] = a[j], a[i]` does not work** here -- a known picoruby gap.
Swap through a temporary instead.
```ruby
a[0] = 1
t = a[i]; a[i] = a[j]; a[j] = t
```

### Array#[]

<pre class="fmrb-sig"><code>[](<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

Get element at specified position

**A negative index counts from the end.** Out of range gives nil, not an
error.
```ruby
a[0]
a[-1]
```

### Array#&

<pre class="fmrb-sig"><code>&amp;(Array other) -&gt; self</code></pre>

Elements that are in both arrays

Keeps what is in both.
```ruby
[1, 2, 3] & [2, 3, 4]  #=> [2, 3]
```

### Array#+

<pre class="fmrb-sig"><code>+(Array other) -&gt; Array</code></pre>

Concatenate arrays

It makes a new array; to add on the end use `push`.
```ruby
c = a + b
```

### Array#-

<pre class="fmrb-sig"><code>-(Array other) -&gt; self</code></pre>

Return new array excluding specified elements

Drops everything the other one has.
```ruby
[1, 2, 3] - [2]  #=> [1, 3]
```

### Array#push

<pre class="fmrb-sig"><code>push(untyped object) -&gt; Array</code></pre>

Append element to end

The same as `<<`; it returns the array so calls can be chained.
```ruby
a.push(1)
a << 1
```

### Array#all?

<pre class="fmrb-sig"><code>all?(*untyped patterns) -&gt; bool
all?(*untyped patterns) { (untyped element) -&gt; untyped } -&gt; bool</code></pre>

Whether every element passes

```ruby
ok = a.all? { |v| v > 0 }
```

### Array#at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

Get element at specified position

The same as `[]`.
```ruby
a.at(2)
```

### Array#clear

<pre class="fmrb-sig"><code>clear() -&gt; Array</code></pre>

Remove all elements from array

Empties the array itself, so everyone holding it sees it empty.
```ruby
a.clear
```

### Array#collect!

<pre class="fmrb-sig"><code>collect!() { (untyped element) -&gt; untyped } -&gt; Array[untyped]</code></pre>

Replace each element with the block's result, in place

Rewrites the array in place instead of making a new one.
```ruby
a.collect! { |v| v * 2 }
```

### Array#count

<pre class="fmrb-sig"><code>count() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return the number of elements

The same as `length`.
```ruby
n = a.count
```

### Array#delete_at

<pre class="fmrb-sig"><code>delete_at(<a href="../Integer/">Integer</a> index) -&gt; untyped</code></pre>

Delete element at specified position

The rest shifts down, so deleting while looping forwards skips items --
go backwards.
```ruby
v = a.delete_at(0)
```

### Array#delete_if

<pre class="fmrb-sig"><code>delete_if() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

Delete elements for which block returns true

```ruby
a.delete_if { |v| v.nil? }
```

### Array#each

<pre class="fmrb-sig"><code>each() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

Execute block for each element

**A block call costs about 0.4ms.** In a per-frame loop, `while` with an
index is faster.
```ruby
a.each do |v|
  draw(v)
end
```

### Array#each_index

<pre class="fmrb-sig"><code>each_index() { (<a href="../Integer/">Integer</a> index) -&gt; untyped } -&gt; self</code></pre>

Execute block for each index

```ruby
a.each_index { |i| p i }
```

### Array#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

Check if array is empty

```ruby
return if a.empty?
```

### Array#first

<pre class="fmrb-sig"><code>first() -&gt; untyped</code></pre>

Get first element

nil when empty.
```ruby
v = a.first
```

### Array#include?

<pre class="fmrb-sig"><code>include?(untyped object) -&gt; bool</code></pre>

Check if element is included

It walks from the front, so it is slow on a long array; use a Hash when
you ask often.
```ruby
if a.include?(v)
```

### Array#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Return string representation for debugging

```ruby
p a
```

### Array#join

<pre class="fmrb-sig"><code>join(?<a href="../String/">String</a> separator) -&gt; <a href="../String/">String</a></code></pre>

Join elements and return string

```ruby
a.join(", ")
```

### Array#last

<pre class="fmrb-sig"><code>last() -&gt; untyped</code></pre>

Get last element

nil when empty.
```ruby
v = a.last
```

### Array#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return number of elements in array

```ruby
n = a.length
```

### Array#max

<pre class="fmrb-sig"><code>max() -&gt; untyped
max() { (untyped left, untyped right) -&gt; untyped } -&gt; untyped</code></pre>

The largest element

nil when empty.
```ruby
v = a.max
```

### Array#min

<pre class="fmrb-sig"><code>min() -&gt; untyped
min() { (untyped left, untyped right) -&gt; untyped } -&gt; untyped</code></pre>

The smallest element

nil when empty.
```ruby
v = a.min
```

### Array#pop

<pre class="fmrb-sig"><code>pop(?<a href="../Integer/">Integer</a> count) -&gt; (untyped | self)</code></pre>

Remove and return last element

Takes from the **end**; with a count it returns that many as an array.
```ruby
v = a.pop
vs = a.pop(2)
```

### Array#reject

<pre class="fmrb-sig"><code>reject() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

Return array without elements the block matches

Drops the ones the block calls true; invert the test to say what to keep.
```ruby
a.reject { |v| v < 0 }
```

### Array#reject!

<pre class="fmrb-sig"><code>reject!() { (untyped element) -&gt; untyped } -&gt; self</code></pre>

Delete the elements the block matches, in place

Rewrites the array in place.
```ruby
a.reject! { |v| v.nil? }
```

### Array#select

<pre class="fmrb-sig"><code>select() { (untyped element) -&gt; untyped } -&gt; Array[untyped]</code></pre>

Return the elements the block accepts

Returns a **new array** of the elements for which the block is true (the original is
not changed). **A block is required** (without one it raises NotImplementedError;
this build has no Enumerator).
```ruby
ids = ids.select { |i| ok?(i) }
```

### Array#shift

<pre class="fmrb-sig"><code>shift(?<a href="../Integer/">Integer</a> count) -&gt; (untyped | self)</code></pre>

Remove and return first element

Takes from the **front** -- a queue.
```ruby
v = a.shift
```

### Array#sort

<pre class="fmrb-sig"><code>sort() -&gt; self
sort() { (untyped left, untyped right) -&gt; untyped } -&gt; self</code></pre>

Return sorted array

It raises when the values cannot be compared -- numbers mixed with
strings.
```ruby
b = a.sort
```

### Array#sort!

<pre class="fmrb-sig"><code>sort!() -&gt; self
sort!() { (untyped left, untyped right) -&gt; untyped } -&gt; self</code></pre>

Sort destructively

Sorts in place.
```ruby
a.sort!
```

### Array#slice

<pre class="fmrb-sig"><code>slice(untyped index_or_range) -&gt; untyped</code></pre>

Get subarray

```ruby
a.slice(1, 2)
```

### Array#uniq

<pre class="fmrb-sig"><code>uniq() -&gt; self</code></pre>

Return array with duplicates removed

Keeps the first of each; the order of first appearance is kept.
```ruby
b = a.uniq
```

### Array#uniq!

<pre class="fmrb-sig"><code>uniq!() -&gt; self</code></pre>

Remove duplicates destructively

**nil when nothing changed.**
```ruby
a.uniq!
```

### Array#unshift

<pre class="fmrb-sig"><code>unshift(untyped object) -&gt; Array</code></pre>

Prepend element to beginning

Puts it at the front, which shifts everything else along.
```ruby
a.unshift(0)
```

### Array#|

<pre class="fmrb-sig"><code>|(Array other) -&gt; Array</code></pre>

The two arrays joined, without duplicates

Joins the two and drops the duplicates.
```ruby
[1, 2] | [2, 3]  #=> [1, 2, 3]
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
