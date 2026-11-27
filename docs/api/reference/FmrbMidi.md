# FmrbMidi

MIDI entry point: devices, songs, MML

How to use it: [MIDI](../midi.md).

`FmrbMidi.device(self)` gives a device (MIDI::Device) wired to the built-in
sound chip (the APU); send notes to it with `note_on` and the like. A
standard MIDI file is played by `FmrbMidi::SmfPlayer`, MML by
`FmrbMidi::MmlPlayer`. For an outside instrument, `sam2695_device` and
`serial_device` make the device and `register` adds a transport. Measure a
song's time with `now_us`.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`GM_DRUM_CHANNEL`</span> | [`Integer`](Integer.md) | The channel General MIDI keeps for drums |

## Class methods

### FmrbMidi.device

<pre class="fmrb-sig"><code>device(<a href="../FmrbApp/">FmrbApp</a> app) -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

Make this app's way of sounding notes

Gives you a device wired to the built-in sound chip. To play an outside
instrument, `register` that transport as well.
```ruby
@midi = FmrbMidi.device(self)
@midi.note_on(60)
```

### FmrbMidi.now_us

<pre class="fmrb-sig"><code>now_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

The time now, in microseconds

The clock to schedule notes against. Measure a song with this, never by
counting frames -- a heavy frame stretches the music.
```ruby
t0 = FmrbMidi.now_us
```

### FmrbMidi.register

<pre class="fmrb-sig"><code>register(untyped transport) -&gt; untyped</code></pre>

Register somewhere to send notes

Registering the same transport twice adds it once.
```ruby
FmrbMidi.register(transport)
```

### FmrbMidi.unregister

<pre class="fmrb-sig"><code>unregister(untyped transport) -&gt; void</code></pre>

Stop sending notes there

```ruby
FmrbMidi.unregister(transport)
```

### FmrbMidi.transports

<pre class="fmrb-sig"><code>transports() -&gt; <a href="../Array/">Array</a></code></pre>

Everywhere notes are being sent

```ruby
FmrbMidi.transports.length
```

### FmrbMidi.gm_name

<pre class="fmrb-sig"><code>gm_name(<a href="../Integer/">Integer</a> program) -&gt; <a href="../String/">String</a>?</code></pre>

The instrument's name from its number

0 to 127; anything else is nil. The names are shortened to 16
characters (program 0 is "Ac Grand Piano").
```ruby
FmrbMidi.gm_name(0)
#=> "Ac Grand Piano"
```

### FmrbMidi.sam2695_device

<pre class="fmrb-sig"><code>sam2695_device(
  ?path: <a href="../String/">String</a>,
  ?uart: <a href="../Integer/">Integer</a>,
  ?tx: <a href="../Integer/">Integer</a>,
  ?rx: <a href="../Integer/">Integer</a>,
  ?baud: <a href="../Integer/">Integer</a>
) -&gt; <a href="../MIDI__Device/">MIDI::Device</a>?</code></pre>

Make a device for an outside SAM2695 unit

M5Stack Unit MIDI and the like; MIDI goes out over a serial port (31250
baud). **nil when it will not connect** (in the sim when the FIFO that
receives it is missing; on a device when the board has no MIDI output or
the pins are taken). Using the nil raises NoMethodError, so always check.
Each call sends GM System On and silences every channel, so make it
once and keep it. It is not the built-in sound (`FmrbMidi.device`);
switch with `SmfPlayer#device=`.
`path:` (sim only), `uart:` and `tx:` (device only), `rx:` (-1 when left
out: send only), `baud:` (31250 when left out). What is left out is the
board's default.
```ruby
@serial = FmrbMidi.sam2695_device
@serial.program_change(0) if @serial
```

### FmrbMidi.serial_device

<pre class="fmrb-sig"><code>serial_device(
  ?path: <a href="../String/">String</a>,
  ?uart: <a href="../Integer/">Integer</a>,
  ?tx: <a href="../Integer/">Integer</a>,
  ?rx: <a href="../Integer/">Integer</a>,
  ?baud: <a href="../Integer/">Integer</a>
) -&gt; <a href="../MIDI__Device/">MIDI::Device</a>?</code></pre>

Make a device on a plain serial MIDI port

The same as `sam2695_device` without the reset sent to the unit.
**nil when it will not connect.** The same keywords (`path:` `uart:`
`tx:` `rx:` `baud:`; the board's default when left out).
```ruby
@out = FmrbMidi.serial_device
@out.note_on(60) if @out
```

### FmrbMidi.scheduler

<pre class="fmrb-sig"><code>scheduler() -&gt; untyped</code></pre>

The scheduler that sends timed notes, or nil

A song's notes are stamped with a time and handed to a C queue, and a
timer sends them at that time. This is that queue. An app only asks
whether it exists; the methods starting with `_` are not for apps.
**nil when there is none** (the host tests).
```ruby
puts FmrbMidi.scheduler ? "yes" : "no"
```

### FmrbMidi.tick

<pre class="fmrb-sig"><code>tick() -&gt; void</code></pre>

Send the note-offs that have come due

This is what ends the notes of `MIDI::Device#trigger`. Call it once in
every `on_update`. Without it a triggered note stays on until the next
MIDI message. Every device made, built-in or serial, is looked at here.
```ruby
def on_update
  FmrbMidi.tick
  FmrbMidi.tick_delay(100)
end
```

### FmrbMidi.tick_delay

<pre class="fmrb-sig"><code>tick_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

How long the app may sleep, in ms

Returns the shorter of the wait you pass and the time to the next
scheduled note-off, in ms and never below 0. Return it from `on_update`
so a short note does not ring on until the next update.
```ruby
def on_update
  FmrbMidi.tick
  FmrbMidi.tick_delay(200)
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
