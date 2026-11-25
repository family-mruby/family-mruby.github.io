# Kernel

Output, random numbers, Proc helpers

The line `puts` writes goes to the log, not the screen. `print` adds no newline.
`rand` with max left out or 0 returns an integer from 0 to 4294967295
(not a Float as in CRuby). `proc`, `lambda` and `->` turn a block into a
Proc.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`MSG_TASK_KERNEL`</span> | [`Integer`](Integer.md) | The kernel's task id (0) |
| <span class="fmrb-name">`MSG_TASK_HOST`</span> | [`Integer`](Integer.md) | The host task's id (1) |
| <span class="fmrb-name">`MSG_TASK_SYSTEM`</span> | [`Integer`](Integer.md) | The system app's task id (2) |

## Class methods

### Kernel.send_message

<pre class="fmrb-sig"><code>send_message(
  <a href="../Integer/">Integer</a> task_id,
  <a href="../Integer/">Integer</a> msg_type,
  <a href="../String/">String</a> data,
  ?<a href="../Integer/">Integer</a> timeout_ms
) -&gt; bool</code></pre>

Put a raw string on a task's queue

task_id is from 0 to below the limit (9 on the devices) (**outside it**
**raises ArgumentError**). data is at most 64 bytes (**more raises**
**ArgumentError**). `timeout_ms` (100 when left out) is how long to wait
while the queue is full.

**It returns true when sent.** It returns **false** when the task has no
queue or the queue stays full for timeout_ms; no exception is raised.
```ruby
Kernel.send_message(0, 1, "key_down:13")
```

### Kernel.receive_message

<pre class="fmrb-sig"><code>receive_message(<a href="../Integer/">Integer</a> task_id, ?<a href="../Integer/">Integer</a> timeout_ms) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Take one message off a task's queue

Returns a `[type, string]` array, or **nil** when nothing came within
timeout_ms (1000 when left out). task_id outside 0 to below the limit
(9 on the devices) raises ArgumentError, and a task with no queue raises
**RuntimeError**, not nil.
**Passing the app's own number reads the very queue `_spin` reads.**
```ruby
msg = Kernel.receive_message(2, 5000)
type, data = msg if msg
```

### Kernel.broadcast_message

<pre class="fmrb-sig"><code>broadcast_message(
  <a href="../Integer/">Integer</a> msg_type,
  <a href="../String/">String</a> data,
  ?<a href="../Integer/">Integer</a> timeout_ms
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Put a raw string on every queue

Puts the same message on **every registered queue** and returns how many
took it. A full queue is waited for up to `timeout_ms` (10 when left
out) each. data is at most 64 bytes (more raises ArgumentError).
```ruby
n = Kernel.broadcast_message(99, "bye")
```

### Kernel.message_queue_exists?

<pre class="fmrb-sig"><code>message_queue_exists?(<a href="../Integer/">Integer</a> task_id) -&gt; bool</code></pre>

Whether a task has a queue

task_id outside 0 to below the limit (9 on the devices) raises
ArgumentError.
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
the simulation, the serial port on a device. It calls `$stdout.puts`, so
it writes as `IO#puts` does (an Array one line per element). A script run
from the shell prints on the shell's screen.
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

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
