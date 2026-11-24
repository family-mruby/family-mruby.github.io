# FmrbAsterism::TableClient

The device side of a game host's table

How to use it: [Network](../network.md).

Finds the tables a game host (app "games") has, joins one, asks the
member's view and leaves. The Link inside connects again; a host that
leaves the network and comes back is handled too.

**Use**: make it in on_create; in every on_update, while `update` is
true, collect the answers of the game's own calls (`proxy`), then call
`update_view`. `close` in on_destroy.

**Methods the app owns (called by the part)**: it calls the app by name
(no blocks are given). **Required**:
- `table_state(path, state)` a put of a table's state (a Hash); return what the list keeps (tables[path])
- `table_joined(reply)` join answered with a token (token is set; the view is asked next)
- `table_refused(why)` join refused (the host's word) or not answered (why nil); table is nil again
- `table_view(view)` the member's view (a Hash)
Optional (called when the app has them):
- `table_link_up(link)` after every connect (the subscription and on_join / on_leave are set)
- `table_link_down(link)` a connect failed or the connection went away
- `table_watch` every update while connected, before the states are read
- `tables_changed(added)` a table joined the list (true) or a host's tables left it (false)
- `table_host_gone` the joined table's host left the network
- `table_host_back` that host came back (the view is asked again)
- `table_view_failed` a view got no answer
- `table_dropped` the host does not know this member; without it the part leaves
- `table_ask_view(px, token)` ask the view yourself (px is the table's async proxy); return the Future
**Leaving or forgetting a table while its join is not answered drops that answer**
(the next join goes out at once). Any answer of the view,
an error too, says the host is there.
```ruby
def on_create
  @tc = FmrbAsterism::TableClient.new(
    self, "othello", tag: "othello")
end
def on_update
  if @tc.update
    @tc.update_view
  end
  100
end
def on_destroy
  @tc.close
end
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`HOST_APP`</span> | [`String`](String.md) | Default app name of the game host ("games") |
| <span class="fmrb-name">`CALL_TIMEOUT`</span> | [`Float`](Float.md) | Default call_timeout (3.0) |
| <span class="fmrb-name">`VIEW_EVERY_MS`</span> | [`Integer`](Integer.md) | Default view_every_ms (3000) |
| <span class="fmrb-name">`LIST_EVERY_MS`</span> | [`Integer`](Integer.md) | Default list_every_ms (30000) |
| <span class="fmrb-name">`RESCAN_MS`</span> | [`Integer`](Integer.md) | Default rescan_ms (3000) |
| <span class="fmrb-name">`RESCAN_STEP_MS`</span> | [`Integer`](Integer.md) | Default rescan_step_ms (300) |
| <span class="fmrb-name">`HOST_GONE_VIEW_MS`</span> | [`Integer`](Integer.md) | Default host_gone_view_ms (30000) |

## Class methods

### FmrbAsterism::TableClient.new

<pre class="fmrb-sig"><code>new(
  untyped owner,
  <a href="../String/">String</a> kind,
  ?tag: <a href="../String/">String</a>?,
  ?app: <a href="../String/">String</a>,
  ?host_app: <a href="../String/">String</a>,
  ?retry_ms: <a href="../Integer/">Integer</a>?,
  ?wifi_wait_ms: <a href="../Integer/">Integer</a>?,
  ?settings: <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a>?,
  ?blank: untyped
) -&gt; FmrbAsterism::TableClient</code></pre>

Make a table client (update connects)

owner is the app (self). kind is the start of the table names
("othello" finds "<host>/games/othello1" and so on). `tag:` (kind when
left out; the log prefix), `app:` ("game"; this app's name on the
network), `host_app:` ("games"; the host app to look for), `retry_ms:`
(3000; nil connects once), `wifi_wait_ms:` (when left out only the
ESP32 waits for WiFi; the sim and the browser do not), `settings:`
(FmrbAsterism.settings), `blank:` (nil; a sample of what the list
keeps for a table whose state has not come yet; a copy is stored;
mahjong uses {}). For the methods the app owns (table_state and the
rest) see the class description.
```ruby
@tc = FmrbAsterism::TableClient.new(
  self, "mahjong", blank: {})
```

## Instance methods

### FmrbAsterism::TableClient#update

<pre class="fmrb-sig"><code>update() -&gt; bool</code></pre>

Every update: connect, states, list, join

While connected it hands the states that came to `table_state`,
looks for tables and collects the answer to a join. Otherwise it
connects (the app waits a few seconds when there is no router, as
with Link#update). True while connected.
```ruby
if @tc.update
  draw_table
end
```

### FmrbAsterism::TableClient#update_view

<pre class="fmrb-sig"><code>update_view(?<a href="../Integer/">Integer</a> now) -&gt; void</code></pre>

Collect the view and ask it when due

Call it after collecting the game's own answers. Hands an arrived
view to `table_view`, and asks a new one when the member is in a
table, none is on its way and it is due. Nothing without a table.
`now` (the current ms when left out) is for tests.
```ruby
@tc.update_view
```

### FmrbAsterism::TableClient#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Close for good (on_destroy)

Closes the Link. It does not leave the table: leave it yourself first when joined.
```ruby
@tc.close
```

### FmrbAsterism::TableClient#net

<pre class="fmrb-sig"><code>net() -&gt; (:connecting | :up | :down)</code></pre>

The network state: :connecting, :up or :down

:connecting before the first try, :up while connected, :down after a
failure or a loss (connecting again).
```ruby
show("net: #{@tc.net}")
```

### FmrbAsterism::TableClient#reconnecting?

<pre class="fmrb-sig"><code>reconnecting?() -&gt; bool</code></pre>

Whether the session is lost and being reopened

```ruby
dim if @tc.reconnecting?
```

### FmrbAsterism::TableClient#joining?

<pre class="fmrb-sig"><code>joining?() -&gt; bool</code></pre>

Whether a join is on its way

```ruby
return if @tc.joining?
```

### FmrbAsterism::TableClient#host_gone?

<pre class="fmrb-sig"><code>host_gone?() -&gt; bool</code></pre>

Whether the joined table's host has left the network

```ruby
show("host gone") if @tc.host_gone?
```

### FmrbAsterism::TableClient#conn

<pre class="fmrb-sig"><code>conn() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a>?</code></pre>

The connection (nil unless connected)

The Link's conn. A new one after every connect.
```ruby
c = @tc.conn
```

### FmrbAsterism::TableClient#link

<pre class="fmrb-sig"><code>link() -&gt; <a href="../FmrbAsterism__Link/">FmrbAsterism::Link</a></code></pre>

The Link inside (state, reason, ...)

Use it to show the state and the reason. Leave close to
TableClient#close.
```ruby
why = @tc.link.reason
```

### FmrbAsterism::TableClient#kind

<pre class="fmrb-sig"><code>kind() -&gt; <a href="../String/">String</a></code></pre>

The kind given to new

```ruby
k = @tc.kind
```

### FmrbAsterism::TableClient#tables

<pre class="fmrb-sig"><code>tables() -&gt; <a href="../Hash/">Hash</a></code></pre>

The tables: path => what table_state returned

What table_state returned (a copy of blank until one came). A path
is "<host>/games/<table>".
```ruby
st = @tc.tables[@tc.table]
```

### FmrbAsterism::TableClient#table_list

<pre class="fmrb-sig"><code>table_list() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

The table paths, sorted

When a host leaves, its tables go off the list.
```ruby
@tc.table_list.each { |p| add(p) }
```

### FmrbAsterism::TableClient#table

<pre class="fmrb-sig"><code>table() -&gt; <a href="../String/">String</a>?</code></pre>

The joined table's path (nil when none)

Set from the moment of join; nil again after leave, forget, a refusal
or no answer.
```ruby
return unless @tc.table
```

### FmrbAsterism::TableClient#token

<pre class="fmrb-sig"><code>token() -&gt; <a href="../String/">String</a>?</code></pre>

The member's token on the table (nil until the join answered)

The host hands it back in the answer to join; pass it with every view
and move.
```ruby
px.play(@tc.token, 3)
```

### FmrbAsterism::TableClient#want_v

<pre class="fmrb-sig"><code>want_v() -&gt; <a href="../Integer/">Integer</a></code></pre>

The newest version a state put told of

When it is above view_v, a newer view is due.

### FmrbAsterism::TableClient#view_v

<pre class="fmrb-sig"><code>view_v() -&gt; <a href="../Integer/">Integer</a></code></pre>

The version of the view last taken

```ruby
v = @tc.view_v
```

### FmrbAsterism::TableClient#proxy

<pre class="fmrb-sig"><code>proxy(?<a href="../String/">String</a> path) -&gt; <a href="../Asterism__Proxy/">Asterism::Proxy</a></code></pre>

A proxy for the table (or another path) for the game's own calls

`proxy` is the joined table, `proxy(path)` another path. Calls wait
call_timeout. For a call that does not wait use `proxy.async`. Raises
Asterism::Disconnected when not connected, ArgumentError without a
path (no table joined).
```ruby
f = @tc.proxy.async.play(@tc.token, 3)
```

### FmrbAsterism::TableClient#join

<pre class="fmrb-sig"><code>join(<a href="../String/">String</a>? path, <a href="../String/">String</a> name) -&gt; <a href="../String/">String</a>?</code></pre>

Join the table at path as name

Sends the call and returns; update collects the answer and calls
table_joined or table_refused. Returns nil and does nothing when a
join is already on its way or path is nil. When the call could not be
sent it returns the error's text (a String) and table is nil again.
Call it while connected.
```ruby
err = @tc.join(path, "Aki")
show(err) if err
```

### FmrbAsterism::TableClient#leave

<pre class="fmrb-sig"><code>leave() -&gt; void</code></pre>

Leave the table (the host is told, not waited for)

Calls the table's leave without waiting when joined, then forgets the
table and token. No exception when it cannot be sent.
```ruby
@tc.leave
```

### FmrbAsterism::TableClient#forget

<pre class="fmrb-sig"><code>forget() -&gt; void</code></pre>

Forget the table without telling the host

A join on its way is dropped: its answer is not read and the next join
goes out at once.
```ruby
@tc.forget
```

### FmrbAsterism::TableClient#ask_view

<pre class="fmrb-sig"><code>ask_view() -&gt; void</code></pre>

Ask the member's view now

Does nothing while a view is on its way or without a token. Quietly
gives up when the call cannot be sent. When the app has
`table_ask_view`, that sends the question.
```ruby
@tc.ask_view
```

### FmrbAsterism::TableClient#refresh_view

<pre class="fmrb-sig"><code>refresh_view() -&gt; void</code></pre>

Drop the view in flight and ask again

Call it after the answer to the game's own call (a move, say) came.
```ruby
@tc.refresh_view
```

### FmrbAsterism::TableClient#call_timeout

<pre class="fmrb-sig"><code>call_timeout() -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

The time limit of the game's own calls (3.0)

```ruby
@tc.call_timeout = 5.0
```

### FmrbAsterism::TableClient#call_timeout=

<pre class="fmrb-sig"><code>call_timeout=(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

Set the time limit of the game's own calls (seconds)

The same unit as the reader.
```ruby
@tc.call_timeout = 5.0
```

### FmrbAsterism::TableClient#view_every_ms

<pre class="fmrb-sig"><code>view_every_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

Ask the view at least this often (3000)

Asking also tells the host this member is still there.
```ruby
@tc.view_every_ms = 5000
```

### FmrbAsterism::TableClient#view_every_ms=

<pre class="fmrb-sig"><code>view_every_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set how often the view is asked (ms)

The same unit as the reader.
```ruby
@tc.view_every_ms = 5000
```

### FmrbAsterism::TableClient#view_min_ms

<pre class="fmrb-sig"><code>view_min_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

The shortest gap between views (0)

A newer version waits until this much time has passed since the last
view.
```ruby
@tc.view_min_ms = 1000
```

### FmrbAsterism::TableClient#view_min_ms=

<pre class="fmrb-sig"><code>view_min_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the shortest gap between views (ms)

The same unit as the reader.
```ruby
@tc.view_min_ms = 1000
```

### FmrbAsterism::TableClient#list_every_ms

<pre class="fmrb-sig"><code>list_every_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

How often the table list is looked for again (30000)

```ruby
@tc.list_every_ms = 10000
```

### FmrbAsterism::TableClient#list_every_ms=

<pre class="fmrb-sig"><code>list_every_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set how often the table list is looked for (ms)

The same unit as the reader.
```ruby
@tc.list_every_ms = 10000
```

### FmrbAsterism::TableClient#rescan_ms

<pre class="fmrb-sig"><code>rescan_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

How long to keep looking after a join (3000)

```ruby
@tc.rescan_ms = 5000
```

### FmrbAsterism::TableClient#rescan_ms=

<pre class="fmrb-sig"><code>rescan_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set how long to keep looking for tables (ms)

The same unit as the reader.
```ruby
@tc.rescan_ms = 5000
```

### FmrbAsterism::TableClient#rescan_step_ms

<pre class="fmrb-sig"><code>rescan_step_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

The gap between looks during that time (300)

```ruby
@tc.rescan_step_ms = 500
```

### FmrbAsterism::TableClient#rescan_step_ms=

<pre class="fmrb-sig"><code>rescan_step_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the gap between those looks (ms)

The same unit as the reader.
```ruby
@tc.rescan_step_ms = 500
```

### FmrbAsterism::TableClient#host_gone_view_ms

<pre class="fmrb-sig"><code>host_gone_view_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

Gap between views while the host is gone (30000)

The view is asked this often even if no notice of its return came.
```ruby
@tc.host_gone_view_ms = 10000
```

### FmrbAsterism::TableClient#host_gone_view_ms=

<pre class="fmrb-sig"><code>host_gone_view_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the view gap while the host is gone

The same unit as the reader.
```ruby
@tc.host_gone_view_ms = 10000
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
