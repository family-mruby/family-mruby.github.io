# Asterism::Subscription

受けているトピック

使い方は [ネットワーク](../network.md) のページにあります。

conn.subscribe の答え。

## インスタンスメソッド

### Asterism::Subscription#close

<pre class="fmrb-sig"><code>close() -&gt; bool</code></pre>

受けるのをやめる

```ruby
@sub.close
```

### Asterism::Subscription#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

やめたか

```ruby
@sub.closed?
```

### Asterism::Subscription#received

<pre class="fmrb-sig"><code>received() -&gt; <a href="../Integer/">Integer</a></code></pre>

これまでに受けた数

```ruby
n = @sub.received
```

### Asterism::Subscription#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

受けている道

```ruby
p = @sub.path
```

### Asterism::Subscription#connection

<pre class="fmrb-sig"><code>connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

この購読の接続

```ruby
c = @sub.connection
```

### Asterism::Subscription#dropped

<pre class="fmrb-sig"><code>dropped() -&gt; <a href="../Integer/">Integer</a></code></pre>

取りこぼした数

次の update までに溜められる数 (`depth:`) を超えて、捨てた数。
```ruby
warn_gap if @sub.dropped > 0
```

### Asterism::Subscription#malformed

<pre class="fmrb-sig"><code>malformed() -&gt; <a href="../Integer/">Integer</a></code></pre>

読めなかった値の数

```ruby
bad = @sub.malformed
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
