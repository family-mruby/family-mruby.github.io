# MessagePack

Turn values into bytes with MessagePack, and back

How to use it: [Utilities](../utilities.md).

`pack` makes a String of bytes from a
Ruby value, `unpack` returns the value. `dump` and `load` are aliases.
```ruby
bin = MessagePack.pack({ "a" => [1, 2] })
MessagePack.unpack(bin)   #=> {"a"=>[1, 2]}
```

## Class methods

### MessagePack.pack

<pre class="fmrb-sig"><code>pack(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

Pack a value into bytes

Writes nil, true, false, Integer (up to 64 bits), Float (always double), String, Symbol,
Array and Hash. **A Symbol is written as a string**, so it comes back as a String (Hash keys too).
A String with the binary flag (`String#b` and the like) is written as bin, a plain String as str.

A type that cannot be written (a Range, your own class) raises RuntimeError
("Failed to pack object to msgpack").
```ruby
bin = MessagePack.pack({ cmd: "go" })
```

### MessagePack.unpack

<pre class="fmrb-sig"><code>unpack(<a href="../String/">String</a> binary) -&gt; untyped</code></pre>

Unpack bytes into a value

The String must hold **exactly one value**. Extra bytes, a cut-off value, an empty string,
an ext type or an integer of 2^63 and over raise RuntimeError ("Failed to unpack msgpack data").
A bin value comes back as a String with the binary flag.
```ruby
v = MessagePack.unpack(bin)
```

### MessagePack.dump

<pre class="fmrb-sig"><code>dump(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

Alias of pack

```ruby
bin = MessagePack.dump([1, 2])
```

### MessagePack.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> binary) -&gt; untyped</code></pre>

Alias of unpack

```ruby
v = MessagePack.load(bin)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
