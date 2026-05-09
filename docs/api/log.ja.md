# ログ

`Log` モジュールはアプリケーションからログを出力するための API です。出力されたログはシステムのログバッファに格納され、UART やコンソール（接続している場合）にも流れます。

## 出力メソッド

```ruby
Log.error("something failed")
Log.warn("low battery")
Log.info("user clicked")
Log.debug("x=#{x}")
```

短縮形も使えます:

```ruby
Log.e("err")
Log.w("warn")
Log.i("info")
Log.d("debug")
```

### タグ付き出力（2 引数版）

第 1 引数にタグ、第 2 引数にメッセージを渡せます。

```ruby
Log.info("MyApp", "started")
Log.error("Net", "connection refused")
```

| メソッド | シグネチャ |
|---|---|
| `Log.error(msg)` / `Log.error(tag, msg)` | エラー |
| `Log.warn(msg)` / `Log.warn(tag, msg)` | 警告 |
| `Log.info(msg)` / `Log.info(tag, msg)` | 情報 |
| `Log.debug(msg)` / `Log.debug(tag, msg)` | デバッグ |
| `Log.e` / `Log.w` / `Log.i` / `Log.d` | 上記の短縮 |

## レベル定数

| 定数 | 値 |
|---|---|
| `Log::LEVEL_NONE` | 0 |
| `Log::LEVEL_ERROR` | 1 |
| `Log::LEVEL_WARN` | 2 |
| `Log::LEVEL_INFO` | 3 |
| `Log::LEVEL_DEBUG` | 4 |
| `Log::LEVEL_VERBOSE` | 5 |

## レベル制御

```ruby
Log.set_level(Log::LEVEL_INFO)             # 全体を INFO 以上に
Log.set_level_for_tag("MyApp", Log::LEVEL_DEBUG)  # タグ別に上書き
```

| メソッド | 用途 |
|---|---|
| `Log.set_level(level)` | 全体ログレベル設定 |
| `Log.set_level_for_tag(tag, level)` | 特定タグのレベルを上書き |

## バッファ参照

ログはリングバッファに保持されており、後から読み戻すことができます。`Log Viewer` のようなアプリを書くときに使います。

| メソッド | 戻り値 |
|---|---|
| `Log.read_lines(max_lines = nil, level = nil)` | 行配列 |
| `Log.write_pos` | 現在の書き込み位置（連番） |
| `Log.set_buffer_level(level_str)` | バッファに保持するレベル設定 |
| `Log.buffer_level` | バッファレベル取得 |

```ruby
lines = Log.read_lines(20)   # 直近 20 行
lines.each { |line| puts line }
```

## サンプル

```ruby
class MyApp < FmrbApp
  TAG = "MyApp"

  def on_create
    Log.info(TAG, "started, name=#{@name}")
  end

  def on_event(ev)
    super
    Log.debug(TAG, "event=#{ev[:type]}")
  end

  def on_destroy
    Log.info(TAG, "stopped")
  end
end
```

## 注意事項

!!! warning "ログ出力のオーバーヘッド"
    `on_update` のように高頻度で呼ばれる場所での `Log.debug` は CPU・UART 帯域を消費します。本番では `LEVEL_INFO` 以上に絞るのがおすすめです。

!!! note
    `puts` / `print` （Kernel）はコンソール（UART）出力に行きます。長期的には `Log` 経由で書くほうが、レベル制御やタグ付け、バッファ参照が効きます。

## 関連

- C 側からの直接 ESP_LOG 出力は推奨されません（OS マニフェストでは `fmrb_log.h` ラッパー経由）。Ruby 側からは常に `Log` を使ってください。
