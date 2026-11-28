# JSON::Digger

大きな JSON から一部だけ取り出す

使い方は [ユーティリティ](../utilities.md) のページにあります。

JSON 全体を読まずに文字列を走査して、`dig` で指した部分だけを切り出す。小さなメモリのためのもので、切り出した部分を `parse` で Ruby の値にする。
```ruby
j = '[{"d": {"name": "Remo"}}]'
JSON::Digger.new(j).dig(0, "d", "name").parse
#=> "Remo"
```

## クラスメソッド

### JSON::Digger.new

<pre class="fmrb-sig"><code>new(<a href="../String/">String</a> json) -&gt; JSON::Digger</code></pre>

掘る JSON を渡して作る

```ruby
d = JSON::Digger.new(text)
```

## インスタンスメソッド

### JSON::Digger#dig

<pre class="fmrb-sig"><code>dig(*<a href="../String/">String</a> | <a href="../Integer/">Integer</a> keys) -&gt; JSON::Digger</code></pre>

キーと位置をたどって、その部分を指す

String は Hash のキー、Integer は Array の位置 (0 から。**負の数は ArgumentError**)。自分 (Digger) を返すので、続けて `dig` や `parse` ができる。
**掘ると、この Digger は切り出した部分だけを持つ**。元には戻れず、続きはその中を掘る。同じ元から別の所を取るなら、新しい Digger を作る。

キーが無いと `JSON::DiggerError` ("Key not found: name")。Hash に位置、Array にキーを使うなど形が合わないと `JSON::JSONError`。String と Integer 以外は ArgumentError。
Array の位置が範囲の外 (空の Array を含む) なら `JSON::DiggerError`
("Array index out of range")。
```ruby
d = JSON::Digger.new('{"a": [10, 20]}')
d.dig("a", 1).parse   #=> 20
```

### JSON::Digger#parse

<pre class="fmrb-sig"><code>parse() -&gt; untyped</code></pre>

今指している部分を Ruby の値にする

```ruby
JSON::Digger.new('[1, 2]').dig(1).parse
#=> 2
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
