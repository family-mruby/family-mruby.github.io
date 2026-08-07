# Audio File Formats

This page describes the audio file formats supported by Family mruby, along with how to create and convert them.

| Format | Purpose | API |
|---|---|---|
| FMSQ | Sequence data for short BGM / sound effects. Loaded into a slot for playback | `FmrbAudio#load_fmsq`, `play_slot` |
| NSF | NES music (NES Sound Format) | `FmrbAudio#play(path, track:)` |
| MID | Standard MIDI files. Played through the MIDI layer, on the internal sound chip or an external instrument | `FmrbMidi::SmfPlayer` |

## FMSQ

FMSQ (Family mruby Sequence) is a proprietary format for writing NES APU-compatible music data. It is suited for short sound effects and BGM loops.

See [https://www.nesdev.org/wiki/APU_registers](https://www.nesdev.org/wiki/APU_registers)


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

### Opcode List

`cc` = channel number (00=Pulse1, 01=Pulse2, 10=Triangle, 11=Noise),
`aaaaa` = register offset from `$4000` (0x00-0x17).

| Bit Pattern | Instruction | Following Bytes | Total Size |
|---|---|---|---|
| `0xxxxxxx` | WAIT (1-128 frames) | 0 | 1 |
| `10cc0000` | NOTE_ON | 2-4 per channel | 3-5 |
| `10cc0001` | NOTE_OFF | 0 | 1 |
| `10cc0010` | PARAM | MASK + variable | 2 or more |
| `110aaaaa` | REG_WRITE (`$4000`+aaaaa) | 1 (DATA) | 2 |
| `11100000` | DPCM_PLAY | 3 (RATE_FLAGS, ADDR, LENGTH) | 4 |
| `11100001` | DPCM_STOP | 0 | 1 |
| `11100010` | DPCM_RAW | 1 (VALUE) | 2 |
| `11111110` | END | 0 | 1 |
| `11111111` | LOOP | 2 (OFFSET) | 3 |


APU emulator limitation: DPCM functionality is not currently supported by the APU emulator side.

#### WAIT instruction

```
0xxxxxxx
```

- Upper 1 bit = 0 -> WAIT
- Lower 7 bits = number of frames to wait minus 1

| Value | Meaning |
|---|---|
| 0x00 | Wait 1 frame |
| 0x01 | Wait 2 frames |
| ... | ... |
| 0x7F | Wait 128 frames |

---

#### Channel instructions (NOTE_ON / NOTE_OFF / PARAM)

High-level commands in the form `10ccxxxx`. `cc` selects the channel (Pulse1=0, Pulse2=1, Triangle=2, Noise=3), and the lower 4 bits select the subcommand.
NOTE_ON / NOTE_OFF also update the corresponding bit of `$4015` (Status) internally.

#### NOTE_ON

`10cc0000`. Following bytes depend on the channel:

| Channel | Following Bytes | Write order |
|---|---|---|
| Pulse1 / Pulse2 | `TIMER_LO`, `TIMER_HI`, `VOL_ENV`, `SWEEP` (4 bytes) | `VOL` -> `SWEEP` -> `LO` -> `HI` |
| Triangle | `TIMER_LO`, `TIMER_HI`, `LINEAR` (3 bytes) | `LINEAR` -> `LO` -> `HI` |
| Noise | `PERIOD_MODE`, `VOL_ENV` (2 bytes) | `VOL` -> `LO` |

#### NOTE_OFF

`10cc0001`. No following bytes. Only clears the corresponding channel bit in `$4015` (the APU registers themselves are not modified).

#### PARAM

`10cc0010 [MASK] [DATA...]`

Updates only the sub-parameters specified by the mask. The mask bits and their following data are as follows:

#### Pulse PARAM (Pulse1 / Pulse2)

| mask bit | Following data | Write target |
|---|---|---|
| `0x01` (TIMER) | `LO`, `HI` (2 bytes) | `$4002/3` or `$4006/7` |
| `0x02` (VOL)   | `VOL_ENV` (1 byte) | `$4000` or `$4004` |
| `0x04` (SWEEP) | `SWEEP` (1 byte) | `$4001` or `$4005` |

#### Triangle PARAM

| mask bit | Following data | Write target |
|---|---|---|
| `0x01` (TIMER)  | `LO`, `HI` (2 bytes) | `$400A/B` |
| `0x02` (LINEAR) | `LINEAR` (1 byte) | `$4008` |

#### Noise PARAM

| mask bit | Following data | Write target |
|---|---|---|
| `0x01` (PERIOD) | `PERIOD_MODE` (1 byte) | `$400E` |
| `0x02` (VOL)    | `VOL_ENV` (1 byte) | `$400C` |

Following bytes are read and written in mask bit order. No following byte is present for bits that are not set.

#### REG_WRITE instruction

```
110aaaaa [DATA]
```

Direct write to an APU register. Preserves both the order and the values of APU register operations from NSF.

- `aaaaa`: offset from $4000 (0-23)
- `DATA`: value to write (1 byte)
- Total: 2 bytes per write

| offset (aaaaa) | APU register | Description |
|----------------|-----------|------|
| 0x00 | $4000 | Pulse1 Volume/Envelope/Duty |
| 0x01 | $4001 | Pulse1 Sweep |
| 0x02 | $4002 | Pulse1 Timer Low |
| 0x03 | $4003 | Pulse1 Timer High + Length |
| 0x04 | $4004 | Pulse2 Volume/Envelope/Duty |
| 0x05 | $4005 | Pulse2 Sweep |
| 0x06 | $4006 | Pulse2 Timer Low |
| 0x07 | $4007 | Pulse2 Timer High + Length |
| 0x08 | $4008 | Triangle Linear Counter |
| 0x0A | $400A | Triangle Timer Low |
| 0x0B | $400B | Triangle Timer High + Length |
| 0x0C | $400C | Noise Volume/Envelope |
| 0x0E | $400E | Noise Period + Mode |
| 0x0F | $400F | Noise Length |
| 0x10 | $4010 | DMC Frequency/Flags |
| 0x11 | $4011 | DMC DAC (7bit) |
| 0x12 | $4012 | DMC Sample Address |
| 0x13 | $4013 | DMC Sample Length |
| 0x15 | $4015 | Status (Channel Enable) |

### Reference

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

- To create your own, export as NSF from a DAW like [FamiStudio](https://famistudio.org/)

### Playback

```ruby
@audio.play("/usr/share/sounds/nsf/song.nsf", track: 1)
```

`track:` is the song number (1-based). Since an NSF file can contain multiple songs, you select the file first and then choose a specific song with the track parameter.

### Limitations

- Some NSF files cannot be played

### Sample

A sample NSF player GUI is available at `/app/tool/nsf_player.app.rb` (implements track forward/backward, track selection, and pause/resume).

## MID (Standard MIDI File)

New in 2.0. A `.mid` file is played by the [MIDI](../api/midi.md) layer rather than the audio
slots, which means the same file can drive the internal sound chip or an external instrument
on the GROVE port.

```ruby
player = FmrbMidi::SmfPlayer.new(@device)
player.load("/usr/share/sounds/midi/song.mid")
player.play
```

Seven public-domain songs ship in `/usr/share/sounds/midi`, and the SMF Player app
(`/app/tool/smf_player.app.rb`) plays them with a file list.

### On the internal sound chip

The APU has four voices — two pulses, a triangle and noise — against MIDI's sixteen channels,
so playing a general MIDI file through it is lossy by construction. Dense arrangements lose
notes. An external General MIDI module has no such limit; see [MIDI](../api/midi.md).

### Converting to FMSQ

For music you want as a fixed sequence rather than live playback, `tool/midi/smf2fmsq.rb` in
the repository converts a `.mid` into an [FMSQ](#fmsq) stream:

```
ruby tool/midi/smf2fmsq.rb input.mid -o out.fmsq
```

It emits register writes carrying full APU state, so the result plays identically on both
FMSQ players. The same four-voice reduction applies.

## WAV / MP3

Not supported. Convert to FMSQ, or use MID or NSF.

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
- [MIDI](../api/midi.md) — playing `.mid`, and sending MIDI to an external instrument
- Piano app: `/app/game/piano.app.rb`
- Sound effects + BGM example: `/app/game/flappy.rb`
- NSF player: `/app/tool/nsf_player.app.rb`
