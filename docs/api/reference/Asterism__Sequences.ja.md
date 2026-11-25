# Asterism::Sequences

受けた値の番号の記憶

使い方は [ネットワーク](../network.md) のページにあります。

送り手ごと・道ごとに、最後の接続の番号と値の番号を覚えて、取りこぼし
(lost) と送り手のやり直し (restarted) を数える。Subscription が 1 つずつ持っていて、SampleInfo の lost・restarted はこれが決める。自分で値を受けるときに使う (普通のアプリは subscribe だけでよい)。

## クラスメソッド

### Asterism::Sequences.new

<pre class="fmrb-sig"><code>new(?<a href="../Integer/">Integer</a>? max) -&gt; Asterism::Sequences</code></pre>

作る

`max` (省略すると端末は 64、PC は 4096) を超えると、一番古く見た道を忘れる (その次の値は最初のものとして数える)。
```ruby
seqs = Asterism::Sequences.new(16)
```

## インスタンスメソッド

### Asterism::Sequences#see

<pre class="fmrb-sig"><code>see(
  <a href="../String/">String</a> lane,
  <a href="../Integer/">Integer</a>? run,
  <a href="../Integer/">Integer</a> seq,
  ?<a href="../String/">String</a>? app
) -&gt; <a href="../Array/">Array</a>[untyped]</code></pre>

値を 1 つ見る

lane は道 (共有の道は送り手も含めた文字列)、run は送り手の接続の番号 (nil なら番号なし)、seq は値の番号、app は送り手の
"端末/アプリ" (分からなければ nil)。`[取りこぼした数, 送り手がやり直したか]` を返す。道を初めて見るときは [0, false]。
```ruby
lost, again =
  seqs.see("k", 7, 1, "n/a")
```

### Asterism::Sequences#forget

<pre class="fmrb-sig"><code>forget(<a href="../String/">String</a> app) -&gt; <a href="../Integer/">Integer</a></code></pre>

あるアプリの記憶を忘れる

忘れた道の数を返す。
```ruby
n = seqs.forget("n/app")
```

### Asterism::Sequences#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

覚えている道の数

```ruby
n = seqs.size
```

### Asterism::Sequences#clear

<pre class="fmrb-sig"><code>clear() -&gt; Asterism::Sequences</code></pre>

全部忘れる

自分を返す。
```ruby
seqs.clear
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
