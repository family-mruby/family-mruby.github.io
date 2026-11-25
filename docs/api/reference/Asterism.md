# Asterism

The Asterism gem; apps use it through conn

How to use it: [Network](../network.md).

The gem in vendor/asterism. An app uses it through the conn of an FmrbAsterism::Link.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PROTOCOL`</span> | [`Integer`](Integer.md) | The wire protocol version this implementation speaks |
| <span class="fmrb-name">`DEFAULT_TIMEOUT`</span> | [`Float`](Float.md) | Default time limit of a call (seconds) |
| <span class="fmrb-name">`DEFAULT_TIMEOUT_MS`</span> | [`Integer`](Integer.md) | Default time limit of a call (milliseconds) |
| <span class="fmrb-name">`CHECK_TIMEOUT`</span> | [`Float`](Float.md) | How long connect looks for a same-name peer (s) |
| <span class="fmrb-name">`ROOT`</span> | [`String`](String.md) | The first chunk of every key ("asterism") |

## Class methods

### Asterism.connect

<pre class="fmrb-sig"><code>connect(
  ?<a href="../String/">String</a>? locator,
  app: <a href="../String/">String</a>,
  ?node: <a href="../String/">String</a>?,
  ?mode: <a href="../Symbol/">Symbol</a>?,
  ?listen: <a href="../String/">String</a>?,
  ?config: (<a href="../Hash/">Hash</a> | <a href="../String/">String</a>)?,
  ?connect_timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?check_timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?credentials: (<a href="../String/">String</a> | <a href="../Asterism__Credentials/">Asterism::Credentials</a>)?
) -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a></code></pre>

Open a connection (what Link does for you)

Connects to the router (locator), puts this app (app of node) on
Asterism and returns an Asterism::Connection. **An app on a machine normally uses Link**
(Link waits for WiFi, connects again and reads the settings); this is
the entry Link calls. **The app waits while it connects** (about 1.5 s
of `check_timeout:` looking for another copy of the same name, and a
few seconds when there is no router). `node:`
(the credentials' name when left out), `app:` (required), `mode:`
(a client of a router when left out; :peer for no router), `listen:`,
`config:` (TLS keys and the like; a Hash or a JSON5 String),
`connect_timeout:` (CRuby on a PC only; ArgumentError on a machine),
`check_timeout:` (seconds), `credentials:` (a .tar path or an
Asterism::Credentials; it gives the default locator and node).
Raises Asterism::Disconnected when it cannot connect, Asterism::Error
when the same node/app is already there, ArgumentError for a bad name.
```ruby
conn = Asterism.connect(
  "tcp/192.0.2.2:7447",
  node: "fmruby-aaa001", app: "demo")
```

### Asterism.connections

<pre class="fmrb-sig"><code>connections() -&gt; <a href="../Array/">Array</a>[<a href="../Asterism__Connection/">Asterism::Connection</a>]</code></pre>

The connections of this program that are open

In the order they were opened; one that was lost but still has its
on_leave blocks to tell is included.
```ruby
n = Asterism.connections.size
```

### Asterism.poll_all

<pre class="fmrb-sig"><code>poll_all() -&gt; bool</code></pre>

Poll every connection of this program

True while one of them is connected. With a Link, Link#update polls.
```ruby
Asterism.poll_all
```

### Asterism.profile_defaults

<pre class="fmrb-sig"><code>profile_defaults(
  ?kind: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?name: <a href="../String/">String</a>?,
  ?host: <a href="../String/">String</a>?,
  ?icon: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

The program's default profile for every node

With keywords it changes those fields (nil removes one; `icon: nil`
does not use the default icon either) and returns the profile they make;
without, it returns the defaults. Connected nodes put the change on the
network. A node's own override is Connection#profile. Fields:
`kind:` (Symbol or String), `name:` and `host:` (Strings), `icon:`
(PNG bytes). ArgumentError for what it does not accept.
```ruby
Asterism.profile_defaults(
  kind: :family_mruby, host: "sim")
```

### Asterism.default_icon_path

<pre class="fmrb-sig"><code>default_icon_path() -&gt; <a href="../String/">String</a>?</code></pre>

Where the default icon is read from

"/usr/share/asterism/icon.png" on a machine. It is used when nobody
gave an icon.
```ruby
path = Asterism.default_icon_path
```

### Asterism.read_attachment

<pre class="fmrb-sig"><code>read_attachment(
  <a href="../String/">String</a>? att,
  ?<a href="../Symbol/">Symbol</a>? place,
  ?<a href="../String/">String</a>? node
) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

Read the attachment of a value: [seq, run id, time, from]

att is the attachment bytes that came with a value. Returns `[seq,
run id, sender's time, sender]`; nil without a sequence number (no
attachment, or the wrong shape). The sender is filled only for a shared
place (place :node or :global). subscribe turns it into a SampleInfo for
you.
```ruby
seq, run, ms, from =
  Asterism.read_attachment(att)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
