# FmrbFile

ファイルを丸ごと読み書きする

使い方は [ファイル・I/O](../filesystem.md) のページにあります。

パスで呼ぶ関数だけで、開いたままの状態は持たない。`read`・`write`・`append`・`exist?`・
`size`・`delete`・`mkdir`・`list` がある。1 回でファイル全体を読み書きするので、大きなファイルは丸ごとメモリに載る。読む位置を持って少しずつ読むなら `File`。

## クラスメソッド

### FmrbFile.read

<pre class="fmrb-sig"><code>read(<a href="../String/">String</a> path) -&gt; bin?</code></pre>

ファイル全体を読む

無い・読めないときは nil。
```ruby
text = FmrbFile.read("/home/memo.txt")
```

### FmrbFile.write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> path, bin data) -&gt; bool</code></pre>

ファイル全体を書く (前の中身は消える)

書けたら true。
```ruby
FmrbFile.write("/home/memo.txt",
               "hello")
```

### FmrbFile.append

<pre class="fmrb-sig"><code>append(<a href="../String/">String</a> path, bin data) -&gt; bool</code></pre>

ファイルの終わりに足す

無ければ作る。書けたら true。
```ruby
FmrbFile.append("/home/log.txt",
                "one more\n")
```

### FmrbFile.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ファイルかディレクトリがあるか

```ruby
FmrbFile.exist?("/home/memo.txt")
```

### FmrbFile.size

<pre class="fmrb-sig"><code>size(<a href="../String/">String</a> path) -&gt; int64?</code></pre>

ファイルの大きさ (バイト)

無いときは nil。
```ruby
n = FmrbFile.size("/home/memo.txt")
```

### FmrbFile.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ファイルか空のディレクトリを消す

消せたら true。
```ruby
FmrbFile.delete("/home/old.txt")
```

### FmrbFile.mkdir

<pre class="fmrb-sig"><code>mkdir(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ディレクトリを作る

作れたら true (もうあるときも true)。
```ruby
FmrbFile.mkdir("/home/notes")
```

### FmrbFile.list

<pre class="fmrb-sig"><code>list(<a href="../String/">String</a> dir) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]?</code></pre>

ディレクトリの中の名前の一覧

ディレクトリの名前は後ろに "/" が付く。読めないときは nil。
```ruby
FmrbFile.list("/home").each do |n|
  Log.info(n)
end
```

### FmrbFile.list_raw

<pre class="fmrb-sig"><code>list_raw(<a href="../String/">String</a> dir) -&gt; <a href="../String/">String</a>?</code></pre>

list の省略なしの形 (名前を改行でつなぐ)

名前を "\n" でつないだ 1 つの文字列 (最後の名前の後にも "\n")。ディレクトリの名前は後ろに "/"。読めないときは nil。包みは list (配列にする)。

### FmrbFile.path_read_only?

<pre class="fmrb-sig"><code>path_read_only?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

消せない・名前を変えられない場所か

PC 版の配布物の木と /mnt/root で true。端末・sim・ブラウザ版では常に false。
```ruby
FmrbFile.path_read_only?("/mnt/root/etc/hostname")
```

### FmrbFile.free_bytes

<pre class="fmrb-sig"><code>free_bytes(<a href="../String/">String</a> path) -&gt; int64?</code></pre>

その場所にあと何バイト書けるか

/tmp は RAM のファイルシステムの空き、ほかはその下のファイルシステムの空き。分からないとき (ブラウザ版の SD など) は nil。
```ruby
FmrbFile.free_bytes("/tmp")
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
