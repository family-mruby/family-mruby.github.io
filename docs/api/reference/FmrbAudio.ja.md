# FmrbAudio

音を鳴らす。曲・効果音・WAV・マイク

使い方は [音声](../audio.md) のページにあります。

アプリは `@audio = FmrbAudio.new(self)` で作る。NSF の曲は `play` (止めるのは `stop`、一時停止は `pause`・`resume`)、WAV は `play_wav`、音を 1 つずつなら `note_on`・`note_off`、
FMSQ のデータは `load_fmsq` で読んで `play_slot`。マイクは `mic_available?` で調べて
`mic_enable`・`mic_read` で読む。MIDI の音符を送るなら FmrbMidi。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`NSF_IDLE`</span> | [`Integer`](Integer.md) | state 0: 曲が無い・命令で止めた |
| <span class="fmrb-name">`NSF_PLAYING`</span> | [`Integer`](Integer.md) | state 1: 鳴っている |
| <span class="fmrb-name">`NSF_FADING`</span> | [`Integer`](Integer.md) | state 2: 終わりを見つけて小さくしている |
| <span class="fmrb-name">`NSF_ENDED`</span> | [`Integer`](Integer.md) | state 3: 曲が自分で終わった |
| <span class="fmrb-name">`NSF_END_SILENCE`</span> | [`Integer`](Integer.md) | reason 1: 無音で終わった |
| <span class="fmrb-name">`NSF_END_LOOP`</span> | [`Integer`](Integer.md) | reason 2: ループを聞き終えて終わった |
| <span class="fmrb-name">`NSF_END_LIMIT`</span> | [`Integer`](Integer.md) | reason 3: 時間の上限で終わった |
| <span class="fmrb-name">`MAIN`</span> | [`Integer`](Integer.md) | 長い曲を置く APU (0) |
| <span class="fmrb-name">`SUB`</span> | [`Integer`](Integer.md) | 効果音の APU (1) |
| <span class="fmrb-name">`CH_PULSE1`</span> | [`Integer`](Integer.md) | 矩形波 1 の channel (0) |
| <span class="fmrb-name">`CH_PULSE2`</span> | [`Integer`](Integer.md) | 矩形波 2 の channel (1) |
| <span class="fmrb-name">`CH_TRIANGLE`</span> | [`Integer`](Integer.md) | 三角波の channel (2) |
| <span class="fmrb-name">`CH_NOISE`</span> | [`Integer`](Integer.md) | ノイズの channel (3) |

## 型

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`nsf_status`</span> | `{ state: uint8, reason: uint8, track: uint8, laps: uint8, gen: uint16, period: uint16, frames: uint32 }` | nsf_status が返す曲のようす |

## クラスメソッド

### FmrbAudio.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbApp/">FmrbApp</a> app) -&gt; FmrbAudio</code></pre>

音の係を作る

```ruby
@audio = FmrbAudio.new(self)
```

## インスタンスメソッド

### FmrbAudio#play

<pre class="fmrb-sig"><code>play(<a href="../String/">String</a> path, ?track: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

曲のファイルを鳴らす

NSF を鳴らす。曲は /usr/share/sounds/nsf にある。`track:` (省略すると 0) は
NSF の中の曲の番号。
```ruby
@audio.play("/usr/share/sounds/nsf/test.nsf")
```

### FmrbAudio#play_raw

<pre class="fmrb-sig"><code>play_raw(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> track) -&gt; void</code></pre>

play の省略なしの形

引数を省略できない単純な形。track は NSF の中の曲の番号 (0 から)。包みは play (track: を省くと 0)。
```ruby
@audio.play_raw("/usr/share/sounds/nsf/test.nsf", 0)
```

### FmrbAudio#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

曲を止める

```ruby
@audio.stop
```

### FmrbAudio#nsf_status

<pre class="fmrb-sig"><code>nsf_status() -&gt; nsf_status?</code></pre>

曲がどこまで進んだかを聞く

NSF には長さが無いので、音の側が曲の終わりを決める (無音・ループを
2 周・時間の上限)。終わった曲は音の側で止まる。1 秒に 1 回ほど聞いて、終わっていたら次の曲へ進む。答えが無いときは nil。
```ruby
st = @audio.nsf_status
next_song if st && st[:state] == FmrbAudio::NSF_ENDED
```

### FmrbAudio#mic_available?

<pre class="fmrb-sig"><code>mic_available?() -&gt; bool</code></pre>

マイクがあるか

ESP32-P4 の端末 (Tab5 など) だけ true。それ以外は false なので、呼ぶ前に端末を調べなくてよい。
```ruby
return unless @audio.mic_available?
```

### FmrbAudio#mic_rate

<pre class="fmrb-sig"><code>mic_rate() -&gt; <a href="../Integer/">Integer</a></code></pre>

マイクの標本化の速さ (Hz)

ESP32-P4 では 47160 (スピーカーと同じクロックで、選べない)。マイクの無い端末では 0。スペクトルの 1 本の幅 (Hz) はこれを標本の数で割る。
```ruby
hz = @audio.mic_rate
```

### FmrbAudio#mic_enable

<pre class="fmrb-sig"><code>mic_enable(?bool on) -&gt; bool</code></pre>

マイクを入れる・切る

`on` (省略すると true)。**読む前に入れ、使い終えたら `false` で切る**。成功したら true。マイクの無い端末や、立ち上げに失敗したときは false
(例外は出ない)。すでにその状態なら true。
```ruby
@audio.mic_enable
@audio.mic_enable(false)
```

### FmrbAudio#mic_read

<pre class="fmrb-sig"><code>mic_read(<a href="../Integer/">Integer</a> count, ?<a href="../Integer/">Integer</a> timeout_ms) -&gt; <a href="../String/">String</a>?</code></pre>

マイクの音を標本で読む

`count` 個 (1〜4096、外れると ArgumentError) の 16 ビット符号つき・リトルエンディアンの標本を、2 * count バイトの String で返す。そろうまで待つ (**止まる**)。`timeout_ms` (省略すると 200) は、ドライバが
256 個ほどずつ渡すその 1 回ごとの待ち。そろわなかったときと、マイクが入っていない・無いときは nil (半端な長さは返さない)。
```ruby
bytes = @audio.mic_read(512, 300)
return if bytes.nil?
```

### FmrbAudio#pause

<pre class="fmrb-sig"><code>pause() -&gt; void</code></pre>

曲をいったん止める

```ruby
@audio.pause
```

### FmrbAudio#resume

<pre class="fmrb-sig"><code>resume() -&gt; void</code></pre>

止めた曲の続きを鳴らす

```ruby
@audio.resume
```

### FmrbAudio#load_fmsq

<pre class="fmrb-sig"><code>load_fmsq(<a href="../Integer/">Integer</a> slot_id, bin binary_data) -&gt; void</code></pre>

曲のデータを箱に入れる

曲を枠に読み込む。**鳴らすのは play_slot**。
```ruby
data = File.open(path, "r") { |f| f.read }
@audio.load_fmsq(0, data)
```

### FmrbAudio#load_fmsq_file

<pre class="fmrb-sig"><code>load_fmsq_file(<a href="../Integer/">Integer</a> slot_id, <a href="../String/">String</a> path) -&gt; void</code></pre>

曲のファイルを箱に読み込む

```ruby
@audio.load_fmsq_file(0,
  "/usr/share/music/round.mml")
```

### FmrbAudio#play_slot

<pre class="fmrb-sig"><code>play_slot(<a href="../Integer/">Integer</a> slot_id, ?instance: <a href="../Integer/">Integer</a>) -&gt; void</code></pre>

箱に入れた曲を鳴らす

`instance:` (省略すると MAIN) は鳴らす APU で、`FmrbAudio::MAIN` か `FmrbAudio::SUB`。
```ruby
@audio.play_slot(0)
```

### FmrbAudio#play_slot_raw

<pre class="fmrb-sig"><code>play_slot_raw(<a href="../Integer/">Integer</a> slot_id, <a href="../Integer/">Integer</a> instance) -&gt; void</code></pre>

play_slot の省略なしの形

引数を省略できない単純な形。instance は鳴らす APU で、MAIN (0) か SUB (1)。長い曲は MAIN、短い効果音は SUB に置くと、効果音が曲を切らない。包みは play_slot (instance: を省くと MAIN)。
```ruby
@audio.play_slot_raw(0, FmrbAudio::SUB)
```

### FmrbAudio#main_volume=

<pre class="fmrb-sig"><code>main_volume=(<a href="../Integer/">Integer</a> percent) -&gt; void</code></pre>

曲 (MAIN) だけの音量を変える

0〜100 (%)、最初は 100。play と MAIN の play_slot の曲だけが変わり、効果音 (SUB)・WAV・端末の音量はそのまま。アプリを閉じると 100 に戻る。
```ruby
@audio.main_volume = 30
```

### FmrbAudio#play_wav

<pre class="fmrb-sig"><code>play_wav(<a href="../String/">String</a> path) -&gt; bool</code></pre>

録音した音 (WAV) を鳴らす

モノラル・8000〜48000Hz・2MB まで。PCM 16bit か IMA-ADPCM 4bit。APU の音に重ねて鳴る。一度に鳴らせるのは 1 本で、鳴っている間にもう一度呼ぶと入れ替わる。
Retro では鳴らせないので false を返す (鳴ったときは true)。
```ruby
ok = @audio.play_wav("/home/a.wav")
# Retro では false
```

### FmrbAudio#stop_wav

<pre class="fmrb-sig"><code>stop_wav() -&gt; bool</code></pre>

鳴っている WAV を止める

```ruby
@audio.stop_wav
```

### FmrbAudio#note_on

<pre class="fmrb-sig"><code>note_on(
  <a href="../Integer/">Integer</a> channel,
  <a href="../Integer/">Integer</a> freq,
  ?<a href="../Integer/">Integer</a> volume,
  ?<a href="../Integer/">Integer</a> duty,
  ?<a href="../Integer/">Integer</a> sweep
) -&gt; void</code></pre>

音を一つ鳴らす

周波数を Hz で渡す。曲を鳴らしている最中でも重なる。
`volume` (省略すると 10) は 0〜15、`duty` (省略すると 2) は矩形波の幅 0〜3、
`sweep` (省略すると 0)。
```ruby
@audio.note_on(0, 440)
```

### FmrbAudio#note_on_raw

<pre class="fmrb-sig"><code>note_on_raw(
  <a href="../Integer/">Integer</a> channel,
  <a href="../Integer/">Integer</a> freq,
  <a href="../Integer/">Integer</a> volume,
  <a href="../Integer/">Integer</a> duty,
  <a href="../Integer/">Integer</a> sweep
) -&gt; void</code></pre>

note_on の省略なしの形

引数を省略できない単純な形。曲の中で何度も鳴らすような、速さが要る所で使う。volume は 0〜15 (包みは 10)、duty は矩形波の幅 0〜3 (包みは 2)、
sweep は 0 (包みと同じ)。包みは note_on。
```ruby
@audio.note_on_raw(0, 440, 10, 2, 0)
```

### FmrbAudio#note_off

<pre class="fmrb-sig"><code>note_off(<a href="../Integer/">Integer</a> channel) -&gt; void</code></pre>

鳴っている音を止める

```ruby
@audio.note_off(0)
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
