# FmrbGfx

絵を描く画面。図形・文字・画像・スプライト

使い方は [描画](../fmrb_gfx.md) のページにあります。

アプリは自分で作らない。`FmrbApp` が用意する `gfx` (`@gfx`) を使う。原点 (0, 0) はアプリが描いてよい区画の左上で、色は RGB332 の数 (`FmrbGfx::RED` など)。描くメソッドは自分自身を返すので続けて書ける。**描いただけでは出ない**。フレームの終わりに `present` を 1 回呼ぶ。

最初に読むとよいメソッド: `clear`、`fill_rect`、`draw_text`、`draw_image`、
`present`。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`BLACK`</span> | [`Integer`](Integer.md) | 黒 (RGB332) |
| <span class="fmrb-name">`WHITE`</span> | [`Integer`](Integer.md) | 白 (RGB332) |
| <span class="fmrb-name">`RED`</span> | [`Integer`](Integer.md) | 赤 (RGB332) |
| <span class="fmrb-name">`GREEN`</span> | [`Integer`](Integer.md) | 緑 (RGB332) |
| <span class="fmrb-name">`BLUE`</span> | [`Integer`](Integer.md) | 青 (RGB332) |
| <span class="fmrb-name">`YELLOW`</span> | [`Integer`](Integer.md) | 黄 (RGB332) |
| <span class="fmrb-name">`CYAN`</span> | [`Integer`](Integer.md) | 水色 (RGB332) |
| <span class="fmrb-name">`MAGENTA`</span> | [`Integer`](Integer.md) | 紫 (RGB332) |
| <span class="fmrb-name">`GRAY`</span> | [`Integer`](Integer.md) | 灰色 (RGB332) |
| <span class="fmrb-name">`COLOR_BLACK`</span> | [`Integer`](Integer.md) | 黒 (RGB332) |
| <span class="fmrb-name">`COLOR_WHITE`</span> | [`Integer`](Integer.md) | 白 (RGB332) |
| <span class="fmrb-name">`COLOR_RED`</span> | [`Integer`](Integer.md) | 赤 (RGB332) |
| <span class="fmrb-name">`COLOR_GREEN`</span> | [`Integer`](Integer.md) | 緑 (RGB332) |
| <span class="fmrb-name">`COLOR_BLUE`</span> | [`Integer`](Integer.md) | 青 (RGB332) |
| <span class="fmrb-name">`COLOR_YELLOW`</span> | [`Integer`](Integer.md) | 黄 (RGB332) |
| <span class="fmrb-name">`COLOR_CYAN`</span> | [`Integer`](Integer.md) | 水色 (RGB332) |
| <span class="fmrb-name">`COLOR_MAGENTA`</span> | [`Integer`](Integer.md) | 紫 (RGB332) |
| <span class="fmrb-name">`COLOR_GRAY`</span> | [`Integer`](Integer.md) | 灰色 (RGB332) |
| <span class="fmrb-name">`BLEND_ADD`</span> | [`Integer`](Integer.md) | 色を加算で混ぜる (blend_rect 用) |
| <span class="fmrb-name">`BLEND_XOR`</span> | [`Integer`](Integer.md) | 色を XOR で混ぜる (blend_rect 用) |

## 型

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`image_info`</span> | `{ id: uint16, width: uint16, height: uint16 }` | create_image が返す絵の番号と大きさ |
| <span class="fmrb-name">`file_info`</span> | `{ exists: bool, size: uint32 }` | file_status が返す描画側のファイルのようす |
| <span class="fmrb-name">`composite_region`</span> | `{ src_x: int16, src_y: int16, dst_x: int16, dst_y: int16, w: int16, h: int16, transparent: bool }` | 合成する矩形 1 つ (set_composite_regions_raw) |
| <span class="fmrb-name">`video_info`</span> | `{ width: uint16, height: uint16 }` | video_open_raw が返す動画の大きさ |
| <span class="fmrb-name">`video_status`</span> | `{ state: uint8, shown: uint32, dropped: uint32 }` | 動画の再生のようす |
| <span class="fmrb-name">`picture_info`</span> | `{ width: uint16, height: uint16, format: uint8, bytes: uint32, mtime: uint32 }` | picture_info が返す絵の大きさと形 |

## クラスメソッド

### FmrbGfx.rgb_to_332

<pre class="fmrb-sig"><code>rgb_to_332(<a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> g, <a href="../Integer/">Integer</a> b) -&gt; <a href="../Integer/">Integer</a></code></pre>

赤緑青の三つの数から色を作る

0-255 の 3 つを 1 バイトに落とす。赤と緑は 3 ビット、青は 2 ビットなので、近い色は同じ値になる。細かい階調は出ない。

結果が 0x01 になる組み合わせは避ける。デスクトップは 0x01 を透明の目印に使っているので、Window が透けて見える。
```ruby
FmrbGfx.rgb_to_332(255, 0, 0)  #=> 224
```

### FmrbGfx.video_control

<pre class="fmrb-sig"><code>video_control(:play | :pause | :stop | :rewind action) -&gt; video_status?</code></pre>

動画を流す・止める

流せる動画は 1 つ。video_open で開いた動画を操作して、そのあとのようすを返す (返事が無ければ
nil)。:stop はファイルを閉じ、canvas には最後の絵が残る。包みは FmrbVideo の
play・pause・stop・rewind。
```ruby
FmrbGfx.video_control(:play)
```

### FmrbGfx.video_status

<pre class="fmrb-sig"><code>video_status() -&gt; video_status?</code></pre>

動画の再生のようす

{state:, shown:, dropped:} か、返事が無ければ nil。state は 0 止まり・
1 再生中・2 一時停止・3 終わり。shown と dropped は出した・飛ばしたこま数。包みは FmrbVideo#status。
```ruby
st = FmrbGfx.video_status
```

### FmrbGfx.hsv_to_rgb

<pre class="fmrb-sig"><code>hsv_to_rgb(<a href="../Integer/">Integer</a> h, <a href="../Integer/">Integer</a> s, <a href="../Integer/">Integer</a> v) -&gt; <a href="../Array/">Array</a></code></pre>

色あいと濃さと明るさから色を作る

h は 0-360、s と v は 0-255。戻り値は [r, g, b] の配列で、そのままでは色として使えない。rgb_to_332 に渡す。

```ruby
r, g, b = FmrbGfx.hsv_to_rgb(hue, 255, 255)
color = FmrbGfx.rgb_to_332(r, g, b)
```

## インスタンスメソッド

### FmrbGfx#canvas_id

<pre class="fmrb-sig"><code>canvas_id() -&gt; <a href="../Integer/">Integer</a></code></pre>

画面の番号

```ruby
id = gfx.canvas_id
```

### FmrbGfx#canvas_width

<pre class="fmrb-sig"><code>canvas_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

画面の横幅 (ドット)

canvas 全体の幅。Window のアプリが描いてよいのは、その内側の区画 (area_width、@user_area_width と同じ) で、canvas_width とは違う。全画面のアプリでは一致する。
```ruby
w = @gfx.canvas_width
```

### FmrbGfx#area_width

<pre class="fmrb-sig"><code>area_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

描く区画の横幅 (ドット)

原点 (0, 0) から描いてよい幅。アプリの gfx では @user_area_width と同じ。
```ruby
w = @gfx.area_width
```

### FmrbGfx#area_height

<pre class="fmrb-sig"><code>area_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

描く区画の高さ (ドット)

原点 (0, 0) から描いてよい高さ。`area_width` と対。アプリの gfx では @user_area_height と同じ。
```ruby
@gfx.fill_rect(0, 0, @gfx.area_width,
                @gfx.area_height, 0)
```

### FmrbGfx#origin_x

<pre class="fmrb-sig"><code>origin_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

原点の canvas 上の x

描く座標はすべてここに足されて canvas に届く (本体の側で足す)。枠のある
Window の gfx は 1、window_gfx などは 0。スプライトの画像へ描いている間は描く座標に足さないが、スプライトの座標 (set_sprite_clip・SpriteInstance)
には足す。
```ruby
FmrbApp.set_text_cursor(
  @gfx.origin_x + x,
  @gfx.origin_y + y, 12)
```

### FmrbGfx#origin_y

<pre class="fmrb-sig"><code>origin_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

原点の canvas 上の y

`origin_x` の縦の対。描く座標に足されて canvas に届く y 座標の原点で、枠のある Window の gfx は 1、window_gfx などは 0。
```ruby
FmrbApp.set_text_cursor(
  @gfx.origin_x + x,
  @gfx.origin_y + y, 12)
```

### FmrbGfx#canvas_height

<pre class="fmrb-sig"><code>canvas_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

画面の高さ (ドット)

```ruby
h = gfx.canvas_height
```

### FmrbGfx#current_font

<pre class="fmrb-sig"><code>current_font() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

今えらんでいる字の種類

```ruby
saved = gfx.current_font
gfx.set_font(:ja)
gfx.set_font(saved)
```

### FmrbGfx#current_text_size

<pre class="fmrb-sig"><code>current_text_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の字の大きさの倍率

```ruby
n = gfx.current_text_size
```

### FmrbGfx#clear

<pre class="fmrb-sig"><code>clear(<a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

画面ぜんぶを一色でぬる

canvas 全体を塗る。Window のアプリで呼ぶと、自分で描いたタイトルバーもわくも消える。Window の中だけを消すなら FmrbApp#clear_user_area を使う。あちらはわくを描き直し、付いている FmrbUI の部品にも描き直しの印を付ける。

全画面のアプリなら clear でよく、fill_rect で同じ範囲を塗るより速い。
```ruby
@gfx.clear(FmrbGfx::BLACK)
@gfx.present
```

### FmrbGfx#set_pixel

<pre class="fmrb-sig"><code>set_pixel(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

点を一つ打つ

```ruby
gfx.set_pixel(10, 20,
              FmrbGfx::WHITE)
```

### FmrbGfx#get_pixel

<pre class="fmrb-sig"><code>get_pixel(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Integer/">Integer</a></code></pre>

点の色を読む

描画側への同期的な往復になる。1 画素ずつ読んで画面を走査するような使い方には向かない。

canvas の外を指すと 0 を返す。0 は黒でもあるので、範囲外と黒は戻り値では区別できない。
```ruby
c = @gfx.get_pixel(60, 40)
# canvas の外は 0
```

### FmrbGfx#draw_line

<pre class="fmrb-sig"><code>draw_line(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

まっすぐな線を引く

```ruby
gfx.draw_line(0, 0, 100, 60,
              FmrbGfx::WHITE)
```

### FmrbGfx#draw_thick_line

<pre class="fmrb-sig"><code>draw_thick_line(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> thickness,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

太さのある線を引く

描画側に太い線の命令が無いので、1 画素の線を thickness 本だけずらして重ねている。太さの分だけ命令が増えるので、太い線を毎フレーム引くと効く。
```ruby
@gfx.draw_thick_line(10, 10, 60, 40,
                    2, FmrbGfx::WHITE)
```

### FmrbGfx#draw_rect

<pre class="fmrb-sig"><code>draw_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

四角のふちを描く

(x, y) は左上の角、w は横幅、h は高さです。線だけを描くので、中は下にあるものが見えたままになります。中もぬりたいときは
`fill_rect` を使います。

```ruby
gfx.draw_rect(10, 10, 100, 50,
              FmrbGfx::WHITE)  # わく
gfx.fill_rect(12, 12, 96, 46,
              FmrbGfx::BLUE)   # 中身
gfx.present
```

### FmrbGfx#fill_rect

<pre class="fmrb-sig"><code>fill_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

四角をぬりつぶす

(x, y) は左上の角、w は横幅、h は高さです。中まで色でうめます。画面ぜんぶを消したいときは `clear` のほうが速いです。

動くものを描くときは、**前にいた場所を背景色でぬってから**新しい場所に描くと、跡が残りません。

```ruby
class MyApp < FmrbApp
  def on_update
    # 前の場所を消す
    gfx.fill_rect(@x, 100, 16, 16,
                  FmrbGfx::BLACK)
    @x = @x + 2
    # 新しい場所に描く
    gfx.fill_rect(@x, 100, 16, 16,
                  FmrbGfx::RED)
    gfx.present
  end
end
```

### FmrbGfx#blend_rect

<pre class="fmrb-sig"><code>blend_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> mode
) -&gt; FmrbGfx</code></pre>

下の絵と混ぜて四角をぬる

最後の引数は混ぜ方で、FmrbGfx::BLEND_ADD (加算) か FmrbGfx::BLEND_XOR。透明度ではない。加算は光っている表現に、XOR は下の色を反転させる表現に使う。

```ruby
gfx.fill_rect(0, 0, 64, 64, FmrbGfx::BLUE)
gfx.blend_rect(16, 16, 32, 32,
               FmrbGfx::RED, FmrbGfx::BLEND_ADD)
```

### FmrbGfx#draw_round_rect

<pre class="fmrb-sig"><code>draw_round_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> r,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

角の丸い四角のふちを描く

```ruby
gfx.draw_round_rect(10, 10, 80, 40,
                    6, theme_fg)
```

### FmrbGfx#fill_round_rect

<pre class="fmrb-sig"><code>fill_round_rect(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> r,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

角の丸い四角をぬりつぶす

```ruby
gfx.fill_round_rect(10, 10, 80, 40,
                    6, theme_bg)
```

### FmrbGfx#draw_button

<pre class="fmrb-sig"><code>draw_button(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../String/">String</a> label,
  <a href="../Integer/">Integer</a> fill,
  <a href="../Integer/">Integer</a> fg
) -&gt; FmrbGfx</code></pre>

角の丸いボタンの絵を描く

地を fill で塗り、label を fg で中央に描く (今のフォント)。**絵だけ**で、押せる範囲は持たない。毎回描く画面では FmrbUI::HitAreas#add と
2 行で使う。8 番目に角の半径を渡せる (既定 3)。

```ruby
@gfx.draw_button(x, y, 60, 16, "OK",
  theme_accent, theme_fg_light)
@hits.add(:ok, x, y, 60, 16)
```

### FmrbGfx#draw_circle

<pre class="fmrb-sig"><code>draw_circle(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

円のふちを描く

```ruby
gfx.draw_circle(50, 30, 20,
                FmrbGfx::WHITE)
```

### FmrbGfx#fill_circle

<pre class="fmrb-sig"><code>fill_circle(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> r, <a href="../Integer/">Integer</a> color) -&gt; FmrbGfx</code></pre>

円をぬりつぶす

```ruby
gfx.fill_circle(50, 30, 20,
                FmrbGfx::YELLOW)
```

### FmrbGfx#draw_ellipse

<pre class="fmrb-sig"><code>draw_ellipse(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> rx,
  <a href="../Integer/">Integer</a> ry,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

だ円のふちを描く

```ruby
gfx.draw_ellipse(50, 30, 30, 15,
                 FmrbGfx::WHITE)
```

### FmrbGfx#fill_ellipse

<pre class="fmrb-sig"><code>fill_ellipse(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> rx,
  <a href="../Integer/">Integer</a> ry,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

だ円をぬりつぶす

```ruby
gfx.fill_ellipse(50, 30, 30, 15,
                 FmrbGfx::CYAN)
```

### FmrbGfx#draw_triangle

<pre class="fmrb-sig"><code>draw_triangle(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> x2,
  <a href="../Integer/">Integer</a> y2,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

三角のふちを描く

```ruby
gfx.draw_triangle(50, 10, 20, 50,
                  80, 50,
                  FmrbGfx::WHITE)
```

### FmrbGfx#fill_triangle

<pre class="fmrb-sig"><code>fill_triangle(
  <a href="../Integer/">Integer</a> x0,
  <a href="../Integer/">Integer</a> y0,
  <a href="../Integer/">Integer</a> x1,
  <a href="../Integer/">Integer</a> y1,
  <a href="../Integer/">Integer</a> x2,
  <a href="../Integer/">Integer</a> y2,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

三角をぬりつぶす

```ruby
gfx.fill_triangle(50, 10, 20, 50,
                  80, 50,
                  FmrbGfx::GREEN)
```

### FmrbGfx#draw_arc

<pre class="fmrb-sig"><code>draw_arc(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> r0,
  <a href="../Integer/">Integer</a> r1,
  <a href="../Integer/">Integer</a> angle0,
  <a href="../Integer/">Integer</a> angle1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

円の一部の弧を描く

角度は度の整数。r0 が内側の半径、r1 が外側の半径で、r0 に 0 でない値を入れると輪の一部になる。r0 を 0 にすると扇形の外周になる。
```ruby
@gfx.draw_arc(80, 60, 35, 45, 0, 360,
              FmrbGfx::WHITE)
```

### FmrbGfx#fill_arc

<pre class="fmrb-sig"><code>fill_arc(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> r0,
  <a href="../Integer/">Integer</a> r1,
  <a href="../Integer/">Integer</a> angle0,
  <a href="../Integer/">Integer</a> angle1,
  <a href="../Integer/">Integer</a> color
) -&gt; FmrbGfx</code></pre>

円の一部をぬりつぶす

角度は度の整数。r0 が内側の半径、r1 が外側の半径。r0 を 0 にすると扇形、
0 でない値にすると輪の一部になる。ゲージや円グラフはこの形で描ける。
```ruby
@gfx.fill_arc(80, 60, 0, 50, 0, 120,
             FmrbGfx::BLUE)
```

### FmrbGfx#draw_text

<pre class="fmrb-sig"><code>draw_text(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> color,
  ?<a href="../Integer/">Integer</a>? bg_color,
  ?mixed: bool
) -&gt; FmrbGfx</code></pre>

文字列を描く

(x, y) は文字列の**左上**の位置です。画面の左上が (0, 0) で、右に行くほど x が大きく、下に行くほど y が大きくなります。
color は RGB332 の数です。`FmrbGfx::WHITE` のような決まった色か、
`FmrbGfx.rgb_to_332(255, 0, 0)` で好きな色を指定できます。

描いたものは `present` を呼ぶまで画面に出ません。
5 番目の引数を渡すと、字の背景をその色で塗ります (省くと塗らない)。
`mixed: true` は、選んでいるフォントに関わらず、英数字を 6x8、日本語を 8x8 のフォントで描きます。

```ruby
class MyApp < FmrbApp
  def on_update
    gfx.clear(FmrbGfx::BLACK)
    gfx.draw_text(10, 20, "こんにちは", FmrbGfx::WHITE)
    gfx.present
  end
end
```

### FmrbGfx#draw_text_raw

<pre class="fmrb-sig"><code>draw_text_raw(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color,
  bool mixed
) -&gt; FmrbGfx</code></pre>

draw_text の省略なしの形

引数を省略できない単純な形。毎フレーム何度も描くような、速さが要る所で使う。bg_color が負なら背景は塗らない。mixed が true なら英数を 6x8、それ以外を misaki 8 で描く (draw_text の mixed: true)。包みは draw_text。
```ruby
gfx.draw_text_raw(10, 20, "hi",
  FmrbGfx::WHITE, -1, false)
```

### FmrbGfx#set_font

<pre class="fmrb-sig"><code>set_font(<a href="../Symbol/">Symbol</a> family, ?<a href="../Integer/">Integer</a> size) -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

字の種類と大きさをえらぶ

family は :default (6x8 の英数)、:ja (日本語)、:ja_bold (:ja の太字)。
size は画素の高さで、:ja は 8 と 12 と 16、:ja_bold は 12。持っている字は機種で違う (Retro は 12 まで) ので、無い大きさや太字を頼むと近いものが選ばれる。戻り値は実際に選ばれた [family, size] で、太字が無かったこともこれで分かる (自分で太く描くときの判断に使う)。
```ruby
got = gfx.set_font(:ja, 12)
```

### FmrbGfx#set_font_raw

<pre class="fmrb-sig"><code>set_font_raw(:default | :ja | :ja_bold family, <a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

set_font の省略なしの形

引数を省略できない単純な形。機種が持つ字への置き換えはしないので、無い大きさはエラーになる (:ja は 8・12・16、:ja_bold は 12。:default の
size は使われない)。current_font は変わらない。包みは set_font。
```ruby
gfx.set_font_raw(:ja, 12)
```

### FmrbGfx#set_text_size

<pre class="fmrb-sig"><code>set_text_size(<a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

字の大きさの倍率を決める

選んでいる字を整数倍で拡大する。字が増えるわけではないので、大きくすると角が目立つ。倍率をかけた後の幅は text_width が返す。
```ruby
@gfx.set_text_size(2)
@gfx.draw_text(4, 4, "BIG", 0xFF)
@gfx.set_text_size(1)
```

### FmrbGfx#set_text_size_raw

<pre class="fmrb-sig"><code>set_text_size_raw(<a href="../Integer/">Integer</a> size) -&gt; FmrbGfx</code></pre>

set_text_size の包みのない形

倍率 (1〜4) を描画側へ送るだけで、current_text_size と text_width の測り方は変わらない。包みは set_text_size。
```ruby
gfx.set_text_size_raw(2)
```

### FmrbGfx#text_width

<pre class="fmrb-sig"><code>text_width(<a href="../String/">String</a> text) -&gt; <a href="../Integer/">Integer</a></code></pre>

字を描いたときの横幅を測る

いま set_font で選んでいる字と set_text_size の倍率で測る。字を変えたら測り直す。UTF-8 を走査して画素の幅を返すので、日本語混じりでも文字数ではなく実際の幅が返る。

```ruby
w = gfx.text_width(text)
x = (gfx.area_width - w) / 2
gfx.draw_text(x, 20, text, FmrbGfx::WHITE)
```

### FmrbGfx#font_height

<pre class="fmrb-sig"><code>font_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

一行分の高さを調べる

いま選んでいる字の高さ。行を積むときの間隔に使う。字を変えると変わる。
```ruby
y += @gfx.font_height + 2
```

### FmrbGfx#draw_wallclock

<pre class="fmrb-sig"><code>draw_wallclock(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color
) -&gt; bool</code></pre>

今の時刻を描く

時刻の文字はこの中で組み立てられる。毎秒呼んでもごみが出ない。
bg_color が負なら背景は塗らない。
```ruby
gfx.draw_wallclock(300, 2,
                   theme_fg, theme_bg)
```

### FmrbGfx#draw_free_iram

<pre class="fmrb-sig"><code>draw_free_iram(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> bg_color
) -&gt; bool</code></pre>

空きメモリの量を描く

値の取得も整形もこの中。空きが読めない環境では横棒が出る。
bg_color が負なら背景は塗らない。
```ruby
gfx.draw_free_iram(360, 2,
                   theme_fg, theme_bg)
```

### FmrbGfx#load_image

<pre class="fmrb-sig"><code>load_image(<a href="../String/">String</a> path) -&gt; void</code></pre>

絵のファイルを読み込んで置く

sync_file、create_image、draw_image、present、delete_image をまとめて行う。一枚絵を出すだけならこれで足りる。

置き場所は coord: で、[x, y] か :center。省略すると左上。毎フレーム呼ぶものではない (呼ぶたびに画像を作り直して捨てる)。

```ruby
gfx.load_image("/home/pic.png", coord: :center)
```

### FmrbGfx#create_image

<pre class="fmrb-sig"><code>create_image(<a href="../String/">String</a> path) -&gt; image_info?</code></pre>

絵のファイルから絵を作る

受けるのは PNG。スプライトの素材 (RGB332 の PNG・BMP) はこちらではなく
SpriteImage#load_bmp が読む。BMP を渡しても例外にはならず、画面と同じ大きさの空の画像ができて何も出ない。

描画側は自分のファイルシステムしか読めないので、先に sync_file で送る。戻り値は {id:, width:, height:} か、読めなければ nil。

```ruby
path = "/home/pic.png"
gfx.sync_file(path)
img = gfx.create_image(path)
gfx.draw_image(img[:id], x: 0, y: 0) if img
```

### FmrbGfx#draw_image

<pre class="fmrb-sig"><code>draw_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

作った絵を描く

位置と倍率はキーワードで渡す (x:, y:, scale_x:, scale_y:)。scale_y に
0.0 を渡すと scale_x と同じ倍率になる。

```ruby
gfx.draw_image(id, x: 10, y: 20)
gfx.draw_image(id, x: 10, y: 20,
               scale_x: 2.0)   # 縦横とも 2 倍
```

### FmrbGfx#draw_image_raw

<pre class="fmrb-sig"><code>draw_image_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Float/">Float</a> scale_x,
  <a href="../Float/">Float</a> scale_y
) -&gt; FmrbGfx</code></pre>

draw_image の省略なしの形

引数を省略できない単純な形。scale_y に 0.0 を渡すと scale_x と同じ倍率。包みは draw_image。
```ruby
gfx.draw_image_raw(id, 10, 20,
                   1.0, 0.0)
```

### FmrbGfx#delete_image

<pre class="fmrb-sig"><code>delete_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

作った絵を片づける

画像は描画側の資源で、数に限りがある。使い終わったら消す。アプリが終わるときには系がまとめて片づけるので、終了処理で消し忘れても漏れはしない。
```ruby
@gfx.delete_image(@image[:id])
```

### FmrbGfx#draw_tile

<pre class="fmrb-sig"><code>draw_tile(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h
) -&gt; FmrbGfx</code></pre>

絵の一部を切り取って描く

SpriteImage の一部を canvas に直接押す。SpriteInstance を作らないので、地形のように動かないものを並べるのに向く。置き場所はキーワード
(dst_x:, dst_y:)。

use_transparent: true で作った SpriteImage なら、その透明色は抜ける。タイル 1 枚ずつを並べる高水準の側は TileMap にある。

scale: で大きさを変えて描ける。2〜32 は元の 1 点を scale x scale に
(scale: 2 で 2 倍)、-2〜-32 は 1/|scale| に (scale: -4 で 1/4。升ごとに左上の 1 点を取る)。中身は draw_tile_scaled_raw。

```ruby
sheet.load_bmp("/cache/app/x/tiles.png")
gfx.draw_tile(sheet.id, 0, 0, 16, 16,
              dst_x: 32, dst_y: 16)
gfx.draw_tile(sheet.id, 0, 0, 16, 16,
  dst_x: 0, dst_y: 40, scale: 3)
```

### FmrbGfx#draw_tile_raw

<pre class="fmrb-sig"><code>draw_tile_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> dst_x,
  <a href="../Integer/">Integer</a> dst_y
) -&gt; FmrbGfx</code></pre>

draw_tile の省略なしの形

置き場所をキーワードでなく位置の引数で渡す形。包みは draw_tile。
```ruby
gfx.draw_tile_raw(sheet.id, 0, 0,
                  16, 16, 32, 16)
```

### FmrbGfx#draw_tile_scaled_raw

<pre class="fmrb-sig"><code>draw_tile_scaled_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  <a href="../Integer/">Integer</a> dst_x,
  <a href="../Integer/">Integer</a> dst_y,
  <a href="../Integer/">Integer</a> scale,
  <a href="../Integer/">Integer</a> clip_x,
  <a href="../Integer/">Integer</a> clip_y,
  <a href="../Integer/">Integer</a> clip_w,
  <a href="../Integer/">Integer</a> clip_h
) -&gt; FmrbGfx</code></pre>

draw_tile を拡大・縮小して描く

scale が 1〜32 なら元の 1 点を scale x scale に、-2〜-32 なら 1/|scale|
の大きさに (升ごとに左上の 1 点。0 と -1 は 1)。範囲の外は ERR_ARG。描く先は clip の矩形 (原点から。clip_w か clip_h が 0 なら無し) と
canvas で切る。透明色は draw_tile と同じに抜ける。包みは draw_tile の
scale:。
```ruby
gfx.draw_tile_scaled_raw(id, 0, 0,
  16, 16, 40, 20, 2, 0, 0, 0, 0)
```

### FmrbGfx#picture_info

<pre class="fmrb-sig"><code>picture_info(<a href="../String/">String</a> path) -&gt; picture_info?</code></pre>

絵のファイルの大きさを読む

PNG と 8 ビットの BMP の先頭だけを読み、解かない (BMP332.info と同じ
C)。結果は {width:, height:, format:, bytes:, mtime:}。format は 1 が
PNG、2 が BMP。bytes はファイルの大きさ、mtime は書いた時刻
(時刻を持たないファイルシステムでは 0)。無い・読めなければ nil。ファイルは本体の側のもの (描画側に送る前でよい)。
```ruby
info = gfx.picture_info("/home/a.png")
w = info[:width] if info
```

### FmrbGfx#draw_picture

<pre class="fmrb-sig"><code>draw_picture(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

絵のファイルを描く (無ければ読む)

パス (か put_picture の名前) を渡すだけでよい。初めての絵は描画側のスプライトの絵に読み、この FmrbGfx が picture_limit 枚 (既定 8) まで持つ。超えたら最近使っていないものから離す。ファイルを書き換えると
(大きさか時刻が変わると) 次に描くときに読み直す (見に行くのは 1 秒に
1 回まで)。アプリが終わると全部離れる。

- scale: 1〜32 は元の 1 点を scale x scale に、-2〜-32 は 1/|scale| に
- checker: true で透明の所に市松を敷く (draw_checker)
- clip: [x, y, w, h] でその矩形の中だけ描く

描けなければ false (落ちない)。理由は picture_error。65,536 点を超える絵は断る。65,536 バイトを超えるファイルはアプリの側で読んで
(BMP332.load、読む間は VM プールに載る) 画素を置く。透明は 0x01 の色
(PNG の α・tRNS)。
```ruby
gfx.draw_picture("/home/stamps/a.png",
  10, 20, scale: 2)
gfx.draw_picture(path, 0, 0,
  scale: -2, checker: true)
```

### FmrbGfx#picture_size

<pre class="fmrb-sig"><code>picture_size(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]?</code></pre>

絵の幅と高さ ([w, h])

置き場にあればその大きさ、無ければファイルの先頭だけを読む
(picture_info)。描画側には送らない。絵でなければ nil。
```ruby
w, h = gfx.picture_size("/home/a.png")
```

### FmrbGfx#put_picture

<pre class="fmrb-sig"><code>put_picture(
  <a href="../String/">String</a> name,
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../String/">String</a> pixels
) -&gt; bool</code></pre>

手元の画素を名前で置き場に置く

pixels は幅 x 高さバイト (上の行から、0x01 が透明)。置いた後は
draw_picture(名前, ...) で描く。同じ名前で置き直すと画素を書き直す。ファイルは使わない。場所が無ければ false。
```ruby
gfx.put_picture("mine", 16, 16, px)
gfx.draw_picture("mine", 0, 0,
  scale: 4)
```

### FmrbGfx#release_picture

<pre class="fmrb-sig"><code>release_picture(<a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

置き場の絵を 1 枚離す

```ruby
gfx.release_picture("/home/a.png")
```

### FmrbGfx#release_pictures

<pre class="fmrb-sig"><code>release_pictures() -&gt; FmrbGfx</code></pre>

置き場の絵を全部離す

アプリが終わるときは呼ばなくてよい (絵は canvas と一緒に離れる)。部屋を変えるときなど、もう描かない絵をまとめて離すのに使う。
```ruby
gfx.release_pictures
```

### FmrbGfx#picture_limit=

<pre class="fmrb-sig"><code>picture_limit=(<a href="../Integer/">Integer</a> n) -&gt; <a href="../Integer/">Integer</a></code></pre>

置き場に持つ絵の枚数を決める

既定は 8。減らすと古いものから離す。描画側の絵の数は機械全体で限りがある (sim・Retro は 64 枚・256 KB、P4 は 160 枚)。
```ruby
gfx.picture_limit = 16
```

### FmrbGfx#picture_error

<pre class="fmrb-sig"><code>picture_error() -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

絵が描けなかった理由

:unreadable (無い・絵でない)、:too_big (65,536 点を超える)、
:no_room (描画側に場所が無い)、:not_sent (描画側へ送れない)。うまくいった後は nil。
```ruby
unless gfx.draw_picture(path, 0, 0)
  Log.info(gfx.picture_error.to_s)
end
```

### FmrbGfx#draw_checker

<pre class="fmrb-sig"><code>draw_checker(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; FmrbGfx</code></pre>

透明を表す市松を描く

白と薄い灰色の升 (cell: px、既定 4) を (x, y, w, h) に敷く。clip:
[x, y, w, h] で切れる。描画側に帯を 1 枚作って押すので、命令は高さ / (cell x 2) 回。
```ruby
gfx.draw_checker(0, 0, 64, 64)
gfx.draw_checker(0, 0, 64, 64,
  cell: 2)
```

### FmrbGfx#create_mask

<pre class="fmrb-sig"><code>create_mask(<a href="../Integer/">Integer</a> width, <a href="../Integer/">Integer</a> height, bin data) -&gt; <a href="../Integer/">Integer</a></code></pre>

型ぬきの形を作る

data は 1 画素 1 ビットの列。1 行あたり ceil(width / 8) バイトで、各バイトは上位ビットが左。ビットが 1 のところだけが描かれる。

戻り値は mask_id で、draw_image_masked に渡す。使い終わったら delete_mask。
```ruby
mask = @gfx.create_mask(48, 48, bits)
# bits: 6 バイト × 48 行
```

### FmrbGfx#delete_mask

<pre class="fmrb-sig"><code>delete_mask(<a href="../Integer/">Integer</a> mask_id) -&gt; FmrbGfx</code></pre>

型ぬきの形を片づける

```ruby
gfx.delete_mask(@mask_id)
```

### FmrbGfx#draw_image_masked

<pre class="fmrb-sig"><code>draw_image_masked(<a href="../Integer/">Integer</a> image_id, <a href="../Integer/">Integer</a> mask_id) -&gt; FmrbGfx</code></pre>

型でぬいた形の絵を描く

SpriteImage の絵を、マスクのビットが立っているところだけ canvas に写す。置き場所はキーワード (x:, y:)。絵の (xx, yy) が canvas の (x+xx, y+yy) に来る。
```ruby
@gfx.draw_image_masked(sid, mask,
                       x: 20, y: 30)
```

### FmrbGfx#draw_image_masked_raw

<pre class="fmrb-sig"><code>draw_image_masked_raw(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> mask_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y
) -&gt; FmrbGfx</code></pre>

draw_image_masked の省略なしの形

置き場所をキーワードでなく位置の引数で渡す形。包みは draw_image_masked。
```ruby
gfx.draw_image_masked_raw(img.id,
  @mask_id, 10, 20)
```

### FmrbGfx#present

<pre class="fmrb-sig"><code>present() -&gt; FmrbGfx</code></pre>

描いたものを画面に出す

描くメソッドは命令を積むだけで、画面には出ない。present を呼んだときにまとめて送られ、そこで初めて出る。スプライトの合成も present の時に走るので、
SpriteInstance#move や visible= の後にも要る。

1 フレームの終わりに 1 回呼ぶ。描くたびに呼ぶと、その回数だけ画面全体の転送が起きて遅くなる。

```ruby
gfx.clear(FmrbGfx::BLACK)
gfx.draw_text(10, 10, "hi", FmrbGfx::WHITE)
gfx.present   # ここで画面に出る
```

### FmrbGfx#present_raw

<pre class="fmrb-sig"><code>present_raw(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, bool positioned) -&gt; FmrbGfx</code></pre>

present の省略なしの形

positioned が false なら Window の位置に出し (x, y は使わない)、true なら画面の (x, y) に出す。包みは present (present(x, y) で位置を渡す)。
```ruby
gfx.present_raw(0, 0, false)
```

### FmrbGfx#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; FmrbGfx</code></pre>

この画面を片づける

自分で作った canvas を片づける。アプリの終了時には自動で消えるので、途中で要らなくなったときだけ呼ぶ。
```ruby
g = create_canvas_gfx(width: 64,
                     height: 64)
g.destroy
```

### FmrbGfx#set_viewport

<pre class="fmrb-sig"><code>set_viewport(
  <a href="../Integer/">Integer</a> src_x,
  <a href="../Integer/">Integer</a> src_y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h
) -&gt; FmrbGfx</code></pre>

画面の見せる場所をずらす

canvas より小さい表示範囲を、canvas の上で動かす。canvas は輪として扱われ、元の四角は端で回り込む。表示範囲より少し大きい canvas を用意し、動いた分だけ新しく見えるところにタイルを描き足せば、大きな地図を描き直さずに流せる。

Modern (ESP32-P4) だけの機能で、Retro の描画側はこの命令を無視する。
FmrbConst::CHIP_MODEL == "ESP32-P4" で分ける。
```ruby
@map_gfx.set_viewport(vx % bw, vy % bh,
                      160, 120)
```

### FmrbGfx#clear_viewport

<pre class="fmrb-sig"><code>clear_viewport() -&gt; FmrbGfx</code></pre>

ずらした場所を元に戻す

set_viewport で決めた切り出しをやめ、canvas 全体を合成に戻す。
set_viewport と同じく Modern (ESP32-P4) だけで効く。
```ruby
@map_gfx.set_viewport(8, 0, 160, 120)
@map_gfx.clear_viewport
```

### FmrbGfx#set_composite_regions

<pre class="fmrb-sig"><code>set_composite_regions(<a href="../Array/">Array</a>[<a href="../Hash/">Hash</a>] regions) -&gt; FmrbGfx</code></pre>

重ねて見せる場所を決める

canvas のどの矩形をどう合成するかを指定する。角の丸い Window のように、隅だけ透過が要るときの最適化で、中央は速い経路で送れる。最大 8 個。nil か [] で既定 (canvas 全体) に戻る。

Window のアプリでは .app.toml の rounded_corners から系が設定するので、ふつうは自分で呼ぶ必要はない。
```ruby
@gfx.set_composite_regions([
  { dst_x: 0, dst_y: 0, w: 100,
    h: 20, transparent: false }
])
```

### FmrbGfx#set_composite_regions_raw

<pre class="fmrb-sig"><code>set_composite_regions_raw(<a href="../Array/">Array</a>[composite_region] regions) -&gt; FmrbGfx</code></pre>

set_composite_regions の省略なしの形

矩形ごとに src_x・src_y・dst_x・dst_y・w・h・transparent を全部書く形。空の配列で既定 (canvas 全体) に戻る。包みは set_composite_regions。
```ruby
gfx.set_composite_regions_raw([
  { src_x: 0, src_y: 0, dst_x: 0,
    dst_y: 0, w: 8, h: 8,
    transparent: true }])
```

### FmrbGfx#set_sprite_clip

<pre class="fmrb-sig"><code>set_sprite_clip(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; FmrbGfx</code></pre>

スプライトが出られる範囲を決める

スプライトは canvas に描いた絵の上に重ねて合成されるので、何もしないと Window のわくやタイトルバーの上にもはみ出す。この四角の中だけに出るようにする。x, y, w, h は SpriteInstance#move と同じ座標 (原点から。スプライトの画像へ描いている間も原点を足す)。

Window のアプリは起動時に Window の中身の範囲が入っているので、ふつうは呼ぶ必要はない。点数を出す帯など、さらに狭い範囲に閉じ込めたいときに使う。
```ruby
# 上 10px を点数の帯にして、スプライトはその下だけに出す
@gfx.set_sprite_clip(0, 10,
  @user_area_width,
  @user_area_height - 10)
```

### FmrbGfx#clear_sprite_clip

<pre class="fmrb-sig"><code>clear_sprite_clip() -&gt; FmrbGfx</code></pre>

スプライトの範囲の決まりをなくす

```ruby
gfx.clear_sprite_clip
```

### FmrbGfx#create_sprite_image

<pre class="fmrb-sig"><code>create_sprite_image(
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> height,
  <a href="../Integer/">Integer</a> transparent_color,
  bool use_transparent
) -&gt; <a href="../Integer/">Integer</a></code></pre>

スプライトの絵を作る

描画側に width x height の絵を作り、番号を返す。use_transparent が真なら
transparent_color の画素は抜ける。包みは SpriteImage.new。
```ruby
id = gfx.create_sprite_image(16, 16,
                             0x00, true)
```

### FmrbGfx#delete_sprite_image

<pre class="fmrb-sig"><code>delete_sprite_image(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

スプライトの絵を片づける

包みは SpriteImage#destroy。
```ruby
gfx.delete_sprite_image(id)
```

### FmrbGfx#load_sprite_image

<pre class="fmrb-sig"><code>load_sprite_image(<a href="../Integer/">Integer</a> image_id, <a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

絵 (PNG か BMP) をスプライトの絵に読み込む

描画側のパスを渡す (先に sync_file で送る)。展開は描画側でやる。
PNG の透明な点 (α が 128 未満、tRNS) は透明色 0x01 になる。包みは SpriteImage#load_bmp。
```ruby
gfx.load_sprite_image(id,
  "/cache/app/x/bird.png")
```

### FmrbGfx#write_sprite_image

<pre class="fmrb-sig"><code>write_sprite_image(
  <a href="../Integer/">Integer</a> image_id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  bin pixels
) -&gt; FmrbGfx</code></pre>

画素 (RGB332) をスプライトの絵に書く

pixels は w * h バイト (上の行から)。絵の (x, y) から書き、絵の外は捨てる。1 回 65,536 点まで (超えると ERR_ARG)。描く命令と同じ列で送るので、前に頼んだ draw_tile は書く前の絵で描かれる。包みは SpriteImage#write_pixels。
```ruby
gfx.write_sprite_image(img.id, 0, 0,
  16, 16, pixels)
```

### FmrbGfx#set_sprite_image_target

<pre class="fmrb-sig"><code>set_sprite_image_target(<a href="../Integer/">Integer</a> image_id) -&gt; FmrbGfx</code></pre>

描く先をスプライトの絵にする

この後の描画は、その絵の中の座標で絵に描かれる (原点は足さない)。0 で
canvas に戻す。包みは SpriteImage#set_target・#reset_target・#draw。
```ruby
gfx.set_sprite_image_target(id)
gfx.fill_rect(0, 0, 16, 16, FmrbGfx::RED)
gfx.set_sprite_image_target(0)
```

### FmrbGfx#create_sprite_instance

<pre class="fmrb-sig"><code>create_sprite_instance(
  <a href="../Array/">Array</a>[uint16] image_ids,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> z
) -&gt; <a href="../Integer/">Integer</a></code></pre>

スプライトの絵を画面に置く

置いた絵の番号を返す。image_ids はパラパラ漫画の絵の番号 (1〜8 枚)。座標は原点から (絵に描いている間も)。z が大きいほど手前。包みは SpriteInstance.new。
```ruby
sp = gfx.create_sprite_instance(
  [id1, id2], 40, 80, 0)
```

### FmrbGfx#delete_sprite_instance

<pre class="fmrb-sig"><code>delete_sprite_instance(<a href="../Integer/">Integer</a> instance_id) -&gt; FmrbGfx</code></pre>

置いた絵を片づける

包みは SpriteInstance#destroy。
```ruby
gfx.delete_sprite_instance(sp)
```

### FmrbGfx#move_sprite

<pre class="fmrb-sig"><code>move_sprite(<a href="../Integer/">Integer</a> instance_id, <a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; FmrbGfx</code></pre>

置いた絵を動かす

座標は原点から。合成は次の present で走る。包みは SpriteInstance#move
(枠なしの Window の当たりに印を付けたスプライトは、包みが当たりも動かす)。
```ruby
gfx.move_sprite(sp, 48, 80)
gfx.present
```

### FmrbGfx#set_sprite_visible

<pre class="fmrb-sig"><code>set_sprite_visible(<a href="../Integer/">Integer</a> instance_id, bool visible) -&gt; FmrbGfx</code></pre>

置いた絵を見せるか隠すか

包みは SpriteInstance#visible=。
```ruby
gfx.set_sprite_visible(sp, false)
```

### FmrbGfx#set_sprite_frame

<pre class="fmrb-sig"><code>set_sprite_frame(<a href="../Integer/">Integer</a> instance_id, <a href="../Integer/">Integer</a> frame) -&gt; FmrbGfx</code></pre>

置いた絵の何枚目を見せるか

0 が 1 枚目。包みは SpriteInstance#frame=。
```ruby
gfx.set_sprite_frame(sp, 1)
```

### FmrbGfx#delete_all_sprites

<pre class="fmrb-sig"><code>delete_all_sprites() -&gt; FmrbGfx</code></pre>

この canvas のスプライトを全部片づける

置いた絵も絵の中身も消える。
```ruby
gfx.delete_all_sprites
```

### FmrbGfx#video_open

<pre class="fmrb-sig"><code>video_open(<a href="../String/">String</a> path) -&gt; <a href="../FmrbVideo/">FmrbVideo</a>?</code></pre>

JPEG を並べた動画を canvas で流す (Modern)

位置と速さはキーワード (x:, y:, fps:, loop:)。止まった状態で開くので、返った FmrbVideo の play で流す。流せない端末 (Retro・sim) では nil。流している間は、その四角の中に描かない。
```ruby
v = gfx.video_open("/home/a.mjpeg",
                   x: 0, y: 0, fps: 15)
v.play if v
```

### FmrbGfx#video_open_raw

<pre class="fmrb-sig"><code>video_open_raw(
  <a href="../String/">String</a> path,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> fps,
  bool loop
) -&gt; video_info?</code></pre>

video_open の省略なしの形

引数を省略できない単純な形。返すのは動画の {width:, height:} か、流せないときは nil。流す・止めるは FmrbGfx.video_control。包みは video_open。
```ruby
info = gfx.video_open_raw(path,
         0, 0, 15, false)
```

### FmrbGfx#export_frame

<pre class="fmrb-sig"><code>export_frame(<a href="../String/">String</a> path) -&gt; FmrbGfx</code></pre>

描いた画面をファイルに書き出す

最後の present で出た絵を、描画側のファイルシステムに書く (Tab5 は JPEG、
sim は BMP。Retro はできない)。present はしないので先に呼んでおく。待たずに返る。
```ruby
gfx.present
gfx.export_frame("/home/shot.jpg")
```

### FmrbGfx#set_output_level

<pre class="fmrb-sig"><code>set_output_level(<a href="../Integer/">Integer</a> level) -&gt; FmrbGfx</code></pre>

映像の明るさを決める

Retro のコンポジット映像の明るさを決める。Modern には効かない。
CRT のつまみで合わせきれないときに使う。
```ruby
@gfx.set_output_level(200)
```

### FmrbGfx#set_chroma_level

<pre class="fmrb-sig"><code>set_chroma_level(<a href="../Integer/">Integer</a> level) -&gt; FmrbGfx</code></pre>

映像の色の濃さを決める

Retro のコンポジット映像の色の濃さ (カラーバーストの振幅) を決める。
Modern には効かない。0 にすると白黒になる。
```ruby
@gfx.set_chroma_level(128)
@gfx.set_chroma_level(0)  # 白黒
```

### FmrbGfx#sync_file

<pre class="fmrb-sig"><code>sync_file(<a href="../String/">String</a> path, ?dest: <a href="../String/">String</a>) -&gt; bool</code></pre>

絵や音のファイルを送る

描画側は自分のファイルシステムしか読めないので、素材は先に送っておく。大きさと CRC32 を比べて、違うときだけ送る。毎回呼んでよい。

file_status[:exists] で「あるから送らない」と判断すると、書き換えた素材が古いまま残る。素材にはこちらを使う。

```ruby
gfx.sync_file("/home/bird.png",
              dest: "/cache/app/x/bird.png")
```

### FmrbGfx#sync_file_raw

<pre class="fmrb-sig"><code>sync_file_raw(<a href="../String/">String</a> path, <a href="../String/">String</a> dest) -&gt; bool</code></pre>

sync_file の省略なしの形

送り先を省略できない形。包みは sync_file (dest: を省くと同じパス)。
```ruby
gfx.sync_file_raw(path, path)
```

### FmrbGfx#transfer_file

<pre class="fmrb-sig"><code>transfer_file(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ファイルを必ず送り直す

中身を見ずに必ず送り直す。ふつうは sync_file でよく、こちらは送り先を書き換えたことが分かっているときに使う。
```ruby
@gfx.transfer_file("/data/a.bmp")
```

### FmrbGfx#transfer_file_raw

<pre class="fmrb-sig"><code>transfer_file_raw(<a href="../String/">String</a> path, <a href="../String/">String</a> dest) -&gt; bool</code></pre>

transfer_file の省略なしの形

送り先を省略できない形。包みは transfer_file。
```ruby
gfx.transfer_file_raw(path, path)
```

### FmrbGfx#file_status

<pre class="fmrb-sig"><code>file_status(<a href="../String/">String</a> path) -&gt; file_info</code></pre>

送った先にファイルがあるか

描画側にそのファイルがあるかと、その大きさを {exists:, size:} で返す。

素材を送るかどうかの判断にはこれを使わない。中身が変わっても exists は
true のままなので、書き換えた素材が古いまま残る。判断は sync_file に任せる。
```ruby
st = @gfx.file_status("/data/a.bmp")
st[:exists]
st[:size]
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
