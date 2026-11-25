# Asterism::Status

Rules for an app's status

How to use it: [Network](../network.md).

The size limits of the status (a small Hash) that Connection#status handles, and
the function that tidies a received one. Read it for the shape of what status_of
answers.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`MAX_BYTES`</span> | [`Integer`](Integer.md) | The most bytes the packed status may take |
| <span class="fmrb-name">`MAX_DEPTH`</span> | [`Integer`](Integer.md) | The most levels of arrays and maps below the status |

## Class methods

### Asterism::Status.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Clean a received status

Keeps the entries with a non-empty String key. nil when it is not a
Hash or packs into more than MAX_BYTES. The answer of status_of went
through it.
```ruby
st = Asterism::Status.check(raw)
```

### Asterism::Status.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> key, <a href="../String/">String</a> payload) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Read a put on asterism/<node>/<app>/@status

Returns `[node, app, status]` from the key and payload as a
subscriber gets them; nil when it is not one.
```ruby
n, a, st = Asterism::Status.parse(k, b)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
