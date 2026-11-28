# FmrbAssoc

Which app opens which file

The place everything that opens a file for the user asks: the file
manager's double click, the shell's `open`, and any app that hands a file
on. The table has two layers: `/etc/associations.toml` (ships with the
firmware) and, on top of it per extension, `/home/associations.toml` (the
user's). One line each, `extension = "answer"`.

The answer is one of three. A path always starts with `/`, so compare it
with `FmrbAssoc::RUN` and `FmrbAssoc::EDIT` to tell them apart.
- `"run"` run the file itself as an app
- `"edit"` open it in the editor
- `"/app/..."` start that app and hand it the file

The table is **read once per VM**. After editing a table, open the app
that reads it again (there is no reload).

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`RUN`</span> | [`String`](String.md) | Answer: run the file itself as an app |
| <span class="fmrb-name">`EDIT`</span> | [`String`](String.md) | Answer: open it in the editor |
| <span class="fmrb-name">`DEFAULT`</span> | [`String`](String.md) | Answer for an extension with no entry (same as EDIT) |
| <span class="fmrb-name">`SYS_PATH`</span> | [`String`](String.md) | Path of the table that ships with the firmware |
| <span class="fmrb-name">`USR_PATH`</span> | [`String`](String.md) | Path of the user's table |
| <span class="fmrb-name">`MAX_EXT_LEN`</span> | [`Integer`](Integer.md) | Longest extension looked at (8) |

## Class methods

### FmrbAssoc.resolve

<pre class="fmrb-sig"><code>resolve(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

Decide how to open a path

Returns `"run"`, `"edit"` or `"/app/..."`. **With no extension, or one**
**the table lacks, it is `"edit"`** (the editor is the answer to "I do not
know"). **It raises nothing.**
```ruby
FmrbAssoc.resolve("/home/hello.rb")
#=> "run"
FmrbAssoc.resolve("/home/a.txt")
#=> "edit"
```

### FmrbAssoc.extension_of

<pre class="fmrb-sig"><code>extension_of(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

The extension of a path

Returns what follows the last `.`, **in lower case** and without the dot.
**It is `""` when there is no extension**: no `.`, a `.` at the end, a
`.` inside a directory name, or more than 8 characters after it.
```ruby
FmrbAssoc.extension_of("/home/README.MD")
#=> "md"
```

### FmrbAssoc.load_table

<pre class="fmrb-sig"><code>load_table() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>]</code></pre>

The association table

Returns the table. **The first call reads the two files, and the same**
**Hash comes back for the rest of the VM.** The user's table overrides the
system one per extension.
```ruby
FmrbAssoc.load_table["md"]
#=> "/app/tool/picorabbit.app.rb"
```

### FmrbAssoc.forget

<pre class="fmrb-sig"><code>forget() -&gt; nil</code></pre>

Drop the table that was read

The next `resolve` reads the files again. For **a caller that has just**
**written a table** and for tests; nothing calls it automatically (except
the base, for an app moved to another machine). It always returns nil.
```ruby
FmrbAssoc.forget
```

### FmrbAssoc.merge_file

<pre class="fmrb-sig"><code>merge_file(<a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>] table, <a href="../String/">String</a> path) -&gt; nil</code></pre>

Merge one table file into a Hash

One step of `load_table`; **it writes into table and returns nil**. A
missing file changes nothing. Keys are stripped and lower-cased, and only
a non-empty String answer is taken. **A file with a TOML error is not**
**read at all** (one log line). The Spinel desktop reads line by line
instead of through TOML.
```ruby
t = {}
FmrbAssoc.merge_file(t, "/home/a.toml")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
