# FmrbApp

使い方は [アプリ](../fmrb_app.md)、[アプリ間通信](../pubsub.md) のページにあります。

## 型

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`wallclock`</span> | `{ year: uint16, month: uint8, day: uint8, hour: uint8, minute: uint8, second: uint8 }` | wallclock が返す日付と時刻 |
| <span class="fmrb-name">`sys_pool_info`</span> | `{ total: uint32, used: uint32, free: uint32, used_blocks: uint32, free_blocks: uint32 }` | sys_pool_info が返す本体のメモリのようす |
| <span class="fmrb-name">`gfx_stats`</span> | `{ cmds: uint32, presents: uint32 }` | gfx_stats が返す絵を送った回数 |
| <span class="fmrb-name">`wasm_stats`</span> | `{ running: uint8, apps: uint8, modules: uint8, natives: uint16, pool_total: uint32, pool_used: uint32, pool_high: uint32, traps: uint32 }` | wasm_stats が返す wasm のランタイムのようす |
| <span class="fmrb-name">`wasm_app_stats`</span> | `{ pages: uint32, max_pages: uint32, binary_size: uint32, hook_us: uint32, hook_max_us: uint32, calls: uint32 }` | wasm_app_stats が返す wasm のアプリのようす |
| <span class="fmrb-name">`event`</span> | `{ type: :key_down \| :key_up \| :mouse_down \| :mouse_up \| :mouse_move \| :mouse_wheel \| :gamepad_down \| :gamepad_up \| :gamepad_axis \| :kana_mode, x: int32, y: int32, wx: int32, wy: int32, button: int32, keycode: int32, scancode: int32, modifier: int32, character: int32, delta: int32, gamepad_id: int32, axis: int32, value: int32, mode: int32 }` | on_event に来る入力 |

## クラスメソッド

### FmrbApp.language

<pre class="fmrb-sig"><code>language() -&gt; <a href="../String/">String</a></code></pre>

今の言葉 ("ja" か "en")

```ruby
if FmrbApp.language == "ja"
```

### FmrbApp.clipboard

<pre class="fmrb-sig"><code>clipboard() -&gt; <a href="../String/">String</a></code></pre>

クリップボードの文字

どのアプリとも同じ 1 つのクリップボード。空なら `""`。
PC とブラウザ版では、そちらでコピーした文字も入る。
`FmrbApp.clipboard(100)` のように数を渡すと、そのバイト数までを、文字の途中で切らずに返す。
```ruby
text = FmrbApp.clipboard
```

### FmrbApp.clipboard_raw

<pre class="fmrb-sig"><code>clipboard_raw(<a href="../Integer/">Integer</a> limit) -&gt; <a href="../String/">String</a></code></pre>

clipboard の省略なしの形

引数を省略できない単純な形。limit が 0 なら全部、正なら そのバイト数までを、文字の途中で切らずに返す。包みは clipboard (limit を省くと 0)。
```ruby
text = FmrbApp.clipboard_raw(0)
```

### FmrbApp.set_clipboard

<pre class="fmrb-sig"><code>set_clipboard(<a href="../String/">String</a> text) -&gt; bool</code></pre>

クリップボードに文字を入れる

64 KB より大きいと入れずに false を返す。
```ruby
FmrbApp.set_clipboard("hello")
```

### FmrbApp.clipboard_gen

<pre class="fmrb-sig"><code>clipboard_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

クリップボードが変わった回数

文字を読まずに、変わったかどうかを知るのに使う。
```ruby
g = FmrbApp.clipboard_gen
```

### FmrbApp.notify

<pre class="fmrb-sig"><code>notify(<a href="../String/">String</a> summary, <a href="../String/">String</a> body) -&gt; bool</code></pre>

画面の右上に小さな知らせを出す

数秒で消える。上にアプリの名前、その下に文と本文
(2 行まで)。知らせを出せるのは PC だけで、ほかの端末では何も出さずに false を返す。
```ruby
FmrbApp.notify("Saved", "/home/a.txt")
```

### FmrbApp.notify_raw

<pre class="fmrb-sig"><code>notify_raw(<a href="../String/">String</a> summary, <a href="../String/">String</a> body) -&gt; bool</code></pre>

notify の省略なしの形

引数を省略できない単純な形。包みは notify (body を省くと "")。
```ruby
FmrbApp.notify_raw("Saved", "")
```

### FmrbApp.ps

<pre class="fmrb-sig"><code>ps() -&gt; <a href="../Array/">Array</a></code></pre>

動いているアプリの一覧

動いているアプリの一覧。1 つずつが名前と pid を持つ Hash。
```ruby
FmrbApp.ps.each do |a|
  Log.info("#{a[:pid]} #{a[:name]}")
end
```

### FmrbApp.ps_gen

<pre class="fmrb-sig"><code>ps_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

アプリ一覧が変わった回数

一覧が変わるたびに増える番号。**これが変わったときだけ `ps` を呼べば**、毎フレーム一覧を作らずに済む。
```ruby
gen = FmrbApp.ps_gen
list = FmrbApp.ps if gen != @gen
```

### FmrbApp.checkpoint

<pre class="fmrb-sig"><code>checkpoint(<a href="../Integer/">Integer</a> pid) -&gt; <a href="../String/">String</a>?</code></pre>

別のアプリをイメージに書いて閉じる

pid のアプリを止めてイメージに書き、閉じるよう頼みます (Shell の
`checkpoint`)。`restart: true` ならすぐに起動し直します。頼めたら nil、頼めないときは理由の文字列。答えは後から `on_control` に
`{"cmd" => "checkpoint_result", "pid", "ok", "path" か "reason"}`
で届きます。
```ruby
FmrbApp.checkpoint(5,
                   restart: true)
```

### FmrbApp.move

<pre class="fmrb-sig"><code>move(<a href="../Integer/">Integer</a> pid, <a href="../String/">String</a> to) -&gt; <a href="../String/">String</a>?</code></pre>

別のアプリを別の端末へ移す

pid のアプリを Asterism の端末 `to` (ノード ID) へ移すよう頼みます
(Shell の `move`)。頼めたら nil、頼めないときは理由の文字列。答えは後から
`on_control` に `{"cmd" => "checkpoint_result", "pid", "ok", "to",
"there" と "missing" か "reason"}` で届きます。
```ruby
FmrbApp.move(5, "fmruby-abcdef")
```

### FmrbApp.heap_info

<pre class="fmrb-sig"><code>heap_info() -&gt; <a href="../Hash/">Hash</a></code></pre>

空きメモリの様子

```ruby
h = FmrbApp.heap_info
Log.info("#{h[:free]} free")
```

### FmrbApp.pool_usage

<pre class="fmrb-sig"><code>pool_usage() -&gt; <a href="../Integer/">Integer</a></code></pre>

自分のメモリの使用率 (百分率)

```ruby
pct = FmrbApp.pool_usage
```

### FmrbApp.pool_used

<pre class="fmrb-sig"><code>pool_used() -&gt; <a href="../Integer/">Integer</a></code></pre>

自分のメモリの使用量 (バイト)

使えないときは -1。**百分率では粗すぎるとき**に使う (デスクトップの
1536KB のプールでは 1% が 15KB)。前後で引き算すれば、その処理が出したごみの量が分かる。
```ruby
before = FmrbApp.pool_used
scan_everything
kb = (FmrbApp.pool_used - before) / 1024
```

### FmrbApp.sys_pool_info

<pre class="fmrb-sig"><code>sys_pool_info() -&gt; sys_pool_info</code></pre>

機械全体のメモリの様子

```ruby
i = FmrbApp.sys_pool_info
```

### FmrbApp.config

<pre class="fmrb-sig"><code>config(<a href="../String/">String</a> section_name) -&gt; <a href="../Array/">Array</a>?</code></pre>

設定ファイルの中身を読む

`system_conf.toml` の節を読む。無ければ nil。
```ruby
rows = FmrbApp.config("theme")
```

### FmrbApp.uptime_us

<pre class="fmrb-sig"><code>uptime_us() -&gt; int64</code></pre>

電源を入れてからの時間 (百万分の一秒)

```ruby
t0 = FmrbApp.uptime_us
work
us = FmrbApp.uptime_us - t0
```

### FmrbApp.uptime_ms

<pre class="fmrb-sig"><code>uptime_ms() -&gt; int64</code></pre>

電源を入れてからの時間 (ミリ秒)

```ruby
t0 = FmrbApp.uptime_ms
```

### FmrbApp.wallclock

<pre class="fmrb-sig"><code>wallclock() -&gt; wallclock?</code></pre>

今の日付と時刻

いまの日時。時計が合っていなければ nil。
```ruby
t = FmrbApp.wallclock
Log.info("#{t[:hour]}") if t
```

### FmrbApp.gfx_stats

<pre class="fmrb-sig"><code>gfx_stats() -&gt; gfx_stats</code></pre>

絵を送った回数の記録

```ruby
s = FmrbApp.gfx_stats
```

### FmrbApp.wasm_stats

<pre class="fmrb-sig"><code>wasm_stats() -&gt; wasm_stats</code></pre>

wasm のランタイムのようす

wasm のアプリを動かすランタイム (WAMR) のようす。running は動いていれば 1
(wasm のアプリが 1 つでも動いている間)、apps はそれを使うアプリの数、
modules は読み込んだモジュールの数、natives は本体が渡す境界の関数の数。
pool_* は全部の wasm のアプリが分けて使う共通のプール (バイト。high は起動してからの最大)、traps は起動してからトラップ (か、長すぎる呼び出し) で止まった回数。wasm のアプリを載せない端末 (ESP32-S3) では全部 0。
```ruby
w = FmrbApp.wasm_stats
Log.info("#{w[:pool_used]} of #{w[:pool_total]}") if w[:running] == 1
```

### FmrbApp.wasm_app_stats

<pre class="fmrb-sig"><code>wasm_app_stats(<a href="../Integer/">Integer</a> pid) -&gt; wasm_app_stats?</code></pre>

wasm のアプリ 1 つのようす

pid の wasm のアプリのようす。wasm のアプリでなければ nil。pages は線形メモリの今の大きさ、max_pages は伸ばせる上限 (64 KB のページ)、
binary_size は .wasm の大きさ、hook_us は直近のフック (on_update など) の呼び出しにかかった時間、hook_max_us はその最長 (百万分の一秒)、calls はフックを呼んだ回数。
```ruby
s = FmrbApp.wasm_app_stats(pid)
Log.info("#{s[:pages]}/#{s[:max_pages]} pages") if s
```

### FmrbApp.enable_cursor

<pre class="fmrb-sig"><code>enable_cursor() -&gt; void</code></pre>

マウスの矢印を出す

マウスの矢印を出す。デスクトップが起動時に呼ぶ。
```ruby
FmrbApp.enable_cursor
```

### FmrbApp.set_cursor_visible

<pre class="fmrb-sig"><code>set_cursor_visible(bool visible) -&gt; void</code></pre>

マウスの矢印を見せるか隠すか

```ruby
FmrbApp.set_cursor_visible(false)
```

### FmrbApp.set_kana_mode

<pre class="fmrb-sig"><code>set_kana_mode(<a href="../Integer/">Integer</a> mode) -&gt; void</code></pre>

かな入力を切りかえる (0 切 1 ひら 2 カタ)

0 = 英字、1 = ひらがな、2 = カタカナ。
```ruby
FmrbApp.set_kana_mode(1)
```

### FmrbApp.set_text_cursor

<pre class="fmrb-sig"><code>set_text_cursor(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

文字カーソルの位置を知らせる (PC の IME 用)

文字を打つアプリが、カーソルを描くたびに呼ぶ。x, y は canvas の座標
(行の左上)、h は行の高さ。h = 0 で「今は文字を打たない」。PC の IME
(fcitx5 など) は、変換中の文字と候補をここに出す。端末では何もしない。
```ruby
FmrbApp.set_text_cursor(x, y, 12)
```

### FmrbApp.audio_muted?

<pre class="fmrb-sig"><code>audio_muted?() -&gt; bool</code></pre>

本体が消音中か

```ruby
FmrbApp.audio_muted?
```

### FmrbApp.path_read_only?

<pre class="fmrb-sig"><code>path_read_only?(<a href="../String/">String</a> path) -&gt; bool</code></pre>

消せない・名前を変えられない場所か

PC 版の配布物の木と /mnt/root で true。端末・sim・ブラウザ版では常に false。削除を確かめる前に聞く用 (File Manager)。
```ruby
FmrbApp.path_read_only?("/mnt/root/etc/hostname")
```

### FmrbApp.app_meta

<pre class="fmrb-sig"><code>app_meta(<a href="../String/">String</a> path) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>]?</code></pre>

アプリの設定 (.app.toml とコメント)

.app.toml と、.rb の先頭の `#---fmrb`
コメントを合わせて読む。両方にある項目は .app.toml が勝つ。キーも値も文字列 (配列は空白でつなぐ)。どちらも無いファイル (アプリでない) は nil。
```ruby
m = FmrbApp.app_meta(
  "/app/game/flappy.app.rb")
m["app_screen_name"] if m
```

### FmrbApp.free_bytes

<pre class="fmrb-sig"><code>free_bytes(<a href="../String/">String</a> path) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

その場所にあと何バイト書けるか

/tmp は RAM のファイルシステムの空き、ほかはその下のファイルシステムの空き。分からないとき (ブラウザ版の /home など) は nil。
```ruby
FmrbApp.free_bytes("/tmp")
```

### FmrbApp.audio_volume

<pre class="fmrb-sig"><code>audio_volume() -&gt; <a href="../Integer/">Integer</a></code></pre>

本体の音量 (0-10)

```ruby
FmrbApp.audio_volume
```

### FmrbApp.wifi_connected?

<pre class="fmrb-sig"><code>wifi_connected?() -&gt; bool</code></pre>

WiFi がつながっているか

```ruby
if FmrbApp.wifi_connected?
```

### FmrbApp.wifi_info

<pre class="fmrb-sig"><code>wifi_info() -&gt; <a href="../Hash/">Hash</a>?</code></pre>

WiFi のつながり具合

**Retro では nil**。Modern は WiFi の状態、Linux は母艦の網の状態を返す。
```ruby
i = FmrbApp.wifi_info
Log.info(i[:ip]) if i
```

### FmrbApp.usb_devices

<pre class="fmrb-sig"><code>usb_devices() -&gt; <a href="../Array/">Array</a></code></pre>

つないだ USB 機器の一覧

```ruby
FmrbApp.usb_devices.each do |d|
  Log.info(d[:type])
end
```

### FmrbApp.hid_raw_subscribe

<pre class="fmrb-sig"><code>hid_raw_subscribe(<a href="../Integer/">Integer</a> slot) -&gt; bool</code></pre>

USB の生の入力を受け取る

その口の生のレポートが `on_control` に届くようになる。HID Inspector が使っている。
```ruby
FmrbApp.hid_raw_subscribe(slot)
```

### FmrbApp.hid_raw_unsubscribe

<pre class="fmrb-sig"><code>hid_raw_unsubscribe(<a href="../Integer/">Integer</a> slot) -&gt; bool</code></pre>

USB の生の入力をやめる

```ruby
FmrbApp.hid_raw_unsubscribe(1)
```

### FmrbApp.pid

<pre class="fmrb-sig"><code>pid() -&gt; <a href="../Integer/">Integer</a></code></pre>

自分の pid

`ps` の :id と同じ番号。一覧から自分を外すときに使う。
```ruby
me = FmrbApp.pid
```

### FmrbApp.script_path

<pre class="fmrb-sig"><code>script_path() -&gt; <a href="../String/">String</a></code></pre>

起動したファイル

ファームに入っているアプリでは "" 。
```ruby
FmrbApp.script_path
```

### FmrbApp.gc

<pre class="fmrb-sig"><code>gc() -&gt; void</code></pre>

自分のメモリのごみを集める

```ruby
FmrbApp.gc
```

### FmrbApp.battery_level

<pre class="fmrb-sig"><code>battery_level() -&gt; <a href="../Integer/">Integer</a>?</code></pre>

電池の残り (百分率)

電池の無い端末では nil。
```ruby
FmrbApp.battery_level
```

### FmrbApp.battery_charging?

<pre class="fmrb-sig"><code>battery_charging?() -&gt; bool</code></pre>

電池を充電中か

```ruby
FmrbApp.battery_charging?
```

### FmrbApp.crt_state

<pre class="fmrb-sig"><code>crt_state() -&gt; <a href="../String/">String</a></code></pre>

ブラウン管の見た目の今の設定

描けない所では "" 。ほかは "crt" か "sharp" と 8 つの強さ。
```ruby
FmrbApp.crt_state != ""
# true where the look can be drawn
```

### FmrbApp.linux_available?

<pre class="fmrb-sig"><code>linux_available?() -&gt; bool</code></pre>

Linux のコマンドが使えるか

ネイティブ版と sim だけ true。
```ruby
FmrbApp.linux_available?
```

### FmrbApp.linux_start

<pre class="fmrb-sig"><code>linux_start(
  <a href="../String/">String</a>? cmd,
  <a href="../String/">String</a> cwd,
  <a href="../Integer/">Integer</a> cols,
  <a href="../Integer/">Integer</a> rows
) -&gt; <a href="../Integer/">Integer</a></code></pre>

Linux のコマンドを端末で始める

返すのは番号。始められないときは例外。cmd が nil ならシェル。
```ruby
h = FmrbApp.linux_start("ls",
      "/home", 80, 24)
```

### FmrbApp.linux_read

<pre class="fmrb-sig"><code>linux_read(<a href="../Integer/">Integer</a> h) -&gt; <a href="../String/">String</a>?</code></pre>

Linux のコマンドの出力を読む

まだ無ければ ""、終わったら nil。待たない。
```ruby
s = FmrbApp.linux_read(h)
```

### FmrbApp.linux_write

<pre class="fmrb-sig"><code>linux_write(<a href="../Integer/">Integer</a> h, <a href="../String/">String</a> data) -&gt; <a href="../Integer/">Integer</a></code></pre>

Linux のコマンドに書く

```ruby
FmrbApp.linux_write(h, "q")
```

### FmrbApp.linux_signal

<pre class="fmrb-sig"><code>linux_signal(<a href="../Integer/">Integer</a> h, <a href="../Symbol/">Symbol</a> sig) -&gt; bool</code></pre>

Linux のコマンドにシグナルを送る

:int・:term・:kill・:hup。
```ruby
FmrbApp.linux_signal(h, :int)
```

### FmrbApp.linux_exit_code

<pre class="fmrb-sig"><code>linux_exit_code(<a href="../Integer/">Integer</a> h) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Linux のコマンドの終わりの値

動いている間は nil。
```ruby
code = FmrbApp.linux_exit_code(h)
# nil while it is still running
```

### FmrbApp.linux_resize

<pre class="fmrb-sig"><code>linux_resize(<a href="../Integer/">Integer</a> h, <a href="../Integer/">Integer</a> cols, <a href="../Integer/">Integer</a> rows) -&gt; bool</code></pre>

Linux のコマンドの端末の大きさを変える

```ruby
FmrbApp.linux_resize(h, 80, 24)
```

### FmrbApp.linux_close

<pre class="fmrb-sig"><code>linux_close(<a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

Linux のコマンドを閉じる

まだ動いていれば止める。待たない。
```ruby
FmrbApp.linux_close(h)
# h comes from FmrbApp.linux_start
```

## インスタンスメソッド

### FmrbApp#gfx

<pre class="fmrb-sig"><code>gfx() -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

絵を描く画面

(0, 0) はアプリが描いてよい区画 (user area) の左上。枠のある Window
では枠の内側、枠なし・全画面では Window の左上。マウスの ev[:x] も同じ。
```ruby
gfx.fill_rect(0, 0, 10, 10,
              theme_fg)
gfx.present
```

### FmrbApp#window_gfx

<pre class="fmrb-sig"><code>window_gfx() -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

Window 全体に描く画面 (枠の上も)

原点が Window の左上の、もう 1 つの描き手。枠を自分で描く、区画の外に自分のタイトルを出す、などのときに使う。文字の書体は canvas で共通なので、set_font は gfx の方で呼ぶ。
```ruby
window_gfx.fill_rect(0, 0,
  window_width, 11, theme_accent)
```

### FmrbApp#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

アプリの名前

```ruby
Log.info("#{name} started")
```

### FmrbApp#running?

<pre class="fmrb-sig"><code>running?() -&gt; bool</code></pre>

動いている最中かどうか

```ruby
stop unless running
```

### FmrbApp#window_width

<pre class="fmrb-sig"><code>window_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window の横幅 (ドット)

Window の外枠まで含めた幅。中に描ける範囲は `@user_area_width` の方。
```ruby
w = window_width
```

### FmrbApp#window_height

<pre class="fmrb-sig"><code>window_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window の高さ (ドット)

```ruby
h = window_height
```

### FmrbApp#pos_x

<pre class="fmrb-sig"><code>pos_x() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window の左上の位置

```ruby
x = pos_x
```

### FmrbApp#pos_y

<pre class="fmrb-sig"><code>pos_y() -&gt; <a href="../Integer/">Integer</a></code></pre>

Window の左上の位置

```ruby
y = pos_y
```

### FmrbApp#user_area_width

<pre class="fmrb-sig"><code>user_area_width() -&gt; <a href="../Integer/">Integer</a></code></pre>

中に描ける区画の横幅 (ドット)

枠の内側 (枠なし・全画面では Window 全体)。gfx の (0, 0) はここの左上。
```ruby
w = user_area_width
```

### FmrbApp#user_area_height

<pre class="fmrb-sig"><code>user_area_height() -&gt; <a href="../Integer/">Integer</a></code></pre>

中に描ける区画の高さ (ドット)

```ruby
h = user_area_height
```

### FmrbApp#platform

<pre class="fmrb-sig"><code>platform() -&gt; (:esp32 | :linux)</code></pre>

動いている機械の種類

`:esp32` か `:linux` (Symbol) を返す。ブラウザ版も `:linux` なので、ブラウザを見分けるなら `FmrbConst::BOARD == "wasm"`。別の端末へ移ったアプリでは、移った先の値になる。
```ruby
if platform == :esp32
```

### FmrbApp#fullscreen?

<pre class="fmrb-sig"><code>fullscreen?() -&gt; bool</code></pre>

全画面かどうか

```ruby
draw_window_frame unless fullscreen
```

### FmrbApp#rounded_corners?

<pre class="fmrb-sig"><code>rounded_corners?() -&gt; bool</code></pre>

Window の角が丸いかどうか

```ruby
r = rounded_corners ? 6 : 0
```

### FmrbApp#closable?

<pre class="fmrb-sig"><code>closable?() -&gt; bool</code></pre>

閉じるボタンで終われるか

```ruby
show_close_button if closable
```

### FmrbApp#closable=

<pre class="fmrb-sig"><code>closable=(bool v) -&gt; void</code></pre>

閉じるボタンで終われるかを決める

画面全体を持つ作りのアプリ (デスクトップ) は、右上の角が普通の UI なので
`false` にします。この設定が見るのは**閉じるボタンのクリックだけ**で、
`false` なら角を押しても `stop` しません。
```ruby
def on_create
  self.closable = false
end
```

### FmrbApp#frameless?

<pre class="fmrb-sig"><code>frameless?() -&gt; bool</code></pre>

枠なしの Window か (window_frame = "none")

枠・タイトルバー・閉じるボタンが無く、user area は Window 全体、地は透ける色。

### FmrbApp#resizable?

<pre class="fmrb-sig"><code>resizable?() -&gt; bool</code></pre>

右下の角で大きさを変えられるか

.app.toml の resizable。枠の右下に印が出る。

### FmrbApp#resize_corner

<pre class="fmrb-sig"><code>resize_corner() -&gt; <a href="../Integer/">Integer</a></code></pre>

右下に空けておく幅

右下の角に何かを描くアプリ (状態行・スクロールバー) が、右端と下端に空けるドット数。大きさを変えられる Window では印と掴む範囲の分の 9 を返し、
**全画面と大きさを変えられない Window では 0** です (定数ではなく毎回答える)。
```ruby
right = @area_w - resize_corner - 2
```

### FmrbApp#on_create

<pre class="fmrb-sig"><code>on_create() -&gt; void</code></pre>

始まるときに一度だけ呼ばれる

画面も Window もここで使える状態になっています。最初の絵と、あとで使う変数をここで用意します。

ファイルにはクラスを書くだけです。末尾に起動のコードは要りません:
ファイルを読み終えると、そのクラスが作られて `start` されます。

```ruby
class MyApp < FmrbApp
  def on_create
    @n = 0
    clear_user_area
    gfx.present
  end
end
```

### FmrbApp#on_update

<pre class="fmrb-sig"><code>on_update() -&gt; void</code></pre>

毎フレーム呼ばれる。描画を書く場所

アプリが動いているあいだ、くり返し呼ばれます。ここに 1 フレーム分の描画を書きます。動きは、呼ばれるたびに位置を少しずつ変えて作ります。

中で止まると他のアプリまで止まるので、**ここで長く待たない**こと。時間をおきたいときは `set_timer` を使います。

```ruby
class MyApp < FmrbApp
  def on_create
    @x = 0
  end

  def on_update
    @x = (@x + 1) % window_width
    gfx.clear(FmrbGfx::BLACK)
    gfx.fill_circle(@x, 60, 8,
                    FmrbGfx::YELLOW)
    gfx.present
  end
end
```

### FmrbApp#on_destroy

<pre class="fmrb-sig"><code>on_destroy() -&gt; void</code></pre>

終わるときに一度だけ呼ばれる

終わる直前に一度だけ呼ばれます。開いたファイルを閉じる、保存する、といった後始末をここに書きます。

呼ばれるのは**行儀よく終わったとき**だけです。例外で落ちたアプリはここに来ません。消えて困るものは、終わりを待たずに書き出しておくこと。
```ruby
def on_destroy
  Log.info("MyApp: bye")
end
```

### FmrbApp#on_suspend

<pre class="fmrb-sig"><code>on_suspend() -&gt; void</code></pre>

他のアプリに画面を渡すとき

別のアプリが前に出たときに呼ばれます。アプリは動いたままで、画面だけが見えなくなります。**描いても誰も見ていない**ので、重い描画や音を止めるならここです。
```ruby
def on_suspend
  @paused = true
end
```

### FmrbApp#on_resume

<pre class="fmrb-sig"><code>on_resume() -&gt; void</code></pre>

画面が戻ってきたとき

画面が戻ってきたときに呼ばれます。**画面の中身は残っていません** —ここで描き直します。
```ruby
def on_resume
  @paused = false
  draw_screen
end
```

### FmrbApp#on_checkpoint

<pre class="fmrb-sig"><code>on_checkpoint() -&gt; void</code></pre>

イメージに書かれた直後

アプリがイメージに書かれ、閉じる直前に呼ばれます。アプリは
**終わったのではなく移った**ので `on_destroy` は来ません。ここでしたことはイメージに入りません。運べるのは `.app.toml` に `movable = true` と書いた、mruby で動くアプリだけです (doc/checkpoint/movable_apps.md)。
```ruby
def on_checkpoint
  Log.info("written to an image")
end
```

### FmrbApp#on_restore

<pre class="fmrb-sig"><code>on_restore() -&gt; void</code></pre>

イメージから起動したとき

イメージから起動したアプリで、**書かれた所から続ける直前**に呼ばれます。インスタンス変数も Task もタイマもそのまま戻っています。Window (同じ場所・大きさ・枠、フォント、`GfxBlock`) と `subscribe` した知らせは基底クラスが戻してあり、キーボードはこのアプリに来ます。**描いた絵は戻りません**:
Window は枠だけの空の状態なので、何かあったときだけ描くアプリはここで描き直します (`on_update` で毎回全部描くアプリは何もしなくてよい)。スプライトや画像など、アプリが自分で外に作ったものもここで作り直します。ファイルを開いたままのアプリはイメージに書けません。画面の大きさが違う端末 (Retro と Modern) へ移ると、Window が画面に収まるよう縮められたり、全画面の大きさが変わったりします。そのときは
`on_restore` の前に `on_resize` が来ます (大きさを変えたときと同じ)。移った先のビルドには、すべての端末に共通でないメソッドが無いことがあります。`respond_to?` で確認するか `rescue NoMethodError` で受けてください (端末の違いはアプリの小さな窓口のオブジェクトに集め、そこで
`respond_to?` か `method_missing` で吸収するのがおすすめ。`Array` など組み込みのクラスに `method_missing` を足すのはおすすめしません)。着いた側は足りない名前をログと答えで教えますが、断りません。無いと続けられないメソッドは `.app.toml` に `requires = ["名前"]` と書くと、それが無いビルドへは移りません。詳しくは doc/checkpoint/movable_apps.md。
```ruby
def on_restore
  draw_screen
end
```

### FmrbApp#on_checkpoint_refused

<pre class="fmrb-sig"><code>on_checkpoint_refused(<a href="../String/">String</a> reason) -&gt; void</code></pre>

自分のイメージを断られたとき

`checkpoint` で頼んだイメージが書けなかったときに、理由を持って呼ばれます。アプリはそのまま動き続けます。
```ruby
def on_checkpoint_refused(reason)
  Log.info("refused: #{reason}")
end
```

### FmrbApp#on_event

<pre class="fmrb-sig"><code>on_event(event ev) -&gt; void</code></pre>

キーやマウスの入力が来たとき

ev は入力の中身が入った Hash です。よく使うのは次の 4 つ:

- `ev[:type]` … `:key_down` `:mouse_up` など、何が起きたか
- `ev[:scancode]` … 押されたキーの番号。**文字ではなくこちらで見ます**
  (かな入力のときも同じ番号が届くため)
- `ev[:x]` `ev[:y]` … マウスの位置 (gfx と同じ、区画の左上が 0。
  Window の左上からの位置は `ev[:wx]` `ev[:wy]`)

Ctrl や Shift が押されていたかは `ev_ctrl?(ev)` などで調べます。

```ruby
class MyApp < FmrbApp
  def on_event(ev)
    return unless
      ev[:type] == :key_down
    case ev[:scancode]
    when 0x4F then @x += 4  # 右
    when 0x50 then @x -= 4  # 左
    end
  end
end
```

### FmrbApp#on_resize

<pre class="fmrb-sig"><code>on_resize(<a href="../Integer/">Integer</a> new_width, <a href="../Integer/">Integer</a> new_height) -&gt; void</code></pre>

Window の大きさが変わったとき

Window の大きさが変わったときに呼ばれます。全画面への切り替えでも呼ばれます。

**FmrbUI の部品は作った場所に貼り付いたまま**なので、大きさが変わったら作り直しが要ります。枠も描き直します。

```ruby
def on_resize(w, h)
  detach_ui(@ui) if @ui
  @ui = FmrbUI.new(self)
  build_widgets
  redraw
end
```

### FmrbApp#on_quit_request

<pre class="fmrb-sig"><code>on_quit_request() -&gt; void</code></pre>

閉じてよいか聞かれたとき

閉じるボタンや Ctrl+Q で呼ばれる。**書き換えなければそのまま終わる**。保存を尋ねたいときはここで止める。
```ruby
def on_quit_request
  if @modified
    ask_save
  else
    stop
  end
end
```

### FmrbApp#on_frameless_right_click

<pre class="fmrb-sig"><code>on_frameless_right_click(event ev) -&gt; void</code></pre>

枠なしの Window の右クリック・長押し

枠なしの Window の右クリック (離したとき) と、動かさずに 1 秒押し続けたとき (ev[:type] が :long_press) に呼ばれる。既定は Window のメニュー
(request_window_menu: 送る・読み直し・閉じる) を出す。右ボタンを自分で使うアプリは空で書き換える (メニューも出したいなら super(ev) を呼ぶ)。右クリックは on_event にも届く。長押しは届かない。
```ruby
def on_frameless_right_click(ev)
end
```

### FmrbApp#set_hit_shape

<pre class="fmrb-sig"><code>set_hit_shape(<a href="../Array/">Array</a> rects) -&gt; bool</code></pre>

当たりを四角の一覧で決める (枠なし)

押して当たるのは、四角・マスク・印を付けた sprite を合わせた所だけ。ほかを押すと後ろの Window へ抜ける。何も決めなければ Window の四角。座標は Window の中。`[]` で四角を外す。移ったら基底が決め直す。
```ruby
set_hit_shape([[0, 0, 40, 30],
               [10, 30, 20, 8]])
```

### FmrbApp#set_hit_mask

<pre class="fmrb-sig"><code>set_hit_mask(<a href="../FmrbHitMask/">FmrbHitMask</a>? mask, ?<a href="../Integer/">Integer</a> x, ?<a href="../Integer/">Integer</a> y) -&gt; bool</code></pre>

当たりをマスク (FmrbHitMask) で決める

左上を (x, y) に置く。nil で外す。
```ruby
m = hit_mask_from_art(ROWS,
      transparent: ".", scale: 3)
set_hit_mask(m, 36, 38)
```

### FmrbApp#hit_mask_from_art

<pre class="fmrb-sig"><code>hit_mask_from_art(
  <a href="../Array/">Array</a> rows,
  ?transparent: <a href="../String/">String</a>,
  ?scale: <a href="../Integer/">Integer</a>
) -&gt; <a href="../FmrbHitMask/">FmrbHitMask</a></code></pre>

ドット絵の文字列から当たりのマスクを作る

1 文字 1 マス (ASCII)。transparent に含まれない文字が当たる。
1 マスは scale x scale 画素。
```ruby
m = hit_mask_from_art(
      ["..XX..", ".XXXX."],
      transparent: ".", scale: 2)
```

### FmrbApp#add_hit_sprite

<pre class="fmrb-sig"><code>add_hit_sprite(<a href="../SpriteInstance/">SpriteInstance</a> sprite, ?<a href="../FmrbHitMask/">FmrbHitMask</a>? mask) -&gt; bool</code></pre>

sprite に当たりの印を付ける

sprite の四角 (mask を渡せばその形) が、sprite の位置と見え隠れについて当たりに入る。移った後は on_restore で付け直す。
```ruby
add_hit_sprite(@player)
```

### FmrbApp#remove_hit_sprite

<pre class="fmrb-sig"><code>remove_hit_sprite(<a href="../SpriteInstance/">SpriteInstance</a> sprite) -&gt; void</code></pre>

sprite の当たりの印を外す

```ruby
remove_hit_sprite(@player)
```

### FmrbApp#clear_hit_shape

<pre class="fmrb-sig"><code>clear_hit_shape() -&gt; bool</code></pre>

当たりを Window の四角に戻す

```ruby
clear_hit_shape
```

### FmrbApp#start

<pre class="fmrb-sig"><code>start() -&gt; void</code></pre>

アプリを動かし始める

`on_create` を呼び、アプリのループに入り、終わったら後始末をします。

ファイルのアプリでは自分で呼びません。ファイルを読み終えたあと、そのファイルが定義した `FmrbApp` の子が作られ、これが呼ばれます。
`.app.toml` (か `#---fmrb` の囲み) に `class = "MyApp"` があればそのクラスを、無ければ子が 1 つのときにそれを起動します。決まらないときは理由がエラーの Window に出ます。
```ruby
MyApp.new.start
```

### FmrbApp#stop

<pre class="fmrb-sig"><code>stop() -&gt; void</code></pre>

アプリを止める

ループを抜けて終わる。**これを通った終わりだけが「行儀のよい終わり」**
として記録され、例外で落ちたのと区別が付く。
```ruby
stop
```

### FmrbApp#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

使った物を片づける

後始末。`start` が最後に自分で呼ぶので、普通は書かない。

### FmrbApp#request_reload

<pre class="fmrb-sig"><code>request_reload() -&gt; void</code></pre>

自分をもう一度読み込み直す

ファイルから起動したアプリを、書き直した内容で起動し直すよう頼む。
Window のメニューの「読み直し」と同じ問いを出す。
```ruby
request_reload
```

### FmrbApp#request_window_menu

<pre class="fmrb-sig"><code>request_window_menu(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; void</code></pre>

Window のメニューを出す

デスクトップに Window のメニューを出してもらう (x, y は Window の中の位置)。送る (運べるアプリで)・読み直し (ファイルのアプリで)・閉じる。タイトルバーの右クリックと、枠なしの右クリック・長押しの既定がこれを呼ぶ。
```ruby
request_window_menu(ev[:wx], ev[:wy])
```

### FmrbApp#request_close_confirm

<pre class="fmrb-sig"><code>request_close_confirm() -&gt; void</code></pre>

「<アプリ> を閉じますか?」と聞く

デスクトップに確認の画面を出してもらう。はいなら on_quit_request が呼ばれ、いいえ・外のクリックでは何も起きない。
```ruby
request_close_confirm
```

### FmrbApp#main_loop

<pre class="fmrb-sig"><code>main_loop() -&gt; void</code></pre>

呼ばれ続ける本体の繰り返し

`start` の中身。自分で呼ぶことはまず無い。

### FmrbApp#draw_window_frame

<pre class="fmrb-sig"><code>draw_window_frame() -&gt; void</code></pre>

Window のふちと題名を描き直す

タイトルバーとわく、閉じるボタンを描きます。全画面のときは何もしません。

**ふつうは呼ばなくてよい。** 起動したときは基底が描き、
clear_user_area も区画を塗った後に枠を描き直します。大きさが変わったときは、on_resize で clear_user_area から描き直せば枠も付いてきます。呼ぶのは、区画の端に描いて枠の線を踏んだとき (clear_user_area を使わずに fill_rect で塗ったときなど) だけです。

タイトルバーは既定のフォントで描かれますが、
**呼ぶ前のフォント設定は戻されます**。`set_font(:ja)` を毎フレーム掛け直す必要はありません。
```ruby
@gfx.clear(FmrbGfx::BLACK)
draw_window_frame
@gfx.present
```

### FmrbApp#clear_user_area

<pre class="fmrb-sig"><code>clear_user_area() -&gt; void</code></pre>

中身の場所をぬりつぶす。色を省くとテーマの紙の色

Window の中だけを塗りつぶします。**わくも描き直し**、その場所にあった
FmrbUI の部品にも描き直しの印を付けます。Window のアプリで画面を消すときは
`gfx.clear` ではなくこちらを使います。

`gfx.clear` は canvas 全体を塗るので、自分で描いたタイトルバーもわくも消えます。
```ruby
clear_user_area
@gfx.draw_text(4, 4, "Hi", theme_fg)
@gfx.present
```

### FmrbApp#clear_user_area_raw

<pre class="fmrb-sig"><code>clear_user_area_raw(<a href="../Integer/">Integer</a> color) -&gt; void</code></pre>

clear_user_area の省略なしの形

引数を省略できない単純な形。color が負ならテーマの紙の色 (枠なしでは透ける色)。包みは clear_user_area (色を省くと負と同じ)。
```ruby
clear_user_area_raw(-1)
```

### FmrbApp#detach_ui

<pre class="fmrb-sig"><code>detach_ui(<a href="../FmrbUI/">FmrbUI</a> ui) -&gt; void</code></pre>

部品箱を外す

Window の大きさが変わるアプリが、部品を作り直す前に古い `FmrbUI` を外すために呼ぶ。外さないと `clear_user_area` が古い座標のまま描き直し続ける。
(新しく作った `FmrbUI` は自分で付く。)
```ruby
def on_resize(w, h)
  detach_ui(@ui) if @ui
  @ui = FmrbUI.new(self)
  build_widgets
end
```

### FmrbApp#draw_resize_mark

<pre class="fmrb-sig"><code>draw_resize_mark(<a href="../Integer/">Integer</a> w, <a href="../Integer/">Integer</a> h) -&gt; void</code></pre>

大きさ変更の印を描く

w x h の Window の右下の角に、タイトルバーの色の三角を描く。大きさを変えられる Window の `draw_window_frame` が自分で描くので、**呼ぶのは枠を**
**自前で描くアプリだけ**で、枠線より前に呼ぶ。`window_gfx` に描くので、画面のないアプリでは使えない。
```ruby
draw_resize_mark(w, h)
```

### FmrbApp#theme_bg

<pre class="fmrb-sig"><code>theme_bg() -&gt; <a href="../Integer/">Integer</a></code></pre>

紙の色

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_bg)
```

### FmrbApp#theme_fg

<pre class="fmrb-sig"><code>theme_fg() -&gt; <a href="../Integer/">Integer</a></code></pre>

紙に書く字の色

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_fg)
```

### FmrbApp#theme_accent

<pre class="fmrb-sig"><code>theme_accent() -&gt; <a href="../Integer/">Integer</a></code></pre>

目立たせる色

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_accent)
```

### FmrbApp#theme_border

<pre class="fmrb-sig"><code>theme_border() -&gt; <a href="../Integer/">Integer</a></code></pre>

線や枠、うすい字の色

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_border)
```

### FmrbApp#theme_fg_light

<pre class="fmrb-sig"><code>theme_fg_light() -&gt; <a href="../Integer/">Integer</a></code></pre>

濃い地の上に書く字の色

```ruby
gfx.fill_rect(0, 0, 40, 20,
              theme_fg_light)
```

### FmrbApp#draw_scrollbar

<pre class="fmrb-sig"><code>draw_scrollbar(<a href="../Integer/">Integer</a> scroll, <a href="../Integer/">Integer</a> total, <a href="../Integer/">Integer</a> visible) -&gt; void</code></pre>

右はしに巻物のつまみを描く

Window の右端にスクロールバーを描く。**位置は自分で持つ** — この呼び出しは絵を描くだけで、値は覚えない。
```ruby
draw_scrollbar(@scroll,
               @lines.size,
               visible_rows)
```

### FmrbApp#scrollbar_hit

<pre class="fmrb-sig"><code>scrollbar_hit(<a href="../Integer/">Integer</a> click_x, <a href="../Integer/">Integer</a> click_y) -&gt; <a href="../Symbol/">Symbol</a>?</code></pre>

つまみのどこを押したか調べる

クリックがバーのどこに当たったかを返す。当たっていなければ nil。
```ruby
case scrollbar_hit(ev[:x], ev[:y])
when :up   then @scroll -= 1
when :down then @scroll += 1
end
```

### FmrbApp#wheel_rows

<pre class="fmrb-sig"><code>wheel_rows(event ev) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

ホイールが求める行数

**符号つき**で、正は一覧の先頭へ (ホイールを奥へ回した向き)。ホイールのイベントでなければ、また delta が 0 なら **nil**。1 刻みの行数は端末の設定 (system_conf.toml の `wheel_lines`) で、アプリが決めない。スクロールバーの部品はホイールに答えない。
```ruby
rows = wheel_rows(ev)
@scroll -= rows if rows
```

### FmrbApp#wheel_notches

<pre class="fmrb-sig"><code>wheel_notches(event ev) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

ホイールの刻みの数

行数にしない刻みそのもの (符号は `wheel_rows` と同じ)。1 行の高さが文字の行と違う一覧 (タイルの並び) に使う。ホイールでなければ nil。
```ruby
n = wheel_notches(ev)
```

### FmrbApp#set_window_position

<pre class="fmrb-sig"><code>set_window_position(<a href="../Integer/">Integer</a> x, <a href="../Integer/">Integer</a> y) -&gt; FmrbApp</code></pre>

Window を動かす

```ruby
set_window_position(20, 40)
```

### FmrbApp#request_fullscreen

<pre class="fmrb-sig"><code>request_fullscreen(bool on) -&gt; void</code></pre>

全画面にするか元に戻すか頼む

全画面と Window を切り替えるよう頼みます。**すぐには変わりません** — VM は動いたまま、答えは `on_resize` として返ってきます。そのときには
`fullscreen` も Window の中の大きさも新しい値になっています。

描き直しは `on_resize` に書きます。ここでは書きません。
```ruby
request_fullscreen(true)
```

### FmrbApp#toggle_fullscreen

<pre class="fmrb-sig"><code>toggle_fullscreen() -&gt; void</code></pre>

全画面と Window を切りかえる

全画面と Window を切り替える。**答えは `on_resize` で返る** (`request_fullscreen`
と同じ)。
```ruby
toggle_fullscreen if sc == 0x44
# 0x44 is F11
```

### FmrbApp#create_canvas_gfx

<pre class="fmrb-sig"><code>create_canvas_gfx(<a href="../Integer/">Integer</a> width, <a href="../Integer/">Integer</a> height) -&gt; <a href="../FmrbGfx/">FmrbGfx</a></code></pre>

自分用の画面をもう一枚作る

このアプリの持ちものとして canvas をもう 1 枚作り、それに結び付いた
FmrbGfx を返します。終了時 (異常終了も含む) に自動で消えます。

**呼び方はキーワード引数です** — 上のシグネチャは型推論の都合で位置引数の形に直してあります。実際にはこう書きます:

```ruby
g = create_canvas_gfx(
  width: 200, height: 100)
g.present(20, 40)
```

**全画面のアプリ向け**です。Window のアプリで使うと、フォーカスが移ったときに Window の管理側が追いかけてくれません。

### FmrbApp#delete_canvas_gfx

<pre class="fmrb-sig"><code>delete_canvas_gfx(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; void</code></pre>

作った画面を片づける

```ruby
delete_canvas_gfx(@layer)
```

### FmrbApp#app_settings

<pre class="fmrb-sig"><code>app_settings() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

アプリ自身の設定ファイルを読む

`/home/<app_handle_name>.toml` を Hash (鍵は文字列) にして返す。
**ファイルが無いか、TOML でないときは `{}`** (後者はログに出る)。
```ruby
city = app_settings["city"]
```

### FmrbApp#save_app_settings

<pre class="fmrb-sig"><code>save_app_settings(<a href="../Hash/">Hash</a>[untyped, untyped] values) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

設定ファイルの鍵を書き換える

values は 鍵 => 値 の Hash。**渡した鍵の行だけ**を書き換え、ほかの行はそのまま残す (ファイルが無ければ作る)。鍵は `"city"` のほか
`"section.key"` の形も使え、値が nil なら鍵を消す。

**書いて読み直せたら、読み直した Hash** を返し、**書けなかったとき・**
**読み直して値が違うとき・TOML でないファイルのときは nil** (その場合ファイルは触らない。理由は `FmrbToml.error`)。
```ruby
save_app_settings({ "city" => name })
```

### FmrbApp#app_settings_path

<pre class="fmrb-sig"><code>app_settings_path() -&gt; <a href="../String/">String</a></code></pre>

設定ファイルの場所

```ruby
app_settings_path   #=> "/home/weather.toml"
```

### FmrbApp#app_handle_name

<pre class="fmrb-sig"><code>app_handle_name() -&gt; <a href="../String/">String</a></code></pre>

アプリの名前 (ファイルの名に使う)

`.app.toml` の `app_handle_name`、無ければファイル名から `.app.rb` を除いたもの (`/app/test/step_sensor.app.rb` なら `step_sensor`)、それも無ければ `name`。
```ruby
app_handle_name   #=> "step_sensor"
```

### FmrbApp#app_state

<pre class="fmrb-sig"><code>app_state(?<a href="../String/">String</a> who) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]</code></pre>

覚えたことを読む (再起動で消える)

`/tmp/<who>.state.toml` を Hash (鍵は文字列) で返す。**再起動 (実機は電源、**
**PC はプログラム、ブラウザはページ) で消える**ので、ユーザの設定は
`app_settings` に置く。値は文字列・整数・true/false だけが残る。
`who` (省略すると `app_handle_name`) は、1 つのアプリの中の部分が自分の名前で持つときに渡す。ファイルが無いか TOML でなければ `{}`。
```ruby
dir = app_state("file_manager")["dir"]
```

### FmrbApp#save_app_state

<pre class="fmrb-sig"><code>save_app_state(<a href="../Hash/">Hash</a>[untyped, untyped] values, ?<a href="../String/">String</a> who) -&gt; bool</code></pre>

次に開くときまで覚える (再起動で消える)

読んだ Hash に values を重ねて書く。**値が変わらなければ書かない**。文字列・整数・true/false 以外の値は**黙って飛ばされる**。書けた (すでに同じだった場合も) なら true、書けなければ false。
```ruby
save_app_state({ "dir" => "/home" })
```

### FmrbApp#app_state_path

<pre class="fmrb-sig"><code>app_state_path(?<a href="../String/">String</a> who) -&gt; <a href="../String/">String</a></code></pre>

覚えておくことのファイルの場所

```ruby
app_state_path   #=> "/tmp/weather.state.toml"
```

### FmrbApp#ev_ctrl?

<pre class="fmrb-sig"><code>ev_ctrl?(event ev) -&gt; bool</code></pre>

Ctrl を押していたかどうか

Ctrl が押されていたかを返します。左右どちらでも真です。

文字のキーを見分けるときは **`ev[:scancode]` を使うこと**。
`ev[:keycode]` は環境で変わります (Linux では SDL の値が来ます) が、
scancode は どこでも同じ USB HID の番号です。

```ruby
# Ctrl+S
if ev_ctrl?(ev) &&
   ev[:scancode] == 0x16
```

### FmrbApp#ev_shift?

<pre class="fmrb-sig"><code>ev_shift?(event ev) -&gt; bool</code></pre>

Shift を押していたかどうか

```ruby
if ev_shift?(ev)
```

### FmrbApp#ev_alt?

<pre class="fmrb-sig"><code>ev_alt?(event ev) -&gt; bool</code></pre>

Alt を押していたかどうか

```ruby
if ev_alt?(ev)
```

### FmrbApp#set_timer

<pre class="fmrb-sig"><code>set_timer(<a href="../Integer/">Integer</a> interval) -&gt; <a href="../Integer/">Integer</a></code></pre>

決まった時間ごとに呼んでもらう

interval ミリ秒後に一度だけブロックを呼びます。**繰り返しません** —続けたいならブロックの中でもう一度 `set_timer` を呼びます。

呼ばれる時刻はアプリのループの刻みに丸められるので、
**ミリ秒どおりには来ません**。戻り値は `clear_timer` に渡す番号です。

Spinel で動かすアプリでは、**ブロックの外側のローカル変数を掴めません**
(インスタンス変数と定数は使えます)。

```ruby
@id = set_timer(500) { blink }
```

### FmrbApp#clear_timer

<pre class="fmrb-sig"><code>clear_timer(<a href="../Integer/">Integer</a> timer_id) -&gt; void</code></pre>

時間の呼び出しをやめる

`set_timer` が返した番号を渡して止める。
```ruby
@id = set_timer(500) { blink }
clear_timer(@id)
```

### FmrbApp#request_early_update

<pre class="fmrb-sig"><code>request_early_update() -&gt; void</code></pre>

待ちを今すぐ終える

**on_control や on_event の中で呼ぶ**。待ちを終わらせて、すぐ `on_update` に戻る。メッセージを受けて、予定より早く動かなければならないと分かったときに使う。**on_update の中で呼んでも何も起きない** (次の待ちを決め直すところなので)。
```ruby
def on_control(msg)
  @due = Machine.board_millis + 200
  request_early_update
end
```

### FmrbApp#subscribe

<pre class="fmrb-sig"><code>subscribe(<a href="../String/">String</a> topic) -&gt; void</code></pre>

知らせを受け取るようにする

その名前で配られたものが `on_control` に届くようになる。
```ruby
subscribe("clock/hour")
```

### FmrbApp#unsubscribe

<pre class="fmrb-sig"><code>unsubscribe(<a href="../String/">String</a> topic) -&gt; void</code></pre>

知らせを受け取るのをやめる

```ruby
unsubscribe("clock/hour")
```

### FmrbApp#publish

<pre class="fmrb-sig"><code>publish(<a href="../String/">String</a> topic, ?untyped data) -&gt; void</code></pre>

みんなに知らせを送る

topic の名前で、購読しているアプリ全部にデータを配ります。

**1 通で送れるのは 176 バイトまで**です。大きなものは `/tmp` に書いて
**その場所だけを配る**のが定石です (`/tmp` はメモリの上にあり、再起動で消えます)。
```ruby
publish("my_topic", { "n" => 1 })
```

### FmrbApp#send_message

<pre class="fmrb-sig"><code>send_message(<a href="../Integer/">Integer</a> dest_pid, <a href="../Integer/">Integer</a> msg_type, untyped data) -&gt; bool</code></pre>

他のアプリに伝言を送る

特定の相手 (dest_pid) に直接送る。data は MessagePack に詰められる値
(ふつうは Hash) で、**詰めたあとの大きさが 176 バイトまで**は
`publish` と同じ。msg_type は `FmrbConst::MSG_TYPE_APP_CONTROL`。

**送れたら true、相手の待ち行列が無い (pid が違う・もう終わった) か、1 秒**
**待っても入らなければ false** (ログにも出る)。176 バイトを超えると
ArgumentError。送り手の pid は中身に入らないので、返事がほしいときは自分で入れる (`"re" => FmrbApp.pid`)。

受け手は `"cmd"` に文字列を持つ Hash だけを読む。`resize`・`moved`・
`suspend`・`resume`・`stop`・`quit_request` など土台が決めている cmd は土台が処理し、**それ以外の cmd は Hash のまま `on_control` に届く**
(定義していれば)。`"cmd"` の無い Hash や、Hash でないものは黙って捨てられる。
```ruby
send_message(pid,
  FmrbConst::MSG_TYPE_APP_CONTROL,
  { "cmd" => "hello",
    "re" => FmrbApp.pid })
```

### FmrbApp#sync_file

<pre class="fmrb-sig"><code>sync_file(<a href="../String/">String</a> path, ?dest: <a href="../String/">String</a>) -&gt; bool</code></pre>

描画側にファイルを送る (画面なしでも)

`FmrbGfx#sync_file` と同じ転送を、**画面を持たないアプリ**からできる形にしたもの。大きさと CRC32 を比べて、違うときだけ送る。`dest:` (省略すると同じパス) は描画側での置き場所。成功で true、失敗で false。
```ruby
sync_file("/home/a.wav",
          dest: "/cache/a.wav")
```

### FmrbApp#request_file_select

<pre class="fmrb-sig"><code>request_file_select(<a href="../String/">String</a> mode, ?dir: <a href="../String/">String</a>) -&gt; void</code></pre>

ファイルを選ぶ Window を出してもらう

ファイル選択の Window を開くよう頼む。選ばれた道は `on_control` に届く。
"open" か "save" を渡す。dir: で最初に開くフォルダを渡せる (無ければ有る所まで親へ戻る。省くと今までどおり)。
```ruby
request_file_select("open")
request_file_select("save", dir: "/home/stamps")
```

### FmrbApp#request_file_select_raw

<pre class="fmrb-sig"><code>request_file_select_raw(<a href="../String/">String</a> mode) -&gt; void</code></pre>

request_file_select の省略なしの形

引数を省略できない単純な形。包みは request_file_select (mode を省くと "open")。
```ruby
request_file_select_raw("save")
```

### FmrbApp#request_run

<pre class="fmrb-sig"><code>request_run(<a href="../String/">String</a> path) -&gt; void</code></pre>

ファイルをアプリとして動かす

```ruby
request_run("/app/usr/mine.app.rb")
```

### FmrbApp#request_run_raw

<pre class="fmrb-sig"><code>request_run_raw(<a href="../String/">String</a> path, <a href="../Integer/">Integer</a> prev_pid) -&gt; void</code></pre>

request_run の省略なしの形

引数を省略できない単純な形。prev_pid は前に頼んで起動したアプリ
(カーネルが先に止める)。負なら無し。包みは request_run (prev_pid を省くと無し)。答えは on_control に run_result で届く。
```ruby
request_run_raw("/app/usr/mine.app.rb", -1)
```

### FmrbApp#checkpoint

<pre class="fmrb-sig"><code>checkpoint() -&gt; <a href="../String/">String</a>?</code></pre>

自分をイメージに書いて閉じる

自分を止めてイメージ (`/tmp/<名前>.ckpt`) に書き、閉じるよう頼みます。書くのはメッセージ待ちの後の区切りなので、
**`on_event` や `on_update` の中から頼んでよい**です。書けたら `on_checkpoint` の後に閉じ、
`restart: true` を渡すとすぐにイメージから起動し直します (`on_restore`)。断られたら
`on_checkpoint_refused` が来ます。頼めたら nil、頼めないときは理由の文字列を返します。
```ruby
why = checkpoint(restart: true)
Log.warn(why) if why
```

### FmrbApp#move_to

<pre class="fmrb-sig"><code>move_to(<a href="../String/">String</a> to) -&gt; <a href="../String/">String</a>?</code></pre>

自分を別の端末へ移す

自分を Asterism の端末 `to` (その端末のノード ID) へ移すよう頼みます。カーネルは先に相手に呼ぶメソッドがあるかを聞き、止めてイメージを書き、運んで、相手で起動できたらこちらを閉じます (`on_checkpoint` が最後、相手では `on_restore`)。断られた・返事が無いときは `on_checkpoint_refused`
が来て、止めた所から続けます。頼めたら nil、頼めないときは理由の文字列。
```ruby
why = move_to("fmruby-abcdef")
Log.warn(why) if why
```

### FmrbApp#idle_gc=

<pre class="fmrb-sig"><code>idle_gc=(bool enable) -&gt; void</code></pre>

ひまな時に片づけをするようにする

拍を崩したくないアプリ (曲を鳴らす・動かし続ける) で `true` にする。回収が**待っている間に小分けで**進み、途中で 100 ms 以上止まることが減る。**世代別の回収が切れ、戻らない**。1 回の小分けが終わるまではメッセージが待たされる。使えない環境ではログに出て、何も変えずに
`idle_gc` が false のままになる。
```ruby
def on_create
  self.idle_gc = true
end
```

### FmrbApp#idle_gc

<pre class="fmrb-sig"><code>idle_gc() -&gt; bool</code></pre>

ひまな時に片づけをするか

暇なときに GC を回す設定が入っているかどうか。
```ruby
idle_gc   #=> false (まだ頼んでいない)
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
