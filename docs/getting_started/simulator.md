# Simulator (Try without hardware)

You can try Family mruby with just Docker and a PC browser, even if you don't have the board.

## Requirements

- Docker (PC)
- A modern browser (tested with Chrome)

## Starting

```bash
docker run --rm -p 6080:6080 ghcr.io/family-mruby/fmruby-desktop:latest
```

After starting, open the following URL in your browser:

[http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)

The Family mruby desktop will appear in the VNC viewer (noVNC), and you can operate it directly with the mouse and keyboard.

## Verified Environments

| OS | Status |
|---|---|
| Linux (x86_64) | Verified |
| Windows (WSL2) | Verified |
| macOS (Apple Silicon) | ARM64 image available, not yet verified |

An ARM64 image is also published, so it should work on Mac, but this has not been verified.

## Limitations

| Item | Status |
|---|---|
| Video output | OK |
| Keyboard input | OK |
| Mouse input | OK |
| Audio output | N/A (due to VNC environment) |
| Gamepad | N/A |
| GPIO / I2C / RMT and other HW features | N/A |

If you want to try sound or physical hardware features, please use the actual device.

## Stopping

Press `Ctrl+C` in the Docker console, or run `docker stop` from another terminal. Since it was started with the `--rm` option, the container will be automatically removed.

## Developing on PC

Refer to each repository's Readme.
