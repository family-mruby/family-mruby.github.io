# Unit8Encoder

ロータリエンコーダ 8 個・ボタン 8 個・スイッチ 1 個・RGB の LED 9 個の機器。

`Unit8Encoder.new(i2c)` に開いた `I2C` を渡す。**通信の失敗は `I2C` の IOError がそのまま**出る
(機器が無いとアプリはここで失敗する)。番号 `index` は エンコーダとボタンが 0〜7、LED が 0〜8。範囲の検査はせず、範囲外はほかのレジスタを読み書きする。
```ruby
require "unit8encoder"
enc = Unit8Encoder.new(i2c)
enc.get_increment(0)
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_ADDR`</span> | [`Integer`](Integer.md) | I2C のアドレスの既定 (0x41) |
| <span class="fmrb-name">`NUM_ENCODERS`</span> | [`Integer`](Integer.md) | エンコーダの数 |
| <span class="fmrb-name">`NUM_LEDS`</span> | [`Integer`](Integer.md) | LED の数 |

## クラスメソッド

### Unit8Encoder.new

<pre class="fmrb-sig"><code>new(<a href="../I2C/">I2C</a> i2c, ?<a href="../Integer/">Integer</a> addr) -&gt; Unit8Encoder</code></pre>

機器に繋ぐ

`i2c` は開いた `I2C`、`addr` は省略すると 0x41。**この時点では通信しない** (機器が無くても失敗しない)。
```ruby
enc = Unit8Encoder.new(i2c)
```

## インスタンスメソッド

### Unit8Encoder#get_counter

<pre class="fmrb-sig"><code>get_counter(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

エンコーダの積算値

符号つきの 32 ビット整数。
```ruby
enc.get_counter(0)
```

### Unit8Encoder#set_counter

<pre class="fmrb-sig"><code>set_counter(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

エンコーダの積算値を書く

送ったバイト数を返す。
```ruby
enc.set_counter(0, 100)
```

### Unit8Encoder#get_increment

<pre class="fmrb-sig"><code>get_increment(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

前に読んでからの増減

符号つきの 32 ビット整数。**読むと機器の側で 0 に戻る**。回転の検出にはこちらを使う。
```ruby
d = enc.get_increment(0)
```

### Unit8Encoder#reset_counter

<pre class="fmrb-sig"><code>reset_counter(<a href="../Integer/">Integer</a> index) -&gt; <a href="../Integer/">Integer</a></code></pre>

エンコーダの積算値を 0 に戻す

送ったバイト数を返す。
```ruby
enc.reset_counter(0)
```

### Unit8Encoder#get_button

<pre class="fmrb-sig"><code>get_button(<a href="../Integer/">Integer</a> index) -&gt; bool</code></pre>

ボタンが押されているか

```ruby
enc.get_button(3)
```

### Unit8Encoder#get_switch

<pre class="fmrb-sig"><code>get_switch() -&gt; bool</code></pre>

スイッチが入っているか

```ruby
enc.get_switch
```

### Unit8Encoder#set_led_color

<pre class="fmrb-sig"><code>set_led_color(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> color) -&gt; <a href="../Integer/">Integer</a></code></pre>

LED 1 個の色を決める

`color` は 0xRRGGBB。送ったバイト数を返す。
```ruby
enc.set_led_color(0, 0xFF0000)
```

### Unit8Encoder#set_all_led_color

<pre class="fmrb-sig"><code>set_all_led_color(<a href="../Integer/">Integer</a> color) -&gt; <a href="../Integer/">Integer</a></code></pre>

LED 全部を同じ色にする

`color` は 0xRRGGBB (0 で全部消す)。送ったバイト数を返す。
```ruby
enc.set_all_led_color(0)
```

### Unit8Encoder#firmware_version

<pre class="fmrb-sig"><code>firmware_version() -&gt; <a href="../Integer/">Integer</a></code></pre>

機器のファームの版

```ruby
enc.firmware_version
```

### Unit8Encoder#get_i2c_address

<pre class="fmrb-sig"><code>get_i2c_address() -&gt; <a href="../Integer/">Integer</a></code></pre>

機器が持っている I2C アドレス

```ruby
enc.get_i2c_address
```

### Unit8Encoder#set_i2c_address

<pre class="fmrb-sig"><code>set_i2c_address(<a href="../Integer/">Integer</a> new_addr) -&gt; <a href="../Integer/">Integer</a></code></pre>

機器の I2C アドレスを変える

1〜127。**機器に書いて、以後はこのオブジェクトも新しいアドレスで話す**。範囲の検査は無い。送ったバイト数を返す。
```ruby
enc.set_i2c_address(0x42)
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
