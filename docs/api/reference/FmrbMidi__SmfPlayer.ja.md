# FmrbMidi::SmfPlayer

曲のファイル (SMF) を鳴らす係

使い方は [MIDI](../midi.md) のページにあります。

tick を毎回呼んで進める。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`LOOKAHEAD_US`</span> | [`Integer`](Integer.md) | 待ち行列に先に入れておく長さ (µs) |

## クラスメソッド

### FmrbMidi::SmfPlayer.new

<pre class="fmrb-sig"><code>new(<a href="../MIDI__Device/">MIDI::Device</a> device) -&gt; SmfPlayer</code></pre>

曲を鳴らす係を作る

```ruby
@smf = FmrbMidi::SmfPlayer.new(@midi)
```

## インスタンスメソッド

### FmrbMidi::SmfPlayer#load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path) -&gt; bool</code></pre>

曲のファイルを読み込む

**読めなければ false**。理由は `error` に入る。読む前に鳴っていた曲は止まる。形式 2 の SMF は読めない。読み込むと `tempo_scale`・`transpose`・`channel_mask`・
`ignore_program_change` は初期値に戻るので、読んだあとで設定する。
```ruby
unless @smf.load("/home/a.mid")
  puts @smf.error
end
```

### FmrbMidi::SmfPlayer#load_string

<pre class="fmrb-sig"><code>load_string(<a href="../String/">String</a> data, ?<a href="../String/">String</a> path) -&gt; bool</code></pre>

曲のバイト列を読み込む

`load` の、メモリにあるバイト列を渡す版。**読めなければ false**、理由は `error`。`path` (省略すると nil) は `path` メソッドが返す名前になるだけで、ファイルは読まない。`load` と同じく設定は初期値に戻る。
```ruby
@smf.load_string(data, "from net")
```

### FmrbMidi::SmfPlayer#loaded?

<pre class="fmrb-sig"><code>loaded?() -&gt; bool</code></pre>

読み込んだかどうか

```ruby
return unless @smf.loaded?
```

### FmrbMidi::SmfPlayer#start

<pre class="fmrb-sig"><code>start() -&gt; bool</code></pre>

曲を鳴らし始める

**頭から**鳴らし直す。途中から続けるなら `resume`。
**すぐ戻る** (鳴り終わるのは待たない)。読んでいなければ false。音が出るのは `tick` を回してからなので、`on_update` で呼び続ける。
```ruby
@smf.start
```

### FmrbMidi::SmfPlayer#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

曲を止める

このプレーヤーが待ち行列に入れた分を捨て、鳴っている音を止める。
1 つのアプリでプレーヤーを 2 つ鳴らしていても、もう片方の分は残る
(pause・`device=` も同じ)。
```ruby
@smf.stop
```

### FmrbMidi::SmfPlayer#pause

<pre class="fmrb-sig"><code>pause() -&gt; bool</code></pre>

曲をいったん止める

鳴っていなければ (止まっている・もう止めた) false。
```ruby
@smf.pause
```

### FmrbMidi::SmfPlayer#resume

<pre class="fmrb-sig"><code>resume() -&gt; bool</code></pre>

止めた曲の続きを鳴らす

**止める前に待ち行列へ入れてあった分 (最大 0.3 秒) は捨てられる**ので、その分だけ先から続く。止めていなければ false。
```ruby
@smf.resume
```

### FmrbMidi::SmfPlayer#playing?

<pre class="fmrb-sig"><code>playing?() -&gt; bool</code></pre>

鳴っている最中かどうか

曲を最後まで読み、**このプレーヤーが予約した音**が全部鳴ったら false になる。ほかのプレーヤー
(同じアプリでも別のアプリでも) が鳴らしている間も、自分の分が終われば false。
```ruby
draw_bar if @smf.playing?
```

### FmrbMidi::SmfPlayer#finished?

<pre class="fmrb-sig"><code>finished?() -&gt; bool</code></pre>

最後まで鳴り終わったか

**読み込んだだけで鳴らしていない曲や、`stop` した曲でも true**。「鳴っていない」の意味なので、終わりを見るなら `playing?` が false に変わるのを見る。
```ruby
@smf.start if @smf.finished?
```

### FmrbMidi::SmfPlayer#tick

<pre class="fmrb-sig"><code>tick() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

曲を進める。毎回呼ぶ

**呼ばないと音が進まない**。毎フレームの決まった場所で 1 回呼ぶ。戻りは、次に呼ぶまでの待ち時間 (ms)。何かが今すぐ要るなら 0、鳴っていない・終わったなら nil。曲の最後まで読み終えたあとも、待ち行列の音が鳴り切るまでは 20 が返り、そのあと nil になる。
```ruby
def on_update
  @smf.tick
end
```

### FmrbMidi::SmfPlayer#next_delay

<pre class="fmrb-sig"><code>next_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

曲を進めて待ち時間を返す

`tick` を呼び、その戻りと渡した `default_ms` の短いほうを返す。
`on_update` の戻り値にする。鳴っていなければ `default_ms`。
```ruby
def on_update
  @smf.next_delay(300)
end
```

### FmrbMidi::SmfPlayer#position_ms

<pre class="fmrb-sig"><code>position_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

今どこまで鳴ったか (千分の一秒)

```ruby
sec = @smf.position_ms / 1000
```

### FmrbMidi::SmfPlayer#channel_usage

<pre class="fmrb-sig"><code>channel_usage() -&gt; <a href="../Hash/">Hash</a></code></pre>

使っているチャンネルの様子

使われている channel だけが入る。中身は `[音符の数, 高さの合計]`。読み込んでいなければ空。
```ruby
@smf.channel_usage.each do |ch, a|
  puts ch.to_s + ": " + a[0].to_s
end
```

### FmrbMidi::SmfPlayer#tempo_scale

<pre class="fmrb-sig"><code>tempo_scale() -&gt; <a href="../Float/">Float</a></code></pre>

曲の速さの倍率

1.0 が楽譜どおりの速さ。
```ruby
s = @smf.tempo_scale
```

### FmrbMidi::SmfPlayer#tempo_scale=

<pre class="fmrb-sig"><code>tempo_scale=(<a href="../Float/">Float</a> value) -&gt; void</code></pre>

曲の速さの倍率を変える

0.001 から 100.0 まで。**鳴っている途中でも変えられる**。
```ruby
@smf.tempo_scale = 1.5
```

### FmrbMidi::SmfPlayer#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

読み込みに失敗した理由

```ruby
msg = @smf.error
```

### FmrbMidi::SmfPlayer#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a>?</code></pre>

曲のファイルの場所

```ruby
name = @smf.path
```

### FmrbMidi::SmfPlayer#device

<pre class="fmrb-sig"><code>device() -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

鳴らす先のデバイス

```ruby
dev = @smf.device
```

### FmrbMidi::SmfPlayer#device=

<pre class="fmrb-sig"><code>device=(<a href="../MIDI__Device/">MIDI::Device</a> value) -&gt; void</code></pre>

鳴らす先のデバイスを切り替える

**鳴らしている最中でも変えられる**。古いデバイスで鳴っていた音は止まり、待ち行列に入れてあった分 (最大 0.3 秒) は捨てられる。内蔵音源と外の音源 (`FmrbMidi.sam2695_device`) の切り替えに使う。
```ruby
@smf.device = @serial
```

### FmrbMidi::SmfPlayer#lookahead_us

<pre class="fmrb-sig"><code>lookahead_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

先に待ち行列へ入れる長さ (µs)

内蔵音源やシリアルのデバイスでは既定で 300000 (`LOOKAHEAD_US`)。時間つきで受けられないデバイスでは 0。
```ruby
n = @smf.lookahead_us
```

### FmrbMidi::SmfPlayer#lookahead_us=

<pre class="fmrb-sig"><code>lookahead_us=(<a href="../Integer/">Integer</a> us) -&gt; void</code></pre>

先に待ち行列へ入れる長さを変える

単位は µs。**0 にすると送るのをアプリのタスクに戻す** (描画などで遅れたぶんだけ音がずれる。比べるときに使う)。0 より大きくしても、デバイスが時間つきで受けられない (スケジューラが無い) ときは 0 のまま。
**変えると待ち行列を捨てる**ので、鳴らす前に変える。
```ruby
@smf.lookahead_us = 0
```

### FmrbMidi::SmfPlayer#transpose

<pre class="fmrb-sig"><code>transpose() -&gt; <a href="../Integer/">Integer</a></code></pre>

全部の音に足す半音の数

0 が元のまま。**channel 9 (ドラム) は動かさない**。0〜127 を出る音も元の高さのまま。鳴らしている途中でも変えられ、次の音から効く
(鳴っている音は始めた高さで止める)。`load` で 0 に戻る。
```ruby
@smf.transpose = 2
```

### FmrbMidi::SmfPlayer#transpose=

<pre class="fmrb-sig"><code>transpose=(<a href="../Integer/">Integer</a> semitones) -&gt; void</code></pre>

半音の数を変える

`transpose` を見る。
```ruby
@smf.transpose = -12
```

### FmrbMidi::SmfPlayer#channel_mask

<pre class="fmrb-sig"><code>channel_mask() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

鳴らす channel の指定

nil なら全部。数なら、**ビット n が channel n** (0〜15) で、0 の
channel の音・つまみ・楽器の指定はすべて飛ばす。`load` で nil に戻る。
```ruby
m = @smf.channel_mask
```

### FmrbMidi::SmfPlayer#channel_mask=

<pre class="fmrb-sig"><code>channel_mask=(<a href="../Integer/">Integer</a>? mask) -&gt; void</code></pre>

鳴らす channel を指定する

`channel_mask` を見る。nil で全部。
```ruby
@smf.channel_mask = 0b101
```

### FmrbMidi::SmfPlayer#ignore_program_change

<pre class="fmrb-sig"><code>ignore_program_change() -&gt; bool</code></pre>

曲の楽器の指定を使わないか

true なら、曲の中の楽器の指定 (Program Change) を送らない。アプリで選んだ楽器を、曲が途中で上書きしないようにする。楽器を持つ外の音源にだけ効く (内蔵音源はどちらでも落とす)。`load` で false に戻る。
```ruby
@smf.ignore_program_change = true
```

### FmrbMidi::SmfPlayer#ignore_program_change=

<pre class="fmrb-sig"><code>ignore_program_change=(bool value) -&gt; void</code></pre>

曲の楽器の指定を使わないようにする

`ignore_program_change` を見る。
```ruby
@smf.ignore_program_change = false
```

### FmrbMidi::SmfPlayer#track_count

<pre class="fmrb-sig"><code>track_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

曲の中の track の数

読み込む前は 0。
```ruby
n = @smf.track_count
```

### FmrbMidi::SmfPlayer#division

<pre class="fmrb-sig"><code>division() -&gt; <a href="../Integer/">Integer</a></code></pre>

四分音符あたりの tick の数

見出しの値。読み込む前は 0。
```ruby
d = @smf.division
```

### FmrbMidi::SmfPlayer#format

<pre class="fmrb-sig"><code>format() -&gt; <a href="../Integer/">Integer</a></code></pre>

SMF の形式 (0 か 1)

読み込む前は 0。形式 2 は読めない。
```ruby
f = @smf.format
```

### FmrbMidi::SmfPlayer#late_count

<pre class="fmrb-sig"><code>late_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

送った出来事の数

`timing_stats` の events。
```ruby
n = @smf.late_count
```

### FmrbMidi::SmfPlayer#late_sum_ms

<pre class="fmrb-sig"><code>late_sum_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

遅れの合計 (ms)

早く送った分は 0 と数える。
```ruby
t = @smf.late_sum_ms
```

### FmrbMidi::SmfPlayer#late_max_ms

<pre class="fmrb-sig"><code>late_max_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

遅れの最大 (ms)

```ruby
t = @smf.late_max_ms
```

### FmrbMidi::SmfPlayer#stall_count

<pre class="fmrb-sig"><code>stall_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

予定をずらした回数

アプリが 200 ms 以上遅れたとき、遅れを一度に取り戻さず予定をずらす。
```ruby
n = @smf.stall_count
```

### FmrbMidi::SmfPlayer#underrun_count

<pre class="fmrb-sig"><code>underrun_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

音が途切れた回数

待ち行列が空なのに 5 ms 以上遅れた回数。
```ruby
n = @smf.underrun_count
```

### FmrbMidi::SmfPlayer#timing_stats

<pre class="fmrb-sig"><code>timing_stats() -&gt; <a href="../String/">String</a></code></pre>

送り具合の一行の報告

ログに出す文字列。何も送っていないうちは "no events yet"。スケジューラがあれば events・fired・avg_late・max_late・stalls・under・
q (待ち行列の深さ) などが並ぶ。
```ruby
Log.info(@smf.timing_stats)
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
