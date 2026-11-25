# GC

ガベージコレクタの操作と統計

ふつうのアプリは触らなくてよい。拍を守るアプリ (演奏・アニメ) が、回収の止まる時間を避けるために使う。まとめて切り替えるなら `FmrbApp#idle_gc=` (中で `scheduler_driven`・
`debt_limit`・`step_limit`・`malloc_threshold` を合わせて設定する) を使う。
```ruby
GC.start
n = GC.stat[:live]
```

## クラスメソッド

### GC.start

<pre class="fmrb-sig"><code>start() -&gt; nil</code></pre>

回収を最後まで 1 回やる

戻り値は nil。**一気に最後まで回すので、その間アプリが止まる** (生きているものが多いほど長い)。計測の前に揃えたいとき (`GC.start` のあとに `GC.stat` を読む) に使う。
```ruby
GC.start
before = GC.stat[:live]
```

### GC.disable

<pre class="fmrb-sig"><code>disable() -&gt; bool</code></pre>

回収を止める

**それまでに止まっていたら true、動いていたら false** を返す。止めている間は確保が増える一方なので、短い区間だけにして、すぐ `GC.enable` で戻す。
**止めている間は `generational_mode=` も RuntimeError になる**。
```ruby
was = GC.disable
work
GC.enable unless was
```

### GC.enable

<pre class="fmrb-sig"><code>enable() -&gt; bool</code></pre>

回収を戻す

**それまで止まっていたら true、動いていたら false** を返す (`GC.disable` と対)。
```ruby
GC.enable
```

### GC.stat

<pre class="fmrb-sig"><code>stat() -&gt; <a href="../Hash/">Hash</a>[<a href="../Symbol/">Symbol</a>, untyped]</code></pre>

回収の状態の数を返す

キーは Symbol。**どのビルドにもあるキー**: `:live` (生きているオブジェクトの数)・
`:debt` (回収が遅れている分のオブジェクト数)・`:state` (回収の段。0 = 待ち、1 = 印を付ける、
2 = 掃く)・`:generational` (世代別か)・`:full` (全体の回収か)・`:step_limit`・
`:malloc_increase`・`:malloc_threshold` (どちらもバイト)・`:symbol_count`・
`:dynamic_symbol_count`。

**計測用のビルドにだけあるキー**: `:total`・`:minor`・`:major` (回収の回数。`MRB_GC_STATS`)、
`:prof_` で始まる停止時間の統計 (`FMRB_GC_PROFILE=1` で作った版だけ)。ふつうのビルドでは無いので、読むときは `GC.stat[:total] || 0` のように nil を考える。
```ruby
live = GC.stat[:live] || 0
```

### GC.reset_stat

<pre class="fmrb-sig"><code>reset_stat() -&gt; nil</code></pre>

停止時間の統計を 0 に戻す

**計測用のビルド (`FMRB_GC_PROFILE=1`) にだけある**。ふつうのビルドでは NoMethodError になるので、`GC.respond_to?(:reset_stat)` で確かめてから呼ぶ。戻り値は nil。
```ruby
GC.reset_stat if GC.respond_to?(:reset_stat)
```

### GC.interval_ratio

<pre class="fmrb-sig"><code>interval_ratio() -&gt; <a href="../Integer/">Integer</a></code></pre>

回収の間隔の割合 (%)

ソースのコメントでは初期値 200。
```ruby
r = GC.interval_ratio
```

### GC.interval_ratio=

<pre class="fmrb-sig"><code>interval_ratio=(<a href="../Integer/">Integer</a> ratio) -&gt; nil</code></pre>

回収の間隔の割合を決める

戻り値は nil。100 にすると、1 回の回収が終わったらすぐ次を始める (ソースのコメント)。
```ruby
GC.interval_ratio = 150
```

### GC.step_ratio

<pre class="fmrb-sig"><code>step_ratio() -&gt; <a href="../Integer/">Integer</a></code></pre>

1 段の仕事の幅の割合 (%)

ソースのコメントでは初期値 200。
```ruby
r = GC.step_ratio
```

### GC.step_ratio=

<pre class="fmrb-sig"><code>step_ratio=(<a href="../Integer/">Integer</a> ratio) -&gt; nil</code></pre>

1 段の仕事の幅の割合を決める

**0 以下は ArgumentError** ("step_ratio must be positive")。戻り値は nil。大きいほど 1 段が長い。
```ruby
GC.step_ratio = 200
```

### GC.step_limit

<pre class="fmrb-sig"><code>step_limit() -&gt; <a href="../Integer/">Integer</a></code></pre>

1 段の仕事の上限

0 は上限なし。
```ruby
n = GC.step_limit
```

### GC.step_limit=

<pre class="fmrb-sig"><code>step_limit=(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Integer/">Integer</a></code></pre>

1 段の仕事の上限を決める

0 は上限なし。**負は ArgumentError** ("step_limit must be non-negative")。渡した値を返す。
**途中で止められない 1 段の長さの上限**になるので、拍を守りたいアプリが小さくする
(`FmrbApp#idle_gc=` は 512 にする)。
```ruby
GC.step_limit = 512
```

### GC.malloc_threshold

<pre class="fmrb-sig"><code>malloc_threshold() -&gt; <a href="../Integer/">Integer</a></code></pre>

回収を始めるバイト増加の線

0 は使わない。
```ruby
n = GC.malloc_threshold
```

### GC.malloc_threshold=

<pre class="fmrb-sig"><code>malloc_threshold=(<a href="../Integer/">Integer</a> bytes) -&gt; <a href="../Integer/">Integer</a></code></pre>

回収を始めるバイト増加の線を決める

確保したバイトがこれだけ増えたら 1 回分の回収を進める。文字列や配列の中身のように、
**オブジェクトの数に出ない大きな確保**を拾う。0 で使わない。**負は ArgumentError**
("malloc_threshold must be non-negative")。渡した値を返す。
```ruby
GC.malloc_threshold = 32 * 1024
```

### GC.generational_mode

<pre class="fmrb-sig"><code>generational_mode() -&gt; bool</code></pre>

世代別の回収か

```ruby
g = GC.generational_mode
```

### GC.generational_mode=

<pre class="fmrb-sig"><code>generational_mode=(bool enable) -&gt; bool</code></pre>

世代別の回収を切り替える

渡した true / false を返す。**`GC.disable` している間は RuntimeError**
("generational mode changed when GC disabled")、
**`scheduler_driven` が true の間に true にしても RuntimeError**。
`scheduler_driven = true` にすると世代別は切れ、false に戻しても自動では戻らない。
```ruby
GC.generational_mode = true
```

### GC.scheduler_driven

<pre class="fmrb-sig"><code>scheduler_driven() -&gt; bool</code></pre>

回収をスケジューラに任せているか

```ruby
d = GC.scheduler_driven
```

### GC.scheduler_driven=

<pre class="fmrb-sig"><code>scheduler_driven=(bool enable) -&gt; bool</code></pre>

回収をスケジューラの空き時間に任せる

true にすると、確保のたびに回収を進めるのをやめ、アプリが待っている間 (`_spin`) に少しずつ進める。**世代別は切れ**、`GC.disable` している間は RuntimeError。false で元に戻る
(世代別は戻らない)。**ずっと忙しいアプリは空きが無く進まない**ので、`debt_limit` を超えると確保の側が回収を強制する。ふつうは `FmrbApp#idle_gc=` を使う。渡した値を返す。
```ruby
GC.scheduler_driven = true
```

### GC.debt_limit

<pre class="fmrb-sig"><code>debt_limit() -&gt; <a href="../Integer/">Integer</a></code></pre>

回収の遅れの上限

0 は使わない。`scheduler_driven` の間だけ働く。
```ruby
n = GC.debt_limit
```

### GC.debt_limit=

<pre class="fmrb-sig"><code>debt_limit=(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Integer/">Integer</a></code></pre>

回収の遅れの上限を決める

`scheduler_driven` が true で空きが無いとき、遅れ (`GC.stat[:debt]`) がこれを超えると、確保の側が
1 段だけ回収を強制する (そこで 1 段ぶん止まる)。**`scheduler_driven` が false の間は効かない**。
0 で使わない。**負は ArgumentError**。渡した値を返す。
```ruby
GC.debt_limit = 4096
```

### GC.step

<pre class="fmrb-sig"><code>step() -&gt; nil</code></pre>

回収を 1 段だけ進める

戻り値は nil。`scheduler_driven` の間に、忙しいアプリが 1 フレームに数回呼んで、回収を小さく分けて済ませる (1 段の長さは `step_limit` が決める)。
```ruby
GC.step
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
