# FmrbUI

部品の入れ物

使い方は [UI 部品](../ui.md) のページにあります。

## クラスメソッド

### FmrbUI.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbApp/">FmrbApp</a> app,
  ?bg: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?bg_painter: untyped
) -&gt; FmrbUI</code></pre>

部品箱を作る

app には自分自身 (FmrbApp) を渡します。描画先と user area の位置をそこから読みます。

`bg:` は**部品が自分の中を塗る色**です (Label の箱、Stepper の値の欄、
Scrollbar の溝)。既定は Window の背景色で、暗い色で塗ったアプリはその色を渡します。省いたときは、アプリをテーマの違う端末へ移すと、着いた側の
Window の背景色に変わります (渡した色はそのまま)。

`bg_painter:` は**部品を消したあとの地を描く相手**です。渡さなければ跡は `bg:` の色で塗られます (地が一色ならこれで正しい)。地が絵の場合
(壁紙・枠線・角の丸み) は、`paint_bg_rect(gfx, x, y, w, h)` を持つオブジェクト (ふつうは self) を渡すと、その矩形を自分で描けます。実装は**描くだけ**。present しない、確保しない、文字サイズやフォントを変えたら戻す。名前は固定です。

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

<pre class="fmrb-sig"><code>label(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?align: <a href="../Symbol/">Symbol</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Label/">FmrbUI::Label</a></code></pre>

文字を置く

align: で寄せ方を選べます (:left / :center / :right、既定は :left)。
text_size: でこの部品だけ文字を大きくできます (1-4)。見出しに使います。
```ruby
@ui.label(:l_size, 4, 148, 60, 10,
          "大きさ")
```

### FmrbUI#button

<pre class="fmrb-sig"><code>button(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?accent: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Button/">FmrbUI::Button</a></code></pre>

押しボタンを置く

押している間だけ反転し、離したときに handle が id を返します。部品の外で離したときは何も起きません。

`accent:` に色 (RGB332) を渡すと、テーマのボタン色の代わりにその色で塗ります。**色そのものが意味を持つ数少ない場合だけ**に使います
(確認ダイアログの Yes、再生/停止など)。Toggle では入のときの色です。
```ruby
@ui.button(:start, 4, 20, 60, 16,
           "Start")
```

### FmrbUI#toggle

<pre class="fmrb-sig"><code>toggle(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> text,
  ?group: <a href="../Symbol/">Symbol</a>,
  ?on: bool,
  ?on_text: <a href="../String/">String</a>,
  ?text_size: <a href="../Integer/">Integer</a>,
  ?accent: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Toggle/">FmrbUI::Toggle</a></code></pre>

入切の切替を置く

group: に同じ名前を付けた切替どうしは、一つだけが入になります
(ラジオボタン)。on: true で最初から入、on_text: を渡すと入のときの文字を変えられます。

```ruby
@ui.toggle(:maru, 0, 0, 50, 16, "円", group: :motif, on: true)
@ui.toggle(:hishi, 58, 0, 50, 16, "菱", group: :motif)
@ui.toggle(:invert, 0, 20, 108, 12, "反転 切", on_text: "反転 入")
```

### FmrbUI#stepper

<pre class="fmrb-sig"><code>stepper(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> value,
  <a href="../Integer/">Integer</a> min,
  <a href="../Integer/">Integer</a> max,
  ?<a href="../Integer/">Integer</a> step,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Stepper/">FmrbUI::Stepper</a></code></pre>

数を増減する部品を置く

「< 値 >」の形で、左右どちらを押しても handle が id を返します。
min / max で止まり、端で押したときは id を返しません。最後に step (増減の幅、既定は 1) を渡せます。

```ruby
@size = @ui.stepper(:size, 0, 0, 108, 14, 70, 30, 100, 10)
@size.suffix = "%"   # 表示を "70%" にする
```

### FmrbUI#enum

<pre class="fmrb-sig"><code>enum(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Array/">Array</a>[<a href="../String/">String</a>] options,
  ?index: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__Enum/">FmrbUI::Enum</a></code></pre>

選択肢を左右で選ぶ部品を置く

「< 選択肢 >」の形で、options の中身を左右で送ります。value は選ばれた添字、option_text はその文字列です。端では止まり、巡回しません。文字を作り直さないので Stepper より軽い部品です。
`index:` (省略すると 0) は最初に選ばれている添字、`text_size:` はこの部品だけの文字の大きさです。options は読むだけで書き換えません。

```ruby
THEMES = ["light", "dark", "classic"]
@ui.enum(:theme, 0, 0, 90, 14, THEMES, index: 1)
# ...
when :theme then apply_theme(@ui.option_text(:theme))
```

### FmrbUI#scrollbar

<pre class="fmrb-sig"><code>scrollbar(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> total,
  <a href="../Integer/">Integer</a> visible,
  ?<a href="../Integer/">Integer</a> scroll
) -&gt; <a href="../FmrbUI__Scrollbar/">FmrbUI::Scrollbar</a></code></pre>

縦のスクロールバーを置く

x, y, w, h は**バーそのもの**の矩形で、動かす一覧のものではありません
(幅は 10 が標準)。total (全部の数)・visible (見える数)・scroll (今の位置、省略すると 0) の 3 つだけでつまみの大きさと位置が決まります。
**位置を持つのはアプリ**です。キーなどで動かしたら `set_value`、件数が変わったら `set_range` で入れ、バーを押されたら `value` で読み戻します。ホイールには応えません (`wheel_rows` で自分で受ける)。

**押した瞬間に** handle が id を返し (離したときではない)、押し続けても返るのは最初の 1 回だけです。1 回で 1 つ動き、端で押したときは返りません。押している間の向きは `direction` で読み、繰り返しはアプリがします。全部が見えている (total が visible 以下の) 間は何も描かず、
**クリックも後ろの一覧へ通ります**。作るのは on_create が前提です (作る呼び出しは確保が起きる。大きさが変わるアプリは on_resize で作り直す)。
```ruby
@ui.scrollbar(:sb, w - 10, y, 10, h,
              0, rows, 0)
# ...
@ui.set_range(:sb, @files.size, rows)
@ui.set_value(:sb, @scroll)
```

### FmrbUI#option_text

<pre class="fmrb-sig"><code>option_text(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

選ばれている文字

Enum が今見せている文字列です。添字は value で読みます。
```ruby
name = @ui.option_text(:mode)
```

### FmrbUI#text_field

<pre class="fmrb-sig"><code>text_field(
  <a href="../Symbol/">Symbol</a> id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  ?<a href="../String/">String</a> text,
  ?max: <a href="../Integer/">Integer</a>,
  ?text_size: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbUI__TextField/">FmrbUI::TextField</a></code></pre>

1 行の文字入力欄を置く

クリックで焦点が移り、焦点のある欄にキーが入ります。Enter で handle が
id を返し (確定)、Esc で焦点が外れます。文字数は max まで。カーソルは点滅しません (点滅は毎フレーム描くことになるため)。矢印キーによる欄内の移動はありません。追加と後退だけです。

```ruby
@ui.text_field(:name, 40, 100, 120, 10, "song", max: 24)
# ...
when :name then save_as(@ui.field_text(:name))
```

### FmrbUI#field_text

<pre class="fmrb-sig"><code>field_text(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

打たれている文字

```ruby
name = @ui.field_text(:name)
```

### FmrbUI#set_field_text

<pre class="fmrb-sig"><code>set_field_text(<a href="../Symbol/">Symbol</a> id, <a href="../String/">String</a> text) -&gt; void</code></pre>

文字を入れ直す

```ruby
@ui.set_field_text(:name, "untitled")
```

### FmrbUI#focus

<pre class="fmrb-sig"><code>focus(<a href="../Symbol/">Symbol</a> id) -&gt; void</code></pre>

焦点を当てる

nil を渡すと焦点を外します。文字入力欄以外を渡した場合も外れます。
```ruby
@ui.focus(:name)
@ui.focus(nil)
```

### FmrbUI#focused

<pre class="fmrb-sig"><code>focused() -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

焦点のある部品の名前

```ruby
return if @ui.focused == :name
```

### FmrbUI#handle

<pre class="fmrb-sig"><code>handle(<a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped] ev) -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

イベントを渡す

操作が決まった部品の id を返します。決まっていなければ nil です。押し下げでは押した見た目にするだけで nil を返し、同じ部品の上で離したときに id を返します。mouse_move は何もせず nil です。
```ruby
case @ui.handle(ev)
when :start then start_game
end
```

### FmrbUI#flush

<pre class="fmrb-sig"><code>flush() -&gt; bool</code></pre>

変わった部品だけ描く

描くものがあれば最後に present を 1 回呼んで true、何も変わっていなければ何もせず false を返します。自分の絵を描いたあとに呼べば
present は 1 回で済みます。
```ruby
draw_picture
@gfx.present unless @ui.flush
```

### FmrbUI#invalidate_all

<pre class="fmrb-sig"><code>invalidate_all() -&gt; void</code></pre>

全部を描き直しの印にする

clear_user_area や大きさ変更のあとに呼びます。
```ruby
clear_user_area
@ui.invalidate_all
@ui.flush
```

### FmrbUI#find

<pre class="fmrb-sig"><code>find(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../FmrbUI__Widget/">FmrbUI::Widget</a>?</code></pre>

id から部品を探す

見つからなければ nil。
```ruby
w = @ui.find(:ok)
w.place(x, y, 60, 20) if w
```

### FmrbUI#move

<pre class="fmrb-sig"><code>move(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

部品を置き直す

座標は作ったときと同じく user area の左上が原点です。
```ruby
@ui.move(:ok, 4, 60, 50, 16)
```

### FmrbUI#on?

<pre class="fmrb-sig"><code>on?(<a href="../Symbol/">Symbol</a> id) -&gt; bool</code></pre>

切替が入かどうか

```ruby
save_backup if @ui.on?(:backup)
```

### FmrbUI#set_on

<pre class="fmrb-sig"><code>set_on(<a href="../Symbol/">Symbol</a> id, bool on) -&gt; void</code></pre>

切替を外から入切する

group を付けた切替なら、入にしたときに同じ group の他は切になります。
```ruby
@ui.set_on(:on, true)
```

### FmrbUI#set_text

<pre class="fmrb-sig"><code>set_text(<a href="../Symbol/">Symbol</a> id, <a href="../String/">String</a> text) -&gt; void</code></pre>

部品の文字を変える

同じ文字なら何もしません。変わったときだけ幅を測り直して描き直します。
```ruby
@ui.set_text(:near, "Back")
```

### FmrbUI#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> value) -&gt; bool</code></pre>

数を外から入れる

min / max で止まります。値が変わったときだけ true を返します。
```ruby
@ui.set_value(:sb, 3)
```

### FmrbUI#value

<pre class="fmrb-sig"><code>value(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

今の数を読む

```ruby
n = @ui.value(:speed)
```

### FmrbUI#set_enabled

<pre class="fmrb-sig"><code>set_enabled(<a href="../Symbol/">Symbol</a> id, bool flag) -&gt; void</code></pre>

部品を使える/使えないにする

使えない部品は押しても反応せず、文字が薄く出ます。
```ruby
@ui.set_enabled(:export, false)
```

### FmrbUI#set_visible

<pre class="fmrb-sig"><code>set_visible(<a href="../Symbol/">Symbol</a> id, bool flag) -&gt; void</code></pre>

部品を出す/隠す

隠した部品のあった場所は背景色で塗り直されます。
```ruby
@ui.set_visible(:inst, false)
```

### FmrbUI#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Symbol/">Symbol</a> id, <a href="../Integer/">Integer</a> min, <a href="../Integer/">Integer</a> max) -&gt; void</code></pre>

範囲を入れ直す

**部品によって 2 つの数の意味が違います**。Stepper (と Enum) は
`(min, max)`、Scrollbar は `(total, visible)`。値は新しい範囲の中へ引き戻されます。同じ範囲なら何もせず、id が無いときも何も起きません
(常に nil)。ほかの部品では何もしません。
```ruby
@ui.set_range(:track, 1, total)    # Stepper
@ui.set_range(:sb, @files.size, 8) # Scrollbar
```

### FmrbUI#direction

<pre class="fmrb-sig"><code>direction(<a href="../Symbol/">Symbol</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

つまみを押している向き

上へ押している間は -1、下へは 1、押していなければ 0 (id が無いときも 0)。
handle が id を返したあとに読み、押している間の繰り返しに使います。
```ruby
if @ui.handle(ev) == :sb
  d = @ui.direction(:sb)
  @scroll_hold = d
end
```

### FmrbUI#bg

<pre class="fmrb-sig"><code>bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

部品の地の色

```ruby
c = @ui.bg
```

### FmrbUI#bg=

<pre class="fmrb-sig"><code>bg=(<a href="../Integer/">Integer</a> c) -&gt; void</code></pre>

部品の地の色を変える

**あとから作る部品と、隠した部品の跡を塗る色**が変わります。
**すでにある部品の中の色は変わりません**。部品は作るときに色を写して持つので、変えるなら部品の `bg=` です。渡した色は自前の色として扱われ、アプリを別の端末へ移してもテーマの色には戻りません。描き直しは
`invalidate_all` のあとの flush で。
```ruby
@ui.bg = @bg_col
@ui.invalidate_all
```

### FmrbUI#widgets

<pre class="fmrb-sig"><code>widgets() -&gt; <a href="../Array/">Array</a>[<a href="../FmrbUI__Widget/">FmrbUI::Widget</a>]</code></pre>

置いてある部品の一覧

```ruby
@ui.widgets.length
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
