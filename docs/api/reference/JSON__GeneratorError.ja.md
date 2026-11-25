# JSON::GeneratorError

JSON.generate の例外 (NaN・無限大)

使い方は [ユーティリティ](../utilities.md) のページにあります。

継承元: [`JSON::JSONError`](JSON__JSONError.md)

`JSON.generate` が Float の NaN・無限大 (入れ子の中も) に出す。文は `"NaN not allowed in JSON"` など。それ以外の書けない値は文字列にして書くので、これは出ない。

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
