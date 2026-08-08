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

## 関連

- 直接バイナリ操作は [`File` / `IO`](filesystem.md) を参照
- I2C デバイス利用には [ハードウェア制御 ▸ I2C](peripherals.md#i2c) も参照
