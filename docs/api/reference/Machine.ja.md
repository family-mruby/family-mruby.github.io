# Machine

時刻と待ち、機種の判別

使い方は [タスク・時間](../system.md) のページにあります。

時刻は `board_millis` (ms)・`uptime_us` (マイクロ秒)、待ちは `delay_ms`・`busy_wait_ms`、機種の判別は `posix?`。**ESP32 の実機と Linux・ブラウザ版で振る舞いが違うものがある**
(メソッドごとの長文に書いた)。
```ruby
t0 = Machine.board_millis
```

## クラスメソッド

### Machine.board_millis

<pre class="fmrb-sig"><code>board_millis() -&gt; <a href="../Integer/">Integer</a></code></pre>

起動からの時間 (ms)

経過時間を測るのに使う。2 回の値の**差**を取る。

単位はミリ秒で、整数は 64 ビット (どのビルドも `MRB_INT64`) なので一周は気にしなくてよい。
**数え始めがビルドで違う**: ESP32 は端末の起動から、Linux・ネイティブ版は**ホストの起動から**
(端末の起動からではない)、ブラウザ版はプログラムの開始から。値そのものに意味を持たせず、差だけを使う。

別の VM から運ばれてきたアプリ (checkpoint) では、元の VM で見ていた値の続きになる
(この端末の値に元の VM とのずれが足される)。`uptime_us` にはこのずれが足されない。
```ruby
t0 = Machine.board_millis
elapsed = Machine.board_millis - t0
```

### Machine.uptime_us

<pre class="fmrb-sig"><code>uptime_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

起動からの時間 (マイクロ秒)

`board_millis` より細かい測りに使う。数え始めは `board_millis` と同じ (ESP32 は端末の起動、
Linux・ネイティブ版はホストの起動、ブラウザ版はプログラムの開始)。
**checkpoint で運ばれたアプリでも、ずれは足されない**。整数は 64 ビット。
```ruby
t = Machine.uptime_us
work
dt = Machine.uptime_us - t
```

### Machine.uptime_formatted

<pre class="fmrb-sig"><code>uptime_formatted() -&gt; <a href="../String/">String</a></code></pre>

起動からの時間を文字列で

```ruby
Machine.uptime_formatted  #=> "0d 00:12:34.56"
```

### Machine.delay_ms

<pre class="fmrb-sig"><code>delay_ms(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

アプリごと止めて待つ (ms)

指定した ms の間、**このアプリのタスクごと止める**。待つ間は `on_update` もイベントの処理も進まず、同じ VM の Task にも切り替わらない。Task を切り替えて待つ `sleep_ms`
とは違い、`_spin` の外 (起動の手順など) でも止まる。

ms が負だと ArgumentError。戻り値は渡した ms。

**待つ長さの細かさは機種で違う**。ESP32 は 1 ms 刻み (FreeRTOS の tick) で待つ。
Linux・ネイティブ版は 10 ms 刻みで実時間を見て待つので、指定より最大で約 10 ms 長くなる。
(2026-11-25 より前のファームの ESP32 は、指定の約 1/10 しか待たなかった。)
```ruby
Machine.delay_ms(100)
```

### Machine.busy_wait_ms

<pre class="fmrb-sig"><code>busy_wait_ms(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

CPU を回して待つ (ms)

ms が負だと ArgumentError。戻り値は渡した ms。

**ESP32 では他の仕事を止めて CPU を回す** (`ets_delay_us(1000 * ms)`)。長い待ちには使わず、`delay_ms` か `sleep_ms` を使う。Linux・ネイティブ版は `nanosleep` を 1 回呼ぶだけで、
CPU は回さず、シグナルで割り込まれると**短く切り上がる**ことがある。
```ruby
Machine.busy_wait_ms(2)
```

### Machine.sleep

<pre class="fmrb-sig"><code>sleep(<a href="../Integer/">Integer</a> sec) -&gt; <a href="../Integer/">Integer</a></code></pre>

秒単位で眠る (軽いスリープ)

sec は秒で、**2 以上 86399 以下**。負や 86400 以上は ArgumentError。**2 未満は眠らず**、警告 ("Cannot sleep less than 2 sec") を出して戻る。眠る前にも警告を出す。戻り値は渡した sec。

ESP32 は chip ごとの light sleep (`esp_light_sleep_start`) に入る。
**Linux・ネイティブ版は何もせず、すぐ戻る**。アプリの待ちには使わず、`delay_ms` か `sleep_ms` を使う。
```ruby
Machine.sleep(5)
```

### Machine.deep_sleep

<pre class="fmrb-sig"><code>deep_sleep(<a href="../Integer/">Integer</a> gpio_pin, bool edge, bool high) -&gt; bot</code></pre>

ディープスリープ (未実装)

**このビルドでは呼ぶと必ず NotImplementedError** (引数は見ない)。
```ruby
begin
  Machine.deep_sleep(5, true, false)
rescue NotImplementedError
end
```

### Machine.unique_id

<pre class="fmrb-sig"><code>unique_id() -&gt; (<a href="../String/">String</a> | nil)</code></pre>

端末の固有 ID を返す

**ESP32 は MAC アドレスを 12 桁の 16 進 (大文字)** で返す。
**Linux・ネイティブ版は `/etc/machine-id` の 32 桁** (ホストの ID)。読めないときは **nil** (ブラウザ版などファイルが無い所)。
```ruby
id = Machine.unique_id
```

### Machine.read_memory

<pre class="fmrb-sig"><code>read_memory(<a href="../Integer/">Integer</a> address, <a href="../Integer/">Integer</a> size) -&gt; <a href="../String/">String</a></code></pre>

生のアドレスからバイトを読む

address 番地から size バイトを新しい文字列 (バイナリ) にして返す。**番地は確かめない**ので、読めない番地を渡すと本体ごと落ちる。デバッグ用。
```ruby
s = Machine.read_memory(addr, 16)
```

### Machine.stack_usage

<pre class="fmrb-sig"><code>stack_usage() -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

スタックの使用量 (未対応)

**今のビルドでは常に nil** (ESP32・Linux とも実装が 0 を返し、0 のときは nil にする)。
```ruby
Machine.stack_usage  #=> nil
```

### Machine.set_hwclock

<pre class="fmrb-sig"><code>set_hwclock(<a href="../Integer/">Integer</a> tv_sec) -&gt; true</code></pre>

システム時計を合わせる

tv_sec は UNIX 時刻 (1970 年からの秒、UTC)。**ESP32 だけ**。成功すると true。
**Linux・ネイティブ版・ブラウザ版は NotImplementedError** を出す (これは
StandardError ではなく ScriptError なので、`rescue => e` では受けられない。呼ぶ前に
`Machine.posix?` で分ける)。RTC チップへは書かない。
```ruby
Machine.set_hwclock(epoch) unless Machine.posix?
```

### Machine.get_hwclock

<pre class="fmrb-sig"><code>get_hwclock() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

システム時計を読む

`[秒, ナノ秒]` の配列 (UNIX 時刻の UTC)。**ESP32 だけ**。
**Linux・ネイティブ版・ブラウザ版は NotImplementedError** (`rescue => e` では受けられない)。
```ruby
sec, nsec = Machine.get_hwclock
```

### Machine.exit

<pre class="fmrb-sig"><code>exit(?<a href="../Integer/">Integer</a> status) -&gt; nil</code></pre>

プログラムを終える

**ESP32 では何もしない** (nil を返すだけ)。
**Linux・ネイティブ版では本体のプロセスごと終わる** ので、アプリから呼ばない。アプリを閉じるのは `FmrbApp#stop`。
```ruby
Machine.exit(0)
# Linux では本体ごと終わる
```

### Machine.reboot

<pre class="fmrb-sig"><code>reboot(?<a href="../Integer/">Integer</a> wait_ms) -&gt; nil</code></pre>

再起動する (このビルドでは使えない)

wait_ms (省略すると 0) だけ待ってから再起動しようとする。
**ESP32 では NotImplementedError** (ウォッチドッグの gem が入っていない)。Linux・ネイティブ版は終了コード 120 でプロセスを終える。端末を再起動するのは `FmrbSystem.reboot`。
```ruby
Machine.reboot(1000)
# Linux では終了コード 120
```

### Machine.posix?

<pre class="fmrb-sig"><code>posix?() -&gt; bool</code></pre>

Linux 系 (POSIX) の版か

**Linux・ネイティブ版・ブラウザ版で true、ESP32 の実機で false**
(`RUBY_PLATFORM` が "ESP32" でなければ true)。実機にしか無い呼び出し
(`set_hwclock` など) を分けるのに使う。
```ruby
if Machine.posix?
  # simulator
end
```

### Machine.wifi_available?

<pre class="fmrb-sig"><code>wifi_available?() -&gt; bool</code></pre>

Wi-Fi を使える版か

`Network::WiFi` が定義されていれば true。
**Family mruby にはこの定義が見つからず、今は常に false** (Wi-Fi の状態は `FmrbApp` と `FmrbNet` で調べる)。
```ruby
Machine.wifi_available?  #=> false
```

### Machine.tud_task

<pre class="fmrb-sig"><code>tud_task() -&gt; nil</code></pre>

USB デバイスの処理を 1 回回す

**この版では中身が空** (ESP32・Linux とも何もせず nil)。
```ruby
Machine.tud_task  #=> nil
```

### Machine.tud_mounted?

<pre class="fmrb-sig"><code>tud_mounted?() -&gt; bool</code></pre>

USB がつながっているか

**ESP32 は常に false、Linux・ネイティブ版は常に true** (実際の接続は見ない)。
```ruby
Machine.tud_mounted?
# ESP32 は false、Linux は true
```

### Machine.bootsel_pressed?

<pre class="fmrb-sig"><code>bootsel_pressed?() -&gt; bool</code></pre>

BOOTSEL ボタンを押しているか (使えない)

RP2 系の機種の機能。**このビルドでは呼ぶと必ず NotImplementedError**。
```ruby
begin
  Machine.bootsel_pressed?
rescue NotImplementedError
end
```

### Machine.check_signal

<pre class="fmrb-sig"><code>check_signal() -&gt; nil</code></pre>

受け取った Ctrl-C を例外にする

受けていれば Interrupt ("SIGINT")、Ctrl-Z なら SignalException ("SIGTSTP") を出す。何も無ければ nil。受け取るのは **Linux・ネイティブ版の標準入力だけ** (ESP32 には受け取る所が無く、いつも nil)。
```ruby
begin
  Machine.check_signal
rescue Interrupt
end
```

### Machine.poll_signal

<pre class="fmrb-sig"><code>poll_signal() -&gt; (<a href="../Symbol/">Symbol</a> | nil)</code></pre>

受け取った Ctrl-C を Symbol で返す

`check_signal` の例外を出さない版。Ctrl-C なら `:INT`、Ctrl-Z なら `:TSTP`、何も無ければ nil。
```ruby
case Machine.poll_signal
when :INT then stop
end
```

### Machine.signal_self_manage

<pre class="fmrb-sig"><code>signal_self_manage() -&gt; true</code></pre>

シグナルを自分で扱うと印を付ける

印を立てるだけ (`pop_signal_self_manage` で読み出して下ろす)。
```ruby
Machine.signal_self_manage  #=> true
```

### Machine.pop_signal_self_manage

<pre class="fmrb-sig"><code>pop_signal_self_manage() -&gt; bool</code></pre>

シグナルの印を読んで下ろす

`signal_self_manage` の印が立っていれば true を返し、印を下ろす。
```ruby
Machine.signal_self_manage
Machine.pop_signal_self_manage #=> true
```

### Machine.debug_puts

<pre class="fmrb-sig"><code>debug_puts(*untyped messages) -&gt; nil</code></pre>

診断のメッセージを標準エラーへ出す

引数ごとに `to_s` して 1 行ずつ出す。**ESP32 だけ**で、Linux・ネイティブ・ブラウザ版にはこのメソッドが無い (呼ぶと NoMethodError)。
```ruby
Machine.debug_puts("x=#{x}")
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
