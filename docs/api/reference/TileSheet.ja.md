# TileSheet

タイルの絵をならべた一枚の絵

使い方は [タイルマップ](../tilemap.md) のページにあります。

番号でタイルを取り出して描く。

## クラスメソッド

### TileSheet.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbGfx/">FmrbGfx</a> gfx,
  <a href="../String/">String</a> path,
  cols: <a href="../Integer/">Integer</a>,
  ?rows: <a href="../Integer/">Integer</a>,
  ?tile_size: <a href="../Integer/">Integer</a>,
  ?source: <a href="../String/">String</a>
) -&gt; TileSheet</code></pre>

タイルの絵を読み込む

並んだ絵を 1 枚の PNG (か BMP) から読む。**キーワード引数で呼ぶ**
(cols: は必須、`tile_size:` は省略すると 16)。path は描画側のパスで、先に
sync_file で送る。rows: を省くなら source: に core の側の元の絵を渡す
(頭から高さを読む)。
```ruby
gfx.sync_file(src, dest: dst)
sheet = TileSheet.new(gfx, dst,
  cols: 8, source: src)
```

### TileSheet.picture_height

<pre class="fmrb-sig"><code>picture_height(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

絵の高さを頭から読む

PNG か BMP のファイルの高さ (ドット) を返す。どちらでもないか読めないときは 0 (例外は出ない)。`TileSheet.new` が `source:` からタイルの段数を出すときに使う。
```ruby
h = TileSheet.picture_height(src)
rows = h / 16
```

## インスタンスメソッド

### TileSheet#image

<pre class="fmrb-sig"><code>image() -&gt; <a href="../SpriteImage/">SpriteImage</a></code></pre>

中で使っているうごく絵

```ruby
img = sheet.image
```

### TileSheet#cols

<pre class="fmrb-sig"><code>cols() -&gt; <a href="../Integer/">Integer</a></code></pre>

横にならぶタイルの数

```ruby
n = sheet.cols
```

### TileSheet#rows

<pre class="fmrb-sig"><code>rows() -&gt; <a href="../Integer/">Integer</a></code></pre>

縦にならぶタイルの数

```ruby
n = sheet.rows
```

### TileSheet#tile_size

<pre class="fmrb-sig"><code>tile_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

タイル一つの大きさ (ドット)

```ruby
px = sheet.tile_size
```

### TileSheet#stamp

<pre class="fmrb-sig"><code>stamp(
  <a href="../Integer/">Integer</a>? index,
  dst_x: <a href="../Integer/">Integer</a>,
  dst_y: <a href="../Integer/">Integer</a>,
  ?clip_x: <a href="../Integer/">Integer</a>,
  ?clip_y: <a href="../Integer/">Integer</a>,
  ?clip_w: <a href="../Integer/">Integer</a>,
  ?clip_h: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

番号のタイルを画面に一つ描く

置き場所はキーワード (dst_x:, dst_y:) で、原点から。clip_x: など 4 つで押す範囲を絞れる。nil か負の番号は何もしない。
```ruby
sheet.stamp(3, dst_x: x, dst_y: y)
```

### TileSheet#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

このタイルの絵を片づける

```ruby
sheet.destroy
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
