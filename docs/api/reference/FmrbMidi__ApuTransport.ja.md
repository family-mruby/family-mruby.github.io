# FmrbMidi::ApuTransport

内蔵音源 (APU) へ MIDI を送る口

使い方は [MIDI](../midi.md) のページにあります。

`FmrbMidi.device(self)` が作る。

APU の声は 4 つ (矩形波 2・三角波・ノイズ) で、1 つの声は 1 度に
1 つの音しか出せない。channel 0・1・2・9 が順に矩形波 1・2・三角波・ノイズに当たり、**ほかの channel は鳴らない** (`map_channel`・`auto_map`
で変える)。楽器の指定・ピッチベンド・SysEx は受けて捨てる。声は SUB 側の APU を使うので、`play_slot` の SUB の効果音とぶつかる。

## クラスメソッド

### FmrbMidi::ApuTransport.new

<pre class="fmrb-sig"><code>new(untyped owner) -&gt; ApuTransport</code></pre>

内蔵音源の口を作る

owner はアプリ (`self`) か `FmrbAudio`。作ると自分を `FmrbMidi.register`
する。ふつうは `FmrbMidi.device(self)` が作るので、直接は作らない。
```ruby
audio = FmrbAudio.new(self)
apu = FmrbMidi::ApuTransport.new(audio)
```

## インスタンスメソッド

### FmrbMidi::ApuTransport#note_on

<pre class="fmrb-sig"><code>note_on(<a href="../Integer/">Integer</a> channel, <a href="../Integer/">Integer</a> note, <a href="../Integer/">Integer</a> velocity) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

音を鳴らす

`MIDI::Device#note_on` を通さない直接の形。channel に声が割り当ててなければ何もせず nil。同じ声に重ねると新しい音が鳴り、離すと押さえたままの前の音へ戻る。
```ruby
apu.note_on(0, 60, 100)
```

### FmrbMidi::ApuTransport#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> channel, <a href="../Integer/">Integer</a> note) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

音を止める

声が割り当ててない channel や、今鳴っていない音なら nil。
```ruby
apu.note_off(0, 60)
```

### FmrbMidi::ApuTransport#defer_voices

<pre class="fmrb-sig"><code>defer_voices(?<a href="../Integer/">Integer</a> due_us) -&gt; void</code></pre>

同じ瞬間の音をひとまとめにし始める

和音のように**同じ瞬間の複数のメッセージ**を送る前に呼び、送り終えたら
`flush_voices`。間は声の状態だけが変わり、`flush_voices` が各声の最後の状態を 1 度だけ送る (和音の内側の音が順に鳴るのを防ぐ)。
`due_us` (省略すると今) は `FmrbMidi.now_us` の時計の時刻で、その時刻に送る。**閉じ忘れると以後の音が鳴らない**ので、`FmrbMidi.tick` が毎回閉じる。すでに開いていれば何もしない。
```ruby
apu.defer_voices
apu.note_on(0, 60, 100)
apu.flush_voices
```

### FmrbMidi::ApuTransport#flush_voices

<pre class="fmrb-sig"><code>flush_voices() -&gt; void</code></pre>

ひとまとめを閉じて送る

`defer_voices` で開けたものを閉じる。開けていなければ何もしない。
```ruby
apu.flush_voices
```

### FmrbMidi::ApuTransport#all_off

<pre class="fmrb-sig"><code>all_off() -&gt; void</code></pre>

全部の音を止める

全 channel を止め、予約した note off も捨てる。
```ruby
@device.transport.all_off
```

### FmrbMidi::ApuTransport#auto_map

<pre class="fmrb-sig"><code>auto_map(<a href="../Hash/">Hash</a> usage) -&gt; <a href="../Array/">Array</a></code></pre>

曲の使い方から声を割り当てる

`SmfPlayer#channel_usage` の結果を渡す。channel 9 はノイズ、音符が多い上位 3 つが平均の高さの高い順に矩形波 1・2・三角波になる。
**それまでの割り当ては全部消える**。usage が空だと全 channel が鳴らなくなる。戻りは新しい割り当て。
```ruby
usage = @smf.channel_usage
@device.transport.auto_map(usage)
```

### FmrbMidi::ApuTransport#map_channel

<pre class="fmrb-sig"><code>map_channel(<a href="../Integer/">Integer</a> channel, untyped voice) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

channel を声に結びつける

voice は `:pulse1` `:pulse2` `:triangle` `:noise` か 0〜3、nil ならその channel は鳴らさない。channel は 0〜15 の整数で、そうでなければ何もせず nil。その channel で鳴っていた音は止まる。
```ruby
@device.transport.map_channel(1, :pulse2)
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
