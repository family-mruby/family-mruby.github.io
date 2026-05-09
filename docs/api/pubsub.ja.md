# Pub/Sub

アプリケーション間でメッセージをやり取りするための Publish / Subscribe 機構です。`FmrbApp` のインスタンスメソッドとして提供されます。

## メソッド

| メソッド | 用途 |
|---|---|
| `subscribe(topic)` | トピックを購読開始 |
| `unsubscribe(topic)` | 購読解除 |
| `publish(topic, data = nil)` | トピックへメッセージを送信。`data` は `Hash` / `Array` / 数値 / `String` / `nil` |
| `send_message(dest_pid, msg_type, data)` | カーネルや特定プロセスへの直接送信（低レベル） |

`data` は内部で **MessagePack** に自動シリアライズされます（最大 176 バイト）。

## 受信ハンドラ

トピックメッセージは `on_event(ev)` ではなく **`on_control(msg)`** で受け取ります。

```ruby
def on_control(msg)
  if msg["cmd"] == "topic_data" && msg["topic"] == "demo"
    payload = msg["data"]   # 送信側が publish に渡した中身
    # ...
  end
end
```

| `msg` のキー | 内容 |
|---|---|
| `"cmd"` | `"topic_data"`（購読中トピックへの publish 受信時） |
| `"topic"` | トピック名 |
| `"data"` | publish 側が渡したペイロード（Hash 等） |

!!! note
    `subscribe`、`publish`、`unsubscribe`、`send_message` の中身は **`send_message(PROC_ID_KERNEL, MSG_TYPE_APP_CONTROL, ...)`** でカーネルにコマンドを送る糖衣です。`on_control` はカーネルからのアプリ制御メッセージ全般を受ける入口で、Pub/Sub もそこを経由します。

## サンプル

### Publisher

```ruby
class PubDemo < FmrbApp
  TOPIC = "demo"

  def on_create
    @count = 0
    redraw
  end

  def on_event(ev)
    super
    if ev[:type] == :mouse_up && ev[:button] == 1
      @count += 1
      publish(TOPIC, {"msg" => "hello", "n" => @count})
      redraw
    end
  end

  def on_update; 100; end

  private

  def redraw
    @gfx.fill_rect(@user_area_x0, @user_area_y0,
                   @user_area_width, @user_area_height, FmrbGfx::BLACK)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Sent: #{@count}", FmrbGfx::WHITE)
    @gfx.present
  end
end

PubDemo.new.start
```

### Subscriber

```ruby
class SubDemo < FmrbApp
  TOPIC = "demo"

  def on_create
    @last = ""
    subscribe(TOPIC)
    redraw
  end

  def on_control(msg)
    if msg["cmd"] == "topic_data" && msg["topic"] == TOPIC
      data = msg["data"]
      @last = "n=#{data["n"]} msg=#{data["msg"]}"
      redraw
    end
  end

  def on_destroy
    unsubscribe(TOPIC)
  end

  def on_update; 100; end

  private

  def redraw
    @gfx.fill_rect(@user_area_x0, @user_area_y0,
                   @user_area_width, @user_area_height, FmrbGfx::BLACK)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4, @last, FmrbGfx::YELLOW)
    @gfx.present
  end
end

SubDemo.new.start
```

`flash/app/demo/pub_demo.app.rb` と `sub_demo.app.rb` が同じ動作をする組のサンプルです。

## トピック設計

トピック名は **任意の文字列**。アプリ同士で取り決めれば動きます。プロジェクトで広く使われる予約名は今のところありません。

推奨される命名規則:

- 小文字英数 + アンダースコア (例: `"sensor_light"`)
- アプリ固有のメッセージは `"<myapp>_<event>"` とプレフィックスする
- 複数アプリで共有する公共トピックはドキュメントしておく

## 制限事項

| 項目 | 値 |
|---|---|
| ペイロード最大サイズ | **176 バイト**（MessagePack 後） |
| `data` に渡せる型 | `Hash`、`Array`、`Integer`、`Float`、`String`、`Boolean`、`nil` |
| 送信タイムアウト | カーネル内部で 5 秒 |

176 バイトを超えるデータを送りたい場合は、ファイルに書いてからファイルパスだけを `publish` する、もしくは複数メッセージに分割します。

## HID イベントとの違い

キーボード／マウス／ゲームパッドの入力は **`on_event(ev)`** に直接届きます（カーネルが `MSG_TYPE_HID_EVENT` でルーティング）。Pub/Sub と混同しないでください。

| 仕組み | 受信ハンドラ | 用途 |
|---|---|---|
| HID 入力 | `on_event(ev)` | ユーザーの物理操作 |
| Pub/Sub | `on_control(msg)` | アプリ間の任意メッセージ |
| 直接 send | `on_control(msg)` | カーネル制御メッセージ全般 |

## 直接送信 (`send_message`)

カーネルや特定アプリにメッセージを送る低レベル API です。`subscribe` などはこれの上に作られています。

```ruby
send_message(FmrbConst::PROC_ID_KERNEL,
             FmrbConst::MSG_TYPE_APP_CONTROL,
             {"cmd" => "subscribe", "topic" => "foo"})
```

- `dest_pid`: 送信先プロセス ID（`FmrbConst::PROC_ID_*`）
- `msg_type`: メッセージタイプ（`MSG_TYPE_APP_CONTROL` 等）
- `data`: 任意の Ruby オブジェクト（自動 MessagePack）
