# ユーティリティ (MessagePack / BMP332 / RX8900)

!!! info "工事中"
    このページは整備中です。

## MessagePack

データのバイナリシリアライゼーション。

| メソッド | 用途 |
|---|---|
| `MessagePack.pack(obj)` / `MessagePack.dump(obj)` | バイナリ化 |
| `MessagePack.unpack(binary)` / `MessagePack.load(binary)` | 復元 |

TODO

## BMP332

RGB332 形式の BMP 画像処理。

| メソッド | 用途 |
|---|---|
| `BMP332.load(path)` | ファイルから読み込み |
| `BMP332.parse(binary)` | バイナリから読み込み |
| `BMP332.save(path, width, height, pixels)` | ファイルに保存 |

!!! note
    画像の生成方法・他形式からの変換は [画像・アイコンファイル](../guide/image_formats.md) を参照。

TODO

## RX8900 (RTC)

I2C 接続の RTC IC ドライバ。

| メソッド | 用途 |
|---|---|
| `RX8900#initialize(i2c)` | 初期化 |
| `init` | RTC 初期化 |
| `read_time` | 現在時刻読み出し |
| `write_time(hash)` | 時刻書き込み |
| `sync_system_clock` | システムクロックを RTC で同期 |
| `temperature` | 温度センサ値取得 |
| `vlf?` | 電圧低下フラグ |

TODO

## サンプル

TODO
