# Asterism

Asterism の gem (vendor/asterism)。アプリは FmrbAsterism::Link の conn
から使う。

使い方は [ネットワーク](../network.md) のページにあります。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`PROTOCOL`</span> | [`Integer`](Integer.md) | 通信の版 |
| <span class="fmrb-name">`DEFAULT_TIMEOUT`</span> | [`Float`](Float.md) | 呼び出しの待ち時間の既定 (秒) |
| <span class="fmrb-name">`DEFAULT_TIMEOUT_MS`</span> | [`Integer`](Integer.md) | 呼び出しの待ち時間の既定 (ミリ秒) |
| <span class="fmrb-name">`CHECK_TIMEOUT`</span> | [`Float`](Float.md) | 同じ名前の相手を探す時間 (秒) |
| <span class="fmrb-name">`ROOT`</span> | [`String`](String.md) | キーの根 |

## クラスメソッド

### Asterism.connect

<pre class="fmrb-sig"><code>connect(
  ?<a href="../String/">String</a>? locator,
  app: <a href="../String/">String</a>,
  ?node: <a href="../String/">String</a>?,
  ?mode: <a href="../Symbol/">Symbol</a>?,
  ?listen: <a href="../String/">String</a>?,
  ?config: (<a href="../Hash/">Hash</a> | <a href="../String/">String</a>)?,
  ?connect_timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?check_timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?credentials: (<a href="../String/">String</a> | <a href="../Asterism__Credentials/">Asterism::Credentials</a>)?
) -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

ネットワークにつなぐ (Link を使わないとき)

ルータ (locator) につないで、このアプリ (node の app) を Asterism の上に出し、Asterism::Connection を返す。**端末のアプリは普通 Link を使う**
(WiFi を待つ・つなぎ直す・設定を読むのは Link)。これは Link が呼ぶ入口。
**つなぐ間アプリは止まる** (同じ名前の相手を探す `check_timeout:` の
1.5 秒ほどと、ルータが無いときの数秒)。
`node:` (省略すると credentials の名前)、`app:` (必須)、`mode:` (省略するとルータのクライアント。:peer ならルータ無し)、`listen:`、`config:` (TLS のキーなど。Hash か JSON5 の String)、`connect_timeout:` (PC の CRuby だけ。端末は ArgumentError)、`check_timeout:` (秒)、`credentials:`
(.tar のパスか Asterism::Credentials。locator と node の既定になる)。つなげないと Asterism::Disconnected、同じ node/app が既にあると
Asterism::Error、名前が正しくないと ArgumentError。
```ruby
conn = Asterism.connect(
  "tcp/192.0.2.2:7447",
  node: "fmruby-aaa001", app: "demo")
```

### Asterism.connections

<pre class="fmrb-sig"><code>connections() -&gt; <a href="../Array/">Array</a>[<a href="../Asterism__Connection/">Asterism::Connection</a>]</code></pre>

開いている接続の一覧

開いた順。切れたあと on_leave をまだ知らせていないものも入る。
```ruby
n = Asterism.connections.size
```

### Asterism.poll_all

<pre class="fmrb-sig"><code>poll_all() -&gt; bool</code></pre>

全部の接続を poll する

1 つでもつながっていれば true。Link を使うなら Link#update が呼ぶ。
```ruby
Asterism.poll_all
```

### Asterism.profile_defaults

<pre class="fmrb-sig"><code>profile_defaults(
  ?kind: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?name: <a href="../String/">String</a>?,
  ?host: <a href="../String/">String</a>?,
  ?icon: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

このプログラムの端末の名乗りの既定

キーワードを渡すとその項目を変え (nil で外す。`icon: nil` は既定のアイコンも使わない)、できた名乗りを返す。渡さなければ今の既定を返す。接続している端末には変更が流れる。端末ごとの上書きは Connection#profile。項目は `kind:` (Symbol か String)、`name:`・`host:` (String)、
`icon:` (PNG のバイト列)。受け付けないものは ArgumentError。
```ruby
Asterism.profile_defaults(
  kind: :family_mruby, host: "sim")
```

### Asterism.default_icon_path

<pre class="fmrb-sig"><code>default_icon_path() -&gt; <a href="../String/">String</a>?</code></pre>

既定のアイコンのファイル

端末では "/usr/share/asterism/icon.png"。誰もアイコンを指定しなければこのファイルが使われる。
```ruby
path = Asterism.default_icon_path
```

### Asterism.read_attachment

<pre class="fmrb-sig"><code>read_attachment(
  <a href="../String/">String</a>? att,
  ?<a href="../Symbol/">Symbol</a>? place,
  ?<a href="../String/">String</a>? node
) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

値に付いた添え物を読む

att は値と一緒に来た添え物のバイト列。`[番号, 接続の番号, 送り手の時刻,
送り手]` を返す。番号が無い (添え物が無い・形が違う) と nil。送り手は place が :node か :global (共有の場所) のときだけ入る。普通は subscribe が SampleInfo にしてくれる。
```ruby
seq, run, ms, from =
  Asterism.read_attachment(att)
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
