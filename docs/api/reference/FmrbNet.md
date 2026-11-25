# FmrbNet

Read the network state; fetch

How to use it: [Network](../network.md).

The machine owns the WiFi connection,
so an app **only looks at the state** (`connected?`, `ip_address`, `hostname`, `ssid`).
Fetching is `FmrbNet.request`, written the same way **in the browser build too**.
**The Linux sim, the native build and the browser build always answer "connected"**
**(`127.0.0.1`, `localhost`).**
```ruby
up = FmrbNet.connected?
```

## Class methods

### FmrbNet.connected?

<pre class="fmrb-sig"><code>connected?() -&gt; bool</code></pre>

Whether WiFi is connected

false on a machine without WiFi (ATOM). true on the Linux sim, native and browser builds.
```ruby
draw_offline unless FmrbNet.connected?
```

### FmrbNet.ip_address

<pre class="fmrb-sig"><code>ip_address() -&gt; <a href="../String/">String</a></code></pre>

This machine's IP address

`"0.0.0.0"` when not connected. `"127.0.0.1"` on the Linux sim, native and browser builds.
```ruby
FmrbNet.ip_address   #=> "0.0.0.0" and the like
```

### FmrbNet.hostname

<pre class="fmrb-sig"><code>hostname() -&gt; <a href="../String/">String</a></code></pre>

This machine's host name

An empty string on a machine without WiFi. `"localhost"` on the Linux sim, native and browser builds.
```ruby
FmrbNet.hostname
```

### FmrbNet.ssid

<pre class="fmrb-sig"><code>ssid() -&gt; <a href="../String/">String</a></code></pre>

Name of the WiFi in use

An empty string when nothing is set or there is no WiFi. **Always empty off a real board**
**(Linux sim, native, browser): they have no WiFi.**
```ruby
FmrbNet.ssid
```

### FmrbNet.wait_for_ip

<pre class="fmrb-sig"><code>wait_for_ip(?<a href="../Integer/">Integer</a> timeout_ms) -&gt; bool</code></pre>

Wait until an IP address is assigned

Stops the calling app's task for up to timeout_ms (`timeout_ms` is 10000 when left out; a
negative value is 0). true once an address is there, false on timeout. **Use a short value in an app**
**with a screen.** true at once on the Linux sim, native and browser builds, false at once
on a machine without WiFi.
```ruby
ok = FmrbNet.wait_for_ip(2000)
```

### FmrbNet.request

<pre class="fmrb-sig"><code>request(<a href="../String/">String</a> url) -&gt; <a href="../FmrbNet__Request/">FmrbNet::Request</a></code></pre>

Start fetching a URL

**Returns a `Request`, not the answer** (which is why it is not called get). Read the
result later, once `done?` is true. There is no callback.

**How it waits differs by build.** The browser build fetches in the background, so `done?`
stays false for a while and the screen keeps moving. **A real board, the Linux sim and the**
**native build finish inside `request`, so the app's task stops until the server answers**
(`done?` is true from the start). It is a Net::HTTP GET only, and a failure goes
into `error`, not an exception.
```ruby
@req = FmrbNet.request("https://example.org/a")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@521eb2e7.*
