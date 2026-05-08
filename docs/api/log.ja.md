# ログ

!!! info "工事中"
    このページは整備中です。

## 概要

`Log` モジュールはアプリケーションからのログ出力に使います。

## メソッド

| メソッド | 用途 |
|---|---|
| `Log.error(msg)` / `Log.e(msg)` | ERROR レベル出力 |
| `Log.warn(msg)`  / `Log.w(msg)` | WARN レベル出力 |
| `Log.info(msg)`  / `Log.i(msg)` | INFO レベル出力 |
| `Log.debug(msg)` / `Log.d(msg)` | DEBUG レベル出力 |
| `Log.set_level(level)` | 全体ログレベル設定 |
| `Log.set_level_for_tag(tag, level)` | タグ別ログレベル設定 |
| `Log.read_lines(max_lines, pos)` | ログバッファ読み出し |
| `Log.write_pos` | バッファ書き込み位置 |
| `Log.set_buffer_level(level_str)` | バッファレベル設定 |
| `Log.buffer_level` | バッファレベル取得 |

TODO

## サンプル

TODO
