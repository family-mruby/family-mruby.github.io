# TileMap

地図そのもの

使い方は [タイルマップ](../tilemap.md) のページにあります。

web の地図エディタが書き出した JSON を読む。

## クラスメソッド

### TileMap.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> json_path) -&gt; TileMap</code></pre>

地図のファイルを読み込む

**`.map.bin` を渡す**。JSON も読めるが、端末では桁違いに遅い
(39 秒 対 55 ミリ秒)。
```ruby
map = TileMap.new("/app/img/world.map.bin")
```

## インスタンスメソッド

### TileMap#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

地図の横のマス数

```ruby
w = map.width
```

### TileMap#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

地図の縦のマス数

```ruby
h = map.height
```

### TileMap#tile_size

<pre class="fmrb-sig"><code>tile_size() -&gt; <a href="../Integer/">Integer</a></code></pre>

マス一つの大きさ (ドット)

```ruby
px = map.tile_size
```

### TileMap#tilesheet_path

<pre class="fmrb-sig"><code>tilesheet_path() -&gt; <a href="../String/">String</a></code></pre>

使うタイルの絵のファイル名

```ruby
path = map.tilesheet_path
```

### TileMap#tilesheet_cols

<pre class="fmrb-sig"><code>tilesheet_cols() -&gt; <a href="../Integer/">Integer</a></code></pre>

タイルの絵の横のならび数

```ruby
n = map.tilesheet_cols
```

### TileMap#layers

<pre class="fmrb-sig"><code>layers() -&gt; <a href="../Array/">Array</a>?</code></pre>

重ねた地図のデータ

`.map.bin` から読んだときは nil (JSON から読んだときだけ配列)。段の数は `layer_count`、マスは `tile_at` で読む。
```ruby
map.layers.length
```

### TileMap#layer_count

<pre class="fmrb-sig"><code>layer_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

重ねた段の数

`.map.bin` でも JSON でも使える。`tile_at` の `layer:` は 0 からこの数より 1 小さい数まで。
```ruby
n = map.layer_count
```

### TileMap#events

<pre class="fmrb-sig"><code>events() -&gt; <a href="../Array/">Array</a></code></pre>

地図に置いた仕掛けの一覧

```ruby
map.events.length
```

### TileMap#walkable_tiles

<pre class="fmrb-sig"><code>walkable_tiles() -&gt; <a href="../Array/">Array</a></code></pre>

歩いてよいタイルの番号

```ruby
map.walkable_tiles
```

### TileMap#spawn_x

<pre class="fmrb-sig"><code>spawn_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

始まりの場所

```ruby
@x = map.spawn_x
```

### TileMap#spawn_y

<pre class="fmrb-sig"><code>spawn_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

始まりの場所

```ruby
@y = map.spawn_y
```

### TileMap#tile_at

<pre class="fmrb-sig"><code>tile_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, ?layer: <a href="../Integer/">Integer</a>) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

そのマスのタイル番号を調べる

地図の外・空のマス・段が無いときは nil。**升目の座標**で、ドットではない。
`layer:` (省略すると 0) は何段目か。
```ruby
t = map.tile_at(3, 5)
```

### TileMap#walkable?

<pre class="fmrb-sig"><code>walkable?(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

そのマスを歩けるかどうか

```ruby
return unless map.walkable?(nx, ny)
```

### TileMap#event_at

<pre class="fmrb-sig"><code>event_at(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

そのマスの仕掛けを取り出す

```ruby
ev = map.event_at(@x, @y)
handle(ev) if ev
```

### TileMap#render

<pre class="fmrb-sig"><code>render(
  <a href="../TileSheet/">TileSheet</a> sheet,
  origin_x: <a href="../Integer/">Integer</a>,
  origin_y: <a href="../Integer/">Integer</a>,
  ?max_cols: <a href="../Integer/">Integer</a>,
  ?max_rows: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

地図ぜんぶを画面に描く

地図を丸ごと描く。大きい地図では**画面ぶんだけの `render_view`** を使う。
**`origin_x:` と `origin_y:` は必須** (最初のタイルを canvas のどこに置くか)。`max_cols:`・`max_rows:` (省略すると地図の全部) で描く範囲を切れる。
```ruby
@map.render(@sheet,
            origin_x: 0, origin_y: 0)
```

### TileMap#render_view

<pre class="fmrb-sig"><code>render_view(
  <a href="../TileSheet/">TileSheet</a> sheet,
  origin_x: <a href="../Integer/">Integer</a>,
  origin_y: <a href="../Integer/">Integer</a>,
  view_x: <a href="../Integer/">Integer</a>,
  view_y: <a href="../Integer/">Integer</a>,
  view_w: <a href="../Integer/">Integer</a>,
  view_h: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

見えている場所だけを描く

**キーワード引数で呼ぶ。全部必須**。`origin_x:` `origin_y:` は見える範囲の左上を canvas のどこに置くか、`view_x:` `view_y:` はその左上が地図のどこか (ドット)。
```ruby
map.render_view(sheet,
  origin_x: 0, origin_y: 0,
  view_x: @cam_x, view_y: @cam_y,
  view_w: 320, view_h: 240)
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
