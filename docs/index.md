# Family mruby Documentation

<div align="center">
  <img src="images/topimage.png" width="500" alt="FMRuby Logo">
</div>

## About Family mruby

[blog article](https://blog.silentworlds.info/family-mruby-os-freertosbesunomicrorubymarutivmgou-xiang-2/)

Documentation is under construction.

## Demo Video

<div align="center">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/Wa_3XtLF-6U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## What is Family mruby?

Long ago, BASIC was often the first programming language that children encountered. Despite its limitations, there were products like Family BASIC, which allowed BASIC programming not only on PCs but also on platforms such as the MSX or the Famicom (NES). Many programmers discovered the joy of programming through these environments.

Today, development environments for most programming languages are freely available and easily installable on PCs. However, because so much is possible, beginners often don't know where to start. Even reaching the point where you can make something slightly beyond "Hello World," such as a simple game, can require a surprisingly high setup cost.

**Family mruby** aims to recreate that accessible programming experience on modern hardware. It provides an environment where you can build small games or applications using a scripting language on a single microcontroller board—bringing back the joy of simple, immediate programming.

## Architecture

<div align="center">
  <img src="images/Architecture.png" alt="Family mruby Architecture" width="800">
</div>

Family mruby is a personal project implementing a "Multi-VM architecture based on MicroRuby," built on top of FreeRTOS. The system enables concurrent execution of multiple Ruby virtual machines.

The architecture consists of two main components:

- **fmrb-core (ESP32-S3 with PSRAM)**: The main processing board running the Family mruby OS Framework. Hosts multiple FreeRTOS tasks, each running independent VMs:
  - OS Manager (MicroRuby): System management and coordination
  - MicroRuby App: User applications written in Ruby
  - Guest Language Apps: Support for other scripting languages like Lua

- **fmrb-audio-graphics (ESP32 with PSRAM)**: Dedicated board handling audio/graphics processing, including an Audio/Graphics Controller, NES APU emulator, and LovyanGFX library. Communicates with the core board via SPI.

### Multi-VM Structure

The system follows a "one task = one VM" design philosophy, leveraging FreeRTOS task functionality to run multiple VMs in parallel. Each VM operates independently with its own stack and memory space, ensuring isolation and stability.

### Key Features

- **OS Foundation**: Built on FreeRTOS running on ESP-IDF
- **VM Implementation**: Uses MicroRuby VM based on mruby (not PicoRuby based on mruby/c)
- **Independent Memory Pools**: Each VM has its own memory allocator handle, preventing system-wide memory fragmentation and isolating failures to individual VMs
- **Multi-language Support**: Primary support for MicroRuby, with experimental Lua support and planned MicroPython integration

### Target Hardware

Designed for ESP32 devices with multi-megabyte PSRAM (e.g., ESP32-S3-WROOM-1-N16R8). Custom development boards are under development.

