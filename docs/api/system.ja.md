# Task / Machine

!!! info "工事中"
    このページは整備中です。

## Task

| メソッド | 用途 |
|---|---|
| `Task.pass` | 制御を他タスクに譲る |
| `Task.sleep(ms)` | 指定ミリ秒スリープ |

TODO

## Machine

| メソッド | 用途 |
|---|---|
| `Machine.delay_ms(ms)` | FreeRTOS の `vTaskDelay` ベースの待機 |
| `Machine.set_hwclock(epoch)` | ハードウェアクロック設定 |
| `Machine.reset` | システムリセット |

!!! warning
    `sleep_ms` は `_spin` の外では tick が進まないため停止することがあります。`Machine.delay_ms` を使ってください（[制約事項](../guide/limitations.md) 参照）。

TODO

## サンプル

TODO
