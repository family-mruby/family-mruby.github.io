# FmrbVideo

FmrbGfx#video_open が返す、流している動画の取っ手。流せる動画は 1 つなので、どの取っ手も同じ再生機を操作する。中身は FmrbGfx.video_control を呼ぶ Ruby。

How to use it: [Drawing](../fmrb_gfx.md).

## Instance methods

### FmrbVideo#width

<pre class="fmrb-sig"><code>width() -&gt; <a href="../Integer/">Integer</a></code></pre>

The video's width in pixels

```ruby
w = v.width
```

### FmrbVideo#height

<pre class="fmrb-sig"><code>height() -&gt; <a href="../Integer/">Integer</a></code></pre>

The video's height in pixels

```ruby
h = v.height
```

### FmrbVideo#play

<pre class="fmrb-sig"><code>play() -&gt; FmrbVideo</code></pre>

Play

```ruby
v.play
```

### FmrbVideo#pause

<pre class="fmrb-sig"><code>pause() -&gt; FmrbVideo</code></pre>

Pause

```ruby
v.pause
```

### FmrbVideo#stop

<pre class="fmrb-sig"><code>stop() -&gt; FmrbVideo</code></pre>

Stop and close the file

The canvas keeps the last picture.
```ruby
@video.stop
```

### FmrbVideo#rewind

<pre class="fmrb-sig"><code>rewind() -&gt; FmrbVideo</code></pre>

Back to the start

```ruby
v.rewind
```

### FmrbVideo#status

<pre class="fmrb-sig"><code>status() -&gt; <a href="../FmrbGfx/">FmrbGfx</a>::video_status?</code></pre>

The player's state

{state:, shown:, dropped:} or nil, as FmrbGfx.video_status.
```ruby
st = @video.status
st[:shown]
st[:dropped]
```

### FmrbVideo#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

Whether it is playing

```ruby
v.play unless v.playing?
```

### FmrbVideo#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

Whether it has played to the end

```ruby
v.rewind if v.finished?
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
