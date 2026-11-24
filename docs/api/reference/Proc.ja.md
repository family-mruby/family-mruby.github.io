# Proc

## クラスメソッド

### Proc.new

<pre class="fmrb-sig"><code>new() { (untyped argument) -&gt; untyped } -&gt; Proc</code></pre>

手続きを作る

普通は `proc` か `->` で作る。
```ruby
f = Proc.new { |v| v * 2 }
```

## インスタンスメソッド

### Proc#call

<pre class="fmrb-sig"><code>call(*untyped arguments) -&gt; untyped</code></pre>

Proc を呼び出す

`.()` とも書ける。
```ruby
f.call(3)
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
