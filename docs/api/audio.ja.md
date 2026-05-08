# FmrbAudio

!!! info "工事中"
    このページは整備中です。

## 概要

オーディオ再生用の API です。`FmrbApp` 内では `@audio` として参照できます。

!!! note
    対応している音声ファイル形式については [音声ファイルフォーマット](../guide/audio_formats.md) を参照してください。

## 再生

| メソッド | 用途 |
|---|---|
| `play(path, track:)` | ファイル再生 |
| `stop` | 停止 |
| `pause` / `resume` | 一時停止 / 再開 |
| `load_fmsq` | FMSQ シーケンスデータの読み込み |
| `play_slot` | スロット指定再生 |
| `note_on(...)` / `note_off(...)` | ノート単位の制御 |

TODO

## サンプル

TODO
