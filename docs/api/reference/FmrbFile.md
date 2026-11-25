# FmrbFile

Read and write whole files by path

How to use it: [Files & I/O](../filesystem.md).

Functions called by path; nothing stays open. There are `read`, `write`,
`append`, `exist?`, `size`, `delete`, `mkdir` and `list`. A call reads or
writes the whole file, so a big file is held in memory entirely. To read
a little at a time from a position, use `File`.

## Class methods

### FmrbFile.read

<pre class="fmrb-sig"><code>read(<a href="../String/">String</a> path) -&gt; bin?</code></pre>

Read a whole file

nil when it is not there or cannot be read.
```ruby
text = FmrbFile.read("/home/memo.txt")
```

### FmrbFile.write

<pre class="fmrb-sig"><code>write(<a href="../String/">String</a> path, bin data) -&gt; bool</code></pre>

Write a whole file, replacing it

true when it was written.
```ruby
FmrbFile.write("/home/memo.txt",
               "hello")
```

### FmrbFile.append

<pre class="fmrb-sig"><code>append(<a href="../String/">String</a> path, bin data) -&gt; bool</code></pre>

Add to the end of a file

Makes the file when it is not there; true when it was written.
```ruby
FmrbFile.append("/home/log.txt",
                "one more\n")
```

### FmrbFile.exist?

<pre class="fmrb-sig"><code>exist?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether a file or a directory is there

```ruby
FmrbFile.exist?("/home/memo.txt")
```

### FmrbFile.size

<pre class="fmrb-sig"><code>size(<a href="../String/">String</a> path) -&gt; int64?</code></pre>

A file's size in bytes

nil when it is not there.
```ruby
n = FmrbFile.size("/home/memo.txt")
```

### FmrbFile.delete

<pre class="fmrb-sig"><code>delete(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Delete a file or an empty directory

true when it was deleted.
```ruby
FmrbFile.delete("/home/old.txt")
```

### FmrbFile.mkdir

<pre class="fmrb-sig"><code>mkdir(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Make a directory

true when it was made, or is there already.
```ruby
FmrbFile.mkdir("/home/notes")
```

### FmrbFile.list

<pre class="fmrb-sig"><code>list(<a href="../String/">String</a> dir) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]?</code></pre>

The names in a directory

A directory's name ends in "/". nil when it cannot be read.
```ruby
FmrbFile.list("/home").each do |n|
  Log.info(n)
end
```

### FmrbFile.list_raw

<pre class="fmrb-sig"><code>list_raw(<a href="../String/">String</a> dir) -&gt; <a href="../String/">String</a>?</code></pre>

list as one String, a name per line

The names joined by "\n", one after the last name too; a directory's
name ends in "/". nil when it cannot be read. The wrapper is list (an
Array).
```ruby
FmrbFile.list_raw("/home")
```

### FmrbFile.path_read_only?

<pre class="fmrb-sig"><code>path_read_only?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

Whether the entry cannot be deleted or renamed

true for the PC build's distribution tree and /mnt/root; always false on
the devices, the simulation and the browser.
```ruby
FmrbFile.path_read_only?("/mnt/root/etc/hostname")
```

### FmrbFile.free_bytes

<pre class="fmrb-sig"><code>free_bytes(<a href="../String/">String</a> path) -&gt; int64?</code></pre>

How many more bytes can be written where the path lives

/tmp: what is left of the RAM filesystem; elsewhere: the free space of
the filesystem under it. nil when it cannot be known.
```ruby
FmrbFile.free_bytes("/tmp")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
