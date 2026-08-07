# ハードウェア制御 (GPIO / I2C / RMT / RTC)

ハードウェア周辺機器を Ruby から操作するための API です。

!!! note
    各端子のピン配置・電気的仕様は [ハードウェア](../hardware.md) を参照してください。  
    ピンが他の機能で使われていないかは [`FmrbHw.pin_status`](const.md#fmrbhw) で確認できます。

!!! warning "ピン番号は機種で違います"
    GROVE のピンは Retro と Modern で違うので、番号を決め打ちしたアプリは片方でしか
    動きません。基板で分岐してください。

    ```ruby
    sda, scl = case FmrbConst::BOARD
               when "tab5", "naryav4" then [53, 54]   # Tab5 の GROVE
               else                        [47, 48]   # narya-board の GROVE 2
               end
    ```

    システムが確保していて、そもそも取得できないピンもあります。機種ごとの一覧は
    [ハードウェア](../hardware.md) を参照してください。

## GPIO

デジタル入出力です。

### コンストラクタ

```ruby
GPIO.new(pin, flags, alt_function = 0)
```

| 引数 | 用途 |
|---|---|
| `pin` | GPIO 番号 |
| `flags` | 方向・プル設定（OR で組み合わせ可） |
| `alt_function` | 代替機能番号（通常 `0`） |

### `flags` 定数

| 定数 | 意味 |
|---|---|
| `GPIO::IN` | 入力 |
| `GPIO::OUT` | 出力 |
| `GPIO::HIGH_Z` | ハイインピーダンス |
| `GPIO::PULL_UP` | プルアップ抵抗有効 |
| `GPIO::PULL_DOWN` | プルダウン抵抗有効 |
| `GPIO::OPEN_DRAIN` | オープンドレイン出力 |
| `GPIO::ALT` | 代替機能 |

OR で組み合わせます:

```ruby
btn = GPIO.new(10, GPIO::IN | GPIO::PULL_UP)
led = GPIO.new(11, GPIO::OUT)
```

### インスタンスメソッド

| メソッド | 用途 |
|---|---|
| `read` | レベル読み出し（`0` / `1`） |
| `write(val)` | `0` または `1` を出力 |
| `high?` | レベルが High なら `true` |
| `low?` | レベルが Low なら `true` |

### クラスメソッド（インスタンスを作らずダイレクト操作）

| メソッド | 用途 |
|---|---|
| `GPIO.read_at(pin)` | レベル読み出し |
| `GPIO.write_at(pin, val)` | レベル出力 |
| `GPIO.high_at?(pin)` / `GPIO.low_at?(pin)` | レベル判定 |
| `GPIO.set_dir_at(pin, dir)` | 方向のみ変更 |
| `GPIO.pull_up_at(pin)` / `GPIO.pull_down_at(pin)` | プル抵抗を有効化 |
| `GPIO.open_drain_at(pin)` | オープンドレイン |
| `GPIO.set_function_at(pin, alt)` | 代替機能 |

### サンプル: ボタンで LED トグル

```ruby
class LedToggle < FmrbApp
  BTN_PIN = 10
  LED_PIN = 11

  def on_create
    @btn = GPIO.new(BTN_PIN, GPIO::IN | GPIO::PULL_UP)
    @led = GPIO.new(LED_PIN, GPIO::OUT)
    @led.write(0)
    @prev = 1
  end

  def on_update
    cur = @btn.read
    if @prev == 1 && cur == 0   # 立ち下がり
      @led.write(@led.read == 1 ? 0 : 1)
    end
    @prev = cur
    20
  end
end

LedToggle.new.start
```

## I2C

I2C バス経由でデバイスと通信します。

### コンストラクタ

```ruby
I2C.new(unit:, frequency: 100_000, sda_pin: -1, scl_pin: -1, timeout: 500)
```

| 引数 | 用途 |
|---|---|
| `unit:` | バス識別子。例: `"ESP32_I2C0"`、`"ESP32_I2C1"` |
| `frequency:` | クロック周波数 (Hz)。デフォルト 100kHz |
| `sda_pin:` / `scl_pin:` | -1 で既定ピンを使用 |
| `timeout:` | タイムアウト ms |

### メソッド

| メソッド | 用途 |
|---|---|
| `read(addr_7bit, length, timeout: @timeout, *write_data)` | リード（`write_data` があれば事前ライト → STOP なしでリード） |
| `write(addr_7bit, *data, timeout: @timeout)` | ライト。`Integer` / `Array<Integer>` / `String` を受け付け |
| `scan(timeout: @timeout)` | 0x08〜0x77 をスキャンして応答デバイス一覧を返す |
| `close` | バス解放 |

### サンプル: I2C デバイスのスキャン

```ruby
i2c = I2C.new(unit: "ESP32_I2C0", frequency: 400_000)
addrs = i2c.scan
Log.info("found: #{addrs.map { |a| a.to_s(16) }.join(', ')}")
```

### サンプル: レジスタ読み書き

```ruby
i2c = I2C.new(unit: "ESP32_I2C0")
# レジスタ 0x10 から 4 バイト読み出し
data = i2c.read(0x32, 4, 0x10)   # 第3引数以降が write_data
i2c.write(0x32, 0x10, 0xAB)      # 0x10 = 0xAB を書き込み
```

## RMT

ESP32 の RMT ペリフェラル経由で WS2812B / WS2812 LED や赤外線リモコンを駆動します。

### コンストラクタ

```ruby
RMT.new(pin, t0h_ns:, t0l_ns:, t1h_ns:, t1l_ns:, reset_ns:)
```

NRZ 符号化のタイミング（ナノ秒）を指定します。WS2812B の標準値:

```ruby
rmt = RMT.new(8,
              t0h_ns: 350,  t0l_ns: 900,
              t1h_ns: 700,  t1l_ns: 600,
              reset_ns: 50_000)
```

### メソッド

| メソッド | 用途 |
|---|---|
| `write(*params)` | バイト列出力。`Integer` / `Array` / `String` 引数対応 |

### サンプル: WS2812B を点灯

```ruby
class LedStrip < FmrbApp
  RMT_PIN = 8

  def on_create
    @rmt = RMT.new(RMT_PIN,
                    t0h_ns: 350,  t0l_ns: 900,
                    t1h_ns: 700,  t1l_ns: 600,
                    reset_ns: 50_000)
    set_color(0xFF, 0x00, 0x00)  # 赤
  end

  def set_color(r, g, b)
    # WS2812B は GRB 順
    @rmt.write([g, r, b])
  end
end

LedStrip.new.start
```

`/app/demo/led_matrix.app.rb` に WS2812B マトリクスのサンプルがあります。

## 時計 (RX8900 / RX8130)

両機種とも I2C の `0x32` に電池つきの RTC を持っています。部品は違います。

| 機種 | 部品 | クラス |
|---|---|---|
| Retro (narya-board) | RX8900。I2C1 上で GROVE 1 と共有 | `RX8900` |
| Modern (M5Stack Tab5) | RX8130。内部のバスに接続 | `RX8130` |

2 つのクラスは引数もメソッドも同じなので、基板でクラスを選べば同じアプリが両方で動きます。

```ruby
i2c = I2C.new(unit: "ESP32_I2C0")
rtc = FmrbConst::BOARD == "tab5" ? RX8130.new(i2c) : RX8900.new(i2c)
rtc.sync_system_clock
```

### メソッド

| メソッド | 戻り値 / 用途 |
|---|---|
| `init` | RTC の初期化 |
| `read_time` | `{year:, month:, day:, hour:, minute:, second:, wday:}` |
| `write_time(hash)` | 時刻を書き込む |
| `sync_system_clock` | RTC からシステム時計を合わせる。成功なら `true` |
| `vlf?` | 電圧低下フラグ。`true` なら保持していた時刻が失われた可能性があります |
| `temperature` | 摂氏の温度 (`Float`)。RX8900 のみ |

### サンプル: 起動時に時計を合わせる

```ruby
class ClockSyncApp < FmrbApp
  def on_create
    i2c = I2C.new(unit: "ESP32_I2C0")
    rtc = FmrbConst::BOARD == "tab5" ? RX8130.new(i2c) : RX8900.new(i2c)
    if rtc.vlf?
      Log.warn("RTC battery low; resetting")
      rtc.write_time(year: 2026, month: 1, day: 1,
                     hour: 0, minute: 0, second: 0, wday: 4)
    end
    rtc.sync_system_clock
    now = rtc.read_time
    Log.info("time: #{now[:year]}-#{now[:month]}-#{now[:day]} #{now[:hour]}:#{now[:minute]}")
  end
end

ClockSyncApp.new.start
```

!!! note "普段は使わなくて済みます"
    システムは起動時に RTC から時刻を取り込みますし、`FmrbApp.wallclock` /
    `FmrbApp.set_wallclock` はシステム時計 (POSIX epoch) 経由で RTC にも書き戻します。
    このクラスを直接使うのは、電圧低下フラグや RX8900 の温度センサなど、部品自身の機能が
    要るときだけです。

## ピン割り当て確認

ピンを使う前に、システムが既に使っていないか確認できます。

```ruby
unless FmrbHw.pin_available?(10)
  Log.error("Pin 10 already in use: #{FmrbHw.pin_status(10)}")
  return
end
```

詳細は [FmrbHw](const.md#fmrbhw) を参照。
