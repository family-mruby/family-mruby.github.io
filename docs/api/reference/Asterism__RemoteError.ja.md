# Asterism::RemoteError

相手のメソッドが例外を出した・呼べなかった

使い方は [ネットワーク](../network.md) のページにあります。

継承元: [`Asterism::Error`](Asterism__Error.md)

## クラスメソッド

### Asterism::RemoteError.new

<pre class="fmrb-sig"><code>new(
  <a href="../String/">String</a> remote_class,
  <a href="../String/">String</a> remote_message,
  ?<a href="../String/">String</a>? remote_kind
) -&gt; Asterism::RemoteError</code></pre>

作る

```ruby
e = Asterism::RemoteError.new(
  "NameError", "x", "no_object")
```

## インスタンスメソッド

### Asterism::RemoteError#remote_class

<pre class="fmrb-sig"><code>remote_class() -&gt; <a href="../String/">String</a></code></pre>

相手の例外のクラスの名前

```ruby
rescue ::Asterism::RemoteError => e
  show(e.remote_class)
```

### Asterism::RemoteError#remote_message

<pre class="fmrb-sig"><code>remote_message() -&gt; <a href="../String/">String</a></code></pre>

相手の例外の文

```ruby
show(e.remote_message)
```

### Asterism::RemoteError#remote_kind

<pre class="fmrb-sig"><code>remote_kind() -&gt; <a href="../String/">String</a>?</code></pre>

何が起きたか

"raised" は相手のメソッドが例外を出した。"not_exposed" は公開していないメソッド、"no_object" はオブジェクトが無い、"arguments" は引数の数が違う、"unsendable" は送れない値を返した。
```ruby
if e.remote_kind == "not_exposed"
  show("呼べません")
end
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
