# FmrbMidi::MmlPlayer

Plays a song written in MML

How to use it: [MIDI](../midi.md).

Call tick on every update to move it along.

## Class methods

### FmrbMidi::MmlPlayer.new

<pre class="fmrb-sig"><code>new(<a href="../MIDI__Device/">MIDI::Device</a> device) -&gt; MmlPlayer</code></pre>

Make the MML player

```ruby
@mml = FmrbMidi::MmlPlayer.new(@midi)
```

## Instance methods

### FmrbMidi::MmlPlayer#load_string

<pre class="fmrb-sig"><code>load_string(<a href="../String/">String</a> mml, ?channel: <a href="../Integer/">Integer</a>, ?velocity: <a href="../Integer/">Integer</a>) -&gt; bool</code></pre>

Read MML text

**Channel and velocity are keyword arguments** (0 and 100 when left
out). Anything loaded before is dropped. false when there is nothing to
play, with the reason in `error`. A tempo such as `t120` in the text is
ignored; use `bpm=`.
```ruby
@mml.load_string("cdefg",
  channel: 0, velocity: 100)
```

### FmrbMidi::MmlPlayer#add_string

<pre class="fmrb-sig"><code>add_string(<a href="../String/">String</a> mml, ?channel: <a href="../Integer/">Integer</a>, ?velocity: <a href="../Integer/">Integer</a>) -&gt; bool</code></pre>

Add another part

Layers another part on top; unlike `load_string` it keeps what is already
there. `channel:` and `velocity:` are 0 and 100 when left out.
```ruby
@mml.add_string("egb", channel: 1)
```

### FmrbMidi::MmlPlayer#load_file

<pre class="fmrb-sig"><code>load_file(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Read a tune file

**false when it cannot be read**, with the reason in `error`. One line
per item; a line starting with `#` is a comment. `bpm 120`, `loop on`,
`velocity 80`, `voice triangle`, `duty 1`, `volume 100` and `program 24`
are settings that apply to the parts below; every other line is an MML
part, on channels 0, 1, ... in order. `voice`, `duty`, `volume` and
`program` are **sent to the device as it loads**, so choose the device
with `device=` first.
```ruby
@mml.device = @midi
@mml.load_file("/home/a.mml")
```

### FmrbMidi::MmlPlayer#load_text

<pre class="fmrb-sig"><code>load_text(<a href="../String/">String</a> text) -&gt; bool</code></pre>

Read tune text in the file format

`load_file` for text already in memory. The format and the failure
(false, with `error`) are the same; no part at all gives "no parts in
the file".
```ruby
@mml.load_text("bpm 90\no4 l4 cdef")
```

### FmrbMidi::MmlPlayer#loaded?

<pre class="fmrb-sig"><code>loaded?() -&gt; bool</code></pre>

Whether anything was read

```ruby
return unless @mml.loaded?
```

### FmrbMidi::MmlPlayer#event_count

<pre class="fmrb-sig"><code>event_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many notes are in it

```ruby
n = @mml.event_count
```

### FmrbMidi::MmlPlayer#total_clocks

<pre class="fmrb-sig"><code>total_clocks() -&gt; <a href="../Integer/">Integer</a></code></pre>

The tune's length in clocks

A quarter note is 24 and a whole note 96. In ms it is
clocks * 2500 / bpm.
```ruby
ms = @mml.total_clocks * 2500 / @mml.bpm
```

### FmrbMidi::MmlPlayer#start

<pre class="fmrb-sig"><code>start() -&gt; bool</code></pre>

Start playing

Plays **from the beginning** and **returns at once**. false when nothing
was loaded. Sound starts once `tick` runs.
```ruby
@mml.start
```

### FmrbMidi::MmlPlayer#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

Stop

Drops what this player queued and stops the notes that are sounding.
Another player of the same app keeps its own queue (pause and
`device=` too).
```ruby
@mml.stop
```

### FmrbMidi::MmlPlayer#pause

<pre class="fmrb-sig"><code>pause() -&gt; bool</code></pre>

Pause

false when it is not playing.
```ruby
@mml.pause
```

### FmrbMidi::MmlPlayer#resume

<pre class="fmrb-sig"><code>resume() -&gt; bool</code></pre>

Carry on

What was already queued when you paused (up to 0.3 s) is dropped. false when not paused.
```ruby
@mml.resume
```

### FmrbMidi::MmlPlayer#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

Whether it is playing

Turns false once the song is read to the end and **what this player queued** has all played.
Another player (of this app or another) still playing does not keep it true.
```ruby
draw_bar if @mml.playing?
```

### FmrbMidi::MmlPlayer#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

Whether it reached the end

**true as well for a tune only loaded, or stopped with `stop`**: it
means "not playing". To catch the end, watch `playing?` turn false.
```ruby
@mml.stop if @mml.finished?
```

### FmrbMidi::MmlPlayer#tick

<pre class="fmrb-sig"><code>tick() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Move the song on -- call it every time

**Nothing plays unless you call it.** It returns the wait until the
next call, in ms; nil when not playing or over.
```ruby
def on_update
  @mml.tick
end
```

### FmrbMidi::MmlPlayer#next_delay

<pre class="fmrb-sig"><code>next_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Move the song on and return how long to wait

Calls `tick` and returns the shorter of its answer and `default_ms`.
Return it from `on_update`.
```ruby
def on_update
  @mml.next_delay(200)
end
```

### FmrbMidi::MmlPlayer#bpm

<pre class="fmrb-sig"><code>bpm() -&gt; <a href="../Integer/">Integer</a></code></pre>

The tempo in beats per minute

```ruby
n = @mml.bpm
```

### FmrbMidi::MmlPlayer#bpm=

<pre class="fmrb-sig"><code>bpm=(<a href="../Integer/">Integer</a> value) -&gt; void</code></pre>

Change the tempo

1 to 1000. Notes already handed to the scheduler keep the old tempo.
```ruby
@mml.bpm = 120
```

### FmrbMidi::MmlPlayer#tempo_scale

<pre class="fmrb-sig"><code>tempo_scale() -&gt; <a href="../Float/">Float</a></code></pre>

How fast to play, against the tempo

1.0 plays at `bpm`. Kept apart from `bpm`.
```ruby
s = @mml.tempo_scale
```

### FmrbMidi::MmlPlayer#tempo_scale=

<pre class="fmrb-sig"><code>tempo_scale=(<a href="../Float/">Float</a> value) -&gt; void</code></pre>

Change the playback speed

From 0.001 to 100.0, and it can be changed while the tune plays.
```ruby
@mml.tempo_scale = 1.5
```

### FmrbMidi::MmlPlayer#loop

<pre class="fmrb-sig"><code>loop() -&gt; bool</code></pre>

Whether it repeats at the end

false to begin with; `loop on` in a file made by `load_file` sets it.
**Loading again does not put it back.**
```ruby
again = @mml.loop
```

### FmrbMidi::MmlPlayer#loop=

<pre class="fmrb-sig"><code>loop=(bool value) -&gt; void</code></pre>

Set whether it repeats at the end

When true it carries on from the top at the end.
```ruby
@mml.loop = true
```

### FmrbMidi::MmlPlayer#device

<pre class="fmrb-sig"><code>device() -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

The device the tune goes to

```ruby
dev = @mml.device
```

### FmrbMidi::MmlPlayer#device=

<pre class="fmrb-sig"><code>device=(<a href="../MIDI__Device/">MIDI::Device</a> value) -&gt; void</code></pre>

Switch the device the tune goes to

Works while it plays. The old device's notes are stopped and what was
queued is dropped.
```ruby
@mml.device = @serial
```

### FmrbMidi::MmlPlayer#sent_count

<pre class="fmrb-sig"><code>sent_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many events were sent

```ruby
n = @mml.sent_count
```

### FmrbMidi::MmlPlayer#stall_count

<pre class="fmrb-sig"><code>stall_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the schedule was shifted

When the app is 200 ms or more late the schedule is shifted.
```ruby
n = @mml.stall_count
```

### FmrbMidi::MmlPlayer#underrun_count

<pre class="fmrb-sig"><code>underrun_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the music gapped

Counts events more than 5 ms late with nothing left in the queue.
```ruby
n = @mml.underrun_count
```

### FmrbMidi::MmlPlayer#timing_stats

<pre class="fmrb-sig"><code>timing_stats() -&gt; <a href="../String/">String</a></code></pre>

A one-line report on the timing

A string for the log; "no events yet" before anything is sent.
```ruby
Log.info(@mml.timing_stats)
```

### FmrbMidi::MmlPlayer#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

Why the read failed

```ruby
msg = @mml.error
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
