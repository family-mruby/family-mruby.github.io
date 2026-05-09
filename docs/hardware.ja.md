# ハードウェア

narya-board の各端子・ピン配置の仕様をまとめます。

!!! note
    回路図・KiCAD 設計データ・基板写真は [narya-board リポジトリ](https://github.com/family-mruby/narya-board) を参照してください。

## 概要

| 項目 | 内容 |
|---|---|
| メイン MCU (fmrb-core) | ESP32-S3-WROOM-1-N16R8（16MB Flash + 8MB PSRAM） |
| サブ MCU (fmrb-graphics-audio) | ESP32-WROVER-E/IE（PSRAM 搭載） |
| MCU 間通信 | UART1（921600 bps、CTS/RTS フロー制御）<br>※ 旧版は SPI、現行は UART に移行 |
| 映像出力 | NTSC コンポジット (LovyanGFX CVBS 実装) |
| 音声出力 | I2S DAC（NES APU エミュレータ） |
| ストレージ | 内蔵 LittleFS (16MB) + SD カード (FAT32, SPI 接続) |

## 電源

| 項目 | 値 |
|---|---|
| 入力 | USB Type-C (5V / ~500mA) |
| 内部レギュレータ | 3.3V |
| 推奨電源 | 安定した USB 給電（PC、スマホ用 5V アダプタ等） |

!!! warning
    USB 周辺機器（マウス、キーボード、ゲームパッド）を本体に接続する場合は、5V 系の電流を多く消費します。USB ハブ経由か、外部給電 USB を使ってください。

## 映像出力

| 項目 | 値 |
|---|---|
| コネクタ | RCA（ピンジャック、黄色） |
| 信号方式 | NTSC コンポジット |
| 標準解像度 | 320 x 224（オーバースキャンに収まる範囲） |
| カラー | RGB332（256 色） |

CRT モニタ／キャプチャデバイスの個体差で色味が変わる場合は、`FmrbGfx#set_output_level` / `set_chroma_level` で調整できます。

## 音声出力

| 項目 | 値 |
|---|---|
| コネクタ | 3.5mm ステレオミニジャック |
| 信号 | I2S → DAC でアナログ出力 |
| 出力レベル | ライン出力相当 |

NES APU エミュレータが動いており、矩形波 2 系統 + 三角波 + ノイズ + DPCM の 5 チャンネルで音を鳴らせます。詳細は [FmrbAudio](api/audio.md) と [音声ファイルフォーマット](file_formats/audio_formats.md) を参照。

## USB

| 項目 | 値 |
|---|---|
| 機能 | USB Host |
| プロトコル | USB HID |
| 対応デバイス | キーボード、マウス、ゲームパッド（HID 互換） |

USB Hub 経由で複数デバイスを同時接続できます。安価なマウスで稀に再接続が必要なケースが既知ですが、ホットプラグ対応済みです。

## ストレージ

| デバイス | パス prefix | 容量 |
|---|---|---|
| 内蔵 LittleFS | `/flash/...` | 16MB |
| SD カード | `/sd/...` | カード次第（FAT32 推奨） |

ファイルシステム API は [ファイル・I/O](api/filesystem.md) を参照。

## ボタン

基板上に 3 つの物理ボタンがあります。

| ボタン | GPIO | 用途 |
|---|---|---|
| UP | GPIO 6 | カーソル上 |
| DOWN | GPIO 7 | カーソル下 |
| ENTER | GPIO 8 | 決定 |

これらはシステム側で監視されており、HID イベントとしてアプリに通知されます。

## LED

| LED | GPIO | 色 | 用途 |
|---|---|---|---|
| STATUS | GPIO 4 | 緑 | 起動状態・正常動作 |
| ERROR | GPIO 39 | 赤 | エラー表示 |

## 拡張 I/O ピン

外部回路と接続できる端子:

### I2C

| バス | SDA | SCL | 備考 |
|---|---|---|---|
| I2C1 | GPIO 14 | GPIO 21 | RTC (RX8900) が共有 |
| I2C2 | GPIO 47 | GPIO 48 | 自由用途 |

`I2C.new(unit: "ESP32_I2C0", ...)` 等で利用します（[周辺機器 ▸ I2C](api/peripherals.md#i2c) 参照）。

### 自由 GPIO

下記以外の GPIO は通常ユーザーアプリから自由に使えます。

#### システム予約ピン（ユーザーは触らない）

| GPIO | 用途 |
|---|---|
| 0 | UART リフラッシュ用ストラッピングピン |
| 3 | JTAG プルダウン |
| 5 | WROVER リセット |
| 9〜13 | WROVER との通信 (UART1 / 旧 SPI) |
| 15〜18 | SD カード SPI3 |
| 19, 20 | USB D-, D+ |
| 35, 36, 37 | PSRAM |
| 38 | SD カード検出 |
| 45, 46 | ストラッピングピン |

#### 内蔵機能で使われているピン

| GPIO | 用途 |
|---|---|
| 1 | USB 電源制御 |
| 4 | Status LED |
| 6, 7, 8 | ボタン UP / DOWN / ENTER |
| 14, 21 | I2C1 |
| 39 | Error LED（JTAG MTCK と共有） |
| 47, 48 | I2C2 |

### 利用可否の確認方法

`FmrbHw.pin_available?(pin)` で実行時にピンが空いているかを確認できます。`tool/gpio_viewer.app.rb` で全ピンの状態を一覧できます。

```ruby
unless FmrbHw.pin_available?(10)
  Log.error("Pin 10 in use")
  return
end
```

詳細は [FmrbHw](api/const.md#fmrbhw) を参照。

## RTC (リアルタイムクロック)

基板に **RX8900** RTC IC（I2C アドレス 0x32、I2C1 経由）が搭載されています。電池で時刻保持されます。

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
