# 定数・システム情報 (FmrbConst / FmrbHw)

!!! info "工事中"
    このページは整備中です。

## FmrbConst

システム全体の定数を提供します。

### プラットフォーム情報

`PLATFORM` (linux / esp32), `OS_VERSION`, `GA_VERSION`, `IDF_VERSION`, `MAC_ADDRESS`, `CHIP_MODEL`, `RESET_REASON`

TODO

### プロセス管理

`PROC_ID_*`, `PROC_STATE_*`

TODO

### メッセージング

`MSG_TYPE_*`

TODO

### テーマ色

`THEME_DESKTOP_BG` ほか

TODO

## FmrbHw

ハードウェアリソース管理。

| メソッド | 用途 |
|---|---|
| `FmrbHw.pin_status(pin)` | 指定ピンの使用状況 |
| `FmrbHw.pin_available?(pin)` | 利用可否判定 |
| `FmrbHw.pin_status_all` | 全ピンの状況 |
| `FmrbHw.pin_count` | ピン数 |

TODO

## サンプル

TODO
