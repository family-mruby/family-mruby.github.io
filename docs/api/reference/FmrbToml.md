# FmrbToml

Read TOML; rewrite it by line

`load` reads a file and `parse` a
string into a Hash. **A failure is nil, not an exception**; `FmrbToml.error` says why. The
only writer is `update`, which **changes only the lines of the keys you name**, so comments,
order and keys nobody here knows stay as a person wrote them.
```ruby
conf = FmrbToml.load("/home/app.toml")
n = conf ? conf["name"] : nil
```

## Class methods

### FmrbToml.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> text) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

Parse a TOML string into a Hash

A table (`[a]`) is a Hash, an array an Array, `[[name]]` an Array of Hash. Strings,
integers (`0x..` too), floats and true/false come back as themselves. **A date and an unquoted word (`bg = black`)**
come back as the text that was written.

Text that is not TOML (even one bad line) gives nil; `FmrbToml.error` says why. No exception.
```ruby
FmrbToml.parse("a = 1\n[s]\nb = \"x\"\n")
#=> {"a"=>1, "s"=>{"b"=>"x"}}
```

### FmrbToml.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

Read a TOML file into a Hash

A missing file gives nil with no log line (the ordinary state of a setting nobody has
changed). An unreadable file or one that is not TOML gives nil and one log line
(`toml: path: reason`). Either way `FmrbToml.error` has the reason.
```ruby
conf = FmrbToml.load("/home/app.toml")
```

### FmrbToml.error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

Why the last parse, load or update gave nil

nil after a success.
```ruby
Log.warn(FmrbToml.error) if conf.nil?
```

### FmrbToml.update

<pre class="fmrb-sig"><code>update(
  <a href="../String/">String</a> path,
  <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped] values
) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

Set keys in a file, leaving the other lines alone

values is a Hash of `name => value`. A name is a top-level key (`"rise_mg"`) or
`"table.key"` (`"editor.bg"`; the last `.` splits table from key). A missing key is added
(a missing table goes at the end of the file), and **a nil value removes the key**. A value
is a String, a Symbol (written as a string), an Integer, a Float, true/false, an Array, a
Hash, or an unquoted word from `FmrbToml.raw`.

The file is read back afterwards, and the Hash it holds now is returned when it has the
values. A file that exists but is not TOML is **left untouched** and gives nil (it is
somebody's text). A failed write or a value that does not read back is nil too. All of
them leave the reason in `FmrbToml.error`. A missing file is created.
```ruby
FmrbToml.update("/home/app.toml",
                { "editor.bg" => 36 })
```

### FmrbToml.raw

<pre class="fmrb-sig"><code>raw(<a href="../String/">String</a> text) -&gt; <a href="../FmrbToml__Raw/">FmrbToml::Raw</a></code></pre>

A value written as it is, unquoted

Passed to `update`, it is written without quotes even though it is text (a colour name,
`bg = black`).
```ruby
FmrbToml.update(path,
  { "shell.bg" => FmrbToml.raw("black") })
```

### FmrbToml.dump_value

<pre class="fmrb-sig"><code>dump_value(untyped value) -&gt; <a href="../String/">String</a></code></pre>

The TOML text of one value

A String is quoted and escaped, numbers and true/false as they are, an Array or a Hash in
one-line inline form. A Symbol is a string. **Anything else is an ArgumentError**
("no TOML for ClassName").
```ruby
FmrbToml.dump_value("a\"b")  #=> "\"a\\\"b\""
```

### FmrbToml.dump_key

<pre class="fmrb-sig"><code>dump_key(<a href="../String/">String</a> key) -&gt; <a href="../String/">String</a></code></pre>

The TOML text of a key

Returned as it is when it holds only letters, digits, `_` and `-`; otherwise quoted.
```ruby
FmrbToml.dump_key("a b")  #=> "\"a b\""
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
