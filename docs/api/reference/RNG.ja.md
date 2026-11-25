# RNG

乱数の元

ESP32 は `esp_random()` (ハードウェアの乱数)、Linux・ネイティブ版は `/dev/urandom` から読む
(1 バイトごとにファイルを開くので、数を大量に作るときは遅い)。
```ruby
r = RNG.random_int % 10
```

## クラスメソッド

### RNG.random_int

<pre class="fmrb-sig"><code>random_int() -&gt; <a href="../Integer/">Integer</a></code></pre>

32 ビットの乱数 (整数)

**0 以上 4294967295 以下**の整数 (負にならない)。範囲を絞るときは `% n` で 0 から n-1 にする
(`Kernel#rand(n)` と同じ)。**種は与えられない**。
```ruby
RNG.random_int % 10   #=> 0..9
```

### RNG.random_string

<pre class="fmrb-sig"><code>random_string(<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

乱数のバイト列を作る

length バイトのバイナリ文字列 (文字ではなくバイト。`bytesize` で数える)。
```ruby
key = RNG.random_string(16)
```

### RNG.uuid

<pre class="fmrb-sig"><code>uuid() -&gt; <a href="../String/">String</a></code></pre>

UUID (バージョン 4) の文字列を作る

`8-4-4-4-12` 桁の 16 進 (小文字) を `-` でつないだ 36 文字。乱数を 32 回引くので軽くはない。
```ruby
id = RNG.uuid
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
