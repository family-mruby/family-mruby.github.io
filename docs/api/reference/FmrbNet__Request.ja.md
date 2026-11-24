# FmrbNet::Request

取得 1 件 (FmrbNet.request が返す)

使い方は [ネットワーク](../network.md) のページにあります。

`on_update` で `done?` を見て、true になったら `ok?` と `body` を読む。
```ruby
if @req && @req.done?
  use(@req.body) if @req.ok?
  @req = nil
end
```

## インスタンスメソッド

### FmrbNet::Request#url

<pre class="fmrb-sig"><code>url() -&gt; <a href="../String/">String</a></code></pre>

取得した URL

```ruby
@req.url
```

### FmrbNet::Request#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

終わったか

失敗で終わっても true。**終わりを見た時に結果 (`status`・`body`・`error`) が確定する**ので、結果は `done?` が true になってから読む。
```ruby
return unless @req.done?
```

### FmrbNet::Request#ok?

<pre class="fmrb-sig"><code>ok?() -&gt; bool</code></pre>

うまくいった (HTTP の 2xx) か

終わっていないと false (中で `done?` を呼ぶ)。`error` があっても false。
```ruby
@req.ok?
```

### FmrbNet::Request#status

<pre class="fmrb-sig"><code>status() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

HTTP の状態コード

終わるまで、また通信の失敗では nil。
```ruby
@req.status   #=> 200
```

### FmrbNet::Request#body

<pre class="fmrb-sig"><code>body() -&gt; <a href="../String/">String</a>?</code></pre>

取得した本文

終わるまで、また失敗では nil。
```ruby
text = @req.body
```

### FmrbNet::Request#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

失敗の理由

成功なら nil。届かなかった・答えが無かった・`cancel` した ("cancelled") などの短い文。
```ruby
Log.warn(@req.error) if @req.error
```

### FmrbNet::Request#cancel

<pre class="fmrb-sig"><code>cancel() -&gt; nil</code></pre>

答えを待つのをやめる

何度呼んでもよい。以後は `done?` が true で、`error` は "cancelled" (すでに別の理由があればそのまま)。nil を返す。
```ruby
@req.cancel
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
