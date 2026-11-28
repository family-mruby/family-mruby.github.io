# GPIO

Use one pin as input or output

How to use it: [Hardware Control](../peripherals.md).

`GPIO.new(pin, flags)` makes it, then `read` and `write`.
Join flags with `|`, as in `GPIO::IN | GPIO::PULL_UP`. **A pin is an integer only.** Check
with `FmrbHw.pin_available?` which pins you may use (a system pin or one in use raises IOError).
```ruby
led = GPIO.new(5, GPIO::OUT)
led.write(1)
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`IN`</span> | [`Integer`](Integer.md) | Input |
| <span class="fmrb-name">`OUT`</span> | [`Integer`](Integer.md) | Output |
| <span class="fmrb-name">`HIGH_Z`</span> | [`Integer`](Integer.md) | High impedance |
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

The pin is claimed in the pin table.
**When it cannot be, IOError is raised and the pin's setup (direction, pull) is left alone**:
a system pin (one `FmrbHw.pin_status` gives as `PIN_SYSTEM_EXCLUSIVE`) is "GPIO n is used by
the system", a pin another app (or another use such as I2C) holds is "GPIO n is in use by
another app or driver".
**The board's buttons** are not claimed and open with `IN` (pulls too) only; `OUT` and the like
raise "GPIO n is input only (a system button or a chip's interrupt line)". A claimed pin goes back to the table when the
app ends.

A String or Symbol pin is an ArgumentError ("Wrong GPIO pin name"), and so is a negative
number; a number this board does not have is an ArgumentError ("GPIO n does not exist on
this board"). No direction, or two or more, is an ArgumentError ("You must specify one of IN, OUT,
HIGH_Z, and ALT", "IN, OUT and HIGH_Z are exclusive"), and so are both `PULL_UP` and `PULL_DOWN`.
```ruby
sw = GPIO.new(7, GPIO::IN | GPIO::PULL_UP)
```

### GPIO.set_dir_at

<pre class="fmrb-sig"><code>set_dir_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> dir) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set direction by pin number

Checked against the pin table as `GPIO.new` is: a free pin becomes this app's, a system pin
or one in use raises IOError (nothing is changed). A board button takes `IN` only. Nothing
else is remembered. `dir` is `IN` or `OUT`. Returns 0. Normally use `GPIO.new`.
```ruby
GPIO.set_dir_at(5, GPIO::OUT)
```

### GPIO.pull_up_at

<pre class="fmrb-sig"><code>pull_up_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Pull a pin up by number

Checked against the pin table like `set_dir_at` (a board button takes it too). Returns 0.
```ruby
GPIO.pull_up_at(7)
```

### GPIO.pull_down_at

<pre class="fmrb-sig"><code>pull_down_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Pull a pin down by number

Checked against the pin table like `set_dir_at` (a board button takes it too). Returns 0.
```ruby
GPIO.pull_down_at(7)
```

### GPIO.open_drain_at

<pre class="fmrb-sig"><code>open_drain_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Open drain by number (does nothing)

This machine's link does nothing. Returns 0. Checked against the pin table as an output (IOError when refused).
```ruby
GPIO.open_drain_at(7)
```

### GPIO.set_function_at

<pre class="fmrb-sig"><code>set_function_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> function) -&gt; <a href="../Integer/">Integer</a></code></pre>

Alternate function by number (does nothing)

This machine's link does nothing. Returns 0. Checked against the pin table as an output (IOError when refused).
```ruby
GPIO.set_function_at(7, 1)
```

### GPIO.read_at

<pre class="fmrb-sig"><code>read_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

Read by pin number

0 or 1. **Reading changes nothing, so any pin can be read**, a system pin or one in use too
(it is not claimed). IOError when it cannot be read. A String, a Symbol, a negative number or
a number this board does not have is an ArgumentError.
```ruby
GPIO.read_at(7)
```

### GPIO.write_at

<pre class="fmrb-sig"><code>write_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write by pin number

Same as `GPIO#write` (0 or 1 only; returns 0). Checked against the pin table like
`set_dir_at`: a free pin becomes this app's; a system pin (a button too) or one in use raises IOError.
```ruby
GPIO.write_at(5, 1)
```

### GPIO.high_at?

<pre class="fmrb-sig"><code>high_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

Whether a pin is high, by number

True when the value read is not 0. Any pin can be read, as with `read_at`; IOError when it cannot be.
```ruby
GPIO.high_at?(7)
```

### GPIO.low_at?

<pre class="fmrb-sig"><code>low_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

Whether a pin is low, by number

True when the value read is 0. Any pin can be read, as with `read_at`; IOError when it cannot be.
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
**it is**, and so does the pull. Returns 0. Making a board button an output raises IOError.
```ruby
sw.setmode(GPIO::IN | GPIO::PULL_DOWN)
```

### GPIO#read

<pre class="fmrb-sig"><code>read() -&gt; <a href="../Integer/">Integer</a></code></pre>

Read the level (0 or 1)

IOError ("GPIO n could not be read") when the level cannot be read.
```ruby
sw.read   #=> 0 or 1
```

### GPIO#write

<pre class="fmrb-sig"><code>write(<a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write the level (0 or 1)

Anything but 0 and 1 is an ArgumentError ("Wrong value. 0 and 1 are only valid"). Returns 0.
Use it on a pin set as an output. On a board button it raises IOError ("... input only").
```ruby
led.write(1)
```

### GPIO#high?

<pre class="fmrb-sig"><code>high?() -&gt; bool</code></pre>

Whether the level is high

true when the value read is not 0. IOError when the level cannot be read.
```ruby
pressed = !sw.high?
```

### GPIO#low?

<pre class="fmrb-sig"><code>low?() -&gt; bool</code></pre>

Whether the level is low

true when the value read is 0. IOError when the level cannot be read.
```ruby
pressed = sw.low?
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
