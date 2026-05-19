# ユーティリティ (JSON / MessagePack / BMP332 / RX8900)

汎用ユーティリティ系の API をまとめます。

## JSON

JSON 文字列のパース・生成。設定ファイル、マップデータ、Web ツールとのやり取りなどに使います。

### メソッド

| メソッド | 用途 |
|---|---|
| `JSON.parse(string)` | JSON 文字列を Hash / Array に変換 |
| `JSON.generate(obj)` / `JSON.dump(obj)` | Ruby オブジェクトを JSON 文字列に |

### サンプル

```ruby
text = File.open("/data/conf.json", "r") { |f| f.read }
conf = ::JSON.parse(text)
Log.info("user=#{conf["user"]}")

File.open("/data/conf.json", "w") do |f|
  f.write(::JSON.generate({"user" => "kishima", "score" => 100}))
end
```

!!! warning "`::JSON` と書く"
    クラスの中で書く `JSON.parse(...)` は picoruby の定数探索で **クラス内の `JSON`** として解釈され、見つからず失敗することがあります。`::JSON.parse(...)` と先頭に `::` を付けてトップレベルを明示してください。

[TileMap](tilemap.md) は内部で `JSON.parse` を使ってマップファイルを読みます。

## MessagePack

データのバイナリシリアライゼーション。`publish` や `send_message` で内部的に使われていますが、ユーザーアプリでも利用できます。

### メソッド

| メソッド | 用途 |
|---|---|
| `MessagePack.pack(obj)` | バイナリ化（`String` を返す） |
| `MessagePack.unpack(binary)` | 復元 |

### 対応する Ruby 型

`Hash`、`Array`、`Integer`、`Float`、`String`、`Boolean`、`nil`

### サンプル: 設定をファイル保存

```ruby
config = {"score" => 100, "name" => "Player1", "options" => [1, 2, 3]}

# 保存
File.open("/save.dat", "w") do |f|
  f.write(MessagePack.pack(config))
end

# 読み戻し
data = File.open("/save.dat", "r") { |f| f.read }
restored = MessagePack.unpack(data)
Log.info("score = #{restored["score"]}")
```

!!! tip "JSON より効率的"
    数値や Boolean を多く含むデータでは MessagePack のほうが省サイズかつパース速度も速いです。Family mruby は picoruby に JSON ライブラリを同梱していないため、構造データの保存形式として MessagePack が標準です。

## BMP332

RGB332 形式の BMP 画像データをパースします。

### メソッド

| メソッド | 用途 |
|---|---|
| `BMP332.parse(binary)` | バイナリから読み込み |

戻り値は次の Hash:

```ruby
{
  width:  Integer,
  height: Integer,
  pixels: String   # RGB332 ピクセル配列（width * height バイト）
}
```

### サンプル

```ruby
data = File.open("/img.bmp", "r") { |f| f.read }
bmp = BMP332.parse(data)
Log.info("size: #{bmp[:width]}x#{bmp[:height]}")

# ピクセルを SpriteImage に書き込みたい場合は SpriteImage#load_bmp を使う方が高速
```

!!! note
    通常の画像表示では **WROVER 側でデコードが完結する** `SpriteImage#load_bmp` または `FmrbGfx#create_image_from_file` を使うのが高速です。`BMP332.parse` はピクセル配列を Ruby 側で扱いたい時（編集・検査）に使います。

詳細仕様は [画像・アイコンファイル](../file_formats/image_formats.md#bmp) を参照。

## RX8900

I2C 接続の RTC（Real Time Clock）IC のドライバです。基板上に搭載されている時計を Ruby から扱います。

I2C アドレス: `0x32` 固定

### コンストラクタ

```ruby
RX8900.new(i2c)
```

引数: `I2C` インスタンス（[周辺機器 ▸ I2C](peripherals.md#i2c) 参照）

### メソッド

| メソッド | 戻り値 / 用途 |
|---|---|
| `init` | RTC 初期化（WEEK ALARM モード、1Hz FOUT 出力など） |
| `read_time` | `{year:, month:, day:, hour:, minute:, second:, wday:}` |
| `write_time(hash)` | 時刻を書き込み |
| `sync_system_clock` | RTC をシステム epoch に同期。成功なら `true` |
| `temperature` | 温度センサ値（摂氏 `Float`） |
| `vlf?` | 電池低下フラグ。`true` なら時計データ消失の可能性 |

### サンプル: 起動時に時計同期

```ruby
class ClockSyncApp < FmrbApp
  def on_create
    i2c = I2C.new(unit: "ESP32_I2C0")
    rtc = RX8900.new(i2c)
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

!!! note
    `FmrbApp.wallclock` / `FmrbApp.set_wallclock` でも時刻取得・設定ができます。これらはシステム時計（POSIX epoch）を経由して RTC とも同期します。日常的な「現在時刻が知りたい」用途では `FmrbApp.wallclock` のほうが手軽です。

## 関連

- 直接バイナリ操作は [`File` / `IO`](filesystem.md) を参照
- I2C デバイス利用には [周辺機器 ▸ I2C](peripherals.md#i2c) も参照
