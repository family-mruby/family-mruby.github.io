# 制約事項

ユーザーがアプリを書くときに踏みやすい制約・標準の Ruby との差分・落とし穴をまとめます。アプリが期待通りに動かないときは、まずここを確認してください。

## メモリ・PSRAM の制約

Family mruby の各アプリは独立した Ruby VM として動作し、それぞれが PSRAM 上に **独自のヒープとスタック** を持ちます。

| 項目 | 目安・上限 |
|---|---|
| 標準アプリのヒープ | 数百 KB |
| `large_memory = 1` 指定時のヒープ | より大きく確保（複数 MB） |
| アプリ同時起動数 | メモリ次第。`large_memory` を有効にすると減る |
| メッセージペイロード | 最大 **176 バイト**（MessagePack 後） |

### 大きいデータを扱うとき

- 画像や音声は **ファイルとして** flash / SD に置き、必要時に開く
- アプリ間でやり取りする時は **ファイルパスを `publish`** するか、ファイルに書いてから読む

### 確認方法

```ruby
info = FmrbApp.heap_info
Log.info("free=#{info[:free]} largest_block=#{info[:largest_block]}")
```

`FmrbApp.sys_pool_info` でも全体プールの状況が分かります。

### PSRAM スタックと DMA

PSRAM 上の領域を **DMA に直接渡せない** ハードウェア制約があります（SPI flash や一部周辺機器）。Family mruby はこのため `hw_proxy` という仕組みで内部的に SRAM 経由のバッファを使っていますが、自分で C 拡張を書くときは注意してください。

## picoruby と CRuby の差分

「普通の Ruby と同じはず」と思って踏みやすい差分:

### `File.binread` / `File.read` （クラスメソッド）が無い

picoruby には `File.binread` や `File.read(path)` のショートカットがありません。

```ruby
# NG (例外)
data = File.binread("/img.bmp")

# OK
data = File.open("/img.bmp", "r") { |f| f.read }
```

### 配列要素を含む並列代入

`a[i], a[j] = a[j], a[i]` のような、配列要素を LHS に含む並列代入は picoruby では正しく動作しないことがあります。

```ruby
# 危険：壊れることがある
a[i], a[j] = a[j], a[i]

# 安全：一時変数で swap
tmp = a[i]
a[i] = a[j]
a[j] = tmp
```

### `JSON` ライブラリは未同梱

JSON が必要な場面では [`MessagePack`](api/utilities.md#messagepack) を使ってください。

### `IO` の挙動

- `STDIN` / `STDOUT` の概念は通常使えません（ヘッドレスでない場合は描画 API を使う）
- `Kernel#puts` / `print` はコンソール（UART）に出力されますが、長期的には [`Log`](api/log.md) 経由が推奨

## Task / sleep の落とし穴

### `sleep_ms` が止まる場合がある

Kernel の `sleep_ms`（picoruby が提供）は、`_spin` の外（つまり `FmrbApp` のメインループから外れた独立タスク中）で **tick が進まず停止する** ことがあります。

```ruby
# NG: 独立タスク内では止まることあり
sleep_ms(500)

# OK: FreeRTOS の vTaskDelay ベース
Machine.delay_ms(500)
```

通常の `on_update` 内では `on_update` の **戻り値** で待機時間を指定するのが正攻法です:

```ruby
def on_update
  do_work
  100   # 次回 on_update まで 100ms 待つ
end
```

### `Task.pass` の使い所

長時間ループする場合は `Task.pass` を入れて他タスクに制御を譲ってください。

```ruby
1000.times do |i|
  heavy_compute(i)
  Task.pass if i % 10 == 0
end
```

## ファイルシステムの制限

| 項目 | 内容 |
|---|---|
| 1 ファイルの最大サイズ | LittleFS の制限内（数 MB 程度推奨） |
| パスの最大長 | `FmrbConst::MAX_PATH_LEN` |
| ファイル名 | ASCII 推奨。日本語や記号は避ける |
| `Dir#seek` / `Dir#tell` | **未対応**（`ENOSYS`）。`rewind` してから数え直す |

## mruby tick

`mruby_tick_task` は無効化されており、Ruby タスクは `_spin` ループ内でのみ進行します。

- `on_update` が呼ばれる頻度は `_spin(timeout_ms)` の引数に依存
- 独立タスク（`Thread` 相当）から Ruby コードを動かすと、上記の `sleep_ms` 問題が顕在化

通常の「`FmrbApp` を継承して `on_update` を書く」という使い方をする限り問題はありません。

## グラフィックス系の制約

### `@gfx.present` を呼ばないと表示されない

```ruby
@gfx.fill_rect(...)
@gfx.draw_text(...)
@gfx.present       # これがないと表示されない
```

特にスプライト操作 (`SpriteInstance#move` 等) の後も `present` を呼ぶ必要があります（`present` のタイミングで合成が走る）。

### `GfxBlock` の制約

`GfxBlock` は描画コマンド列を WROVER 側にバイトコードとしてキャッシュする仕組みのため、**ブロック内で命令数を変えてはいけません**。

```ruby
# NG: kwargs によって命令数が変わる
GfxBlock.new(@gfx, n: 5) do |r, n:|
  n.times { r.fill_rect(0, 0, 5, 5, 0xFF) }
end

# OK: 命令数は固定、座標等のみ変動
GfxBlock.new(@gfx, x: 0) do |r, x:|
  r.fill_rect(x, 0, 5, 5, 0xFF)
end
```

詳細は [Sprite ▸ GfxBlock](api/sprite.md#gfxblock) を参照。

## アプリ間メッセージのサイズ制限

[Pub/Sub](api/pubsub.md) の `publish` / `send_message` のペイロードは MessagePack 後で **176 バイト** までです。それを超える場合はファイル経由にする、複数メッセージに分けるなどの工夫が必要です。

## ファイル選択ダイアログの制限

`request_file_select(mode)` は同時に **1 つのアプリ** からしか呼べません。同時に複数のアプリで開こうとするとカーネルが拒否します。

## 関連

- ライフサイクルの詳細 → [FmrbApp](api/fmrb_app.md)
- 適切な待機方法 → [Task / Machine](api/system.md)
- メモリ可視化 → `FmrbApp.heap_info` / `FmrbApp.sys_pool_info` ([FmrbApp](api/fmrb_app.md#クラスメソッド))
