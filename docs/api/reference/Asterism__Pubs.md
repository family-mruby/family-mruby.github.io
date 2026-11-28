# Asterism::Pubs

Rules for the topic declarations (@pubs)

How to use it: [Network](../network.md).

The rules for sending the declarations of the topics being published
({"name" => {"t", "e", "u", "d", "ts"}}), and the table of encoding numbers.
Read it for the shape of what pubs_of and publishers_of answer.

## Class methods

### Asterism::Pubs.encoding_id

<pre class="fmrb-sig"><code>encoding_id(<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The fixed number of a Zenoh encoding (nil when none)

"image/jpeg" or "text/plain;charset=utf-8" (what follows ";" is
ignored).
```ruby
Asterism::Pubs.encoding_id(
  "image/jpeg")  #=> 17
```

### Asterism::Pubs.encoding_name

<pre class="fmrb-sig"><code>encoding_name(<a href="../Integer/">Integer</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

The encoding name of a number (nil when none)

```ruby
Asterism::Pubs.encoding_name(17)
#=> "image/jpeg"
```

### Asterism::Pubs.place

<pre class="fmrb-sig"><code>place(<a href="../String/">String</a> entry) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Split a declaration entry into [shared, node, name]

An own topic gives `[nil, nil, name]`, "<node>/@shared/<name>" gives
`[:node, node, name]`, "@shared/<name>" gives `[:global, nil, name]`.
nil for a form that is not a name.
```ruby
Asterism::Pubs.place("@shared/lobby")
#=> [:global, nil, "lobby"]
```

### Asterism::Pubs.entry

<pre class="fmrb-sig"><code>entry(<a href="../Symbol/">Symbol</a>? shared, <a href="../String/">String</a> node, <a href="../String/">String</a> name) -&gt; <a href="../String/">String</a></code></pre>

The declaration entry of a topic

`shared` is nil, :node or :global: name as it is, "<node>/@shared/<name>"
or "@shared/<name>".
```ruby
Asterism::Pubs.entry(
  :global, "n", "lobby")
#=> "@shared/lobby"
```

### Asterism::Pubs.path

<pre class="fmrb-sig"><code>path(<a href="../String/">String</a> node, <a href="../String/">String</a> app, <a href="../String/">String</a> entry) -&gt; <a href="../String/">String</a>?</code></pre>

The key below asterism/ a declared entry puts values on

`path("n", "app", "imu")` is "n/app/imu"; a shared entry is the key
itself. nil when the entry is not valid.
```ruby
Asterism::Pubs.path("n", "app", "imu")
#=> "n/app/imu"
```

### Asterism::Pubs.check

<pre class="fmrb-sig"><code>check(untyped h, ?<a href="../String/">String</a>? node) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Clean a received map of declarations

Keeps entries with a valid name and a Hash declaration, with only the
valid "t", "e", "u", "d" and "ts". With node (the node that declared
them), another node's shared entries are dropped. nil when it is not
a Hash. The answer of pubs_of went through it.
```ruby
d = Asterism::Pubs.check(raw, "n")
```

### Asterism::Pubs.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> key, <a href="../String/">String</a> payload) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Read a put on asterism/<node>/<app>/@pubs

Returns `[node, app, declarations]` from the key and payload as a
subscriber gets them; nil when it is not one.
```ruby
n, a, d = Asterism::Pubs.parse(k, b)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
