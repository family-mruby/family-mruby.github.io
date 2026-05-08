# 周辺機器 (GPIO / I2C / RMT)

!!! info "工事中"
    このページは整備中です。

## 概要

ハードウェア周辺機器を Ruby から操作するための API です。

!!! note
    各端子のピン配置・電気的仕様は [ハードウェア](../hardware.md) を参照してください。

## GPIO

`GPIO.new(pin, mode)`, `read`, `write(value)`, モード指定 (`GPIO::IN`, `GPIO::OUT`, ほか)

TODO

## I2C

`I2C.new(...)`, `read`, `write`, `write_read`

TODO

## RMT

ESP32 の RMT ペリフェラル経由での赤外線 / WS2812B LED 制御。

TODO

## サンプル

TODO
