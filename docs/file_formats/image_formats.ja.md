# 画像・アイコンファイル

!!! note
    内容編集中です


Family mruby が対応する画像・アイコン形式と、その作成・変換方法を説明します。

| 形式 | 用途 | 関連 API |
|---|---|---|
| BMP (RGB332) | 一般的な画像表示・スプライト | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | アプリアイコン（テキスト形式） | – |
| PNG | 未対応 | – |

## BMP (RGB332)

Family mruby が標準で扱う画像形式は、RGB332 相当の 8bit BMP です。  
1 ピクセルは 1 バイトで、色は R:3bit / G:3bit / B:2bit で表現されます。

### フォーマット仕様

BMP ファイル形式としては、標準的な 8bit パレット BMP を使用します。

- BMP ヘッダ  
  - `BITMAPFILEHEADER`
  - `BITMAPINFOHEADER`
- 8bit indexed BMP
- パレットは RGB332 配列
- 各ピクセル値は RGB332 インデックス値

### PC で作る方法

GIMP / ImageMagick / Photoshop 等で:

1. 画像を必要サイズにリサイズ
2. 8bit / 256 色に変換
3. BMP（8bit indexed）として保存

その後、パレットを RGB332 配列に変換します。

### RGB332 の色構成

| 要素 | bit数 |
|---|---|
| Red | 3bit |
| Green | 3bit |
| Blue | 2bit |

合計 8bit / 256 色です。

### 使い方

```ruby
# スプライト画像として読み込み（高速）
img = SpriteImage.new(@gfx, width: 32, height: 32,
                       transparent_color: 0, use_transparent: true)
img.load_bmp("/usr/share/sprite/player.bmp")

# 通常画像として読み込み・表示
ret = @gfx.create_image_from_file("/img.bmp")
@gfx.draw_image(ret[:id], 10, 20)

# Ruby 側でピクセルを操作したい場合
data = File.open("/img.bmp", "r") { |f| f.read }
bmp = BMP332.parse(data)
# bmp[:width], bmp[:height], bmp[:pixels]
```

## アイコンファイル (.icon)

アプリのランチャーに表示するアイコンを定義する テキスト形式 のファイルです。

### 形式

```
# <名前> (<幅>x<高さ>) color=0x<RGB332>
............
...111111...
..11111111..
.11111.1111.
111111..1111
.1111111111.
..11111111..
...111111...
....1111....
.....11.....
............
............
```

| 文字 | 意味 |
|---|---|
| `.` | 透明（描画しない） |
| `1` | ピクセル（指定色で塗る） |
| `#` | コメント行（先頭に色設定が書ける） |

### コメント行のメタ情報

- `color=0xNN` で全ピクセルの色（RGB332）を指定
- 省略時は白 (`0xFF`)

### 推奨サイズ

ランチャーアイコンの標準サイズは 12 × 12 ピクセル

### 配置先

```
/usr/share/icon/<name>.icon
```

`.toml` で参照する際は:

```toml
icon = "usr/share/icon/myapp.icon"
```

（先頭の `/` は不要、相対パスで書きます）

### サンプル

リンゴ風アイコン (12 × 12、赤):

```
# Apple (12x12) color=0xE0
......1.....
.....11.....
.....1......
....1......
...111111...
..11111111..
.111111111..
.111111111..
.111111111..
.111111111..
..11111111..
...111111...
```

### 既定アイコン

`.toml` で `icon` を省略すると、本体ファイルの拡張子に応じた既定アイコンが使われます:

| 拡張子 | 既定アイコン |
|---|---|
| `.rb` | `usr/share/icon/ruby.icon` |
| `.lua` | `usr/share/icon/lua.icon` |
| `.bas` | `usr/share/icon/basic.icon` |

## PNG

PNG ファイルの直接表示は 未対応 です。PC 側で BMP332 形式に変換して書き込んでください（GIMP の「エクスポート」→ BMP、24bit を選んだ後、別途 RGB332 変換スクリプトで圧縮）。

## 関連

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- スプライトエディタ: `flash/app/tool/sprite_editor.app.rb`
