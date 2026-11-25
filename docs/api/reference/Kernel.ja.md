# Kernel

どこからでも呼べる出力・乱数・Proc の道具

`puts` の行は**ログに出る** (画面ではない)。`print` は改行しない。`rand` は max を省くか 0 で
0 以上 4294967295 以下の整数を返す (CRuby のような小数ではない)。`proc`・`lambda`・
`->` でブロックを Proc にする。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`MSG_TASK_KERNEL`</span> | [`Integer`](Integer.md) | カーネルの task 番号 (0) |
| <span class="fmrb-name">`MSG_TASK_HOST`</span> | [`Integer`](Integer.md) | ホストの task 番号 (1) |
| <span class="fmrb-name">`MSG_TASK_SYSTEM`</span> | [`Integer`](Integer.md) | デスクトップ (システムのアプリ) の task 番号 (2) |

## クラスメソッド

### Kernel.send_message

<pre class="fmrb-sig"><code>send_message(
  <a href="../Integer/">Integer</a> task_id,
  <a href="../Integer/">Integer</a> msg_type,
  <a href="../String/">String</a> data,
  ?<a href="../Integer/">Integer</a> timeout_ms
) -&gt; bool</code></pre>

待ち行列に生の文字列を送る

task_id は 0 から上限 (端末で 9) 未満 (**範囲の外は ArgumentError**)。
data は 64 バイトまで (**超えると ArgumentError**)。`timeout_ms`
(省略すると 100) は、行列が満杯のときに待つ長さ。

**送れたら true** で、行列が無い・満杯のまま timeout_ms が過ぎたときは
**false** (例外は出ない)。
```ruby
Kernel.send_message(0, 1, "key_down:13")
```

### Kernel.receive_message

<pre class="fmrb-sig"><code>receive_message(<a href="../Integer/">Integer</a> task_id, ?<a href="../Integer/">Integer</a> timeout_ms) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

待ち行列から 1 通取り出す

`[種類, 文字列]` の配列を返す。待っても来なければ **nil** (timeout_ms は省略すると 1000)。task_id が 0 から上限 (端末で 9) 未満の外なら
ArgumentError、行列が無いときは **RuntimeError** で、nil ではない。
**アプリ自身の番号を渡すと、`_spin` が読んでいるのと同じ行列を取り合う**。
```ruby
msg = Kernel.receive_message(2, 5000)
type, data = msg if msg
```

### Kernel.broadcast_message

<pre class="fmrb-sig"><code>broadcast_message(
  <a href="../Integer/">Integer</a> msg_type,
  <a href="../String/">String</a> data,
  ?<a href="../Integer/">Integer</a> timeout_ms
) -&gt; <a href="../Integer/">Integer</a></code></pre>

全部の待ち行列に送る

登録されている**全部の行列**に同じ伝言を入れ、入った数を返す。行列が満杯なら 1 つにつき `timeout_ms` (省略すると 10) まで待つ。data は
64 バイトまで (超えると ArgumentError)。
```ruby
n = Kernel.broadcast_message(99, "bye")
```

### Kernel.message_queue_exists?

<pre class="fmrb-sig"><code>message_queue_exists?(<a href="../Integer/">Integer</a> task_id) -&gt; bool</code></pre>

その task に待ち行列があるか

task_id が 0 から上限 (端末で 9) 未満の外なら ArgumentError。
```ruby
ready = Kernel.message_queue_exists?(0)
```

## インスタンスメソッド

### Kernel#p

<pre class="fmrb-sig"><code>p(*untyped objects) -&gt; untyped</code></pre>

中身が分かる形で出力する

**`inspect` した形**で出す。渡したものがそのまま返るので、式の途中に差し込める。
```ruby
p x
y = p compute
```

### Kernel#print

<pre class="fmrb-sig"><code>print(*untyped objects) -&gt; nil</code></pre>

出力する

**改行しない**。
```ruby
print "loading"
```

### Kernel#puts

<pre class="fmrb-sig"><code>puts(*untyped objects) -&gt; nil</code></pre>

改行をつけて出力する

**行はログに出る** (画面ではない)。sim なら `docker logs fmruby_core`、実機ならシリアル。`$stdout.puts` を呼ぶので書き方は `IO#puts` と同じ
(配列は 1 要素 1 行)。シェルで動かしたスクリプトではシェルの画面に出る。
```ruby
puts "started"
```

### Kernel#rand

<pre class="fmrb-sig"><code>rand(?<a href="../Integer/">Integer</a> max) -&gt; <a href="../Integer/">Integer</a></code></pre>

乱数を返す

**max を省くか 0 を渡すと、0 以上 4294967295 以下の整数** (CRuby のような 0 以上 1 未満の
Float ではない)。max があれば、**0 以上 max 未満**の整数 (`RNG.random_int % max`)。整数だけを受ける (Range・Float は使えない)。**種は与えられない** (`srand` は無い)。
```ruby
x = rand(10)    #=> 0..9
t = 2000 + rand(4000)
```

### Kernel#yield

<pre class="fmrb-sig"><code>yield(*untyped arguments) -&gt; untyped</code></pre>

渡されたブロックを呼ぶ

渡されたブロックを呼ぶ。**無いのに呼ぶと落ちる**ので `block_given?` で確かめる。
```ruby
yield(v) if block_given?
```

### Kernel#proc

<pre class="fmrb-sig"><code>proc() { (untyped argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

Proc を作る

**外のローカル変数は掴めない** (Spinel)。後で呼ぶブロックに渡す値はインスタンス変数か引数にする。
```ruby
f = proc { |v| draw(v) }
```

### Kernel#lambda

<pre class="fmrb-sig"><code>lambda() { (untyped argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

lambda を作る

`proc` との違いは引数の数の厳しさと `return` の効き方。
```ruby
f = lambda { |v| v * 2 }
```

### Kernel#->

<pre class="fmrb-sig"><code>-&gt;(untyped argument) { (untyped block_argument) -&gt; untyped } -&gt; <a href="../Proc/">Proc</a></code></pre>

手続きを短く書く

`lambda` の短い書き方。
```ruby
f = ->(v) { v * 2 }
f.call(3)
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
