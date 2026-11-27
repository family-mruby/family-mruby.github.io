# Integer

An integer

Integer division truncates (make one side a `Float` for a fraction).
`times` and `downto` call a block, about 0.4ms each, so in a loop that
runs many times write `while`. `chr` returns a one-byte string for 0
to 255.

## Instance methods

### Integer#%

<pre class="fmrb-sig"><code>%(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

Calculate modulo

The remainder -- how you count round a ring.
```ruby
i = (i + 1) % 8
```

### Integer#&

<pre class="fmrb-sig"><code>&amp;(Integer other) -&gt; Integer</code></pre>

Perform bitwise AND operation

Bitwise and -- how you test a flag.
```ruby
if flags & 0x04 != 0
```

### Integer#*

<pre class="fmrb-sig"><code>*(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

Perform multiplication

Multiplying by a Float gives a Float.
```ruby
n * 2
n * 1.5  # Float
```

### Integer#**

<pre class="fmrb-sig"><code>**(Integer | <a href="../Float/">Float</a> other) -&gt; Integer</code></pre>

Calculate power

```ruby
2 ** 8  #=> 256
```

### Integer#+

<pre class="fmrb-sig"><code>+(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

Perform addition

```ruby
n + 1
```

### Integer#+@

<pre class="fmrb-sig"><code>+@() -&gt; Integer</code></pre>

Unary plus operator. Returns self

Returns the number unchanged.
```ruby
+n
```

### Integer#-

<pre class="fmrb-sig"><code>-(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

Perform subtraction

```ruby
n - 1
```

### Integer#-@

<pre class="fmrb-sig"><code>-@() -&gt; Integer</code></pre>

Unary minus operator. Inverts sign

```ruby
-n
```

### Integer#/

<pre class="fmrb-sig"><code>/(Integer | <a href="../Float/">Float</a> other) -&gt; (Integer | <a href="../Float/">Float</a>)</code></pre>

Perform division

**Integer division truncates.** Make one side a Float for a fraction.
```ruby
7 / 2      #=> 3
7 / 2.0    #=> 3.5
```

### Integer#<

<pre class="fmrb-sig"><code>&lt;(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

Perform less than comparison

```ruby
if x < w
```

### Integer#<<

<pre class="fmrb-sig"><code>&lt;&lt;(Integer other) -&gt; Integer</code></pre>

Perform left bit shift

A left shift multiplies by a power of two -- how you build a flag.
```ruby
1 << 3  #=> 8
```

### Integer#<=

<pre class="fmrb-sig"><code>&lt;=(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

Perform less than or equal comparison

```ruby
if x <= w
```

### Integer#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(Integer | untyped other) -&gt; Integer</code></pre>

Compare. Returns -1, 0 or 1

```ruby
a <=> b  #=> -1, 0, 1
```

### Integer#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

```ruby
if n == 0
```

### Integer#>

<pre class="fmrb-sig"><code>&gt;(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

Perform greater than comparison

```ruby
if n > 0
```

### Integer#>=

<pre class="fmrb-sig"><code>&gt;=(Integer | <a href="../Float/">Float</a> other) -&gt; bool</code></pre>

Perform greater than or equal comparison

```ruby
if n >= 0
```

### Integer#>>

<pre class="fmrb-sig"><code>&gt;&gt;(Integer other) -&gt; Integer</code></pre>

Perform right bit shift

A right shift divides by a power of two -- how you pull a byte out.
```ruby
(v >> 8) & 0xFF
```

### Integer#^

<pre class="fmrb-sig"><code>^(Integer other) -&gt; Integer</code></pre>

Perform bitwise XOR operation

Bitwise xor -- how you invert bits.
```ruby
v ^ 0xFF
```

### Integer#[]

<pre class="fmrb-sig"><code>[](untyped index) -&gt; Integer</code></pre>

Get value at specified bit position

The bit at that position, 0 or 1.
```ruby
v[0]  # the lowest bit
```

### Integer#abs

<pre class="fmrb-sig"><code>abs() -&gt; Integer</code></pre>

Get absolute value

```ruby
d = (a - b).abs
```

### Integer#round

<pre class="fmrb-sig"><code>round(?Integer ndigits) -&gt; Integer</code></pre>

Round at a digit

**Without ndigits, or with 0 or more, it returns the integer itself.** A negative
ndigits rounds at the tens, hundreds and so on (`1234.round(-2)` is 1200). A digit
too large gives 0.
```ruby
1234.round(-2)   #=> 1200
```

### Integer#chr

<pre class="fmrb-sig"><code>chr() -&gt; <a href="../String/">String</a></code></pre>

Return the character for this code

**0 to 255**, as a one-byte string.
```ruby
65.chr  #=> "A"
```

### Integer#downto

<pre class="fmrb-sig"><code>downto(Integer limit) { (Integer block_limit) -&gt; untyped } -&gt; Integer</code></pre>

Run the block from self down to the argument

What you want when deleting from the back.
```ruby
(a.length - 1).downto(0) do |i|
  a.delete_at(i) if drop?(a[i])
end
```

### Integer#times

<pre class="fmrb-sig"><code>times() { (Integer index) -&gt; untyped } -&gt; Integer</code></pre>

Execute block self times

**A block call costs about 0.4ms.** Rewrite a hot loop as `while`.
```ruby
8.times do |i|
  draw(i)
end
```

### Integer#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

Convert to floating point number

Used to move into floating point before a division.
```ruby
r = a.to_f / b
```

### Integer#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; Integer</code></pre>

Return self as integer value

Returns the number itself.
```ruby
n.to_i
```

### Integer#to_s

<pre class="fmrb-sig"><code>to_s(?Integer base) -&gt; <a href="../String/">String</a></code></pre>

Convert to string. Base can be specified with argument

**Takes a base** -- what you want for a hex log line.
```ruby
255.to_s      #=> "255"
255.to_s(16)  #=> "ff"
```

### Integer#|

<pre class="fmrb-sig"><code>|(Integer other) -&gt; Integer</code></pre>

Perform bitwise OR operation

Bitwise or -- how you set a flag.
```ruby
flags = flags | 0x04
```

### Integer#~

<pre class="fmrb-sig"><code>~() -&gt; Integer</code></pre>

Perform bitwise NOT operation

Inverts every bit -- how you clear a flag.
```ruby
flags = flags & ~0x04
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
