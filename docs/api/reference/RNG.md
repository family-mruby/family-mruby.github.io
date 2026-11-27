# RNG

The source of random numbers

An ESP32 uses `esp_random()` (the hardware RNG);
Linux and the native build read `/dev/urandom` (opening the file once per byte, so
producing many numbers is slow).
```ruby
r = RNG.random_int % 10
```

## Class methods

### RNG.random_int

<pre class="fmrb-sig"><code>random_int() -&gt; <a href="../Integer/">Integer</a></code></pre>

A random 32-bit integer

An integer from **0 to 4294967295** (never negative). Narrow it with `% n` to get 0
to n-1 (what `Kernel#rand(n)` does). **There is no way to seed it.**
```ruby
RNG.random_int % 10   #=> 0..9
```

### RNG.random_string

<pre class="fmrb-sig"><code>random_string(<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

A random binary string

A binary string of length bytes (bytes, not characters; count it with `bytesize`).
```ruby
key = RNG.random_string(16)
```

### RNG.uuid

<pre class="fmrb-sig"><code>uuid() -&gt; <a href="../String/">String</a></code></pre>

A version 4 UUID string

36 characters: lower-case hex in groups of `8-4-4-4-12` joined by `-`. It draws 32
random numbers, so it is not cheap.
```ruby
id = RNG.uuid
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
