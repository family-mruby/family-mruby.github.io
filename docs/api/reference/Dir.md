# Dir

List and operate on directories

How to use it: [Files & I/O](../filesystem.md).

`Dir.children` is the easy way to list (an array of
names); to go one by one, `Dir.open` and loop on `read`.
```ruby
Dir.children("/home").each { |n| p n }
```

## Class methods

### Dir.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path) -&gt; Dir</code></pre>

Open a directory

RuntimeError (the message is the path) when it is missing or not a directory.
An ESP32 can have 10 open at once, for all apps together. What was left open is
closed when the app ends. Same as `Dir.open`.
```ruby
d = Dir.new("/home")
```

### Dir.open

<pre class="fmrb-sig"><code>open(<a href="../String/">String</a> path) { (Dir dir) -&gt; untyped } -&gt; untyped
open(<a href="../String/">String</a> path) -&gt; Dir</code></pre>

Open a directory (a block closes it)

**With a block it closes the directory on the way out and returns the block's value.**
RuntimeError when it is missing. Apps also use it to test existence (open
and close for true; a RuntimeError for false); `Dir.exist?` is simpler for that.
```ruby
Dir.open("/home") do |d|
  while (n = d.read)
    p n
  end
end
```

### Dir.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether it is a directory

true only for a directory (a regular file gives false; `File.exist?` is true for
both). false when it is missing or cannot be checked, never an exception. On an
ESP32 "/" and "/mnt" count too. `exists?` is the same method.
```ruby
Dir.mkdir("/home/d") unless Dir.exist?("/home/d")
```

### Dir.exists?

<pre class="fmrb-sig"><code>exists?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether it is a directory (alias of exist?)

```ruby
Dir.exists?("/home")
```

### Dir.mkdir

<pre class="fmrb-sig"><code>mkdir(<a href="../String/">String</a> path, ?<a href="../Integer/">Integer</a> mode) -&gt; <a href="../Integer/">Integer</a></code></pre>

Make a directory

Returns 0 when made.
**RuntimeError (the message is the path) when it exists already and when a parent is missing**:
make them one level at a time, and check
with `Dir.exist?` first. `mode` (0777 when left out) means nothing on LittleFS.
/tmp is meant for files only; directories are not made in it on a device (whether
`Dir.mkdir` refuses in the simulation is not checked).
```ruby
Dir.mkdir("/home/notes") unless Dir.exist?("/home/notes")
```

### Dir.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Delete an empty directory

Returns 0 when deleted.
**RuntimeError (the message is the path) when it is not empty or is missing.**
"/" and "/mnt" cannot be deleted (on a device). `rmdir` and
`unlink` are the same method. For a file use `File.delete`.
```ruby
Dir.delete("/home/old")
```

### Dir.rmdir

<pre class="fmrb-sig"><code>rmdir(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Delete an empty directory (alias of delete)

```ruby
Dir.rmdir("/home/old")
```

### Dir.unlink

<pre class="fmrb-sig"><code>unlink(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a></code></pre>

Delete an empty directory (alias of delete)

```ruby
Dir.unlink("/home/old")
```

### Dir.children

<pre class="fmrb-sig"><code>children(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

Names inside, without "." and ".."

RuntimeError (the message is the path) when it is missing.
**The order is not fixed.**
Directories and files are both just names (tell them apart with
`File.directory?`).
```ruby
names = Dir.children("/home")
names = (Dir.children(dir) rescue [])
```

### Dir.entries

<pre class="fmrb-sig"><code>entries(<a href="../String/">String</a> path) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

Names inside, "." and ".." may be in

**Whether "." and ".." appear depends on the machine**: they do in the simulation and
the browser build, and they do not on an ESP32's LittleFS (as far as I read it).
Use `Dir.children` to be rid of them.
```ruby
Dir.entries("/home")
```

### Dir.empty?

<pre class="fmrb-sig"><code>empty?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether a directory is empty

"." and ".." are not counted. RuntimeError when it is missing.
```ruby
Dir.empty?("/home/tmp")
```

### Dir.foreach

<pre class="fmrb-sig"><code>foreach(<a href="../String/">String</a> path) { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; untyped</code></pre>

Yield each name

**A block is required** (NotImplementedError without one; Enumerator is not built
in).
```ruby
Dir.foreach("/home") { |n| p n }
```

### Dir.getwd

<pre class="fmrb-sig"><code>getwd() -&gt; <a href="../String/">String</a></code></pre>

The working directory

`pwd` is the same method. **Each app has its own**, "/" when it starts. `Dir.chdir`
changes it, and relative paths in file operations (File.open, Dir.open, ...) and in
`File.expand_path` are taken from it. It is apart from other apps' and from the
shell's `cd` (an app started from the shell starts at "/" too).
```ruby
Dir.getwd   #=> "/"
```

### Dir.pwd

<pre class="fmrb-sig"><code>pwd() -&gt; <a href="../String/">String</a></code></pre>

The working directory (alias of getwd)

```ruby
Dir.pwd
```

### Dir.chdir

<pre class="fmrb-sig"><code>chdir(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a>
chdir(<a href="../String/">String</a> path) { (<a href="../String/">String</a> path) -&gt; untyped } -&gt; untyped</code></pre>

Change the working directory

Returns 0. Only this app's place changes (see `Dir.getwd`). A relative path is taken
from the current place; "." and ".." are folded and it never goes above "/". Missing,
not a directory or too long (127 bytes at most) raises RuntimeError and leaves the
place as it was. With a block it changes only for the block, restores (also on an
exception), and returns the block's value. It is gone when the app ends.
```ruby
Dir.chdir("/tmp")
File.open("a.txt", "w") { |f| f.write("x") }   # /tmp/a.txt
Dir.chdir("/home") { Dir.getwd }               #=> "/home"
```

## Instance methods

### Dir#read

<pre class="fmrb-sig"><code>read() -&gt; <a href="../String/">String</a>?</code></pre>

Read the next name

Returns the next name; **nil at the end**. The order is not fixed. Whether "." and
".." come out depends on the machine (see `Dir.entries`). IOError when closed.
```ruby
while (n = d.read)
  p n
end
```

### Dir#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Close an open directory

Returns nil. **A second close raises IOError ("closed directory")**, unlike
File#close.
```ruby
d.close
```

### Dir#rewind

<pre class="fmrb-sig"><code>rewind() -&gt; self</code></pre>

Go back to the first name

```ruby
d.rewind
```

### Dir#each

<pre class="fmrb-sig"><code>each() { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; self</code></pre>

Yield every name

Loops `read` to the end (it does not rewind first, so after reading part of it, it
goes on from there). A block is required (NotImplementedError without one).
```ruby
d.each { |n| p n }
```

### Dir#each_child

<pre class="fmrb-sig"><code>each_child() { (<a href="../String/">String</a> name) -&gt; untyped } -&gt; self</code></pre>

Yield every name except "." and ".."

A block is required (NotImplementedError without one).
```ruby
d.each_child { |n| p n }
```

### Dir#tell

<pre class="fmrb-sig"><code>tell() -&gt; <a href="../Integer/">Integer</a></code></pre>

The read position

`pos` is the same method. **NotImplementedError on an ESP32** (no way to read a
directory position). A position value on the simulation and the browser build. Do
not use it; go back with `rewind`.
```ruby
d.tell
```

### Dir#seek

<pre class="fmrb-sig"><code>seek(<a href="../Integer/">Integer</a> pos) -&gt; self</code></pre>

Set the read position

`pos=` is the same method. **NotImplementedError on an ESP32.** Only pass a value
`tell` returned.
```ruby
d.seek(pos)
```

### Dir#pos

<pre class="fmrb-sig"><code>pos() -&gt; <a href="../Integer/">Integer</a></code></pre>

The read position (alias of tell)

```ruby
d.pos
```

### Dir#pos=

<pre class="fmrb-sig"><code>pos=(<a href="../Integer/">Integer</a> pos) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the read position (alias of seek)

```ruby
d.pos = saved
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
