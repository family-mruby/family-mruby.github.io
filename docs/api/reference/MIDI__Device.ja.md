# MIDI::Device

音を出す口。音符や音色をここへ送る

使い方は [MIDI](../midi.md) のページにあります。

## クラスメソッド

### MIDI::Device.new

<pre class="fmrb-sig"><code>new(untyped transport) -&gt; MIDI::Device</code></pre>

音を出す口を作る

transport は MIDI を送る相手で、`send_packet(cable, cin, b1, b2, b3)`・
`read_available`・`bytes_available`・`connected?` を持つ (`info` には
`device_info`、`trigger` には `transport_id` も使う)。内蔵音源と外の音源の口は `FmrbMidi.device` と `FmrbMidi.sam2695_device` が作る。自分の送り先で `trigger` を使うなら、`FmrbMidi.register` で登録し、
`@pending = []` と `note_on(channel, note, velocity)`・
`note_off(channel, note)` を用意して `FmrbMidi::NoteScheduler` を
include する。
```ruby
dev = MIDI::Device.new(MyTransport.new)
```

## インスタンスメソッド

### MIDI::Device#transport

<pre class="fmrb-sig"><code>transport() -&gt; untyped</code></pre>

送り先 (transport)

内蔵音源の口なら `FmrbMidi::ApuTransport`。`all_off`・`auto_map`・
`map_channel` はここから呼ぶ。
```ruby
@device.transport.all_off
```

### MIDI::Device#note_on

<pre class="fmrb-sig"><code>note_on(<a href="../Integer/">Integer</a> note, ?<a href="../Integer/">Integer</a> velocity, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音を鳴らす

**強さと channel は省ける** (127、0)。60 が真ん中のド。止めるのは `note_off`。
```ruby
dev.note_on(60)
dev.note_on(64, 100, channel: 1)
```

### MIDI::Device#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> note, ?<a href="../Integer/">Integer</a> velocity, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音を止める

**鳴らしたのと同じ channel へ送る**。違う channel だと止まらない。
```ruby
dev.note_off(60)
dev.note_off(64, 0, channel: 1)
```

### MIDI::Device#pitch_bend

<pre class="fmrb-sig"><code>pitch_bend(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音の高さをずらす

-8192 から 8191。0 が元の高さ。
```ruby
dev.pitch_bend(2048)
dev.pitch_bend(0)
```

### MIDI::Device#program_change

<pre class="fmrb-sig"><code>program_change(<a href="../Integer/">Integer</a> program, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

楽器をえらぶ

0 から 127。番号と名前は `FmrbMidi.gm_name` で引ける。
```ruby
dev.program_change(48, channel: 1)
```

### MIDI::Device#control_change

<pre class="fmrb-sig"><code>control_change(<a href="../Integer/">Integer</a> cc, <a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

つまみの値を送る

よく使うつまみには `volume` `pan` などの近道がある。
```ruby
dev.control_change(74, 64, channel: 0)
```

### MIDI::Device#volume

<pre class="fmrb-sig"><code>volume(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音の大きさを決める

0 から 127 (CC 7)。
```ruby
dev.volume(90, channel: 0)
```

### MIDI::Device#pan

<pre class="fmrb-sig"><code>pan(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

左右のどちらから出すか

0 が左、64 が中、127 が右 (CC 10)。
```ruby
dev.pan(0)
```

### MIDI::Device#modulation

<pre class="fmrb-sig"><code>modulation(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

ゆれ (ビブラート) の深さ

0 から 127 (CC 1)。
```ruby
dev.modulation(40)
```

### MIDI::Device#expression

<pre class="fmrb-sig"><code>expression(<a href="../Integer/">Integer</a> value, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音の強さの変化

`volume` とは別の口 (CC 11)。曲中の強弱はこちらで付ける。
```ruby
dev.expression(100)
```

### MIDI::Device#sustain

<pre class="fmrb-sig"><code>sustain(bool on_off, ?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

ペダルを踏むか離すか

**true / false を渡す** (CC 64)。
```ruby
dev.sustain(true)
dev.sustain(false)
```

### MIDI::Device#trigger

<pre class="fmrb-sig"><code>trigger(
  <a href="../Integer/">Integer</a> note,
  ?<a href="../Integer/">Integer</a> velocity,
  ?duration: <a href="../Integer/">Integer</a>,
  ?channel: <a href="../Integer/">Integer</a>
) -&gt; void</code></pre>

決まった長さだけ音を鳴らす

**長さを渡すと止める予約が入る**。すぐ戻るので、複数の音を同時に始められる (`note_on` と待ちの組ではずれる)。`duration:` は ms で、省略すると 100。**実際に止めるのは `FmrbMidi.tick`** なので、
`on_update` で呼び続ける (呼ばないと次の MIDI メッセージまで鳴る)。
```ruby
dev.trigger(60, 100, duration: 200)
```

### MIDI::Device#trigger_batch

<pre class="fmrb-sig"><code>trigger_batch(<a href="../Array/">Array</a> events) -&gt; <a href="../Integer/">Integer</a></code></pre>

まとめて音を鳴らす

和音を**マイクロ秒の差**で鳴らす。`:note_on` だけが対象で、
`duration_ms` で止まる。
```ruby
dev.trigger_batch([
  {type: :note_on, channel: 0,
   note: 60, velocity: 100,
   duration_ms: 200}])
```

### MIDI::Device#all_notes_off

<pre class="fmrb-sig"><code>all_notes_off(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

鳴っている音をぜんぶ止める

**channel ごと**なので、使った channel の数だけ呼ぶ。
```ruby
dev.all_notes_off(channel: 0)
```

### MIDI::Device#all_sound_off

<pre class="fmrb-sig"><code>all_sound_off(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

音をすぐにぜんぶ止める

余韻ごと切る。`all_notes_off` は余韻を残す。
```ruby
dev.all_sound_off(channel: 0)
```

### MIDI::Device#reset_all_controllers

<pre class="fmrb-sig"><code>reset_all_controllers(?channel: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

つまみをぜんぶ元に戻す

```ruby
dev.reset_all_controllers(channel: 0)
```

### MIDI::Device#send_clock

<pre class="fmrb-sig"><code>send_clock() -&gt; void</code></pre>

拍を知らせる合図を送る

外の機械と拍を合わせるとき、四分音符あたり 24 回送る。
```ruby
dev.send_clock
```

### MIDI::Device#send_start

<pre class="fmrb-sig"><code>send_start() -&gt; void</code></pre>

始まりの合図を送る

```ruby
dev.send_start
```

### MIDI::Device#send_stop

<pre class="fmrb-sig"><code>send_stop() -&gt; void</code></pre>

終わりの合図を送る

```ruby
dev.send_stop
```

### MIDI::Device#send_continue

<pre class="fmrb-sig"><code>send_continue() -&gt; void</code></pre>

続きの合図を送る

```ruby
dev.send_continue
```

### MIDI::Device#send_sysex

<pre class="fmrb-sig"><code>send_sysex(<a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] data, ?wrap: bool) -&gt; void</code></pre>

機器ごとの特別なデータを送る

**整数の配列**を渡す (文字列ではない)。**F0 で始めて F7 で終える**か、
`wrap: true` (省略すると false) で F0・F7 を足させる。
```ruby
dev.send_sysex([0x7E, 0x7F, 0x09, 0x01],
               wrap: true)
```

### MIDI::Device#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

つながっているかどうか

```ruby
return unless dev.connected?
```

### MIDI::Device#info

<pre class="fmrb-sig"><code>info() -&gt; <a href="../Hash/">Hash</a></code></pre>

つないだ機器の名前など

```ruby
dev.info[:name]
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
