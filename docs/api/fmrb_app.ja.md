# アプリ (FmrbApp)

`FmrbApp` は Family mruby のアプリケーション基底クラスです。ユーザーアプリは 必ず `FmrbApp` を継承して ライフサイクルメソッドを実装します。

## 最小サンプル

```ruby
class MyApp < FmrbApp
  def on_create
    clear_user_area
    @gfx.draw_text(4, 4, "Hello, mruby!", theme_fg)
    @gfx.present
  end

  def on_update
    100  # 100ms 待つ
  end
end
```

ファイルにはクラスを書くだけです。末尾に起動のコードは要りません。ファイルを読み終えると、
ランタイムがそのファイルで定義された `FmrbApp` の子クラスを作って起動します。1 つのファイルに
子クラスを 2 つ以上書くときは、`.app.toml` (か `#---fmrb` の囲み) に `class = "MyApp"` と書いて
起動するものを名指しします。決まらないときや起動中に例外が出たときは、理由がエラーウィンドウとログに
出ます。

ウィンドウサイズなどは `.app.toml` か、`.rb` 先頭の `#---fmrb` コメントで指定します（[アプリ設定ファイル (.app.toml)](../file_formats/app_toml.md) 参照）。

## ライフサイクル

| メソッド | 呼び出し条件 | 戻り値の意味 |
|---|---|---|
| `on_create` | アプリ起動時に1回 | 任意（無視される） |
| `on_update` | メインループ内で繰り返し | 次回 `on_update` までの待機ミリ秒。デフォルト 330ms |
| `on_event(ev)` | キーボード／マウス／ゲームパッド／HID 受信時 | 任意 |
| `on_suspend` | フルスクリーンアプリに切り替えられたとき | 任意 |
| `on_resume` | 中断状態から復帰したとき | 任意 |
| `on_resize(w, h)` | ウィンドウの大きさが変わったとき。角のドラッグや全画面の切り替え。`fullscreen?` と描画可能領域は更新済み | 任意 |
| `on_quit_request` | `Ctrl` + `Q` のとき。すぐ閉じる代わりに呼ばれる | 任意 |
| `on_checkpoint` / `on_restore` | 運べるアプリがイメージに書かれたとき、イメージから続けるとき (別の端末を含む)。[動いているアプリを運ぶ](#動いているアプリを運ぶ) を参照 | 任意 |
| `on_destroy` | アプリ終了時に1回 | 任意 |

```
(ファイルを読み終えると、ランタイムが子クラスを作って start を呼ぶ)
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
  ev[:x]       # アプリの描画領域の左上からの X (@gfx の 0 と同じ所)
  ev[:y]       # 同じく Y
  ev[:wx]      # ウィンドウの左上 (タイトルバーを含む) からの X
  ev[:wy]      # 同じく Y
when :mouse_move
  ev[:x], ev[:y]
```

`ev[:x]` / `ev[:y]` は `@gfx` と原点が同じなので、描いた位置とクリックの位置が食い違いません。
`ev[:wx]` / `ev[:wy]` は、枠を気にする珍しいアプリ (自前の閉じるボタンなど) のためのものです。

タイトルバー上のクリック（閉じるボタンと、右クリックで出るウィンドウのメニュー: 送る・読み直し・閉じる）は、
アプリの `on_event` が呼ばれる前に基底クラスが処理します。呼ぶものは何もなく、`super(ev)` も書きません。

### ホイール

ホイールのイベントは、カーソルの下のウィンドウではなく、キーボードの入力先になっているウィンドウに届きます。
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
| `clear_user_area(color = FmrbConst::THEME_WINDOW_BG)` | アプリの描画領域（タイトルバー・枠の内側）を塗りつぶす。既定色はシステムのテーマに従い、この呼び出しでウィンドウ枠の描き直しと、付いている部品の再描画指定も行われる |
| `draw_window_frame` | ウィンドウ枠（タイトルバー + 縁）を描き直す。`clear_user_area` が済ませるので、呼ぶのは描画領域の隅に描いたあと (枠の角の丸みが描画領域にかかるため) だけ |
| `window_gfx` | 同じキャンバスに描く 2 つめの `FmrbGfx` で、(0, 0) がウィンドウの左上。描画領域の外 (自前の枠やタイトル) に描くときに使う。書体はキャンバスで共通なので `set_font` は `@gfx` で呼ぶ |
| `request_fullscreen(on)` / `toggle_fullscreen` | ウィンドウと全画面を切り替える。VM は動いたままなのでアプリの状態は残る。結果は `on_resize` で届き、そのとき `fullscreen?` と描画可能領域は更新済み |
| `request_file_select(mode = "open")` | システムのファイル選択ダイアログを呼び出し |
| `sync_file(path, dest: nil)` | 描画・音声側にあるファイルの複製を、こちらのものと一致させる。違うときだけ転送する。画面を持たないアプリでも使える |
| `request_reload` | スクリプトをリロード（ウィンドウのメニューの「読み直し」） |
| `request_window_menu(x, y)` | ウィンドウのメニュー（送る・読み直し・閉じる）をウィンドウ内の位置に出す |

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
| `clear_timer(id)` | まだ発火していないものを取り消します |

タイマは 1 回限りです。繰り返したいときは、ブロックの中で次を張り直します。確認はアプリの
ループ 1 周につき 1 回なので、細かさは `on_update` の戻り値で決まります。

## 別のアプリを起動する

`request_run(path, prev_pid = nil)` はカーネルにファイルの起動をリクエストします。前の要求で
起動したものがあれば、その pid を渡して先に止められます。結果は新しい pid を載せた
アプリ制御メッセージとして届きます (失敗なら `nil`)。渡せるのは `/app` と `/home` の下だけです。

## キャンバスを増やす

`create_canvas_gfx(width:, height:, z_offset: 1, transparent: false, transparent_color: 0)`
は、アプリ自身が持つキャンバスに結びついた `FmrbGfx` を返します。`delete_canvas_gfx(gfx)`
で解放します (アプリが終わるとき、落ちたときにも自動で解放されます)。位置を決めて出すのは
`gfx.present(x, y)` で、[`set_viewport`](fmrb_gfx.md#ハードウェアスクロール-modern-のみ) と
組み合わせるとハードウェアでスクロールする層になります。

これは全画面のアプリ向けです。ウィンドウの管理は、焦点が移ったときに増やしたキャンバスまでは
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
| `start` | イベントループ開始（`on_create` が呼ばれる）。ここから `running?` は true。ファイルを読み終えたあとランタイムが呼ぶので、アプリは呼ばない |
| `stop` | 終わらせる。`running?` が false になり、次の `_spin` の後 `destroy` へ |
| `destroy` | カーネルへ exit を通知し、`@gfx.destroy`、`on_destroy`、`_cleanup` |

| `on_quit_request` | `Ctrl` + `Q` のときに、すぐ終了する代わりに呼ばれる。既定は終了。保存していないものがあるなら、上書きして先に尋ねる |
| `request_early_update` | 今の待ちをすぐ終える。アプリが指定した待ち時間を待たずに `on_update` へ進む |

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

## 設定と、覚えておく状態

アプリが自分でファイルを開かずに持てる、小さな表が 2 つあります。どちらも TOML で、
文字列・整数・`true`/`false` を入れられ、ファイルが無いか壊れているときは `{}` として読めます。

| メソッド | 置き場所 | 用途 |
|---|---|---|
| `app_settings` / `save_app_settings(hash)` | `/home/<app_handle_name>.toml` | 利用者の選択 (名前やレベルなど)。保存は渡したキーの行だけを書き換えるので、利用者が書いたコメントは残ります |
| `app_state` / `save_app_state(hash)` | `/tmp/<app_handle_name>.state.toml` | 次に開いたときに戻る所 (最後に開いたフォルダなど)。本体を再起動するまで残り、値が変わったときだけ書きます |

```ruby
def on_create
  @dir = app_state["dir"] || "/home"
end

def on_destroy
  save_app_state("dir" => @dir)
end
```

`app_handle_name` はアプリのメタデータから、無ければファイル名から決まります。File Manager は
`app_state` を使って、閉じたときのフォルダで開き直します。

## アプリから読めるもの

| | 内容 |
|---|---|
| `@gfx` (`gfx` でも可) | `FmrbGfx` インスタンス（描画 API。headless モードでは `nil`） |
| `name` | アプリの表示名（`.toml` の `app_screen_name`） |
| `platform` | `:esp32` または `:linux` |
| `running?` | アプリが動作中なら `true` |
| `fullscreen?` | フルスクリーンならば `true` |
| `closable?` | クローズボタンでアプリを止めてよいか。画面を占有するアプリは `closable = false` で切れます |
| `rounded_corners?` | このウィンドウの角が丸いかどうか。枠を自分で描くアプリ向け |
| `@window_width` / `@window_height` | ウィンドウ全体のサイズ |
| `@pos_x` / `@pos_y` | ウィンドウ左上の絶対座標 |
| `@user_area_width` / `@user_area_height` | アプリの描画領域（`@gfx` が描く所）のサイズ |
| `frameless?` | `window_frame = "none"` の枠なしウィンドウなら `true` |
| `window_gfx` | ウィンドウの左上を (0, 0) として描く |

!!! note "`@_` で始まる名前は基底クラスのものです"
    2.1 から、基底クラスは自分の状態を `@_` 付きの変数に持ちます。`@_` で始まらない変数は
    アプリのものだと考えてかまいません。とくに困っていたのが `@running` と `@name` で、
    アプリが自分の `@running` を置くと黙って終了していました。今は `running?` と `name` で
    読みます。

    音源はここには入りません。アプリが `FmrbAudio.new(self)` で自分の分を作ります。

!!! tip "(0, 0) はアプリの描画領域の左上"
    `@gfx` は、アプリが描いてよい描画領域の左上から描きます。枠のあるウィンドウでは枠の内側、
    枠なし (`window_frame = "none"`) ではウィンドウの左上、全画面では画面の左上です。どの形でも
    同じコードで描き、幅 `@user_area_width`・高さ `@user_area_height` に収めます。原点は全画面への
    出入り・枠の切り替え・画面の大きさの違う端末への移動で変わりますが、基底が持ち直すので
    `on_resize` では描き直すだけで済みます。スプライト、`set_sprite_clip`、[UI 部品](ui.md) も
    同じ原点です。

## ファイル・ディレクトリのパス

`File.open` / `Dir.open` にはルート相対のパス（`/home/foo.txt` など）や SD カードの `/mnt/sd/...` をそのまま渡します。詳細は [ファイル・I/O ▸ ファイル名前空間](filesystem.md#ファイル名前空間) を参照。

## クラスメソッド

| メソッド | 用途 |
|---|---|
| `FmrbApp.language` | 利用者が選んだ表示言語。`"en"` か `"ja"` |
| `FmrbApp.ps` | 全プロセスの状態（id, name, state, vm_type, mem_*, stack_water など）の Array of Hash |
| `FmrbApp.config(section)` | アプリの `.toml` から指定セクションを読み出し |
| `FmrbApp.wallclock` | 現在時刻 (`{year, month, day, hour, minute, second}`) |
| `FmrbApp.gfx_stats` | 描画統計 `{cmds:, presents:}` |
| `FmrbApp.wasm_stats` / `FmrbApp.wasm_app_stats(pid)` | WebAssembly のランタイムの様子 (`running`、`apps`、`pool_used`、`pool_total`、`traps` など。ランタイムの無い端末では全部 0) と、1 つの [WebAssembly のアプリ](../wasm_apps.md) の様子 (`pages`、`max_pages`、`binary_size`、`hook_us`、`hook_max_us`、`calls`。`pid` が WebAssembly のアプリでなければ `nil`) **(開発版)** |
| `FmrbApp.sys_pool_info` | システムメモリプール情報 |
| `FmrbApp.pool_used` | 自分のプールを何バイト使ったか。読めないときは `-1`。処理の前後で引き算すると、その処理が出したごみの量が分かります |
| `FmrbApp.heap_info` | ESP-IDF ヒープ情報（`free`, `total`, `min_free`, `largest_block` ほか） |
| `FmrbApp.enable_cursor` | マウスカーソルを表示（最初のマウス移動まで遅延あり） |
| `FmrbApp.set_cursor_visible(visible)` | カーソルの即時表示／非表示。フルスクリーンゲームで非表示にし、終了時に戻す用途 |
| `FmrbApp.uptime_us` / `FmrbApp.uptime_ms` | 起動からのマイクロ秒 / ミリ秒 (`uptime_ms` は開発中の版) |
| `FmrbApp.wifi_info` / `FmrbApp.wifi_connected?` | つながっているネットワークの情報と、つながっているかどうか |
| `FmrbApp.usb_devices` | USB ホスト端子につながっているもの |
| `FmrbApp.set_kana_mode(mode)` | かな入力の切替。0 ASCII、1 ひらがな、2 カタカナ。結果は `kana_mode` イベントで返ります |
| `FmrbApp.audio_volume` / `FmrbApp.audio_muted?` | 音量の段と、ミュート中かどうか |
| `FmrbApp.battery_level` / `FmrbApp.battery_charging?` | 電池の残量 (%。電池の無い機種では `nil`) と、充電中かどうか |
| `FmrbApp.clipboard` / `FmrbApp.set_clipboard(text)` | 共有のクリップボード |
| `FmrbApp.app_meta(path)` | アプリファイルの記述 (`.app.toml` と `#---fmrb` を合わせたもの) を文字列の Hash で。アプリでなければ `nil` |
| `FmrbApp.pid` / `FmrbApp.script_path` | 自分のプロセス id と、起動したファイル |
| `FmrbApp.checkpoint(pid)` / `FmrbApp.move(pid, to)` | ほかのアプリをイメージに書く・別の端末へ移すよう頼む (Shell の `checkpoint` / [`amove`](../getting_started/shell.md#端末の間でアプリとファイルを運ぶ)) |
| `FmrbApp._get_last_error` | 最後のアプリエラー（あれば `{name:, error:}`） |

### 本体の設定 (`FmrbSystem`)

本体の設定やサービスを**変える**メソッドは、普通のアプリが使うものと分けて `FmrbSystem` に
あります。デスクトップと設定のアプリのためのものです。

| メソッド | 用途 |
|---|---|
| `FmrbSystem.set_wallclock(year, month, day, hour, minute, second)` | RTC・システム時刻を設定 |
| `FmrbSystem.reboot` | 再起動します |
| `FmrbSystem.power_actions` / `FmrbSystem.power(action)` | この端末でできる電源の操作 (端末では `:reset`、Linux 機では `:power_off`・`:suspend` など) と、その実行 |
| `FmrbSystem.set_audio_mute(on)` / `FmrbSystem.set_audio_volume(step)` | ミュートと音量 |
| `FmrbSystem.wifi_networks(scan)` / `wifi_connect(ssid, password)` / `wifi_disconnect` / `wifi_forget(ssid)` | WiFi の設定 |
| `FmrbSystem.ble_start` / `ble_state` | Bluetooth LE のサービス |

全部 (34 個。Linux 版の設定を含む) は `sig/fmrb_system.rbs` にあります。これらを
`FmrbApp.<名前>` で呼ぶと `NoMethodError` になります。

## 動いているアプリを運ぶ

`.app.toml` に `movable = true` と書いた (mruby で動く) アプリは、イメージに書いて、そこから
続けられます。同じ端末でも、Asterism でつながった別の端末でもかまいません (ウィンドウの
メニューの「送る」、Shell の `checkpoint` / [`amove`](../getting_started/shell.md#端末の間でアプリとファイルを運ぶ))。

| メソッド | 用途 |
|---|---|
| `checkpoint(restart: false)` | 自分を `/tmp/<名前>.ckpt` に書いて閉じるよう頼む。`restart: true` ですぐ起動し直す。頼めたら `nil`、頼めないときは理由の文字列 |
| `move_to(node_id)` | 自分を別の端末へ移すよう頼む |
| `on_checkpoint` | イメージが書けて、ここで閉じる直前に呼ばれる (`on_destroy` は来ない) |
| `on_restore` | イメージから続ける直前に呼ばれる。インスタンス変数・Task・タイマ、ウィンドウと購読は戻っているが、**描いた絵は戻らない**のでここで描き直す。画面の大きさが違う端末へ移ったときは先に `on_resize` が来る |
| `on_checkpoint_refused(reason)` | イメージが書けなかった・移動を断られた。アプリはそのまま続く |

移った先のビルドには、すべての端末に共通でないメソッドが無いことがあります。`respond_to?` で
確認するか、無いと続けられないものを `.app.toml` の `requires = [...]` に書くと、それが無い
ビルドへは移りません。

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
    clear_user_area
    @gfx.draw_text(4, 4, "Count: #{@count}", theme_fg)
    @gfx.present
  end
end
```
