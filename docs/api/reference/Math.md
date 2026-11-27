# Math

Trigonometric, exponential and logarithmic functions

Takes an Integer or a Float and always returns a Float. A non-number (nil, a
String) raises TypeError.
**A value outside the domain raises `Math::DomainError`** (noted per function).
```ruby
Math.sqrt(2)   #=> 1.4142135623730951
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PI`</span> | [`Float`](Float.md) | The constant pi |
| <span class="fmrb-name">`E`</span> | [`Float`](Float.md) | The base of natural logarithms, e |

## Class methods

### Math.sin

<pre class="fmrb-sig"><code>sin(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Sine of x in radians

```ruby
y = Math.sin(t) * 20
```

### Math.cos

<pre class="fmrb-sig"><code>cos(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Cosine of x in radians

```ruby
x = Math.cos(t) * 20
```

### Math.tan

<pre class="fmrb-sig"><code>tan(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Tangent of x in radians

```ruby
Math.tan(Math::PI / 4)
```

### Math.asin

<pre class="fmrb-sig"><code>asin(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Arc sine

Returns -PI/2 to PI/2. **Raises DomainError when x is outside -1..1.**
```ruby
Math.asin(0.5)   #=> 0.5235987755982989
```

### Math.acos

<pre class="fmrb-sig"><code>acos(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Arc cosine

Returns 0 to PI. **Raises DomainError when x is outside -1..1.**
```ruby
Math.acos(0.5)   #=> 1.0471975511965979
```

### Math.atan

<pre class="fmrb-sig"><code>atan(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Arc tangent

```ruby
Math.atan(1)   #=> 0.7853981633974483
```

### Math.atan2

<pre class="fmrb-sig"><code>atan2(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> y, <a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Angle from y and x

**y comes first, then x.** Returns -PI to PI.
```ruby
a = Math.atan2(dy, dx)
```

### Math.sinh

<pre class="fmrb-sig"><code>sinh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Hyperbolic sine

```ruby
Math.sinh(1)
```

### Math.cosh

<pre class="fmrb-sig"><code>cosh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Hyperbolic cosine

```ruby
Math.cosh(1)
```

### Math.tanh

<pre class="fmrb-sig"><code>tanh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Hyperbolic tangent

```ruby
Math.tanh(1)
```

### Math.asinh

<pre class="fmrb-sig"><code>asinh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Inverse hyperbolic sine

```ruby
Math.asinh(1)
```

### Math.acosh

<pre class="fmrb-sig"><code>acosh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Inverse hyperbolic cosine

**Raises DomainError when x is less than 1.**
```ruby
Math.acosh(2)
```

### Math.atanh

<pre class="fmrb-sig"><code>atanh(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Inverse hyperbolic tangent

**Raises DomainError when x is outside -1..1.**
```ruby
Math.atanh(0.5)
```

### Math.exp

<pre class="fmrb-sig"><code>exp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

e raised to the power x

```ruby
Math.exp(1)   #=> 2.718281828459045
```

### Math.expm1

<pre class="fmrb-sig"><code>expm1(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

exp(x) minus 1

```ruby
Math.expm1(0.001)
```

### Math.log1p

<pre class="fmrb-sig"><code>log1p(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Natural log of 1 plus x

**Raises DomainError when x is less than -1.**
```ruby
Math.log1p(0.001)
```

### Math.log

<pre class="fmrb-sig"><code>log(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x, ?<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> base) -&gt; <a href="../Float/">Float</a></code></pre>

Natural log, or log to a given base

Without a base it is the natural log (base e); with one it returns
log(x) / log(base). `base` (e when left out).
**Raises DomainError when x or base is negative** (0 and 1 go straight to C's log).
```ruby
Math.log(8, 2)   #=> 3.0
```

### Math.log2

<pre class="fmrb-sig"><code>log2(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Base-2 logarithm

**Raises DomainError when x is negative.**
```ruby
Math.log2(8)   #=> 3.0
```

### Math.log10

<pre class="fmrb-sig"><code>log10(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Base-10 logarithm

**Raises DomainError when x is negative.**
```ruby
Math.log10(1000)   #=> 3.0
```

### Math.sqrt

<pre class="fmrb-sig"><code>sqrt(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Square root

**Raises DomainError when x is negative** (no complex result).
```ruby
Math.sqrt(dx * dx + dy * dy)
```

### Math.cbrt

<pre class="fmrb-sig"><code>cbrt(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Cube root

```ruby
Math.cbrt(27)   #=> 3.0
```

### Math.frexp

<pre class="fmrb-sig"><code>frexp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Array/">Array</a>[<a href="../Float/">Float</a> | <a href="../Integer/">Integer</a>]</code></pre>

Split into fraction and exponent

Returns [fraction (Float), exponent (Integer)]. x = fraction * 2 to the power of exponent.
```ruby
f, e = Math.frexp(1234)
#=> f = 0.6025390625, e = 11
```

### Math.ldexp

<pre class="fmrb-sig"><code>ldexp(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> fraction, <a href="../Integer/">Integer</a> exponent) -&gt; <a href="../Float/">Float</a></code></pre>

Compute fraction * 2 ** exponent

```ruby
Math.ldexp(0.5, 3)   #=> 4.0
```

### Math.hypot

<pre class="fmrb-sig"><code>hypot(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x, <a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> y) -&gt; <a href="../Float/">Float</a></code></pre>

Length of the hypotenuse

```ruby
Math.hypot(3, 4)   #=> 5.0
```

### Math.erf

<pre class="fmrb-sig"><code>erf(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Error function

```ruby
Math.erf(1)
```

### Math.erfc

<pre class="fmrb-sig"><code>erfc(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> x) -&gt; <a href="../Float/">Float</a></code></pre>

Complementary error function

```ruby
Math.erfc(1)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
