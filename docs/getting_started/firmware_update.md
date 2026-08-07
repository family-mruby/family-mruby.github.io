# Firmware Update

Firmware is written from your browser. Nothing to install.

Installer: [https://family-mruby.github.io/family-mruby-installer/](https://family-mruby.github.io/family-mruby-installer/)

## Requirements

| Item | What works |
|---|---|
| Browser | Chrome, Edge or Opera (desktop). Firefox and Safari have no Web Serial and cannot flash |
| USB cable | Must carry data. Charge-only cables never appear in the port dialog |

## How many chips you are flashing

This differs between the two machines, and it is the thing people get wrong.

| Machine | Chips to flash | Buttons in the installer |
|---|---|---|
| **Modern** (M5Stack Tab5) | One — the ESP32-P4 | `Connect & Flash Tab5 firmware` |
| **Retro** (narya-board) | Two — the ESP32-S3 and the ESP32-WROVER, separately | `Connect & Flash fmruby-core`, `Connect & Flash fmruby-graphics-audio` |

The installer checks the chip family before writing (ESP32-P4 / ESP32-S3 / ESP32), so
pressing the wrong button gives you an error, not a broken device.

!!! warning "Flashing replaces the files on the device"
    The image includes the flash filesystem. Your own apps and any config files you edited
    on the device are replaced by the shipped contents. Copy anything you want to keep off
    the device first — see [Console](console.md).

## Modern (M5Stack Tab5)

1. Open the [installer](https://family-mruby.github.io/family-mruby-installer/)
2. Connect the Tab5 to your PC with a USB-C data cable
3. Go to the **Family mruby Modern (Tab5)** section
4. Choose a version (newest is preselected)
5. Press **Connect & Flash Tab5 firmware** and pick the port
6. Wait for it to finish, then let the device restart

The Tab5 connects over USB-Serial-JTAG, so **no button has to be held** to enter download
mode. If the device sits in download mode after flashing — the serial log shows
`waiting for download` — press reset once.

## Retro (narya-board)

The board has two MCUs and they are flashed independently, through **different USB-C ports**
on the board:

- The **ESP32-S3 side** port flashes `fmruby-core`
- The **ESP32-WROVER side** port flashes `fmruby-graphics-audio`

1. Open the [installer](https://family-mruby.github.io/family-mruby-installer/)
2. Connect a USB-C data cable to the port for the chip you are flashing
3. Go to the **Family mruby Retro** section and choose a version
4. Press the matching button, then pick the port in the browser dialog
5. Repeat for the other chip, from the other port

!!! note "Keep the two versions the same"
    Flash both chips with the same version. A new `fmruby-core` against an old
    `fmruby-graphics-audio` will not boot correctly — the link protocol between them has to
    match.

## Troubleshooting

### The browser does not show a serial port

- The cable must carry data. Charge-only USB-C cables are never offered
- Use a USB-certified cable, as short as is practical
- Connect straight to the PC, not through a hub
- Try another USB port
- Check that your OS has the USB-serial driver for the chip (recent OSes ship it)

### Flashing stops part way

- Check the cable and the connection. Insufficient power or a loose contact is the usual cause
- Press the button again and reselect the port
- If it keeps failing, try another PC or another browser

### Nothing on screen after flashing

**Modern:** press reset once. If the log shows `boot:0x204 (DOWNLOAD...)` and
`waiting for download`, the board stayed in download mode — reset is all it needs.

**Retro:** check that both chips are on the same version. An old `fmruby-core` with a new
`fmruby-graphics-audio` (or the reverse) fails to boot. Flash both with the same release.
