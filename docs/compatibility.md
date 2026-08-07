# Verified Peripherals

This page lists USB devices that have been verified to work with actual hardware.

Devices not listed here may also work, but due to limitations in the USB driver functionality, some devices may not be recognized.

!!! tip "A device that is recognised but behaves wrongly"
    If the cursor jumps, moves on the wrong axis, or does not move while the buttons work,
    the device is being read with the wrong report layout. You can work out the right one on
    the device itself with the **HID Inspector** app — see
    [HID Device Config](file_formats/hid_devices.md).

!!! note "Which machine these were tested on"
    The results below were taken on **Retro** (narya-board). Both machines run the same USB
    host driver, so a device that works on one should work on the other, but the entries
    here have not been re-verified on a Tab5.

    On **Modern** you have an alternative that sidesteps USB entirely: the M5Stack Tab5
    Keyboard accessory attaches to the body over I2C, and the touch panel gives you a
    pointer. Neither needs the USB-A port.

## Keyboards

| Result | Manufacturer | Model | Notes |
|---|---|---|---|
| OK | Elecom | FCP096BK | Verified with Elecom USB hub https://www.amazon.co.jp/dp/B078HT86WB |
| Failed | Buffalo | BSKBU108ENBK | US layout. Not recognized via USB hub https://www.amazon.co.jp/dp/B07JHK41RD |

## Mice

| Result | Manufacturer | Model | Notes |
|---|---|---|---|
| OK | Amazon | -- | Verified with Elecom USB hub https://www.amazon.co.jp/dp/B005EJH6RW |

## Keyboard and Mouse Combos

| Result | Manufacturer | Model | Notes |
|---|---|---|---|
| OK | Logitech | MK245nBK | https://www.amazon.co.jp/dp/B01LW8E866 |
| OK | Omikamo | -- | Verified with wired connection https://www.amazon.co.jp/dp/B0GJSV522Q |

## USB Hubs

| Result | Manufacturer | Model | Notes |
|---|---|---|---|
| OK | Elecom | U3H-H042BK/E | https://www.amazon.co.jp/dp/B0DVGRKJV6 |


## Gamepads

| Result | Manufacturer | Model | Axes / Buttons | Notes |
|---|---|---|---|---|
|---| _None registered_ | -- | -- | -- |

## Connection Tips

- Multiple devices can be connected simultaneously via a USB hub, but compatibility varies by device (keyboard + mouse + gamepad).
- Using the Logitech keyboard and mouse combo (MK245nBK) is recommended as it requires no extra cables.

## Related

- [Hardware > USB](hardware.md#usb) -- Connection specifications
- [Setup and Connection](getting_started/setup.md) -- Connection procedure
