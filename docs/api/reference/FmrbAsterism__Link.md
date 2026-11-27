# FmrbAsterism::Link

Keeps the app connected (connect, retry, close)

How to use it: [Network](../network.md).

One per app. Make it in on_create, call update in every on_update,
close it in on_destroy. After every connect it calls the app's
**link_up(link)**; after a failed connect or a lost connection it
calls **link_down(link)** when the app has one (optional). It
connects again by itself every retry_ms.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_RETRY_MS`</span> | [`Integer`](Integer.md) | Default retry_ms (3000) |
| <span class="fmrb-name">`DEFAULT_WIFI_WAIT_MS`</span> | [`Integer`](Integer.md) | Default wifi_wait_ms (20000) |

## Class methods

### FmrbAsterism::Link.new

<pre class="fmrb-sig"><code>new(
  <a href="../FmrbApp/">FmrbApp</a> owner,
  <a href="../String/">String</a> app,
  ?tag: <a href="../String/">String</a>?,
  ?retry_ms: <a href="../Integer/">Integer</a>?,
  ?wifi_wait_ms: <a href="../Integer/">Integer</a>,
  ?screen_wait_ms: <a href="../Integer/">Integer</a>?,
  ?settings: <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a>?
) -&gt; FmrbAsterism::Link</code></pre>

Make a link (update connects later)

owner is the app (self). app is the app's name on the network:
others see "<node>/<app>/<object>". No /, *, #, ?, $ and no leading
@. **Keywords are optional**: tag: (log prefix), retry_ms: (default
3000; nil tries once). Making it does not connect yet. One app of a
name per machine (a second one gets :still_there). Also
`wifi_wait_ms:` (20000 when left out; the most it waits for WiFi to
get an address), `screen_wait_ms:` (not waiting when left out; a value
waits for screen_ready), `settings:` (FmrbAsterism.settings when left out).
```ruby
@link = FmrbAsterism::Link.new(
  self, "talk", retry_ms: 5000)
```

## Instance methods

### FmrbAsterism::Link#update

<pre class="fmrb-sig"><code>update() -&gt; bool</code></pre>

Call every on_update (answer, receive, connect)

While connected it answers the calls that came in and runs the
subscribe blocks; otherwise it connects when it is time (the app
waits for that, a few seconds when there is no router). True
while connected.
```ruby
def on_update
  if @link.update
    check_call
  end
  100
end
```

### FmrbAsterism::Link#connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

Whether it is connected

Also true while reconnecting.
```ruby
return unless @link.connected?
```

### FmrbAsterism::Link#up?

<pre class="fmrb-sig"><code>up?() -&gt; bool</code></pre>

Connected and not reconnecting

```ruby
@topic.put(v) if @link.up?
```

### FmrbAsterism::Link#state

<pre class="fmrb-sig"><code>state() -&gt; (:waiting_wifi | :waiting_screen | :connecting | :connected | :reconnecting | :retrying | :still_there | :lost | :failed | :closed)</code></pre>

The state now

:connected is connected. :connecting connects on the next update
(draw "connecting" first). :retrying, :lost and :still_there try
again after retry_ms. :failed failed with retry_ms: nil, :closed
is after close.
```ruby
if @link.state == :connecting
  show("connecting")
end
```

### FmrbAsterism::Link#reason

<pre class="fmrb-sig"><code>reason() -&gt; <a href="../String/">String</a></code></pre>

Why it is not connected ("" while connected)

```ruby
def link_down(link)
  show(link.reason)
end
```

### FmrbAsterism::Link#conn

<pre class="fmrb-sig"><code>conn() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a>?</code></pre>

The connection: expose, call, publish, subscribe

Only while connected; nil before the first connect and after a
loss. A new one after every connect, so take it from link.conn
each time (in link_up, or after connected?).
```ruby
c = @link.conn
c.nodes if c
```

### FmrbAsterism::Link#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a></code></pre>

This machine's node ID

```ruby
me = @link.node
```

### FmrbAsterism::Link#app

<pre class="fmrb-sig"><code>app() -&gt; <a href="../String/">String</a></code></pre>

The app's name on the network

```ruby
path = "#{@link.node}/#{@link.app}"
```

### FmrbAsterism::Link#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a></code></pre>

The router's locator

```ruby
r = @link.router
```

### FmrbAsterism::Link#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

Milliseconds the last connect took

```ruby
ms = @link.took_ms
```

### FmrbAsterism::Link#connects

<pre class="fmrb-sig"><code>connects() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times it has connected

```ruby
n = @link.connects
```

### FmrbAsterism::Link#lost

<pre class="fmrb-sig"><code>lost(<a href="../String/">String</a> why) -&gt; void</code></pre>

Give up the connection now (retried after retry_ms)

Closes it, keeps the reason, connects again after retry_ms (and
calls link_down).
```ruby
@link.lost("no answer")
```

### FmrbAsterism::Link#close

<pre class="fmrb-sig"><code>close() -&gt; void</code></pre>

Close for good (on_destroy)

The exposed objects, topics and subscriptions end with it.
```ruby
def on_destroy
  @link.close
end
```

### FmrbAsterism::Link#screen_ready

<pre class="fmrb-sig"><code>screen_ready() -&gt; void</code></pre>

Tell the link the screen is ready

Only needed when Link.new was given screen_wait_ms:.
```ruby
@link.screen_ready
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
