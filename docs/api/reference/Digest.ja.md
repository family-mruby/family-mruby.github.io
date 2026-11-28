# Digest

ハッシュの入れもの (SHA-256)

入るのはブラウザ版 (wasm) だけ。実機・Linux sim・ネイティブ版では `Digest` が無く、先に `Object.const_defined?(:Digest)` で調べる。

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
