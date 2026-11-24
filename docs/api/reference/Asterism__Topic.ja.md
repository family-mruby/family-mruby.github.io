# Asterism::Topic

出したトピック (conn.publish の答え)

使い方は [ネットワーク](../network.md) のページにあります。

## インスタンスメソッド

### Asterism::Topic#put

<pre class="fmrb-sig"><code>put(untyped value) -&gt; void</code></pre>

値を流す

送れるのは nil・true・false・数・文字列・Symbol・Array・Hash だけ
(ほかは Asterism::EncodeError)。受けている側全部に届く。閉じた・切れたトピックは Asterism::Disconnected。
```ruby
@said.put({ "from" => who,
            "text" => text })
```

### Asterism::Topic#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

トピックの名前

```ruby
n = @said.name
```

### Asterism::Topic#close

<pre class="fmrb-sig"><code>close() -&gt; bool</code></pre>

トピックをやめる

```ruby
@said.close
```

### Asterism::Topic#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

トピックが閉じているか

```ruby
return if @said.closed?
```

### Asterism::Topic#connection

<pre class="fmrb-sig"><code>connection() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

このトピックを出した接続

```ruby
c = @said.connection
```

### Asterism::Topic#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

流している道

```ruby
k = @said.key
```

### Asterism::Topic#entry

<pre class="fmrb-sig"><code>entry() -&gt; <a href="../String/">String</a></code></pre>

宣言の項目名

自分のトピックは name と同じ。共有なら "<端末>/@shared/<名前>" か
"@shared/<名前>"。published が返すのはこれ。
```ruby
e = @said.entry
```

### Asterism::Topic#shared

<pre class="fmrb-sig"><code>shared() -&gt; (:node | :global)?</code></pre>

共有の場所か

nil は自分の道、:node は端末の @shared、:global はネットワークの @shared。
```ruby
s = @said.shared
```

### Asterism::Topic#encoding

<pre class="fmrb-sig"><code>encoding() -&gt; <a href="../String/">String</a>?</code></pre>

値と一緒に送った符号化

publish の `encoding:` に渡したもの ("image/jpeg" など)。
```ruby
e = @cam.encoding
```

### Asterism::Topic#seq

<pre class="fmrb-sig"><code>seq() -&gt; <a href="../Integer/">Integer</a></code></pre>

次に送る値の番号

0 から始まり、2147483647 の次は 0 に戻る。
```ruby
n = @said.seq
```

### Asterism::Topic#ts?

<pre class="fmrb-sig"><code>ts?() -&gt; bool</code></pre>

送り手の時刻も付けるか

publish の `ts: true` のとき true。
```ruby
t = @said.ts?
```

### Asterism::Topic#declaration

<pre class="fmrb-sig"><code>declaration() -&gt; <a href="../Hash/">Hash</a></code></pre>

送った宣言

`{"t" => 型, "u" => 単位, "d" => 説明, "e" => 符号化の番号, "ts" => true}`
のうち、指定した項目だけ。コピーを返す。
```ruby
d = @said.declaration
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
