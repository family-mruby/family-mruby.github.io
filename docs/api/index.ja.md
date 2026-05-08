# API リファレンス 一覧

!!! info "工事中"
    このページは整備中です。

ここでは Family mruby が提供する全 API の早見表を示します。詳細は各リンク先のページを参照してください。

## アプリケーション

| クラス / モジュール | 主な用途 | 詳細 |
|---|---|---|
| `FmrbApp` | アプリのライフサイクル、ウィンドウ操作 | [FmrbApp](fmrb_app.md) |
| `FmrbGfx` | 図形・テキストの描画 | [FmrbGfx](fmrb_gfx.md) |
| `SpriteImage` / `SpriteInstance` / `GfxBlock` | スプライト・タイルマップ | [Sprite](sprite.md) |
| `FmrbAudio` | BGM・効果音 | [FmrbAudio](audio.md) |
| Pub/Sub | アプリ間メッセージング | [Pub/Sub](pubsub.md) |

## ファイル・データ

| クラス / モジュール | 主な用途 | 詳細 |
|---|---|---|
| `File` / `Dir` / `IO` | ファイル・ディレクトリ操作 | [ファイル・I/O](filesystem.md) |
| `Log` | ロギング | [ログ](log.md) |
| `MessagePack` / `BMP332` / `RX8900` | シリアライズ・画像変換・RTC | [ユーティリティ](utilities.md) |

## ハードウェア・システム

| クラス / モジュール | 主な用途 | 詳細 |
|---|---|---|
| `GPIO` / `I2C` / `RMT` | デジタル入出力・I2C・RMT | [周辺機器](peripherals.md) |
| `FmrbConst` / `FmrbHw` | 定数・ピン状態 | [定数・システム情報](const.md) |
| `Task` / `Machine` | タスク制御・システム | [Task / Machine](system.md) |

## メソッド一覧（横断索引）

TODO
