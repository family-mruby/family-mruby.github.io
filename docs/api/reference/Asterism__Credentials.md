# Asterism::Credentials

The credentials .tar a console hands out

How to use it: [Network](../network.md).

The .tar an Asterism console hands out with a certificate (private
key, certificate, CA, asterism.json), read. Pass it to
`Asterism.connect(credentials: ...)` for a TLS router: the certificates
go to Zenoh and the router and node ID default to what it holds. On a
machine FmrbAsterism.credentials_for and FmrbAsterism.settings.credentials
return one already read, so an app rarely reads it itself. A file that
cannot be read or has the wrong shape raises Asterism::Credentials::Error.

## Class methods

### Asterism::Credentials.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path, ?warn: bool) -&gt; Asterism::Credentials</code></pre>

Read a credentials .tar

Reads the .tar at path (nothing over 1 MB). `warn:` (true when left
out) is the check of who may read the key file on CRuby; it does
nothing on a machine. Raises Asterism::Credentials::Error when it
cannot be read, has no key or certificate, or has two keys.
```ruby
c = Asterism::Credentials.load(
  "/home/asterism/n.tar")
```

### Asterism::Credentials.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path, ?warn: bool) -&gt; Asterism::Credentials</code></pre>

Read a credentials .tar (same as load)

```ruby
c = Asterism::Credentials.new(
  "/home/asterism/n.tar")
```

## Instance methods

### Asterism::Credentials#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

The path it was read from

```ruby
p = creds.path
```

### Asterism::Credentials#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The node name the certificate is for

The router's access control knows the machine by this name. It is the
default node: of a connection.
```ruby
me = creds.name
```

### Asterism::Credentials#kind

<pre class="fmrb-sig"><code>kind() -&gt; <a href="../String/">String</a>?</code></pre>

The kind asterism.json says (nil when it says none)

```ruby
k = creds.kind
```

### Asterism::Credentials#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a>?</code></pre>

The router's locator in asterism.json (nil when none)

Shaped "tls/host:port". It is the default locator of a connection.
```ruby
r = creds.router
```

### Asterism::Credentials#not_after

<pre class="fmrb-sig"><code>not_after() -&gt; <a href="../String/">String</a>?</code></pre>

The expiry asterism.json says (nil when none)

The string as asterism.json has it.
```ruby
s = creds.not_after
```

### Asterism::Credentials#key_pem

<pre class="fmrb-sig"><code>key_pem() -&gt; <a href="../String/">String</a></code></pre>

The private key (PEM text)

Never show it or log it.
```ruby
pem = creds.key_pem
```

### Asterism::Credentials#cert_pem

<pre class="fmrb-sig"><code>cert_pem() -&gt; <a href="../String/">String</a></code></pre>

The certificate (PEM text)

```ruby
pem = creds.cert_pem
```

### Asterism::Credentials#ca_pem

<pre class="fmrb-sig"><code>ca_pem() -&gt; <a href="../String/">String</a></code></pre>

The CA certificate (PEM text)

```ruby
pem = creds.ca_pem
```

### Asterism::Credentials#info

<pre class="fmrb-sig"><code>info() -&gt; <a href="../Hash/">Hash</a></code></pre>

What asterism.json says (a Hash; {} without it)

Strings such as name, kind, router and not_after.
```ruby
n = creds.info["name"]
```

### Asterism::Credentials#zenoh_config

<pre class="fmrb-sig"><code>zenoh_config() -&gt; <a href="../Hash/">Hash</a></code></pre>

The Zenoh configuration keys for mutual TLS

A Hash with the CA, certificate and key as base64 under
`transport/link/tls/...` and enable_mtls. Asterism.connect uses it
from `credentials:`, so you rarely call it.
```ruby
cfg = creds.zenoh_config
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
