# I2C

I2C の機器と話す

使い方は [ハードウェア制御](../peripherals.md) のページにあります。

`I2C.new` で線を開き、`write` と `read` でバイトを送り受ける。7 ビットのアドレスで話す。
**ユニットは `:ESP32_I2C0` と `:ESP32_I2C1` だけ**。ピンは `FmrbHw::PIN_I2C1_SDA`・`PIN_I2C1_SCL`
を使う。**失敗はすべて IOError**。
```ruby
i2c = I2C.new(unit: :ESP32_I2C1,
  sda_pin: FmrbHw::PIN_I2C1_SDA,
  scl_pin: FmrbHw::PIN_I2C1_SCL)
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_FREQUENCY`</span> | [`Integer`](Integer.md) | 周波数の既定 (Hz) |
| <span class="fmrb-name">`DEFAULT_TIMEOUT`</span> | [`Integer`](Integer.md) | 待ちの既定 (ms) |

## クラスメソッド

### I2C.new

<pre class="fmrb-sig"><code>new(
  unit: <a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>,
  ?frequency: <a href="../Integer/">Integer</a>,
  ?sda_pin: <a href="../Integer/">Integer</a>,
  ?scl_pin: <a href="../Integer/">Integer</a>,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; I2C</code></pre>

I2C の線を開く

`unit:` は必須 (`:ESP32_I2C0` か `:ESP32_I2C1`。文字列でもよい)。`frequency:` (省略すると 100000 Hz)、
`sda_pin:`・`scl_pin:` (省略すると -1)、`timeout:` (省略すると 500。以後の `read`・`write` の待ちの既定、ms)。

**開けないときの IOError の文は "Invalid I2C unit" 1 種類**: 知らないユニット名だけでなく、
**すでに別のアプリが持っている**、**画面を持つ機種で I2C1 に別のピンを渡した**、画面の準備前、も同じ文になる。画面を持つ機種 (Tab5・NARYA v4・AtomS3R) の I2C1 は本体の配線に固定で、`FmrbHw::PIN_I2C1_SDA`・`PIN_I2C1_SCL` 以外は断られる。
```ruby
i2c = I2C.new(unit: :ESP32_I2C1,
  sda_pin: FmrbHw::PIN_I2C1_SDA,
  scl_pin: FmrbHw::PIN_I2C1_SCL)
```

## インスタンスメソッド

### I2C#write

<pre class="fmrb-sig"><code>write(
  <a href="../Integer/">Integer</a> addr,
  *<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] | <a href="../String/">String</a> data,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Integer/">Integer</a></code></pre>

機器へ書く

`addr` は 7 ビットのアドレス。データは**幾つでも続けて渡せ**、Integer (1 バイト)・
Integer の Array・String (バイト列) を混ぜてよい。全部まとめて 1 回で送る。
1 バイトは下 8 ビットに丸められる。`timeout:` は ms (省略すると `new` の `timeout:`)。送ったバイト数を返す。

失敗は IOError ("I2C write failed")。型が合わないと TypeError ("argument must be Integer,
Array or String"、Array の中が Integer でないときも)。
```ruby
i2c.write(0x41, 0x20, [1, 2])
```

### I2C#read

<pre class="fmrb-sig"><code>read(
  <a href="../Integer/">Integer</a> addr,
  <a href="../Integer/">Integer</a> len,
  *<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>] | <a href="../String/">String</a> write_data,
  ?timeout: <a href="../Integer/">Integer</a>
) -&gt; <a href="../String/">String</a></code></pre>

機器から読む

`addr` のアドレスから `len` バイトを読み、**バイト列の String** で返す。`len` の後ろにデータを渡すと (レジスタ番号など)、**先にそれを送り、STOP を出さずに続けて読む**
(`write` と同じ渡し方)。`timeout:` は ms (省略すると `new` の `timeout:`)。

失敗は IOError ("I2C read failed"、読む前の送りの失敗は "I2C write (for read) failed")。
**`len` が 0 でも "I2C read failed"**。1 回の待ちは最短 10 ms に切り上げられる。
```ruby
v = i2c.read(0x41, 1, 0xFE)
v.getbyte(0)
```

### I2C#scan

<pre class="fmrb-sig"><code>scan(?timeout: <a href="../Integer/">Integer</a>) -&gt; nil</code></pre>

7 ビットのアドレスを順に当てて見つける

0x08〜0x77 を 1 つずつ読み・書きして、答えたアドレスを **`puts` で出す**
("I2C device found at 7-bit address 0x41 ...")。**戻り値は nil** で、見つけた一覧は返らない。出力が要るのでシェルや開発のためのもの。`timeout:` は省略すると `new` の値。
```ruby
i2c.scan
```

### I2C#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

線を手放す

持っていたピンとユニットの所有を手放す (**バスそのものは閉じず残る**ので、同じアプリでも別のアプリでも、続けて `I2C.new` で開き直せる)。nil を返し、失敗しても例外にしない。
```ruby
i2c.close
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
