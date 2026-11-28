# FmrbAudio

Play sound: songs, effects, WAV, microphone

How to use it: [Sound](../audio.md).

An app makes one with `@audio = FmrbAudio.new(self)`. A song in NSF is
played with `play` (`stop` ends it; `pause` and `resume` hold it), a WAV
with `play_wav`, single notes with `note_on` and `note_off`, and FMSQ data is
loaded with `load_fmsq` and played with `play_slot`. For
the microphone, check `mic_available?` and read with `mic_enable` and
`mic_read`. To send MIDI notes, use FmrbMidi.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`NSF_IDLE`</span> | [`Integer`](Integer.md) | state 0: no song, or stopped |
| <span class="fmrb-name">`NSF_PLAYING`</span> | [`Integer`](Integer.md) | state 1: playing |
| <span class="fmrb-name">`NSF_FADING`</span> | [`Integer`](Integer.md) | state 2: end found, fading out |
| <span class="fmrb-name">`NSF_ENDED`</span> | [`Integer`](Integer.md) | state 3: over by itself |
| <span class="fmrb-name">`NSF_END_SILENCE`</span> | [`Integer`](Integer.md) | reason 1: ended on silence |
| <span class="fmrb-name">`NSF_END_LOOP`</span> | [`Integer`](Integer.md) | reason 2: ended after the loop was heard |
| <span class="fmrb-name">`NSF_END_LIMIT`</span> | [`Integer`](Integer.md) | reason 3: ended at the time limit |
| <span class="fmrb-name">`MAIN`</span> | [`Integer`](Integer.md) | The APU for long music (0) |
| <span class="fmrb-name">`SUB`</span> | [`Integer`](Integer.md) | The APU for short effects (1) |
| <span class="fmrb-name">`CH_PULSE1`</span> | [`Integer`](Integer.md) | The first pulse channel (0) |
| <span class="fmrb-name">`CH_PULSE2`</span> | [`Integer`](Integer.md) | The second pulse channel (1) |
| <span class="fmrb-name">`CH_TRIANGLE`</span> | [`Integer`](Integer.md) | The triangle channel (2) |
| <span class="fmrb-name">`CH_NOISE`</span> | [`Integer`](Integer.md) | The noise channel (3) |

## Types

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`nsf_status`</span> | `{ state: uint8, reason: uint8, track: uint8, laps: uint8, gen: uint16, period: uint16, frames: uint32 }` | Where the song is, from nsf_status |

## Class methods

### FmrbAudio.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbApp/">FmrbApp</a> app) -&gt; FmrbAudio</code></pre>

Make the sound handler

```ruby
@audio = FmrbAudio.new(self)
```

## Instance methods

### FmrbAudio#play

<pre class="fmrb-sig"><code>play(<a href="../String/">String</a> path, ?track: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Play a song file

Plays an NSF. The tunes live in /usr/share/sounds/nsf. `track:` (0 when
left out) is the song inside the NSF.
```ruby
@audio.play("/usr/share/sounds/nsf/test.nsf")
```

### FmrbAudio#play_raw

<pre class="fmrb-sig"><code>play_raw(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> track) -&gt; void</code></pre>

play with nothing left out

The simple form, with no argument left out. track is the song inside the
NSF, from 0. The wrapper is play (track: left out is 0).
```ruby
@audio.play_raw("/usr/share/sounds/nsf/test.nsf", 0)
```

### FmrbAudio#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

Stop the song

```ruby
@audio.stop
```

### FmrbAudio#nsf_status

<pre class="fmrb-sig"><code>nsf_status() -&gt; nsf_status?</code></pre>

Ask where the song is

An NSF has no length, so the audio side decides when a song is over
(silence, its loop heard twice, or a time limit) and stops it. Ask about
once a second and move on when it is over. nil when there is no answer.
```ruby
st = @audio.nsf_status
next_song if st && st[:state] == FmrbAudio::NSF_ENDED
```

### FmrbAudio#mic_available?

<pre class="fmrb-sig"><code>mic_available?() -&gt; bool</code></pre>

Whether this machine has a microphone

true only on an ESP32-P4 machine (a Tab5 and the like); false elsewhere,
so there is no need to check the machine first.
```ruby
return unless @audio.mic_available?
```

### FmrbAudio#mic_rate

<pre class="fmrb-sig"><code>mic_rate() -&gt; <a href="../Integer/">Integer</a></code></pre>

The microphone's sampling rate in Hz

47160 on an ESP32-P4 (it shares the speaker's clock and cannot be
chosen); 0 on a machine without a microphone. A spectrum's bin width in
Hz is this over the number of samples.
```ruby
hz = @audio.mic_rate
```

### FmrbAudio#mic_enable

<pre class="fmrb-sig"><code>mic_enable(?bool on) -&gt; bool</code></pre>

Turn the microphone on or off

`on` (true when left out). Turn it on before reading and off with
`false` when done. true on success; false on a machine without one or
when it fails to start (no exception). true if it is already so.
```ruby
@audio.mic_enable
@audio.mic_enable(false)
```

### FmrbAudio#mic_read

<pre class="fmrb-sig"><code>mic_read(<a href="../Integer/">Integer</a> count, ?<a href="../Integer/">Integer</a> timeout_ms) -&gt; <a href="../String/">String</a>?</code></pre>

Read microphone samples

Returns `count` (1 to 4096, else ArgumentError) signed 16-bit
little-endian samples as a String of 2 * count bytes. It waits until they
are there (**it blocks**); `timeout_ms` (200 when left out) is the wait of
each hand-over from the driver, about 256 samples at a time. nil when
they did not arrive, and when the microphone is off or absent (never a
short String).
```ruby
bytes = @audio.mic_read(512, 300)
return if bytes.nil?
```

### FmrbAudio#pause

<pre class="fmrb-sig"><code>pause() -&gt; void</code></pre>

Pause the song

```ruby
@audio.pause
```

### FmrbAudio#resume

<pre class="fmrb-sig"><code>resume() -&gt; void</code></pre>

Carry on from the pause

```ruby
@audio.resume
```

### FmrbAudio#load_fmsq

<pre class="fmrb-sig"><code>load_fmsq(<a href="../Integer/">Integer</a> slot_id, bin binary_data) -&gt; void</code></pre>

Put song data into a slot

Loads a tune into a slot. **play_slot is what sounds it.**
```ruby
data = File.open(path, "r") { |f| f.read }
@audio.load_fmsq(0, data)
```

### FmrbAudio#load_fmsq_file

<pre class="fmrb-sig"><code>load_fmsq_file(<a href="../Integer/">Integer</a> slot_id, <a href="../String/">String</a> path) -&gt; void</code></pre>

Read a song file into a slot

```ruby
@audio.load_fmsq_file(0,
  "/usr/share/music/round.mml")
```

### FmrbAudio#play_slot

<pre class="fmrb-sig"><code>play_slot(<a href="../Integer/">Integer</a> slot_id, ?instance: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

Play the song in a slot

`instance:` (MAIN when left out) is the APU that plays it,
`FmrbAudio::MAIN` or `FmrbAudio::SUB`.
```ruby
@audio.play_slot(0)
```

### FmrbAudio#play_slot_raw

<pre class="fmrb-sig"><code>play_slot_raw(<a href="../Integer/">Integer</a> slot_id, <a href="../Integer/">Integer</a> instance) -&gt; void</code></pre>

play_slot with nothing left out

The simple form, with no argument left out. instance is the APU that plays
it, MAIN (0) or SUB (1): a long tune on MAIN and the short effects on SUB,
so an effect never cuts the tune. The wrapper is play_slot (instance: left
out is MAIN).
```ruby
@audio.play_slot_raw(0, FmrbAudio::SUB)
```

### FmrbAudio#main_volume=

<pre class="fmrb-sig"><code>main_volume=(<a href="../Integer/">Integer</a> percent) -&gt; void</code></pre>

Set the volume of the music (MAIN) only

0 to 100 (%), 100 to start with. Only the music of play and of
play_slot on MAIN changes; the effects (SUB), WAVs and the machine's
volume stay. It goes back to 100 when the app closes.
```ruby
@audio.main_volume = 30
```

### FmrbAudio#play_wav

<pre class="fmrb-sig"><code>play_wav(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Play a recorded sound (WAV)

Mono, 8000 to 48000Hz, up to 2MB, 16-bit PCM or 4-bit IMA-ADPCM. It plays over the APU.
Only one at a time: calling again while one sounds replaces it.
Retro cannot play it and gets false back (true when it does play).
```ruby
ok = @audio.play_wav("/home/a.wav")
# false on Retro
```

### FmrbAudio#stop_wav

<pre class="fmrb-sig"><code>stop_wav() -&gt; bool</code></pre>

Stop the WAV that is playing

```ruby
@audio.stop_wav
```

### FmrbAudio#note_on

<pre class="fmrb-sig"><code>note_on(
  <a href="../Integer/">Integer</a> channel,
  <a href="../Integer/">Integer</a> freq,
  ?<a href="../Integer/">Integer</a> volume,
  ?<a href="../Integer/">Integer</a> duty,
  ?<a href="../Integer/">Integer</a> sweep
) -&gt; void</code></pre>

Sound one note

The frequency is in Hz. It sounds over a tune that is already playing.
`volume` (10 when left out) is 0 to 15, `duty` (2) the pulse width 0 to
3, `sweep` (0).
```ruby
@audio.note_on(0, 440)
```

### FmrbAudio#note_on_raw

<pre class="fmrb-sig"><code>note_on_raw(
  <a href="../Integer/">Integer</a> channel,
  <a href="../Integer/">Integer</a> freq,
  <a href="../Integer/">Integer</a> volume,
  <a href="../Integer/">Integer</a> duty,
  <a href="../Integer/">Integer</a> sweep
) -&gt; void</code></pre>

note_on with nothing left out

The simple form, with no argument left out, for where speed matters (many
notes in a tune). volume 0 to 15 (10 in the wrapper), duty the pulse width
0 to 3 (2 in the wrapper), sweep 0 (as the wrapper). The wrapper is note_on.
```ruby
@audio.note_on_raw(0, 440, 10, 2, 0)
```

### FmrbAudio#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> channel) -&gt; void</code></pre>

Stop a note

```ruby
@audio.note_off(0)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
