# Asterism::SharedSession

接続のセッションに付くモジュール

使い方は [ネットワーク](../network.md) のページにあります。

connection.session に付いて、接続以外からの close を無視させる。アプリが直接使うことはない。

## インスタンスメソッド

### Asterism::SharedSession#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

接続以外からの close は何もしない

1 回だけ警告を出して nil を返す。閉じるのは Connection#close。
```ruby
conn.session.close  # does nothing
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
