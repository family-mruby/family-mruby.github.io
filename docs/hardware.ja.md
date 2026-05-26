# ハードウェア

narya-board の各端子・ピン配置の仕様です。


!!! note
    回路図・KiCAD 設計データ・基板写真は [narya-board リポジトリ](https://github.com/family-mruby/narya-board) を参照してください。

## 概要

| 項目 | 内容 |
|---|---|
| メイン MCU (fmrb-core) | ESP32-S3-WROOM-1-N16R8（16MB Flash + 8MB PSRAM） |
| サブ MCU (fmrb-graphics-audio) | ESP32-WROVER-E/IE（PSRAM 搭載） |
| MCU 間通信 | UART1（921600 bps、CTS/RTS フロー制御） |
| 映像出力 | NTSC コンポジット (LovyanGFX CVBS を利用) |
| 音声出力 | I2S DAC（NES APU エミュレータ） |
| ストレージ | 内蔵 LittleFS (16MB) + SD カード (FAT32, SPI 接続) |

![Narya board](../../images/board_block_diagram.png)

## 電源

| 項目 | 値 |
|---|---|
| 入力 | USB Type-C (5V) |
| 内部レギュレータ | 3.3V |
| 推奨電源 | 1A以上の安定した USB 給電 |

## 映像出力

| 項目 | 値 |
|---|---|
| コネクタ | RCA（ピンジャック、黄色） |
| 信号方式 | NTSC コンポジット |
| 標準解像度 | 320 x 240 |
| カラー | RGB332（256 色） |

CRT モニタ／キャプチャデバイスの個体差で色味が変わる場合は、`FmrbGfx#set_output_level` / `set_chroma_level` で調整できます。

## 音声出力

| 項目 | 値 |
|---|---|
| コネクタ | 3.5mm ステレオミニジャック |
| 信号 | I2S → DAC でアナログ出力 |
| 出力レベル | ライン出力相当 |

NES APU エミュレータが動いており、矩形波 2 系統 + 三角波 + ノイズ の ４ チャンネルで音を鳴らせます。詳細は [FmrbAudio](api/audio.md) と [音声ファイルフォーマット](file_formats/audio_formats.md) を参照。

## GROVE

基板には 2 つの GROVE コネクタがあります。
左画からGND、電源、Sig1、Sig2 とした場合の接続品は以下の通りです。

| コネクタ | Sig2 | Sig2 | 備考 |
|---|---|---|---|
| GROVE 1 | GPIO 14/I2C1-SDA | GPIO 21/I2C1-SCL | I2C用/RTC (RX8900 アドレス:0x32) と共有。10Kプルアップ有り |
| GROVE 2 | GPIO 47 | GPIO 48 | 汎用。プルアップなし。電源選択可能 |

GROVE 1 は RTC が接続されている I2C バスを共有するため、アドレスの衝突に注意してください。

GROVE 2 は信号にプルアップなしで、電源の供給方法をピンヘッダで変更可能なので、GPIO、UARTや[RMT](api/peripherals.md#rmt) など自由な用途で利用可能です。

![Grove](images/Grove-pin.png)

## PIN配置

ESP32-S3 PIN配置

![ESP32-S3 PIN配置](images/ESP32-S3-PIN.png)

ESP32-WROVER PIN配置

![ESP32-WROVER PIN配置](images/ESP32-WROVER-PIN.png)

### I2C

| バス | SDA | SCL | 備考 |
|---|---|---|---|
| I2C1 | GPIO 14 | GPIO 21 | RTC (RX8900) が共有 |
| I2C2 | GPIO 47 | GPIO 48 | 自由用途 |

`I2C.new(unit: "ESP32_I2C0", ...)` 等で利用します（[周辺機器 ▸ I2C](api/peripherals.md#i2c) 参照）。

### 外出しGPIO

ピン位置 (S3)

![ピン位置 (S3)](images/pin-location-s3.png)

ピン位置 (WROVER)

![ピン位置 (WROVER)](images/pin-location-wrover.png)

## RTC (リアルタイムクロック)

基板に RX8900 RTC IC（I2C アドレス 0x32、I2C1 経由）が搭載されています。電池で時刻保持されます。

```ruby
i2c = I2C.new(unit: "ESP32_I2C0")
rtc = RX8900.new(i2c)
rtc.sync_system_clock
```

詳細は [RX8900 API](api/utilities.md#rx8900) を参照。

## 関連

- ピンを使う前の確認 → [FmrbHw](api/const.md#fmrbhw)
- 周辺機器 API → [周辺機器](api/peripherals.md)
- 起動から最初のアプリまで → [起動と接続](getting_started/setup.md)
