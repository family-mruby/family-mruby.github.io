# Exception

例外のもとになるクラス

`rescue => e` で受けるのは `StandardError` とその下のクラス。`Exception` を名指しすると、メモリ不足 (`NoMemoryError`) やスタックの使い切り (`SystemStackError`) まで受ける。

## クラスメソッド

### Exception.new

<pre class="fmrb-sig"><code>new(?<a href="../String/">String</a> message) -&gt; Exception</code></pre>

例外を作る

ふつうは `raise ArgumentError, "bad size"` と書き、`new` は直接呼ばない。文を省くと、`message` はクラスの名前になる。

```ruby
e = RuntimeError.new("no map")
e.message   #=> "no map"
```

## インスタンスメソッド

### Exception#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

例外の文

```ruby
begin
  Integer("x")
rescue => e
  show(e.message)
end
```

### Exception#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

例外の文 (message と同じ)

```ruby
puts e.to_s
```

### Exception#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

クラスの名前つきの文

ログに出すときに向く。

```ruby
Log.error(e.inspect)
```

### Exception#backtrace

<pre class="fmrb-sig"><code>backtrace() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]?</code></pre>

例外が起きた場所の一覧

"ファイル:行" の文字列の Array。場所が取れないときは nil か空。

```ruby
bt = e.backtrace
Log.error(bt[0]) if bt && bt[0]
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
