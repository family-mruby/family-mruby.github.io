# Asterism::Connection

ネットワーク上のアプリ 1 つ分のつながり

使い方は [ネットワーク](../network.md) のページにあります。

link.conn で得る。

## インスタンスメソッド

### Asterism::Connection#expose

<pre class="fmrb-sig"><code>expose(
  <a href="../String/">String</a> name,
  untyped obj,
  methods: <a href="../Array/">Array</a>[untyped] | <a href="../Hash/">Hash</a>[untyped, untyped],
  ?caller: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?doc: <a href="../String/">String</a>?
) -&gt; <a href="../String/">String</a></code></pre>

オブジェクトを公開する

name はオブジェクトの名前で、ほかの端末からは
"<この端末>/<アプリ>/<name>" で呼ばれる。
**methods: はキーワードで渡す**: 呼んでよいメソッドの名前と引数の数の Hash
({ post: 1 }。数は呼ばれる前に確かめる、-1 は何個でも) か、名前の Array。並べたメソッドだけが呼べる。obj にそのメソッドが無いと ArgumentError。公開したメソッドは update の中で呼ばれる。メソッドが例外を出すと、呼んだ側に RemoteError で届く。
`caller:` (省略すると渡さない) に :from のようなキーワード名を渡すと、呼ぶたびに呼んだ端末の名前がそのキーワードで公開メソッドに渡る。
`doc:` (省略すると無し) はオブジェクトの説明 (2048 バイトまで)。戻り値は公開した道 ("node/app/name")。link_up の中で呼ぶ。
```ruby
def link_up(link)
  link.conn.expose("board", self,
    methods: { post: 1 })
end

def post(text)
  @lines << text
  @lines.size
end
```

### Asterism::Connection#[]

<pre class="fmrb-sig"><code>[](
  <a href="../String/">String</a> path,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Asterism__Proxy/">Asterism::Proxy</a></code></pre>

ほかの端末のオブジェクトを受け取る

path は "<端末>/<アプリ>/<オブジェクト>"。受け取っただけでは何も送らない。そのメソッドを呼ぶと相手で動き、答えを待つ (既定 2 秒。
**timeout: で秒を変えられる**。ミリ秒なら `timeout_ms:`)。待つ間も、こちらに来た呼び出しには答える。待たずに呼ぶなら async。失敗: 相手が例外を出した・公開していない・引数の数が違うと
Asterism::RemoteError、時間切れは Asterism::TimeoutError、つながっていないと Asterism::Disconnected。どれも Asterism::Error。
```ruby
b = @link.conn[
  "fmruby-1/talk_board/board"]
begin
  n = b.post("hello")
rescue ::Asterism::Error => e
  show(e.message)
end
```

### Asterism::Connection#each

<pre class="fmrb-sig"><code>each(?<a href="../String/">String</a> pattern) -&gt; <a href="../Array/">Array</a>[<a href="../Asterism__Proxy/">Asterism::Proxy</a>]
each(?<a href="../String/">String</a> pattern) { (<a href="../Asterism__Proxy/">Asterism::Proxy</a> proxy) -&gt; untyped } -&gt; <a href="../Integer/">Integer</a></code></pre>

公開されているオブジェクトを探す

pattern の * は 1 区切り、`**` は何区切りでも (省略すると全部)。この端末の物も入る。答えはオブジェクトの Array (受け取り方は conn[path] と同じ)。ブロックを渡すと 1 つずつ渡し、数を返す。ネットワークに問い合わせないので、毎回呼んでよい。
```ruby
list = @link.conn.each(
  "*/talk_board/board")
@board = list[0]
```

### Asterism::Connection#nodes

<pre class="fmrb-sig"><code>nodes() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

今いる端末の名前

```ruby
names = @link.conn.nodes
```

### Asterism::Connection#apps

<pre class="fmrb-sig"><code>apps(?<a href="../String/">String</a> pattern) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

今いるアプリ ("端末/アプリ")

```ruby
list = @link.conn.apps("*/talk")
```

### Asterism::Connection#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

この端末/アプリの道

```ruby
me = @link.conn.path
```

### Asterism::Connection#publish

<pre class="fmrb-sig"><code>publish(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  ?type: (<a href="../Symbol/">Symbol</a> | <a href="../Integer/">Integer</a> | <a href="../String/">String</a>)?,
  ?unit: <a href="../String/">String</a>?,
  ?desc: <a href="../String/">String</a>?,
  ?ts: bool,
  ?encoding: <a href="../String/">String</a>?,
  ?shared: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?
) -&gt; <a href="../Asterism__Topic/">Asterism::Topic</a></code></pre>

トピックを出す (値を流せるように宣言する)

name は "said" や "game/score" (区切りは /)。ほかの端末からは
"<この端末>/<アプリ>/<name>" で受ける。返った Topic の put で値を流す。キーワード (type:・unit:・desc:・ts:) は省ける。残らない (後から受け始めた側には前の値は届かない)。つながっていないと Asterism::Disconnected。link_up の中で呼ぶ。
```ruby
def link_up(link)
  @said = link.conn.publish("said")
end
# ...
@said.put({ "text" => "hi" })
```

### Asterism::Connection#subscribe

<pre class="fmrb-sig"><code>subscribe(
  <a href="../String/">String</a> path,
  ?depth: <a href="../Integer/">Integer</a>?
) { (untyped value, <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info) -&gt; untyped } -&gt; <a href="../Asterism__Subscription/">Asterism::Subscription</a></code></pre>

トピックを受ける (ブロックで)

path は "<端末>/<アプリ>/<トピック>"。* は 1 区切り、`**` は何区切りでも。値が来るたびに、**update の中で**ブロックが |値, info| で呼ばれる (info は Asterism::SampleInfo)。自分で put した値は自分には届かない。**depth: で溜める数を変えられる**。止めるには返った Subscription の close。link_up の中で呼ぶ。
```ruby
def link_up(link)
  link.conn.subscribe(
    "*/talk_board/said") do |v, info|
    got(v, info.from)
  end
end
```

### Asterism::Connection#status

<pre class="fmrb-sig"><code>status(?<a href="../Hash/">Hash</a> status, **untyped fields) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

このアプリの状態を出す

Hash を渡すと全部を入れ替え、キーワードで渡すとその項目だけ変わる (nil で消える)。変わったときだけ流れる。1 KB まで。引数なしなら今の状態を返す (無ければ nil)。`status(lines: 3)` のようにキーワードで渡すと、その項目だけが変わる。
```ruby
@link.conn.status(
  { "lines" => @lines.size })
```

### Asterism::Connection#status_of

<pre class="fmrb-sig"><code>status_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

ほかのアプリの状態を読む

答えを待つ (既定 2 秒。`timeout:` は秒、`timeout_ms:` はミリ秒)。つながっていないと Asterism::Disconnected。
```ruby
st = @link.conn.status_of(
  "fmruby-1", "talk_board")
```

### Asterism::Connection#on_join

<pre class="fmrb-sig"><code>on_join() { (<a href="../String/">String</a> node) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

端末が来たときに呼ぶブロック

ブロックは |端末の名前| で、update の中で呼ばれる。link_up の中で渡す (つなぎ直すと消えるため)。
```ruby
link.conn.on_join { |n| joined(n) }
```

### Asterism::Connection#on_leave

<pre class="fmrb-sig"><code>on_leave() { (<a href="../String/">String</a> node) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

端末が去ったときに呼ぶブロック

切れたときは、知っていた端末が全部去る。
```ruby
link.conn.on_leave { |n| left(n) }
```

### Asterism::Connection#current_call

<pre class="fmrb-sig"><code>current_call() -&gt; <a href="../Asterism__CurrentCall/">Asterism::CurrentCall</a>?</code></pre>

今答えている呼び出し (だれから)

公開したメソッドの中で、呼んだ端末の名前を知るのに使う。
```ruby
def post(text)
  who = @link.conn.current_call.from
  add("#{who}: #{text}")
end
```

### Asterism::Connection#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a></code></pre>

このアプリの名前

```ruby
name = @link.conn.app
```

### Asterism::Connection#node_id

<pre class="fmrb-sig"><code>node_id() -&gt; <a href="../String/">String</a></code></pre>

この端末の名前 (ノード ID)

```ruby
me = @link.conn.node_id
```

### Asterism::Connection#run_id

<pre class="fmrb-sig"><code>run_id() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の接続の番号

接続するたびに変わる。トピックの値に付いて、受ける側が「送り手がつなぎ直した」と気づくのに使う (SampleInfo#restarted?)。
```ruby
id = @link.conn.run_id
```

### Asterism::Connection#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

つながっているか

つなぎ直しの途中 (reconnecting?) も true。セッションが閉じていると気づいたときは、その場で「切れた」ことにして false を返す。
```ruby
return unless conn.connected?
```

### Asterism::Connection#reconnecting?

<pre class="fmrb-sig"><code>reconnecting?() -&gt; bool</code></pre>

切れたあと自動でつなぎ直している最中か

true の間は connected? も true。ほかの端末は一度 leave し、戻ると
join し直す。呼び出しは Disconnected か時間切れ、put は誰にも届かない。戻ると、公開したオブジェクト・トピック・購読は元のまま使える。
```ruby
if conn.reconnecting?
  show("reconnecting")
end
```

### Asterism::Connection#lost_reason

<pre class="fmrb-sig"><code>lost_reason() -&gt; <a href="../String/">String</a>?</code></pre>

つながっていない理由

```ruby
why = @link.conn.lost_reason
```

### Asterism::Connection#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

つながりを閉じる

公開・トピック・購読もいっしょに終わり、on_join などのブロックも忘れる。何度呼んでも構わない。閉じたものはもう開かない
(Asterism.connect で作り直す)。Link を使うなら Link#close でよい。戻り値は nil。
```ruby
conn.close
```

### Asterism::Connection#poll

<pre class="fmrb-sig"><code>poll() -&gt; bool</code></pre>

毎回呼ぶ (答える・受ける・知らせる)

届いた呼び出しに答え、on_join / on_leave のブロックと subscribe のブロックを呼ぶ。つなぎ直しの待ちの中からは呼ばれない。閉じたら false。
**Link を使うなら Link#update が呼ぶので、自分では呼ばない**。
Asterism.poll_all はプログラムの全部の接続を呼ぶ。
```ruby
conn = Asterism.connect(r, app: "x")
conn.poll
```

### Asterism::Connection#session

<pre class="fmrb-sig"><code>session() -&gt; untyped</code></pre>

Zenoh のセッション

ROS 2 の Node (`Asterism::ROS::Node.new(conn.session, ...)`) や
put・subscribe を直接使うとき用。セッションは接続のもので、そこから close しても何も起きない (1 回だけ警告)。閉じるのは
Connection#close。つながっていないと Asterism::Disconnected。
```ruby
s = @link.conn.session
node = Asterism::ROS::Node.new(s, "n")
```

### Asterism::Connection#exposed

<pre class="fmrb-sig"><code>exposed() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

公開しているオブジェクトの名前

```ruby
names = @link.conn.exposed
```

### Asterism::Connection#unexpose

<pre class="fmrb-sig"><code>unexpose(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name) -&gt; bool</code></pre>

公開をやめる

公開していたら true、無ければ false。
```ruby
@link.conn.unexpose("board")
```

### Asterism::Connection#published

<pre class="fmrb-sig"><code>published() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

出しているトピックの名前

自分のトピックは名前、共有のものは "<端末>/@shared/<名前>" か
"@shared/<名前>"。
```ruby
list = @link.conn.published
```

### Asterism::Connection#unpublish

<pre class="fmrb-sig"><code>unpublish(
  <a href="../Asterism__Topic/">Asterism::Topic</a> | <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> topic,
  ?shared: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?
) -&gt; bool</code></pre>

トピックをやめる

Topic か、publish に渡した名前 (共有なら同じ `shared:` も) を渡す。宣言が消える。やめたら true、無いものは false。同じ名前でまた publish すると番号は続きから。
```ruby
@link.conn.unpublish("said")
```

### Asterism::Connection#unsubscribe

<pre class="fmrb-sig"><code>unsubscribe(<a href="../Asterism__Subscription/">Asterism::Subscription</a> sub) -&gt; bool</code></pre>

受けるのをやめる

Subscription#close と同じ。受けていたら true。
```ruby
@link.conn.unsubscribe(@sub)
```

### Asterism::Connection#off_join

<pre class="fmrb-sig"><code>off_join(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

on_join で渡したブロックを外す

渡したときの Proc を取っておき、同じものを渡す。
```ruby
h = proc { |n| joined(n) }
conn.on_join(&h)
conn.off_join(h)
```

### Asterism::Connection#off_leave

<pre class="fmrb-sig"><code>off_leave(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

on_leave で渡したブロックを外す

```ruby
conn.off_leave(h)
```

### Asterism::Connection#on_app_join

<pre class="fmrb-sig"><code>on_app_join() { (<a href="../String/">String</a> node, <a href="../String/">String</a> app) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

アプリが来たときに呼ぶブロック

ブロックは |端末の名前, アプリの名前| で、update の中で呼ばれる。
1 つの端末が複数のアプリを動かしていても、アプリごとに来る・去る。切れたときは、知っていたアプリが全部去る。link_up の中で渡す。
```ruby
conn.on_app_join do |n, a|
  seen(n, a)
end
```

### Asterism::Connection#on_app_leave

<pre class="fmrb-sig"><code>on_app_leave() { (<a href="../String/">String</a> node, <a href="../String/">String</a> app) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

アプリが去ったときに呼ぶブロック

```ruby
conn.on_app_leave do |n, a|
  gone(n, a)
end
```

### Asterism::Connection#off_app_join

<pre class="fmrb-sig"><code>off_app_join(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

on_app_join のブロックを外す

```ruby
conn.off_app_join(h)
```

### Asterism::Connection#off_app_leave

<pre class="fmrb-sig"><code>off_app_leave(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

on_app_leave のブロックを外す

```ruby
conn.off_app_leave(h)
```

### Asterism::Connection#profile

<pre class="fmrb-sig"><code>profile(
  ?kind: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?name: <a href="../String/">String</a>?,
  ?host: <a href="../String/">String</a>?,
  ?icon: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

この端末の名乗り (種類・名前・アイコン)

キーワードを渡すとその項目を変えて、全体を返す。渡さなければ今のものを返す。`kind:` (Symbol か String。nil で既定へ戻す)、`name:`・`host:`
(String。nil で外す)、`icon:` (PNG のバイト列。nil でアイコン無し)。受け付けないものは ArgumentError。名乗りは端末のもので、同じ端末のほかの接続にも効く。変えると流れる。
```ruby
conn.profile(name: "Rover")
```

### Asterism::Connection#profile_of

<pre class="fmrb-sig"><code>profile_of(
  <a href="../String/">String</a> node,
  ?icon: bool,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

ほかの端末の名乗りを読む

答えを待つ (既定 2 秒。`timeout:` は秒、`timeout_ms:` はミリ秒)。
`icon: false` でアイコンのバイト列を省く (icon_hash は付く)。つながっていないと Asterism::Disconnected。自分の端末は問い合わせない。
```ruby
p = @link.conn.profile_of(node)
name = p["name"] if p
```

### Asterism::Connection#protocol_of

<pre class="fmrb-sig"><code>protocol_of(
  <a href="../String/">String</a> node,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

端末やアプリが話す通信の版

"端末/アプリ" を渡すとそのアプリの版 (まだ見えていなければ nil)。端末だけなら、そのアプリの版の一番低いもの。アプリが見えない端末は名乗りに聞く (答えなければ nil、版が書いてなければ 0)。自分の版は
Asterism::PROTOCOL。
```ruby
v = conn.protocol_of("n/app")
```

### Asterism::Connection#define_type

<pre class="fmrb-sig"><code>define_type(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  <a href="../Array/">Array</a>[<a href="../Array/">Array</a>[untyped]] fields,
  ?desc: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

自分の型を決める

name は "mygame/board.strokes" のような名前。fields は
`[[名前, 型], ...]` で、型は名前 (組み込みの "vector3"、基本の "int"
"float" "str" "bin" "bool" "any"、別の自分の型。末尾に "[]" で配列)。値は欄の名前をキーにした Hash で、名前は短いほど値が小さい。
`desc:` (省略すると無し) は説明。同じ名前は置き換わる。つながりが閉じても残る。送った定義 ({"f" => ..., "d" => ...}) を返す。数を型にしたり不正な欄だと ArgumentError。publish の `type:` に名前を渡す。
```ruby
conn.define_type("g/pt",
  [["x", "int"], ["y", "int"]])
```

### Asterism::Connection#pubs_of

<pre class="fmrb-sig"><code>pubs_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

ほかのアプリのトピックを読む

`{トピック名 => {"t" => 型, "u" => 単位, ...}}`。何も出していなければ {}、答えが無ければ nil。status_of と同じ待ち方 (既定 2 秒、`timeout:`
は秒、`timeout_ms:` はミリ秒)。つながっていないと Asterism::Disconnected。
```ruby
t = @link.conn.pubs_of("n", "app")
```

### Asterism::Connection#types_of

<pre class="fmrb-sig"><code>types_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

ほかのアプリの自分の型を読む

`{型の名前 => {"f" => [[欄, 型], ...], "d" => 説明}}`。無ければ {}、答えが無ければ nil。待ち方は pubs_of と同じ。
```ruby
t = @link.conn.types_of("n", "app")
```

### Asterism::Connection#publishers_of

<pre class="fmrb-sig"><code>publishers_of(
  <a href="../String/">String</a> path,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

共有の場所に値を出しているアプリを探す

path は "@shared/<名前>" か "<端末>/@shared/<名前>" (端末は * も可)。
`{"端末/アプリ" => 宣言}` を返す (自分も入る)。誰もいなければ {}。全アプリの名乗りに一度に問い合わせて `timeout:` (秒、既定 2 秒) まで待つ (`timeout_ms:` はミリ秒)。共有の道でなければ ArgumentError、つながっていないと Asterism::Disconnected。
```ruby
who = conn.publishers_of(
  "@shared/lobby")
```

### Asterism::Connection#declaration_of

<pre class="fmrb-sig"><code>declaration_of(
  <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

受けた値の送り手の宣言を読む

info は subscribe のブロックの SampleInfo。送り手の @pubs の、そのキーの項目 (`{"t", "e", "u", "d", "ts"}`) を返す。共有の場所では送り手ごとに宣言が違うので、送り手 (info.from) に問い合わせる。送り手が分からない・答えない・宣言していなければ nil。初回だけ待ち (既定 2 秒)、答えは覚える。
```ruby
d = conn.declaration_of(info)
```

### Asterism::Connection#type_of

<pre class="fmrb-sig"><code>type_of(
  <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; (<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[untyped])?</code></pre>

受けた値の型を、送り手の宣言から読む

組み込みの型なら番号 (Integer)、自分の型なら `[名前, 定義]` (定義は送り手の自分の型の表から。無ければ nil)。型が無い・送り手が答えない場合は nil。待ち方と覚え方は declaration_of と同じ。
```ruby
t = conn.type_of(info)
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
