# Sound (FmrbAudio)

`FmrbAudio` is the audio playback API. Create an instance by calling `FmrbAudio.new(self)`.

```ruby
class MyApp < FmrbApp
  def on_create
    @audio = FmrbAudio.new(self)
  end
end
```

Internally, it sends `MSG_TYPE_APP_AUDIO` messages to the kernel, which are processed by the audio engine on the graphics side.

!!! note "Supported file formats"
    For details on supported audio file formats, see [Audio File Formats](../file_formats/audio_formats.md).

## Methods

### File Playback

| Method | Purpose |
|---|---|
| `play(path, track: 0)` | Start playing a file |
| `stop` | Stop playback |
| `pause` | Pause playback |
| `resume` | Resume playback |

`path` is a file path (e.g. `/usr/share/sounds/nsf/song.nsf`). `track:` specifies the track number (used for files like NSF that contain multiple tracks).

### Playing a recording (`play_wav`)

```ruby
@audio.play_wav("/home/voice.wav")
```

| Method | Purpose |
|---|---|
| `play_wav(path)` | Play a WAV mixed on top of the sound chip. `true` if it started |
| `stop_wav` | Stop it |

Mono, 8-48 kHz, up to 2 MB, either 16-bit PCM or 4-bit IMA-ADPCM (WAV format `0x11`, about a
quarter of the size; in the development version). An ADPCM file is decoded as it plays, so
it takes no more memory than the file itself. `ffmpeg -i in.wav -ac 1 -c:a adpcm_ima_wav
out.wav` makes one; the voices that ship with the system are stored this way. It rides over whatever the sound chip is playing,
so a spoken line or a recorded chime does not interrupt the music. One clip at a time for
the whole machine: starting another replaces it.

!!! note "Modern only"
    `play_wav` returns `false` on Retro without sending anything, so an app can call it
    unconditionally and fall back on the answer — which is what the hourly chime does: a
    recording if it can, its note if it cannot. Retro's audio lives on the WROVER at the
    far end of a serial link, and shipping a clip across it before a note could sound is
    too slow to be worth it.

### The microphone (Modern only)

| Method | Purpose |
|---|---|
| `mic_available?` | Whether this machine has one |
| `mic_rate` | Samples per second. Fixed by the hardware, so a spectrum's bin width follows from it |
| `mic_enable(on = true)` | Start or stop sampling |
| `mic_read(count, timeout_ms = 200)` | `count` 16-bit samples as a byte String, or `nil` if they did not arrive |

Nothing is recorded and nothing leaves the device; the samples are handed to the app and
that is all. The bundled Mic Spectrum app is the worked example.

### FMSQ Sequences

A mechanism for pre-loading sequences into slots before playback. Suitable for short sound effects and looping BGM.

| Method | Purpose |
|---|---|
| `load_fmsq(slot_id, binary_data)` | Register binary data into a slot. Bounded by the message size, so a real score does not fit |
| `load_fmsq_file(slot_id, path)` | Load a slot from a file already on the audio side (put it there with `@gfx.sync_file` first). This is the route for anything bigger than a jingle |
| `play_slot(slot_id)` | Play a registered slot |

```ruby
data = File.open("/sfx.fmsq", "r") { |f| f.read }
@audio.load_fmsq(0, data)
@audio.play_slot(0)
```

For detailed specifications, see [Audio File Formats](../file_formats/audio_formats.md#fmsq).

### Tone Synthesis (note_on / note_off)

Directly drives NES APU-compatible channels. Allows playing short sound effects and game BGM from scripts.

```ruby
@audio.note_on(channel, freq, volume = 10, duty = 2, sweep = 0)
@audio.note_off(channel)
```

| Argument | Range and Meaning |
|---|---|
| `channel` | Channel number. NES APU configuration: `0` / `1` = pulse wave, `2` = triangle wave, `3` = noise |
| `freq` | Frequency (Hz). Integer. May have a different meaning on the noise channel |
| `volume` | Volume. Approximately `0` to `15`. Default `10` |
| `duty` | Pulse wave duty cycle. `0` to `3` |
| `sweep` | Frequency sweep value (packed APU register value) |

#### Example: Piano-style

```ruby
class MiniPiano < FmrbApp
  KEYS = {
    "a" => 261, "s" => 293, "d" => 329, "f" => 349,
    "g" => 392, "h" => 440, "j" => 493, "k" => 523
  }

  def on_create
    @audio = FmrbAudio.new(self)
    @ch = 0
  end

  def on_event(ev)
    return unless ev[:character]
    if ev[:type] == :key_down && (freq = KEYS[ev[:character]])
      @audio.note_on(@ch, freq, 10, 2, 0)
    elsif ev[:type] == :key_up
      @audio.note_off(@ch)
    end
  end
end
```

## Track Numbers and Playback Control

| Use Case | Recommended Track |
|---|---|
| BGM | `0` |
| SE (Sound Effects) | `1` and above |

Calling `play(path, track:)` with different track numbers simultaneously enables parallel playback on separate tracks (implementation dependent).

### The music's own volume

```ruby
@audio.main_volume = 30   # percent, 100 to start with
```

Only the music changes — what `play` and `play_slot` play on the MAIN sound chip. Sound
effects (SUB), WAVs and the machine's volume stay where they are, and it goes back to 100
when the app closes. The mahjong table uses it for a BGM that sits under the effects.

## NSF File Playback

NES Sound Format is supported.

```ruby
@audio.play("/usr/share/sounds/nsf/song.nsf", track: 1)
```

A playback GUI sample is available in `tool/nsf_player.app.rb`. For details, see [Audio File Formats](../file_formats/audio_formats.md#nsf-nes-sound-format).

### When a song is over (`nsf_status`)

An NSF has no length, so the audio side decides when a song is over — silence, its loop
heard twice, or a time limit — and stops it. Ask about once a second and move on when it is
over (development branch, after 3.0.0):

```ruby
st = @audio.nsf_status            # nil when there is no answer
next_song if st && st[:state] == FmrbAudio::NSF_ENDED
```

`st[:state]` is `NSF_IDLE`, `NSF_PLAYING`, `NSF_FADING` or `NSF_ENDED`; `st[:reason]` says why
it ended: `NSF_END_SILENCE`, `NSF_END_LOOP` or `NSF_END_LIMIT`.

## Cleanup

To stop any playing audio when the app exits, it is safe to call `stop` in `on_destroy`.

```ruby
def on_destroy
  @audio.stop if @audio
end
```

## Related

- [Audio File Formats](../file_formats/audio_formats.md) -- FMSQ / NSF specifications and how to create them
- [MIDI](midi.md) -- driving this same sound chip through a MIDI device, or sending MIDI to an external instrument
- [Default Apps](../getting_started/default_apps.md) -- `piano`, `flappy`, `nsf_player`, and more

<!-- BEGIN class reference links (generated by fmruby-core tools/ti/gen_site.rb; do not edit) -->
**Class reference:** [`FmrbAudio`](reference/FmrbAudio.md), [`FmrbMic`](reference/FmrbMic.md), [`NsfHeader`](reference/NsfHeader.md)
<!-- END class reference links -->
