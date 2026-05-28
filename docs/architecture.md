# Architecture

!!! note
    Under construction.

![Family mruby Architecture](../../images/Architecture.png)

Family mruby is a personal project implementing a "Multi-VM architecture based on MicroRuby," built on top of FreeRTOS. The system enables concurrent execution of multiple MicroRuby virtual machines.

The architecture consists of two main components:

- fmrb-core (ESP32-S3 with PSRAM): The main processing board running the Family mruby OS framework. It hosts multiple FreeRTOS tasks, each running an independent VM:
    - OS Manager (MicroRuby): System management and coordination
    - MicroRuby App: User applications written in Ruby
    - Guest Language Apps: Support for other scripting languages like Lua

- fmrb-audio-graphics (ESP32 with PSRAM): A dedicated board handling audio and graphics processing. It includes an Audio/Graphics Controller, NES APU emulator, and the LovyanGFX library. It communicates with the core board via UART.

## Multi-VM Structure

The system follows a "one task = one VM" design philosophy, leveraging FreeRTOS task functionality to run multiple VMs in parallel. Each VM has its own stack and memory space, operating independently to ensure isolation and stability.

## Key Features

- OS Foundation: FreeRTOS running on ESP-IDF
- VM Implementation: Uses MicroRuby VM based on mruby
- Independent Memory Pools: Each VM has its own memory allocator handle, preventing system-wide memory fragmentation and isolating individual VM failures
- Multi-language Support: Primary support for MicroRuby, with experimental Lua support and planned MicroPython integration

## Target Hardware

Designed for ESP32 devices with PSRAM (e.g., ESP32-S3-WROOM-1-N16R8). Custom development boards are also under development.
