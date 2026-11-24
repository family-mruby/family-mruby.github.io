# Asterism::Profile

A node's profile: kind, name, host, icon

How to use it: [Network](../network.md).

端末が自分で言う種類・名前・場所・アイコンの決まりと、PNG のアイコンを調べる関数。名乗りを変えるのは Connection#profile と Asterism.profile_defaults。

## Class methods

### Asterism::Profile.png_info

<pre class="fmrb-sig"><code>png_info(untyped bytes) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Check a PNG icon: [width, height, icon_hash] (nil if not acceptable)

Checks a PNG a profile may carry: the 8-byte signature, 8192 bytes at
most, chunks running from IHDR to IEND, each side 256 pixels at most.
Returns `[width, height, icon_hash]` (8 hex digits), or nil.
```ruby
w, h, hash =
  Asterism::Profile.png_info(png)
```

### Asterism::Profile.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Clean a received profile

Keeps the valid fields (kind, protocol, host, name, icon, icon_hash).
nil when kind is not valid. A broken icon goes with its hash. The
answer of profile_of went through it.
```ruby
p = Asterism::Profile.check(raw)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
