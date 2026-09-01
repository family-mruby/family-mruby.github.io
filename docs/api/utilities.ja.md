# ユーティリティ (JSON / MessagePack / BMP332)

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
text = File.open("/home/conf.json", "r") { |f| f.read }
conf = ::JSON.parse(text)
Log.info("user=#{conf["user"]}")

File.open("/home/conf.json", "w") do |f|
  f.write(::JSON.generate({"user" => "kishima", "score" => 100}))
end
```

!!! warning "`::JSON` と書く"
    クラスの中で書く `JSON.parse(...)` は picoruby の定数探索で クラス内の `JSON` として解釈され、見つからず失敗することがあります。`::JSON.parse(...)` と先頭に `::` を付けてトップレベルを明示してください。

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
    通常の画像表示では グラフィックス側でデコードが完結する `SpriteImage#load_bmp` または `FmrbGfx#create_image_from_file` を使うのが高速です。`BMP332.parse` はピクセル配列を Ruby 側で扱いたい時（編集・検査）に使います。

詳細仕様は [画像・アイコンファイル](../file_formats/image_formats.md#bmp-rgb332) を参照。

## Fmrb::Fft

高速フーリエ変換です。使う実装は実行時に選べます。もともとはマイクの音を見るアプリの
ために作ったものですが、標本を周波数に変えたいものなら何にでも使えます。

```ruby
fft = Fmrb::Fft.new(size: 512, backend: :c)
mag = fft.forward(samples)              # size/2 個の int16 (リトルエンディアン)
peak = Fmrb::Fft.peak_bin(mag)          # 一番大きい所の番号
hz = peak * rate / 512.0
fft.close
```

`size` は 64 から 1024 までの 2 のべき乗です。`samples` は int16 を `size` 個並べた
バイト列で、`FmrbAudio#mic_read` が返す形そのままです。

| メソッド | |
|---|---|
| `Fmrb::Fft.new(size: 512, backend: :ruby)` | 実装を選びます |
| `forward(samples)` | 1 回変換して、大きさの列を返します |
| `run(samples, iters)` | 同じ入力を `iters` 回変換し、実装の中で時間を測ります。`[マイクロ秒, 大きさの列]` |
| `close` | 解放します |
| `Fmrb::Fft.bin(mag, index)` | 結果から 1 つ取り出します |
| `Fmrb::Fft.peak_bin(mag)` | 一番大きい所の番号 |
| `Fmrb::Fft.sine(size:, cycles:, amp:)` | 合成した入力。同じ波形で実装どうしを比べるため |
| `Fmrb::Fft.bench(size:, iters:, backend:, reps:)` | 1 つの実装の時間を測ります |
| `Fmrb::Fft.available?(backend)` / `.q15?(backend)` | このビルドに入っているか、固定小数点で計算するか |

実装は `:ruby`、`:c`、`:c64`、`:dsp`、`:spinel` と、固定小数点の `:ruby_q15`、`:c_q15`、
`:spinel_q15` です。どれが入っているかはビルド次第なので、決め打ちせず `available?` で
尋ねてください。固定小数点のものは仕組み上、浮動小数点のものと数カウント違います。
2 つの系統をまたいで結果を比べるときは、その分を見込む必要があります。

## 関連

- 直接バイナリ操作は [`File` / `IO`](filesystem.md) を参照
- I2C デバイス利用には [ハードウェア制御 ▸ I2C](peripherals.md#i2c) も参照
