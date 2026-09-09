# アプリ (FmrbApp)

`FmrbApp` は Family mruby のアプリケーション基底クラスです。ユーザーアプリは 必ず `FmrbApp` を継承して ライフサイクルメソッドを実装します。

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
| `on_update` | メインループ内で繰り返し | 次回 `on_update` までの待機ミリ秒。デフォルト 330ms |
| `on_event(ev)` | キーボード／マウス／ゲームパッド／HID 受信時 | 任意 |
| `on_suspend` | フルスクリーンアプリに切り替えられたとき | 任意 |
| `on_resume` | 中断状態から復帰したとき | 任意 |
| `on_resize(w, h)` | 窓の大きさが変わったとき。角のドラッグや全画面の切り替え。`fullscreen?` と描画可能領域は更新済み | 任意 |
| `on_quit_request` | `Ctrl` + `Q` のとき。すぐ閉じる代わりに呼ばれる | 任意 |
| `on_destroy` | アプリ終了時に1回 | 任意 |

```
start
  └─ on_create
       └─ main_loop:
            ├─ on_update  → 戻り値 ms 分 _spin で待機
            ├─ _spin 中に on_event(ev), _handle_system_control(msg) をディスパッチ
            └─ アプリが止まるまで繰り返し (`running?` が false になるまで)
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
    文字キーを判定するときは `scancode` を使ってください。`keycode` はプラットフォーム間で値が変わります（SDL2 はアスキーを返す等）。

!!! tip "`FmrbConst::KEY_*` / `MOD_*` 定数"
    `scancode` の値は USB HID Usage ID なので、生の `0x29` （ESC）等を書く代わりに `FmrbConst::KEY_ESC` などの定数が使えます。修飾キーも `FmrbConst::MOD_CTRL` などのマスク定数があります。一覧は [定数 ▸ KEY_* / MOD_*](const.md#入力デバイス-キーボード-key_) を参照。

### マウス

```ruby
when :mouse_down, :mouse_up
  ev[:button]  # 1=左, 2=中, 3=右
  ev[:x]       # ウィンドウ内 X 座標
  ev[:y]       # ウィンドウ内 Y 座標
when :mouse_move
  ev[:x], ev[:y]
```

タイトルバー上のクリック（左クリックでクローズ／右クリックでリロード）は、アプリの `on_event` が呼ばれる前に基底クラスが処理します。呼ぶものは何もありません。`super` を書かなくても閉じる動作もリロードも効きます。2.0 向けに書いたアプリは `on_event` の先頭で `super(ev)` を呼んでいることが多いですが、2.1 以降それは空のメソッドに届くだけなので、残しても消してもかまいません。

### ホイール

ホイールのイベントは、カーソルの下の窓ではなく、キーボードの入力先になっている窓に届きます。
読み取りは 2 つのどちらかで、ホイール以外のイベントなら `nil` が返るので、そのまま次へ
進めます。

```ruby
rows = wheel_rows(ev)
if rows
  @scroll -= rows
  redraw
end
```

| メソッド | |
|---|---|
| `wheel_rows(ev)` | 段数に本体の `wheel_lines` 設定を掛けたもの。行が文字の行であるものはこちら |
| `wheel_notches(ev)` | 段数そのもの。行が文字の行でない一覧向け。ランチャーの升目は数行分の高さがあり、`wheel_lines` では飛びすぎます |

1 段でどれだけ動くかは本体の設定であって、アプリごとの都合ではありません。

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
| `clear_user_area(color = FmrbConst::THEME_WINDOW_BG)` | アプリ描画可能領域（タイトルバー・枠を除く）を塗りつぶす。既定色はシステムのテーマに従い、この呼び出しで窓枠の描き直しと、付いている部品の再描画指定も行われる |
| `request_fullscreen(on)` / `toggle_fullscreen` | 窓と全画面を切り替える。VM は動いたままなのでアプリの状態は残る。結果は `on_resize` で届き、そのとき `fullscreen?` と描画可能領域は更新済み |
| `request_file_select(mode = "open")` | システムのファイル選択ダイアログを呼び出し |
| `sync_file(path, dest: nil)` | 描画・音声側にあるファイルの複製を、こちらのものと一致させる。違うときだけ転送する。画面を持たないアプリでも使える |
| `request_reload` | スクリプトをリロード（タイトルバー右クリックで自動呼び出しされる） |

スクロールバーは移動しました。`draw_scrollbar` と `scrollbar_hit` は無くなり、部品になって
います。[UI 部品](ui.md) を参照してください。

!!! tip "`@gfx.clear` の代わりに `clear_user_area`"
    `@gfx.clear(color)` は キャンバス全体 を塗りつぶすため、タイトルバーや閉じるボタンも消えます。ウィンドウ枠を保ちたい場合は `clear_user_area(color)` を使ってください。

## メッセージング

| メソッド | 用途 |
|---|---|
| `subscribe(topic)` / `unsubscribe(topic)` | トピックの購読 |
| `publish(topic, data=nil)` | トピックへ送信 |
| `send_message(dest_pid, msg_type, data)` | カーネルや特定アプリへの直接送信。`data` は MessagePack で自動シリアライズされる |

詳細と受信ハンドラは [Pub/Sub](pubsub.md) を参照。

## タイマ

| メソッド | |
|---|---|
| `set_timer(interval) { ... }` | `interval` ミリ秒後にブロックを 1 回実行します。id を返します |
| `clear_time(id)` | まだ発火していないものを取り消します |

タイマは 1 回限りです。繰り返したいときは、ブロックの中で次を張り直します。確認はアプリの
ループ 1 周につき 1 回なので、細かさは `on_update` の戻り値で決まります。

## 別のアプリを起動する

`request_run(path, prev_pid = nil)` はカーネルにファイルの起動を頼みます。前の要求で
起動したものがあれば、その pid を渡して先に止められます。結果は新しい pid を載せた
アプリ制御メッセージとして届きます (失敗なら `nil`)。渡せるのは `/app` と `/home` の下だけです。

## キャンバスを増やす

`create_canvas_gfx(width:, height:, z_offset: 1, transparent: false, transparent_color: 0)`
は、アプリ自身が持つキャンバスに結びついた `FmrbGfx` を返します。`delete_canvas_gfx(gfx)`
で解放します (アプリが終わるとき、落ちたときにも自動で解放されます)。位置を決めて出すのは
`gfx.present(x, y)` で、[`set_viewport`](fmrb_gfx.md#ハードウェアスクロール-modern-のみ) と
組み合わせるとハードウェアでスクロールする層になります。

これは全画面のアプリ向けです。窓の管理は、焦点が移ったときに増やしたキャンバスまでは
面倒を見ません。

## 暇なときに GC を進める

`self.idle_gc = true` にすると、回収を細かく分けて、アプリが何もしていない時間に少しずつ
進めます。途中で 100〜200 ミリ秒止まるのを避けたいアプリ — 演奏やアニメーション — で、かつ
確保を無くしきれないときのためのものです。

代償が 2 つあります。世代別モードが切れて自動では戻らないことと、1 回の刻みの分だけ
メッセージが遅れうることです。ずっと忙しいアプリは、放っておいても元の挙動に戻ります。

## 実行制御

| メソッド | 用途 |
|---|---|
| `start` | イベントループ開始（`on_create` が呼ばれる）。ここから `running?` は true |
| `stop` | 終わらせる。`running?` が false になり、次の `_spin` の後 `destroy` へ |
| `destroy` | カーネルへ exit を通知し、`@gfx.destroy`、`on_destroy`、`_cleanup` |

| `on_quit_request` | `Ctrl` + `Q` のときに、すぐ終了する代わりに呼ばれる。既定は終了。保存していないものがあるなら、上書きして先に尋ねる |
| `request_early_update` | 今の待ちをすぐ終える。アプリが指定した待ち時間を待たずに `on_update` へ進む |

通常は `MyApp.new.start` だけ書けば足ります。

`request_early_update` があるおかげで、暇なアプリは長く眠れます。抜ける手立てが無いと
「次の期限まで眠る」は、後から急ぎで頼まれるかもしれない用事に合わせて短く刻むしかなく、
それは名前を変えた定期確認です。意味があるのはコールバックの中 (`on_control`、`on_event`)
だけで、`on_update` からでは次の待ち時間がどのみち計算し直されます。

## テーマの色を使う

数値を 1 つも書かずにシステムの色を取れる読み取りが 5 つあります。これを使えば、本体の
テーマと利用者の[配色の上書き](../file_formats/colors.md)に自動的に従います。

| メソッド | 役割 |
|---|---|
| `theme_bg` | 地の色 |
| `theme_fg` | `theme_bg` の上に乗る文字の色 |
| `theme_accent` | 選択、強調 |
| `theme_border` | 罫線、囲み、控えめな文字 |
| `theme_fg_light` | 強調色やボタンの上に乗る文字の色 |

## アプリから読めるもの

| | 内容 |
|---|---|
| `@gfx` (`gfx` でも可) | `FmrbGfx` インスタンス（描画 API。headless モードでは `nil`） |
| `name` | アプリの表示名（`.toml` の `app_screen_name`） |
| `platform` | `:esp32` または `:linux` |
| `running?` | アプリが動作中なら `true` |
| `fullscreen?` | フルスクリーンならば `true` |
| `closable?` | クローズボタンでアプリを止めてよいか。画面を占有するアプリは `closable = false` で切れます |
| `rounded_corners?` | この窓の角が丸いかどうか。枠を自分で描くアプリ向け |
| `@window_width` / `@window_height` | ウィンドウ全体のサイズ |
| `@pos_x` / `@pos_y` | ウィンドウ左上の絶対座標 |
| `@user_area_x0` / `@user_area_y0` / `@user_area_x1` / `@user_area_y1` | タイトルバーや枠を除いた描画可能領域 の境界 |
| `@user_area_width` / `@user_area_height` | 描画可能領域のサイズ |

!!! note "`@_` で始まる名前は基底クラスのものです"
    2.1 から、基底クラスは自分の状態を `@_` 付きの変数に持ちます。`@_` で始まらない変数は
    アプリのものだと考えてかまいません。とくに困っていたのが `@running` と `@name` で、
    アプリが自分の `@running` を置くと黙って終了していました。今は `running?` と `name` で
    読みます。

    音源はここには入りません。アプリが `FmrbAudio.new(self)` で自分の分を作ります。

!!! tip "ウィンドウ枠を侵さない描画"
    タイトルバーがあるウィンドウモードでは、絶対に `@user_area_*` の範囲内で描画してください。`@user_area_x0`, `@user_area_y0` から始めて、幅 `@user_area_width`、高さ `@user_area_height` 内で完結させます。

## ファイル・ディレクトリのパス

`File.open` / `Dir.open` にはルート相対のパス（`/home/foo.txt` など）や SD カードの `/mnt/sd/...` をそのまま渡します。詳細は [ファイル・I/O ▸ ファイル名前空間](filesystem.md#ファイル名前空間) を参照。

## クラスメソッド

| メソッド | 用途 |
|---|---|
| `FmrbApp.language` | 利用者が選んだ表示言語。`"en"` か `"ja"` |
| `FmrbApp.ps` | 全プロセスの状態（id, name, state, vm_type, mem_*, stack_water など）の Array of Hash |
| `FmrbApp.config(section)` | アプリの `.toml` から指定セクションを読み出し |
| `FmrbApp.wallclock` | 現在時刻 (`{year, month, day, hour, minute, second}`) |
| `FmrbApp.set_wallclock(year, month, day, hour, minute, second)` | RTC・システム時刻を設定 |
| `FmrbApp.gfx_stats` | 描画統計 `{cmds:, presents:}` |
| `FmrbApp.sys_pool_info` | システムメモリプール情報 |
| `FmrbApp.pool_used` | 自分のプールを何バイト使ったか。読めないときは `-1`。処理の前後で引き算すると、その処理が出したごみの量が分かります |
| `FmrbApp.heap_info` | ESP-IDF ヒープ情報（`free`, `total`, `min_free`, `largest_block` ほか） |
| `FmrbApp.enable_cursor` | マウスカーソルを表示（最初のマウス移動まで遅延あり） |
| `FmrbApp.set_cursor_visible(visible)` | カーソルの即時表示／非表示。フルスクリーンゲームで非表示にし、終了時に戻す用途 |
| `FmrbApp.uptime_us` | 起動からのマイクロ秒 |
| `FmrbApp.wifi_info` / `FmrbApp.wifi_connected?` | つながっているネットワークの情報と、つながっているかどうか |
| `FmrbApp.usb_devices` | USB ホスト端子につながっているもの |
| `FmrbApp.set_kana_mode(mode)` | かな入力の切替。0 ASCII、1 ひらがな、2 カタカナ。結果は `kana_mode` イベントで返ります |
| `FmrbApp.reboot` | 再起動します |
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
