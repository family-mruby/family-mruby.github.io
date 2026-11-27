# JSON::JSONError

JSON の例外の親

使い方は [ユーティリティ](../utilities.md) のページにあります。

継承元: [`StandardError`](StandardError.md)

`JSON.parse` が `,` や `:` を期待して外したときは、`ParserError` ではなくこの `JSONError` そのもの。
JSON まわりをまとめて受けるなら `rescue JSON::JSONError`。

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
