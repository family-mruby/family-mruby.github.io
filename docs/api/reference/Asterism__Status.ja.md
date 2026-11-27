# Asterism::Status

アプリの状態の決まり

使い方は [ネットワーク](../network.md) のページにあります。

Connection#status が扱う状態 (小さな Hash) の大きさの上限と、受けた状態を整える関数。status_of の答えの形を知るときに読む。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`MAX_BYTES`</span> | [`Integer`](Integer.md) | 状態を詰めた大きさの上限 (バイト) |
| <span class="fmrb-name">`MAX_DEPTH`</span> | [`Integer`](Integer.md) | 入れ子の深さの上限 |

## クラスメソッド

### Asterism::Status.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

受けた状態を整える

空でない String のキーだけを残す。Hash でない、または詰めると
MAX_BYTES を超えるときは nil。status_of の答えはこれを通ってくる。
```ruby
st = Asterism::Status.check(raw)
```

### Asterism::Status.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> key, <a href="../String/">String</a> payload) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

@status への put を読む

key と payload (購読した側が受けるまま) から `[端末, アプリ, 状態]` を返す。そうでなければ nil。
```ruby
n, a, st = Asterism::Status.parse(k, b)
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
