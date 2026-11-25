# Kernel

Output, random numbers, Proc helpers

The line `puts` writes goes to the log, not the screen. `print` adds no newline.
`rand` with max left out or 0 returns an integer from 0 to 4294967295
(not a Float as in CRuby). `proc`, `lambda` and `->` turn a block into a
Proc.

## Class methods

### Kernel.message_queue_exists?

<pre class="fmrb-sig"><code>message_queue_exists?(<a href="../Integer/">Integer</a> task_id) -&gt; bool</code></pre>

Whether a task has a queue

task_id outside 0-15 raises ArgumentError. **9 and above is always**
**false.**
```ruby
ready = Kernel.message_queue_exists?(0)
```

## Instance methods

### Kernel#p

<pre class="fmrb-sig"><code>p(*untyped objects) -&gt; untyped</code></pre>

Inspect and output object

Prints the `inspect` form and hands the value back, so it can sit inside
an expression.
```ruby
p x
y = p compute
```

### Kernel#print

<pre class="fmrb-sig"><code>print(*untyped objects) -&gt; nil</code></pre>

Output object

**No newline.**
```ruby
print "loading"
```

### Kernel#puts

<pre class="fmrb-sig"><code>puts(*untyped objects) -&gt; nil</code></pre>

Output object with newline

**The line goes to the log**, not the screen: `docker logs fmruby_core` in
the simulation, the serial port on a device.
```ruby
puts "started"
```

### Kernel#rand

<pre class="fmrb-sig"><code>rand(?<a href="../Integer/">Integer</a> max) -&gt; <a href="../Integer/">Integer</a></code></pre>

Return a random integer

**With max left out or 0 it returns an integer from 0 to 4294967295** (not a Float in
0...1 as in CRuby). With max it returns an integer **from 0 up to, but not
including, max** (`RNG.random_int % max`). Integers only (no Range or Float). **There
is no way to seed it** (no `srand`).
```ruby
x = rand(10)    #=> 0..9
t = 2000 + rand(4000)
```

### Kernel#yield

<pre class="fmrb-sig"><code>yield(*untyped arguments) -&gt; untyped</code></pre>

Call the block that was given

Calls the block it was given; **calling it without one raises**, so check
`block_given?`.
```ruby
yield(v) if block_given?
```

### Kernel#proc

<pre class="fmrb-sig"><code>proc() { (untyped argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

Create Proc object

**It cannot capture an outer local** under Spinel. Pass what a stored
block needs as an ivar or an argument.
```ruby
f = proc { |v| draw(v) }
```

### Kernel#lambda

<pre class="fmrb-sig"><code>lambda() { (untyped argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

Create lambda expression

It differs from `proc` in argument checking and in what `return` does.
```ruby
f = lambda { |v| v * 2 }
```

### Kernel#->

<pre class="fmrb-sig"><code>-&gt;(untyped argument) { (untyped block_argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

The short spelling of lambda

The short spelling of `lambda`.
```ruby
f = ->(v) { v * 2 }
f.call(3)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
