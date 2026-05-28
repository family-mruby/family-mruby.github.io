# BLE Web Console

A tool for reading and writing files on the board from a PC's browser via Bluetooth Low Energy (BLE).

It can be operated from a web browser.

## Requirements

- A PC capable of BLE communication
- Web Bluetooth compatible browser (Chrome / Edge) (Firefox / Safari are not supported)

## Starting the Client

Open the following URL in your browser.

[https://family-mruby.github.io/console/](/console/)

## Connection Procedure

1. Turn on the board and wait for startup to complete (a few seconds)
2. Open the client in your browser
3. Click the "Connect" button on the screen
4. Select "Family-mruby-XXXXXX" from the browser's BLE device selection dialog
5. Press the "Pair" button (on some operating systems this may appear as "Connect")

![Console connection](../images/console-pare.png)

!!! warning "If you have trouble connecting on Windows"
    The Windows Bluetooth stack may retain old pairing information and prevent connection. Try deleting the existing `Family-mruby-*` entry from the OS Bluetooth settings and then reconnecting (this device does not retain pairing information).

## Uploading Files (PC to Board)

![Console screen](../images/console1.png)

1. Navigate to the destination directory in the client
2. Drag and drop files from your PC's file explorer into the browser
3. Wait for the transfer to complete

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

Communication speed is not very fast, so large files will take time to transfer.

### Simultaneous Connections

Only one client can be connected at a time. If you want to connect from another browser, disconnect the current one first.

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
