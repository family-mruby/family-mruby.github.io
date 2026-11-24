# FmrbMidi::SmfPlayer

曲のファイル (SMF) を鳴らす係。tick を毎回呼んで進める。

How to use it: [MIDI](../midi.md).

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`LOOKAHEAD_US`</span> | [`Integer`](Integer.md) | How far ahead the queue is filled (µs) |

## Class methods

### FmrbMidi::SmfPlayer.new

<pre class="fmrb-sig"><code>new(<a href="../MIDI__Device/">MIDI::Device</a> device) -&gt; SmfPlayer</code></pre>

Make the song player

```ruby
@smf = FmrbMidi::SmfPlayer.new(@midi)
```

## Instance methods

### FmrbMidi::SmfPlayer#load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Read a song file

**false when it cannot be read**, with the reason in `error`.
Whatever was playing stops. SMF format 2 cannot be read.
Loading puts `tempo_scale`, `transpose`, `channel_mask` and
`ignore_program_change` back to their defaults, so set them after.
```ruby
unless @smf.load("/home/a.mid")
  puts @smf.error
end
```

### FmrbMidi::SmfPlayer#load_string

<pre class="fmrb-sig"><code>load_string(<a href="../String/">String</a> data, ?<a href="../String/">String</a> path) -&gt; bool</code></pre>

Read a song from bytes

`load` for bytes already in memory. **false when it cannot be read**,
with the reason in `error`. `path` (nil when left out) is only the name
the `path` method returns; no file is read. Settings go back to their
defaults, as with `load`.
```ruby
@smf.load_string(data, "from net")
```

### FmrbMidi::SmfPlayer#loaded?

<pre class="fmrb-sig"><code>loaded?() -&gt; bool</code></pre>

Whether a song was read

```ruby
return unless @smf.loaded?
```

### FmrbMidi::SmfPlayer#start

<pre class="fmrb-sig"><code>start() -&gt; bool</code></pre>

Start the song

Plays **from the beginning**. To carry on from where you stopped, use
`resume`. **It returns at once**; it does not wait for the end. false
when nothing was loaded. Sound starts once `tick` runs, so keep calling
it from `on_update`.
```ruby
@smf.start
```

### FmrbMidi::SmfPlayer#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

Stop the song

Drops what was queued and stops the notes that are sounding.
```ruby
@smf.stop
```

### FmrbMidi::SmfPlayer#pause

<pre class="fmrb-sig"><code>pause() -&gt; bool</code></pre>

Pause the song

false when it is not playing (stopped or already paused).
```ruby
@smf.pause
```

### FmrbMidi::SmfPlayer#resume

<pre class="fmrb-sig"><code>resume() -&gt; bool</code></pre>

Carry on from the pause

**What was already queued when you paused (up to 0.3 s) is dropped**,
so it carries on that much further on. false when not paused.
```ruby
@smf.resume
```

### FmrbMidi::SmfPlayer#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

Whether it is playing

```ruby
draw_bar if @smf.playing?
```

### FmrbMidi::SmfPlayer#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

Whether it reached the end

**true as well for a song only loaded, or stopped with `stop`**: it
means "not playing". To catch the end, watch `playing?` turn false.
```ruby
@smf.start if @smf.finished?
```

### FmrbMidi::SmfPlayer#tick

<pre class="fmrb-sig"><code>tick() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Move the song on -- call it every time

**Nothing plays unless you call it.** Call it once at a fixed point in
every frame. It returns the wait until the next call, in ms: 0 when
something is due now, nil when not playing or over. After the last
event is read it returns 20 until the queue has played out, then nil.
```ruby
def on_update
  @smf.tick
end
```

### FmrbMidi::SmfPlayer#next_delay

<pre class="fmrb-sig"><code>next_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Move the song on and return how long to wait

Calls `tick` and returns the shorter of its answer and `default_ms`.
Return it from `on_update`. `default_ms` when nothing is playing.
```ruby
def on_update
  @smf.next_delay(300)
end
```

### FmrbMidi::SmfPlayer#position_ms

<pre class="fmrb-sig"><code>position_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

How far it has played, in milliseconds

```ruby
sec = @smf.position_ms / 1000
```

### FmrbMidi::SmfPlayer#channel_usage

<pre class="fmrb-sig"><code>channel_usage() -&gt; <a href="../Hash/">Hash</a></code></pre>

Which channels the song uses

Only the channels the song uses, each as `[note count, pitch total]`.
Empty when nothing is loaded.
```ruby
@smf.channel_usage.each do |ch, a|
  puts ch.to_s + ": " + a[0].to_s
end
```

### FmrbMidi::SmfPlayer#tempo_scale

<pre class="fmrb-sig"><code>tempo_scale() -&gt; <a href="../Float/">Float</a></code></pre>

How fast to play, against what is written

1.0 is the written tempo.
```ruby
s = @smf.tempo_scale
```

### FmrbMidi::SmfPlayer#tempo_scale=

<pre class="fmrb-sig"><code>tempo_scale=(<a href="../Float/">Float</a> value) -&gt; void</code></pre>

Change the playback speed

From 0.001 to 100.0, and it can be changed while the song plays.
```ruby
@smf.tempo_scale = 1.5
```

### FmrbMidi::SmfPlayer#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

Why the read failed

```ruby
msg = @smf.error
```

### FmrbMidi::SmfPlayer#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a>?</code></pre>

Where the song file is

```ruby
name = @smf.path
```

### FmrbMidi::SmfPlayer#device

<pre class="fmrb-sig"><code>device() -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

The device the song goes to

```ruby
dev = @smf.device
```

### FmrbMidi::SmfPlayer#device=

<pre class="fmrb-sig"><code>device=(<a href="../MIDI__Device/">MIDI::Device</a> value) -&gt; void</code></pre>

Switch the device the song goes to

**Works while the song plays.** What sounded on the old device is
stopped and what was queued (up to 0.3 s) is dropped. Use it to move
between the built-in sound and an outside one
(`FmrbMidi.sam2695_device`).
```ruby
@smf.device = @serial
```

### FmrbMidi::SmfPlayer#lookahead_us

<pre class="fmrb-sig"><code>lookahead_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

How far ahead the queue is filled, in µs

300000 (`LOOKAHEAD_US`) by default on the built-in sound and serial
devices; 0 on a device that cannot take a time.
```ruby
n = @smf.lookahead_us
```

### FmrbMidi::SmfPlayer#lookahead_us=

<pre class="fmrb-sig"><code>lookahead_us=(<a href="../Integer/">Integer</a> us) -&gt; void</code></pre>

Change how far ahead the queue is filled

In µs. **0 sends from the app's own task again**, so a late frame
shifts the music (for comparing). Above 0 it stays 0 when the device
cannot take a time (no scheduler). **Changing it drops the queue**, so
do it before playing.
```ruby
@smf.lookahead_us = 0
```

### FmrbMidi::SmfPlayer#transpose

<pre class="fmrb-sig"><code>transpose() -&gt; <a href="../Integer/">Integer</a></code></pre>

Semitones added to every melodic note

0 leaves the notes as written. **Channel 9 (drums) is not moved**, and
a note that would leave 0-127 keeps its pitch. Changing it without
stopping can mis-stop sounding notes (the note-off uses the current
value too). `load` puts it back to 0.
```ruby
@smf.transpose = 2
```

### FmrbMidi::SmfPlayer#transpose=

<pre class="fmrb-sig"><code>transpose=(<a href="../Integer/">Integer</a> semitones) -&gt; void</code></pre>

Change the transposition

See `transpose`.
```ruby
@smf.transpose = -12
```

### FmrbMidi::SmfPlayer#channel_mask

<pre class="fmrb-sig"><code>channel_mask() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Which channels are played

nil plays everything. A number is a bit mask with bit n for channel
n (0-15); everything on a channel whose bit is 0 (notes, controllers,
program changes) is skipped. `load` puts it back to nil.
```ruby
m = @smf.channel_mask
```

### FmrbMidi::SmfPlayer#channel_mask=

<pre class="fmrb-sig"><code>channel_mask=(<a href="../Integer/">Integer</a>? mask) -&gt; void</code></pre>

Choose the channels to play

See `channel_mask`; nil for all.
```ruby
@smf.channel_mask = 0b101
```

### FmrbMidi::SmfPlayer#ignore_program_change

<pre class="fmrb-sig"><code>ignore_program_change() -&gt; bool</code></pre>

Whether the song's own instrument choices are dropped

When true, the Program Change events in the song are not sent, so the
instrument the app chose is not overwritten partway. Matters only for
an outside sound source (the built-in one drops them either way).
`load` puts it back to false.
```ruby
@smf.ignore_program_change = true
```

### FmrbMidi::SmfPlayer#ignore_program_change=

<pre class="fmrb-sig"><code>ignore_program_change=(bool value) -&gt; void</code></pre>

Drop or keep the song's instrument choices

See `ignore_program_change`.
```ruby
@smf.ignore_program_change = false
```

### FmrbMidi::SmfPlayer#track_count

<pre class="fmrb-sig"><code>track_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many tracks the file has

0 before a song is loaded.
```ruby
n = @smf.track_count
```

### FmrbMidi::SmfPlayer#division

<pre class="fmrb-sig"><code>division() -&gt; <a href="../Integer/">Integer</a></code></pre>

Ticks per quarter note

The value in the header. 0 before a song is loaded.
```ruby
d = @smf.division
```

### FmrbMidi::SmfPlayer#format

<pre class="fmrb-sig"><code>format() -&gt; <a href="../Integer/">Integer</a></code></pre>

The SMF format (0 or 1)

0 before a song is loaded. Format 2 cannot be read.
```ruby
f = @smf.format
```

### FmrbMidi::SmfPlayer#late_count

<pre class="fmrb-sig"><code>late_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many events were sent

The events figure of `timing_stats`.
```ruby
n = @smf.late_count
```

### FmrbMidi::SmfPlayer#late_sum_ms

<pre class="fmrb-sig"><code>late_sum_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

Total lateness, in ms

Events sent early count as 0.
```ruby
t = @smf.late_sum_ms
```

### FmrbMidi::SmfPlayer#late_max_ms

<pre class="fmrb-sig"><code>late_max_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

Worst lateness, in ms

```ruby
t = @smf.late_max_ms
```

### FmrbMidi::SmfPlayer#stall_count

<pre class="fmrb-sig"><code>stall_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the schedule was shifted

When the app is 200 ms or more late the schedule is shifted rather than
firing the backlog at once.
```ruby
n = @smf.stall_count
```

### FmrbMidi::SmfPlayer#underrun_count

<pre class="fmrb-sig"><code>underrun_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the music gapped

Counts events more than 5 ms late with nothing left in the queue.
```ruby
n = @smf.underrun_count
```

### FmrbMidi::SmfPlayer#timing_stats

<pre class="fmrb-sig"><code>timing_stats() -&gt; <a href="../String/">String</a></code></pre>

A one-line report on the timing

A string for the log: "no events yet" before anything is sent, then
events, fired, avg_late, max_late, stalls, under, q (queue depth) and
so on when there is a scheduler.
```ruby
Log.info(@smf.timing_stats)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
