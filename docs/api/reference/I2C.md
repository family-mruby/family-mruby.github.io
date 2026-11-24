# I2C

Talk to I2C devices

How to use it: [Hardware Control](../peripherals.md).

`I2C.new` opens the bus, and `write` and `read` send and receive bytes
with a 7-bit address. **The only units are `:ESP32_I2C0` and `:ESP32_I2C1`.** Use
`FmrbHw::PIN_I2C1_SDA` and `PIN_I2C1_SCL` for the pins. **Every failure is an IOError.**
```ruby
i2c = I2C.new(unit: :ESP32_I2C1,
  sda_pin: FmrbHw::PIN_I2C1_SDA,
  scl_pin: FmrbHw::PIN_I2C1_SCL)
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_FREQUENCY`</span> | [`Integer`](Integer.md) | Default frequency (Hz) |
| <span class="fmrb-name">`DEFAULT_TIMEOUT`</span> | [`Integer`](Integer.md) | Default timeout (ms) |

## Class methods

### I2C.new

<pre class="fmrb-sig"><code>new(
  unit: <a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>,
  ?frequency: <a href="../Integer/">Integer</a>,
  ?sda_pin: <a href="../Integer/">Integer</a>,
  ?scl_pin: <a href="../Integer/">Integer</a>,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; I2C</code></pre>

Open an I2C bus

`unit:` is required (`:ESP32_I2C0` or `:ESP32_I2C1`; a string also works). `frequency:`
(100000 Hz when left out), `sda_pin:` and `scl_pin:` (-1 when left out), `timeout:` (500
when left out; the default wait of later `read` and `write`, in ms).

**A bus that cannot be opened raises IOError with one message, "Invalid I2C unit"**: not
only an unknown unit name, but also **a bus another app already holds**, **a different pin**
**for I2C1 on a board with a screen**, and a screen not ready yet. On those boards
(Tab5, NARYA v4, AtomS3R) I2C1 is fixed to the board's wiring, and anything but
`FmrbHw::PIN_I2C1_SDA` and `PIN_I2C1_SCL` is refused.
```ruby
i2c = I2C.new(unit: :ESP32_I2C1,
  sda_pin: FmrbHw::PIN_I2C1_SDA,
  scl_pin: FmrbHw::PIN_I2C1_SCL)
```

## Instance methods

### I2C#write

<pre class="fmrb-sig"><code>write(
  <a href="../Integer/">Integer</a> addr,
  *<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] | <a href="../String/">String</a> data,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write to a device

`addr` is the 7-bit address. Pass **any number of data arguments**: an Integer (one
byte), an Array of Integers, a String (bytes), mixed freely. All of it goes out in one
transaction. A byte is cut to its low 8 bits. `timeout:` is in ms (the `timeout:` of `new`
when left out). Returns the number of bytes sent.

A failure is IOError ("I2C write failed"). A wrong type is a TypeError ("argument must be
Integer, Array or String", also for a non-Integer inside an Array).
```ruby
i2c.write(0x41, 0x20, [1, 2])
```

### I2C#read

<pre class="fmrb-sig"><code>read(
  <a href="../Integer/">Integer</a> addr,
  <a href="../Integer/">Integer</a> len,
  *<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] | <a href="../String/">String</a> write_data,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; <a href="../String/">String</a></code></pre>

Read from a device

Reads `len` bytes from `addr` and returns them as a **String of bytes**. Data after `len`
(a register number, say) is **sent first, and the read follows without a STOP** (passed
as in `write`). `timeout:` is in ms (the `timeout:` of `new` when left out).

A failure is IOError ("I2C read failed"; a failed send before the read is "I2C write (for
read) failed"). **A `len` of 0 also raises "I2C read failed".** One wait is rounded up to at least 10 ms.
```ruby
v = i2c.read(0x41, 1, 0xFE)
v.getbyte(0)
```

### I2C#scan

<pre class="fmrb-sig"><code>scan(?timeout: <a href="../Integer/">Integer</a>) -&gt; nil</code></pre>

Probe the 7-bit addresses for devices

Reads and writes each address from 0x08 to 0x77 and **prints** the ones that answer with
`puts` ("I2C device found at 7-bit address 0x41 ..."). **It returns nil**, not the list.
It is for the shell and for development. `timeout:` is the value of `new` when left out.
```ruby
i2c.scan
```

### I2C#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Release the bus

Gives up the ownership of the unit and its pins (**the bus itself stays**, so the same app
or another one can open it again with `I2C.new`). Returns nil and raises nothing on failure.
```ruby
i2c.close
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
