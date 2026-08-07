# HID Device Config (`/etc/hid_devices.toml`)

**Whether a given USB device works is not a given.** The USB host stack here is limited, and
so are a lot of the devices: some are not enumerated at all, some enumerate and then report
in a format the generic path reads wrongly. [Verified Peripherals](../compatibility.md)
lists what has actually been tested.

`/etc/hid_devices.toml` is the tool for the second case. A USB HID device is supposed to
describe its own report format, but plenty of them describe it badly, or pack their axes in a
way the generic path does not expect. This file lets you spell out, per device, exactly which
bits of the report mean what.

It helps when a device **is** recognised but behaves wrongly — the cursor jumps, moves on the
wrong axis, or does not move at all while the buttons work. It cannot help a device that
never enumerates; that is a driver problem, not a layout one.

## How a device gets its layout

The system tries these in order:

1. **This file.** If a `[[mouse]]` or `[[gamepad]]` block matches the device's vendor and
   product ID, that layout wins outright
2. **Boot protocol.** With no match, a boot-capable mouse is asked to send standard 3-byte
   boot reports
3. **Auto-detection.** If the reports that arrive do not look like boot reports — longer than
   3 bytes and starting with the mouse report ID — the system switches itself to a Report
   Protocol layout with 12-bit packed axes, which covers a common family of cheap mice

So a device only needs an entry here when all three fail.

## Writing an entry without a PC

The **HID Inspector** app does this interactively on the device itself. It is built into the
firmware rather than installed under `/app`, so it is **not in the launcher** — press `I` on
the desktop to start it:

1. **LIST** — pick the misbehaving device from the connected list
2. **INSPECT** — watch the raw report bytes as you move and click
3. **WIZARD** — it walks you through moving one axis at a time and works out where each field
   sits
4. **RESULT** — it shows the `[[mouse]]` block it generated; press `S` to append it to
   `/etc/hid_devices.toml`

No serial cable, no PC. This is the intended way to produce an entry; the format below is
for reading and hand-editing what it writes.

## `[[mouse]]`

```toml
[[mouse]]
vid = 0x046D
pid = 0xC534
name = "Logitech Unifying"
report_id = 0x02
report_len = 7
buttons = { offset = 0,  size = 8,  min = 0,     max = 1,    relative = false }
x       = { offset = 16, size = 12, min = -2048, max = 2047, relative = true }
y       = { offset = 28, size = 12, min = -2048, max = 2047, relative = true }
```

| Key | Meaning |
|---|---|
| `vid` / `pid` | USB vendor and product ID, as hex |
| `name` | Free text, used in the log so you can tell entries apart |
| `report_id` | The report ID byte. Omit it, or set `-1`, when the device sends none |
| `report_len` | Report length in bytes, **not** counting the report ID |
| `skip_control_transfer` | `true` to skip USB control transfers for this device. A few devices stall on them |
| `buttons` | Where the button bits are |
| `x` / `y` | Where the axes are |

Field tables take:

| Key | Meaning |
|---|---|
| `offset` | Bit offset from the start of the report data (after the report ID, if any) |
| `size` | Field width in bits |
| `min` / `max` | Value range. Negative `min` means the field is signed |
| `relative` | `true` for a mouse reporting movement, `false` for a touchpad or tablet reporting a position |

**Offsets are in bits, not bytes.** A 12-bit axis starting halfway through byte 2 is
`offset = 20`, and that is exactly the case the generic path gets wrong.

## `[[gamepad]]`

```toml
[[gamepad]]
vid = 0x0F0D
pid = 0x0009
name = "HORI PAD 3 TURBO"
report_len = 19
buttons = { offset = 0,  size = 16 }
hat     = { offset = 16, size = 4 }
left_x  = { offset = 24, size = 8, center = 128 }
left_y  = { offset = 32, size = 8, center = 128 }
right_x = { offset = 40, size = 8, center = 128 }
right_y = { offset = 48, size = 8, center = 128 }
```

| Key | Meaning |
|---|---|
| `vid` / `pid` / `name` | As above |
| `report_len` | Report length in bytes |
| `buttons` | Bitmask field: `offset`, `size`. Bit *n* becomes button *n* |
| `hat` | D-pad / hat switch: `offset`, `size`. Optional |
| `left_x`, `left_y`, `right_x`, `right_y`, `l2`, `r2` | Axes: `offset`, `size`, `center` |

`center` is the resting value of the axis — `128` for a stick that reports 0-255 — so the
system knows which way is "pushed".

Button numbers reach your app as `ev[:button]` in a `:gamepad_down` / `:gamepad_up` event, and
the `GP_*` constants name them. See
[Constants & System Info](../api/const.md#input-device-gamepad-gp_).

## Notes

- Blocks are matched by `vid` and `pid` only. A device that reports a different pid in a
  different mode needs an entry per mode
- The shipped file contains working entries for a Logitech Unifying receiver, a Logickeyboard
  TITAN touchpad, a Sipeed NanoKVM-USB and a HORI PAD 3 TURBO. They are worth reading as
  examples even if you own none of them
- Flashing firmware replaces this file along with the rest of `/etc`, so keep a copy of
  entries you worked out

## Related

- [Verified Peripherals](../compatibility.md) — what has been tested, and what failed
- [System Configuration](system_conf.md) — `system_conf.toml` and `wifi.toml`
- [Constants & System Info](../api/const.md) — the `GP_*` and `KEY_*` constants
- [Default Apps](../getting_started/default_apps.md) — the HID Inspector
