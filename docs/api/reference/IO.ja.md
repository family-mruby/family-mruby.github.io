# IO

入出力のストリーム

使い方は [ファイル・I/O](../filesystem.md) のページにあります。

標準出力 (`$stdout`) もファイルも同じ IO。
**ストリームが閉じた後の `read`・`write` は IOError でなく RuntimeError**
("closed stream")。開いた向きと逆の操作 (書くだけの `"w"`・`"a"` で `read`、読むだけの
`"r"` で `write`・`puts`・`print`) は IOError。それ以外のエラーは RuntimeError で、理由 (errno) は区別できない。
```ruby
$stdout.puts "hello"
```

## インスタンスメソッド

### IO#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

読む (File では File#read)

length バイトまでを読んで文字列で返す。**length を省くと 1024 バイト**
(標準入力などのストリーム用。ファイルは File#read で、省くと全部読む)。
length が 0 以下なら "" を返す。
**書くだけで開いたもの (`"w"`・`"a"`、標準出力) は IOError ("not opened for reading")**。読めなかったときは RuntimeError
("failed to read from stream")、閉じたストリームなら RuntimeError ("closed stream")。
```ruby
s = $stdin.read(16)
```

### IO#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

書き込む

str を書き、**書いたバイト数**を返す。str は String だけ (数値などは TypeError。
`puts`・`print` は to_s してから渡す)。
**読むだけで開いたもの (`"r"`、標準入力) は IOError ("not opened for writing")** (`puts`・`print` も)。書けなかったときは RuntimeError ("write failed")、閉じたストリームなら RuntimeError ("closed stream")。
```ruby
n = f.write("hello\n")   #=> 6
```

### IO#puts

<pre class="fmrb-sig"><code>puts(*untyped objects) -&gt; nil</code></pre>

改行つきで書く

引数を 1 つずつ to_s して書き、末尾が "\n" でなければ "\n" を足す。引数が無いときは
"\n" だけ。**配列は 1 要素 1 行** (入れ子も展開する。`puts [1, [2]]` は "1" と "2" の
2 行、空の配列は空行)。16 段より深い配列 (自分自身を含む配列) はそこで "[...]"。
nil は空行。いつも nil を返す。mruby と同じ。
```ruby
f.puts "line"
f.puts ["a", "b"]   # 2 行
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

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
