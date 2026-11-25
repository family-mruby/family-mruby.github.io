# Object

A copy for calls with Object as the receiver

A copy for calls with Object itself as the receiver, as in
`Object.const_defined?(:X)`. It does the same as Module#const_defined?
(Object is a kind of Module).

## Class methods

### Object.const_defined?

<pre class="fmrb-sig"><code>const_defined?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool inherit) -&gt; bool</code></pre>

Whether a constant is defined

```ruby
Object.const_defined?(:Digest)
```

### Object.methods

<pre class="fmrb-sig"><code>methods() -&gt; <a href="../Array/">Array</a>[<a href="../Symbol/">Symbol</a>]</code></pre>

get object method list

For finding out what an object answers to.
```ruby
p obj.methods
```

## Instance methods

### Object#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(untyped other) -&gt; <a href="../Integer/">Integer</a></code></pre>

Comparison operator

0 for the same object, nil otherwise.
```ruby
a <=> b
```

### Object#!=

<pre class="fmrb-sig"><code>!=(untyped other) -&gt; bool</code></pre>

Perform inequality comparison

```ruby
if a != b
```

### Object#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

**By default it asks whether they are the same object.** Define it
yourself to compare contents.
```ruby
if a == b
```

### Object#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

Judge case equality

```ruby
case v
when Integer then n
end
```

### Object#attr_accessor

<pre class="fmrb-sig"><code>attr_accessor(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

Define a reader and a writer

Gives both a reader and a writer. Written inside the class.
```ruby
class Foo
  attr_accessor :x, :y
end
```

### Object#attr_reader

<pre class="fmrb-sig"><code>attr_reader(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

Define a reader

**Reader only.**
```ruby
attr_reader :id
```

### Object#block_given?

<pre class="fmrb-sig"><code>block_given?() -&gt; bool</code></pre>

Whether a block was given

Check before you `yield`.
```ruby
yield(v) if block_given?
```

### Object#class

<pre class="fmrb-sig"><code>class() -&gt; <a href="../Class/">Class</a></code></pre>

Return object class

```ruby
obj.class.name
```

### Object#dup

<pre class="fmrb-sig"><code>dup() -&gt; self</code></pre>

Duplicate object

**A shallow copy**: what is inside is shared, not copied.
```ruby
b = a.dup
```

### Object#equal?

<pre class="fmrb-sig"><code>equal?(untyped other) -&gt; bool</code></pre>

Whether it is the very same object

**Asks for the same object, not the same value** (unlike `==`). Two strings with
equal contents that were built separately give false.
```ruby
a.equal?(b)
```

### Object#exit

<pre class="fmrb-sig"><code>exit(?<a href="../Integer/">Integer</a> status) -&gt; nil</code></pre>

End the app

Ends the app; the window is tidied up for you.
```ruby
exit
```

### Object#include

<pre class="fmrb-sig"><code>include(*untyped modules) -&gt; nil</code></pre>

Mix a module in

**A bare constant is not found through the including class** in picoruby;
write `self.class::NAME`.
```ruby
class Foo
  include Bar
end
```

### Object#extend

<pre class="fmrb-sig"><code>extend(*untyped modules) -&gt; nil</code></pre>

Add a module to this object alone

Adds the module to that one object.
```ruby
obj.extend(Bar)
```

### Object#freeze

<pre class="fmrb-sig"><code>freeze() -&gt; self</code></pre>

Make the object unmodifiable

Returns the object itself. Changing a frozen String, Array or Hash afterwards raises
**FrozenError**. Integer, Symbol, nil, true and false are left as they are (they
cannot change anyway). Use it to protect a constant Array or Hash.
```ruby
NAMES = ["a", "b"].freeze
```

### Object#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Return string representation for debugging

```ruby
p obj
```

### Object#is_a?

<pre class="fmrb-sig"><code>is_a?(untyped class_or_module) -&gt; bool</code></pre>

Check if instance of specified class or module

**There is no `defined?` here**; use this, `const_defined?`, or a rescue.
```ruby
if v.is_a?(Integer)
```

### Object#loop

<pre class="fmrb-sig"><code>loop() { (nil value) -&gt; untyped } -&gt; nil</code></pre>

Repeat forever

**Do not spin inside an app**: the shell can no longer deliver input.
```ruby
loop do
  break if done?
end
```

### Object#nil?

<pre class="fmrb-sig"><code>nil?() -&gt; bool</code></pre>

Check if nil

```ruby
return if v.nil?
```

### Object#private

<pre class="fmrb-sig"><code>private(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

Make what follows private

```ruby
private
def helper
end
```

### Object#public

<pre class="fmrb-sig"><code>public(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

Make what follows public

```ruby
public
```

### Object#raise

<pre class="fmrb-sig"><code>raise(?untyped exception, ?<a href="../String/">String</a> message) -&gt; bot</code></pre>

Raise an exception

**It ends the app if nothing catches it.** Wrap file work in a `rescue`.
```ruby
raise "bad path"
begin
  risky
rescue => e
  Log.info(e.message)
end
```

### Object#relinquish

<pre class="fmrb-sig"><code>relinquish() -&gt; bool</code></pre>

Give other tasks a turn

Hands the turn to other tasks; drop it into a long calculation and the
screen keeps moving.
```ruby
i = 0
while i < 10000
  relinquish if i % 500 == 0
  i += 1
end
```

### Object#respond_to?

<pre class="fmrb-sig"><code>respond_to?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool include_all) -&gt; bool</code></pre>

Whether the object has the method

name is a Symbol or a String. **It does not look at private** (true when the method
exists). Even without the method it is true when `respond_to_missing?` says so
(`include_all` is only passed on to that call). Use it for an API that exists on
some platforms or builds only.
```ruby
GC.respond_to?(:reset_stat)
```

### Object#sleep

<pre class="fmrb-sig"><code>sleep(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> duration) -&gt; <a href="../Integer/">Integer</a></code></pre>

Wait, in seconds

Waits in seconds.
```ruby
sleep 1
```

### Object#sleep_ms

<pre class="fmrb-sig"><code>sleep_ms(<a href="../Integer/">Integer</a> milliseconds) -&gt; <a href="../Integer/">Integer</a></code></pre>

Wait, in milliseconds

**Not for use inside an app**: outside `_spin` the tick does not advance
and it never returns. Wait with `Machine.delay_ms`.
```ruby
Machine.delay_ms(50)
```

### Object#sprintf

<pre class="fmrb-sig"><code>sprintf(<a href="../String/">String</a> format, *untyped arguments) -&gt; <a href="../String/">String</a></code></pre>

Format a string

For lining figures up.
```ruby
s = sprintf("%3d%%", n)
```

### Object#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

Return string representation

```ruby
obj.to_s
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
