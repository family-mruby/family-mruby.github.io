# FmrbMidi

MIDI の入り口。音を出す口・曲・MML

使い方は [MIDI](../midi.md) のページにあります。

`FmrbMidi.device(self)` で内蔵音源 (APU) につながった口 (MIDI::Device) をもらい、
`note_on` などで音符を送る。標準 MIDI ファイルは `FmrbMidi::SmfPlayer`、MML は
`FmrbMidi::MmlPlayer` が鳴らす。外の音源へは `sam2695_device`・`serial_device` が口を作り、`register` で出し先を足す。曲の時間は `now_us` で測る。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`GM_DRUM_CHANNEL`</span> | [`Integer`](Integer.md) | ドラムの channel の番号 |

## クラスメソッド

### FmrbMidi.device

<pre class="fmrb-sig"><code>device(<a href="../FmrbApp/">FmrbApp</a> app) -&gt; <a href="../MIDI__Device/">MIDI::Device</a></code></pre>

このアプリ用の音を出す口を作る

**内蔵音源 (APU) につながった口**が返る。外の音源に出すなら出し先を `register` する。
```ruby
@midi = FmrbMidi.device(self)
@midi.note_on(60)
```

### FmrbMidi.now_us

<pre class="fmrb-sig"><code>now_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の時刻 (百万分の一秒)

音の予定を組むときの時計。**曲の時間はこれで測る** (描画の回数で数えると重いフレームで狂う)。
```ruby
t0 = FmrbMidi.now_us
```

### FmrbMidi.register

<pre class="fmrb-sig"><code>register(untyped transport) -&gt; untyped</code></pre>

音の出し先を登録する

同じものを二度足しても増えない。
```ruby
FmrbMidi.register(transport)
```

### FmrbMidi.unregister

<pre class="fmrb-sig"><code>unregister(untyped transport) -&gt; void</code></pre>

音の出し先の登録をやめる

```ruby
FmrbMidi.unregister(transport)
```

### FmrbMidi.transports

<pre class="fmrb-sig"><code>transports() -&gt; <a href="../Array/">Array</a></code></pre>

登録してある音の出し先の一覧

```ruby
FmrbMidi.transports.length
```

### FmrbMidi.gm_name

<pre class="fmrb-sig"><code>gm_name(<a href="../Integer/">Integer</a> program) -&gt; <a href="../String/">String</a>?</code></pre>

楽器の番号から名前を引く

0 から 127 まで。範囲の外は nil。名前は 16 字までに縮めてある
(0 番は "Ac Grand Piano")。
```ruby
FmrbMidi.gm_name(0)
#=> "Ac Grand Piano"
```

### FmrbMidi.sam2695_device

<pre class="fmrb-sig"><code>sam2695_device(
  ?path: <a href="../String/">String</a>,
  ?uart: <a href="../Integer/">Integer</a>,
  ?tx: <a href="../Integer/">Integer</a>,
  ?rx: <a href="../Integer/">Integer</a>,
  ?baud: <a href="../Integer/">Integer</a>
) -&gt; <a href="../MIDI__Device/">MIDI::Device</a>?</code></pre>

外の音源 (SAM2695) の口を作る

M5Stack Unit MIDI など。シリアルで MIDI を送る (31250 baud)。
**つながらなければ nil** (sim では受け皿の FIFO が無いとき、実機では端末に MIDI の出口が無いときやピンが使われているとき)。
nil のまま使うと NoMethodError なので、必ず確かめる。つなぐたびに音源へ GM System On を送り全 channel を止めるので、
**一度だけ作って持っておく**。内蔵音源の口 (`FmrbMidi.device`) とは別物で、`SmfPlayer#device=` で切り替える。
`path:` (sim だけ)・`uart:`・`tx:` (実機だけ)・`rx:` (省略すると -1 =
送るだけ)・`baud:` (省略すると 31250)。省略した分は端末の既定。
```ruby
@serial = FmrbMidi.sam2695_device
@serial.program_change(0) if @serial
```

### FmrbMidi.serial_device

<pre class="fmrb-sig"><code>serial_device(
  ?path: <a href="../String/">String</a>,
  ?uart: <a href="../Integer/">Integer</a>,
  ?tx: <a href="../Integer/">Integer</a>,
  ?rx: <a href="../Integer/">Integer</a>,
  ?baud: <a href="../Integer/">Integer</a>
) -&gt; <a href="../MIDI__Device/">MIDI::Device</a>?</code></pre>

シリアルの MIDI の口を作る

`sam2695_device` と同じで、音源のリセットを送らない版。**つながらなければ nil**。引数も同じ (`path:` `uart:` `tx:` `rx:` `baud:`、省略すると端末の既定)。
```ruby
@out = FmrbMidi.serial_device
@out.note_on(60) if @out
```

### FmrbMidi.scheduler

<pre class="fmrb-sig"><code>scheduler() -&gt; untyped</code></pre>

音の時間割を預かる係を返す

曲の音は、時刻をつけて C の待ち行列へ渡され、タイマーがその時刻に送る。この係が**その行列**。アプリが見るのは有無だけで、中の `_` で始まるメソッドは使わない。**無ければ nil** (ホストの試験)。
```ruby
puts FmrbMidi.scheduler ? "yes" : "no"
```

### FmrbMidi.tick

<pre class="fmrb-sig"><code>tick() -&gt; void</code></pre>

予定した音の止め時を見る

`MIDI::Device#trigger` の音を止めるのはこれ。毎回の `on_update` で 1 回呼ぶ。呼ばないと、trigger の音は次の MIDI メッセージまで鳴りっぱなし。内蔵音源 (`FmrbMidi.device`) もシリアルも、作った口は全部ここで見る。
```ruby
def on_update
  FmrbMidi.tick
  FmrbMidi.tick_delay(100)
end
```

### FmrbMidi.tick_delay

<pre class="fmrb-sig"><code>tick_delay(<a href="../Integer/">Integer</a> default_ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

寝てよい時間 (千分の一秒)

渡した待ち時間と、予定した音の止め時までの短いほうを返す。
`on_update` の戻り値にすると、短い音が長く鳴らない。返るのは ms。
0 より小さくはならない。
```ruby
def on_update
  FmrbMidi.tick
  FmrbMidi.tick_delay(200)
end
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
