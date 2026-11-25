# Float

A floating-point number

Arithmetic and comparison with `Integer` work. **Do not compare floats with `==`**;
compare the size of the difference. Dividing by 0.0 does not
raise; it gives Infinity. `to_i` truncates and `round` rounds.

## Instance methods

### Float#%

<pre class="fmrb-sig"><code>%(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Calculate modulo

```ruby
5.5 % 2.0  #=> 1.5
```

### Float#*

<pre class="fmrb-sig"><code>*(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Perform multiplication

```ruby
x * 0.5
```

### Float#**

<pre class="fmrb-sig"><code>**(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Calculate power

```ruby
2.0 ** 0.5
```

### Float#+

<pre class="fmrb-sig"><code>+(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Perform addition

```ruby
x + 1.0
```

### Float#+@

<pre class="fmrb-sig"><code>+@() -&gt; Float</code></pre>

Unary plus operator. Returns self

```ruby
+x
```

### Float#-

<pre class="fmrb-sig"><code>-(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Perform subtraction

```ruby
x - 1.0
```

### Float#-@

<pre class="fmrb-sig"><code>-@() -&gt; Float</code></pre>

Unary minus operator. Inverts sign

```ruby
-x
```

### Float#/

<pre class="fmrb-sig"><code>/(<a href="../Integer/">Integer</a> | Float other) -&gt; Float</code></pre>

Perform division

Dividing by 0.0 does not raise; it gives Infinity.
```ruby
x / 2.0
```

### Float#<

<pre class="fmrb-sig"><code>&lt;(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

Perform less than comparison

```ruby
if x < 1.0
```

### Float#<=

<pre class="fmrb-sig"><code>&lt;=(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

Perform less than or equal comparison

```ruby
if x <= 1.0
```

### Float#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(<a href="../Integer/">Integer</a> | Float other) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

Compare. Returns -1, 0 or 1

```ruby
a <=> b
```

### Float#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

**Do not compare floats with ==**; rounding drifts. Compare the size of
the difference.
```ruby
(a - b).abs < 0.001
```

### Float#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

Equality as `case` uses it

```ruby
case x
when 1.0 then hit
end
```

### Float#>

<pre class="fmrb-sig"><code>&gt;(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

Perform greater than comparison

```ruby
if x > 0.0
```

### Float#>=

<pre class="fmrb-sig"><code>&gt;=(<a href="../Integer/">Integer</a> | Float other) -&gt; bool</code></pre>

Perform greater than or equal comparison

```ruby
if x >= 0.0
```

### Float#abs

<pre class="fmrb-sig"><code>abs() -&gt; Float</code></pre>

Get absolute value

```ruby
d = (a - b).abs
```

### Float#round

<pre class="fmrb-sig"><code>round(?<a href="../Integer/">Integer</a> ndigits) -&gt; (<a href="../Integer/">Integer</a> | Float)</code></pre>

Round to the nearest

**Without ndigits, or with 0 or less, it returns an Integer; with 1 or more, a
Float.** A negative ndigits rounds at the tens, hundreds and so on (`1234.5.round(-2)`
is 1200). **A half goes away from zero** (`2.5.round` is 3, `-2.5.round` is -3). nan
and infinity raise FloatDomainError.
```ruby
3.14159.round(2)   #=> 3.14
2.5.round          #=> 3
```

### Float#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; Float</code></pre>

Return self as floating point number

Returns the number itself.
```ruby
x.to_f
```

### Float#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

Convert to integer (truncate)

**Truncates** rather than rounding; a negative number moves toward zero.
```ruby
1.9.to_i   #=> 1
(-1.9).to_i #=> -1
```

### Float#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

Convert to string

```ruby
x.to_s
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
