# FmrbUart

The app boundary's UART functions

How to use it: [Hardware Control](../peripherals.md).

The layer under the `UART` class. Called by unit number; only the app that opened a
unit may use it (another app's unit is a RuntimeError). A Ruby app normally uses
`UART`; the other languages (C, Lua, MicroPython, wasm) see this shape as it is. The
reading functions never wait. `unit_mask` tells beforehand which units this machine
offers (0 in the browser and the native build).
```ruby
r = FmrbUart.open(2, 47, 48, 115200,
                  8, 1, 0, 4096)
FmrbUart.write(2, "hi\n") if r == 0
```

## Class methods

### FmrbUart.open

<pre class="fmrb-sig"><code>open(
  <a href="../Integer/">Integer</a> unit,
  <a href="../Integer/">Integer</a> txd_pin,
  <a href="../Integer/">Integer</a> rxd_pin,
  <a href="../Integer/">Integer</a> baudrate,
  <a href="../Integer/">Integer</a> data_bits,
  <a href="../Integer/">Integer</a> stop_bits,
  <a href="../Integer/">Integer</a> parity,
  <a href="../Integer/">Integer</a> rx_buffer_size
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Open a UART: 0 when opened, else why not

Every argument is needed (`parity` 0 none, 1 even, 2 odd; `rx_buffer_size` a power of
two from 16 to 16384); one pin may be -1. The answer (its low 8 bits): 1 no such unit,
2 no such pin, 3 both pins -1, 4 TX and RX on one pin, 5 the rate, 6 the format, 7 the
buffer size (so far the caller's mistakes), 8 the system's unit, 9 another app has it,
10 MIDI has it, 11 a system pin, 12 a line a chip drives as TX, 13 a pin in use, 14 it
did not open, 15 none in this environment. An answer about a pin has which one in the
next byte (1 TX, 2 RX; `r >> 8`).
```ruby
r = FmrbUart.open(2, 47, 48, 9600,
                  8, 1, 0, 4096)
```

### FmrbUart.close

<pre class="fmrb-sig"><code>close(<a href="../Integer/">Integer</a> unit) -&gt; bool</code></pre>

Close it and give the pins back (true if closed)

false for a unit this app has not opened.
```ruby
FmrbUart.close(2)
```

### FmrbUart.read

<pre class="fmrb-sig"><code>read(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> max) -&gt; bin</code></pre>

Read up to max received bytes, never waiting

An empty string when nothing has arrived. When a caller's buffer (C and the like) is
smaller than the answer, nothing is taken and the whole length is returned; the next
call with a buffer that long takes those same bytes.
```ruby
s = FmrbUart.read(2, 64)
```

### FmrbUart.read_line

<pre class="fmrb-sig"><code>read_line(<a href="../Integer/">Integer</a> unit) -&gt; bin?</code></pre>

Read one line up to "\n" (nil when none)

Returns it with its `"\n"`; nil, taking nothing, while none has arrived.
```ruby
line = FmrbUart.read_line(2)
```

### FmrbUart.write

<pre class="fmrb-sig"><code>write(<a href="../Integer/">Integer</a> unit, bin data) -&gt; <a href="../Integer/">Integer</a></code></pre>

Send bytes (4096 at most), waiting

Returns the number of bytes. Longer than 4096 bytes is an ArgumentError
(`UART#write` sends in pieces).
```ruby
FmrbUart.write(2, "AT\r\n")
```

### FmrbUart.bytes_available

<pre class="fmrb-sig"><code>bytes_available(<a href="../Integer/">Integer</a> unit) -&gt; <a href="../Integer/">Integer</a></code></pre>

How many received bytes can be read

```ruby
n = FmrbUart.bytes_available(2)
```

### FmrbUart.unget

<pre class="fmrb-sig"><code>unget(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> byte) -&gt; bool</code></pre>

Put one byte back in front (false when full)

```ruby
FmrbUart.unget(2, 0x41)
```

### FmrbUart.flush

<pre class="fmrb-sig"><code>flush(<a href="../Integer/">Integer</a> unit) -&gt; bool</code></pre>

Wait until what was sent has gone out (1 s at most)

true when it has, false when the wait ran out.
```ruby
FmrbUart.flush(2)
```

### FmrbUart.clear_rx

<pre class="fmrb-sig"><code>clear_rx(<a href="../Integer/">Integer</a> unit) -&gt; void</code></pre>

Empty the receive buffer

```ruby
FmrbUart.clear_rx(2)
```

### FmrbUart.clear_tx

<pre class="fmrb-sig"><code>clear_tx(<a href="../Integer/">Integer</a> unit) -&gt; void</code></pre>

Empty the send buffer (does nothing here)

```ruby
FmrbUart.clear_tx(2)
```

### FmrbUart.send_break

<pre class="fmrb-sig"><code>send_break(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> ms) -&gt; void</code></pre>

Send a break for ms milliseconds

0-10000; waits that long. Does nothing on the Linux sim.
```ruby
FmrbUart.send_break(2, 100)
```

### FmrbUart.set_baudrate

<pre class="fmrb-sig"><code>set_baudrate(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> baudrate) -&gt; <a href="../Integer/">Integer</a></code></pre>

Change the baud rate; returns the actual rate

Outside 300-5000000 is an ArgumentError.
```ruby
FmrbUart.set_baudrate(2, 9600)
```

### FmrbUart.set_format

<pre class="fmrb-sig"><code>set_format(
  <a href="../Integer/">Integer</a> unit,
  <a href="../Integer/">Integer</a> data_bits,
  <a href="../Integer/">Integer</a> stop_bits,
  <a href="../Integer/">Integer</a> parity
) -&gt; bool</code></pre>

Change data bits, stop bits and parity

A value out of range is an ArgumentError.
```ruby
FmrbUart.set_format(2, 8, 1, 0)
```

### FmrbUart.dropped

<pre class="fmrb-sig"><code>dropped(<a href="../Integer/">Integer</a> unit) -&gt; <a href="../Integer/">Integer</a></code></pre>

Bytes dropped while the receive buffer was full

```ruby
FmrbUart.dropped(2)
```

### FmrbUart.unit_mask

<pre class="fmrb-sig"><code>unit_mask() -&gt; <a href="../Integer/">Integer</a></code></pre>

The units an app may open, one bit each

Bit n set means `UARTn` can be opened. 0 in the browser and the native build.
```ruby
m = FmrbUart.unit_mask
ok = (m >> 2) & 1 == 1   # UART2
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
