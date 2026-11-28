# FmrbHw

ピンの台帳を読む

使い方は [ハードウェア制御](../peripherals.md)、[定数・システム情報](../const.md) のページにあります。

どのピンが「システム専用」で、どれをアプリの `GPIO`・`I2C`・RMT が使っているかを調べる。機種ごとにアプリが使えるピンは `FmrbHw.pin_available?` で確かめる。
**台帳に実際の印が付くのは実機だけ**。Linux sim・ネイティブ版・ブラウザ版はピンを持たず、台帳は全部 `PIN_UNUSED` のまま (ピンの数は 49)。
```ruby
if FmrbHw.pin_available?(5)
  io = GPIO.new(5, GPIO::OUT)
end
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PIN_UNUSED`</span> | [`Integer`](Integer.md) | 使われていないピン |
| <span class="fmrb-name">`PIN_SYSTEM_EXCLUSIVE`</span> | [`Integer`](Integer.md) | システム専用のピン |
| <span class="fmrb-name">`PIN_USER_GPIO`</span> | [`Integer`](Integer.md) | アプリが GPIO として取っているピン |
| <span class="fmrb-name">`PIN_USER_I2C`</span> | [`Integer`](Integer.md) | I2C が取っているピン |
| <span class="fmrb-name">`PIN_USER_RMT`</span> | [`Integer`](Integer.md) | RMT が取っているピン |
| <span class="fmrb-name">`PIN_USER_SPI`</span> | [`Integer`](Integer.md) | SPI が取っているピン (予約の値) |
| <span class="fmrb-name">`PIN_USER_PWM`</span> | [`Integer`](Integer.md) | PWM が取っているピン (予約の値) |
| <span class="fmrb-name">`PIN_USER_UART`</span> | [`Integer`](Integer.md) | UART が取っているピン (予約の値) |
| <span class="fmrb-name">`PIN_I2C1_SDA`</span> | [`Integer`](Integer.md) | I2C1 の SDA のピン番号 |
| <span class="fmrb-name">`PIN_I2C1_SCL`</span> | [`Integer`](Integer.md) | I2C1 の SCL のピン番号 |
| <span class="fmrb-name">`PIN_I2C2_SDA`</span> | [`Integer`](Integer.md) | I2C2 の SDA のピン番号 |
| <span class="fmrb-name">`PIN_I2C2_SCL`</span> | [`Integer`](Integer.md) | I2C2 の SCL のピン番号 |

## クラスメソッド

### FmrbHw.pin_status

<pre class="fmrb-sig"><code>pin_status(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピンの使われ方 (PIN_* の値)

システムが使うピンは、台帳に取られていなくても `PIN_SYSTEM_EXCLUSIVE` (`GPIO` が断るピンと同じ)。範囲外のピン番号は例外にならず `PIN_UNUSED` (0)。
```ruby
FmrbHw.pin_status(25) == FmrbHw::PIN_SYSTEM_EXCLUSIVE
```

### FmrbHw.pin_available?

<pre class="fmrb-sig"><code>pin_available?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

そのピンをアプリが取れるか

`PIN_UNUSED` のピンだけ true。**範囲外の番号は false**。システム専用のピン (`GPIO` が断るピン) と、すでに誰かが取っているピンは false。
```ruby
FmrbHw.pin_available?(5)   #=> true か false
```

### FmrbHw.pin_status_all

<pre class="fmrb-sig"><code>pin_status_all() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

全ピンの使われ方

添字がピン番号、値が `PIN_*` (`pin_status` と同じ値)。長さは `pin_count`。
```ruby
FmrbHw.pin_status_all[5]
```

### FmrbHw.pin_count

<pre class="fmrb-sig"><code>pin_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

台帳のピンの数

**ESP32-P4 の機種は 55** (GPIO 0〜54)、それ以外 (S3・Linux sim・ネイティブ版・ブラウザ版) は 49
(GPIO 0〜48)。
```ruby
FmrbHw.pin_count   #=> 55 か 49
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
