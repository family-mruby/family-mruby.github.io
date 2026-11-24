# Asterism::Topic

出したトピック (conn.publish の答え)

How to use it: [Network](../network.md).

## Instance methods

### Asterism::Topic#put

<pre class="fmrb-sig"><code>put(untyped value) -&gt; void</code></pre>

Send a value to the subscribers

Only nil, true, false, numbers, Strings, Symbols, Arrays and
Hashes (others raise Asterism::EncodeError). Every subscriber gets
it. A closed topic or a lost connection raises
Asterism::Disconnected.
```ruby
@said.put({ "from" => who,
            "text" => text })
```

### Asterism::Topic#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The topic's name

```ruby
n = @said.name
```

### Asterism::Topic#close

<pre class="fmrb-sig"><code>close() -&gt; bool</code></pre>

Withdraw the topic

```ruby
@said.close
```

### Asterism::Topic#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether the topic is withdrawn

```ruby
return if @said.closed?
```

### Asterism::Topic#connection

<pre class="fmrb-sig"><code>connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

The connection that published it

```ruby
c = @said.connection
```

### Asterism::Topic#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

The whole key values go on ("asterism/<node>/<app>/<name>")

```ruby
k = @said.key
```

### Asterism::Topic#entry

<pre class="fmrb-sig"><code>entry() -&gt; <a href="../String/">String</a></code></pre>

Its name in the declarations (the shared ones differ)

Same as name for an own topic; "<node>/@shared/<name>" or
"@shared/<name>" for a shared one. published returns these.
```ruby
e = @said.entry
```

### Asterism::Topic#shared

<pre class="fmrb-sig"><code>shared() -&gt; (:node | :global)?</code></pre>

Which shared place it is on (nil: the app's own)

nil is the app's own key, :node the node's @shared, :global the
network's @shared.
```ruby
s = @said.shared
```

### Asterism::Topic#encoding

<pre class="fmrb-sig"><code>encoding() -&gt; <a href="../String/">String</a>?</code></pre>

The Zenoh encoding of the values (nil: MessagePack)

What publish's `encoding:` was given ("image/jpeg", ...).
```ruby
e = @cam.encoding
```

### Asterism::Topic#seq

<pre class="fmrb-sig"><code>seq() -&gt; <a href="../Integer/">Integer</a></code></pre>

The sequence number the next put sends

Starts at 0 and goes back to 0 after 2147483647.
```ruby
n = @said.seq
```

### Asterism::Topic#ts?

<pre class="fmrb-sig"><code>ts?() -&gt; bool</code></pre>

Whether each value carries the sender's time

True when publish got `ts: true`.
```ruby
t = @said.ts?
```

### Asterism::Topic#declaration

<pre class="fmrb-sig"><code>declaration() -&gt; <a href="../Hash/">Hash</a></code></pre>

The declaration as sent

The fields that were given out of `{"t" => type, "u" => unit,
"d" => text, "e" => encoding number, "ts" => true}`. A copy.
```ruby
d = @said.declaration
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
