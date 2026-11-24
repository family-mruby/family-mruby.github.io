# FmrbAsterism::Settings

Connection settings

How to use it: [Network](../network.md).

What FmrbAsterism.settings answers.

## Instance methods

### FmrbAsterism::Settings#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a></code></pre>

The router's locator ("tcp/host:7447")

```ruby
r = FmrbAsterism.settings.router
```

### FmrbAsterism::Settings#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a></code></pre>

This machine's node ID

Other machines call this machine's objects by this name.
```ruby
me = FmrbAsterism.settings.node
```

### FmrbAsterism::Settings#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The display name the owner gave ("" for none)

```ruby
n = FmrbAsterism.settings.name
```

### FmrbAsterism::Settings#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

Why the settings are unusable (nil when fine)

```ruby
err = FmrbAsterism.settings.error
```

### FmrbAsterism::Settings#credentials

<pre class="fmrb-sig"><code>credentials() -&gt; <a href="../Asterism__Credentials/">Asterism::Credentials</a>?</code></pre>

The credentials for a TLS router (nil when none)

The Asterism::Credentials, only for a tls/ router; nil otherwise.
```ruby
c = FmrbAsterism.settings.credentials
```

### FmrbAsterism::Settings#zenoh_config

<pre class="fmrb-sig"><code>zenoh_config() -&gt; <a href="../Hash/">Hash</a>?</code></pre>

The Zenoh config for Session.open (TLS keys; nil without credentials)

```ruby
cfg = FmrbAsterism.settings
  .zenoh_config
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
