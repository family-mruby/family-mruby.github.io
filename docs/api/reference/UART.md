# UART

Talk to a device over a serial line (UART)

How to use it: [Hardware Control](../peripherals.md).

Written the way upstream PicoRuby's class is. Open with `UART.new`, send with
`puts` and `write`, receive with `gets` and `read`. **Reading never waits**: it
gives nil until something has arrived, so call it in every `on_update`. Only
`write` waits until the bytes are on their way.

The units (`unit:`) and the pins depend on the board (a unit is the number of
`UART0` and so on):

| Board | Units an app may open | Example pins |
|---|---|---|
| Tab5 | 1, 2, 3, 4 | the Grove port, G53 and G54 |
| NARYA v4 (P4-Nano) | 1, 2, 3, 4 | the expansion header |
| AtomS3R, StickS3 | 1, 2 | Grove |
| NARYA v3 | 2 | GROVE 2, 47 and 48 |
| Linux sim | 2 (a stand-in) | 47, 48 and others |

UART0 (the console) and NARYA v3's UART1 (the link to the drawing side) are the
system's: opening one is an IOError. The browser and the native build have no
UART (IOError "not available in this environment"). Pins are guarded by the same
table as GPIO: a system pin, or one another app or I2C holds, is an IOError.
**It cannot be used together with the serial MIDI output**: while a MIDI app sends
to serial, UART2 and its TX pin are MIDI's, free again once that app ends. The
system closes a UART when the app ends.

The Linux sim's UART is a stand-in: what is written comes back to be read (a
loopback). With `uart2_in.fifo` and `uart2_out.fifo` in the project directory, it
reads from the first and writes to the second.
```ruby
# unit and pins are an example
u = UART.new(unit: 1, txd_pin: 53,
  rxd_pin: 54, baudrate: 115200)
u.puts "hello"
line = u.gets   # nil if none yet
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PARITY_NONE`</span> | [`Integer`](Integer.md) | No parity |
| <span class="fmrb-name">`PARITY_EVEN`</span> | [`Integer`](Integer.md) | Even parity |
| <span class="fmrb-name">`PARITY_ODD`</span> | [`Integer`](Integer.md) | Odd parity |
| <span class="fmrb-name">`FLOW_CONTROL_NONE`</span> | [`Integer`](Integer.md) | No flow control (the only one here) |
| <span class="fmrb-name">`FLOW_CONTROL_RTS_CTS`</span> | [`Integer`](Integer.md) | RTS/CTS flow control (not here) |
| <span class="fmrb-name">`WRITE_MAX`</span> | [`Integer`](Integer.md) | The most bytes one FmrbUart.write takes |

## Class methods

### UART.new

<pre class="fmrb-sig"><code>new(
  unit: <a href="../Integer/">Integer</a> | <a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>,
  ?txd_pin: <a href="../Integer/">Integer</a>,
  ?rxd_pin: <a href="../Integer/">Integer</a>,
  ?baudrate: <a href="../Integer/">Integer</a>,
  ?data_bits: <a href="../Integer/">Integer</a>,
  ?stop_bits: <a href="../Integer/">Integer</a>,
  ?parity: <a href="../Integer/">Integer</a>,
  ?flow_control: <a href="../Integer/">Integer</a>,
  ?rts_pin: <a href="../Integer/">Integer</a>,
  ?cts_pin: <a href="../Integer/">Integer</a>,
  ?rx_buffer_size: <a href="../Integer/">Integer</a>?
) -&gt; UART</code></pre>

Open a UART

`unit:` is a number (`2`) or upstream's name (`:ESP32_UART2`). `txd_pin:` and `rxd_pin:`
are GPIO numbers; -1 for one of them (receive only, send only). When left out:
`baudrate: 9600`, `data_bits: 8`, `stop_bits: 1`, `parity: PARITY_NONE`,
`rx_buffer_size: 4096`. `rts_pin:` and `cts_pin:` are not used.

Received bytes go into a receive buffer taken while it is open (`rx_buffer_size`
bytes, a power of two from 16 to 16384, in PSRAM). A byte that arrives while it is
full is dropped and counted by `dropped`.

Wrong arguments are an ArgumentError: an unknown name ("unknown unit"), a unit or pin
this board does not have, both pins -1, TX and RX on one pin, a rate outside
300-5000000, a wrong format, the buffer size, anything but `FLOW_CONTROL_NONE`. When
it cannot be opened it is an IOError with the reason: the system's unit ("UART0 is
used by the system"), another app has it open, MIDI uses it, a system pin, a line a
chip drives (an interrupt line) as TX, a pin in use, none in this environment. The
same app opening the same unit again closes the one it had first (that object is
closed: reading or writing it is an IOError ("closed")).
```ruby
# unit and pins are an example
u = UART.new(unit: 2, txd_pin: 47,
  rxd_pin: 48, baudrate: 115200)
```

## Instance methods

### UART#baudrate

<pre class="fmrb-sig"><code>baudrate() -&gt; <a href="../Integer/">Integer</a></code></pre>

The baud rate

The rate `UART.new` asked for, or the one after `setmode` changed it.
```ruby
u.baudrate   #=> 115200
```

### UART#line_ending=

<pre class="fmrb-sig"><code>line_ending=(<a href="../String/">String</a> line_ending) -&gt; <a href="../String/">String</a></code></pre>

Set the line ending puts adds

One of `"\n"` (the default), `"\r\n"` and `"\r"`; anything else is an ArgumentError.
`gets` still ends a line at `"\n"`.
```ruby
u.line_ending = "\r\n"
```

### UART#puts

<pre class="fmrb-sig"><code>puts(<a href="../String/">String</a> str) -&gt; nil</code></pre>

Send a line, adding the line ending

Adds the line ending (`line_ending`) unless the string ends with it. Returns nil.
```ruby
u.puts "AT"
```

### UART#setmode

<pre class="fmrb-sig"><code>setmode(
  ?baudrate: <a href="../Integer/">Integer</a>?,
  ?data_bits: <a href="../Integer/">Integer</a>?,
  ?stop_bits: <a href="../Integer/">Integer</a>?,
  ?parity: <a href="../Integer/">Integer</a>?,
  ?flow_control: <a href="../Integer/">Integer</a>?,
  ?rts_pin: <a href="../Integer/">Integer</a>?,
  ?cts_pin: <a href="../Integer/">Integer</a>?
) -&gt; UART</code></pre>

Change the rate and the format together

Changes what is given; but the format (`data_bits`, `stop_bits`, `parity`) goes back
to 8, 1 and `PARITY_NONE` when left out (as upstream). Flow control is
`FLOW_CONTROL_NONE` only. A rate outside 300-5000000 is an ArgumentError.
```ruby
u.setmode(baudrate: 9600)
```

### UART#set_flow_control

<pre class="fmrb-sig"><code>set_flow_control(
  <a href="../Integer/">Integer</a> flow_control,
  <a href="../Integer/">Integer</a> rts_pin,
  <a href="../Integer/">Integer</a> cts_pin
) -&gt; nil</code></pre>

Set flow control (none only)

Only `FLOW_CONTROL_NONE` passes; anything else is an ArgumentError.
```ruby
u.set_flow_control(
  UART::FLOW_CONTROL_NONE, -1, -1)
```

### UART#set_format

<pre class="fmrb-sig"><code>set_format(
  <a href="../Integer/">Integer</a>? data_bits,
  <a href="../Integer/">Integer</a>? stop_bits,
  <a href="../Integer/">Integer</a>? parity
) -&gt; UART?</code></pre>

Change data bits, stop bits and parity

`data_bits` 5-8, `stop_bits` 1 or 2, `parity` one of `PARITY_*`. All three nil does
nothing (returns nil); some nil, or a value out of range, is an ArgumentError.
```ruby
u.set_format(8, 1, UART::PARITY_EVEN)
```

### UART#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> len) -&gt; <a href="../String/">String</a>?</code></pre>

Read what has arrived, without waiting

With `len`, exactly `len` bytes, or nil (taking nothing) while fewer have arrived.
Without it, everything that has arrived; nil when nothing has. The string is bytes
(count it with `bytesize`).
```ruby
head = u.read(4)  # 4 bytes or nil
```

### UART#readpartial

<pre class="fmrb-sig"><code>readpartial(<a href="../Integer/">Integer</a> maxlen) -&gt; <a href="../String/">String</a>?</code></pre>

Read what has arrived, up to maxlen bytes

nil when nothing has arrived. Does not wait.
```ruby
s = u.readpartial(256)
```

### UART#getbyte

<pre class="fmrb-sig"><code>getbyte() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Read one byte (nil when none)

```ruby
b = u.getbyte
```

### UART#ungetbyte

<pre class="fmrb-sig"><code>ungetbyte(<a href="../Integer/">Integer</a> byte) -&gt; nil</code></pre>

Put one byte back in front of the received ones

Puts back the low 8 bits; the next `getbyte` or `read` gives it. IOError ("rx buffer is
full") when the buffer is full. Returns nil.
```ruby
u.ungetbyte(0x41)
```

### UART#bytes_available

<pre class="fmrb-sig"><code>bytes_available() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many received bytes can be read

```ruby
n = u.bytes_available
```

### UART#gets

<pre class="fmrb-sig"><code>gets() -&gt; <a href="../String/">String</a>?</code></pre>

Read one line up to "\n", without waiting

The line with its `"\n"` when one has arrived; nil (taking nothing) until then. The
end is `"\n"` whatever `line_ending` is. A line longer than the receive buffer never
comes (the buffer fills and later bytes are dropped).
```ruby
line = u.gets
```

### UART#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

Send bytes, waiting until they are handed over

Returns the number of bytes. A long string is sent 4096 bytes at a time.
```ruby
u.write("AT\r\n")
```

### UART#putc

<pre class="fmrb-sig"><code>putc(<a href="../Integer/">Integer</a> | <a href="../String/">String</a> ch) -&gt; (<a href="../Integer/">Integer</a> | <a href="../String/">String</a>)</code></pre>

Send one character or one byte

An Integer's low 8 bits, or a String's first character (one UTF-8 character).
Returns what was given; another type is a TypeError.
```ruby
u.putc(0x41)   # "A"
```

### UART#flush

<pre class="fmrb-sig"><code>flush() -&gt; UART</code></pre>

Wait until what was written has gone out

Waits one second at most.
```ruby
u.flush
```

### UART#clear_rx_buffer

<pre class="fmrb-sig"><code>clear_rx_buffer() -&gt; UART</code></pre>

Empty the receive buffer

```ruby
u.clear_rx_buffer
```

### UART#clear_tx_buffer

<pre class="fmrb-sig"><code>clear_tx_buffer() -&gt; UART</code></pre>

Empty the send buffer (does nothing here)

Bytes already handed over cannot be taken back (as upstream's ESP32 port).
```ruby
u.clear_tx_buffer
```

### UART#break

<pre class="fmrb-sig"><code>break(?<a href="../Float/">Float</a> | <a href="../Integer/">Integer</a> time) -&gt; UART</code></pre>

Send a break (hold TX low)

`time` is seconds as a Float, ms as an Integer (as upstream); 100 ms when left out.
Waits that long. Over 10 seconds is an ArgumentError, another type a TypeError. Does
nothing on the Linux sim.
```ruby
u.break(0.05)   # 50 ms
```

### UART#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

Bytes dropped while the receive buffer was full

The total since it was opened. If it grows, read more often or give a larger
`rx_buffer_size`.
```ruby
lost = u.dropped
```

### UART#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Close it and give the pins back

Does nothing the second time. Reading or writing after it is an IOError ("closed").
The system closes it when the app ends even without this.
```ruby
u.close
```

### UART#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether it is closed

```ruby
u.closed?   #=> false
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
