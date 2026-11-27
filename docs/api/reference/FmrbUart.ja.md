# FmrbUart

アプリの UART の境界の関数

使い方は [ハードウェア制御](../peripherals.md) のページにあります。

`UART` クラスの下の層。番号 (`unit`) で呼び、開いたアプリだけが使える (ほかのアプリの番号は RuntimeError)。Ruby のアプリはふつう `UART` を使う。ほかの言語 (C・Lua・
MicroPython・wasm) はこの形がそのまま見える。読む関数は待たない。`unit_mask` でその端末が開ける番号を先に確かめられる (ブラウザ版・ネイティブ版は 0)。
```ruby
r = FmrbUart.open(2, 47, 48, 115200,
                  8, 1, 0, 4096)
FmrbUart.write(2, "hi\n") if r == 0
```

## クラスメソッド

### FmrbUart.open

<pre class="fmrb-sig"><code>open(
  <a href="../Integer/">Integer</a> unit,
  <a href="../Integer/">Integer</a> txd_pin,
  <a href="../Integer/">Integer</a> rxd_pin,
  <a href="../Integer/">Integer</a> baudrate,
  <a href="../Integer/">Integer</a> data_bits,
  <a href="../Integer/">Integer</a> stop_bits,
  <a href="../Integer/">Integer</a> parity,
  <a href="../Integer/">Integer</a> rx_buffer_size
) -&gt; <a href="../Integer/">Integer</a></code></pre>

UART を開く (0 で成功、ほかは理由の番号)

引数は全部要る (`parity` は 0 無し・1 偶数・2 奇数、`rx_buffer_size` は 16〜16384 の
2 のべき乗)。ピンの片方は -1 でよい。答えの番号 (下位 8 ビット): 1 番号が無い・2 ピンが無い・
3 ピンが両方 -1・4 TX と RX が同じ・5 速さ・6 形式・7 箱の大きさ (ここまで引数の誤り)、
8 本体の番号・9 ほかのアプリが使用中・10 MIDI が使用中・11 システムのピン・12 入力だけの線を
TX に・13 ピンが使用中・14 開けなかった・15 この環境に無い。ピンについての答えは次のバイトにどちらか (1 TX、2 RX) が入る (`r >> 8`)。
```ruby
r = FmrbUart.open(2, 47, 48, 9600,
                  8, 1, 0, 4096)
```

### FmrbUart.close

<pre class="fmrb-sig"><code>close(<a href="../Integer/">Integer</a> unit) -&gt; bool</code></pre>

閉じてピンを返す (閉じたら true)

自分が開いていない番号なら false。
```ruby
FmrbUart.close(2)
```

### FmrbUart.read

<pre class="fmrb-sig"><code>read(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> max) -&gt; bin</code></pre>

届いた分を max バイトまで読む (待たない)

無ければ空の文字列。C などで呼ぶ側の箱が答えより小さいと、何も取らずに全体の長さを返し、次にその長さの箱で呼ぶと同じバイトを取る。
```ruby
s = FmrbUart.read(2, 64)
```

### FmrbUart.read_line

<pre class="fmrb-sig"><code>read_line(<a href="../Integer/">Integer</a> unit) -&gt; bin?</code></pre>

"\n" まで 1 行読む (無ければ nil)

`"\n"` を含めて返す。まだ届いていなければ nil で、何も取らない。
```ruby
line = FmrbUart.read_line(2)
```

### FmrbUart.write

<pre class="fmrb-sig"><code>write(<a href="../Integer/">Integer</a> unit, bin data) -&gt; <a href="../Integer/">Integer</a></code></pre>

送る (4096 バイトまで、待つ)

送ったバイト数を返す。4096 バイトより長いと ArgumentError (`UART#write` は分けて送る)。
```ruby
FmrbUart.write(2, "AT\r\n")
```

### FmrbUart.bytes_available

<pre class="fmrb-sig"><code>bytes_available(<a href="../Integer/">Integer</a> unit) -&gt; <a href="../Integer/">Integer</a></code></pre>

読めるバイト数

```ruby
n = FmrbUart.bytes_available(2)
```

### FmrbUart.unget

<pre class="fmrb-sig"><code>unget(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> byte) -&gt; bool</code></pre>

1 バイトを先頭へ戻す (一杯なら false)

```ruby
FmrbUart.unget(2, 0x41)
```

### FmrbUart.flush

<pre class="fmrb-sig"><code>flush(<a href="../Integer/">Integer</a> unit) -&gt; bool</code></pre>

送った物が出きるまで待つ (1 秒まで)

出きったら true、待ちきれなければ false。
```ruby
FmrbUart.flush(2)
```

### FmrbUart.clear_rx

<pre class="fmrb-sig"><code>clear_rx(<a href="../Integer/">Integer</a> unit) -&gt; void</code></pre>

受信の箱を空にする

```ruby
FmrbUart.clear_rx(2)
```

### FmrbUart.clear_tx

<pre class="fmrb-sig"><code>clear_tx(<a href="../Integer/">Integer</a> unit) -&gt; void</code></pre>

送信の箱を空にする (何もしない)

```ruby
FmrbUart.clear_tx(2)
```

### FmrbUart.send_break

<pre class="fmrb-sig"><code>send_break(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> ms) -&gt; void</code></pre>

ブレークを ms ミリ秒送る

0〜10000。その間待つ。Linux sim では何もしない。
```ruby
FmrbUart.send_break(2, 100)
```

### FmrbUart.set_baudrate

<pre class="fmrb-sig"><code>set_baudrate(<a href="../Integer/">Integer</a> unit, <a href="../Integer/">Integer</a> baudrate) -&gt; <a href="../Integer/">Integer</a></code></pre>

速さを変える (実際の速さを返す)

300〜5000000 の外は ArgumentError。
```ruby
FmrbUart.set_baudrate(2, 9600)
```

### FmrbUart.set_format

<pre class="fmrb-sig"><code>set_format(
  <a href="../Integer/">Integer</a> unit,
  <a href="../Integer/">Integer</a> data_bits,
  <a href="../Integer/">Integer</a> stop_bits,
  <a href="../Integer/">Integer</a> parity
) -&gt; bool</code></pre>

データ・ストップ・パリティを変える

範囲の外は ArgumentError。
```ruby
FmrbUart.set_format(2, 8, 1, 0)
```

### FmrbUart.dropped

<pre class="fmrb-sig"><code>dropped(<a href="../Integer/">Integer</a> unit) -&gt; <a href="../Integer/">Integer</a></code></pre>

受信の箱が一杯で捨てたバイト数

```ruby
FmrbUart.dropped(2)
```

### FmrbUart.unit_mask

<pre class="fmrb-sig"><code>unit_mask() -&gt; <a href="../Integer/">Integer</a></code></pre>

アプリが開ける番号 (1 ビットずつ)

ビット n が立っていれば `UARTn` を開ける。ブラウザ版・ネイティブ版は 0。
```ruby
m = FmrbUart.unit_mask
ok = (m >> 2) & 1 == 1   # UART2
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
