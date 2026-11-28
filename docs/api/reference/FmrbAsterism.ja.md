# FmrbAsterism

ほかの端末とつなぐ設定と Link

使い方は [ネットワーク](../network.md) のページにあります。

設定 (ルータ・端末の名前) は端末の /home/asterism/config.toml にある。アプリが自分で読まなくても、Link が使う。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`CONFIG_FILE`</span> | [`String`](String.md) | 設定ファイル |
| <span class="fmrb-name">`DIR`</span> | [`String`](String.md) | 設定と証明書を置くディレクトリ |
| <span class="fmrb-name">`DEFAULT_ROUTER`</span> | [`String`](String.md) | 何も指定が無いときのルータ |
| <span class="fmrb-name">`SYSTEM_CONF`</span> | [`String`](String.md) | 端末の設定ファイル |

## クラスメソッド

### FmrbAsterism.host

<pre class="fmrb-sig"><code>host() -&gt; <a href="../String/">String</a></code></pre>

この端末の種類の名前

```ruby
kind = FmrbAsterism.host
```

### FmrbAsterism.settings

<pre class="fmrb-sig"><code>settings() -&gt; <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a></code></pre>

この端末のつなぎ方の設定

例外を出さない。設定がおかしいときは error に理由が入る。普通は Link が読むので、アプリが呼ぶのは表示したいときだけ。
```ruby
st = FmrbAsterism.settings
puts "#{st.node} via #{st.router}"
```

### FmrbAsterism.config

<pre class="fmrb-sig"><code>config() -&gt; <a href="../Hash/">Hash</a></code></pre>

config.toml の中身

`{"router" => ..., "node" => ..., "name" => ...}` のうち、ファイルに書いてある文字列の項目だけ。ファイルが無ければ {}。
**ファイルが無いときは、昔のファイル (zenoh_echo.txt など) があれば config.toml に写してから読む**
(昔のファイルは残る)。TOML でないファイルは {} でログに 1 行出る。
```ruby
c = FmrbAsterism.config
router = c["router"]
```

### FmrbAsterism.read_config

<pre class="fmrb-sig"><code>read_config() -&gt; <a href="../Hash/">Hash</a></code></pre>

config.toml だけを読む

config と同じ形の Hash。ファイルが無い・TOML でないと {}。昔のファイルの引っ越しはしない。
```ruby
c = FmrbAsterism.read_config
```

### FmrbAsterism.write_config

<pre class="fmrb-sig"><code>write_config(<a href="../Hash/">Hash</a> c) -&gt; nil</code></pre>

config.toml を書く

c の "router"・"node"・"name" のうち持っているものだけを書く。
**ファイル全体を置き換える**ので、残したい項目も c に入れる (config で読んで直して渡す)。ディレクトリが無ければ作る。nil を返す。
```ruby
c = FmrbAsterism.config
c["router"] = "tcp/192.0.2.2:7447"
FmrbAsterism.write_config(c)
```

### FmrbAsterism.saved_name

<pre class="fmrb-sig"><code>saved_name() -&gt; <a href="../String/">String</a></code></pre>

保存してある名前

config.toml の name。無いか読めなければ ""。
```ruby
n = FmrbAsterism.saved_name
```

### FmrbAsterism.save_name

<pre class="fmrb-sig"><code>save_name(<a href="../String/">String</a>? name) -&gt; <a href="../Hash/">Hash</a></code></pre>

表示の名前を保存する

前後の空白を除いて config.toml の name に書き、このプログラムの名乗りの既定
(Asterism.profile_defaults) にも入れる。nil か "" で消す。接続中なら変更がネットワークに流れる。名乗りの Hash を返す。名乗りが受け付けない名前
(64 バイトを超える) は ArgumentError で、ファイルは変わらない。
```ruby
FmrbAsterism.save_name("Rover")
```

### FmrbAsterism.hostname

<pre class="fmrb-sig"><code>hostname() -&gt; <a href="../String/">String</a></code></pre>

この端末の mDNS の名前

WiFi の情報から読む。WiFi の無い端末・読めないときは ""。
```ruby
h = FmrbAsterism.hostname
```

### FmrbAsterism.system_conf

<pre class="fmrb-sig"><code>system_conf(<a href="../String/">String</a> key) -&gt; <a href="../String/">String</a></code></pre>

端末の設定 (system_conf.toml) の文字列

key の値の前後の空白を除いて返す。ファイルが無い・キーが無い・文字列でないと ""。
```ruby
r = FmrbAsterism.system_conf(
  "zenoh_router")
```

### FmrbAsterism.tls?

<pre class="fmrb-sig"><code>tls?(<a href="../String/">String</a>? locator) -&gt; bool</code></pre>

ルータが TLS を求めているか

```ruby
FmrbAsterism.tls?(
  "tls/router.example.org:7447")
#=> true
```

### FmrbAsterism.credentials_path

<pre class="fmrb-sig"><code>credentials_path() -&gt; <a href="../String/">String</a>?</code></pre>

証明書の .tar の場所

名前順で最初の .tar。2 つ以上あるとログに 1 行出す。ディレクトリが読めなくても nil。
```ruby
path = FmrbAsterism.credentials_path
```

### FmrbAsterism.credentials_for

<pre class="fmrb-sig"><code>credentials_for(<a href="../String/">String</a> locator) -&gt; <a href="../Asterism__Credentials/">Asterism::Credentials</a>?</code></pre>

TLS のルータ用の証明書を読む

locator が "tls/" で始まらなければ nil。始まるのに .tar が無い・読めないと
Asterism::Error。この証明書の名前が、ルータのアクセス制御が知っている端末の名前になる。
```ruby
c = FmrbAsterism.credentials_for(
  "tls/router.example.org:7447")
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
