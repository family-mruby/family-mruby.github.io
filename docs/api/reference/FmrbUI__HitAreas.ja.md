# FmrbUI::HitAreas

毎回描く画面の押せる範囲

使い方は [UI 部品](../ui.md) のページにあります。

ゲームの卓のように画面をまるごと描き直す物で使う。描く前に clear し、描きながら add し、クリックの点を id_at で引く。**何も描かない**
(ボタンの絵は FmrbGfx#draw_button)。FmrbUI の部品とは混ぜない。押した時点でアプリが動く。

```ruby
@hits = FmrbUI::HitAreas.new

@hits.clear
@gfx.draw_button(x, y, 60, 16, "OK",
  theme_accent, theme_fg_light)
@hits.add(:ok, x, y, 60, 16)

id = @hits.id_at(ev[:x], ev[:y])
```

## クラスメソッド

### FmrbUI::HitAreas.new

<pre class="fmrb-sig"><code>new() -&gt; FmrbUI::HitAreas</code></pre>

空の一覧を作る

```ruby
@hits = FmrbUI::HitAreas.new
```

## インスタンスメソッド

### FmrbUI::HitAreas#clear

<pre class="fmrb-sig"><code>clear() -&gt; FmrbUI::HitAreas</code></pre>

一覧を空にする

```ruby
@hits.clear
```

### FmrbUI::HitAreas#add

<pre class="fmrb-sig"><code>add(
  untyped id,
  <a href="../Integer/">Integer</a> x,
  <a href="../Integer/">Integer</a> y,
  <a href="../Integer/">Integer</a> w,
  <a href="../Integer/">Integer</a> h,
  ?untyped data
) -&gt; FmrbUI::HitAreas</code></pre>

押せる範囲を足す

6 番目に data を渡すと、at の結果に入って戻る (麻雀の牌など)。範囲は次の clear まで有効。

```ruby
@hits.add(:ok, x, y, 60, 16)
@hits.add(:tile, x, y, 16, 24, t)
```

### FmrbUI::HitAreas#at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Array/">Array</a>?</code></pre>

点にある範囲を引く

戻り値は `[id, x, y, w, h, data]` か nil。重なっているときは
**先に足した方が勝つ**。

```ruby
b = @hits.at(ev[:x], ev[:y])
tile = b[5] if b
```

### FmrbUI::HitAreas#id_at

<pre class="fmrb-sig"><code>id_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; untyped</code></pre>

点にある範囲の id

無ければ nil。重なっているときは先に足した方。

```ruby
case @hits.id_at(ev[:x], ev[:y])
when :ok then close
end
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
