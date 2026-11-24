# Asterism::ROS::Message

The base of the generated message types

How to use it: [Network](../network.md).

型ごとに ROS_NAME・欄ごとの読み書きができる。欄は Hash か型の `new(欄: 値)` で渡せる (書かない欄は既定の値、知らない欄は ArgumentError)。パターンマッチでも読める (`case m in { x: }`)。

## Class methods

### Asterism::ROS::Message.from

<pre class="fmrb-sig"><code>from(untyped v) -&gt; Asterism::ROS::Message</code></pre>

A message from nil, a Hash of fields or a message

nil gives all defaults, a Hash gives the fields (Symbol or String
keys; missing fields take defaults, unknown ones raise
ArgumentError), a message of this type is returned as it is. TypeError
for anything else. A class method of a generated type (what
`require_type` returns).
```ruby
t = Asterism::ROS.require_type(
  "std_msgs/msg/String")
m = t.from({ data: "hi" })
```

### Asterism::ROS::Message.encode

<pre class="fmrb-sig"><code>encode(untyped msg) -&gt; <a href="../String/">String</a></code></pre>

The CDR bytes (with its 4-byte header) of a message or Hash

```ruby
b = t.encode({ data: "hi" })
```

### Asterism::ROS::Message.decode

<pre class="fmrb-sig"><code>decode(<a href="../String/">String</a> bytes) -&gt; Asterism::ROS::Message</code></pre>

Decode a message from CDR bytes

Raises Asterism::CDR::DecodeError when the bytes do not fit.
```ruby
m = t.decode(b)
```

## Instance methods

### Asterism::ROS::Message#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

The fields as a Hash (nested messages as Hashes)

```ruby
h = m.to_h
```

### Asterism::ROS::Message#deconstruct_keys

<pre class="fmrb-sig"><code>deconstruct_keys(untyped keys) -&gt; <a href="../Hash/">Hash</a></code></pre>

For pattern matching (`case m in { linear: { x: } }`)

Nested messages stay messages.
```ruby
case m in { data: d } then show(d) end
```

### Asterism::ROS::Message#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Same type and equal fields

```ruby
same = m1 == m2
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
