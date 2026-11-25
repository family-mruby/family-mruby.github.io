# File

Reading and writing files (File)

How to use it: [Files & I/O](../filesystem.md).

Inherits from: [`IO`](IO.md)

A subclass of IO; write, puts, print, flush, close and closed? are IO's.
Implemented in the Family mruby gems picoruby-fmrb-filesystem
(lib/gems/picoruby-fmrb-filesystem/: mrblib/file.rb,
ports/esp32/fmrb_filesystem.c) and picoruby-fmrb-io.
**What CRuby's File has and this one lacks**: gets, each_line, readlines,
seek, eof?, File.read, File.write, File.binread, File.foreach, File.stat,
File.mtime and more. Read with `read`; to write or read a whole file at
once use FmrbFile.
**A failure is a RuntimeError** (no Errno::ENOENT and the like; a missing
file, a file that cannot be written and too many open files are told apart
by the message only). Writable places are /home and /tmp (/tmp is a small
temporary space in RAM).

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`SEPARATOR`</span> | [`String`](String.md) | The path separator |

## Class methods

### File.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode, ?<a href="../Integer/">Integer</a> perm) -&gt; File</code></pre>

Open a file (new)

mode: `"r"` (default; read), `"w"` (truncate and write; created when missing), `"a"`
(append; created when missing), `"r+"` (read and write; fails when missing),
`"w+"` (truncate, read and write). **The `+` must be the second character** (the
`b` of `"rb"` is the second one, so `"rb+"` opens read-only).
**A mode starting with any other letter opens read-only**
(no error). **`a+` does not append**: like
`r+` it overwrites from the start. `perm` is accepted and ignored.

**RuntimeError ("failed to open file: path") when it cannot open**; the reason
(missing, no room, too many open) is not told apart. Only 10 files can be open on
an ESP32, for all apps together. Close a File when done (File.open with a block
does it).
```ruby
f = File.new("/home/a.txt", "w")
f.write("hi")
f.close
```

### File.join

<pre class="fmrb-sig"><code>join(*<a href="../String/">String</a> | <a href="../Array/">Array</a>[untyped] names) -&gt; <a href="../String/">String</a></code></pre>

Join path parts

Joins the parts with exactly one "/" between them. Parts are Strings or arrays of
Strings (nesting allowed); anything else is a TypeError. "" with no arguments.
```ruby
File.join("/home", "a.txt")   #=> "/home/a.txt"
```

### File.basename

<pre class="fmrb-sig"><code>basename(<a href="../String/">String</a> path, ?<a href="../String/">String</a> suffix) -&gt; <a href="../String/">String</a></code></pre>

The last name of a path

Ignores trailing "/". `suffix` (nothing is removed when left out) is cut off the
end when it matches (**literal text only**; CRuby's ".*" does not work). "/" gives
"/".
```ruby
File.basename("/home/a.txt")          #=> "a.txt"
File.basename("/home/a.txt", ".txt")  #=> "a"
```

### File.dirname

<pre class="fmrb-sig"><code>dirname(<a href="../String/">String</a> path, ?<a href="../Integer/">Integer</a> level) -&gt; <a href="../String/">String</a></code></pre>

The directory part of a path

`level` (1 when left out) is how many names to cut off; a negative level is an
ArgumentError. A path with no "/" gives ".".
```ruby
File.dirname("/home/a.txt")   #=> "/home"
```

### File.extname

<pre class="fmrb-sig"><code>extname(<a href="../String/">String</a> filename) -&gt; <a href="../String/">String</a></code></pre>

The extension, with its dot

```ruby
File.extname("a.txt")   #=> ".txt"
```

### File.expand_path

<pre class="fmrb-sig"><code>expand_path(<a href="../String/">String</a> path, ?<a href="../String/">String</a> default_dir) -&gt; <a href="../String/">String</a></code></pre>

Make a path absolute

Resolves "." and ".." and merges repeated "/".
**A relative path is based on `default_dir` (".")**
**put on the environment variable `PWD` ("/" when it is not set)**,
not on `Dir.getwd`. A leading "~" becomes `HOME` (ArgumentError when HOME is not
set); the "~name" form is an ArgumentError. It does not check the file exists.
```ruby
File.expand_path("/home/../tmp/a")   #=> "/tmp/a"
```

### File.exists?

<pre class="fmrb-sig"><code>exists?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether a file or a directory is there

true for a directory too; false when it is missing or cannot be checked (no
exception). `exists?` is the same method under another name.
```ruby
File.exist?("/home/a.txt")
```

### File.file?

<pre class="fmrb-sig"><code>file?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether it is a regular file

false for a directory or a missing path.
```ruby
File.file?("/home/a.txt")
```

### File.directory?

<pre class="fmrb-sig"><code>directory?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether it is a directory

false for a missing path. "/" and "/mnt" are true.
```ruby
File.directory?("/tmp")
```

### File.size

<pre class="fmrb-sig"><code>size(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

A file's size in bytes

**RuntimeError ("stat failed for path") when it is missing**, not nil; check with
`File.exist?` first. (`FmrbFile.size` returns nil instead.)
```ruby
n = File.size("/home/a.txt")
```

### File.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Delete a file

**One path only** (several cannot be given as in CRuby). Returns 1 when deleted and
**raises RuntimeError ("cannot delete path") when it cannot**: a missing file, a
directory (use `Dir.delete`) or a file still open. `unlink` is the same method.
```ruby
File.delete("/home/old.txt") if File.exist?("/home/old.txt")
```

### File.unlink

<pre class="fmrb-sig"><code>unlink(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Delete a file (same as delete)

```ruby
File.unlink("/home/old.txt")
```

### File.rename

<pre class="fmrb-sig"><code>rename(<a href="../String/">String</a> old_path, <a href="../String/">String</a> new_path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Rename or move a file

Returns 0 when it worked and
**raises RuntimeError ("cannot rename old to new") when it fails**.
What happens when the target exists is left to the underlying
rename(3) (not checked; delete the target first to be sure).
```ruby
File.rename("/home/a.tmp", "/home/a.txt")
```

### File.open

<pre class="fmrb-sig"><code>open(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode) -&gt; File
open(<a href="../String/">String</a> path, ?<a href="../String/">String</a> mode) { (File file) -&gt; untyped } -&gt; untyped</code></pre>

Open a file

**Pass a block**: it closes on the way out and returns the block's
value. The mode is `"r"`, `"w"` or `"a"` (`"r"` when left out; see
`File.new` for the rest). Reading a missing file raises RuntimeError.
There is no `File.binread`; use `read`.
```ruby
File.open("/home/a.txt", "r") do |f|
  body = f.read
end
```

### File.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether the file is there

```ruby
return unless File.exist?(path)
```

## Instance methods

### File#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

The path the file was opened with

```ruby
f.path
```

### File#path=

<pre class="fmrb-sig"><code>path=(<a href="../String/">String</a> value) -&gt; <a href="../String/">String</a></code></pre>

Set the recorded path

Only changes what `path` returns; the file does not move.
```ruby
f.path = "/home/b.txt"
```

### File#read

<pre class="fmrb-sig"><code>read(?<a href="../Integer/">Integer</a> length) -&gt; <a href="../String/">String</a></code></pre>

Read the file, or that many bytes of it

Without an argument it returns all that is left, in memory at once; for
a big file pass a length (bytes) and loop. At the end it returns
**"" and not nil**.

**There is no `gets`** (calling it raises NoMethodError). To work line
by line, `split("\n")` what you read.
```ruby
body = f.read
head = f.read(16)
body.split("\n").each do |line|
  handle(line)
end
```

### File#write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

Write to the file

It gives back how many bytes went out.
```ruby
f.write("hello\n")
```

### File#close

<pre class="fmrb-sig"><code>close() -&gt; void</code></pre>

Close it

Not needed when `open` was given a block.
```ruby
f.close
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
