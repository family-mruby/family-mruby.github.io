# 制約事項

!!! info "工事中"
    このページは整備中です。

ユーザーがアプリを書くときに踏みやすい制約・差分をここにまとめます。

## メモリ・PSRAM の制約

- VM ごとのスタック制限
- PSRAM 配置時のスタック・DMA 制約
- ヒープ確保サイズの目安

TODO

## picoruby と CRuby の差分

ユーザーが「Ruby と同じはず」と思って踏みやすい差分:

- `File.binread` は存在しない（`File.open(path, "r") { |f| f.read }` を使う）
- 配列要素を含む並列代入 `a[i], a[j] = a[j], a[i]` が壊れる場合あり（一時変数で swap）

TODO

## Task / sleep_ms の注意点

`sleep_ms` は `_spin` の外（独立タスク中）では tick が進まないため停止することがあります。`Machine.delay_ms` を使ってください。

TODO

## ファイルシステムの制限

- 1 ファイルのサイズ上限
- ディレクトリあたりのファイル数
- ファイル名の長さ・使える文字

TODO

## mruby_tick の挙動

TODO
