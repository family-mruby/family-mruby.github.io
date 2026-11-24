# Asterism::Error

やり取りの失敗の元 (rescue ::Asterism::Error で全部受かる)

使い方は [ネットワーク](../network.md) のページにあります。

## インスタンスメソッド

### Asterism::Error#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

失敗の説明

```ruby
rescue ::Asterism::Error => e
  show(e.message)
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
