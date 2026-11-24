# Asterism::Types

Names and numbers of the built-in value types

How to use it: [Network](../network.md).

publish の `type:` に渡す組み込みの型。番号か Symbol (:vector3) で書く。自分の型は文字列で、Connection#define_type で決める。

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`NUMBER`</span> | [`Integer`](Integer.md) | A number (Float or Integer) |
| <span class="fmrb-name">`VECTOR3`</span> | [`Integer`](Integer.md) | [x, y, z] |
| <span class="fmrb-name">`POSE`</span> | [`Integer`](Integer.md) | [x, y, z, qx, qy, qz, qw] (ROS 2's Pose order) |
| <span class="fmrb-name">`IMAGE`</span> | [`Integer`](Integer.md) | An image (bytes in the topic's encoding) |
| <span class="fmrb-name">`STATE`</span> | [`Integer`](Integer.md) | A state (a String or an Integer) |
| <span class="fmrb-name">`LOG`</span> | [`Integer`](Integer.md) | A log record (level, msg, time) |
| <span class="fmrb-name">`TEXT`</span> | [`Integer`](Integer.md) | A String |

## Class methods

### Asterism::Types.number

<pre class="fmrb-sig"><code>number(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The number of a built-in type from its name (nil if none)

```ruby
Asterism::Types.number(:vector3)  #=> 2
```

### Asterism::Types.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Clean a received map of type definitions

Keeps the definitions with a String name and an "f" that is an Array
of `[field, type]` pairs, and drops the broken ones. nil when it is
not a Hash. The answer of types_of went through it.
```ruby
t = Asterism::Types.check(raw)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
