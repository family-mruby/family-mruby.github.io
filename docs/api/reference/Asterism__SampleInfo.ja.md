# Asterism::SampleInfo

受けた値に付いてくる情報

使い方は [ネットワーク](../network.md) のページにあります。

subscribe のブロックの 2 つ目。

## インスタンスメソッド

### Asterism::SampleInfo#from

<pre class="fmrb-sig"><code>from() -&gt; <a href="../String/">String</a>?</code></pre>

送った端末/アプリ

```ruby
do |v, info|
  who = info.from
end
```

### Asterism::SampleInfo#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a>?</code></pre>

送った端末の名前

```ruby
n = info.node
```

### Asterism::SampleInfo#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a>?</code></pre>

送ったアプリの名前

```ruby
a = info.app
```

### Asterism::SampleInfo#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

トピックの名前

```ruby
t = info.name
```

### Asterism::SampleInfo#lost

<pre class="fmrb-sig"><code>lost() -&gt; <a href="../Integer/">Integer</a></code></pre>

前の値から取りこぼした数

```ruby
warn_gap if info.lost > 0
```

### Asterism::SampleInfo#seq

<pre class="fmrb-sig"><code>seq() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

送った側の番号

```ruby
s = info.seq
```

### Asterism::SampleInfo#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

値が届いた道

```ruby
k = info.key
```

### Asterism::SampleInfo#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

値が届いた道 (asterism/ の下)

```ruby
p = info.path
```

### Asterism::SampleInfo#shared

<pre class="fmrb-sig"><code>shared() -&gt; (:node | :global)?</code></pre>

共有の場所か

```ruby
sh = info.shared
```

### Asterism::SampleInfo#run_id

<pre class="fmrb-sig"><code>run_id() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

送り手の接続の番号

送り手がつなぎ直すと変わる。
```ruby
r = info.run_id
```

### Asterism::SampleInfo#time

<pre class="fmrb-sig"><code>time() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

送り手の時刻

```ruby
t = info.time
```

### Asterism::SampleInfo#timestamp

<pre class="fmrb-sig"><code>timestamp() -&gt; untyped</code></pre>

ルータが付けた時刻

型は Asterism::Zenoh::Timestamp。
```ruby
ts = info.timestamp
```

### Asterism::SampleInfo#encoding

<pre class="fmrb-sig"><code>encoding() -&gt; <a href="../String/">String</a></code></pre>

値の符号化

"msgpack" なら値は復号した Ruby の値、それ以外はバイト列 (String)。
```ruby
if info.encoding == "image/jpeg"
  img = v
end
```

### Asterism::SampleInfo#restarted?

<pre class="fmrb-sig"><code>restarted?() -&gt; bool</code></pre>

送り手が新しく始めたか

接続し直した (接続の番号が変わった) か、同じ接続で番号が戻ったとき true。接続し直したときの lost は 0。「今の値」を問い合わせ直す合図に使う。
```ruby
ask_again if info.restarted?
```

### Asterism::SampleInfo#to_h

<pre class="fmrb-sig"><code>to_h() -&gt; <a href="../Hash/">Hash</a></code></pre>

全部の項目の Hash

`key`・`path`・`shared`・`from`・`node`・`app`・`name`・`seq`・`run_id`・
`time`・`encoding`・`timestamp`・`lost`・`restarted` を Symbol のキーで返す。
```ruby
puts info.to_h
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
