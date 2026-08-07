# MIDI (MIDI::Device / FmrbMidi)

New in 2.0. Family mruby plays the part of the instrument's controller: it sends MIDI,
and something makes the sound. That something can be the machine's own APU sound chip, or an
external synth on the GROVE port — and because both sit behind the same `MIDI::Device`, the
same app code drives either one.

Works on both machines.

```ruby
device = FmrbMidi.device(self)     # the built-in APU
device.note_on(1, 60, 100)         # channel, note number, velocity
device.note_off(1, 60)
```

The layer is imported from the [Midori](https://github.com/picoruby) MIDI gems, so the
`MIDI::Device` API is the one those gems define.

## Two places the sound can come out

### The built-in APU

```ruby
def on_create
  @device = FmrbMidi.device(self)
end

def on_update
  FmrbMidi.tick        # runs scheduled note-offs; call this every update
end
```

Notes are mapped onto the NES-style APU's channels. It is 4 voices — two square waves, a
triangle and a noise channel — so a chord uses them up quickly, and the mapping decides
which MIDI channel lands on which voice.

### An external instrument, over the GROVE port

```ruby
device = FmrbMidi.serial_device(tx: 53)      # plain serial MIDI out
device = FmrbMidi.sam2695_device(tx: 53)     # M5Stack Unit MIDI, reset and ready
```

Both return `nil` if the port will not open — the pins may already be taken by an I2C user —
so check before you use it:

```ruby
@device = FmrbMidi.sam2695_device(tx: 53)
if @device.nil?
  Log.warn("no MIDI port")
  @device = FmrbMidi.device(self)   # fall back to the APU
end
```

Serial MIDI runs at 31250 baud, the MIDI standard rate. The pin depends on the board:

| Machine | GROVE pin for MIDI TX |
|---|---|
| Modern (Tab5) | GPIO 53 |
| Retro (narya-board) | GPIO 47 (GROVE 2) |

```ruby
tx = FmrbConst::BOARD == "tab5" ? 53 : 47
```

The reference external instrument is the M5Stack Unit MIDI (SAM2695), a General MIDI
module that needs only a GROVE cable — GROVE port 2 can supply its 5 V.

## Playing a standard MIDI file

```ruby
player = FmrbMidi::SmfPlayer.new(@device)
player.load("/usr/share/sounds/midi/song.mid")
player.play

def on_update
  player.tick
  FmrbMidi.tick
end
```

`player.playing?` tells you when it is done, and `player.stop` cuts it short (silencing any
note left sounding).

Bundled songs live in `/usr/share/sounds/midi`. The SMF Player app
(`/app/tool/smf_player.app.rb`) is a full file-picking player you can read or just use.

## MML

For a tune written in text rather than a file:

```ruby
@device = FmrbMidi.device(self)
@player = FmrbMidi::MmlPlayer.new(@device)
@player.bpm = 120
@player.load_string("o4 l8 crdrerfrgrarbr>cr")
@player.play
```

Several parts play together by loading more than one string — they merge into one tune, so
two voices can land on the same instant.

The timing does not come from your update loop. The player hands the C layer commands
stamped with the microsecond they are due, and a timer sends them at that microsecond
without entering the VM, so the beat holds steady even when the app is busy.

The MML demo (`/app/demo/mml.app.rb`) plays the same tune on the APU or on an external
instrument, switchable at runtime.

!!! note "This MML is not BASIC's MML"
    FMRuby BASIC has its own `PLAY` statement with Family BASIC-compatible syntax. It is a
    separate implementation and the two dialects are not the same. See [BASIC and
    MicroPython](../other_languages.md).

## Watching what goes out

For development, `tools/fmrb_midi_monitor.rb` in the repository prints every byte the serial
port emits, with arrival times:

```
note on ch1 C4 vel=100 [90 3C 64]
```

Because it timestamps arrivals, it measures tempo and note spacing more precisely than
listening does. It can also drive a software synth on your PC so you can hear the output
without any hardware.

## Costs

Sending a note allocates nothing on the serial path, which is what lets a song play without
the garbage collector interrupting it. Keep it that way in your own code: build the strings
and arrays you need once, at load time, not inside the note loop.

## Related

- [FmrbAudio](audio.md) — the APU directly, without MIDI in the way
- [Audio File Formats](../file_formats/audio_formats.md) — FMSQ, the internal music format
- [Hardware](../hardware.md) — the GROVE pins on each machine
- [Default Apps](../getting_started/default_apps.md) — SMF Player, MIDI APU, MML
