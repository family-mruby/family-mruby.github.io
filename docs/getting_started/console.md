# Console

A tool for reading and writing files on the board from a PC or smartphone via Bluetooth Low Energy (BLE). It can be operated from a web browser.

## Overview

- Connection method: Web Bluetooth API (browser standard)
- Device name: `Family-mruby-XXXXXX` (the last 6 characters are the tail of the MAC address)
- Supported operations: Directory listing / File download / File upload / Delete / Directory creation / Sprite editing (in development)

## Requirements

| Item | Recommendation |
|---|---|
| PC with built-in Bluetooth or a Bluetooth USB adapter | Required |
| Web Bluetooth compatible browser | Chrome / Edge (Firefox / Safari are not supported) |
| A running Family mruby device | – |

## Starting the Client

Open the following URL in your browser.

[https://family-mruby.github.io/console/](/console/)

### Running Locally

The client HTML is included in the `fmruby-core/tool/web/` directory of the repository.

```bash
cd fmruby-core/tool
ruby web_server.rb        # Starts on port 8080
# → Open http://localhost:8080 in your browser
```

## Connection Procedure

1. Turn on the board and wait for startup to complete (a few seconds)
2. Open the client in your browser
3. Click the "Connect" button on the screen
4. Select "Family-mruby-XXXXXX" from the browser's BLE device selection dialog
5. Press the "Pair" button (on some operating systems this may appear as "Connect")

!!! warning "If you have trouble connecting on Windows"
    The Windows Bluetooth stack may retain old pairing information and prevent connection. Try deleting the existing `Family-mruby-*` entry from the OS Bluetooth settings and then reconnecting (this device does not retain pairing information).

## Uploading Files (PC to Board)

1. Navigate to the destination directory in the client (e.g., `/app/myapps/`)
2. Drag and drop files from your PC's file explorer into the browser
3. A progress bar will appear — wait for it to complete

You can drop multiple files at once.

## Downloading Files (Board to PC)

1. Display the file in the client
2. Click the download icon
3. Specify the save location in the standard file save dialog on your PC

## Applying Uploaded Files

After uploading app files (`.app.rb` / `.app.toml`) to `/app/<dir>/`, they will not appear in the launcher immediately. You can apply them using either of the following methods:

- Open the launcher and right-click — the title bar will show "Rescanning..." and new apps will appear within 1–2 seconds
- Restart the device — apps are automatically picked up during the startup scan

For details, see [Hello World > Applying in the Launcher](hello_world.md#ランチャーで反映する).

## Notes

### Large Files

The maximum chunk size for PUT / GET is 2KB. The frame size limit is 4KB. Large files are internally split into multiple chunks, but the transfer takes time.

### Simultaneous Connections

Only one client can be connected at a time. If you want to connect from another browser, disconnect the current one first.

### Frequency Interference

Since it uses the same 2.4GHz band as WiFi, disconnections may occur in congested environments.

## Troubleshooting

### Device Not Found

- Check that the board is powered on
- Restart the board and wait a few seconds
- Check whether another browser or tab on the OS is already connected

### Connect Button Does Not Work

- Are you using Chrome / Edge? (Firefox / Safari are not supported)
- Are you opening the client via HTTPS or `localhost`?

## Related

- Where to transfer your custom apps: [Hello World](hello_world.md)
- File system structure: [Files and I/O](../api/filesystem.md#ファイル名前空間)
