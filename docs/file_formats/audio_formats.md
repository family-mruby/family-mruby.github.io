# Audio File Formats

!!! note
    This page is under construction.


This page describes the audio file formats supported by Family mruby, along with how to create and convert them.

| Format | Purpose | API |
|---|---|---|
| FMSQ | Sequence data for short BGM / sound effects. Loaded into a slot for playback | `FmrbAudio#load_fmsq`, `play_slot` |
| NSF | NES music (NES Sound Format) | `FmrbAudio#play(path, track:)` |

## FMSQ

FMSQ (Family mruby Sequence) is a proprietary format for writing NES APU-compatible music data. It is suited for short sound effects and BGM loops.

### File Structure

12-byte header + variable-length command stream. All values are little-endian.

```
+------+----------------+
| 0..3 | "FMSQ"         |  magic
| 4    | version (=1)   |
| 5    | flags (=0)     |  reserved
| 6..7 | frame_count    |  total frames
| 8..9 | data_size      |  command bytes
| 10..11 | loop_offset  |  0 = no loop
+------+----------------+
| 12.. | command stream |
+------+----------------+
```

### Command Encoding

| Command | Format | Meaning |
|---|---|---|
| WAIT | `0xxxxxxx` | Wait 1 to 128 frames (`(N & 0x7F) + 1`) |
| NOTE_ON  | `10cc0000` | Start note on channel `cc` |
| NOTE_OFF | `10cc0001` | Stop note on channel `cc` |
| PARAM | `10cc0010` | Update channel parameters (followed by mask and data) |
| REG_WRITE | `110aaaaa DATA` | Direct write to APU register `$4000 + a` |
| DPCM_PLAY | `0xE0 RATE_FLAGS ADDR LENGTH` | Play DPCM |
| DPCM_STOP | `0xE1` | Stop DPCM |
| DPCM_RAW  | `0xE2 VALUE` | Direct 7-bit DAC write |
| END  | `0xFE` | End of data |
| LOOP | `0xFF OFFSET_LO OFFSET_HI` | Loop to specified offset |

### Channel IDs

| ID | Channel |
|---|---|
| 0 | Pulse 1 (square wave) |
| 1 | Pulse 2 (square wave) |
| 2 | Triangle (triangle wave) |
| 3 | Noise |

### Creating FMSQ Files

Ruby generators are available under `fmruby-graphics-audio/tools/` (run on PC).

```
fmruby-graphics-audio/tools/gen_test_fmsq.rb     # Scale pattern
fmruby-graphics-audio/tools/gen_intro_fmsq.rb    # Jingle
```

Use these as a reference to write scales and chords, and generate `.fmsq` binary files.

### Playback

Load the data into a slot (by numeric ID), then play it.

```ruby
data = File.open("/sfx.fmsq", "r") { |f| f.read }
@audio.load_fmsq(0, data)   # Register in slot 0
@audio.play_slot(0)         # Play
```

See [FmrbAudio](../api/audio.md) for details.

## NSF (NES Sound Format)

NES Sound Format is a standard format for playing actual NES music. Family mruby supports playback of NSF files.

### Obtaining NSF Files

- Download from archive sites (such as NSFArchive)
- To create your own, export as NSF from a DAW like FamiTracker

### Playback

```ruby
@audio.play("/usr/share/music/dq.nsf", track: 1)
```

`track:` is the song number (1-based). Since an NSF file can contain multiple songs, you select the file first and then choose a specific song with the track parameter.

### Limitations

- Large NSF files that heavily use bank switching may take longer to load
- Some NSFe extension features are not supported

### Sample

A sample NSF player GUI is available at `flash/app/tool/nsf_player.app.rb` (implements track forward/backward, track selection, and pause/resume).

## WAV / MP3

Not supported. Please convert to FMSQ or NSF.

## Direct Synthesis (`note_on` / `note_off`)

You can drive the APU directly using `FmrbAudio#note_on` without any files. This is useful for rhythm, dialogue sound effects, button click sounds, and similar.

```ruby
@audio.note_on(0, 440, 10, 2, 0)   # A4 on Pulse 1 channel
sleep_ms(200)
@audio.note_off(0)
```

See [FmrbAudio - note_on / note_off](../api/audio.md#direct-synthesis-note_on--note_off) for details.

## Related

- [FmrbAudio](../api/audio.md)
- Piano app: `flash/app/game/piano.app.rb`
- Sound effects + BGM example: `flash/app/game/flappy.rb`
- NSF player: `flash/app/tool/nsf_player.app.rb`
