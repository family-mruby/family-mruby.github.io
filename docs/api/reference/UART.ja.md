# UART

シリアル (UART) で外の機器とやりとりする

使い方は [ハードウェア制御](../peripherals.md) のページにあります。

上流の PicoRuby と同じ書き方のクラス。`UART.new` で開き、`puts`・`write` で送り、
`gets`・`read` で受ける。**読む側は待たない**: まだ届いていなければ nil を返すので、
`on_update` の中で毎回呼ぶ。`write` だけは送り終わるまで待つ。

開ける番号 (`unit:`) とピンは機種で違う (番号は `UART0` などの数字):

| 機種 | アプリが開ける番号 | 端子の例 |
|---|---|---|
| Tab5 | 1・2・3・4 | Grove の G53・G54 |
| NARYA v4 (P4-Nano) | 1・2・3・4 | 拡張のピンヘッダ |
| AtomS3R・StickS3 | 1・2 | Grove |
| NARYA v3 | 2 | GROVE 2 の 47・48 |
| Linux sim | 2 (偽物) | 47・48 など |

UART0 (コンソール) と NARYA v3 の UART1 (描画側とのリンク) は本体の物で、開くと IOError。ブラウザ版・ネイティブ版には UART が無く、開くと IOError ("not available in this environment")。ピンは GPIO と同じ表で守る: システムのピン・ほかのアプリや I2C が使っているピンは IOError。
**シリアルの MIDI 出力と同時には使えない** (MIDI は一度開くと再起動まで UART2 と TX のピンを持つ)。アプリが終わると本体が閉じる。

Linux sim の UART は偽物: 書いた物がそのまま読める (ループバック)。プロジェクトの直下に
`uart2_in.fifo`・`uart2_out.fifo` があれば、そちらから読み、そちらへ書く。
```ruby
# 番号とピンは例 (Tab5 の Grove)
u = UART.new(unit: 1, txd_pin: 53,
  rxd_pin: 54, baudrate: 115200)
u.puts "hello"
line = u.gets   # 来ていなければ nil
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PARITY_NONE`</span> | [`Integer`](Integer.md) | パリティ無し |
| <span class="fmrb-name">`PARITY_EVEN`</span> | [`Integer`](Integer.md) | 偶数パリティ |
| <span class="fmrb-name">`PARITY_ODD`</span> | [`Integer`](Integer.md) | 奇数パリティ |
| <span class="fmrb-name">`FLOW_CONTROL_NONE`</span> | [`Integer`](Integer.md) | 流れの制御なし (使えるのはこれだけ) |
| <span class="fmrb-name">`FLOW_CONTROL_RTS_CTS`</span> | [`Integer`](Integer.md) | RTS/CTS の流れの制御 (この端末では使えない) |
| <span class="fmrb-name">`WRITE_MAX`</span> | [`Integer`](Integer.md) | 1 回の FmrbUart.write の上限 (バイト) |

## クラスメソッド

### UART.new

<pre class="fmrb-sig"><code>new(
  unit: <a href="../Integer/">Integer</a> | <a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>,
  ?txd_pin: <a href="../Integer/">Integer</a>,
  ?rxd_pin: <a href="../Integer/">Integer</a>,
  ?baudrate: <a href="../Integer/">Integer</a>,
  ?data_bits: <a href="../Integer/">Integer</a>,
  ?stop_bits: <a href="../Integer/">Integer</a>,
  ?parity: <a href="../Integer/">Integer</a>,
  ?flow_control: <a href="../Integer/">Integer</a>,
  ?rts_pin: <a href="../Integer/">Integer</a>,
  ?cts_pin: <a href="../Integer/">Integer</a>,
  ?rx_buffer_size: <a href="../Integer/">Integer</a>?
) -&gt; UART</code></pre>

UART を開く

`unit:` は番号 (`2`) か上流の名前 (`:ESP32_UART2`)。`txd_pin:`・`rxd_pin:` は GPIO の番号で、片方だけなら -1 (受けるだけ・送るだけ)。省略したときの値: `baudrate: 9600`、`data_bits: 8`、
`stop_bits: 1`、`parity: PARITY_NONE`、`rx_buffer_size: 4096`。`rts_pin:`・`cts_pin:` は使わない。

受けたバイトは開いている間だけ取る受信の箱 (`rx_buffer_size` バイト、16〜16384 の 2 のべき乗、
PSRAM) に入る。箱が一杯のときに届いたバイトは捨て、`dropped` で数える。

間違った引数は ArgumentError: 知らない名前 ("unknown unit")、その機種に無い番号・ピン、ピンが両方 -1、TX と RX が同じ、速さが 300〜5000000 の外、形式の誤り、箱の大きさ、
`FLOW_CONTROL_NONE` 以外。開けないときは IOError で理由が付く: 本体の番号
("UART0 is used by the system")、ほかのアプリが開いている、MIDI が使っている、システムのピン、入力だけの線 (チップの割り込みの線) を TX にした、ピンが使用中、この環境に無い。同じアプリが同じ番号を開き直すと、前の物を閉じてから開く (前の物は閉じた物になり、読み書きは IOError ("closed"))。
```ruby
# 番号とピンは例
u = UART.new(unit: 2, txd_pin: 47,
  rxd_pin: 48, baudrate: 115200)
```

## インスタンスメソッド

### UART#baudrate

<pre class="fmrb-sig"><code>baudrate() -&gt; <a href="../Integer/">Integer</a></code></pre>

速さ (ボー)

`UART.new` で頼んだ値か、`setmode` で変えた後の値。
```ruby
u.baudrate   #=> 115200
```

### UART#line_ending=

<pre class="fmrb-sig"><code>line_ending=(<a href="../String/">String</a> line_ending) -&gt; <a href="../String/">String</a></code></pre>

puts が足す行末を決める

`"\n"` (既定)・`"\r\n"`・`"\r"` のどれか。ほかは ArgumentError。`gets` の区切りは変わらず `"\n"`。
```ruby
u.line_ending = "\r\n"
```

### UART#puts

<pre class="fmrb-sig"><code>puts(<a href="../String/">String</a> str) -&gt; nil</code></pre>

1 行を送る (行末を足す)

文字列が行末 (`line_ending`) で終わっていなければ足す。nil を返す。
```ruby
u.puts "AT"
```

### UART#setmode

<pre class="fmrb-sig"><code>setmode(
  ?baudrate: <a href="../Integer/">Integer</a>?,
  ?data_bits: <a href="../Integer/">Integer</a>?,
  ?stop_bits: <a href="../Integer/">Integer</a>?,
  ?parity: <a href="../Integer/">Integer</a>?,
  ?flow_control: <a href="../Integer/">Integer</a>?,
  ?rts_pin: <a href="../Integer/">Integer</a>?,
  ?cts_pin: <a href="../Integer/">Integer</a>?
) -&gt; UART</code></pre>

速さと形式をまとめて変える

渡した物だけを変える。ただし形式 (`data_bits`・`stop_bits`・`parity`) は省くと
8・1・`PARITY_NONE` に戻る (上流と同じ)。流れの制御は `FLOW_CONTROL_NONE` だけ。速さが 300〜5000000 の外なら ArgumentError。
```ruby
u.setmode(baudrate: 9600)
```

### UART#set_flow_control

<pre class="fmrb-sig"><code>set_flow_control(
  <a href="../Integer/">Integer</a> flow_control,
  <a href="../Integer/">Integer</a> rts_pin,
  <a href="../Integer/">Integer</a> cts_pin
) -&gt; nil</code></pre>

流れの制御を決める (無しだけ)

`FLOW_CONTROL_NONE` のときだけ通る。ほかは ArgumentError。
```ruby
u.set_flow_control(
  UART::FLOW_CONTROL_NONE, -1, -1)
```

### UART#set_format

<pre class="fmrb-sig"><code>set_format(
  <a href="../Integer/">Integer</a>? data_bits,
  <a href="../Integer/">Integer</a>? stop_bits,
  <a href="../Integer/">Integer</a>? parity
) -&gt; UART?</code></pre>

データ・ストップ・パリティを変える

`data_bits` は 5〜8、`stop_bits` は 1 か 2、`parity` は `PARITY_*`。3 つとも nil なら何もしない (nil を返す)。一部だけ nil・範囲の外は ArgumentError。
```ruby
u.set_format(8, 1, UART::PARITY_EVEN)
```

### UART#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> len) -&gt; <a href="../String/">String</a>?</code></pre>

届いたバイトを読む (待たない)

`len` を渡すと、ちょうど `len` バイト。まだそれだけ届いていなければ nil (取らない)。省くと届いている分を全部。何も無ければ nil。文字列はバイト列 (`bytesize` で数える)。
```ruby
head = u.read(4)  # 4 バイトか nil
```

### UART#readpartial

<pre class="fmrb-sig"><code>readpartial(<a href="../Integer/">Integer</a> maxlen) -&gt; <a href="../String/">String</a>?</code></pre>

届いている分を maxlen バイトまで読む

何も無ければ nil。待たない。
```ruby
s = u.readpartial(256)
```

### UART#getbyte

<pre class="fmrb-sig"><code>getbyte() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

1 バイト読む (無ければ nil)

```ruby
b = u.getbyte
```

### UART#ungetbyte

<pre class="fmrb-sig"><code>ungetbyte(<a href="../Integer/">Integer</a> byte) -&gt; nil</code></pre>

1 バイトを受信の箱の先頭へ戻す

下の 8 ビットだけを戻す。次の `getbyte`・`read` がそれを返す。箱が一杯なら IOError
("rx buffer is full")。nil を返す。
```ruby
u.ungetbyte(0x41)
```

### UART#bytes_available

<pre class="fmrb-sig"><code>bytes_available() -&gt; <a href="../Integer/">Integer</a></code></pre>

読めるバイト数

```ruby
n = u.bytes_available
```

### UART#gets

<pre class="fmrb-sig"><code>gets() -&gt; <a href="../String/">String</a>?</code></pre>

1 行読む ("\n" まで、待たない)

`"\n"` が届いていれば、それを含めた 1 行。まだなら nil (取らない)。`line_ending` によらず区切りは `"\n"`。受信の箱より長い行は返らない (箱が一杯になり、後のバイトが捨てられる)。
```ruby
line = u.gets
```

### UART#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

バイト列を送る (送り終わるまで待つ)

送ったバイト数を返す。長い文字列は 4096 バイトずつ分けて送る。
```ruby
u.write("AT\r\n")
```

### UART#putc

<pre class="fmrb-sig"><code>putc(<a href="../Integer/">Integer</a> | <a href="../String/">String</a> ch) -&gt; (<a href="../Integer/">Integer</a> | <a href="../String/">String</a>)</code></pre>

1 文字か 1 バイトを送る

整数は下の 8 ビット、文字列は最初の 1 文字 (UTF-8 の 1 文字)。渡した物を返す。ほかの型は TypeError。
```ruby
u.putc(0x41)   # "A"
```

### UART#flush

<pre class="fmrb-sig"><code>flush() -&gt; UART</code></pre>

送った物が出きるまで待つ

長くて 1 秒待つ。
```ruby
u.flush
```

### UART#clear_rx_buffer

<pre class="fmrb-sig"><code>clear_rx_buffer() -&gt; UART</code></pre>

受信の箱を空にする

```ruby
u.clear_rx_buffer
```

### UART#clear_tx_buffer

<pre class="fmrb-sig"><code>clear_tx_buffer() -&gt; UART</code></pre>

送信の箱を空にする (何もしない)

一度渡したバイトは取り消せない (上流の ESP32 版と同じ)。
```ruby
u.clear_tx_buffer
```

### UART#break

<pre class="fmrb-sig"><code>break(?<a href="../Float/">Float</a> | <a href="../Integer/">Integer</a> time) -&gt; UART</code></pre>

ブレークを送る (TX を低く保つ)

`time` は Float なら秒、Integer なら ms (上流と同じ)。省くと 100 ms。その間待つ。
10 秒より長いと ArgumentError、ほかの型は TypeError。Linux sim では何もしない。
```ruby
u.break(0.05)   # 50 ms
```

### UART#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

受信の箱が一杯で捨てたバイト数

開いてからの合計。増えるなら、もっと頻繁に読むか `rx_buffer_size` を大きくする。
```ruby
lost = u.dropped
```

### UART#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じてピンを返す

2 回目からは何もしない。閉じた後の読み書きは IOError ("closed")。閉じなくてもアプリが終われば本体が閉じる。
```ruby
u.close
```

### UART#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

閉じたか

```ruby
u.closed?   #=> false
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
