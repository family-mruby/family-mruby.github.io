# Asterism::Future

待たずに呼んだ呼び出しの答え

使い方は [ネットワーク](../network.md) のページにあります。

これから届く。

## インスタンスメソッド

### Asterism::Future#done?

<pre class="fmrb-sig"><code>done?() -&gt; bool</code></pre>

答えが来たか (待たない)

時間切れ・切れたときも true になる (value が例外を出す)。
```ruby
if @call.done?
  take(@call.value)
end
```

### Asterism::Future#value

<pre class="fmrb-sig"><code>value() -&gt; untyped</code></pre>

答えの値

done? の前に呼ぶと待つ。相手が例外を出したら
Asterism::RemoteError、時間切れは Asterism::TimeoutError。
```ruby
begin
  n = @call.value
rescue ::Asterism::Error => e
  show(e.message)
end
```

### Asterism::Future#took_ms

<pre class="fmrb-sig"><code>took_ms() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

答えまでの時間 (ms)

```ruby
ms = @call.took_ms
```

### Asterism::Future#path

<pre class="fmrb-sig"><code>path() -&gt; <a href="../String/">String</a></code></pre>

呼んだ道

```ruby
p = @call.path
```

### Asterism::Future#method_name

<pre class="fmrb-sig"><code>method_name() -&gt; <a href="../String/">String</a></code></pre>

呼んだメソッドの名前

```ruby
m = @call.method_name
```

### Asterism::Future#took

<pre class="fmrb-sig"><code>took() -&gt; <a href="../Float/">Float</a>?</code></pre>

答えまでの時間 (秒)

```ruby
s = @call.took
```

### Asterism::Future#raw_value

<pre class="fmrb-sig"><code>raw_value() -&gt; untyped</code></pre>

答えをそのまま読む

{"value" => ...} か {"error" => ...} の Hash のまま返す。value と同じに待ち、時間切れは Asterism::TimeoutError、切れたら Asterism::Disconnected、読めない答えは Asterism::Error。普通は value を使う。
```ruby
raw = @call.raw_value
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
