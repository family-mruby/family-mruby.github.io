# MIDI::Device

A sender for sound; send notes and tones to it

How to use it: [MIDI](../midi.md).

## Class methods

### MIDI::Device.new

<pre class="fmrb-sig"><code>new(untyped transport) -&gt; MIDI::Device</code></pre>

Make a device on a transport

transport is whatever receives the MIDI. It needs `send_packet(cable,
cin, b1, b2, b3)`, `read_available`, `bytes_available` and `connected?`
(`device_info` for `info`, `transport_id` for `trigger`). The built-in
and outside devices are made by `FmrbMidi.device` and
`FmrbMidi.sam2695_device`. To use `trigger` on a transport of your own,
`FmrbMidi.register` it, give it `@pending = []`, `note_on(channel, note,
velocity)` and `note_off(channel, note)`, and include
`FmrbMidi::NoteScheduler`.
```ruby
dev = MIDI::Device.new(MyTransport.new)
```

## Instance methods

### MIDI::Device#transport

<pre class="fmrb-sig"><code>transport() -&gt; untyped</code></pre>

The transport behind the device

For the built-in sound it is a `FmrbMidi::ApuTransport`; call
`all_off`, `auto_map` and `map_channel` on it.
```ruby
@device.transport.all_off
```

### MIDI::Device#note_on

<pre class="fmrb-sig"><code>note_on(<a href="../Integer/">Integer</a> note, ?<a href="../Integer/">Integer</a> velocity, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Sound a note

**Velocity and channel are optional** (127 and 0). 60 is middle C. Stop it
with `note_off`.
```ruby
dev.note_on(60)
dev.note_on(64, 100, channel: 1)
```

### MIDI::Device#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> note, ?<a href="../Integer/">Integer</a> velocity, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Stop a note

**Send it on the channel the note started on**, or it will not stop.
```ruby
dev.note_off(60)
dev.note_off(64, 0, channel: 1)
```

### MIDI::Device#pitch_bend

<pre class="fmrb-sig"><code>pitch_bend(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Bend the pitch

-8192 to 8191, with 0 as the written pitch.
```ruby
dev.pitch_bend(2048)
dev.pitch_bend(0)
```

### MIDI::Device#program_change

<pre class="fmrb-sig"><code>program_change(<a href="../Integer/">Integer</a> program, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Choose an instrument

0 to 127; `FmrbMidi.gm_name` turns the number into a name.
```ruby
dev.program_change(48, channel: 1)
```

### MIDI::Device#control_change

<pre class="fmrb-sig"><code>control_change(<a href="../Integer/">Integer</a> cc, <a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Send a controller value

The common controllers have shortcuts of their own (`volume`, `pan`).
```ruby
dev.control_change(74, 64, channel: 0)
```

### MIDI::Device#volume

<pre class="fmrb-sig"><code>volume(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Set the loudness

0 to 127 (CC 7).
```ruby
dev.volume(90, channel: 0)
```

### MIDI::Device#pan

<pre class="fmrb-sig"><code>pan(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Set the left-right position

0 is left, 64 centre, 127 right (CC 10).
```ruby
dev.pan(0)
```

### MIDI::Device#modulation

<pre class="fmrb-sig"><code>modulation(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Set the depth of the vibrato

0 to 127 (CC 1).
```ruby
dev.modulation(40)
```

### MIDI::Device#expression

<pre class="fmrb-sig"><code>expression(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Shape the loudness within a piece

A second level beside `volume` (CC 11); use it for shaping within a piece.
```ruby
dev.expression(100)
```

### MIDI::Device#sustain

<pre class="fmrb-sig"><code>sustain(bool on_off, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Press or release the pedal

**Takes true or false** (CC 64).
```ruby
dev.sustain(true)
dev.sustain(false)
```

### MIDI::Device#trigger

<pre class="fmrb-sig"><code>trigger(
  <a href="../Integer/">Integer</a> note,
  ?<a href="../Integer/">Integer</a> velocity,
  ?duration: <a href="../Integer/">Integer</a>,
  ?channel: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

Sound a note for a set length

**Give it a length and a note-off is booked.** It returns at once, so
several notes can start together -- `note_on` plus a wait cannot.
`duration:` is in ms (100 when left out). `FmrbMidi.tick` is what
sends the stop, so keep calling it from `on_update` (without it the
note rings until the next MIDI message).
```ruby
dev.trigger(60, 100, duration: 200)
```

### MIDI::Device#trigger_batch

<pre class="fmrb-sig"><code>trigger_batch(<a href="../Array/">Array</a> events) -&gt; <a href="../Integer/">Integer</a></code></pre>

Sound several notes at once

Starts a chord within microseconds. Only `:note_on` entries are used, and
`duration_ms` ends them.
```ruby
dev.trigger_batch([
  {type: :note_on, channel: 0,
   note: 60, velocity: 100,
   duration_ms: 200}])
```

### MIDI::Device#all_notes_off

<pre class="fmrb-sig"><code>all_notes_off(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Stop every note that is sounding

**Per channel**: call it once for each channel you used.
```ruby
dev.all_notes_off(channel: 0)
```

### MIDI::Device#all_sound_off

<pre class="fmrb-sig"><code>all_sound_off(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Stop every sound at once

Cuts the tail as well; `all_notes_off` lets it ring out.
```ruby
dev.all_sound_off(channel: 0)
```

### MIDI::Device#reset_all_controllers

<pre class="fmrb-sig"><code>reset_all_controllers(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Put every controller back

```ruby
dev.reset_all_controllers(channel: 0)
```

### MIDI::Device#send_clock

<pre class="fmrb-sig"><code>send_clock() -&gt; void</code></pre>

Send a beat marker

Sent 24 times a quarter note to keep an outside machine in step.
```ruby
dev.send_clock
```

### MIDI::Device#send_start

<pre class="fmrb-sig"><code>send_start() -&gt; void</code></pre>

Send a start marker

```ruby
dev.send_start
```

### MIDI::Device#send_stop

<pre class="fmrb-sig"><code>send_stop() -&gt; void</code></pre>

Send a stop marker

```ruby
dev.send_stop
```

### MIDI::Device#send_continue

<pre class="fmrb-sig"><code>send_continue() -&gt; void</code></pre>

Send a continue marker

```ruby
dev.send_continue
```

### MIDI::Device#send_sysex

<pre class="fmrb-sig"><code>send_sysex(<a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] data, ?wrap: bool) -&gt; void</code></pre>

Send a device's own data

Pass an Array of Integers (not a String), starting with F0 and
ending with F7, or give `wrap: true` (false when left out) to have
them added.
```ruby
dev.send_sysex([0x7E, 0x7F, 0x09, 0x01],
               wrap: true)
```

### MIDI::Device#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

Whether it is connected

```ruby
return unless dev.connected?
```

### MIDI::Device#info

<pre class="fmrb-sig"><code>info() -&gt; <a href="../Hash/">Hash</a></code></pre>

The name of what is connected

```ruby
dev.info[:name]
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
