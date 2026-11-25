# Log

ログ (シリアルと sim の端末に出る)

使い方は [ログ](../log.md) のページにあります。

Log はクラスごと本体との境界に載る (%a{fmrb.boundary}、doc/app_boundary)。
info などは包みで、隣に省略なしの _raw の形がある (mruby の包みは C で、前に書いたタグを 1 つめに受ける形 `Log.info("TAG", msg)` も読む)。

## クラスメソッド

### Log.debug

<pre class="fmrb-sig"><code>debug(<a href="../String/">String</a> msg) -&gt; void</code></pre>

細かい様子をログに書く

行の頭にアプリの名前が付く。
```ruby
Log.debug("x = #{x}")
```

### Log.debug_raw

<pre class="fmrb-sig"><code>debug_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

debug の省略なしの形

細かい様子 (D) の 1 行を書く。包みは debug。
```ruby
Log.debug_raw("ready")
```

### Log.info

<pre class="fmrb-sig"><code>info(<a href="../String/">String</a> msg) -&gt; void</code></pre>

ログに書く

行の頭にアプリの名前が付く。
```ruby
Log.info("saved #{path}")
```

### Log.info_raw

<pre class="fmrb-sig"><code>info_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

info の省略なしの形

ふつうの知らせ (I) の 1 行を書く。包みは info。
```ruby
Log.info_raw("ready")
```

### Log.warn

<pre class="fmrb-sig"><code>warn(<a href="../String/">String</a> msg) -&gt; void</code></pre>

注意をログに書く

行の頭にアプリの名前が付く。
```ruby
Log.warn("x = #{x}")
```

### Log.warn_raw

<pre class="fmrb-sig"><code>warn_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

warn の省略なしの形

注意 (W) の 1 行を書く。包みは warn。
```ruby
Log.warn_raw("ready")
```

### Log.error

<pre class="fmrb-sig"><code>error(<a href="../String/">String</a> msg) -&gt; void</code></pre>

エラーをログに書く

行の頭にアプリの名前が付く。
```ruby
Log.error("x = #{x}")
```

### Log.error_raw

<pre class="fmrb-sig"><code>error_raw(<a href="../String/">String</a> msg) -&gt; void</code></pre>

error の省略なしの形

エラー (E) の 1 行を書く。包みは error。
```ruby
Log.error_raw("ready")
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
