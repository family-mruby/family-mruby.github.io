# FmrbApp

!!! info "工事中"
    このページは整備中です。

## 概要

`FmrbApp` は Family mruby のアプリケーションを記述するための基底クラスです。アプリは `FmrbApp` を継承し、ライフサイクルメソッドを実装することで動作します。

## ライフサイクルメソッド

| メソッド | 呼ばれるタイミング |
|---|---|
| `on_create` | アプリ起動時に1度だけ |
| `on_update` | フレームごと |
| `on_event(ev)` | キーボード・マウス・HID イベント受信時 |
| `on_suspend` | アプリが中断されたとき |
| `on_resume` | 中断後に復帰したとき |
| `on_destroy` | アプリ終了時に1度だけ |

TODO

## ウィンドウ操作

`set_window_position`, `draw_window_frame`, `draw_scrollbar`, `scrollbar_hit` ほか

TODO

## メッセージング

`subscribe(topic)`, `publish(topic, data)`, `send_message`

詳細は [Pub/Sub](pubsub.md) を参照。

## サンプル

TODO
