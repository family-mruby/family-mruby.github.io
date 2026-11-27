# FmrbUI::Stepper

数を増減する部品

使い方は [UI 部品](../ui.md) のページにあります。

継承元: [`FmrbUI::Widget`](FmrbUI__Widget.md)

## インスタンスメソッド

### FmrbUI::Stepper#value

<pre class="fmrb-sig"><code>value() -&gt; <a href="../Integer/">Integer</a></code></pre>

今の数

```ruby
n = stepper.value
```

### FmrbUI::Stepper#min

<pre class="fmrb-sig"><code>min() -&gt; <a href="../Integer/">Integer</a></code></pre>

下限

```ruby
lo = stepper.min
```

### FmrbUI::Stepper#max

<pre class="fmrb-sig"><code>max() -&gt; <a href="../Integer/">Integer</a></code></pre>

上限

```ruby
hi = stepper.max
```

### FmrbUI::Stepper#step

<pre class="fmrb-sig"><code>step() -&gt; <a href="../Integer/">Integer</a></code></pre>

一度に増減する幅

```ruby
d = stepper.step
```

### FmrbUI::Stepper#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

出ている文字

```ruby
s = stepper.text
```

### FmrbUI::Stepper#set_value

<pre class="fmrb-sig"><code>set_value(<a href="../Integer/">Integer</a> v) -&gt; bool</code></pre>

数を入れる

min / max で止まります。値が変わったときだけ true を返します。
```ruby
st = @ui.stepper(:size, 4, 26, 108,
                 14, 5, 1, 9)
st.set_value(7)   #=> true
```

### FmrbUI::Stepper#set_range

<pre class="fmrb-sig"><code>set_range(<a href="../Integer/">Integer</a> min, <a href="../Integer/">Integer</a> max) -&gt; void</code></pre>

下限と上限を入れ直す

**今の数は新しい範囲の中へ引き戻されます**。同じ範囲なら何もしません。読み込んだファイルの曲数のように、範囲がデータで決まるときに使います。
```ruby
@track_st.set_range(1, total)
```

### FmrbUI::Stepper#suffix=

<pre class="fmrb-sig"><code>suffix=(<a href="../String/">String</a> s) -&gt; void</code></pre>

数のうしろに付ける単位

作ったあとに 1 回だけ渡します ("%" など)。
```ruby
st.suffix = "%"
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
