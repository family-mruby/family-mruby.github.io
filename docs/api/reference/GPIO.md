# GPIO

Uses one pin as input or output. `GPIO.new(pin, flags)` makes it, then `read` and `write`.
Join flags with `|`, as in `GPIO::IN | GPIO::PULL_UP`. **A pin is an integer only.** Check
with `FmrbHw.pin_available?` which pins you may use.
```ruby
led = GPIO.new(5, GPIO::OUT)
led.write(1)
```

How to use it: [Hardware Control](../peripherals.md).

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`IN`</span> | [`Integer`](Integer.md) | Input |
| <span class="fmrb-name">`OUT`</span> | [`Integer`](Integer.md) | Output |
| <span class="fmrb-name">`HIGH_Z`</span> | [`Integer`](Integer.md) | High impedance (set up as an input here) |
| <span class="fmrb-name">`PULL_UP`</span> | [`Integer`](Integer.md) | Pull-up |
| <span class="fmrb-name">`PULL_DOWN`</span> | [`Integer`](Integer.md) | Pull-down |
| <span class="fmrb-name">`OPEN_DRAIN`</span> | [`Integer`](Integer.md) | Open drain (does nothing here) |
| <span class="fmrb-name">`ALT`</span> | [`Integer`](Integer.md) | Alternate function (does nothing here) |

## Class methods

### GPIO.new

<pre class="fmrb-sig"><code>new(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> flags, ?<a href="../Integer/">Integer</a> alt_function) -&gt; GPIO</code></pre>

Open a pin

Pass in `flags` **one** of `IN`, `OUT` and `HIGH_Z`, plus `PULL_UP` or `PULL_DOWN` if
needed, joined with `|`. `alt_function` (0 when left out) is for ALT and has no effect here.

**A pin that is already in use does not raise.** The pin is claimed in the table, but a
refusal is not looked at and setup and I/O go on. **To keep off system-only pins**, check
`FmrbHw.pin_available?` first.

A String or Symbol pin is an ArgumentError ("Wrong GPIO pin name"), and so is a negative
number. No direction, or two or more, is an ArgumentError ("You must specify one of IN, OUT,
HIGH_Z, and ALT", "IN, OUT and HIGH_Z are exclusive"), and so are both `PULL_UP` and `PULL_DOWN`.
```ruby
sw = GPIO.new(7, GPIO::IN | GPIO::PULL_UP)
```

### GPIO.set_dir_at

<pre class="fmrb-sig"><code>set_dir_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> dir) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set direction by pin number (no claim)

**It skips `GPIO.new`, so the pin is not claimed** and nothing else is remembered. `dir`
is `IN` or `OUT`. Returns 0. Normally use `GPIO.new`.
```ruby
GPIO.set_dir_at(5, GPIO::OUT)
```

### GPIO.pull_up_at

<pre class="fmrb-sig"><code>pull_up_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Pull a pin up by number

Like `set_dir_at`, it does not claim the pin. Returns 0.
```ruby
GPIO.pull_up_at(7)
```

### GPIO.pull_down_at

<pre class="fmrb-sig"><code>pull_down_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Pull a pin down by number

Like `set_dir_at`, it does not claim the pin. Returns 0.
```ruby
GPIO.pull_down_at(7)
```

### GPIO.open_drain_at

<pre class="fmrb-sig"><code>open_drain_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Open drain by number (does nothing)

This machine's link does nothing. Returns 0.
```ruby
GPIO.open_drain_at(7)
```

### GPIO.set_function_at

<pre class="fmrb-sig"><code>set_function_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> function) -&gt; <a href="../Integer/">Integer</a></code></pre>

Alternate function by number (does nothing)

This machine's link does nothing. Returns 0.
```ruby
GPIO.set_function_at(7, 1)
```

### GPIO.read_at

<pre class="fmrb-sig"><code>read_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read by pin number

Same as `GPIO#read` (0 or 1, -1 on failure). A String, a Symbol or a negative number is an ArgumentError.
```ruby
GPIO.read_at(7)
```

### GPIO.write_at

<pre class="fmrb-sig"><code>write_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write by pin number

Same as `GPIO#write` (0 or 1 only; returns 0).
```ruby
GPIO.write_at(5, 1)
```

### GPIO.high_at?

<pre class="fmrb-sig"><code>high_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

Whether a pin is high, by number

読んだ値が 0 でなければ true。
```ruby
GPIO.high_at?(7)
```

### GPIO.low_at?

<pre class="fmrb-sig"><code>low_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

Whether a pin is low, by number

読んだ値が 0 なら true。
```ruby
GPIO.low_at?(7)
```

## Instance methods

### GPIO#pin

<pre class="fmrb-sig"><code>pin() -&gt; <a href="../Integer/">Integer</a></code></pre>

The pin number

```ruby
led.pin   #=> 5
```

### GPIO#setmode

<pre class="fmrb-sig"><code>setmode(<a href="../Integer/">Integer</a> flags, ?<a href="../Integer/">Integer</a> alt_function) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set direction and pull again

Takes the same combinations as `new`. **Without a direction flag the direction stays as**
**it is**, and so does the pull. Returns 0.
```ruby
sw.setmode(GPIO::IN | GPIO::PULL_DOWN)
```

### GPIO#read

<pre class="fmrb-sig"><code>read() -&gt; <a href="../Integer/">Integer</a></code></pre>

Read the level (0 or 1)

**-1** on failure (no exception). -1 is not 0, so `high?` is true then.
```ruby
sw.read   #=> 0 or 1
```

### GPIO#write

<pre class="fmrb-sig"><code>write(<a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write the level (0 or 1)

Anything but 0 and 1 is an ArgumentError ("Wrong value. 0 and 1 are only valid"). Returns 0.
Use it on a pin set as an output.
```ruby
led.write(1)
```

### GPIO#high?

<pre class="fmrb-sig"><code>high?() -&gt; bool</code></pre>

Whether the level is high

true when the value read is not 0 (also when the read failed and gave -1).
```ruby
pressed = !sw.high?
```

### GPIO#low?

<pre class="fmrb-sig"><code>low?() -&gt; bool</code></pre>

Whether the level is low

true when the value read is 0.
```ruby
pressed = sw.low?
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
