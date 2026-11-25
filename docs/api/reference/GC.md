# GC

Control and statistics of the garbage collector

An ordinary app does not need
it; an app that must keep a rhythm (playing, animating) uses it to avoid the
pause of a collection. To switch it all at once use `FmrbApp#idle_gc=` (it sets
`scheduler_driven`, `debt_limit`, `step_limit` and `malloc_threshold` together).
```ruby
GC.start
n = GC.stat[:live]
```

## Class methods

### GC.start

<pre class="fmrb-sig"><code>start() -&gt; nil</code></pre>

Run a full collection now

Returns nil. **It runs to the end in one go, so the app stops meanwhile** (longer
with more live objects). Use it to level things before a measurement.
```ruby
GC.start
before = GC.stat[:live]
```

### GC.disable

<pre class="fmrb-sig"><code>disable() -&gt; bool</code></pre>

Disable collection

Returns **true if it was already disabled, false if it was running**. Memory only
grows while it is off, so keep the span short and call `GC.enable` soon.
**`generational_mode=` raises RuntimeError while it is off.**
```ruby
was = GC.disable
work
GC.enable unless was
```

### GC.enable

<pre class="fmrb-sig"><code>enable() -&gt; bool</code></pre>

Enable collection

Returns **true if it was disabled, false if it was running** (the pair of `GC.disable`).
```ruby
GC.enable
```

### GC.stat

<pre class="fmrb-sig"><code>stat() -&gt; <a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped]</code></pre>

Return GC statistics as a hash

The keys are Symbols. **Keys in every build**: `:live` (live objects), `:debt`
(objects the collector is behind by), `:state` (phase: 0 idle, 1 mark, 2 sweep),
`:generational`, `:full`, `:step_limit`, `:malloc_increase` and `:malloc_threshold`
(both in bytes), `:symbol_count`, `:dynamic_symbol_count`.

**Keys only in a measurement build**: `:total`, `:minor`, `:major` (collection
counts, `MRB_GC_STATS`) and the `:prof_` pause statistics (a build made with
`FMRB_GC_PROFILE=1`). An ordinary build does not have them, so allow for nil:
`GC.stat[:total] || 0`.
```ruby
live = GC.stat[:live] || 0
```

### GC.reset_stat

<pre class="fmrb-sig"><code>reset_stat() -&gt; nil</code></pre>

Zero the pause statistics

**Only in a measurement build (`FMRB_GC_PROFILE=1`).** An ordinary build raises
NoMethodError, so check `GC.respond_to?(:reset_stat)` first. Returns nil.
```ruby
GC.reset_stat if GC.respond_to?(:reset_stat)
```

### GC.interval_ratio

<pre class="fmrb-sig"><code>interval_ratio() -&gt; <a href="../Integer/">Integer</a></code></pre>

Interval ratio of the collector (percent)

The source comment gives 200 as the initial value.
```ruby
r = GC.interval_ratio
```

### GC.interval_ratio=

<pre class="fmrb-sig"><code>interval_ratio=(<a href="../Integer/">Integer</a> ratio) -&gt; nil</code></pre>

Set the interval ratio (percent)

Returns nil. At 100 the next collection starts as soon as one ends (source comment).
```ruby
GC.interval_ratio = 150
```

### GC.step_ratio

<pre class="fmrb-sig"><code>step_ratio() -&gt; <a href="../Integer/">Integer</a></code></pre>

Step ratio of incremental collection (percent)

The source comment gives 200 as the initial value.
```ruby
r = GC.step_ratio
```

### GC.step_ratio=

<pre class="fmrb-sig"><code>step_ratio=(<a href="../Integer/">Integer</a> ratio) -&gt; nil</code></pre>

Set the step ratio (percent)

**Zero or less raises ArgumentError** ("step_ratio must be positive"). Returns nil.
A larger value makes one step longer.
```ruby
GC.step_ratio = 200
```

### GC.step_limit

<pre class="fmrb-sig"><code>step_limit() -&gt; <a href="../Integer/">Integer</a></code></pre>

Cap on the work of one step

0 means no cap.
```ruby
n = GC.step_limit
```

### GC.step_limit=

<pre class="fmrb-sig"><code>step_limit=(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the cap on the work of one step

0 means no cap. **A negative value raises ArgumentError** ("step_limit must be
non-negative"). It returns the value you passed. It bounds
**the length of one step, which cannot be interrupted**,
so an app that keeps a rhythm lowers it
(`FmrbApp#idle_gc=` sets 512).
```ruby
GC.step_limit = 512
```

### GC.malloc_threshold

<pre class="fmrb-sig"><code>malloc_threshold() -&gt; <a href="../Integer/">Integer</a></code></pre>

Malloc growth that triggers a collection

0 turns it off.
```ruby
n = GC.malloc_threshold
```

### GC.malloc_threshold=

<pre class="fmrb-sig"><code>malloc_threshold=(<a href="../Integer/">Integer</a> bytes) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the malloc growth threshold

Advances a collection once malloc'd bytes have grown this much. It catches
**large allocations the object count does not show**, such as the body of a String or an
Array. 0 turns it off. **A negative value raises ArgumentError**
("malloc_threshold must be non-negative"). It returns the value you passed.
```ruby
GC.malloc_threshold = 32 * 1024
```

### GC.generational_mode

<pre class="fmrb-sig"><code>generational_mode() -&gt; bool</code></pre>

Whether generational mode is on

```ruby
g = GC.generational_mode
```

### GC.generational_mode=

<pre class="fmrb-sig"><code>generational_mode=(bool enable) -&gt; bool</code></pre>

Switch generational mode

Returns the true / false you passed.
**It raises RuntimeError while `GC.disable` is in effect**
("generational mode changed when GC disabled"),
**and when you turn it on while `scheduler_driven` is true.**
`scheduler_driven = true` turns it off, and
setting `scheduler_driven` back to false does not turn it on again.
```ruby
GC.generational_mode = true
```

### GC.scheduler_driven

<pre class="fmrb-sig"><code>scheduler_driven() -&gt; bool</code></pre>

Whether the scheduler drives the collector

```ruby
d = GC.scheduler_driven
```

### GC.scheduler_driven=

<pre class="fmrb-sig"><code>scheduler_driven=(bool enable) -&gt; bool</code></pre>

Hand collection to the scheduler's idle time

When true, allocation no longer drives collection; it advances in small steps while
the app waits (`_spin`). **Generational mode goes off**, and it raises RuntimeError
while `GC.disable` is in effect. false puts it back (generational mode does not
return). **An always-busy app never has idle time**, so past `debt_limit` the
allocation path forces a step. Usually use `FmrbApp#idle_gc=`. Returns the value you
passed.
```ruby
GC.scheduler_driven = true
```

### GC.debt_limit

<pre class="fmrb-sig"><code>debt_limit() -&gt; <a href="../Integer/">Integer</a></code></pre>

Limit of how far collection may fall behind

0 turns it off. It only works while `scheduler_driven` is true.
```ruby
n = GC.debt_limit
```

### GC.debt_limit=

<pre class="fmrb-sig"><code>debt_limit=(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the limit of collection debt

While `scheduler_driven` is true and there is no idle time, once the debt
(`GC.stat[:debt]`) passes this the allocation path forces one step (a pause of one
step). **It does nothing while `scheduler_driven` is false.** 0 turns it off.
**A negative value raises ArgumentError.** Returns the value you passed.
```ruby
GC.debt_limit = 4096
```

### GC.step

<pre class="fmrb-sig"><code>step() -&gt; nil</code></pre>

Run one bounded collection step

Returns nil. While `scheduler_driven`, a busy app calls it a few times per frame to
spread collection into small slices (`step_limit` sets the length of one).
```ruby
GC.step
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
