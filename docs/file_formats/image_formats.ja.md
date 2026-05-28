# 画像・アイコンファイル

Family mruby が対応する画像・アイコン形式と、その作成・変換方法を説明します。

| 形式 | 用途 | 関連 API |
|---|---|---|
| BMP (RGB332) | 一般的な画像表示・スプライト | [BMP332](../api/utilities.md#bmp332) / [SpriteImage](../api/sprite.md#spriteimage) |
| `.icon` | アプリアイコン（テキスト形式） | – |

## BMP (RGB332)

Family mruby が標準で扱う画像形式は、RGB332 配列を使用した 8bit BMP です。

1 ピクセルは 1 バイトで、各ピクセル値そのものを RGB332 色値として扱います。

- R: 3bit
- G: 3bit
- B: 2bit

合計 256 色を表現できます。

### フォーマット仕様

BMP ファイル形式としては、標準的な 8bit indexed BMP を使用します。

- BMP ヘッダ
  - `BITMAPFILEHEADER`
  - `BITMAPINFOHEADER`
- 8bit indexed BMP
- 256 色パレット
- パレット内容は RGB332 配列
- 各ピクセル値は RGB332 色値として扱われる

BMP 内のパレットは、PC 上の画像ビューア互換性のために含まれています。  
Family mruby 側ではパレット参照は行わず、ピクセル値を直接 RGB332 色値として扱います。

### RGB332 の色構成

| 要素 | bit数 |
|---|---|
| Red | 3bit |
| Green | 3bit |
| Blue | 2bit |

合計 8bit / 256 色です。

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
icon = "/usr/share/icon/myapp.icon"
```
### 既定アイコン

`.toml` で `icon` を省略すると、本体ファイルの拡張子に応じた既定アイコンが使われます:

| 拡張子 | 既定アイコン |
|---|---|
| `.rb` | `/usr/share/icon/ruby.icon` |
| `.lua` | `/usr/share/icon/lua.icon` |
| `.bas` | `/usr/share/icon/basic.icon` |

## 関連

- [BMP332 API](../api/utilities.md#bmp332)
- [Sprite](../api/sprite.md)
- スプライトエディタ: `/app/tool/sprite_editor.app.rb`
