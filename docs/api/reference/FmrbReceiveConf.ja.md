# FmrbReceiveConf

ファイルや app の受け取りの設定を読み書きする

設定は `/home/asterism/receive.toml` (無ければ出荷時の `/etc/asterism/receive.toml`)。
**受け取りは `enabled = true` の行があるときだけ**で、ファイルが無い・行が無いと「受け取らない」。手で書く部分と、console が書く「managed」の部分があり、`set_*`・`allow`・`deny` が書き換えるのは
**手で書く部分だけ**。
```ruby
require "/usr/share/transfer/receive_conf"
FmrbReceiveConf.enabled?
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PATH`</span> | [`String`](String.md) | 手で書く設定のファイル |
| <span class="fmrb-name">`SYS_PATH`</span> | [`String`](String.md) | 出荷時の設定のファイル |
| <span class="fmrb-name">`ANYONE`</span> | [`String`](String.md) | 「ネットワークの全員」の印 (`"*"`) |
| <span class="fmrb-name">`ENTRY_MAX`</span> | [`Integer`](Integer.md) | 1 つの送り手の名前・型の長さの上限 (バイト) |

## クラスメソッド

### FmrbReceiveConf.path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a>?</code></pre>

読んでいる設定のファイル

利用者のファイルがあればそれ、無ければ出荷時のもの、どちらも無ければ nil。
```ruby
FmrbReceiveConf.path
```

### FmrbReceiveConf.enabled?

<pre class="fmrb-sig"><code>enabled?() -&gt; bool</code></pre>

受け取りが入っているか

手で書く部分に `enabled = true` があれば true。行が無い・ほかの値・TOML でない・ファイルが無い、は false。
```ruby
FmrbReceiveConf.enabled?
```

### FmrbReceiveConf.send_enabled?

<pre class="fmrb-sig"><code>send_enabled?() -&gt; bool</code></pre>

送る先の一覧を持つ設定が入っているか

`send_enabled = true` があれば true。同じ規則。
```ruby
FmrbReceiveConf.send_enabled?
```

### FmrbReceiveConf.install_mode

<pre class="fmrb-sig"><code>install_mode() -&gt; <a href="../String/">String</a></code></pre>

app の入れ方 ("ask" か "auto")

`[app]` の `install = "auto"` があれば "auto" (証明書で確かめた送り手のものは聞かずに入れる)、それ以外は "ask" (毎回持ち主に聞く)。
```ruby
FmrbReceiveConf.install_mode   #=> "ask"
```

### FmrbReceiveConf.view

<pre class="fmrb-sig"><code>view() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

設定を 1 度に読んだ表

Receiving アプリが見せるものを Hash で返す: `"enabled"`・`"send_enabled"`・`"path"` (ファイルが無ければ nil)・`"hand_ok"` (手で書く部分が TOML か空)・`"by"`・`"at"` (console の書いたもの)・
`"install"`、種類 (`"file"`・`"checkpoint"`・`"app"`) ごとの `{ "hand" => 一覧か nil, "managed" => 一覧か nil }`。
```ruby
v = FmrbReceiveConf.view
v["file"]["hand"]
```

### FmrbReceiveConf.set_enabled

<pre class="fmrb-sig"><code>set_enabled(bool on) -&gt; bool</code></pre>

受け取りを入れる・切る

書いたら true、すでにその状態なら false (書かない)。**手で書く部分が TOML でないと**
**ArgumentError** で何も書かない (人の文章は書き換えない)。書く前に読み戻して確かめる。入れ切りの後は `tell_transfer` で転送アプリに知らせる。
```ruby
FmrbReceiveConf.set_enabled(true)
```

### FmrbReceiveConf.set_send_enabled

<pre class="fmrb-sig"><code>set_send_enabled(bool on) -&gt; bool</code></pre>

送る先の一覧を持つのを入れる・切る

`set_enabled` と同じ答えと例外。
```ruby
FmrbReceiveConf.set_send_enabled(true)
```

### FmrbReceiveConf.set_install_mode

<pre class="fmrb-sig"><code>set_install_mode(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> mode) -&gt; bool</code></pre>

app の入れ方を決める

`"ask"` か `"auto"` (Symbol も可)。ほかは ArgumentError ("not a way to install")。書いたら true、すでにそうなら false。ほかの例外は `set_enabled` と同じ。
```ruby
FmrbReceiveConf.set_install_mode("ask")
```

### FmrbReceiveConf.allow

<pre class="fmrb-sig"><code>allow(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> kind, <a href="../String/">String</a> node) -&gt; bool</code></pre>

送り手を許す

`kind` は `"file"`・`"checkpoint"`・`"app"` (Symbol も可。ほかは ArgumentError)。`node` はノード名か型 (英数字と `.` `_` `-` `*` だけ、`ENTRY_MAX` バイトまで。`"*"` はネットワークの全員、`"pc-*"` のような型も可)。そうでないと ArgumentError。1 つの一覧は 64 件まで
(超えると ArgumentError)。書いたら true、すでに手で書く一覧にあれば false。
```ruby
FmrbReceiveConf.allow("file", "pc-desk")
```

### FmrbReceiveConf.deny

<pre class="fmrb-sig"><code>deny(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> kind, <a href="../String/">String</a> node) -&gt; bool</code></pre>

送り手を外す

手で書く一覧から外して true。**一覧に無いと ArgumentError** で、console が書いた一覧にだけあるときは「そちらで変える」という文になる (console の一覧はここでは変えない)。
```ruby
FmrbReceiveConf.deny("file", "pc-desk")
```

### FmrbReceiveConf.tell_transfer

<pre class="fmrb-sig"><code>tell_transfer(<a href="../FmrbApp/">FmrbApp</a> app, bool on) -&gt; <a href="../Symbol/">Symbol</a></code></pre>

転送アプリに設定の変更を知らせる

`app` は呼ぶアプリ (self)、`on` は受け取り・送りのどちらかが入っているか。入っていて転送アプリが動いていなければ起動して `:started`、動いていれば設定を読み直させて `:running`
(`on` が false なら `:stopping`: 受け取り中の分が済んだら終わる)。動いておらず切る側なら `:none`。
```ruby
FmrbReceiveConf.tell_transfer(self, on)
```

### FmrbReceiveConf.node_ok?

<pre class="fmrb-sig"><code>node_ok?(untyped name) -&gt; bool</code></pre>

一覧に載せてよい名前か

ノード名か型として正しければ true (`allow` の検査と同じ)。
```ruby
FmrbReceiveConf.node_ok?("pc-*")   #=> true
```

### FmrbReceiveConf.allows_anyone?

<pre class="fmrb-sig"><code>allows_anyone?(untyped list) -&gt; bool</code></pre>

一覧にネットワークの全員が入っているか

一覧に `"*"` があれば true。一覧が Array でなければ false。
```ruby
FmrbReceiveConf.allows_anyone?(list)
```

### FmrbReceiveConf.allows?

<pre class="fmrb-sig"><code>allows?(untyped list, <a href="../String/">String</a> node) -&gt; bool</code></pre>

一覧がそのノードを入れるか

一覧の項目が `node` と同じか、`"*"` を含む型に合えば true。`*` は文字の連なり (空も可)。一覧が Array でなければ false。
```ruby
FmrbReceiveConf.allows?(["pc-*"], "pc-desk")
#=> true
```

### FmrbReceiveConf.senders

<pre class="fmrb-sig"><code>senders(<a href="../String/">String</a> kind) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

1 つの種類の送り手

1 回の読みで Hash を返す: `"enabled"`、`"hand"` (手で書いた一覧、無ければ nil)、`"managed"`
(console の一覧、無ければ nil)、`"by"`・`"at"` (console のもの)。
```ruby
s = FmrbReceiveConf.senders("file")
s["hand"]
```

### FmrbReceiveConf.lines

<pre class="fmrb-sig"><code>lines() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

設定を見せる文の行

シェルの `areceive` と `asend -l` が出す文。入り切り・読んだファイル・種類ごとの送り手とその出所を英語の行にして返す。
```ruby
FmrbReceiveConf.lines.each { |l| puts l }
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
