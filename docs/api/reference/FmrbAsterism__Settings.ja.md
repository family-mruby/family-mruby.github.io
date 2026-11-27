# FmrbAsterism::Settings

つなぎ方の設定

使い方は [ネットワーク](../network.md) のページにあります。

FmrbAsterism.settings の答え。

## インスタンスメソッド

### FmrbAsterism::Settings#router

<pre class="fmrb-sig"><code>router() -&gt; <a href="../String/">String</a></code></pre>

ルータの場所

```ruby
r = FmrbAsterism.settings.router
```

### FmrbAsterism::Settings#node

<pre class="fmrb-sig"><code>node() -&gt; <a href="../String/">String</a></code></pre>

この端末の名前 (ノード ID)

ほかの端末はこの名前で、こちらのオブジェクトを呼ぶ。
```ruby
me = FmrbAsterism.settings.node
```

### FmrbAsterism::Settings#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

持ち主が付けた表示の名前

```ruby
n = FmrbAsterism.settings.name
```

### FmrbAsterism::Settings#error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

設定がおかしい理由

```ruby
err = FmrbAsterism.settings.error
```

### FmrbAsterism::Settings#credentials

<pre class="fmrb-sig"><code>credentials() -&gt; <a href="../Asterism__Credentials/">Asterism::Credentials</a>?</code></pre>

証明書

ルータが tls/ のときだけ読んだ Asterism::Credentials。そうでなければ nil。
```ruby
c = FmrbAsterism.settings.credentials
```

### FmrbAsterism::Settings#zenoh_config

<pre class="fmrb-sig"><code>zenoh_config() -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Zenoh に渡す設定

```ruby
cfg = FmrbAsterism.settings
  .zenoh_config
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
