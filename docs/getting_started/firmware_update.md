# Firmware Update

A browser-based installer is available for writing firmware. When firmware updates are released in the future, you can use this page to apply them.

Public URL: [https://family-mruby.github.io/family-mruby-installer/](https://family-mruby.github.io/family-mruby-installer/)

## Requirements

| Item | Recommendation |
|---|---|
| Web Serial compatible browser | Chrome / Edge / Opera (desktop versions). Firefox / Safari are not supported |
| USB Type-C cable | Must support data communication (charging-only cables will not work) |

## Flashing Procedure

The Family mruby board has two MCUs (ESP32-S3 for main processing and ESP32-WROVER for video/audio), and each must be flashed independently. The installer screen provides buttons for each MCU.

1. Open the [installer](https://family-mruby.github.io/family-mruby-installer/) in your browser
2. Connect the board to your PC with a USB Type-C cable (use a data-capable cable)
3. Select the desired version from the dropdown
4. Click the appropriate button for the target MCU:
    - `fmruby-core` button: flash the ESP32-S3
    - `fmruby-graphics-audio` button: flash the ESP32-WROVER
5. Select the serial port in the browser dialog
6. The chip is automatically detected and flashing begins

!!! note "Update target"
    Update the firmware for both MCUs to the same version. If the versions do not match, the system will not boot correctly.

!!! warning "What happens if you select the wrong MCU?"
    The installer automatically checks the chip family (ESP32-S3 / ESP32), so selecting the wrong one will result in an error.


## Which USB Port to Connect

The board has separate USB Type-C ports for different purposes:

- Connecting to the ESP32-S3 side USB-C allows flashing fmruby-core
- Connecting to the ESP32-WROVER side USB-C allows flashing fmruby-graphics-audio

## Troubleshooting

### The browser does not recognize the serial port

- Check that the cable supports data communication (charging-only USB-C cables will not be recognized)
- Use a USB-certified cable
- Connect directly to the PC without a USB hub
- Use as short a USB cable as possible
- Try a different USB port
- Verify that the USB serial driver for the ESP32 chip is installed on your OS (recent OS versions include it by default)

### Flashing fails midway

- Check the USB cable and connection (insufficient power or poor contact is often the cause)
- Click again and re-select the port to retry
- If it still fails, try a different PC or browser

### No display after flashing

- Verify that both MCUs are on the same protocol version. Combinations such as an old fmruby-core with a new fmruby-graphics-audio will fail to boot
- Flash both MCUs with the latest version
