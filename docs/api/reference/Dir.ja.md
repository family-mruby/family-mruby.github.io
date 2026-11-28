# Dir

ディレクトリの一覧と操作

使い方は [ファイル・I/O](../filesystem.md) のページにあります。

一覧は `Dir.children` が手軽 (名前の配列)。1 件ずつなら `Dir.open` して `read` を回す。
```ruby
Dir.children("/home").each { |n| p n }
```

## クラスメソッド

### Dir.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path) -&gt; Dir</code></pre>

ディレクトリを開く

無い・ディレクトリでないと RuntimeError (メッセージはパス)。開けるのは ESP32 では全アプリで
10 個まで。閉じ忘れたものはアプリが終わるときに閉じられる。`Dir.open` と同じ。
```ruby
d = Dir.new("/home")
```

### Dir.open

<pre class="fmrb-sig"><code>open(<a href="../String/">String</a> path) { (Dir dir) -&gt; untyped } -&gt; untyped
open(<a href="../String/">String</a> path) -&gt; Dir</code></pre>

ディレクトリを開く (ブロック付きは閉じる)

**ブロックを渡すと、抜けるときに閉じ、ブロックの値を返す**。無いと RuntimeError。アプリでは、あるかの確認にも使われる (開けたら閉じて true、RuntimeError なら false。確認だけなら `Dir.exist?` が手軽)。
```ruby
Dir.open("/home") do |d|
  while (n = d.read)
    p n
  end
end
```

### Dir.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ディレクトリか

ディレクトリだけ true (普通のファイルは false。`File.exist?` はどちらも true)。無い・調べられないときは false で、例外は出ない。ESP32 では "/" と "/mnt" も true。
`exists?` は同じ働きの別名。
```ruby
Dir.mkdir("/home/d") unless Dir.exist?("/home/d")
```

### Dir.exists?

<pre class="fmrb-sig"><code>exists?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

ディレクトリか (exist? の別名)

```ruby
Dir.exists?("/home")
```

### Dir.mkdir

<pre class="fmrb-sig"><code>mkdir(<a href="../String/">String</a> path, ?<a href="../Integer/">Integer</a> mode) -&gt; <a href="../Integer/">Integer</a></code></pre>

ディレクトリを作る

成功すると 0。**もうあるときも、間のディレクトリが無いときも RuntimeError** (メッセージはパス。1 段ずつ作る。先に `Dir.exist?` で確認する)。`mode` (省略すると 0777) は
LittleFS では意味を持たない。/tmp はファイルを入れるだけの場所で、ディレクトリは作れない設計 (実機の /tmp。`Dir.mkdir` が sim で断るかは確かめていない)。
```ruby
Dir.mkdir("/home/notes") unless Dir.exist?("/home/notes")
```

### Dir.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

空のディレクトリを消す

成功すると 0。**空でない・無いと RuntimeError** (メッセージはパス)。"/" や "/mnt" は消せない
(実機)。`rmdir`・`unlink` は同じ働きの別名。ファイルは `File.delete`。
```ruby
Dir.delete("/home/old")
```

### Dir.rmdir

<pre class="fmrb-sig"><code>rmdir(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

空のディレクトリを消す (delete の別名)

```ruby
Dir.rmdir("/home/old")
```

### Dir.unlink

<pre class="fmrb-sig"><code>unlink(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

空のディレクトリを消す (delete の別名)

```ruby
Dir.unlink("/home/old")
```

### Dir.children

<pre class="fmrb-sig"><code>children(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

中の名前の配列 ("." と ".." を除く)

無いと RuntimeError (メッセージはパス)。**並び順は決まっていない**。ディレクトリもファイルも名前だけが入る (区別は `File.directory?`)。
```ruby
names = Dir.children("/home")
names = (Dir.children(dir) rescue [])
```

### Dir.entries

<pre class="fmrb-sig"><code>entries(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

中の名前の配列 ("." と ".." を含みうる)

**"." と ".." が入るかは機種で違う**: sim・ブラウザ版は入り、ESP32 の LittleFS は入らない
(読んだ限り)。要らないなら `Dir.children`。
```ruby
Dir.entries("/home")
```

### Dir.empty?

<pre class="fmrb-sig"><code>empty?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

空かどうか

"." と ".." は数えない。無いと RuntimeError。
```ruby
Dir.empty?("/home/tmp")
```

### Dir.foreach

<pre class="fmrb-sig"><code>foreach(<a href="../String/">String</a> path) { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; untyped</code></pre>

名前を 1 つずつ渡す

**ブロックが要る** (無いと NotImplementedError。Enumerator は入っていない)。
```ruby
Dir.foreach("/home") { |n| p n }
```

### Dir.getwd

<pre class="fmrb-sig"><code>getwd() -&gt; <a href="../String/">String</a></code></pre>

作業ディレクトリ

`pwd` は同じ働きの別名。**アプリごと**の場所で、起動したときは "/"。`Dir.chdir` で変わり、ファイルの操作 (File.open・Dir.open ...) と `File.expand_path` の相対パスはここから解く。ほかのアプリの場所とは別で、シェルの `cd` とも別 (シェルから起動したアプリも "/" から)。
```ruby
Dir.getwd   #=> "/"
```

### Dir.pwd

<pre class="fmrb-sig"><code>pwd() -&gt; <a href="../String/">String</a></code></pre>

作業ディレクトリ (getwd の別名)

```ruby
Dir.pwd
```

### Dir.chdir

<pre class="fmrb-sig"><code>chdir(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a>
chdir(<a href="../String/">String</a> path) { (<a href="../String/">String</a> path) -&gt; untyped } -&gt; untyped</code></pre>

作業ディレクトリを変える

成功すると 0。変わるのはこのアプリの場所だけ (`Dir.getwd` 参照)。相対パスは今の場所から、
"." と ".." をまとめ、"/" より上には出ない。無い・フォルダでない・長すぎる (127 バイトまで)
と RuntimeError で、場所は変わらない。ブロックを渡すと、その間だけ変えて元に戻し
(例外でも戻る)、ブロックの値を返す。アプリが終わると消える。
```ruby
Dir.chdir("/tmp")
File.open("a.txt", "w") { |f| f.write("x") }   # /tmp/a.txt
Dir.chdir("/home") { Dir.getwd }               #=> "/home"
```

## インスタンスメソッド

### Dir#read

<pre class="fmrb-sig"><code>read() -&gt; <a href="../String/">String</a>?</code></pre>

開いたディレクトリから 1 つ読む

次の名前を返す。**終わりで nil**。並び順は決まっていない。`"."`・`".."` が出るかは機種で違う (`Dir.entries` 参照)。閉じていると IOError。
```ruby
while (n = d.read)
  p n
end
```

### Dir#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

開いたディレクトリを閉じる

nil を返す。**2 回目は IOError ("closed directory")** (File#close と違う)。
```ruby
d.close
```

### Dir#rewind

<pre class="fmrb-sig"><code>rewind() -&gt; self</code></pre>

読む位置を先頭に戻す

```ruby
d.rewind
```

### Dir#each

<pre class="fmrb-sig"><code>each() { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; self</code></pre>

全部の名前を 1 つずつ渡す

`read` を終わりまで回す (先頭に戻さないので、途中まで読んだ後はそこから)。ブロックが要る
(無いと NotImplementedError)。
```ruby
d.each { |n| p n }
```

### Dir#each_child

<pre class="fmrb-sig"><code>each_child() { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; self</code></pre>

"." と ".." 以外を 1 つずつ渡す

ブロックが要る (無いと NotImplementedError)。
```ruby
d.each_child { |n| p n }
```

### Dir#tell

<pre class="fmrb-sig"><code>tell() -&gt; <a href="../Integer/">Integer</a></code></pre>

読む位置

`pos` は同じ働きの別名。**ESP32 では NotImplementedError** (ディレクトリの位置を取る手段が無い)。sim・ブラウザ版では位置の値。使わず、`rewind` で先頭に戻す。
```ruby
d.tell
```

### Dir#seek

<pre class="fmrb-sig"><code>seek(<a href="../Integer/">Integer</a> pos) -&gt; self</code></pre>

読む位置を決める

`pos=` は同じ働きの別名。**ESP32 では NotImplementedError**。`tell` が返した値だけを渡す。
```ruby
d.seek(pos)
```

### Dir#pos

<pre class="fmrb-sig"><code>pos() -&gt; <a href="../Integer/">Integer</a></code></pre>

読む位置 (tell の別名)

```ruby
d.pos
```

### Dir#pos=

<pre class="fmrb-sig"><code>pos=(<a href="../Integer/">Integer</a> pos) -&gt; <a href="../Integer/">Integer</a></code></pre>

読む位置を決める (seek の別名)

```ruby
d.pos = saved
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
