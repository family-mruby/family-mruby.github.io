# Asterism::Connection

One app's connection to the network

How to use it: [Network](../network.md).

Got with link.conn.

## Instance methods

### Asterism::Connection#expose

<pre class="fmrb-sig"><code>expose(
  <a href="../String/">String</a> name,
  untyped obj,
  methods: <a href="../Array/">Array</a>[untyped] | <a href="../Hash/">Hash</a>[untyped, untyped],
  ?caller: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?doc: <a href="../String/">String</a>?
) -&gt; <a href="../String/">String</a></code></pre>

Expose an object to other machines

Others call it as "<this node>/<app>/<name>".
**Pass methods: as a keyword**: a Hash of method name => number of arguments
({ post: 1 }, checked before the call; -1 for any) or an Array of
names. Only those can be called; a missing one raises
ArgumentError. Exposed methods run inside update; what they raise
reaches the caller as a RemoteError. `caller:` (not given when left
out), a keyword name such as :from: every call passes the calling
node's ID to the method under that keyword. `doc:` (none when left
out) describes the object (2048 bytes at most). Returns the path.
Call it in link_up.
```ruby
def link_up(link)
  link.conn.expose("board", self,
    methods: { post: 1 })
end
```

### Asterism::Connection#[]

<pre class="fmrb-sig"><code>[](
  <a href="../String/">String</a> path,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Asterism__Proxy/">Asterism::Proxy</a></code></pre>

A proxy for another machine's object

path is "<node>/<app>/<object>". Nothing is sent until a method is
called on it; the call runs there and waits for the answer (2 s;
**timeout: sets seconds**; `timeout_ms:` for milliseconds), answering calls to this app meanwhile.
Use async not to wait. Fails with Asterism::RemoteError (it raised,
is not exposed, wrong arguments), Asterism::TimeoutError, or
Asterism::Disconnected -- all Asterism::Error.
```ruby
b = @link.conn[
  "fmruby-1/talk_board/board"]
n = b.post("hello")
```

### Asterism::Connection#each

<pre class="fmrb-sig"><code>each(?<a href="../String/">String</a> pattern) -&gt; <a href="../Array/">Array</a>[<a href="../Asterism__Proxy/">Asterism::Proxy</a>]
each(?<a href="../String/">String</a> pattern) { (<a href="../Asterism__Proxy/">Asterism::Proxy</a> proxy) -&gt; untyped } -&gt; <a href="../Integer/">Integer</a></code></pre>

The exposed objects alive now matching a pattern

* is one chunk, `**` any number (everything when left out); this
machine's own are included. With a block it yields each and returns
the count. Returns an Array of proxies (like conn[path]). It does not ask the
network, so it is cheap to call every time.
```ruby
list = @link.conn.each(
  "*/talk_board/board")
@board = list[0]
```

### Asterism::Connection#nodes

<pre class="fmrb-sig"><code>nodes() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

The node IDs alive now (this one first)

```ruby
names = @link.conn.nodes
```

### Asterism::Connection#apps

<pre class="fmrb-sig"><code>apps(?<a href="../String/">String</a> pattern) -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

The apps alive now ("node/app") matching a pattern

```ruby
list = @link.conn.apps("*/talk")
```

### Asterism::Connection#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

This app's path, "node/app"

```ruby
me = @link.conn.path
```

### Asterism::Connection#publish

<pre class="fmrb-sig"><code>publish(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  ?type: (<a href="../Symbol/">Symbol</a> | <a href="../Integer/">Integer</a> | <a href="../String/">String</a>)?,
  ?unit: <a href="../String/">String</a>?,
  ?desc: <a href="../String/">String</a>?,
  ?ts: bool,
  ?encoding: <a href="../String/">String</a>?,
  ?shared: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?
) -&gt; <a href="../Asterism__Topic/">Asterism::Topic</a></code></pre>

Declare a topic to put values on

name is "said" or "game/score". Others subscribe to
"<this node>/<app>/<name>"; put on the returned Topic sends a
value. Keywords (type:, unit:, desc:, ts:) are optional. Values are
not kept for late readers. Raises Asterism::Disconnected when not
connected. Call it in link_up.
```ruby
@said = link.conn.publish("said")
@said.put({ "text" => "hi" })
```

### Asterism::Connection#subscribe

<pre class="fmrb-sig"><code>subscribe(
  <a href="../String/">String</a> path,
  ?depth: <a href="../Integer/">Integer</a>?
) { (untyped value, <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info) -&gt; untyped } -&gt; <a href="../Asterism__Subscription/">Asterism::Subscription</a></code></pre>

Receive the values of topics (in a block)

path is "<node>/<app>/<topic>" (* one chunk, `**` any number). The
block gets |value, info| (an Asterism::SampleInfo)
**inside update**. Your own puts do not come back to you. **depth:** sets how
many wait between updates. close the returned Subscription to stop.
Call it in link_up.
```ruby
link.conn.subscribe(
  "*/talk_board/said") do |v, info|
  got(v, info.from)
end
```

### Asterism::Connection#status

<pre class="fmrb-sig"><code>status(?<a href="../Hash/">Hash</a> status, **untyped fields) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Set this app's status (a small Hash others can read)

A Hash replaces it, keywords change those fields (nil removes one).
It goes out only when it changes; 1 KB at most. Without arguments,
returns it (nil when none). `status(lines: 3)` changes only that field.
```ruby
@link.conn.status(
  { "lines" => @lines.size })
```

### Asterism::Connection#status_of

<pre class="fmrb-sig"><code>status_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Another app's status (nil when it does not answer)

Waits for the answer (2 s; `timeout:` in seconds, `timeout_ms:` in
milliseconds). Raises Asterism::Disconnected when not
connected.
```ruby
st = @link.conn.status_of(
  "fmruby-1", "talk_board")
```

### Asterism::Connection#on_join

<pre class="fmrb-sig"><code>on_join() { (<a href="../String/">String</a> node) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

Run a block when another machine joins

The block gets |node| and runs inside update. Give it in link_up
(a new connection forgets it).
```ruby
link.conn.on_join { |n| joined(n) }
```

### Asterism::Connection#on_leave

<pre class="fmrb-sig"><code>on_leave() { (<a href="../String/">String</a> node) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

Run a block when another machine leaves

When the connection is lost, every machine known until then leaves.
```ruby
link.conn.on_leave { |n| left(n) }
```

### Asterism::Connection#current_call

<pre class="fmrb-sig"><code>current_call() -&gt; <a href="../Asterism__CurrentCall/">Asterism::CurrentCall</a>?</code></pre>

The call being answered now: who called (nil outside)

Inside an exposed method, tells which machine called.
```ruby
def post(text)
  who = @link.conn.current_call.from
  add("#{who}: #{text}")
end
```

### Asterism::Connection#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a></code></pre>

This app's name on the network

```ruby
name = @link.conn.app
```

### Asterism::Connection#node_id

<pre class="fmrb-sig"><code>node_id() -&gt; <a href="../String/">String</a></code></pre>

This machine's node ID

```ruby
me = @link.conn.node_id
```

### Asterism::Connection#run_id

<pre class="fmrb-sig"><code>run_id() -&gt; <a href="../Integer/">Integer</a></code></pre>

The run id of this connection (16 random bits)

A new one for every connect. It goes with each value of the
topics, so a reader notices that the sender connected again
(SampleInfo#restarted?).
```ruby
id = @link.conn.run_id
```

### Asterism::Connection#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

Whether the connection is there

Also true while reconnecting. When it finds the session closed it
marks the connection lost on the spot and returns false.
```ruby
return unless conn.connected?
```

### Asterism::Connection#reconnecting?

<pre class="fmrb-sig"><code>reconnecting?() -&gt; bool</code></pre>

Whether the binding is reconnecting by itself

While true, connected? is true too. The other nodes leave (on_leave)
and join again; calls raise Disconnected or time out and puts reach
nobody. Once it is back, what was exposed, published and subscribed
works as before.
```ruby
if conn.reconnecting?
  show("reconnecting")
end
```

### Asterism::Connection#lost_reason

<pre class="fmrb-sig"><code>lost_reason() -&gt; <a href="../String/">String</a>?</code></pre>

Why the connection went away (nil while connected)

```ruby
why = @link.conn.lost_reason
```

### Asterism::Connection#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Close the connection

Everything exposed, published and subscribed ends with it, and the
on_join blocks are forgotten. Safe to call twice. A closed
connection is not opened again (make a new one with
Asterism.connect). With a Link, Link#close does this. Returns nil.
```ruby
conn.close
```

### Asterism::Connection#poll

<pre class="fmrb-sig"><code>poll() -&gt; bool</code></pre>

Poll: answer, receive, tell joins

Answers the calls that came in and runs the on_join / on_leave and
subscribe blocks (never from inside the polling of a waiting call).
False once closed. **With a Link, Link#update calls it; do not call it yourself.**
Asterism.poll_all polls every connection.
```ruby
conn = Asterism.connect(r, app: "x")
conn.poll
```

### Asterism::Connection#session

<pre class="fmrb-sig"><code>session() -&gt; untyped</code></pre>

The Zenoh session, for what Asterism does not do

For a ROS 2 Node (`Asterism::ROS::Node.new(conn.session, ...)`) or
put and subscribe by hand. The session belongs to the connection: its
close does nothing (it warns once); Connection#close closes it.
Raises Asterism::Disconnected when not connected.
```ruby
s = @link.conn.session
node = Asterism::ROS::Node.new(s, "n")
```

### Asterism::Connection#exposed

<pre class="fmrb-sig"><code>exposed() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

Names of the objects exposed now

```ruby
names = @link.conn.exposed
```

### Asterism::Connection#unexpose

<pre class="fmrb-sig"><code>unexpose(<a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name) -&gt; bool</code></pre>

Stop exposing an object

True when it was exposed, false when it was not.
```ruby
@link.conn.unexpose("board")
```

### Asterism::Connection#published

<pre class="fmrb-sig"><code>published() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

The topics published now (their entries)

Own topics by name; shared ones as "<node>/@shared/<name>" or
"@shared/<name>".
```ruby
list = @link.conn.published
```

### Asterism::Connection#unpublish

<pre class="fmrb-sig"><code>unpublish(
  <a href="../Asterism__Topic/">Asterism::Topic</a> | <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> topic,
  ?shared: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?
) -&gt; bool</code></pre>

Withdraw a topic

Pass the Topic, or its name with the `shared:` it was published with.
Its declaration goes. True when there was one. Publishing the name
again goes on from the same numbers.
```ruby
@link.conn.unpublish("said")
```

### Asterism::Connection#unsubscribe

<pre class="fmrb-sig"><code>unsubscribe(<a href="../Asterism__Subscription/">Asterism::Subscription</a> sub) -&gt; bool</code></pre>

End a subscription

The same as Subscription#close. True when it was open.
```ruby
@link.conn.unsubscribe(@sub)
```

### Asterism::Connection#off_join

<pre class="fmrb-sig"><code>off_join(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

Remove a block given to on_join

Keep the Proc you gave and pass it again.
```ruby
h = proc { |n| joined(n) }
conn.on_join(&h)
conn.off_join(h)
```

### Asterism::Connection#off_leave

<pre class="fmrb-sig"><code>off_leave(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

Remove a block given to on_leave

```ruby
conn.off_leave(h)
```

### Asterism::Connection#on_app_join

<pre class="fmrb-sig"><code>on_app_join() { (<a href="../String/">String</a> node, <a href="../String/">String</a> app) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

Run a block when another machine's app appears

The block gets |node, app| and runs inside update. A node may run
several apps; each comes and goes on its own. When the connection is
lost, every app known until then leaves. Give it in link_up.
```ruby
conn.on_app_join do |n, a|
  seen(n, a)
end
```

### Asterism::Connection#on_app_leave

<pre class="fmrb-sig"><code>on_app_leave() { (<a href="../String/">String</a> node, <a href="../String/">String</a> app) -&gt; untyped } -&gt; Asterism::Connection</code></pre>

Run a block when another machine's app leaves

```ruby
conn.on_app_leave do |n, a|
  gone(n, a)
end
```

### Asterism::Connection#off_app_join

<pre class="fmrb-sig"><code>off_app_join(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

Remove a block given to on_app_join

```ruby
conn.off_app_join(h)
```

### Asterism::Connection#off_app_leave

<pre class="fmrb-sig"><code>off_app_leave(<a href="../Proc/">Proc</a> blk) -&gt; Asterism::Connection</code></pre>

Remove a block given to on_app_leave

```ruby
conn.off_app_leave(h)
```

### Asterism::Connection#profile

<pre class="fmrb-sig"><code>profile(
  ?kind: (<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a>)?,
  ?name: <a href="../String/">String</a>?,
  ?host: <a href="../String/">String</a>?,
  ?icon: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

This node's profile (kind, name, host, icon)

With keywords it changes those fields and returns the profile;
without, it returns the profile. `kind:` (Symbol or String; nil goes
back to the default), `name:` and `host:` (Strings; nil leaves them
out), `icon:` (PNG bytes; nil for no icon). ArgumentError for what it
does not accept. The profile belongs to the node, so other
connections of the same node share it. A change is put on the network.
```ruby
conn.profile(name: "Rover")
```

### Asterism::Connection#profile_of

<pre class="fmrb-sig"><code>profile_of(
  <a href="../String/">String</a> node,
  ?icon: bool,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Another node's profile (nil when it does not answer)

Waits for the answer (2 s; `timeout:` in seconds, `timeout_ms:` in
milliseconds). `icon: false` leaves out the icon bytes (icon_hash
still says which one). Raises Asterism::Disconnected when not
connected. Its own node is not asked over the network.
```ruby
p = @link.conn.profile_of(node)
name = p["name"] if p
```

### Asterism::Connection#protocol_of

<pre class="fmrb-sig"><code>protocol_of(
  <a href="../String/">String</a> node,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

The protocol version a node or app speaks

"node/app" gives that app's version (nil while it is not seen); a
node alone gives the lowest of its apps', or asks its profile when
no app is known (nil without an answer, 0 when it says none). This
program speaks Asterism::PROTOCOL.
```ruby
v = conn.protocol_of("n/app")
```

### Asterism::Connection#define_type

<pre class="fmrb-sig"><code>define_type(
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  <a href="../Array/">Array</a>[<a href="../Array/">Array</a>[untyped]] fields,
  ?desc: <a href="../String/">String</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

Define an application type for topic values

name is like "mygame/board.strokes". fields is `[[name, type], ...]`;
a type is a name: built in ("vector3"), basic ("int", "float",
"str", "bin", "bool", "any") or another of your types, "[]" at the
end for an array. Values are Hashes keyed by the field names (short
names keep them small). `desc:` (none when left out) is a text.
Defining a name again replaces it; the types outlive close. Returns
the definition as sent ({"f" => ..., "d" => ...}). ArgumentError for
a number as a type or a bad field. Pass the name as publish's `type:`.
```ruby
conn.define_type("g/pt",
  [["x", "int"], ["y", "int"]])
```

### Asterism::Connection#pubs_of

<pre class="fmrb-sig"><code>pubs_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Another app's topics (nil if no answer)

`{topic => {"t" => type, "u" => unit, ...}}`; {} when it has none, nil
without an answer. Waits like status_of (2 s; `timeout:` in seconds,
`timeout_ms:` in milliseconds). Raises Asterism::Disconnected when
not connected.
```ruby
t = @link.conn.pubs_of("n", "app")
```

### Asterism::Connection#types_of

<pre class="fmrb-sig"><code>types_of(
  <a href="../String/">String</a> node,
  <a href="../String/">String</a> app,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Another app's own types (nil when it does not answer)

`{type name => {"f" => [[field, type], ...], "d" => text}}`; {} when it
has none, nil without an answer. Waits like pubs_of.
```ruby
t = @link.conn.types_of("n", "app")
```

### Asterism::Connection#publishers_of

<pre class="fmrb-sig"><code>publishers_of(
  <a href="../String/">String</a> path,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a></code></pre>

The apps that publish on a shared key

path is "@shared/<name>" or "<node>/@shared/<name>" (node may be *).
Returns `{"node/app" => declaration}` (this app's own included), {}
when nobody publishes it. Asks every app's profile at once and waits
up to `timeout:` seconds (2 by default; `timeout_ms:` in
milliseconds). ArgumentError for a path that is not a shared key;
Asterism::Disconnected when not connected.
```ruby
who = conn.publishers_of(
  "@shared/lobby")
```

### Asterism::Connection#declaration_of

<pre class="fmrb-sig"><code>declaration_of(
  <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

The sender's declaration of the topic a value came on

info is the SampleInfo a subscribe block gets. Returns the sender's
entry for that key in its @pubs (`{"t", "e", "u", "d", "ts"}`). On a
shared key every sender declares it its own way, so it asks the
sender (info.from). nil when the sender is unknown, does not answer
or does not declare the key. Waits the first time (2 s), then keeps
the answer.
```ruby
d = conn.declaration_of(info)
```

### Asterism::Connection#type_of

<pre class="fmrb-sig"><code>type_of(
  <a href="../Asterism__SampleInfo/">Asterism::SampleInfo</a> info,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?
) -&gt; (<a href="../Integer/">Integer</a> | <a href="../Array/">Array</a>[untyped])?</code></pre>

The type of a value, as its sender declared it

A built-in type's number (Integer), or `[name, definition]` for the
sender's own type (the definition from its own types; nil when it
does not tell). nil when there is no type or the sender does not
answer. Waits and keeps the answer as declaration_of does.
```ruby
t = conn.type_of(info)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
