# FmrbMidi::ApuTransport

Sends MIDI to the built-in sound chip (APU)

How to use it: [MIDI](../midi.md).

Made by `FmrbMidi.device(self)`.

The APU has 4 voices (2 square, a triangle and noise), and one voice
sounds only one note at a time. Channels 0, 1, 2 and 9 map to square 1,
square 2, the triangle and the noise in that order, and
**other channels stay silent** (change this with `map_channel` and `auto_map`). Program
changes, pitch bends and SysEx are received and dropped. The voices use
the APU on the SUB side, so they clash with the SUB sound effects of
`play_slot`.

## Class methods

### FmrbMidi::ApuTransport.new

<pre class="fmrb-sig"><code>new(untyped owner) -&gt; ApuTransport</code></pre>

Make a sender to the built-in sound

owner is the app (`self`) or an `FmrbAudio`. It registers itself with
`FmrbMidi.register`. `FmrbMidi.device(self)` normally makes it.
```ruby
audio = FmrbAudio.new(self)
apu = FmrbMidi::ApuTransport.new(audio)
```

## Instance methods

### FmrbMidi::ApuTransport#note_on

<pre class="fmrb-sig"><code>note_on(<a href="../Integer/">Integer</a> channel, <a href="../Integer/">Integer</a> note, <a href="../Integer/">Integer</a> velocity) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Sound a note on a channel

The direct form that skips `MIDI::Device#note_on`. nil and nothing
happens when the channel has no voice. A second note on the same voice
takes it over, and releasing it falls back to the one still held.
```ruby
apu.note_on(0, 60, 100)
```

### FmrbMidi::ApuTransport#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> channel, <a href="../Integer/">Integer</a> note) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Release a note on a channel

nil when the channel has no voice or the note is not the one sounding.
```ruby
apu.note_off(0, 60)
```

### FmrbMidi::ApuTransport#defer_voices

<pre class="fmrb-sig"><code>defer_voices(?<a href="../Integer/">Integer</a> due_us) -&gt; void</code></pre>

Begin a group of notes of one instant

Call it before sending several messages of **one instant**, such as a
chord, and `flush_voices` after. Meanwhile only the voices' state
changes, and `flush_voices` sends each voice's final state once (so the
inner notes of a chord are not played in turn). `due_us` (now when left
out) is a time on the `FmrbMidi.now_us` clock to send at. A group left
open swallows every later note; `FmrbMidi.tick` closes it each time.
Nothing happens when one is already open.
```ruby
apu.defer_voices
apu.note_on(0, 60, 100)
apu.flush_voices
```

### FmrbMidi::ApuTransport#flush_voices

<pre class="fmrb-sig"><code>flush_voices() -&gt; void</code></pre>

Close the group and send it

Closes what `defer_voices` opened. Nothing happens if none is open.
```ruby
apu.flush_voices
```

### FmrbMidi::ApuTransport#all_off

<pre class="fmrb-sig"><code>all_off() -&gt; void</code></pre>

Stop everything it is sounding

Silences every channel and drops the scheduled note-offs.
```ruby
@device.transport.all_off
```

### FmrbMidi::ApuTransport#auto_map

<pre class="fmrb-sig"><code>auto_map(<a href="../Hash/">Hash</a> usage) -&gt; <a href="../Array/">Array</a></code></pre>

Assign voices from what a song uses

Pass `SmfPlayer#channel_usage`. Channel 9 becomes noise; the three
busiest channels become pulse 1, pulse 2 and triangle, highest average
pitch first. **Every earlier assignment is cleared**; an empty usage
leaves every channel silent. Returns the new assignment.
```ruby
usage = @smf.channel_usage
@device.transport.auto_map(usage)
```

### FmrbMidi::ApuTransport#map_channel

<pre class="fmrb-sig"><code>map_channel(<a href="../Integer/">Integer</a> channel, untyped voice) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Route a channel to a voice

voice is `:pulse1`, `:pulse2`, `:triangle`, `:noise` or 0-3; nil
silences the channel. channel must be an Integer 0-15, else nothing
happens and nil comes back. What was sounding on the channel stops.
```ruby
@device.transport.map_channel(1, :pulse2)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
