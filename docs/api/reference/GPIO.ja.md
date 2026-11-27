# GPIO

1 本のピンを入れ出力に使う

使い方は [ハードウェア制御](../peripherals.md) のページにあります。

`GPIO.new(ピン, フラグ)` で作り、`read` と `write` を使う。フラグは `GPIO::IN | GPIO::PULL_UP`
のように `|` でつなぐ。**ピンは整数だけ**。使ってよいピンは `FmrbHw.pin_available?` で調べる
(システムのピン・使用中のピンは IOError になる)。
```ruby
led = GPIO.new(5, GPIO::OUT)
led.write(1)
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`IN`</span> | [`Integer`](Integer.md) | 入力 |
| <span class="fmrb-name">`OUT`</span> | [`Integer`](Integer.md) | 出力 |
| <span class="fmrb-name">`HIGH_Z`</span> | [`Integer`](Integer.md) | ハイインピーダンス |
| <span class="fmrb-name">`PULL_UP`</span> | [`Integer`](Integer.md) | プルアップ |
| <span class="fmrb-name">`PULL_DOWN`</span> | [`Integer`](Integer.md) | プルダウン |
| <span class="fmrb-name">`OPEN_DRAIN`</span> | [`Integer`](Integer.md) | オープンドレイン (この端末では何もしない) |
| <span class="fmrb-name">`ALT`</span> | [`Integer`](Integer.md) | 代替機能 (この端末では何もしない) |

## クラスメソッド

### GPIO.new

<pre class="fmrb-sig"><code>new(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> flags, ?<a href="../Integer/">Integer</a> alt_function) -&gt; GPIO</code></pre>

ピンを開く

`flags` に `IN`・`OUT`・`HIGH_Z` のどれか **1 つ**と、必要なら `PULL_UP` か `PULL_DOWN` を `|` で渡す。
`alt_function` (省略すると 0) は ALT 用で、この端末では効かない。

作るときにピンの台帳へ取る。**取れないときは IOError で、ピンの設定 (向き・プル) は変えない**:
システムのピン (`FmrbHw.pin_status` が `PIN_SYSTEM_EXCLUSIVE` のピン) は "GPIO n is used by the
system"、ほかのアプリ (または I2C などの別の使い方) が持っているピンは "GPIO n is in use by another app or driver"。**本体のボタン**は台帳には取らず、
`IN` (プルつきも) でだけ開ける。`OUT` などで開くと "GPIO n is input only (a system button or a chip's interrupt line)"。取ったピンはアプリが終わると台帳へ返る。

文字列・Symbol のピンは ArgumentError ("Wrong GPIO pin name")、負の数も同じ。端末に無い番号は
ArgumentError ("GPIO n does not exist on this board")。方向が無い・
2 つ以上は ArgumentError ("You must specify one of IN, OUT, HIGH_Z, and ALT"・
"IN, OUT and HIGH_Z are exclusive")、`PULL_UP` と `PULL_DOWN` の両方も ArgumentError。
```ruby
sw = GPIO.new(7, GPIO::IN | GPIO::PULL_UP)
```

### GPIO.set_dir_at

<pre class="fmrb-sig"><code>set_dir_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> dir) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号で向きを設定する

`GPIO.new` と同じく台帳に照らす: 空いているピンはこのアプリの物になり、システムのピン・使用中のピンは IOError (設定は変えない)。本体のボタンは `IN` だけ。ほかの設定は覚えない。
`dir` は `IN`・`OUT`。戻り値は 0。普通は `GPIO.new` を使う。
```ruby
GPIO.set_dir_at(5, GPIO::OUT)
```

### GPIO.pull_up_at

<pre class="fmrb-sig"><code>pull_up_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号でプルアップにする

`set_dir_at` と同じく台帳に照らす (本体のボタンにもかけられる)。戻り値は 0。
```ruby
GPIO.pull_up_at(7)
```

### GPIO.pull_down_at

<pre class="fmrb-sig"><code>pull_down_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号でプルダウンにする

`set_dir_at` と同じく台帳に照らす (本体のボタンにもかけられる)。戻り値は 0。
```ruby
GPIO.pull_down_at(7)
```

### GPIO.open_drain_at

<pre class="fmrb-sig"><code>open_drain_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号でオープンドレインにする (何もしない)

この端末のつなぎは何もせず、戻り値は 0。出力と同じく台帳に照らす (断られると IOError)。
```ruby
GPIO.open_drain_at(7)
```

### GPIO.set_function_at

<pre class="fmrb-sig"><code>set_function_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> function) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号で代替機能にする (何もしない)

この端末のつなぎは何もせず、戻り値は 0。出力と同じく台帳に照らす (断られると IOError)。
```ruby
GPIO.set_function_at(7, 1)
```

### GPIO.read_at

<pre class="fmrb-sig"><code>read_at(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号で読む

0 か 1。**読むだけなので、システムのピンも使用中のピンも読める** (台帳に取らず、設定も変えない)。読めなかったときは IOError。文字列・Symbol・負の数・端末に無い番号は ArgumentError。
```ruby
GPIO.read_at(7)
```

### GPIO.write_at

<pre class="fmrb-sig"><code>write_at(<a href="../Integer/">Integer</a> pin, <a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号で書く

`GPIO#write` と同じ (0・1 だけ、戻り値は 0)。`set_dir_at` と同じく台帳に照らす: 空いているピンはこのアプリの物になり、システムのピン (ボタンも)・使用中のピンは IOError。
```ruby
GPIO.write_at(5, 1)
```

### GPIO.high_at?

<pre class="fmrb-sig"><code>high_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

ピン番号で高いか

読んだ値が 0 でなければ true。`read_at` と同じく、どのピンも読める。読めなければ IOError。
```ruby
GPIO.high_at?(7)
```

### GPIO.low_at?

<pre class="fmrb-sig"><code>low_at?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

ピン番号で低いか

読んだ値が 0 なら true。`read_at` と同じく、どのピンも読める。読めなければ IOError。
```ruby
GPIO.low_at?(7)
```

## インスタンスメソッド

### GPIO#pin

<pre class="fmrb-sig"><code>pin() -&gt; <a href="../Integer/">Integer</a></code></pre>

ピン番号

```ruby
led.pin   #=> 5
```

### GPIO#setmode

<pre class="fmrb-sig"><code>setmode(<a href="../Integer/">Integer</a> flags, ?<a href="../Integer/">Integer</a> alt_function) -&gt; <a href="../Integer/">Integer</a></code></pre>

向きとプルを設定し直す

`new` と同じ組み合わせを渡せる。**向きのフラグを渡さなければ向きは今のまま**、プルも同じ。戻り値は 0。本体のボタンを出力にしようとすると IOError。
```ruby
sw.setmode(GPIO::IN | GPIO::PULL_DOWN)
```

### GPIO#read

<pre class="fmrb-sig"><code>read() -&gt; <a href="../Integer/">Integer</a></code></pre>

読む (0 か 1)

読めなかったときは IOError ("GPIO n could not be read")。
```ruby
sw.read   #=> 0 か 1
```

### GPIO#write

<pre class="fmrb-sig"><code>write(<a href="../Integer/">Integer</a> value) -&gt; <a href="../Integer/">Integer</a></code></pre>

書く (0 か 1)

0 と 1 以外は ArgumentError ("Wrong value. 0 and 1 are only valid")。戻り値は 0。出力に設定したピンに使う。本体のボタンでは IOError ("... input only")。
```ruby
led.write(1)
```

### GPIO#high?

<pre class="fmrb-sig"><code>high?() -&gt; bool</code></pre>

高いか

読んだ値が 0 でなければ true。読めなかったときは IOError。
```ruby
pressed = !sw.high?
```

### GPIO#low?

<pre class="fmrb-sig"><code>low?() -&gt; bool</code></pre>

低いか

読んだ値が 0 なら true。読めなかったときは IOError。
```ruby
pressed = sw.low?
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
