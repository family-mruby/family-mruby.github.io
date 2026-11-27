# Fmrb::Fft

Compute the spectrum of a sound

How to use it: [Utilities](../utilities.md).

Pass **a byte String of 16-bit integers** (little-endian)
and get **a byte String of magnitudes in the same form**. The methods (`backend:`) are
`:ruby`, `:c`, `:dsp`, `:spinel`, `:c64`, and the integer-only `:ruby_q15`, `:c_q15`,
`:spinel_q15`. **They all take and give the same thing**; they differ in speed and in
which builds have them.
```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
mag = fft.forward(pcm)
Fmrb::Fft.bin(mag, 8)
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`BACKENDS`</span> | `Array[Symbol]` | The names of the backends |
| <span class="fmrb-name">`Q15_BACKENDS`</span> | `Array[Symbol]` | The fixed-point backends |

## Class methods

### Fmrb::Fft.new

<pre class="fmrb-sig"><code>new(?size: <a href="../Integer/">Integer</a>, ?backend: <a href="../Symbol/">Symbol</a>) -&gt; Fmrb::Fft</code></pre>

Make a transform

`size:` (512 when left out) is **a power of two from 64 to 1024**, `backend:` (`:ruby` when
left out). An unknown backend or size is an ArgumentError ("unknown FFT backend: x", "FFT
size must be a power of two in 64..1024: n"). **Check a backend with `Fmrb::Fft.available?`**
**first**: not every build has every one.

`:spinel` and `:spinel_q15` are one instance for the machine, **held by the app that opened**
**it first**. A second app silently gets `:ruby` or `:ruby_q15` (see `backend`). A build
without it raises RuntimeError. Call `close` when done.
```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
```

### Fmrb::Fft.available?

<pre class="fmrb-sig"><code>available?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

Whether this build has a backend

`:ruby`, `:c`, `:c64` and their Q15 forms are always true. **`:dsp` only in a real-board**
**build with esp-dsp**, the `:spinel` ones only in a build that has the Spinel FFT. An
unknown name is false.
```ruby
Fmrb::Fft.available?(:dsp)
```

### Fmrb::Fft.q15?

<pre class="fmrb-sig"><code>q15?(<a href="../Symbol/">Symbol</a> backend) -&gt; bool</code></pre>

Whether a backend is fixed-point

```ruby
Fmrb::Fft.q15?(:c_q15)   #=> true
```

### Fmrb::Fft.micros

<pre class="fmrb-sig"><code>micros() -&gt; <a href="../Integer/">Integer</a></code></pre>

The clock every backend is timed with (microseconds)

Use differences.
```ruby
t = Fmrb::Fft.micros
```

### Fmrb::Fft.spinel_total_us

<pre class="fmrb-sig"><code>spinel_total_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

Total cost of the last Spinel call

Microseconds of the last whole `:spinel` call (passing samples in, results out, and the
first table build). Its gap to the transform-only time `run` returned is the cost of
crossing the boundary.
```ruby
Fmrb::Fft.spinel_total_us
```

### Fmrb::Fft.sine

<pre class="fmrb-sig"><code>sine(?size: <a href="../Integer/">Integer</a>, ?cycles: <a href="../Integer/">Integer</a>, ?amp: <a href="../Integer/">Integer</a>) -&gt; <a href="../String/">String</a></code></pre>

Make a test sine wave

`size:` samples (512 when left out) holding `cycles:` periods (8 when left out) at
amplitude `amp:` (12000 when left out), as 16-bit integer bytes. Its peak lands on bin `cycles`.
```ruby
pcm = Fmrb::Fft.sine(size: 512, cycles: 8)
```

### Fmrb::Fft.bin

<pre class="fmrb-sig"><code>bin(<a href="../String/">String</a> mag, <a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read one magnitude

The value at `index` (0..32767). **Out of range is 0** (no exception).
```ruby
h = Fmrb::Fft.bin(mag, 8)
```

### Fmrb::Fft.peak_bin

<pre class="fmrb-sig"><code>peak_bin(<a href="../String/">String</a> mag) -&gt; <a href="../Integer/">Integer</a></code></pre>

The index of the loudest bin

Bin 0 (the DC part) counts. On a tie the lower index wins.
```ruby
Fmrb::Fft.peak_bin(mag)   #=> 8
```

### Fmrb::Fft.bench

<pre class="fmrb-sig"><code>bench(
  ?size: <a href="../Integer/">Integer</a>,
  ?iters: <a href="../Integer/">Integer</a>,
  ?backend: <a href="../Symbol/">Symbol</a>,
  ?reps: <a href="../Integer/">Integer</a>,
  ?samples: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped]</code></pre>

Time one backend

Defaults: `size:` 512, `iters:` 100, `backend:` `:c`, `reps:` 5, `samples:` a `sine`. It runs
`iters` transforms `reps` times. The result is a Hash: `:backend` (asked for), `:ran_on`
(ran), `:size`, `:iters`, `:reps`, `:us_avg` (per transform on average, a Float), `:us_min`
(per transform in the best rep), `:mag`, `:peak_bin`. An unusable backend raises as `new` does.
```ruby
r = Fmrb::Fft.bench(backend: :c)
r[:us_avg]
```

## Instance methods

### Fmrb::Fft#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

The transform size

```ruby
fft.size   #=> 512
```

### Fmrb::Fft#backend

<pre class="fmrb-sig"><code>backend() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

The backend actually running

It can differ from the one asked for (when another app holds Spinel).
```ruby
fft.backend   #=> :c
```

### Fmrb::Fft#forward

<pre class="fmrb-sig"><code>forward(<a href="../String/">String</a> samples) -&gt; <a href="../String/">String</a></code></pre>

One transform, returning the magnitudes

`samples` is **`size` little-endian 16-bit integers as bytes** (`size * 2` bytes). The result
is size/2 little-endian 16-bit integers: **Hann-windowed, scaled by 2/size and clamped at**
**32767**. Bin 0 is the DC part and tends to be the loudest. Read it with `Fmrb::Fft.bin`.

The `:c` family **raises ArgumentError when too short** ("need 512 int16 samples, got n
bytes"). **The `:ruby` family treats the missing part as 0 and goes on silently.**
```ruby
mag = fft.forward(pcm)
```

### Fmrb::Fft#run

<pre class="fmrb-sig"><code>run(<a href="../String/">String</a> samples, <a href="../Integer/">Integer</a> iters) -&gt; [ <a href="../Integer/">Integer</a>, <a href="../String/">String</a> ]</code></pre>

Transform the same input iters times, timed

Returns `[microseconds, magnitude bytes]`. The time is **the transforms only, measured**
**inside the engine** (not the call's cost). `iters` is 1 or more (the `:c` family raises
ArgumentError below that). **This is the form an app uses for each frame.**
```ruby
us, mag = fft.run(pcm, 1)
```

### Fmrb::Fft#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Be done with it

Gives up the Spinel instance (nothing for the other backends). Returns nil. **Call it**
**when the app ends if you used a `:spinel` backend.**
```ruby
fft.close
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
