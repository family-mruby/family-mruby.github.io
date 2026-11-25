# Digest::SHA256

Compute SHA-256

**Only in the browser build.** Code that must run on the other builds checks
`Object.const_defined?(:Digest)` first (the chat app's stamps.rb does).
```ruby
d = Digest::SHA256.new
d.update("abc")
d.hexdigest.size   #=> 64
```

## Class methods

### Digest::SHA256.new

<pre class="fmrb-sig"><code>new() -&gt; Digest::SHA256</code></pre>

Start a new computation

```ruby
d = Digest::SHA256.new
```

### Digest::SHA256.hexdigest

<pre class="fmrb-sig"><code>hexdigest(<a href="../String/">String</a> data) -&gt; <a href="../String/">String</a></code></pre>

One-shot, as a hex string

Takes a String (bytes are fine); anything else is a TypeError. The result is 64
lowercase hex digits.
```ruby
Digest::SHA256.hexdigest("abc")
#=> "ba7816bf8f01cfea..." (64 digits)
```

## Instance methods

### Digest::SHA256#update

<pre class="fmrb-sig"><code>update(<a href="../String/">String</a> data) -&gt; Digest::SHA256</code></pre>

Add more data

Returns itself, so `d.update(a).update(b)` chains. `<<` is the same.
```ruby
d.update(chunk)
```

### Digest::SHA256#<<

<pre class="fmrb-sig"><code>&lt;&lt;(<a href="../String/">String</a> data) -&gt; Digest::SHA256</code></pre>

Alias of update

```ruby
d << chunk
```

### Digest::SHA256#hexdigest

<pre class="fmrb-sig"><code>hexdigest() -&gt; <a href="../String/">String</a></code></pre>

The result so far, as hex

**Safe to call any number of times, and `update` may go on afterwards** (the state is untouched).
```ruby
d.hexdigest   #=> 64 lowercase hex digits
```

### Digest::SHA256#digest

<pre class="fmrb-sig"><code>digest() -&gt; <a href="../String/">String</a></code></pre>

The result so far, as 32 bytes

Does not change the state, like `hexdigest`.
```ruby
raw = d.digest
raw.bytesize   #=> 32
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
