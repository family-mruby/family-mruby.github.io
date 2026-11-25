# Asterism::ROS::Subscription

トピックの Subscription (node.subscription・node.subscribe の答え)

使い方は [ネットワーク](../network.md) のページにあります。

届いたメッセージは溜まり、each_pending で取り出す。node.subscribe で作ると、取り出しは Node#poll がブロックに渡す。

## インスタンスメソッド

### Asterism::ROS::Subscription#each_pending

<pre class="fmrb-sig"><code>each_pending() { (<a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a> msg, <a href="../Asterism__ROS__Attachment/">Asterism::ROS::Attachment</a>? info) -&gt; untyped } -&gt; <a href="../Integer/">Integer</a>
each_pending() -&gt; <a href="../Array/">Array</a>[<a href="../Array/">Array</a>[untyped]]</code></pre>

溜まったメッセージを取り出す

復号した `[メッセージ, 添え物]` を 1 つずつブロックに渡し、数を返す。ブロックが無ければ `[[msg, info], ...]` の Array。添え物は
Asterism::ROS::Attachment (無ければ nil)。復号できないものは数えて
(errors) 捨てる。
```ruby
sub.each_pending do |m, info|
  got(m)
end
```

### Asterism::ROS::Subscription#pending

<pre class="fmrb-sig"><code>pending() -&gt; <a href="../Integer/">Integer</a></code></pre>

溜まっている数

```ruby
n = sub.pending
```

### Asterism::ROS::Subscription#received

<pre class="fmrb-sig"><code>received() -&gt; <a href="../Integer/">Integer</a></code></pre>

受けた数

```ruby
n = sub.received
```

### Asterism::ROS::Subscription#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

溢れて捨てた数

```ruby
n = sub.dropped
```

### Asterism::ROS::Subscription#errors

<pre class="fmrb-sig"><code>errors() -&gt; <a href="../Integer/">Integer</a></code></pre>

復号できなかった数

```ruby
n = sub.errors
```

### Asterism::ROS::Subscription#handler

<pre class="fmrb-sig"><code>handler() -&gt; <a href="../Proc/">Proc</a>?</code></pre>

node.subscribe のブロック

```ruby
b = sub.handler
```

### Asterism::ROS::Subscription#handler=

<pre class="fmrb-sig"><code>handler=(<a href="../Proc/">Proc</a>? blk) -&gt; <a href="../Proc/">Proc</a>?</code></pre>

ブロックを付け替える

Node#poll が渡す先を変える。**node.subscribe で作ったものだけ**
Node#poll が渡す (node.subscription の物は each_pending で取る)。
```ruby
sub.handler = proc { |m, i| got(m) }
```

### Asterism::ROS::Subscription#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

受けるのをやめる

nil を返す。
```ruby
sub.close
```

### Asterism::ROS::Subscription#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

やめたか

```ruby
return if sub.closed?
```

### Asterism::ROS::Subscription#topic_key

<pre class="fmrb-sig"><code>topic_key() -&gt; <a href="../String/">String</a></code></pre>

データのキー

```ruby
k = sub.topic_key
```

### Asterism::ROS::Subscription#token_key

<pre class="fmrb-sig"><code>token_key() -&gt; <a href="../String/">String</a></code></pre>

liveliness のキー

```ruby
k = sub.token_key
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
