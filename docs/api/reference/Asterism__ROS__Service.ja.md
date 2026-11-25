# Asterism::ROS::Service

提供しているサービス (node.service の答え)

使い方は [ネットワーク](../network.md) のページにあります。

要求への答えは Node#poll が handle_pending を呼んで行う。node を使わずに自分で handle_pending を呼んでもよい。

## インスタンスメソッド

### Asterism::ROS::Service#handle_pending

<pre class="fmrb-sig"><code>handle_pending() -&gt; <a href="../Integer/">Integer</a></code></pre>

届いている要求に答える

要求を型の Request に復号して、node.service のブロックを呼び、答えを送る。復号できない・添え物の無い要求は数えて (errors) 答えない。ブロックが例外を出した要求は答えず終わり、例外はここから出る。答えた数を返す。
```ruby
n = srv.handle_pending
```

### Asterism::ROS::Service#handled

<pre class="fmrb-sig"><code>handled() -&gt; <a href="../Integer/">Integer</a></code></pre>

答えた数

```ruby
n = srv.handled
```

### Asterism::ROS::Service#errors

<pre class="fmrb-sig"><code>errors() -&gt; <a href="../Integer/">Integer</a></code></pre>

受け付けられなかった数

```ruby
n = srv.errors
```

### Asterism::ROS::Service#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じる

nil を返す。
```ruby
srv.close
```

### Asterism::ROS::Service#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

閉じたか

```ruby
return if srv.closed?
```

### Asterism::ROS::Service#service_key

<pre class="fmrb-sig"><code>service_key() -&gt; <a href="../String/">String</a></code></pre>

サービスのキー

```ruby
k = srv.service_key
```

### Asterism::ROS::Service#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

liveliness のキー

```ruby
k = srv.token_key
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
