# FmrbVideo

流している動画の取っ手

使い方は [描画](../fmrb_gfx.md) のページにあります。

FmrbGfx#video_open が返す。流せる動画は 1 つなので、どの取っ手も同じ再生機を操作する。中身は FmrbGfx.video_control を呼ぶ Ruby。

## インスタンスメソッド

### FmrbVideo#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

動画の横幅 (ドット)

```ruby
w = v.width
```

### FmrbVideo#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

動画の高さ (ドット)

```ruby
h = v.height
```

### FmrbVideo#play

<pre class="fmrb-sig"><code>play() -&gt; FmrbVideo</code></pre>

流す

```ruby
v.play
```

### FmrbVideo#pause

<pre class="fmrb-sig"><code>pause() -&gt; FmrbVideo</code></pre>

一時停止する

```ruby
v.pause
```

### FmrbVideo#stop

<pre class="fmrb-sig"><code>stop() -&gt; FmrbVideo</code></pre>

止めてファイルを閉じる

canvas には最後の絵が残る。
```ruby
@video.stop
```

### FmrbVideo#rewind

<pre class="fmrb-sig"><code>rewind() -&gt; FmrbVideo</code></pre>

頭に戻す

```ruby
v.rewind
```

### FmrbVideo#status

<pre class="fmrb-sig"><code>status() -&gt; <a href="../FmrbGfx/">FmrbGfx</a>::video_status?</code></pre>

再生のようす

{state:, shown:, dropped:} か nil (FmrbGfx.video_status と同じ)。
```ruby
st = @video.status
st[:shown]
st[:dropped]
```

### FmrbVideo#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

流れているか

```ruby
v.play unless v.playing?
```

### FmrbVideo#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

終わりまで流れたか

```ruby
v.rewind if v.finished?
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
