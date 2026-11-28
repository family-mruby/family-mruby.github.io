# Proc

ブロックを値にしたもの

ふつうは `proc` か `->` で作り、`call` (または `.()`) で呼ぶ。Spinel では
**外のローカル変数を掴めない**ので、後で呼ぶ Proc に渡す値は引数で渡す。

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

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
