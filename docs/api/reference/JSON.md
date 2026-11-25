# JSON

Reading and writing JSON

How to use it: [Utilities](../utilities.md).

`JSON.parse` reads, `JSON.generate` writes; to take a part out
of a big JSON use `JSON::Digger`. **All of it is a small implementation in Ruby**, built
for size rather than speed.
```ruby
h = JSON.parse('{"a": [1, 2]}')
s = JSON.generate(h)   #=> "{\"a\":[1,2]}"
```

## Class methods

### JSON.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> json) -&gt; untyped</code></pre>

Parse a JSON string into Ruby values

`{}` becomes a Hash (**keys are always Strings**), `[]` an Array, numbers Integer or Float,
and `true`, `false`, `null` as themselves (`null` is nil).

Failure raises. A text that does not start with a value, an empty string and an unclosed
string raise `JSON::ParserError`; a broken structure (a missing `:` or `,`) raises
`JSON::JSONError` (the parent). **Trailing junk after the JSON is dropped silently**
(`"[1,2] xyz"` is `[1, 2]`).

**Do not trust `\uXXXX`.** It is packed into one byte, so Japanese is not read right. Pass
JSON with the text as UTF-8 instead. Floats are built by hand, so the last digits can
differ from CRuby. It is all Ruby, so reading a big JSON whole is heavy.
```ruby
h = JSON.parse('{"temp": 21.5}')
h["temp"]   #=> 21.5
```

### JSON.generate

<pre class="fmrb-sig"><code>generate(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

Turn a Ruby value into a JSON string

Writes Hash, Array, String, Integer, Float, true, false and nil. **A Symbol becomes a string**, and a Hash key is written as its `to_s`. **Any other object is written as its `to_s`** (no error).

The result is one line with no spaces. Japanese is left as it is (not escaped). `NaN` and
infinity do not raise either: the text `NaN` and the like go in, which is not valid JSON.
```ruby
JSON.generate({ "a" => [1, nil] })
#=> "{\"a\":[1,null]}"
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
