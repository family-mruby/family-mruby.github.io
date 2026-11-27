# Asterism::Credentials

コンソールが渡す証明書一式 (.tar)

使い方は [ネットワーク](../network.md) のページにあります。

Asterism のコンソールが証明書を出すときに渡す .tar (秘密鍵・証明書・
CA・asterism.json) を読んだもの。TLS のルータにつなぐときに
`Asterism.connect(credentials: ...)` へ渡すと、証明書が Zenoh に渡り、ルータの場所と端末の名前の既定も入っている値から取られる。端末では FmrbAsterism.credentials_for と FmrbAsterism.settings.credentials
が読んだものを返すので、アプリが自分で読むことはあまり無い。読めない・形が違うときは Asterism::Credentials::Error。

## クラスメソッド

### Asterism::Credentials.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path, ?warn: bool) -&gt; Asterism::Credentials</code></pre>

.tar を読む

path の .tar を読む。1 MB を超えるものは読まない。`warn:` (省略すると true)
は、CRuby で鍵のファイルを他人が読めるかの注意を出すかで、端末では意味が無い。読めない・鍵や証明書が無い・鍵が 2 つある、のとき
Asterism::Credentials::Error。
```ruby
c = Asterism::Credentials.load(
  "/home/asterism/n.tar")
```

### Asterism::Credentials.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> path, ?warn: bool) -&gt; Asterism::Credentials</code></pre>

.tar を読む (load と同じ)

```ruby
c = Asterism::Credentials.new(
  "/home/asterism/n.tar")
```

## インスタンスメソッド

### Asterism::Credentials#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

.tar のパス

```ruby
p = creds.path
```

### Asterism::Credentials#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

端末の名前 (証明書の名前)

ルータのアクセス制御はこの名前で端末を知る。接続の node: の既定になる。
```ruby
me = creds.name
```

### Asterism::Credentials#kind

<pre class="fmrb-sig"><code>kind() -&gt; <a href="../String/">String</a>?</code></pre>

証明書の種類

```ruby
k = creds.kind
```

### Asterism::Credentials#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a>?</code></pre>

ルータの場所

"tls/ホスト:ポート" の形。接続の locator の既定になる。
```ruby
r = creds.router
```

### Asterism::Credentials#not_after

<pre class="fmrb-sig"><code>not_after() -&gt; <a href="../String/">String</a>?</code></pre>

証明書の期限

asterism.json に書かれた文字列のまま。
```ruby
s = creds.not_after
```

### Asterism::Credentials#key_pem

<pre class="fmrb-sig"><code>key_pem() -&gt; <a href="../String/">String</a></code></pre>

秘密鍵 (PEM)

人に見せたりログに出したりしない。
```ruby
pem = creds.key_pem
```

### Asterism::Credentials#cert_pem

<pre class="fmrb-sig"><code>cert_pem() -&gt; <a href="../String/">String</a></code></pre>

証明書 (PEM)

```ruby
pem = creds.cert_pem
```

### Asterism::Credentials#ca_pem

<pre class="fmrb-sig"><code>ca_pem() -&gt; <a href="../String/">String</a></code></pre>

CA の証明書 (PEM)

```ruby
pem = creds.ca_pem
```

### Asterism::Credentials#info

<pre class="fmrb-sig"><code>info() -&gt; <a href="../Hash/">Hash</a></code></pre>

asterism.json の内容

name・kind・router・not_after などの文字列。
```ruby
n = creds.info["name"]
```

### Asterism::Credentials#zenoh_config

<pre class="fmrb-sig"><code>zenoh_config() -&gt; <a href="../Hash/">Hash</a></code></pre>

Zenoh に渡す TLS の設定

CA・証明書・鍵を base64 にして、`transport/link/tls/...` のキーと
enable_mtls を入れた Hash。Asterism.connect が `credentials:` から自分で使うので、普通は呼ばない。
```ruby
cfg = creds.zenoh_config
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
