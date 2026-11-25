# TileRing

見えている周りだけを描き直す仕組み

使い方は [タイルマップ](../tilemap.md) のページにあります。

広い地図を軽く動かすための仕組み。

## クラスメソッド

### TileRing.new

<pre class="fmrb-sig"><code>new(
  <a href="../TileMap/">TileMap</a> map,
  <a href="../TileSheet/">TileSheet</a> sheet,
  tiles_w: <a href="../Integer/">Integer</a>,
  tiles_h: <a href="../Integer/">Integer</a>
) -&gt; TileRing</code></pre>

動かすための入れ物を作る

画面より少し大きい canvas を輪のように使い、**新しく見えた列だけ**を描き足して広い世界をずらす。**Modern 専用**。
**`tiles_w:` と `tiles_h:` は必須** (輪にする canvas の大きさ。タイルの数で、見える数 + 1 以上にする)。
```ruby
ring = TileRing.new(map, sheet,
  tiles_w: 12, tiles_h: 12)
```

## インスタンスメソッド

### TileRing#buf_w

<pre class="fmrb-sig"><code>buf_w() -&gt; <a href="../Integer/">Integer</a></code></pre>

入れ物の横幅 (ドット)

```ruby
w = ring.buf_w
```

### TileRing#buf_h

<pre class="fmrb-sig"><code>buf_h() -&gt; <a href="../Integer/">Integer</a></code></pre>

入れ物の高さ (ドット)

```ruby
h = ring.buf_h
```

### TileRing#ensure_view

<pre class="fmrb-sig"><code>ensure_view(
  <a href="../Integer/">Integer</a> view_x,
  <a href="../Integer/">Integer</a> view_y,
  <a href="../Integer/">Integer</a> view_w,
  <a href="../Integer/">Integer</a> view_h
) -&gt; bool</code></pre>

見えてきたところを描き足す

**毎フレーム、動かしたあとに呼ぶ**。新しく見えた列だけを押すので、少し動いたときは何もしない。何か描いたら true で、そのとき輪の canvas を present しないと画面に出ない。
```ruby
ring.ensure_view(@cam_x, @cam_y,
                 320, 240)
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
