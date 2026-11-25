# JSON

JSON の読み書き

使い方は [ユーティリティ](../utilities.md) のページにあります。

読むのは `JSON.parse`、書くのは `JSON.generate`。大きな JSON から一部だけ取るなら
`JSON::Digger`。**どれも Ruby で書いた小さな実装**で、速さより小ささを優先している。
```ruby
h = JSON.parse('{"a": [1, 2]}')
s = JSON.generate(h)   #=> "{\"a\":[1,2]}"
```

## クラスメソッド

### JSON.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> json) -&gt; untyped</code></pre>

JSON 文字列を Ruby の値にする

`{}` は Hash (**キーは必ず String**)、`[]` は Array、数は Integer か Float、
`true`・`false`・`null` はそのまま (`null` は nil)。

失敗は例外。先頭が値でない・空文字列・閉じていない文字列は `JSON::ParserError`、
`:` や `,` が無いなど構造の崩れは `JSON::JSONError` (親)。**後ろのごみは黙って捨てる**
(JSON の後ろに付いた字) (`"[1,2] xyz"` は `[1, 2]`)。

`\uXXXX` は UTF-8 の文字になる (日本語も、`\ud83d\ude00` のような 2 つ組も)。小数は自前の計算で組み立てるので、末尾の桁が CRuby とずれることがある。全部 Ruby の実装で、大きな JSON を丸ごと読むのは重い。
```ruby
h = JSON.parse('{"temp": 21.5}')
h["temp"]   #=> 21.5
```

### JSON.generate

<pre class="fmrb-sig"><code>generate(untyped obj) -&gt; <a href="../String/">String</a></code></pre>

Ruby の値を JSON 文字列にする

Hash・Array・String・Integer・Float・true・false・nil を書く。**Symbol は文字列**になり、
Hash のキーは `to_s` した文字列になる。**それ以外のオブジェクトも `to_s` した文字列**で書く (エラーにならない)。

空白も改行も入れず 1 行で返す。日本語はそのまま (エスケープしない)。`NaN` や無限大も例外にならず、JSON として正しくない `NaN` などの字がそのまま入る。
```ruby
JSON.generate({ "a" => [1, nil] })
#=> "{\"a\":[1,null]}"
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
