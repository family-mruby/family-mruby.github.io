# Asterism::SampleInfo

Information that comes with a received value

How to use it: [Network](../network.md).

The second argument of the subscribe block.

## Instance methods

### Asterism::SampleInfo#from

<pre class="fmrb-sig"><code>from() -&gt; <a href="../String/">String</a>?</code></pre>

The sender, "node/app"

```ruby
do |v, info|
  who = info.from
end
```

### Asterism::SampleInfo#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a>?</code></pre>

The sender's node ID

```ruby
n = info.node
```

### Asterism::SampleInfo#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a>?</code></pre>

The sender's app name

```ruby
a = info.app
```

### Asterism::SampleInfo#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The topic's name

```ruby
t = info.name
```

### Asterism::SampleInfo#lost

<pre class="fmrb-sig"><code>lost() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many values were missed before this one

```ruby
warn_gap if info.lost > 0
```

### Asterism::SampleInfo#seq

<pre class="fmrb-sig"><code>seq() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The sender's sequence number

```ruby
s = info.seq
```

### Asterism::SampleInfo#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

The whole key it came on

```ruby
k = info.key
```

### Asterism::SampleInfo#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

The key below asterism/ ("<node>/<app>/<name>")

```ruby
p = info.path
```

### Asterism::SampleInfo#shared

<pre class="fmrb-sig"><code>shared() -&gt; (:node | :global)?</code></pre>

Which shared place (nil: an app's own topic)

```ruby
sh = info.shared
```

### Asterism::SampleInfo#run_id

<pre class="fmrb-sig"><code>run_id() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The sender's run id (nil when it came without one)

It changes when the sender connects again.
```ruby
r = info.run_id
```

### Asterism::SampleInfo#time

<pre class="fmrb-sig"><code>time() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The sender's time in ms since 1970 (nil unless ts: true)

```ruby
t = info.time
```

### Asterism::SampleInfo#timestamp

<pre class="fmrb-sig"><code>timestamp() -&gt; untyped</code></pre>

The router's timestamp (nil when none)

An Asterism::Zenoh::Timestamp.
```ruby
ts = info.timestamp
```

### Asterism::SampleInfo#encoding

<pre class="fmrb-sig"><code>encoding() -&gt; <a href="../String/">String</a></code></pre>

"msgpack", or the Zenoh encoding ("image/jpeg")

With "msgpack" the value is the decoded Ruby value; otherwise it is the
bytes (a String).
```ruby
if info.encoding == "image/jpeg"
  img = v
end
```

### Asterism::SampleInfo#restarted?

<pre class="fmrb-sig"><code>restarted?() -&gt; bool</code></pre>

Whether the sender started a new run

True when the sender connected again (its run id changed; lost is 0
then) or its numbers went back on the same run. Use it as the cue to ask for the
current value again.
```ruby
ask_again if info.restarted?
```

### Asterism::SampleInfo#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

All the fields as a Hash

The fields key, path, shared, from, node, app, name, seq, run_id,
time, encoding, timestamp, lost and restarted, with Symbol keys.
```ruby
puts info.to_h
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
