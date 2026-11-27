# FmrbText

文字を px で測って詰める・折る道具

使い方は [描画](../fmrb_gfx.md) のページにあります。

FmrbGfx に混ぜてあるので、`@gfx.fit_text` のように呼ぶ。幅は呼んだ時点のフォントと文字の大きさで測る (text_width と同じ数字)。何も覚えない。実装は lib/gems/picoruby-fmrb-app/mrblib/fmrb-text.rb。

```ruby
s = @gfx.fit_text(name, 80)
@gfx.draw_text(x, y, s, theme_fg)
```

## インスタンスメソッド

### FmrbText#fit_text

<pre class="fmrb-sig"><code>fit_text(
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> width,
  ?<a href="../String/">String</a> mark,
  ?<a href="../Integer/">Integer</a>? mark_w,
  ?<a href="../Symbol/">Symbol</a>? family
) -&gt; <a href="../String/">String</a></code></pre>

文字を幅に収まるよう切る

**収まる文字はそのまま返る**。切ったときだけ 3 番目の引数の印
(`"…"`、`".."`) を付け、その幅の分を空けて切る。印を省くと何も付けずに切る。4 番目は印の幅 (px、nil で測る)、5 番目は測るフォント (nil で今のフォント)。

```ruby
@gfx.fit_text(title, 100)
@gfx.fit_text(title, 100, "…")
@gfx.fit_text(name, w, "..", nil,
              :default)
```

### FmrbText#wrap_text

<pre class="fmrb-sig"><code>wrap_text(<a href="../String/">String</a> text, <a href="../Integer/">Integer</a> width) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

文字を最大 2 行に折る

戻り値は 1 つか 2 つの文字列の配列。1 行目の最後の空白で割って残りが 1 行に収まればそこで、だめなら幅で割り、2 行目がまだ長ければ
`…` で詰める。3 行以上は fit_text で 1 行ずつ切る。

```ruby
lines = @gfx.wrap_text(msg, 120)
```

### FmrbText#draw_text_lines

<pre class="fmrb-sig"><code>draw_text_lines(
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../String/">String</a> text,
  <a href="../Integer/">Integer</a> width,
  <a href="../Integer/">Integer</a> color,
  <a href="../Integer/">Integer</a> line_h
) -&gt; <a href="../Integer/">Integer</a></code></pre>

折った文字を行ごとに描く

wrap_text の行を line_h 間隔で下へ描き、最後の行の下の y を返す。

```ruby
y = @gfx.draw_text_lines(x, y, msg,
      120, theme_fg, 15)
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
