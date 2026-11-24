# IO

入出力のストリーム。

使い方は [ファイル・I/O](../filesystem.md) のページにあります。

標準出力 (`$stdout`) もファイルも同じ IO。
**ストリームが閉じた後の `read`・`write` は IOError でなく RuntimeError**
("closed stream")。エラーはどれも RuntimeError で、理由 (errno) は区別できない。
```ruby
$stdout.puts "hello"
```

## インスタンスメソッド

### IO#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

読む (File では File#read)

length バイトまでを読んで文字列で返す。**length を省くと 1024 バイト**
(標準入力などのストリーム用。ファイルは File#read で、省くと全部読む)。
length が 0 以下なら "" を返す。読めなかったときは RuntimeError
("failed to read from stream")、閉じたストリームなら RuntimeError ("closed stream")。
```ruby
s = $stdin.read(16)
```

### IO#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

書き込む

str を書き、**書いたバイト数**を返す。str は String だけ (数値などは TypeError。
`puts`・`print` は to_s してから渡す)。書けなかったときは RuntimeError ("write failed")、閉じたストリームなら RuntimeError ("closed stream")。
```ruby
n = f.write("hello\n")   #=> 6
```

### IO#puts

<pre class="fmrb-sig"><code>puts(*untyped objects) -&gt; nil</code></pre>

改行つきで書く

引数を 1 つずつ to_s して書き、末尾が "\n" でなければ "\n" を足す。引数が無いときは
"\n" だけ。**配列は展開しない** (`puts [1, 2]` は "[1, 2]" の 1 行。CRuby は 1 要素 1 行)。
nil は空行。いつも nil を返す。
```ruby
f.puts "line"
```

### IO#print

<pre class="fmrb-sig"><code>print(*untyped objects) -&gt; nil</code></pre>

改行なしで書く

引数を 1 つずつ to_s して書く。いつも nil を返す。
```ruby
f.print "a", 1
```

### IO#flush

<pre class="fmrb-sig"><code>flush() -&gt; self</code></pre>

書いた内容を記憶領域へ流す

ファイルの書き込みを確定させる。自分 (self) を返す。標準出力・標準エラー・閉じたものでは何もしない。流せなかったときは RuntimeError ("flush failed")。
```ruby
f.flush
```

### IO#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じる

**何度呼んでも例外にならない** (閉じていれば何もしない)。nil を返す。標準入出力では何もしない。
**開いたまま忘れたファイルは、ガベージコレクタでは閉じない**。アプリが終わるときまとめて閉じられる。開いたままにできる数は有限 (ESP32 では全アプリで 10 個。File#new 参照)。
```ruby
f.close
```

### IO#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

閉じているか

```ruby
f.closed?
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
