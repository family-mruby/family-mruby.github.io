# IO

An input/output stream

How to use it: [Files & I/O](../filesystem.md).

The parent of File. `$stdout` and a file are the same kind
of IO. **`read` and `write` on a closed stream raise RuntimeError** ("closed
stream"), not IOError. Every failure is a RuntimeError; the reason (errno) is not
told apart.
```ruby
$stdout.puts "hello"
```

## Instance methods

### IO#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

Read bytes (File overrides it as File#read)

Reads up to length bytes and returns them. **length defaults to 1024** (for
streams such as stdin; a file goes through File#read, which reads everything
when it is left out). length of 0 or less returns "". RuntimeError when the
read fails ("failed to read from stream") or the stream is closed
("closed stream").
```ruby
s = $stdin.read(16)
```

### IO#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write a string

Writes str and returns **the number of bytes written**. Only a String is
accepted (a number raises TypeError; `puts` and `print` call to_s first).
RuntimeError when the write fails ("write failed") or the stream is closed
("closed stream").
```ruby
n = f.write("hello\n")   #=> 6
```

### IO#puts

<pre class="fmrb-sig"><code>puts(*untyped objects) -&gt; nil</code></pre>

Write with a newline

Writes each argument after to_s and adds "\n" unless it already ends with one;
with no arguments it writes just "\n". **Arrays are not flattened** (`puts [1, 2]`
writes the one line "[1, 2]"; CRuby writes one line per element). nil is an empty
line. Always returns nil.
```ruby
f.puts "line"
```

### IO#print

<pre class="fmrb-sig"><code>print(*untyped objects) -&gt; nil</code></pre>

Write without a newline

Calls to_s on each argument and writes it. Always returns nil.
```ruby
f.print "a", 1
```

### IO#flush

<pre class="fmrb-sig"><code>flush() -&gt; self</code></pre>

Flush what was written to storage

Pushes a file's writes out to storage and returns self. Does nothing for
stdout, stderr and a closed stream. RuntimeError when it cannot flush
("flush failed").
```ruby
f.flush
```

### IO#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Close the stream

**Calling it again is not an error** (nothing happens once it is closed). Returns
nil. Nothing happens for the standard streams.
**A file left open is not closed by the garbage collector**;
it is closed when the app ends. The number that can
stay open is limited (10 for all apps together on an ESP32; see File.new).
```ruby
f.close
```

### IO#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
f.closed?
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
