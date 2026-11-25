# FmrbAsterism::Link

つなぐ・つなぎ直す・閉じる

使い方は [ネットワーク](../network.md) のページにあります。

アプリ 1 つに 1 つ。on_create で作り、on_update で毎回 update を呼び、on_destroy で close する。つながるたびにアプリの
**link_up(link)** を呼ぶ。つながらなかった・切れたときは、アプリに
**link_down(link)** があれば呼ぶ (無くてよい)。切れたら retry_ms
ごとに自分でつなぎ直す。

```ruby
def on_create
  @link = FmrbAsterism::Link.new(
    self, "talk")
end

def link_up(link)
  link.conn.expose("board", self,
    methods: { post: 1 })
end

def on_update
  @link.update
  100
end

def on_destroy
  @link.close
end
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_RETRY_MS`</span> | [`Integer`](Integer.md) | つなぎ直す間隔の既定 (ms) |
| <span class="fmrb-name">`DEFAULT_WIFI_WAIT_MS`</span> | [`Integer`](Integer.md) | WiFi を待つ上限の既定 (ms) |

## クラスメソッド

### FmrbAsterism::Link.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbApp/">FmrbApp</a> owner,
  <a href="../String/">String</a> app,
  ?tag: <a href="../String/">String</a>?,
  ?retry_ms: <a href="../Integer/">Integer</a>?,
  ?wifi_wait_ms: <a href="../Integer/">Integer</a>,
  ?screen_wait_ms: <a href="../Integer/">Integer</a>?,
  ?settings: <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a>?
) -&gt; FmrbAsterism::Link</code></pre>

作る (つなぐのは後の update)

owner はアプリ (self)。app はネットワークでのアプリの名前で、ほかの端末からは "<端末>/<app>/<オブジェクト>" で見える。
/・*・#・?・$ を含めない、@ で始めない。
**キーワードは省ける**: tag: (ログの頭)、retry_ms: (つなぎ直す間隔、既定 3000。nil なら 1 回だけ)。作っただけではつながない。同じ端末で同じ app 名は 1 つだけ (2 つ目は :still_there)。ほかのキーワード: `wifi_wait_ms:` (省略すると 20000。WiFi にアドレスが付くのを待つ上限)、`screen_wait_ms:` (省略すると待たない。値を渡すと screen_ready まで待つ)、`settings:` (省略すると
FmrbAsterism.settings)。
```ruby
@link = FmrbAsterism::Link.new(
  self, "talk", retry_ms: 5000)
```

## インスタンスメソッド

### FmrbAsterism::Link#update

<pre class="fmrb-sig"><code>update() -&gt; bool</code></pre>

毎回呼ぶ (答える・受ける・つなぐ)

つながっている間は届いた呼び出しに答え、subscribe のブロックを呼ぶ。つながっていなければ、時間が来たらつなぐ。つなぐ間
(ルータが無いと数秒) アプリは止まる。つながっている間 true。
```ruby
def on_update
  if @link.update
    check_call
  end
  100
end
```

### FmrbAsterism::Link#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

つながっているか

つなぎ直しの途中 (:reconnecting) も true。
```ruby
return unless @link.connected?
```

### FmrbAsterism::Link#up?

<pre class="fmrb-sig"><code>up?() -&gt; bool</code></pre>

出した物がほかに届く状態か

```ruby
@topic.put(v) if @link.up?
```

### FmrbAsterism::Link#state

<pre class="fmrb-sig"><code>state() -&gt; (:waiting_wifi | :waiting_screen | :connecting | :connected | :reconnecting | :retrying | :still_there | :lost | :failed | :closed)</code></pre>

今の状態

:connected がつながっている。:connecting は次の update でつなぐ (先に「つないでいます」を描ける)。:retrying・:lost・
:still_there は retry_ms の後にまたつなぐ。:failed は
retry_ms: nil で失敗した、:closed は close の後。
```ruby
if @link.state == :connecting
  show("つないでいます")
end
```

### FmrbAsterism::Link#reason

<pre class="fmrb-sig"><code>reason() -&gt; <a href="../String/">String</a></code></pre>

つながっていない理由

```ruby
def link_down(link)
  show(link.reason)
end
```

### FmrbAsterism::Link#conn

<pre class="fmrb-sig"><code>conn() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a>?</code></pre>

つながり (公開・呼び出し・トピック)

つながっている間だけある。つながる前・切れた後は nil。つなぎ直すと別の物になるので、変数にしまわず毎回 link.conn から取る (link_up の中か、connected? の後)。
```ruby
c = @link.conn
c.nodes if c
```

### FmrbAsterism::Link#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a></code></pre>

この端末の名前 (ノード ID)

```ruby
me = @link.node
```

### FmrbAsterism::Link#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a></code></pre>

ネットワークでのアプリの名前

```ruby
path = "#{@link.node}/#{@link.app}"
```

### FmrbAsterism::Link#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a></code></pre>

ルータの場所

```ruby
r = @link.router
```

### FmrbAsterism::Link#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

最後につなぐのにかかった時間 (ms)

```ruby
ms = @link.took_ms
```

### FmrbAsterism::Link#connects

<pre class="fmrb-sig"><code>connects() -&gt; <a href="../Integer/">Integer</a></code></pre>

つながった回数

```ruby
n = @link.connects
```

### FmrbAsterism::Link#lost

<pre class="fmrb-sig"><code>lost(<a href="../String/">String</a> why) -&gt; void</code></pre>

アプリの側でつながりをあきらめる

閉じて理由を残し、retry_ms の後につなぎ直す (link_down も呼ぶ)。
```ruby
@link.lost("no answer")
```

### FmrbAsterism::Link#close

<pre class="fmrb-sig"><code>close() -&gt; void</code></pre>

閉じる (もうつながない)

公開したオブジェクト・トピック・購読もいっしょに終わる。
```ruby
def on_destroy
  @link.close
end
```

### FmrbAsterism::Link#screen_ready

<pre class="fmrb-sig"><code>screen_ready() -&gt; void</code></pre>

画面ができたと知らせる

Link.new に screen_wait_ms: を渡したときだけ要る。
```ruby
@link.screen_ready
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
