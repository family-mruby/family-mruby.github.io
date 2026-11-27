# Asterism::Pubs

トピックの宣言 (@pubs) の決まり

使い方は [ネットワーク](../network.md) のページにあります。

出しているトピックの宣言を ({"名前" => {"t", "e", "u", "d", "ts"}}) 送るときの決まりと、符号化の番号表。pubs_of や publishers_of の答えの形を知るときに読む。

## クラスメソッド

### Asterism::Pubs.encoding_id

<pre class="fmrb-sig"><code>encoding_id(<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

符号化の名前の番号

"image/jpeg" や "text/plain;charset=utf-8" (; から後は無視)。
```ruby
Asterism::Pubs.encoding_id(
  "image/jpeg")  #=> 17
```

### Asterism::Pubs.encoding_name

<pre class="fmrb-sig"><code>encoding_name(<a href="../Integer/">Integer</a> id) -&gt; <a href="../String/">String</a>?</code></pre>

番号から符号化の名前

```ruby
Asterism::Pubs.encoding_name(17)
#=> "image/jpeg"
```

### Asterism::Pubs.place

<pre class="fmrb-sig"><code>place(<a href="../String/">String</a> entry) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

宣言の項目から出す先を分ける

自分のトピックは `[nil, nil, 名前]`、"<端末>/@shared/<名前>" は
`[:node, 端末, 名前]`、"@shared/<名前>" は `[:global, nil, 名前]`。名前として使えない形なら nil。
```ruby
Asterism::Pubs.place("@shared/lobby")
#=> [:global, nil, "lobby"]
```

### Asterism::Pubs.entry

<pre class="fmrb-sig"><code>entry(<a href="../Symbol/">Symbol</a>? shared, <a href="../String/">String</a> node, <a href="../String/">String</a> name) -&gt; <a href="../String/">String</a></code></pre>

宣言の項目を作る

`shared` は nil・:node・:global。nil なら name のまま、:node なら
"<node>/@shared/<name>"、:global なら "@shared/<name>"。
```ruby
Asterism::Pubs.entry(
  :global, "n", "lobby")
#=> "@shared/lobby"
```

### Asterism::Pubs.path

<pre class="fmrb-sig"><code>path(<a href="../String/">String</a> node, <a href="../String/">String</a> app, <a href="../String/">String</a> entry) -&gt; <a href="../String/">String</a>?</code></pre>

宣言の項目から道を作る

`path("n", "app", "imu")` は "n/app/imu"、共有はその項目がそのまま
(端末は項目の中)。項目が正しくなければ nil。
```ruby
Asterism::Pubs.path("n", "app", "imu")
#=> "n/app/imu"
```

### Asterism::Pubs.check

<pre class="fmrb-sig"><code>check(untyped h, ?<a href="../String/">String</a>? node) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

受けた宣言の表を整える

項目名として正しく、宣言が Hash のものを残し、"t"・"e"・"u"・"d"・"ts" の正しいものだけを入れる。node (宣言を出した端末) を渡すと、ほかの端末の共有の項目は落とす。Hash でなければ nil。pubs_of の答えはこれを通ってくる。
```ruby
d = Asterism::Pubs.check(raw, "n")
```

### Asterism::Pubs.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> key, <a href="../String/">String</a> payload) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

@pubs への put を読む

key と payload (購読した側が受けるまま) から `[端末, アプリ, 宣言]` を返す。そうでなければ nil。
```ruby
n, a, d = Asterism::Pubs.parse(k, b)
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
