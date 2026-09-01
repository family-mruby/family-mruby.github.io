# System Services (`services.toml`)

A service is a small job that stays resident: it wakes on a timer, or when something is
published, and it has no window. The clock that sets itself from the network is one; so is
the thing that reads a sentence out loud.

They all run inside a single app, the service host. A dozen small resident jobs therefore
cost one task and one VM instead of a dozen — which is why they exist as services and not as
apps you leave running.

!!! note "Modern only"
    The service host is not carried in the Retro firmware. On Retro nothing here applies,
    and the Retro simulator behaves the same way.

## What ships

| Service | What it does |
|---|---|
| `clock` | Keeps the time of day |
| `hourly_chime` | Rings a note on the hour. Point it at a WAV and it rings that instead |
| `net` | Watches the network and publishes `net/state`. The address goes into the log the moment there is one |
| `timesync` | Sets the clock from an NTP server once the machine is on the network, so Set Clock stops being a chore after every power cut |
| `tts` | Says things out loud. Anything that publishes to `tts/say` is read aloud |

[Studio](../getting_started/studio.md) carries the first two; a browser tab has no clock to
set and no speaker service to call.

## Two lists

| File | Bodies | |
|---|---|---|
| `/etc/services.toml` | `/usr/share/services/` | Ships with the firmware |
| `/home/services.toml` | `/home/services/` | Yours. Read second, and wins field by field |

Winning field by field is what makes the user list small. To switch off a service the
firmware ships, that is the whole file:

```toml
[hourly_chime]
enable = false
```

## Fields

| Field | |
|---|---|
| `file` | The source, under the list's own directory |
| `class` | The class inside it |
| `enable` | `false` keeps the entry but does not run it. Default `true` |
| `interval_ms` | How often `on_tick` is called. Omit it for a service that only reacts to topics |
| `oneshot` | `true` runs `on_start` once at boot, then drops the entry |
| `[<name>.config]` | Handed to the service as `ctx.config` |

## Writing your own

Copy the sample and list it:

```
cp /usr/share/samples/services/services.toml.example /home/services.toml
cp /usr/share/samples/services/heartbeat.rb /home/services/heartbeat.rb
```

The contract is five optional methods:

```ruby
class HeartbeatService
  def on_start(ctx)          # ctx is the only way out to the rest of the machine
  def on_tick(now_ms)        # every interval_ms
  def on_wake(now_ms)        # after ctx.wake_in
  def on_event(topic, data)
  def on_stop
end
```

`ctx` offers `publish`, `wake_in`, `audio`, `log`, `now_ms`, `config` and `stop_self`.

Keep every method short. The services run one after another on one task, so time spent in
one is time the others wait; the host logs a warning past 50 ms. A service that raises is
switched off on its own after three errors, without taking the others with it.

## Starting an app at boot

An entry can name an app instead of a service:

```toml
[my_game]
app = "/app/game/robo_explorer/robo_explorer.app.rb"
fullscreen = true      # overrides the app's own window mode
delay_ms = 2000        # let the desktop settle first
restart = true         # start it again if it crashes (a kill stays killed)
```

## Switching one off

Two ways, and they are not the same:

| | |
|---|---|
| `svc stop <name>` (or `kill <name>`) | This session only. A reboot undoes it |
| `svc disable <name>` | Remembered, so it stays off after a reboot |

`svc start` and `svc enable` are the other halves. What is remembered goes in
`/home/services_state.toml`, which the host writes — your own `services.toml` is never
rewritten. `ps` in the shell lists the services alongside the apps, and so does the Monitor.

## Speech

The `tts` service turns a published sentence into speech. A sentence said once is cached as
a WAV under `/tmp`, which is in PSRAM rather than on the flash — speech is a couple of
hundred kilobytes a go, and the flash is small and wears out. It plays from the cache
afterwards with no network at all, until the next reboot empties it.

Two ways to synthesise:

```toml
[tts.config]
server = "http://192.168.10.5:50021"   # a VOICEVOX server on your PC
speaker = 1
timeout_ms = 3000
```

```toml
[tts.config]
api_key = "sk-..."                     # or synthesise in the cloud, with no PC
cloud_model = "gpt-4o-mini-tts"
cloud_voice = "alloy"
cloud_timeout_ms = 10000
```

The key sits there in plain text. This is a personal machine, and the development build
serves `/home` over HTTP anyway — treat the machine as you would a notebook with your
password taped inside it.

To run with no network, leave the `server` line where it is and simply let it be
unreachable: a miss then costs one refused connection and a log line, and everything already
said still plays. Deleting the line changes the cache key, and the machine stops finding its
own cache.

A phrase that has to sound with no network and after a power cut is not a job for the cache.
Put a WAV in `/home/voice/` and play it.

## Related

- [Inter-App Messaging](../api/pubsub.md) — the topics services publish and listen on
- [Default Apps](../getting_started/default_apps.md) — the Monitor, which lists them
