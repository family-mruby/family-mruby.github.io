# Asterism::ROS::Node

ROS 2 のノード

使い方は [ネットワーク](../network.md) のページにあります。

トピック・サービス・タイマーはこのノードにぶら下がる。ノードを閉じると全部が終わる。受け取りと答え (subscribe・every・service のブロック) は
**Node#poll の中で**呼ばれる。ブロックの中で待たない (サービスの呼び出しや相手のメソッドを待つと、update が止まる): call_async を始めて、後で done? を見る。
```ruby
node = Asterism::ROS::Node.new(
  @link.conn.session, "fmrb_node")
```

## クラスメソッド

### Asterism::ROS::Node.new

<pre class="fmrb-sig"><code>new(
  untyped session,
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  ?namespace: <a href="../String/">String</a>,
  ?domain: <a href="../Integer/">Integer</a>,
  ?enclave: <a href="../String/">String</a>
) -&gt; Asterism::ROS::Node</code></pre>

ノードを作る

session は開いた Zenoh のセッション (`conn.session`)。name は 1 つの名前 ("/" を含まない・空でない。違うと ArgumentError)。
`namespace:` (省略すると "/")、`domain:` (省略すると 0。ROS_DOMAIN_ID)、
`enclave:` (省略すると "/")。作った時点でノードの liveliness を出す。
```ruby
node = Asterism::ROS::Node.new(
  conn.session, "fmrb_node",
  namespace: "/fmrb")
```

## インスタンスメソッド

### Asterism::ROS::Node#poll

<pre class="fmrb-sig"><code>poll(?<a href="../Integer/">Integer</a> steps) -&gt; bool</code></pre>

毎回呼ぶ (受け取る・答える・タイマー)

セッションを poll し、届いたサービスの要求に答え、subscribe のブロックにメッセージを渡し、時間が来たタイマーを動かす。セッションが閉じていれば
false (そうでなければ true)。`steps` (省略すると 8) は 1 回にセッションの処理を繰り返す回数の上限 (空になれば途中でやめる)。
```ruby
def on_update
  @node.poll
  100
end
```

### Asterism::ROS::Node#publisher

<pre class="fmrb-sig"><code>publisher(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>
) -&gt; <a href="../Asterism__ROS__Publisher/">Asterism::ROS::Publisher</a></code></pre>

トピックの Publisher を作る

topic はトピック名 ("/chatter"。相対ならノードの namespace の下)、
type は型そのものか ROS の名前 ("std_msgs/msg/String")。`qos:`
(省略すると DEFAULT_QOS)。型が読めないと Asterism::ROS::UnknownType か
ArgumentError。
```ruby
pub = node.publisher("/chatter",
  "std_msgs/msg/String")
```

### Asterism::ROS::Node#subscription

<pre class="fmrb-sig"><code>subscription(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a></code></pre>

Subscription を作る (自分で取り出す)

届いたメッセージは溜まり、`each_pending` で取り出す。`depth:` (省略すると
16) は溜めておける数、`qos:` (省略すると DEFAULT_QOS)。ブロックで受けたいときは subscribe。
```ruby
sub = node.subscription("/cmd",
  "std_msgs/msg/String")
```

### Asterism::ROS::Node#subscribe

<pre class="fmrb-sig"><code>subscribe(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) { (<a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a> msg, <a href="../Asterism__ROS__Attachment/">Asterism::ROS::Attachment</a>? info) -&gt; untyped } -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a>

subscribe(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a></code></pre>

トピックを受ける (ブロックで)

メッセージが来るたびに、**Node#poll の中で** |msg, info| が呼ばれる
(info は Asterism::ROS::Attachment で、無ければ nil)。ブロックの中では待たない。返った Subscription の close で止める。ブロックを渡さないと
subscription と同じ。
```ruby
node.subscribe("/cmd",
  "std_msgs/msg/String") do |m, i|
  got(m.data)
end
```

### Asterism::ROS::Node#service

<pre class="fmrb-sig"><code>service(
  <a href="../String/">String</a> service,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) { (untyped request) -&gt; untyped } -&gt; <a href="../Asterism__ROS__Service/">Asterism::ROS::Service</a></code></pre>

サービスを提供する

要求が来るたびに、**Node#poll の中で**ブロックが要求 (`type::Request`)
を受けて、答え (`type::Response` か欄の Hash) を返す。`depth:` (省略すると 8)、
`qos:` (省略すると DEFAULT_QOS)。ブロックが無いと ArgumentError。ブロックが例外を出すとその要求には答えず、例外は poll から出る。
```ruby
add = Asterism::ROS.require_type(
  "example_interfaces/srv/AddTwoInts")
node.service("/add", add) do |r|
  { sum: r.a + r.b }
end
```

### Asterism::ROS::Node#client

<pre class="fmrb-sig"><code>client(
  <a href="../String/">String</a> service,
  untyped type,
  ?qos: <a href="../String/">String</a>
) -&gt; <a href="../Asterism__ROS__Client/">Asterism::ROS::Client</a></code></pre>

サービスの Client を作る

呼ぶのは Client#call (待つ) か call_async (待たない)。`qos:` (省略すると
DEFAULT_QOS)。1 回だけ呼ぶなら Node#call が Client を作って覚える。
```ruby
cli = node.client("/add", add)
```

### Asterism::ROS::Node#call

<pre class="fmrb-sig"><code>call(
  <a href="../String/">String</a> service,
  untyped type,
  ?untyped req,
  ?request: untyped,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?,
  **untyped fields
) -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a></code></pre>

サービスを 1 回呼んで答えを待つ

`node.call("/add", add, a: 2, b: 3)`。要求は欄をキーワードで渡すか、
Hash かメッセージを位置引数か `request:` で渡す。待ち時間は `timeout:`
(秒) か `timeout_ms:` (省略すると 2 秒)。Client はサービスの名前ごとに
1 つ作って覚える。**答えが来るまでアプリは止まる**が、その間もこのノードのサービスには答える (subscribe と every のブロックは動かない)。時間内に答えが無ければ Asterism::ROS::TimeoutError、セッションが閉じていれば
Asterism::Zenoh::ClosedError。要求の欄が timeout や timeout_ms という名前なら
`request: { ... }` で渡す。
```ruby
r = node.call("/add", add,
  a: 2, b: 3)
puts r.sum
```

### Asterism::ROS::Node#every

<pre class="fmrb-sig"><code>every(
  ?(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)? seconds,
  ?ms: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?
) { () -&gt; untyped } -&gt; <a href="../Asterism__ROS__Timer/">Asterism::ROS::Timer</a></code></pre>

一定の間隔でブロックを呼ぶ

`every(1.0) { ... }` (秒) か `every(ms: 500) { ... }`。最初は 1 周期後。
**Node#poll の中で**呼ぶ。長く止まっても、取りこぼした分をまとめて呼ばない (今から数え直す)。ブロックの中では待たない。Timer を返す
(cancel で止める)。ブロックが無い・周期が無い・両方ある・0 以下は
ArgumentError。
```ruby
t = node.every(1.0) do
  pub << { data: "tick" }
end
```

### Asterism::ROS::Node#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

ノードを閉じる

Publisher・Subscription・サービス・クライアント・タイマーも終わる。何度呼んでもよい。nil を返す。
```ruby
node.close
```

### Asterism::ROS::Node#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

閉じたか

```ruby
return if node.closed?
```

### Asterism::ROS::Node#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

ノードの名前

```ruby
n = node.name
```

### Asterism::ROS::Node#namespace

<pre class="fmrb-sig"><code>namespace() -&gt; <a href="../String/">String</a></code></pre>

ノードの namespace

```ruby
ns = node.namespace
```

### Asterism::ROS::Node#domain

<pre class="fmrb-sig"><code>domain() -&gt; <a href="../Integer/">Integer</a></code></pre>

ROS_DOMAIN_ID

```ruby
d = node.domain
```

### Asterism::ROS::Node#zid

<pre class="fmrb-sig"><code>zid() -&gt; <a href="../String/">String</a></code></pre>

このセッションの Zenoh ID

```ruby
id = node.zid
```

### Asterism::ROS::Node#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

ノードの liveliness のキー

```ruby
k = node.key
```

### Asterism::ROS::Node#session

<pre class="fmrb-sig"><code>session() -&gt; untyped</code></pre>

乗っているセッション

```ruby
s = node.session
```

### Asterism::ROS::Node#cancel_timer

<pre class="fmrb-sig"><code>cancel_timer(<a href="../Asterism__ROS__Timer/">Asterism::ROS::Timer</a> timer) -&gt; nil</code></pre>

一定間隔のブロックを止める

Timer#cancel と同じ。nil を返す。
```ruby
node.cancel_timer(t)
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
