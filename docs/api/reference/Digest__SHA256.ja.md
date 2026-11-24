# Digest::SHA256

SHA-256 を計算する

**ブラウザ版だけにある**。ほかのビルドでも動くコードは、先に
`Object.const_defined?(:Digest)` で調べる (chat の stamps.rb が実例)。
```ruby
d = Digest::SHA256.new
d.update("abc")
d.hexdigest.size   #=> 64
```

## クラスメソッド

### Digest::SHA256.new

<pre class="fmrb-sig"><code>new() -&gt; Digest::SHA256</code></pre>

新しい計算を始める

```ruby
d = Digest::SHA256.new
```

### Digest::SHA256.hexdigest

<pre class="fmrb-sig"><code>hexdigest(<a href="../String/">String</a> data) -&gt; <a href="../String/">String</a></code></pre>

1 回で 16 進の文字列にする

渡すのは String (バイト列も可)。それ以外は TypeError。結果は小文字 16 進の 64 桁。
```ruby
Digest::SHA256.hexdigest("abc")
#=> "ba7816bf8f01cfea..." (64 桁)
```

## インスタンスメソッド

### Digest::SHA256#update

<pre class="fmrb-sig"><code>update(<a href="../String/">String</a> data) -&gt; Digest::SHA256</code></pre>

続きのデータを足す

自分を返すので `d.update(a).update(b)` と続けられる。`<<` も同じ。
```ruby
d.update(chunk)
```

### Digest::SHA256#<<

<pre class="fmrb-sig"><code>&lt;&lt;(<a href="../String/">String</a> data) -&gt; Digest::SHA256</code></pre>

update の別名

```ruby
d << chunk
```

### Digest::SHA256#hexdigest

<pre class="fmrb-sig"><code>hexdigest() -&gt; <a href="../String/">String</a></code></pre>

ここまでの 16 進の結果

**何度呼んでもよく、呼んだ後に `update` を続けてもよい** (内部の状態は変わらない)。
```ruby
d.hexdigest   #=> 64 桁の小文字 16 進
```

### Digest::SHA256#digest

<pre class="fmrb-sig"><code>digest() -&gt; <a href="../String/">String</a></code></pre>

ここまでの結果の 32 バイト

`hexdigest` と同じく状態を変えない。
```ruby
raw = d.digest
raw.bytesize   #=> 32
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
