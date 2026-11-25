# Asterism::Error

やり取りの失敗の元

使い方は [ネットワーク](../network.md) のページにあります。

rescue ::Asterism::Error で全部受かる。

## インスタンスメソッド

### Asterism::Error#message

<pre class="fmrb-sig"><code>message() -&gt; <a href="../String/">String</a></code></pre>

失敗の説明

```ruby
rescue ::Asterism::Error => e
  show(e.message)
```

---

*このページは fmruby-core の develop@32b44bcd の API の型定義 (`sig/`) から自動で作っています。*
