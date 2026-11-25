# FmrbSystem

端末の設定とサービス

使い方は [アプリ](../fmrb_app.md) のページにあります。

Wi-Fi・BLE・電源・時計・音の設定・PC の設定を変える。状態を読むだけのものは FmrbApp にある。
```ruby
FmrbSystem.set_audio_mute(true)
```

## クラスメソッド

### FmrbSystem.set_wallclock

<pre class="fmrb-sig"><code>set_wallclock(
  <a href="../Integer/">Integer</a> year,
  <a href="../Integer/">Integer</a> month,
  <a href="../Integer/">Integer</a> day,
  <a href="../Integer/">Integer</a> hour,
  <a href="../Integer/">Integer</a> minute,
  <a href="../Integer/">Integer</a> second
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

日付と時刻を合わせる

渡すのは**地方時**。戻ってくるのは同じ時刻の UTC。**端末でしか効かない**
(Linux とブラウザでは何もしない)。
```ruby
FmrbSystem.set_wallclock(2026, 9, 1,
                         12, 0, 0)
```

### FmrbSystem.reboot

<pre class="fmrb-sig"><code>reboot() -&gt; void</code></pre>

機械を再起動する

機械ごと再起動する。**戻ってこない**。端末専用。
```ruby
FmrbSystem.reboot
```

### FmrbSystem.set_audio_mute

<pre class="fmrb-sig"><code>set_audio_mute(bool on) -&gt; void</code></pre>

本体の音を消す・戻す

true で消音。音は鳴り続けたまま出力だけ無音になる (スピーカのミュート)。少し後 (約 2 秒) に設定に保存され、再起動後も残る。外部 MIDI 出力は止めない。
```ruby
FmrbSystem.set_audio_mute(true)
```

### FmrbSystem.set_audio_volume

<pre class="fmrb-sig"><code>set_audio_volume(<a href="../Integer/">Integer</a> step) -&gt; void</code></pre>

本体の音量を変える (0-10)

0 は無音、10 が最大。ミュートとは別で、ミュートを外すとこの音量に戻る。設定に保存され、再起動後も残る。
```ruby
FmrbSystem.set_audio_volume(5)
```

### FmrbSystem.preview_audio_volume

<pre class="fmrb-sig"><code>preview_audio_volume(<a href="../Integer/">Integer</a> step) -&gt; void</code></pre>

音量を保存せずに試す

設定画面の試聴用。保存は audio_conf_saved か set_audio_volume で。
```ruby
FmrbSystem.preview_audio_volume(v)
```

### FmrbSystem.audio_conf_saved

<pre class="fmrb-sig"><code>audio_conf_saved() -&gt; void</code></pre>

設定ファイルに音の設定を書いたと知らせる

system_conf に今の消音と音量を自分で書いた後に呼ぶ。待っている保存を取り消す。
```ruby
FmrbSystem.audio_conf_saved
```

### FmrbSystem.remote_access

<pre class="fmrb-sig"><code>remote_access() -&gt; <a href="../Integer/">Integer</a></code></pre>

遠隔操作の許可の状態

リリースのビルドの WiFi の遠隔操作。-1 はここに無い (開発のビルドは許可なしで使える)、0 は閉じている、1 は開いている (閉じるまで、再起動しても残る)。
```ruby
FmrbSystem.remote_access
# -1、0 か 1
```

### FmrbSystem.remote_access_code

<pre class="fmrb-sig"><code>remote_access_code() -&gt; <a href="../Integer/">Integer</a></code></pre>

PC に入れてもらう番号

「PC を登録」を開いている間に画面に出す 6 桁の番号。無いときは -1、番号違いが続いて止まっているときは -2。
```ruby
code = FmrbSystem.remote_access_code
sprintf('%06d', code) if code >= 0
```

### FmrbSystem.set_remote_access

<pre class="fmrb-sig"><code>set_remote_access(bool on) -&gt; void</code></pre>

遠隔操作を開く・閉じる

閉じるまで残る (再起動しても)。閉じると開いている接続も切る。
```ruby
FmrbSystem.set_remote_access(true)
```

### FmrbSystem.set_remote_pairing

<pre class="fmrb-sig"><code>set_remote_pairing(bool on) -&gt; void</code></pre>

PC の登録を受け付ける・やめる

受け付けている間だけ番号が出て、新しい PC が登録できる。開くたびに新しい番号になり、番号違いの停止も解ける。登録済みの PC はこれに関係なく使える。
```ruby
FmrbSystem.set_remote_pairing(true)
FmrbSystem.set_remote_pairing(false)
```

### FmrbSystem.remote_access_paired

<pre class="fmrb-sig"><code>remote_access_paired() -&gt; <a href="../Integer/">Integer</a></code></pre>

登録した PC の数

リリースのビルドで、遠隔操作に登録済みの PC の数。遠隔操作の守りが無いビルドでは 0。
`revoke_remote_access` で全部取り消すと 0 に戻る。
```ruby
n = FmrbSystem.remote_access_paired
FmrbSystem.revoke_remote_access
FmrbSystem.remote_access_paired  #=> 0
```

### FmrbSystem.revoke_remote_access

<pre class="fmrb-sig"><code>revoke_remote_access() -&gt; bool</code></pre>

登録した PC を全部取り消す

保存できたら true。
```ruby
FmrbSystem.revoke_remote_access
```

### FmrbSystem.ble_start

<pre class="fmrb-sig"><code>ble_start() -&gt; bool</code></pre>

Bluetooth をはじめる

BLE を手で起動する。Retro 用。
```ruby
ok = FmrbSystem.ble_start
```

### FmrbSystem.ble_state

<pre class="fmrb-sig"><code>ble_state() -&gt; <a href="../Integer/">Integer</a></code></pre>

Bluetooth の様子

```ruby
st = FmrbSystem.ble_state
```

### FmrbSystem.ble_settings_window

<pre class="fmrb-sig"><code>ble_settings_window(<a href="../Integer/">Integer</a> seconds) -&gt; <a href="../Integer/">Integer</a></code></pre>

BLE で設定を受け付ける時間を開く

秒数だけ開き (0 で閉じる)、残りの秒数を返す。開けなかったときは 0。開いている間だけ、BLE のコンソールが WiFi と Asterism の設定を書ける。

### FmrbSystem.ble_settings_left

<pre class="fmrb-sig"><code>ble_settings_left() -&gt; <a href="../Integer/">Integer</a></code></pre>

設定を受け付ける時間の残り秒数

閉じていれば 0。
```ruby
left = FmrbSystem.ble_settings_left
# 秒。閉じていれば 0
```

### FmrbSystem.rd_stream_state

<pre class="fmrb-sig"><code>rd_stream_state() -&gt; <a href="../Integer/">Integer</a></code></pre>

画面を配信中かどうかの様子

遠隔デスクトップに誰か繋がっているか。
```ruby
FmrbSystem.rd_stream_state > 0
# 誰かが見ている
```

### FmrbSystem.power_actions

<pre class="fmrb-sig"><code>power_actions() -&gt; <a href="../Array/">Array</a></code></pre>

電源のメニューにある操作

`:reset`・`:exit`・`:power_off`・`:restart`・`:suspend`・`:lock` のうちこの端末でできるもの。端末は `[:reset]`、sim とブラウザ版は空。
```ruby
FmrbSystem.power_actions
```

### FmrbSystem.power

<pre class="fmrb-sig"><code>power(<a href="../Symbol/">Symbol</a> action) -&gt; bool</code></pre>

電源の操作を 1 つ行う

できない操作なら false。
```ruby
FmrbSystem.power(:reset)
```

### FmrbSystem.linux_apps

<pre class="fmrb-sig"><code>linux_apps(<a href="../Integer/">Integer</a> mode, <a href="../String/">String</a> lang) -&gt; <a href="../String/">String</a></code></pre>

PC のアプリの一覧 (ランチャー用)

ネイティブ版がコンポジタのときだけ中身がある。ほかは "" 。
1 行目が見出し、mode 0 なら続けて 1 つずつ "名前\tid\tアイコン"。
mode 1 は読み直し、mode 2 は見出しだけ。
```ruby
FmrbSystem.linux_apps(0, "ja")
```

### FmrbSystem.linux_launch

<pre class="fmrb-sig"><code>linux_launch(<a href="../Integer/">Integer</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

PC のアプリを起動する

頼めたら 0、無いときは -1。待たない。
```ruby
FmrbSystem.linux_launch(id)
```

### FmrbSystem.linux_handlers

<pre class="fmrb-sig"><code>linux_handlers(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

ファイルを開ける PC のアプリ

1 行に 1 つ。ネイティブ版だけ、ほかは "" 。
```ruby
FmrbSystem.linux_handlers(
  "/home/a.png")
```

### FmrbSystem.linux_open

<pre class="fmrb-sig"><code>linux_open(<a href="../Integer/">Integer</a> id, <a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

PC のアプリでファイルを開く

頼めたら ""、だめなら理由。
```ruby
FmrbSystem.linux_open(id, path)
```

### FmrbSystem.wifi_networks

<pre class="fmrb-sig"><code>wifi_networks(bool scan) -&gt; <a href="../String/">String</a></code></pre>

Wi-Fi の網の一覧

Wi-Fi の画面の文。Family mruby が網を選ばない所 (sim・ブラウザ版) では
"" 。true を渡すと探し直しも頼む。
```ruby
FmrbSystem.wifi_networks(true)
```

### FmrbSystem.wifi_connect

<pre class="fmrb-sig"><code>wifi_connect(<a href="../String/">String</a> ssid, <a href="../String/">String</a> password) -&gt; bool</code></pre>

Wi-Fi の網につなぐ

```ruby
FmrbSystem.wifi_connect("home",
                        "secret")
```

### FmrbSystem.wifi_disconnect

<pre class="fmrb-sig"><code>wifi_disconnect() -&gt; bool</code></pre>

Wi-Fi の網から離れる

```ruby
FmrbSystem.wifi_disconnect
```

### FmrbSystem.wifi_forget

<pre class="fmrb-sig"><code>wifi_forget(<a href="../String/">String</a> ssid) -&gt; bool</code></pre>

覚えた Wi-Fi の網を忘れる

```ruby
FmrbSystem.wifi_forget("home")
```

### FmrbSystem.bt_devices

<pre class="fmrb-sig"><code>bt_devices() -&gt; <a href="../String/">String</a></code></pre>

Bluetooth の機器の一覧

PC だけ。ほかは "" 。
```ruby
FmrbSystem.bt_devices != ""
# PC なら true
```

### FmrbSystem.bt_power

<pre class="fmrb-sig"><code>bt_power(bool on) -&gt; bool</code></pre>

Bluetooth を入れる・切る

```ruby
FmrbSystem.bt_power(true)
```

### FmrbSystem.bt_connect

<pre class="fmrb-sig"><code>bt_connect(<a href="../String/">String</a> address, bool on) -&gt; bool</code></pre>

Bluetooth の機器とつなぐ・離す

```ruby
FmrbSystem.bt_connect(addr, true)
```

### FmrbSystem.notices_gen

<pre class="fmrb-sig"><code>notices_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

PC の知らせが変わった回数

知らせの無い端末では -1。
```ruby
g = FmrbSystem.notices_gen
# 知らせの無い端末では -1
```

### FmrbSystem.notices

<pre class="fmrb-sig"><code>notices() -&gt; <a href="../String/">String</a></code></pre>

PC の知らせの一覧

1 行に 1 つ "id\t種類\tアプリ\t文\t本文"。無い端末では "" 。
```ruby
text = FmrbSystem.notices
lines = text.split("\n")
```

### FmrbSystem.notice_dismiss

<pre class="fmrb-sig"><code>notice_dismiss(<a href="../Integer/">Integer</a> id) -&gt; void</code></pre>

PC の知らせを消す

```ruby
FmrbSystem.notice_dismiss(id)
```

### FmrbSystem.wl_window

<pre class="fmrb-sig"><code>wl_window() -&gt; (<a href="../String/">String</a> | bool | nil)</code></pre>

代役の Linux の Window の題

Linux の Window があれば題、閉じたら false、代役でなければ nil。ネイティブ版にだけある。
```ruby
st = FmrbSystem.wl_window
# 題。閉じたら false、
# 代役でなければ nil
```

### FmrbSystem.wl_close

<pre class="fmrb-sig"><code>wl_close() -&gt; bool</code></pre>

Linux の Window を閉じるよう頼む

保存の確認をしたり断ったりするのはその Window のプログラム。ネイティブ版だけ。
```ruby
if FmrbSystem.wl_close
  redraw_close_button
end
```

### FmrbSystem.wl_key

<pre class="fmrb-sig"><code>wl_key() -&gt; <a href="../Integer/">Integer</a></code></pre>

自分のキャンバスの透ける色 (ネイティブ版だけ)

代役が角の外を塗る色 (RGB332)。
```ruby
key = FmrbSystem.wl_key
```

### FmrbSystem.linux_keyboard

<pre class="fmrb-sig"><code>linux_keyboard() -&gt; <a href="../String/">String</a></code></pre>

Linux のキーボードの配列 (ネイティブ版だけ)

"jp" か "us"。keyboard_layout = "auto" がこれに従う。
```ruby
FmrbSystem.linux_keyboard
# ネイティブ版だけ
```

### FmrbSystem.linux_settings

<pre class="fmrb-sig"><code>linux_settings(<a href="../String/">String</a> page) -&gt; bool</code></pre>

PC の設定の Window を開く (ネイティブ版だけ)

"wifi"・"bluetooth"・"display" のページで開く。
```ruby
FmrbSystem.linux_settings("wifi")
```

### FmrbSystem.settings_page

<pre class="fmrb-sig"><code>settings_page() -&gt; <a href="../Integer/">Integer</a></code></pre>

PC の設定で頼まれたページ

ネイティブ版だけ。下の 2 ビットがページ (0 Wi-Fi、1 Bluetooth、2 Display)、その上が頼まれた回数。
```ruby
n = FmrbSystem.settings_page
page = n & 3
# 0 Wi-Fi, 1 Bluetooth, 2 Display
```

### FmrbSystem.crt_set

<pre class="fmrb-sig"><code>crt_set(
  bool crt,
  <a href="../Integer/">Integer</a> scanline,
  <a href="../Integer/">Integer</a> mask,
  <a href="../Integer/">Integer</a> glow,
  <a href="../Integer/">Integer</a> curve,
  <a href="../Integer/">Integer</a> vignette,
  <a href="../Integer/">Integer</a> ntsc,
  <a href="../Integer/">Integer</a> flicker,
  <a href="../Integer/">Integer</a> noise
) -&gt; bool</code></pre>

ブラウン管の見た目を変える (ネイティブ版だけ)

crt と 8 つの強さ (走査線・マスク・にじみ・曲がり・周辺減光・NTSC・ちらつき・ノイズ)。描けない所では false。
```ruby
FmrbSystem.crt_set(true, 55, 30,
  30, 15, 40, 0, 0, 0)
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
