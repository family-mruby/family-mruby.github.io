# Asterism::AsyncProxy

待たずに呼ぶ形

使い方は [ネットワーク](../network.md) のページにあります。

Proxy#async の答え。メソッドを呼ぶと Future が返る。

## インスタンスメソッド

### Asterism::AsyncProxy#asterism_call

<pre class="fmrb-sig"><code>asterism_call(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  *untyped args,
  **untyped kw
) -&gt; <a href="../Asterism__Future/">Asterism::Future</a></code></pre>

名前で呼んで、すぐ Future を受け取る

```ruby
f = board.async.asterism_call(
  "post", "hi")
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
