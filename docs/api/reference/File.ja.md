# File

ファイルの読み書き (File)

使い方は [ファイル・I/O](../filesystem.md) のページにあります。

継承元: [`IO`](IO.md)

IO の子クラスで、write・puts・print・flush・close・closed? は IO のもの。実装は Family mruby の gem picoruby-fmrb-filesystem (lib/gems/picoruby-fmrb-filesystem/:
mrblib/file.rb、ports/esp32/fmrb_filesystem.c) と picoruby-fmrb-io。
**CRuby の File にあって無いもの**:
gets・each_line・readlines・seek・eof?・File.read・File.write・File.binread・
File.foreach・File.stat・File.mtime ほか。読むのは `read`、全体を一度に書く・読むなら FmrbFile。
**失敗は RuntimeError** (Errno::ENOENT などは無く、ファイルが無い・書けない・数が多すぎる、はメッセージだけで区別する)。書いてよい場所は /home と /tmp (/tmp は RAM の上の小さな一時置き場)。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`SEPARATOR`</span> | [`String`](String.md) | パスの区切り |

## クラスメソッド

### File.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode, ?<a href="../Integer/">Integer</a> perm) -&gt; File</code></pre>

ファイルを開く (new)

mode は `"r"` (省略時・読む)・`"w"` (空にして書く。無ければ作る)・`"a"` (末尾に足す。無ければ作る)
と、`"r+"` (読み書き。無いと失敗)・`"w+"` (空にして読み書き)。**`+` は 2 文字目に置く**
(`"rb"` の `b` は 2 文字目なので `"rb+"` は読み取り専用になる)。
**ほかの文字で始まる mode は読み取り専用として開く** (エラーにならない)。**`a+` は追記にならない** (`r+` と同じで、先頭から上書きする)。
`perm` は受け取るだけで使わない。

**開けないと RuntimeError ("failed to open file: パス")**。理由 (無い・場所が無い・開いている数が上限) は区別できない。開いたままにできるのは、ESP32 では全アプリで 10 個。開いた File は使い終えたら close する (File.open のブロックなら自動)。
```ruby
f = File.new("/home/a.txt", "w")
f.write("hi")
f.close
```

### File.join

<pre class="fmrb-sig"><code>join(*<a href="../String/">String</a> | <a href="../Array/">Array</a>[untyped] names) -&gt; <a href="../String/">String</a></code></pre>

パスを組み立てる

部品の間に "/" を 1 つだけ入れてつなぐ (重なった "/" は 1 つに)。部品は String か、
String の配列 (入れ子も可)。ほかは TypeError。引数が無いと ""。
```ruby
File.join("/home", "a.txt")   #=> "/home/a.txt"
```

### File.basename

<pre class="fmrb-sig"><code>basename(<a href="../String/">String</a> path, ?<a href="../String/">String</a> suffix) -&gt; <a href="../String/">String</a></code></pre>

パスの最後の名前

末尾の "/" は無視する。`suffix` (省略すると何も取らない) が名前の終わりに一致すれば取り除く (**文字列そのままの一致だけ**。CRuby の ".*" は使えない)。"/" は "/"。
```ruby
File.basename("/home/a.txt")          #=> "a.txt"
File.basename("/home/a.txt", ".txt")  #=> "a"
```

### File.dirname

<pre class="fmrb-sig"><code>dirname(<a href="../String/">String</a> path, ?<a href="../Integer/">Integer</a> level) -&gt; <a href="../String/">String</a></code></pre>

パスの親のディレクトリ

```ruby
File.dirname("/home/a.txt")   #=> "/home"
```

### File.extname

<pre class="fmrb-sig"><code>extname(<a href="../String/">String</a> filename) -&gt; <a href="../String/">String</a></code></pre>

拡張子 (ドットを含む)

```ruby
File.extname("a.txt")   #=> ".txt"
```

### File.expand_path

<pre class="fmrb-sig"><code>expand_path(<a href="../String/">String</a> path, ?<a href="../String/">String</a> default_dir) -&gt; <a href="../String/">String</a></code></pre>

絶対パスにする

"." と ".." をたどり、重なった "/" をまとめる。
**相対パスの基準は `default_dir` (省略すると ".") を環境変数 `PWD` (無ければ "/") に付けたもの**で、`Dir.getwd` ではない。
"~" で始まるパスは環境変数 `HOME` に置き換わり、HOME が無いと ArgumentError。
"~名前" の形は ArgumentError。ファイルがあるかは見ない。
```ruby
File.expand_path("/home/../tmp/a")   #=> "/tmp/a"
```

### File.exists?

<pre class="fmrb-sig"><code>exists?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ファイルかディレクトリがあるか (exists? も同じ)

ディレクトリでも true。無い・調べられないときは false (例外は出ない)。
`exists?` は同じ働きの別名。

### File.file?

<pre class="fmrb-sig"><code>file?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

普通のファイルか

ディレクトリや、無いパスは false。
```ruby
File.file?("/home/a.txt")
```

### File.directory?

<pre class="fmrb-sig"><code>directory?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ディレクトリか

無いパスは false。"/"・"/mnt" は true。
```ruby
File.directory?("/tmp")
```

### File.size

<pre class="fmrb-sig"><code>size(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

ファイルの大きさ (バイト)

**無いと nil でなく RuntimeError ("stat failed for パス")**。先に `File.exist?` で調べる。
(nil を返す `FmrbFile.size` もある。)
```ruby
n = File.size("/home/a.txt")
```

### File.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

ファイルを消す

**パスは 1 つだけ** (CRuby のように複数は渡せない)。消せたら 1 を返し、
**消せないと RuntimeError ("cannot delete パス")**。無い・ディレクトリ・開いたままのファイルは消せない (ディレクトリは `Dir.delete`)。`unlink` は同じ働きの別名。
```ruby
File.delete("/home/old.txt") if File.exist?("/home/old.txt")
```

### File.unlink

<pre class="fmrb-sig"><code>unlink(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

ファイルを消す (delete の別名)

```ruby
File.unlink("/home/old.txt")
```

### File.rename

<pre class="fmrb-sig"><code>rename(<a href="../String/">String</a> old_path, <a href="../String/">String</a> new_path) -&gt; <a href="../Integer/">Integer</a></code></pre>

名前を変える・移す

成功すると 0。**失敗すると RuntimeError ("cannot rename 元 to 先")**。先に同じ名前のファイルがあるときの動きは、実装の rename(3) まかせ (確かめていない。先に `File.delete`
すると確実)。
```ruby
File.rename("/home/a.tmp", "/home/a.txt")
```

### File.open

<pre class="fmrb-sig"><code>open(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode) -&gt; File
open(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode) { (File file) -&gt; untyped } -&gt; untyped</code></pre>

ファイルを開く

**ブロックを渡した形が安全** (抜けるときに閉じ、ブロックの値を返す)。
mode は `"r"` `"w"` `"a"` (省略すると `"r"`。細かい形は `File.new`)。無いファイルを読もうとすると RuntimeError。**File.binread は無い**
ので、読むのは `read`。
```ruby
File.open("/home/a.txt", "r") do |f|
  body = f.read
end
```

### File.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ファイルがあるかどうか

```ruby
return unless File.exist?(path)
```

## インスタンスメソッド

### File#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

開いたファイルのパス

```ruby
f.path
```

### File#path=

<pre class="fmrb-sig"><code>path=(<a href="../String/">String</a> value) -&gt; <a href="../String/">String</a></code></pre>

パスを置き換える (記録だけ)

`path` が返す値を変えるだけで、ファイルは動かない。
```ruby
f.path = "/home/b.txt"
```

### File#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

中身を読む (長さを渡せばその分だけ)

引数なしなら残り全部が文字列で返る。
**大きいファイルは丸ごとメモリに載る**ので、少しずつ処理するなら長さ (バイト) を渡して回す。終わりまで読んだ後は **nil でなく ""** が返る。

**`gets` (1 行読む) は無い** (呼ぶと NoMethodError)。行で分けるなら、読んだ文字列を `split("\n")` する。
```ruby
body = f.read
head = f.read(16)
body.split("\n").each do |line|
  handle(line)
end
```

### File#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

書き込む

書けたバイト数が返る。
```ruby
f.write("hello\n")
```

### File#close

<pre class="fmrb-sig"><code>close() -&gt; void</code></pre>

閉じる

ブロック付きの `open` なら要らない。
```ruby
f.close
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
