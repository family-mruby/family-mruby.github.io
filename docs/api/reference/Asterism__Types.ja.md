# Asterism::Types

トピックの値の型の名前と番号

使い方は [ネットワーク](../network.md) のページにあります。

publish の `type:` に渡す組み込みの型。番号か Symbol (:vector3) で書く。自分の型は文字列で、Connection#define_type で決める。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`NUMBER`</span> | [`Integer`](Integer.md) | 数 (Float か Integer) |
| <span class="fmrb-name">`VECTOR3`</span> | [`Integer`](Integer.md) | [x, y, z] |
| <span class="fmrb-name">`POSE`</span> | [`Integer`](Integer.md) | [x, y, z, qx, qy, qz, qw] (ROS 2 の Pose の順) |
| <span class="fmrb-name">`IMAGE`</span> | [`Integer`](Integer.md) | 画像 (符号化に従ったバイト列) |
| <span class="fmrb-name">`STATE`</span> | [`Integer`](Integer.md) | 状態 (String か Integer) |
| <span class="fmrb-name">`LOG`</span> | [`Integer`](Integer.md) | ログの 1 件 (level・msg・time) |
| <span class="fmrb-name">`TEXT`</span> | [`Integer`](Integer.md) | 文字列 |

## クラスメソッド

### Asterism::Types.number

<pre class="fmrb-sig"><code>number(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

組み込みの型の番号

```ruby
Asterism::Types.number(:vector3)  #=> 2
```

### Asterism::Types.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

受けた型の表を整える

名前が String で、"f" が `[[欄, 型], ...]` の定義だけを残す (壊れたものは落とす)。Hash でなければ nil。types_of の答えはこれを通ってくる。
```ruby
t = Asterism::Types.check(raw)
```

---

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
