# FmrbToml::Raw

Holds a value to write unquoted

Usually made with `FmrbToml.raw`.
```ruby
r = FmrbToml::Raw.new("black")
r.text   #=> "black"
```

## Class methods

### FmrbToml::Raw.new

<pre class="fmrb-sig"><code>new(untyped text) -&gt; FmrbToml::Raw</code></pre>

Make one from text (kept as to_s)

```ruby
r = FmrbToml::Raw.new("black")
```

## Instance methods

### FmrbToml::Raw#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

The text it holds

```ruby
r.text   #=> "black"
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
