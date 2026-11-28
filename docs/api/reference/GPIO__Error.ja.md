# GPIO::Error

GPIO の周辺機器の失敗の番号と例外

使い方は [ハードウェア制御](../peripherals.md) のページにあります。

定数 `GPIO_ERROR_NONE` (0)・`TIMEOUT` (-1)・`GENERIC` (-2)・`NO_DATA` (-3)・`NOT_PERMITTED` (-4)・
`INVALID_ARG` (-5)・`IO` (-6) は番号。

## クラスメソッド

### GPIO::Error.peripheral_error

<pre class="fmrb-sig"><code>peripheral_error(<a href="../Integer/">Integer</a> code, ?<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a></code></pre>

番号を例外にする

0 (`GPIO_ERROR_NONE`) は 0 を返す。それ以外の番号は **IOError** を出す (文は
"Timeout error in 名前" の形。知らない番号は "Unknown error in 名前. code: n")。
`name` は省略すると "unknown peripheral"。同梱のアプリは呼ばない。
```ruby
GPIO::Error.peripheral_error(-1, "uart")
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
