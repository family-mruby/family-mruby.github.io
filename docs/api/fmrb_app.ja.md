# FmrbApp

`FmrbApp` は Family mruby のアプリケーション基底クラスです。ユーザーアプリは **必ず `FmrbApp` を継承して** ライフサイクルメソッドを実装します。

## 最小サンプル

```ruby
class MyApp < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello, mruby!", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end

  def on_update
    100  # 100ms 待つ
  end
end

MyApp.new.start
```

`.toml` でウィンドウサイズなどを指定します（[アプリ設定ファイル (.toml)](../file_formats/app_toml.md) 参照）。

## ライフサイクル

| メソッド | 呼び出し条件 | 戻り値の意味 |
|---|---|---|
| `on_create` | アプリ起動時に1回 | 任意（無視される） |
| `on_update` | メインループ内で繰り返し | **次回 `on_update` までの待機ミリ秒**。デフォルト 330ms |
| `on_event(ev)` | キーボード／マウス／ゲームパッド／HID 受信時 | 任意 |
| `on_suspend` | フルスクリーンアプリに切り替えられたとき | 任意 |
| `on_resume` | 中断状態から復帰したとき | 任意 |
| `on_destroy` | アプリ終了時に1回 | 任意 |

```
start
  └─ on_create
       └─ main_loop:
            ├─ on_update  → 戻り値 ms 分 _spin で待機
            ├─ _spin 中に on_event(ev), _handle_system_control(msg) をディスパッチ
            └─ @running が false になるまで繰り返し
  └─ destroy → on_destroy
```

!!! note "`on_update` の戻り値"
    短い値（10〜30ms）にするとフレームレートが上がりますが CPU を消費します。ゲームでは 16〜33ms、静的 UI では 100〜500ms が目安です。

## イベントハンドリング (`on_event(ev)`)

`ev` は Hash で、`ev[:type]` でイベント種別を判定します。

### キーボード

```ruby
def on_event(ev)
  case ev[:type]
  when :key_down
    keycode  = ev[:keycode]    # 文字コード（プラットフォーム依存）
    scancode = ev[:scancode]   # USB HID Usage ID（プラットフォーム共通）
    modifier = ev[:modifier]   # 修飾キービット (下記参照)
    char     = ev[:character]  # 文字（あれば）
    Log.info("key down: #{char.inspect}")
  when :key_up
    # ...
  end
end
```

修飾キービット（`ev[:modifier]`）の構成:

| ビット | 値 | 意味 |
|---|---|---|
| 0 | 0x01 | LSHIFT |
| 1 | 0x02 | RSHIFT |
| 2 | 0x04 | LCTRL |
| 3 | 0x08 | RCTRL |
| 4 | 0x10 | LALT |
| 5 | 0x20 | RALT |

判定ヘルパが用意されています:

```ruby
ev_ctrl?(ev)   # Ctrl が押されている
ev_shift?(ev)  # Shift が押されている
ev_alt?(ev)    # Alt が押されている
```

!!! note
    文字キーを判定するときは **`scancode` を使ってください**。`keycode` はプラットフォーム間で値が変わります（SDL2 はアスキーを返す等）。

!!! tip "`FmrbConst::KEY_*` / `MOD_*` 定数"
    `scancode` の値は USB HID Usage ID なので、生の `0x29` （ESC）等を書く代わりに **`FmrbConst::KEY_ESC`** などの定数が使えます。修飾キーも `FmrbConst::MOD_CTRL` などのマスク定数があります。一覧は [定数 ▸ KEY_* / MOD_*](const.md#入力デバイス-キーボード-key_) を参照。

### マウス

```ruby
when :mouse_down, :mouse_up
  ev[:button]  # 1=左, 2=中, 3=右
  ev[:x]       # ウィンドウ内 X 座標
  ev[:y]       # ウィンドウ内 Y 座標
when :mouse_move
  ev[:x], ev[:y]
```

タイトルバー上のクリック（左クリックでクローズ／右クリックでリロード）は基底クラスが既に処理しているので、サブクラスは `super` を呼ばなくても閉じる動作は機能します。

### ゲームパッド

```ruby
when :gamepad_down, :gamepad_up
  ev[:gamepad_id]  # 0以降
  ev[:button]      # 0..15
when :gamepad_axis
  ev[:gamepad_id]
  ev[:axis]        # 0..5
  ev[:value]       # 軸値
```

!!! tip "`FmrbConst::GP_*` 定数"
    ボタン番号には `FmrbConst::GP_SQUARE` / `GP_CROSS` / `GP_START` 等、軸番号には `GP_AXIS_LX` / `GP_AXIS_LY` などの定数があります。詳細は [定数 ▸ GP_*](const.md#入力デバイス-ゲームパッド-gp_) を参照。

## ウィンドウ操作

| メソッド | 用途 |
|---|---|
| `set_window_position(x, y)` | ウィンドウ位置を変更 |
| `draw_window_frame` | ウィンドウ枠（タイトルバー + 縁）を描画。基底クラスが管理する `GfxBlock` を再利用 |
| `clear_user_area(color = FmrbGfx::BLACK)` | アプリ描画可能領域（タイトルバー・枠を除く）を指定色で塗りつぶす |
| `draw_scrollbar(scroll, total, visible, x=…, y=…, w=…, h=…)` | スクロールバー描画 |
| `scrollbar_hit(click_x, click_y, x=…, y=…, w=…, h=…)` | スクロールバーのヒット判定 (`:up` / `:down` / `nil`) |
| `request_file_select(mode = "open")` | システムのファイル選択ダイアログを呼び出し |
| `request_reload` | スクリプトをリロード（タイトルバー右クリックで自動呼び出しされる） |

!!! tip "`@gfx.clear` の代わりに `clear_user_area`"
    `@gfx.clear(color)` は **キャンバス全体** を塗りつぶすため、タイトルバーや閉じるボタンも消えます。ウィンドウ枠を保ちたい場合は `clear_user_area(color)` を使ってください。

## メッセージング

| メソッド | 用途 |
|---|---|
| `subscribe(topic)` / `unsubscribe(topic)` | トピックの購読 |
| `publish(topic, data=nil)` | トピックへ送信 |
| `send_message(dest_pid, msg_type, data)` | カーネルや特定アプリへの直接送信。`data` は MessagePack で自動シリアライズされる |

詳細と受信ハンドラは [Pub/Sub](pubsub.md) を参照。

## 実行制御

| メソッド | 用途 |
|---|---|
| `start` | `@running = true` にしてイベントループ開始（`on_create` が呼ばれる） |
| `stop` | `@running = false`（次の `_spin` 後に `destroy` へ） |
| `destroy` | カーネルへ exit を通知し、`@gfx.destroy`、`on_destroy`、`_cleanup` |

通常は `MyApp.new.start` だけ書けば足ります。

## 主要インスタンス変数

| 変数 | 内容 |
|---|---|
| `@gfx` | `FmrbGfx` インスタンス（描画 API。headless モードでは `nil`） |
| `@audio` | `FmrbAudio` インスタンス |
| `@name` | アプリの表示名（`.toml` の `app_screen_name`） |
| `@platform` | `:esp32` または `:linux` |
| `@fullscreen` | フルスクリーンならば `true` |
| `@window_width` / `@window_height` | ウィンドウ全体のサイズ |
| `@pos_x` / `@pos_y` | ウィンドウ左上の絶対座標 |
| `@user_area_x0` / `@user_area_y0` / `@user_area_x1` / `@user_area_y1` | **タイトルバーや枠を除いた描画可能領域** の境界 |
| `@user_area_width` / `@user_area_height` | 描画可能領域のサイズ |
| `@running` | アプリが動作中なら `true` |
| `@suspended` | サスペンド中なら `true` |

!!! tip "ウィンドウ枠を侵さない描画"
    タイトルバーがあるウィンドウモードでは、絶対に `@user_area_*` の範囲内で描画してください。`@user_area_x0`, `@user_area_y0` から始めて、幅 `@user_area_width`、高さ `@user_area_height` 内で完結させます。

## ファイル・ディレクトリのパス

`File.open` / `Dir.open` にはルート相対のパス（`/data/foo.txt` など）や SD カードの `/mnt/sd/...` をそのまま渡します。詳細は [ファイル・I/O ▸ ファイル名前空間](filesystem.md#ファイル名前空間) を参照。

## クラスメソッド

| メソッド | 用途 |
|---|---|
| `FmrbApp.ps` | 全プロセスの状態（id, name, state, vm_type, mem_*, stack_water など）の Array of Hash |
| `FmrbApp.config(section)` | アプリの `.toml` から指定セクションを読み出し |
| `FmrbApp.wallclock` | 現在時刻 (`{year, month, day, hour, minute, second}`) |
| `FmrbApp.set_wallclock(year, month, day, hour, minute, second)` | RTC・システム時刻を設定 |
| `FmrbApp.gfx_stats` | 描画統計 `{cmds:, presents:}` |
| `FmrbApp.sys_pool_info` | システムメモリプール情報 |
| `FmrbApp.heap_info` | ESP-IDF ヒープ情報（`free`, `total`, `min_free`, `largest_block` ほか） |
| `FmrbApp.enable_cursor` | マウスカーソルを表示（最初のマウス移動まで遅延あり） |
| `FmrbApp.set_cursor_visible(visible)` | カーソルの即時表示／非表示。フルスクリーンゲームで非表示にし、終了時に戻す用途 |
| `FmrbApp._get_last_error` | 最後のアプリエラー（あれば `{name:, error:}`） |

## 定数

| 定数 | 値 | 用途 |
|---|---|---|
| `TITLE_BAR_H` | 11 | タイトルバーの高さ (px) |
| `CORNER_R` | 4 | ウィンドウ角の半径 |
| `TRANSPARENT_COLOR` | 0x01 | 透明色（合成時に透過） |
| `SCROLLBAR_W` | 10 | スクロールバー幅 |
| `SCROLLBAR_BTN_H` | 10 | スクロールバーボタン高さ |

## サンプル: ボタンを押されたら数値を増やす

```ruby
class CounterApp < FmrbApp
  def on_create
    @count = 0
    redraw
  end

  def on_event(ev)
    super  # クローズボタン処理を継承
    if ev[:type] == :mouse_down && ev[:button] == 1
      @count += 1
      redraw
    elsif ev[:type] == :key_down && ev[:character] == "r"
      @count = 0
      redraw
    end
  end

  def on_update
    300
  end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Count: #{@count}", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

CounterApp.new.start
```
