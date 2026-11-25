# Class

クラス自身を表す。名前を読む

このファイルでは `name` だけを載せている (`obj.class.name`)。クラスを受け手にする
`const_defined?` と `remove_method` は `Module` に、`Object` 向けの写しは `Object` にある。

## インスタンスメソッド

### Class#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

クラス名を文字列で返す

```ruby
obj.class.name
```

---

*このページは fmruby-core の develop@9274e3b8 の API の型定義 (`sig/`) から自動で作っています。*
