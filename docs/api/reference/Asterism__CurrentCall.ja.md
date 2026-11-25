# Asterism::CurrentCall

今答えている呼び出し

使い方は [ネットワーク](../network.md) のページにあります。

conn.current_call の答え。

## インスタンスメソッド

### Asterism::CurrentCall#from

<pre class="fmrb-sig"><code>from() -&gt; <a href="../String/">String</a></code></pre>

呼んだ端末の名前

```ruby
who = @link.conn.current_call.from
```

### Asterism::CurrentCall#object

<pre class="fmrb-sig"><code>object() -&gt; <a href="../String/">String</a></code></pre>

呼ばれたオブジェクトの名前

```ruby
o = call.object
```

### Asterism::CurrentCall#method

<pre class="fmrb-sig"><code>method() -&gt; <a href="../String/">String</a></code></pre>

呼ばれたメソッドの名前

```ruby
m = call.method
```

### Asterism::CurrentCall#verified

<pre class="fmrb-sig"><code>verified() -&gt; (:claimed | :local)</code></pre>

呼んだ人を確かめた程度

:claimed は呼んだ側が自分で名乗った名前 (名前を確かにするのはルータのアクセス制御)。:local は同じアプリの中からの呼び出し。
```ruby
trust = conn.current_call.verified
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
