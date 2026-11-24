# FmrbUI

部品の入れ物

## クラスメソッド

### FmrbUI.new

```ruby
new(FmrbApp app) -> FmrbUI
```

部品箱を作る

app には自分自身 (FmrbApp) を渡します。描画先と user area の位置を
そこから読みます。

`bg:` は**部品が自分の中を塗る色**です (Label の箱、Stepper の値の欄、
Scrollbar の溝)。既定は Window の背景色で、暗い色で塗ったアプリはその色を
渡します。省いたときは、アプリをテーマの違う端末へ移すと、着いた側の
Window の背景色に変わります (渡した色はそのまま)。

`bg_painter:` は**部品を消したあとの地を描く相手**です。渡さなければ
跡は `bg:` の色で塗られます (地が一色ならこれで正しい)。地が絵の場合
(壁紙・枠線・角の丸み) は、`paint_bg_rect(gfx, x, y, w, h)` を持つ
オブジェクト (ふつうは self) を渡すと、その矩形を自分で描けます。
実装は**描くだけ**。present しない、確保しない、文字サイズや
フォントを変えたら戻す。名前は固定です。

```ruby
@ui = FmrbUI.new(self)                    # Window の背景色
@ui = FmrbUI.new(self, bg: COLOR_BG)      # 自前の背景色
@ui = FmrbUI.new(self, bg_painter: self)  # 地は自分で描く

def paint_bg_rect(gfx, x, y, w, h)
  gfx.fill_rect(x, y, w, h, 0x01)
end
```

## インスタンスメソッド

### FmrbUI#label

```ruby
label(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?align: Symbol, ?text_size: Integer) -> FmrbUI::Label
```

文字を置く

align: で寄せ方を選べます (:left / :center / :right、既定は :left)。
text_size: でこの部品だけ文字を大きくできます (1-4)。見出しに使います。
```ruby
@ui.label(:l_size, 4, 148, 60, 10,
          "大きさ")
```

### FmrbUI#button

```ruby
button(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?text_size: Integer, ?accent: Integer) -> FmrbUI::Button
```

押しボタンを置く

押している間だけ反転し、離したときに handle が id を返します。
部品の外で離したときは何も起きません。

`accent:` に色 (RGB332) を渡すと、テーマのボタン色の代わりにその色で
塗ります。**色そのものが意味を持つ数少ない場合だけ**に使います
(確認ダイアログの Yes、再生/停止など)。Toggle では入のときの色です。
```ruby
@ui.button(:start, 4, 20, 60, 16,
           "Start")
```

### FmrbUI#toggle

```ruby
toggle(Symbol id, Integer x, Integer y, Integer w, Integer h, String text, ?group: Symbol, ?on: bool, ?on_text: String, ?text_size: Integer, ?accent: Integer) -> FmrbUI::Toggle
```

入切の切替を置く

group: に同じ名前を付けた切替どうしは、一つだけが入になります
(ラジオボタン)。on: true で最初から入、on_text: を渡すと入のときの
文字を変えられます。

```ruby
@ui.toggle(:maru, 0, 0, 50, 16, "円", group: :motif, on: true)
@ui.toggle(:hishi, 58, 0, 50, 16, "菱", group: :motif)
@ui.toggle(:invert, 0, 20, 108, 12, "反転 切", on_text: "反転 入")
```

### FmrbUI#stepper

```ruby
stepper(Symbol id, Integer x, Integer y, Integer w, Integer h, Integer value, Integer min, Integer max, ?Integer step, ?text_size: Integer) -> FmrbUI::Stepper
```

数を増減する部品を置く

「< 値 >」の形で、左右どちらを押しても handle が id を返します。
min / max で止まり、端で押したときは id を返しません。
最後に step (増減の幅、既定は 1) を渡せます。

```ruby
@size = @ui.stepper(:size, 0, 0, 108, 14, 70, 30, 100, 10)
@size.suffix = "%"   # 表示を "70%" にする
```

### FmrbUI#enum

```ruby
enum(Symbol id, Integer x, Integer y, Integer w, Integer h, Array[String] options) -> FmrbUI::Enum
```

選択肢を左右で選ぶ部品を置く

「< 選択肢 >」の形で、options の中身を左右で送ります。value は選ばれた
添字、option_text はその文字列です。端では止まり、巡回しません。
文字を作り直さないので Stepper より軽い部品です。

```ruby
THEMES = ["light", "dark", "classic"]
@ui.enum(:theme, 0, 0, 90, 14, THEMES, index: 1)
# ...
when :theme then apply_theme(@ui.option_text(:theme))
```

### FmrbUI#option_text

```ruby
option_text(Symbol id) -> String?
```

選ばれている文字

Enum が今見せている文字列です。添字は value で読みます。
```ruby
name = @ui.option_text(:mode)
```

### FmrbUI#text_field

```ruby
text_field(Symbol id, Integer x, Integer y, Integer w, Integer h, ?String text, ?max: Integer, ?text_size: Integer) -> FmrbUI::TextField
```

1 行の文字入力欄を置く

クリックで焦点が移り、焦点のある欄にキーが入ります。Enter で handle が
id を返し (確定)、Esc で焦点が外れます。文字数は max まで。
カーソルは点滅しません (点滅は毎フレーム描くことになるため)。
矢印キーによる欄内の移動はありません。追加と後退だけです。

```ruby
@ui.text_field(:name, 40, 100, 120, 10, "song", max: 24)
# ...
when :name then save_as(@ui.field_text(:name))
```

### FmrbUI#field_text

```ruby
field_text(Symbol id) -> String?
```

打たれている文字

```ruby
name = @ui.field_text(:name)
```

### FmrbUI#set_field_text

```ruby
set_field_text(Symbol id, String text) -> void
```

文字を入れ直す

```ruby
@ui.set_field_text(:name, "untitled")
```

### FmrbUI#focus

```ruby
focus(Symbol id) -> void
```

焦点を当てる

nil を渡すと焦点を外します。文字入力欄以外を渡した場合も外れます。
```ruby
@ui.focus(:name)
@ui.focus(nil)
```

### FmrbUI#focused

```ruby
focused() -> Symbol?
```

焦点のある部品の名前

```ruby
return if @ui.focused == :name
```

### FmrbUI#handle

```ruby
handle(Hash[Symbol, untyped] ev) -> Symbol?
```

イベントを渡す

操作が決まった部品の id を返します。決まっていなければ nil です。
押し下げでは押した見た目にするだけで nil を返し、同じ部品の上で
離したときに id を返します。mouse_move は何もせず nil です。
```ruby
case @ui.handle(ev)
when :start then start_game
end
```

### FmrbUI#flush

```ruby
flush() -> bool
```

変わった部品だけ描く

描くものがあれば最後に present を 1 回呼んで true、何も変わって
いなければ何もせず false を返します。自分の絵を描いたあとに呼べば
present は 1 回で済みます。
```ruby
draw_picture
@gfx.present unless @ui.flush
```

### FmrbUI#invalidate_all

```ruby
invalidate_all() -> void
```

全部を描き直しの印にする

clear_user_area や大きさ変更のあとに呼びます。
```ruby
clear_user_area
@ui.invalidate_all
@ui.flush
```

### FmrbUI#find

```ruby
find(Symbol id) -> FmrbUI::Widget?
```

id から部品を探す

見つからなければ nil。
```ruby
w = @ui.find(:ok)
w.place(x, y, 60, 20) if w
```

### FmrbUI#move

```ruby
move(Symbol id, Integer x, Integer y, Integer w, Integer h) -> void
```

部品を置き直す

座標は作ったときと同じく user area の左上が原点です。
```ruby
@ui.move(:ok, 4, 60, 50, 16)
```

### FmrbUI#on?

```ruby
on?(Symbol id) -> bool
```

切替が入かどうか

```ruby
save_backup if @ui.on?(:backup)
```

### FmrbUI#set_on

```ruby
set_on(Symbol id, bool on) -> void
```

切替を外から入切する

group を付けた切替なら、入にしたときに同じ group の他は切になります。
```ruby
@ui.set_on(:on, true)
```

### FmrbUI#set_text

```ruby
set_text(Symbol id, String text) -> void
```

部品の文字を変える

同じ文字なら何もしません。変わったときだけ幅を測り直して描き直します。
```ruby
@ui.set_text(:near, "Back")
```

### FmrbUI#set_value

```ruby
set_value(Symbol id, Integer value) -> bool
```

数を外から入れる

min / max で止まります。値が変わったときだけ true を返します。
```ruby
@ui.set_value(:sb, 3)
```

### FmrbUI#value

```ruby
value(Symbol id) -> Integer
```

今の数を読む

```ruby
n = @ui.value(:speed)
```

### FmrbUI#set_enabled

```ruby
set_enabled(Symbol id, bool flag) -> void
```

部品を使える/使えないにする

使えない部品は押しても反応せず、文字が薄く出ます。
```ruby
@ui.set_enabled(:export, false)
```

### FmrbUI#set_visible

```ruby
set_visible(Symbol id, bool flag) -> void
```

部品を出す/隠す

隠した部品のあった場所は背景色で塗り直されます。
```ruby
@ui.set_visible(:inst, false)
```

### FmrbUI#widgets

```ruby
widgets() -> Array[FmrbUI::Widget]
```

置いてある部品の一覧

```ruby
@ui.widgets.length
```

---

*このページは Family mruby の API の型定義 (`sig/`) から自動で作っています (fmruby-core api-site 45b8559c).*
