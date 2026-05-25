# 制約事項

## メモリ・PSRAM の制約

Family mruby の各アプリは独立した Ruby VM として動作し、それぞれが PSRAM 上に 独自のヒープとスタック を持ちます。(LuaとBASICは現在はコンセプト実装)

| 項目 | 目安・上限 |
|---|---|
| 標準アプリのヒープ | 500 KB |
| `large_memory = 1` 指定時のヒープ | 1000 KB |
| アプリ同時起動数 | 3 |

ヒープの使用状況はモニターアプリで確認できます。

## PicoRuby と CRuby の差分

PicoRubyはmrubyをベースとしており、CRubyで標準的に使えるメソッドが使えないことがあります。

## Task / sleep の制約

現在は、PicoRubyのタスク切り替えに必要なTick(`mrb_tick`)処理を、mrubyVM外のコンテキストから呼ぶとVMのスタックが破壊される現状があり、暫定的に止めています。そのため以下のような制約があります。

Tick処理については、今後対策予定です。

### `sleep_ms` が止まる場合がある

Kernel の `sleep_ms`（picoruby が提供）は、`_spin` の外（つまり `FmrbApp` のメインループから外れた独立タスク中）で tick が進まず停止する ことがあります。

代わりに `Machine.delay_ms` を利用してください。

```ruby
# NG: 独立タスク内では止まることあり
sleep_ms(500)

# OK: FreeRTOS の vTaskDelay ベース
Machine.delay_ms(500)
```

### Task機能の制約

`on_update` 内では `mrb_tick` を呼んでいるため、`on_update`を高頻度でループさせることでTask機能を動かすことも可能ですが、予期せぬ動作をする可能性があります。
（EditorやShellではTask機能を利用してます）

## ファイルシステムの制限

| 項目 | 内容 |
|---|---|
| 1 ファイルの最大サイズ | LittleFS の制限内（数 MB 程度推奨） |
| パスの最大長 | `FmrbConst::MAX_PATH_LEN` |
| ファイル名 | ASCII 推奨。日本語や記号は避ける |
| `Dir#seek` / `Dir#tell` | 未対応（`ENOSYS`）。`rewind` してから数え直す |

## アプリ間メッセージのサイズ制限

[Pub/Sub](api/pubsub.md) の `publish` / `send_message` のペイロードは MessagePack 後で 176 バイト までです。それを超える場合はファイル経由にする、複数メッセージに分けるなどの工夫が必要です。

