# Architecture

<div align="center">
  <img src="images/Architecture.png" alt="Family mruby Architecture" width="800">
</div>

Family mruby is a personal project implementing a "Multi-VM architecture based on MicroRuby," built on top of FreeRTOS. The system enables concurrent execution of multiple Ruby virtual machines.

The architecture consists of two main components:

- **fmrb-core (ESP32-S3 with PSRAM)**: The main processing board running the Family mruby OS Framework. Hosts multiple FreeRTOS tasks, each running independent VMs:
    - OS Manager (MicroRuby): System management and coordination
    - MicroRuby App: User applications written in Ruby
    - Guest Language Apps: Support for other scripting languages like Lua

- **fmrb-audio-graphics (ESP32 with PSRAM)**: Dedicated board handling audio/graphics processing, including an Audio/Graphics Controller, NES APU emulator, and LovyanGFX library. Communicates with the core board via UART.

## Multi-VM Structure

The system follows a "one task = one VM" design philosophy, leveraging FreeRTOS task functionality to run multiple VMs in parallel. Each VM operates independently with its own stack and memory space, ensuring isolation and stability.

## Key Features

- **OS Foundation**: Built on FreeRTOS running on ESP-IDF
- **VM Implementation**: Uses MicroRuby VM based on mruby (not PicoRuby based on mruby/c)
- **Independent Memory Pools**: Each VM has its own memory allocator handle, preventing system-wide memory fragmentation and isolating failures to individual VMs
- **Multi-language Support**: Primary support for MicroRuby, with experimental Lua support and planned MicroPython integration

## Target Hardware

Designed for ESP32 devices with multi-megabyte PSRAM (e.g., ESP32-S3-WROOM-1-N16R8). Custom development boards are under development.
