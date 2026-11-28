# FmrbVideo

A handle on the video being played

How to use it: [Drawing](../fmrb_gfx.md).

Returned by FmrbGfx#video_open. Only one video can play at a time, so every
handle operates the same player. It is Ruby that calls FmrbGfx.video_control.

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

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
