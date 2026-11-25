# JSON::Digger

Take a part out of a big JSON

How to use it: [Utilities](../utilities.md).

Scans the string without reading the whole JSON and cuts out the part `dig` points at.
It is for small memory: `parse` turns the cut part into a Ruby value.
```ruby
j = '[{"d": {"name": "Remo"}}]'
JSON::Digger.new(j).dig(0, "d", "name").parse
#=> "Remo"
```

## Class methods

### JSON::Digger.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> json) -&gt; JSON::Digger</code></pre>

Make one on a JSON string

```ruby
d = JSON::Digger.new(text)
```

## Instance methods

### JSON::Digger#dig

<pre class="fmrb-sig"><code>dig(*<a href="../String/">String</a> | <a href="../Integer/">Integer</a> keys) -&gt; JSON::Digger</code></pre>

Follow keys and positions to a part

A String is a Hash key, an Integer an Array position (from 0; **a negative number is an ArgumentError**). It returns itself, so `dig` and `parse` can follow.
**After digging, this Digger holds only the cut part.** There is no way back: the next
`dig` goes inside it. To take another place from the same source, make a new Digger.

A missing key raises `JSON::DiggerError` ("Key not found: name"). A shape that does not
fit (a position on a Hash, a key on an Array) raises `JSON::JSONError`. Anything but a
String or an Integer is an ArgumentError.
An Array position past the end (an empty Array included) raises
`JSON::DiggerError` ("Array index out of range").
```ruby
d = JSON::Digger.new('{"a": [10, 20]}')
d.dig("a", 1).parse   #=> 20
```

### JSON::Digger#parse

<pre class="fmrb-sig"><code>parse() -&gt; untyped</code></pre>

Turn the part it points at into a Ruby value

```ruby
JSON::Digger.new('[1, 2]').dig(1).parse
#=> 2
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
