# FmrbMidi::MmlPlayer

MML で書いた曲を鳴らす係

使い方は [MIDI](../midi.md) のページにあります。

tick を毎回呼んで進める。

## クラスメソッド

### FmrbMidi::MmlPlayer.new

<pre class="fmrb-sig"><code>new(<a href="../MIDI__Device/">MIDI::Device</a> device) -&gt; MmlPlayer</code></pre>

MML を鳴らす係を作る

```ruby
@mml = FmrbMidi::MmlPlayer.new(@midi)
```

## インスタンスメソッド

### FmrbMidi::MmlPlayer#load_string

<pre class="fmrb-sig"><code>load_string(<a href="../String/">String</a> mml, ?channel: <a href="../Integer/">Integer</a>, ?velocity: <a href="../Integer/">Integer</a>) -&gt; bool</code></pre>

MML の文を読み込む

**channel と velocity はキーワードで渡す** (省略すると 0 と 100)。前に入れた曲は消える。鳴らせる音符が無ければ false で、理由は
`error`。MML の `t120` のような速さの指定は読まれない (`bpm=` を使う)。
```ruby
@mml.load_string("cdefg",
  channel: 0, velocity: 100)
```

### FmrbMidi::MmlPlayer#add_string

<pre class="fmrb-sig"><code>add_string(<a href="../String/">String</a> mml, ?channel: <a href="../Integer/">Integer</a>, ?velocity: <a href="../Integer/">Integer</a>) -&gt; bool</code></pre>

別のパートを足す

**伴奏を重ねる**ときに使う。`load_string` と違って前のパートを消さない。
`channel:` と `velocity:` は省略すると 0 と 100。
```ruby
@mml.add_string("egb", channel: 1)
```

### FmrbMidi::MmlPlayer#load_file

<pre class="fmrb-sig"><code>load_file(<a href="../String/">String</a> path) -&gt; bool</code></pre>

曲のファイル (.mml) を読み込む

**読めなければ false**、理由は `error`。行ごとの書式で、`#` で始まる行は注釈。`bpm 120`・`loop on`・`velocity 80`・`voice triangle`・`duty 1`・
`volume 100`・`program 24` は設定で、それ以降のパートに効く。それ以外の行は MML のパートで、順に channel 0, 1, ... に載る。
`voice` `duty` `volume` `program` は**読み込むときにデバイスへ送られる**ので、
`device=` で先にデバイスを決めておく。
```ruby
@mml.device = @midi
@mml.load_file("/home/a.mml")
```

### FmrbMidi::MmlPlayer#load_text

<pre class="fmrb-sig"><code>load_text(<a href="../String/">String</a> text) -&gt; bool</code></pre>

曲の文字列 (ファイルの書式) を読み込む

`load_file` の、メモリにある文字列版。書式と失敗のしかた (false と
`error`) は同じ。パートが 1 つも無いと "no parts in the file"。
```ruby
@mml.load_text("bpm 90\no4 l4 cdef")
```

### FmrbMidi::MmlPlayer#loaded?

<pre class="fmrb-sig"><code>loaded?() -&gt; bool</code></pre>

読み込んだかどうか

```ruby
return unless @mml.loaded?
```

### FmrbMidi::MmlPlayer#event_count

<pre class="fmrb-sig"><code>event_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

入っている音符の数

```ruby
n = @mml.event_count
```

### FmrbMidi::MmlPlayer#total_clocks

<pre class="fmrb-sig"><code>total_clocks() -&gt; <a href="../Integer/">Integer</a></code></pre>

曲の長さ (clock)

四分音符が 24、全音符が 96。ms にするなら clock * 2500 / bpm。
```ruby
ms = @mml.total_clocks * 2500 / @mml.bpm
```

### FmrbMidi::MmlPlayer#start

<pre class="fmrb-sig"><code>start() -&gt; bool</code></pre>

鳴らし始める

**頭から**鳴らす。**すぐ戻る**。読んでいなければ false。音が出るのは
`tick` を回してから。
```ruby
@mml.start
```

### FmrbMidi::MmlPlayer#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

止める

このプレーヤーが待ち行列に入れた分を捨て、鳴っている音を止める。
1 つのアプリでプレーヤーを 2 つ鳴らしていても、もう片方の分は残る
(pause・`device=` も同じ)。
```ruby
@mml.stop
```

### FmrbMidi::MmlPlayer#pause

<pre class="fmrb-sig"><code>pause() -&gt; bool</code></pre>

いったん止める

鳴っていなければ false。
```ruby
@mml.pause
```

### FmrbMidi::MmlPlayer#resume

<pre class="fmrb-sig"><code>resume() -&gt; bool</code></pre>

続きを鳴らす

止める前に待ち行列へ入れてあった分 (最大 0.3 秒) は捨てられる。止めていなければ false。
```ruby
@mml.resume
```

### FmrbMidi::MmlPlayer#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

鳴っている最中かどうか

```ruby
draw_bar if @mml.playing?
```

### FmrbMidi::MmlPlayer#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

最後まで鳴り終わったか

**読み込んだだけで鳴らしていない曲や、`stop` した曲でも true**。終わりを見るなら `playing?` が false に変わるのを見る。
```ruby
@mml.stop if @mml.finished?
```

### FmrbMidi::MmlPlayer#tick

<pre class="fmrb-sig"><code>tick() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

曲を進める。毎回呼ぶ

**呼ばないと音が進まない**。戻りは次に呼ぶまでの待ち時間 (ms)。鳴っていない・終わったなら nil。
```ruby
def on_update
  @mml.tick
end
```

### FmrbMidi::MmlPlayer#next_delay

<pre class="fmrb-sig"><code>next_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

曲を進めて待ち時間を返す

`tick` を呼び、その戻りと渡した `default_ms` の短いほうを返す。
`on_update` の戻り値にする。
```ruby
def on_update
  @mml.next_delay(200)
end
```

### FmrbMidi::MmlPlayer#bpm

<pre class="fmrb-sig"><code>bpm() -&gt; <a href="../Integer/">Integer</a></code></pre>

曲の速さ (一分間の拍数)

```ruby
n = @mml.bpm
```

### FmrbMidi::MmlPlayer#bpm=

<pre class="fmrb-sig"><code>bpm=(<a href="../Integer/">Integer</a> value) -&gt; void</code></pre>

曲の速さを変える

1 から 1000 まで。**渡し済みの音符は前の速さのまま**鳴る。
```ruby
@mml.bpm = 120
```

### FmrbMidi::MmlPlayer#tempo_scale

<pre class="fmrb-sig"><code>tempo_scale() -&gt; <a href="../Float/">Float</a></code></pre>

曲の速さの倍率

1.0 が `bpm` のとおり。`bpm` とは別に持つ。
```ruby
s = @mml.tempo_scale
```

### FmrbMidi::MmlPlayer#tempo_scale=

<pre class="fmrb-sig"><code>tempo_scale=(<a href="../Float/">Float</a> value) -&gt; void</code></pre>

曲の速さの倍率を変える

0.001 から 100.0 まで。鳴っている途中でも変えられる。
```ruby
@mml.tempo_scale = 1.5
```

### FmrbMidi::MmlPlayer#loop

<pre class="fmrb-sig"><code>loop() -&gt; bool</code></pre>

繰り返すか

初めは false。`load_file` の `loop on` で true になる。
**新しく読み込んでも戻らない**。
```ruby
again = @mml.loop
```

### FmrbMidi::MmlPlayer#loop=

<pre class="fmrb-sig"><code>loop=(bool value) -&gt; void</code></pre>

繰り返すかを決める

true なら終わりまで来たら頭から続ける。
```ruby
@mml.loop = true
```

### FmrbMidi::MmlPlayer#device

<pre class="fmrb-sig"><code>device() -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

鳴らす先のデバイス

```ruby
dev = @mml.device
```

### FmrbMidi::MmlPlayer#device=

<pre class="fmrb-sig"><code>device=(<a href="../MIDI__Device/">MIDI::Device</a> value) -&gt; void</code></pre>

鳴らす先のデバイスを切り替える

鳴らしている最中でも変えられる。古いデバイスの音は止まり、待ち行列にあった分は捨てられる。
```ruby
@mml.device = @serial
```

### FmrbMidi::MmlPlayer#sent_count

<pre class="fmrb-sig"><code>sent_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

送った出来事の数

```ruby
n = @mml.sent_count
```

### FmrbMidi::MmlPlayer#stall_count

<pre class="fmrb-sig"><code>stall_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

予定をずらした回数

アプリが 200 ms 以上遅れたとき、予定をずらす。
```ruby
n = @mml.stall_count
```

### FmrbMidi::MmlPlayer#underrun_count

<pre class="fmrb-sig"><code>underrun_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

音が途切れた回数

待ち行列が空なのに 5 ms 以上遅れた回数。
```ruby
n = @mml.underrun_count
```

### FmrbMidi::MmlPlayer#timing_stats

<pre class="fmrb-sig"><code>timing_stats() -&gt; <a href="../String/">String</a></code></pre>

送り具合の一行の報告

ログに出す文字列。何も送っていないうちは "no events yet"。
```ruby
Log.info(@mml.timing_stats)
```

### FmrbMidi::MmlPlayer#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

読み込みに失敗した理由

```ruby
msg = @mml.error
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
