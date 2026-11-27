# Unit8Encoder

8 encoders, 8 buttons, 9 LEDs

Pass an open `I2C` to
`Unit8Encoder.new`. **A communication failure is the `I2C` IOError as it is** (without the
device the app fails here). `index` is 0..7 for encoders and buttons and 0..8 for LEDs.
**There is no range check**: an index out of range reads or writes another register.
```ruby
require "unit8encoder"
enc = Unit8Encoder.new(i2c)
enc.get_increment(0)
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_ADDR`</span> | [`Integer`](Integer.md) | Default I2C address (0x41) |
| <span class="fmrb-name">`NUM_ENCODERS`</span> | [`Integer`](Integer.md) | Number of encoders |
| <span class="fmrb-name">`NUM_LEDS`</span> | [`Integer`](Integer.md) | Number of LEDs |

## Class methods

### Unit8Encoder.new

<pre class="fmrb-sig"><code>new(<a href="../I2C/">I2C</a> i2c, ?<a href="../Integer/">Integer</a> addr) -&gt; Unit8Encoder</code></pre>

Attach to the device

`i2c` is an open `I2C`, `addr` is 0x41 when left out. **It does not communicate yet** (it does
not fail without the device).
```ruby
enc = Unit8Encoder.new(i2c)
```

## Instance methods

### Unit8Encoder#get_counter

<pre class="fmrb-sig"><code>get_counter(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

Encoder counter

A signed 32-bit integer.
```ruby
enc.get_counter(0)
```

### Unit8Encoder#set_counter

<pre class="fmrb-sig"><code>set_counter(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set an encoder counter

Returns the number of bytes sent.
```ruby
enc.set_counter(0, 100)
```

### Unit8Encoder#get_increment

<pre class="fmrb-sig"><code>get_increment(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

Change since the last read

A signed 32-bit integer. **Reading resets it on the device.** Use this to detect turning.
```ruby
d = enc.get_increment(0)
```

### Unit8Encoder#reset_counter

<pre class="fmrb-sig"><code>reset_counter(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

Reset an encoder counter

Returns the number of bytes sent.
```ruby
enc.reset_counter(0)
```

### Unit8Encoder#get_button

<pre class="fmrb-sig"><code>get_button(<a href="../Integer/">Integer</a> index) -&gt; bool</code></pre>

Whether a button is pressed

```ruby
enc.get_button(3)
```

### Unit8Encoder#get_switch

<pre class="fmrb-sig"><code>get_switch() -&gt; bool</code></pre>

Whether the switch is on

```ruby
enc.get_switch
```

### Unit8Encoder#set_led_color

<pre class="fmrb-sig"><code>set_led_color(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> color) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set one LED colour

`color` is 0xRRGGBB. Returns the number of bytes sent.
```ruby
enc.set_led_color(0, 0xFF0000)
```

### Unit8Encoder#set_all_led_color

<pre class="fmrb-sig"><code>set_all_led_color(<a href="../Integer/">Integer</a> color) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set all LEDs to one colour

`color` is 0xRRGGBB (0 turns them all off). Returns the number of bytes sent.
```ruby
enc.set_all_led_color(0)
```

### Unit8Encoder#firmware_version

<pre class="fmrb-sig"><code>firmware_version() -&gt; <a href="../Integer/">Integer</a></code></pre>

Firmware version of the device

```ruby
enc.firmware_version
```

### Unit8Encoder#get_i2c_address

<pre class="fmrb-sig"><code>get_i2c_address() -&gt; <a href="../Integer/">Integer</a></code></pre>

The I2C address the device holds

```ruby
enc.get_i2c_address
```

### Unit8Encoder#set_i2c_address

<pre class="fmrb-sig"><code>set_i2c_address(<a href="../Integer/">Integer</a> new_addr) -&gt; <a href="../Integer/">Integer</a></code></pre>

Change the device's I2C address

1..127. **It writes to the device, and from then on this object talks to the new address.**
There is no range check. Returns the number of bytes sent.
```ruby
enc.set_i2c_address(0x42)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
