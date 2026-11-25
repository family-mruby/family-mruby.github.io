# FmrbColors

色の名前の表と、/home/colors.toml の読み書き

色は **RGB332 の 0〜255 の整数**。名前は web の色名を 256 色に写したもの (101 個の一覧と、同じ色へ行く別名)。`/home/colors.toml` にはアプリごとの上書きだけを書き、ファイルも節もキーも無ければ「テーマのまま」になる。
```ruby
bg = FmrbColors.by_name("navy")   #=> 2
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PATH`</span> | [`String`](String.md) | 上書きのファイル |

## クラスメソッド

### FmrbColors.shade

<pre class="fmrb-sig"><code>shade(<a href="../Integer/">Integer</a> color, ?<a href="../Integer/">Integer</a>? avoid) -&gt; <a href="../Integer/">Integer</a></code></pre>

テーマの色より 1 段暗い色

赤と緑を 2 段、青を 1 段下げる。結果が 0x01 (デスクトップの透明色)・元の色・`avoid` になるときは、下げずに上げる方へ振る。隣り合うバーが溶け合わないようにするためのもの。
```ruby
bar = FmrbColors.shade(
  FmrbConst::THEME_MENU_BG, bg)
```

### FmrbColors.by_name

<pre class="fmrb-sig"><code>by_name(<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

名前から色 (RGB332) を引く

名前は**小文字**で、一覧か別名にあるもの。無ければ nil。
```ruby
FmrbColors.by_name("black")   #=> 0
```

### FmrbColors.name_of

<pre class="fmrb-sig"><code>name_of(<a href="../Integer/">Integer</a> value) -&gt; <a href="../String/">String</a>?</code></pre>

色の名前 (選ぶときに見せるもの)

名前の無い色は nil。別名は返らず、一覧の名前が返る。
```ruby
FmrbColors.name_of(0)   #=> "black"
```

### FmrbColors.name_at

<pre class="fmrb-sig"><code>name_at(<a href="../Integer/">Integer</a> index) -&gt; <a href="../String/">String</a>?</code></pre>

一覧の n 番目の名前

0 から。範囲外は nil。
```ruby
FmrbColors.name_at(0)   #=> "black"
```

### FmrbColors.palette_size

<pre class="fmrb-sig"><code>palette_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

一覧の個数

```ruby
FmrbColors.palette_size.times { |i| p FmrbColors.name_at(i) }
```

### FmrbColors.palette_value

<pre class="fmrb-sig"><code>palette_value(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

一覧の n 番目の色

0 から。範囲外は nil。`name_at` と同じ並び。
```ruby
FmrbColors.palette_value(0)   #=> 0
```

### FmrbColors.to_color

<pre class="fmrb-sig"><code>to_color(<a href="../String/">String</a> text) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

文字を色にする

`"0x24"` (16 進)、`"36"` (10 進)、`"black"`・`"\"black\""` (名前) を 0〜255 にする。
**それ以外は nil** なので、打ち間違いはテーマの色が残る (黒で塗られない)。16 進と 10 進は
256 を超えても下 8 ビットに丸める。
```ruby
FmrbColors.to_color("0x1C")   #=> 28
```

### FmrbColors.to_text

<pre class="fmrb-sig"><code>to_text(<a href="../Integer/">Integer</a> value) -&gt; <a href="../String/">String</a></code></pre>

色を書き戻す字にする

名前があれば名前、無ければ `"0x1C"` の形。
```ruby
FmrbColors.to_text(28)   #=> "0x1C" か名前
```

### FmrbColors.section

<pre class="fmrb-sig"><code>section(<a href="../String/">String</a> name) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../Integer/">Integer</a>]</code></pre>

1 つの節の上書きを読む

`{ "bg" => 36, ... }` を返す。**ファイルや節が無い・TOML でない・色にならない値**は空か飛ばしで、例外にならない。整数は下 8 ビット (負は飛ばす)、文字列は `to_color`。
```ruby
c = FmrbColors.section("editor")
bg = c["bg"] || FmrbConst::THEME_WINDOW_BG
```

### FmrbColors.set

<pre class="fmrb-sig"><code>set(<a href="../String/">String</a> section, <a href="../String/">String</a> key, <a href="../Integer/">Integer</a>? value) -&gt; bool</code></pre>

1 つの色の上書きを書く

節 `section` のキー `key` に色を書く。**value が nil ならそのキーを消す** (テーマに戻る)。書き方は `FmrbToml.update` と同じ (他の行・コメントは残る)。ファイルに入れば true、書けない・TOML でないファイルなら false。
```ruby
FmrbColors.set("shell", "bg", 0x24)
```

### FmrbColors.clear

<pre class="fmrb-sig"><code>clear(<a href="../String/">String</a> section) -&gt; bool</code></pre>

1 つの節の上書きを全部消す

見出しからその節の終わりまでを消して、ファイルを書き直す。ファイルが無ければ true、書けなければ false。**ほかの節は保つが全体を書き直す**。
```ruby
FmrbColors.clear("shell")
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
