# FmrbReceiveConf

Read and write the receive settings

The settings
are in `/home/asterism/receive.toml` (else the shipped `/etc/asterism/receive.toml`).
**Receiving is on only with an `enabled = true` line**; a missing file or line means "not
receiving". There is a part written by hand and a "managed" part the console writes; `set_*`,
`allow` and `deny` change **only the part by hand**.
```ruby
require "/usr/share/transfer/receive_conf"
FmrbReceiveConf.enabled?
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PATH`</span> | [`String`](String.md) | The settings file you edit |
| <span class="fmrb-name">`SYS_PATH`</span> | [`String`](String.md) | The shipped settings file |
| <span class="fmrb-name">`ANYONE`</span> | [`String`](String.md) | The mark for everyone on the network (`"*"`) |
| <span class="fmrb-name">`ENTRY_MAX`</span> | [`Integer`](Integer.md) | Longest sender entry (bytes) |

## Class methods

### FmrbReceiveConf.path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a>?</code></pre>

The settings file in use

The user's file if there is one, else the shipped one, nil when neither exists.
```ruby
FmrbReceiveConf.path
```

### FmrbReceiveConf.enabled?

<pre class="fmrb-sig"><code>enabled?() -&gt; bool</code></pre>

Whether receiving is on

true when the part by hand has `enabled = true`. No line, another value, text that is not
TOML and no file are all false.
```ruby
FmrbReceiveConf.enabled?
```

### FmrbReceiveConf.send_enabled?

<pre class="fmrb-sig"><code>send_enabled?() -&gt; bool</code></pre>

Whether the send list is on

true with `send_enabled = true`. The same rules.
```ruby
FmrbReceiveConf.send_enabled?
```

### FmrbReceiveConf.rshell_enabled?

<pre class="fmrb-sig"><code>rshell_enabled?() -&gt; bool</code></pre>

Whether the remote shell is on

true with `rshell_enabled = true`. The same rules. Who may come in is the `"rshell"` kind's
list (doc/remote_shell).
```ruby
FmrbReceiveConf.rshell_enabled?
```

### FmrbReceiveConf.rshell_uncertified?

<pre class="fmrb-sig"><code>rshell_uncertified?() -&gt; bool</code></pre>

Whether unchecked connections are taken

true with `rshell_uncertified = true` (written by hand only). For the sim and development
checks; otherwise only a tls/ router's connection (the console's door in the browser) is taken.
```ruby
FmrbReceiveConf.rshell_uncertified?
```

### FmrbReceiveConf.install_mode

<pre class="fmrb-sig"><code>install_mode() -&gt; <a href="../String/">String</a></code></pre>

How apps are installed ("ask" or "auto")

"auto" with `install = "auto"` under `[app]` (apps from a sender checked by its certificate
are installed without asking), otherwise "ask" (the owner is asked each time).
```ruby
FmrbReceiveConf.install_mode   #=> "ask"
```

### FmrbReceiveConf.view

<pre class="fmrb-sig"><code>view() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

The settings read in one go

A Hash of what the Receiving app shows: `"enabled"`, `"send_enabled"`, `"path"` (nil without
a file), `"hand_ok"` (the part by hand is TOML or empty), `"by"` and `"at"` (what the console
wrote), `"install"`, `"rshell_enabled"`, and per kind (`"file"`, `"checkpoint"`, `"app"`,
`"rshell"`) `{ "hand" => list or nil, "managed" => list or nil }`.
```ruby
v = FmrbReceiveConf.view
v["file"]["hand"]
```

### FmrbReceiveConf.set_enabled

<pre class="fmrb-sig"><code>set_enabled(bool on) -&gt; bool</code></pre>

Turn receiving on or off

true when it wrote, false when it was already so (nothing is written). **A part by hand**
**that is not TOML raises ArgumentError** and nothing is written (somebody's text is not
rewritten). The change is checked by reading it back before writing. After switching,
tell the transfer app with `tell_transfer`.
```ruby
FmrbReceiveConf.set_enabled(true)
```

### FmrbReceiveConf.set_send_enabled

<pre class="fmrb-sig"><code>set_send_enabled(bool on) -&gt; bool</code></pre>

Turn the send list on or off

The same answers and exceptions as `set_enabled`.
```ruby
FmrbReceiveConf.set_send_enabled(true)
```

### FmrbReceiveConf.set_rshell_enabled

<pre class="fmrb-sig"><code>set_rshell_enabled(bool on) -&gt; bool</code></pre>

Turn the remote shell on or off

The same answers and exceptions as `set_enabled`. On, the machines allowed can see and
change the files here from afar. After switching, tell the transfer app with `tell_transfer`.
```ruby
FmrbReceiveConf.set_rshell_enabled(true)
```

### FmrbReceiveConf.set_install_mode

<pre class="fmrb-sig"><code>set_install_mode(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> mode) -&gt; bool</code></pre>

Choose how apps are installed

`"ask"` or `"auto"` (a Symbol works too). Anything else is an ArgumentError ("not a way to
install"). true when it wrote, false when it was already so. Other exceptions as `set_enabled`.
```ruby
FmrbReceiveConf.set_install_mode("ask")
```

### FmrbReceiveConf.allow

<pre class="fmrb-sig"><code>allow(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> kind, <a href="../String/">String</a> node, ?bool all_kinds) -&gt; bool</code></pre>

Let a sender in

`kind` is `"file"`, `"checkpoint"` or `"app"` (a Symbol works; anything else is an
ArgumentError; with `all_kinds` true `"rshell"` too). `node` is a node name or pattern (letters, digits and `.` `_` `-` `*` only, up
to `ENTRY_MAX` bytes; `"*"` is everyone on the network, and a pattern like `"pc-*"` works), else
an ArgumentError. One list holds at most 64 entries (more is an ArgumentError). true when it
wrote, false when the list by hand already had it.
```ruby
FmrbReceiveConf.allow("file", "pc-desk")
```

### FmrbReceiveConf.deny

<pre class="fmrb-sig"><code>deny(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> kind, <a href="../String/">String</a> node, ?bool all_kinds) -&gt; bool</code></pre>

Take a sender out

Takes it out of the list by hand and returns true. **A node that is not in the list is an**
**ArgumentError**; when it is only in the console's list the message says it is changed there
(the console's list is not changed here).
```ruby
FmrbReceiveConf.deny("file", "pc-desk")
```

### FmrbReceiveConf.tell_transfer

<pre class="fmrb-sig"><code>tell_transfer(<a href="../FmrbApp/">FmrbApp</a> app, bool on) -&gt; <a href="../Symbol/">Symbol</a></code></pre>

Tell the transfer app the settings changed

`app` is the calling app (self), `on` whether receiving, sending or the remote shell is on. When on and the
transfer app is not running it is started (`:started`); when running it is asked to read the
settings again (`:running`, or `:stopping` when `on` is false: it ends once what is coming in
is in). `:none` when it is not running and `on` is false.
```ruby
FmrbReceiveConf.tell_transfer(self, on)
```

### FmrbReceiveConf.node_ok?

<pre class="fmrb-sig"><code>node_ok?(untyped name) -&gt; bool</code></pre>

Whether a name may go in a list

true for a valid node name or pattern (the check `allow` makes).
```ruby
FmrbReceiveConf.node_ok?("pc-*")   #=> true
```

### FmrbReceiveConf.allows_anyone?

<pre class="fmrb-sig"><code>allows_anyone?(untyped list) -&gt; bool</code></pre>

Whether a list lets everyone in

true when the list has `"*"`. false when it is not an Array.
```ruby
FmrbReceiveConf.allows_anyone?(list)
```

### FmrbReceiveConf.allows?

<pre class="fmrb-sig"><code>allows?(untyped list, <a href="../String/">String</a> node) -&gt; bool</code></pre>

Whether a list lets a node in

true when an entry equals `node` or a pattern with `*` matches it. A `*` is any run of
letters (also none). false when the list is not an Array.
```ruby
FmrbReceiveConf.allows?(["pc-*"], "pc-desk")
#=> true
```

### FmrbReceiveConf.senders

<pre class="fmrb-sig"><code>senders(<a href="../String/">String</a> kind) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

The senders of one kind

One read, returning a Hash: `"enabled"`, `"hand"` (the list by hand, nil if none),
`"managed"` (the console's list, nil if none), `"by"` and `"at"` (the console's).
```ruby
s = FmrbReceiveConf.senders("file")
s["hand"]
```

### FmrbReceiveConf.lines

<pre class="fmrb-sig"><code>lines() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

Lines that describe the settings

The text the shell's `areceive` and `asend -l` print: on or off, the file read, and the
senders of each kind with where they come from, as English lines.
```ruby
FmrbReceiveConf.lines.each { |l| puts l }
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
