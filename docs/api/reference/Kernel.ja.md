# Kernel

## クラスメソッド

### Kernel.message_queue_exists?

<pre class="fmrb-sig"><code>message_queue_exists?(<a href="../Integer/">Integer</a> task_id) -&gt; bool</code></pre>

その task に待ち行列があるか

task_id が 0-15 の外なら ArgumentError。**9 以上は常に false**。
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

**行はログに出る** (画面ではない)。sim なら `docker logs fmruby_core`、実機ならシリアル。
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

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
