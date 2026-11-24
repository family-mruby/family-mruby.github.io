# FmrbNet

ネットワークの状態を読み、待たずに取得する。

使い方は [ネットワーク](../network.md) のページにあります。

WiFi の接続は端末が受け持つので、アプリは**状態を見るだけ** (`connected?`・`ip_address`・
`hostname`・`ssid`)。取得は `FmrbNet.request` で、**ブラウザ版でも同じ書き方**ができる。
**Linux sim・ネイティブ版・ブラウザ版は、いつも「つながっている」(`127.0.0.1`・`localhost`)** と答える。
```ruby
up = FmrbNet.connected?
```

## クラスメソッド

### FmrbNet.connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

WiFi につながっているか

WiFi の無い端末 (ATOM) は false。Linux sim・ネイティブ版・ブラウザ版は true。
```ruby
draw_offline unless FmrbNet.connected?
```

### FmrbNet.ip_address

<pre class="fmrb-sig"><code>ip_address() -&gt; <a href="../String/">String</a></code></pre>

端末の IP アドレス

つながっていないと `"0.0.0.0"`。Linux sim・ネイティブ版・ブラウザ版は `"127.0.0.1"`。
```ruby
FmrbNet.ip_address   #=> "0.0.0.0" など
```

### FmrbNet.hostname

<pre class="fmrb-sig"><code>hostname() -&gt; <a href="../String/">String</a></code></pre>

端末のホスト名

WiFi の無い端末は空の文字列。Linux sim・ネイティブ版・ブラウザ版は `"localhost"`。
```ruby
FmrbNet.hostname
```

### FmrbNet.ssid

<pre class="fmrb-sig"><code>ssid() -&gt; <a href="../String/">String</a></code></pre>

つないでいる WiFi の名前

設定が無い・WiFi の無い端末は空の文字列。**実機以外 (Linux sim・ネイティブ版・**
**ブラウザ版) では WiFi を持たないので常に空**。
```ruby
FmrbNet.ssid
```

### FmrbNet.wait_for_ip

<pre class="fmrb-sig"><code>wait_for_ip(?<a href="../Integer/">Integer</a> timeout_ms) -&gt; bool</code></pre>

IP アドレスが付くまで待つ

呼んだアプリのタスクを最大 timeout_ms 止める (`timeout_ms` は省略すると 10000。負は 0)。付けば true、時間切れは false。**画面を持つアプリでは短い値にする**。Linux sim・ネイティブ版・ブラウザ版はすぐ true、WiFi の無い端末はすぐ false。
```ruby
ok = FmrbNet.wait_for_ip(2000)
```

### FmrbNet.request

<pre class="fmrb-sig"><code>request(<a href="../String/">String</a> url) -&gt; <a href="../FmrbNet__Request/">FmrbNet::Request</a></code></pre>

URL の取得を始める

**答えそのものではなく `Request` を返す** (名前が get でない理由)。結果は後で
`done?` が true になってから読む。コールバックは無い。

**待ち方が環境で違う**: ブラウザ版は裏で取るので `done?` はしばらく false で、画面は動き続ける。**実機・Linux sim・ネイティブ版は `request` の中で取り終えるので、**
**サーバが答えるまでアプリのタスクが止まる** (`done?` は最初から true)。Net::HTTP の GET だけで、失敗は例外でなく `error` に入る。
```ruby
@req = FmrbNet.request("https://example.org/a")
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
