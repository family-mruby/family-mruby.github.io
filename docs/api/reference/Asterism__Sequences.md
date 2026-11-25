# Asterism::Sequences

A reader's memory of the sequence numbers

How to use it: [Network](../network.md).

Per sender and per path it remembers the last connection number and value
number, and counts what was missed (lost) and the sender's restarts (restarted).
Each Subscription holds one, and it decides SampleInfo's lost and restarted.
For code that receives values itself (an ordinary app only needs subscribe).

## Class methods

### Asterism::Sequences.new

<pre class="fmrb-sig"><code>new(?<a href="../Integer/">Integer</a>? max) -&gt; Asterism::Sequences</code></pre>

Make one remembering up to max lanes

`max` (64 on a machine, 4096 on a PC when left out). Past it the lane
seen longest ago is forgotten (its next value counts as a first one).
```ruby
seqs = Asterism::Sequences.new(16)
```

## Instance methods

### Asterism::Sequences#see

<pre class="fmrb-sig"><code>see(
  <a href="../String/">String</a> lane,
  <a href="../Integer/">Integer</a>? run,
  <a href="../Integer/">Integer</a> seq,
  ?<a href="../String/">String</a>? app
) -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

See one value: [lost, restarted]

lane is the key (for a shared key, with the sender), run the sender's
run id (nil: none), seq the value's number, app the sender's
"node/app" (nil when unknown). Returns `[values missed, whether the
sender restarted]`; the first sight of a lane is [0, false].
```ruby
lost, again =
  seqs.see("k", 7, 1, "n/a")
```

### Asterism::Sequences#forget

<pre class="fmrb-sig"><code>forget(<a href="../String/">String</a> app) -&gt; <a href="../Integer/">Integer</a></code></pre>

Forget the lanes of an app that left

Returns how many lanes it forgot.
```ruby
n = seqs.forget("n/app")
```

### Asterism::Sequences#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many lanes are remembered now

```ruby
n = seqs.size
```

### Asterism::Sequences#clear

<pre class="fmrb-sig"><code>clear() -&gt; Asterism::Sequences</code></pre>

Forget everything

Returns itself.
```ruby
seqs.clear
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
