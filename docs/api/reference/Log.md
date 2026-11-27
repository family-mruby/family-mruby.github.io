# Log

The log (goes to the serial port and the sim's terminal)

How to use it: [Logging](../log.md).

Log as a whole class is on the boundary to the system (%a{fmrb.boundary},
doc/app_boundary). info and the like are wrappers, each with a _raw form
next to it that leaves nothing out (the mruby wrapper is in C and also
reads the older form that takes the tag first, `Log.info("TAG", msg)`).

## Class methods

### Log.debug

<pre class="fmrb-sig"><code>debug(<a href="../String/">String</a> msg) -&gt; void</code></pre>

Write a debug line to the log

The line starts with the app's name.
```ruby
Log.debug("x = #{x}")
```

### Log.debug_raw

<pre class="fmrb-sig"><code>debug_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

debug with nothing left out

Writes one line, debug (D). The wrapper is debug.
```ruby
Log.debug_raw("ready")
```

### Log.info

<pre class="fmrb-sig"><code>info(<a href="../String/">String</a> msg) -&gt; void</code></pre>

Write a line to the log

The line starts with the app's name.
```ruby
Log.info("saved #{path}")
```

### Log.info_raw

<pre class="fmrb-sig"><code>info_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

info with nothing left out

Writes one line, an ordinary note (I). The wrapper is info.
```ruby
Log.info_raw("ready")
```

### Log.warn

<pre class="fmrb-sig"><code>warn(<a href="../String/">String</a> msg) -&gt; void</code></pre>

Write a warning to the log

The line starts with the app's name.
```ruby
Log.warn("x = #{x}")
```

### Log.warn_raw

<pre class="fmrb-sig"><code>warn_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

warn with nothing left out

Writes one line, a warning (W). The wrapper is warn.
```ruby
Log.warn_raw("ready")
```

### Log.error

<pre class="fmrb-sig"><code>error(<a href="../String/">String</a> msg) -&gt; void</code></pre>

Write an error to the log

The line starts with the app's name.
```ruby
Log.error("x = #{x}")
```

### Log.error_raw

<pre class="fmrb-sig"><code>error_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

error with nothing left out

Writes one line, an error (E). The wrapper is error.
```ruby
Log.error_raw("ready")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
