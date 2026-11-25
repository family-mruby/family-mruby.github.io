# Asterism::Proxy

ほかの端末のオブジェクトの代わり

使い方は [ネットワーク](../network.md) のページにあります。

conn[path] の答え。公開されたメソッドを、そのまま普通のメソッドのように呼ぶ
(`board.post("hi")`)。呼ぶと答えを待つ。

## インスタンスメソッド

### Asterism::Proxy#async

<pre class="fmrb-sig"><code>async() -&gt; <a href="../Asterism__AsyncProxy/">Asterism::AsyncProxy</a></code></pre>

待たずに呼ぶ形にする

メソッドを呼ぶと、すぐに Asterism::Future が返る。update のたびに
done? を見て、true になったら value で答えを取る。
```ruby
@call = @board.async.post("hi")
# on_update:
if @call && @call.done?
  n = @call.value
  @call = nil
end
```

### Asterism::Proxy#asterism_call

<pre class="fmrb-sig"><code>asterism_call(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  *untyped args,
  **untyped kw
) -&gt; untyped</code></pre>

名前でメソッドを呼ぶ

普通は `board.post("hi")` と書けばよい。名前が Ruby で書けないときや、class・display など Object が持つ名前のときに使う。
```ruby
v = board.asterism_call("post", "hi")
```

### Asterism::Proxy#asterism_path

<pre class="fmrb-sig"><code>asterism_path() -&gt; <a href="../String/">String</a></code></pre>

相手の道

```ruby
node = px.asterism_path.split("/")[0]
```

### Asterism::Proxy#remote_methods

<pre class="fmrb-sig"><code>remote_methods() -&gt; <a href="../Array/">Array</a>[<a href="../Symbol/">Symbol</a>]</code></pre>

相手が公開しているメソッドの名前

答えを待つ。答えが無ければ Asterism::Error。
```ruby
names = board.remote_methods
```

### Asterism::Proxy#asterism_connection

<pre class="fmrb-sig"><code>asterism_connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

呼び出しが出ていく接続

```ruby
c = board.asterism_connection
```

### Asterism::Proxy#asterism_meta

<pre class="fmrb-sig"><code>asterism_meta() -&gt; <a href="../Hash/">Hash</a></code></pre>

相手が答えるメソッドの表

`{"methods" => [{"name" => ..., "arity" => ...}, ...]}`。初回は相手に問い合わせて待つ。答えが無ければ Asterism::TimeoutError か
Asterism::RemoteError ("no_object")、切れていれば Asterism::Disconnected。
```ruby
m = board.asterism_meta
```

### Asterism::Proxy#asterism_refresh

<pre class="fmrb-sig"><code>asterism_refresh() -&gt; Asterism::Proxy</code></pre>

覚えている表を捨てる

次に asterism_meta や remote_methods を呼ぶと問い合わせ直す。自分を返す。
```ruby
board.asterism_refresh
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
