# UI 部品 (`FmrbUI`)

自分で窓を描くアプリのための、小さな部品の集まりです。以前はアプリごとにボタンの表と
当たり判定と押した見た目を書いていました。その 1 つ分をここに置いてあります。

```ruby
def on_create
  @ui = FmrbUI.new(self)
  @ui.label(:title, 0, 0, 108, 10, "紋様")
  @ui.toggle(:maru, 0, 12, 50, 16, "円", group: :motif, on: true)
  @ui.toggle(:hishi, 58, 12, 50, 16, "菱", group: :motif)
  @ui.button(:save, 0, 34, 108, 14, "保存")
  @ui.flush
end

def on_event(ev)
  super
  case @ui.handle(ev)
  when :maru, :hishi then redraw
  when :save then save
  end
  @ui.flush
end
```

## 土台にある 2 つの決まり

平常時は何も確保しません。部品は `on_create` で作り、イベントと再描画の経路では確保を
まったく行いません。

毎フレームは描きません。部品ごとに「変わった」印を持っていて、`flush` はその部品だけを
描き、`present` を 1 回だけ呼びます。何も変わっていなければ描きません。

## 部品箱

`FmrbUI.new(app, bg: …, text_size: 1, bg_painter: nil)`

`app` には自分自身を渡します。描画先と user area の位置をそこから読むので、部品の座標は
user area からの相対になります。

| 引数 | |
|---|---|
| `bg:` | 部品が自分の中を塗る色。Label の箱、Stepper の値の欄、Scrollbar の溝など。既定は窓の背景色 |
| `text_size:` | ここから作る部品の既定の文字の大きさ。部品ごとに `text_size:` で上書きできます |
| `bg_painter:` | 部品を消したあとの地を描く相手 |

渡さなければ、隠した部品の跡は `bg:` の色で塗られます。地が一色ならそれで正しい動きです。
地が絵の場合 (壁紙・枠線・角の丸み) は、`paint_bg_rect(gfx, x, y, w, h)` を持つ
オブジェクト (ふつうは `self`) を渡してください。

```ruby
@ui = FmrbUI.new(self, bg_painter: self)

def paint_bg_rect(gfx, x, y, w, h)
  gfx.fill_rect(x, y, w, h, 0x01)
end
```

この実装は描くだけです。`present` を呼ばず、確保もせず、文字の大きさやフォントを変えたら
戻します。名前は固定です。

## 部品

| 作り方 | |
|---|---|
| `label(id, x, y, w, h, text, align: :left, text_size: nil)` | 文字。`align:` は `:left` / `:center` / `:right` |
| `button(id, x, y, w, h, text, accent: nil)` | 押しボタン。押している間は反転し、その上で離したときに `handle` が id を返します |
| `toggle(id, x, y, w, h, text, group: nil, on: false, on_text: nil)` | 入切。同じ `group:` を付けたものは 1 つだけが入になります |
| `stepper(id, x, y, w, h, value, min, max, step = 1)` | 「< 値 >」の形。`min` / `max` で止まります |
| `enum(id, x, y, w, h, options, index: 0)` | 「< 選択肢 >」の形。動かしても文字を作り直さないので Stepper より軽い部品です |
| `scrollbar(id, x, y, w, h, total, visible, scroll = 0)` | スクロールバー |
| `text_field(id, x, y, w, h, text = "", max: 32)` | 1 行の文字入力欄 |

`accent:` を渡すと、テーマのボタン色ではなくその色 (RGB332) で塗ります。色そのものが意味を
持つ数少ない場合だけに使ってください (確認ダイアログの Yes、再生の停止など)。Toggle では
入のときの色になります。

Stepper には作った直後に単位を渡せます。`@size.suffix = "%"` とすると `70%` と出ます。

文字入力欄はクリックで焦点が移り、焦点のある欄にキーが入ります。`Enter` で `handle` が
id を返し、`Esc` で焦点が外れます。カーソルは点滅しません (点滅させると毎フレーム描くことに
なるためです)。矢印キーによる欄内の移動もありません。末尾への追加と後退だけです。

## 動かす

| メソッド | |
|---|---|
| `handle(ev)` | イベントを 1 つ渡します。操作が決まった部品の id を返し、決まっていなければ `nil` です。押し下げでは見た目を変えるだけで、同じ部品の上で離したときに id が返ります |
| `flush` | 変わった部品だけを描きます。描いたら `true` (`present` は 1 回)、何も変わっていなければ `false` |

自分の絵を描いたあとに `flush` を呼べば、`present` は 1 回で済みます。

## アプリ側から部品を変える

| メソッド | |
|---|---|
| `set_text(id, text)` | 文字を変える |
| `set_on(id, on)` / `on?(id)` | 切替の状態 |
| `set_value(id, value)` / `value(id)` | Stepper や Enum の値 |
| `set_range(id, min, max)` | Stepper の上限・下限 |
| `option_text(id)` | Enum で選ばれている文字列 |
| `field_text(id)` / `set_field_text(id, text)` | 入力欄の中身 |
| `set_enabled(id, flag)` | 使える/使えないにする |
| `set_visible(id, flag)` | 出す/隠す。画面から消したい `flush` の前に隠します |
| `move(id, x, y, w, h)` | 置き直す |
| `focus(id)` | 焦点を当てる |
| `set_origin(x0, y0)` | 大きさが変わったあと、部品を置く原点をずらす |
| `invalidate_all` | 全部を描き直しの印にする |

## 書く人が知っておくこと

1. 毎フレーム描かない。`on_update` からは何も描かれません
2. ブロックは使わない。`handle` が返す id で分岐します (部品はコールバックを持ちません)
3. 座標は user area からの相対です。間違えても黙ってはいません。窓の外に置いた部品は、
   作った時点で知らせます
4. 画面から消したい `flush` の前に隠します
5. `bg:` は部品が自分の中を塗る色であって、後ろにあるものの色ではありません
6. `bg_painter` を渡したときだけ: `paint_bg_rect` はその矩形を描くだけです

user area を消すことはこの一覧に入っていません。
[`clear_user_area`](fmrb_app.md#ウィンドウ操作) が窓枠の描き直しと部品への印付けを
やってくれます。

## 関連

- [FmrbApp](fmrb_app.md) — 部品箱を付ける相手
- [配色](../file_formats/colors.md) — 部品の色の出どころ
- [描画](fmrb_gfx.md)
