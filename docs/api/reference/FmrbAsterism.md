# FmrbAsterism

Settings and the link to other machines

How to use it: [Network](../network.md).

The machine's settings (router, node ID) live in
/home/asterism/config.toml; the Link uses them for you.

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`CONFIG_FILE`</span> | [`String`](String.md) | The settings file ("/home/asterism/config.toml") |
| <span class="fmrb-name">`DIR`</span> | [`String`](String.md) | The directory of the settings and credentials |
| <span class="fmrb-name">`DEFAULT_ROUTER`</span> | [`String`](String.md) | The router used when none is set ("tcp/zenohd:7447", the sim's) |
| <span class="fmrb-name">`SYSTEM_CONF`</span> | [`String`](String.md) | The machine's settings file ("/etc/system_conf.toml") |

## Class methods

### FmrbAsterism.host

<pre class="fmrb-sig"><code>host() -&gt; <a href="../String/">String</a></code></pre>

This machine's kind ("sim", "p4nano", ...)

```ruby
kind = FmrbAsterism.host
```

### FmrbAsterism.settings

<pre class="fmrb-sig"><code>settings() -&gt; <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a></code></pre>

How this machine connects (resolved settings)

Never raises; a bad setting puts its reason in error. The Link
reads it itself, so call it only to show it.
```ruby
st = FmrbAsterism.settings
puts "#{st.node} via #{st.router}"
```

### FmrbAsterism.config

<pre class="fmrb-sig"><code>config() -&gt; <a href="../Hash/">Hash</a></code></pre>

What config.toml says (router, node, name)

Only the String entries of `{"router" => ..., "node" => ..., "name" => ...}`
that the file has; {} without it.
**Without the file, the files from before config.toml (zenoh_echo.txt and others) are copied into it first**
(the old files stay). A file that is not TOML gives {} and a log line.
```ruby
c = FmrbAsterism.config
router = c["router"]
```

### FmrbAsterism.read_config

<pre class="fmrb-sig"><code>read_config() -&gt; <a href="../Hash/">Hash</a></code></pre>

Read config.toml (without the old-file copy of config)

The same Hash as config; {} when the file is missing or is not TOML.
It does not copy the old files.
```ruby
c = FmrbAsterism.read_config
```

### FmrbAsterism.write_config

<pre class="fmrb-sig"><code>write_config(<a href="../Hash/">Hash</a> c) -&gt; nil</code></pre>

Write config.toml from a Hash

Writes only the "router", "node" and "name" that c has.
**It replaces the whole file**, so keep the entries you want in c (read with config,
change, pass back). Makes the directory when it is missing. Returns nil.
```ruby
c = FmrbAsterism.config
c["router"] = "tcp/192.0.2.2:7447"
FmrbAsterism.write_config(c)
```

### FmrbAsterism.saved_name

<pre class="fmrb-sig"><code>saved_name() -&gt; <a href="../String/">String</a></code></pre>

The saved display name ("" when none)

The name in config.toml. "" when there is none or it cannot be read.
```ruby
n = FmrbAsterism.saved_name
```

### FmrbAsterism.save_name

<pre class="fmrb-sig"><code>save_name(<a href="../String/">String</a>? name) -&gt; <a href="../Hash/">Hash</a></code></pre>

Save the display name and use it now

Trims it, writes it as name in config.toml and sets it in this
program's profile defaults (Asterism.profile_defaults); nil or ""
removes it. A connected app puts the change on the network. Returns the
profile Hash. A name the profile does not take (over 64 bytes) raises
ArgumentError and the file is left as it was.
```ruby
FmrbAsterism.save_name("Rover")
```

### FmrbAsterism.hostname

<pre class="fmrb-sig"><code>hostname() -&gt; <a href="../String/">String</a></code></pre>

The machine's mDNS host name ("" without WiFi)

Read from the WiFi info; "" on a machine without WiFi or when it
cannot be read.
```ruby
h = FmrbAsterism.hostname
```

### FmrbAsterism.system_conf

<pre class="fmrb-sig"><code>system_conf(<a href="../String/">String</a> key) -&gt; <a href="../String/">String</a></code></pre>

A top-level String of /etc/system_conf.toml ("" if none)

The value of key, trimmed. "" when the file or the key is missing or
the value is not a String.
```ruby
r = FmrbAsterism.system_conf(
  "zenoh_router")
```

### FmrbAsterism.tls?

<pre class="fmrb-sig"><code>tls?(<a href="../String/">String</a>? locator) -&gt; bool</code></pre>

Whether a locator asks for TLS (starts with "tls/")

```ruby
FmrbAsterism.tls?(
  "tls/router.example.org:7447")
#=> true
```

### FmrbAsterism.credentials_path

<pre class="fmrb-sig"><code>credentials_path() -&gt; <a href="../String/">String</a>?</code></pre>

The path of the credentials .tar in /home/asterism (nil if none)

The first .tar by name; it logs a line when there is more than one.
nil also when the directory cannot be read.
```ruby
path = FmrbAsterism.credentials_path
```

### FmrbAsterism.credentials_for

<pre class="fmrb-sig"><code>credentials_for(<a href="../String/">String</a> locator) -&gt; <a href="../Asterism__Credentials/">Asterism::Credentials</a>?</code></pre>

Load the credentials for a tls/ router

nil unless the locator starts with "tls/". Raises Asterism::Error when
it does and there is no .tar or it cannot be read. The certificate's
name is the node ID the router's access control knows.
```ruby
c = FmrbAsterism.credentials_for(
  "tls/router.example.org:7447")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
