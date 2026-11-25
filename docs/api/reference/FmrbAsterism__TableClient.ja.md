# FmrbAsterism::TableClient

ゲームホストの卓につなぐ部品

使い方は [ネットワーク](../network.md) のページにあります。

ゲームホスト (アプリ名 "games") が持つ卓の一覧を探し、卓に入り (join)、見え (view) を取り、卓を出る (leave)。つなぎ直しは中の Link が行い、ホストがネットワークから消えて戻る場合も扱う。

**使い方**: on_create で作り、on_update で毎回 `update` が true の間にゲーム自分の呼び出し (`proxy`) の答えを集め、その後 `update_view` を呼ぶ。
on_destroy で `close`。

**アプリが持つ (呼ばれる) メソッド** — 部品がアプリを名前で呼ぶ (ブロックは渡さない)。**必須**:
- `table_state(path, state)` 卓の状態 (Hash) の put が来た。一覧が覚える値を返す (tables[path])
- `table_joined(reply)` join に token が返った (token は設定済み。続けて view を取りに行く)
- `table_refused(why)` join が断られた (why はホストの言葉)・答えが無い (why が nil)。table は nil に戻る
- `table_view(view)` 見え (Hash) が届いた無くてよい (持っていれば呼ぶ):
- `table_link_up(link)` つながるたび (購読と on_join / on_leave は設定済み)
- `table_link_down(link)` つなぎそこなった・切れた
- `table_watch` つながっている間の update ごと (状態を読む前)
- `tables_changed(added)` 卓が一覧に増えた (true)・ホストの卓が消えた (false)
- `table_host_gone` 入っている卓のホストが去った
- `table_host_back` そのホストが戻った (見えはまた取る)
- `table_view_failed` 見えに答えが無かった
- `table_dropped` ホストが自分を知らなくなった。無いと leave する
- `table_ask_view(px, token)` 見えの問い合わせを自分で出す (px は卓の async プロキシ)。Future を返す
**卓から出る・忘れるとき、入る答えを待っていると、その答えは捨てられる**
(次の join はすぐ出る)。見えの答えは、エラーでも「ホストはいる」の印になる。

```ruby
def on_create
  @tc = FmrbAsterism::TableClient.new(
    self, "othello", tag: "othello")
end
def on_update
  if @tc.update
    @tc.update_view
  end
  100
end
def on_destroy
  @tc.close
end
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`HOST_APP`</span> | [`String`](String.md) | ゲームホストのアプリ名の既定 |
| <span class="fmrb-name">`CALL_TIMEOUT`</span> | [`Float`](Float.md) | 呼び出しの待ち時間の既定 (秒) |
| <span class="fmrb-name">`VIEW_EVERY_MS`</span> | [`Integer`](Integer.md) | 見えを取り直す間隔の既定 (ms) |
| <span class="fmrb-name">`LIST_EVERY_MS`</span> | [`Integer`](Integer.md) | 卓の一覧を取り直す間隔の既定 (ms) |
| <span class="fmrb-name">`RESCAN_MS`</span> | [`Integer`](Integer.md) | 端末が来たあと卓を探し続ける時間の既定 (ms) |
| <span class="fmrb-name">`RESCAN_STEP_MS`</span> | [`Integer`](Integer.md) | その間の探す間隔の既定 (ms) |
| <span class="fmrb-name">`HOST_GONE_VIEW_MS`</span> | [`Integer`](Integer.md) | ホストが去っている間の見えの間隔の既定 (ms) |

## クラスメソッド

### FmrbAsterism::TableClient.new

<pre class="fmrb-sig"><code>new(
  untyped owner,
  <a href="../String/">String</a> kind,
  ?tag: <a href="../String/">String</a>?,
  ?app: <a href="../String/">String</a>,
  ?host_app: <a href="../String/">String</a>,
  ?retry_ms: <a href="../Integer/">Integer</a>?,
  ?wifi_wait_ms: <a href="../Integer/">Integer</a>?,
  ?settings: <a href="../FmrbAsterism__Settings/">FmrbAsterism::Settings</a>?,
  ?blank: untyped
) -&gt; FmrbAsterism::TableClient</code></pre>

作る (つなぐのは update)

owner はアプリ (self)。kind は卓の名前の始まり ("othello" なら
"<ホスト>/games/othello1" などを探す)。`tag:` (省略すると kind。ログの頭)、
`app:` (省略すると "game"。ネットワークでのこのアプリの名前)、
`host_app:` (省略すると "games"。探すホストのアプリ名)、
`retry_ms:` (省略すると 3000。nil なら 1 回だけつなぐ)、
`wifi_wait_ms:` (省略すると ESP32 だけ WiFi を待つ。sim・ブラウザ版は待たない)、
`settings:` (省略すると FmrbAsterism.settings)、
`blank:` (省略すると nil。まだ状態が来ていない卓について一覧が持つ値の見本。コピーを入れる。麻雀は {})。アプリが持つメソッド (table_state ほか) はクラスの説明を見る。
```ruby
@tc = FmrbAsterism::TableClient.new(
  self, "mahjong", blank: {})
```

## インスタンスメソッド

### FmrbAsterism::TableClient#update

<pre class="fmrb-sig"><code>update() -&gt; bool</code></pre>

毎回呼ぶ (つなぐ・状態・一覧・入る答え)

つながっている間に、届いた卓の状態を `table_state` に渡し、卓の一覧を探し、入ろうとした答えを集める。つながっていなければつなぐ (ルータが無いと数秒アプリが止まる。Link#update と同じ)。つながっている間 true。
```ruby
if @tc.update
  draw_table
end
```

### FmrbAsterism::TableClient#update_view

<pre class="fmrb-sig"><code>update_view(?<a href="../Integer/">Integer</a> now) -&gt; void</code></pre>

見えを集めて、時が来たら取りに行く

ゲーム自分の答えを集めたあとに呼ぶ。届いた見えを `table_view` に渡し、入っていて前の問い合わせが無く時が来ていれば、新しく問い合わせる。卓に入っていなければ何もしない。`now` (省略すると今の ms) はテスト用。
```ruby
@tc.update_view
```

### FmrbAsterism::TableClient#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

閉じる (on_destroy)

Link を閉じる。卓の leave はしないので、入っていれば先に自分で leave する。
```ruby
@tc.close
```

### FmrbAsterism::TableClient#net

<pre class="fmrb-sig"><code>net() -&gt; (:connecting | :up | :down)</code></pre>

つなぎの状態

:connecting は最初のつなぎの前、:up はつながっている、:down は失敗か切れ (つなぎ直し中)。
```ruby
show("net: #{@tc.net}")
```

### FmrbAsterism::TableClient#reconnecting?

<pre class="fmrb-sig"><code>reconnecting?() -&gt; bool</code></pre>

つなぎ直しの最中か

```ruby
dim if @tc.reconnecting?
```

### FmrbAsterism::TableClient#joining?

<pre class="fmrb-sig"><code>joining?() -&gt; bool</code></pre>

卓に入る答えを待っているか

```ruby
return if @tc.joining?
```

### FmrbAsterism::TableClient#host_gone?

<pre class="fmrb-sig"><code>host_gone?() -&gt; bool</code></pre>

入っている卓のホストが去っているか

```ruby
show("host gone") if @tc.host_gone?
```

### FmrbAsterism::TableClient#conn

<pre class="fmrb-sig"><code>conn() -&gt; <a href="../Asterism__Connection/">Asterism::Connection</a>?</code></pre>

つながり

Link の conn。つなぎ直すと別の物になる。
```ruby
c = @tc.conn
```

### FmrbAsterism::TableClient#link

<pre class="fmrb-sig"><code>link() -&gt; <a href="../FmrbAsterism__Link/">FmrbAsterism::Link</a></code></pre>

中の Link

状態や理由を画面に出すのに使う。close は TableClient#close に任せる。
```ruby
why = @tc.link.reason
```

### FmrbAsterism::TableClient#kind

<pre class="fmrb-sig"><code>kind() -&gt; <a href="../String/">String</a></code></pre>

卓の名前の始まり

```ruby
k = @tc.kind
```

### FmrbAsterism::TableClient#tables

<pre class="fmrb-sig"><code>tables() -&gt; <a href="../Hash/">Hash</a></code></pre>

卓の一覧 (道 => 持っている値)

table_state が返した値 (まだ来ていなければ blank のコピー)。道は
"<ホスト>/games/<卓>"。
```ruby
st = @tc.tables[@tc.table]
```

### FmrbAsterism::TableClient#table_list

<pre class="fmrb-sig"><code>table_list() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

卓の道の一覧 (並べ替え済み)

ホストが去ると、その卓は消える。
```ruby
@tc.table_list.each { |p| add(p) }
```

### FmrbAsterism::TableClient#table

<pre class="fmrb-sig"><code>table() -&gt; <a href="../String/">String</a>?</code></pre>

入っている (入ろうとしている) 卓の道

join した時点から決まり、leave・forget・断られた・答えが無いと nil に戻る。
```ruby
return unless @tc.table
```

### FmrbAsterism::TableClient#token

<pre class="fmrb-sig"><code>token() -&gt; <a href="../String/">String</a>?</code></pre>

卓での自分の印

ホストが join の答えで渡す。見えや手のたびにこれを渡す。
```ruby
px.play(@tc.token, 3)
```

### FmrbAsterism::TableClient#want_v

<pre class="fmrb-sig"><code>want_v() -&gt; <a href="../Integer/">Integer</a></code></pre>

知らされた卓の版

これが view_v より大きいと、見えを取り直す時になる。
```ruby
stale = @tc.want_v > @tc.view_v
```

### FmrbAsterism::TableClient#view_v

<pre class="fmrb-sig"><code>view_v() -&gt; <a href="../Integer/">Integer</a></code></pre>

取れた見えの版

```ruby
v = @tc.view_v
```

### FmrbAsterism::TableClient#proxy

<pre class="fmrb-sig"><code>proxy(?<a href="../String/">String</a> path) -&gt; <a href="../Asterism__Proxy/">Asterism::Proxy</a></code></pre>

卓の相手に呼び出す入口

`proxy` は入っている卓、`proxy(path)` は別の道。呼び出しの待ち時間は
call_timeout。待たずに呼ぶなら `proxy.async`。つながっていないと
Asterism::Disconnected、道が無い (卓に入っていない) と ArgumentError。
```ruby
f = @tc.proxy.async.play(@tc.token, 3)
```

### FmrbAsterism::TableClient#join

<pre class="fmrb-sig"><code>join(<a href="../String/">String</a>? path, <a href="../String/">String</a> name) -&gt; <a href="../String/">String</a>?</code></pre>

卓に入る

呼び出しを出して戻る (答えは update が集め、table_joined か table_refused になる)。すでに入る答えを待っている・path が nil なら何もせず nil。送れなかったら、その失敗の文 (String) を返し、table は nil に戻る。つながっているときに呼ぶ。
```ruby
err = @tc.join(path, "Aki")
show(err) if err
```

### FmrbAsterism::TableClient#leave

<pre class="fmrb-sig"><code>leave() -&gt; void</code></pre>

卓を出る

入っていれば卓の leave を待たずに呼び、table・token などを忘れる。呼べなくても例外は出ない。
```ruby
@tc.leave
```

### FmrbAsterism::TableClient#forget

<pre class="fmrb-sig"><code>forget() -&gt; void</code></pre>

卓のことを忘れる (ホストには知らせない)

入る答えを待っていれば、その答えは捨てる (次の join はすぐ出る)。
```ruby
@tc.forget
```

### FmrbAsterism::TableClient#ask_view

<pre class="fmrb-sig"><code>ask_view() -&gt; void</code></pre>

見えを今取りに行く

前の問い合わせが済んでいない・卓に入っていない (token が nil) と何もしない。問い合わせが出せなければ黙ってやめる。アプリに
`table_ask_view` があればそれが問い合わせを出す。
```ruby
@tc.ask_view
```

### FmrbAsterism::TableClient#refresh_view

<pre class="fmrb-sig"><code>refresh_view() -&gt; void</code></pre>

見えを取り直す

ゲーム自分の呼び出し (手を打つなど) の答えが届いたあとに呼ぶ。
```ruby
@tc.refresh_view
```

### FmrbAsterism::TableClient#call_timeout

<pre class="fmrb-sig"><code>call_timeout() -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

呼び出しの待ち時間 (秒)

```ruby
@tc.call_timeout = 5.0
```

### FmrbAsterism::TableClient#call_timeout=

<pre class="fmrb-sig"><code>call_timeout=(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)</code></pre>

呼び出しの待ち時間を決める (秒)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.call_timeout = 5.0
```

### FmrbAsterism::TableClient#view_every_ms

<pre class="fmrb-sig"><code>view_every_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

見えを取り直す間隔 (ms)

取り直しはホストに「まだいる」と知らせることにもなる。
```ruby
@tc.view_every_ms = 5000
```

### FmrbAsterism::TableClient#view_every_ms=

<pre class="fmrb-sig"><code>view_every_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

見えを取り直す間隔を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.view_every_ms = 5000
```

### FmrbAsterism::TableClient#view_min_ms

<pre class="fmrb-sig"><code>view_min_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

見えを取る最短の間隔 (ms)

版が上がっても、前に取ってからこの時間が経つまでは待つ。
```ruby
@tc.view_min_ms = 1000
```

### FmrbAsterism::TableClient#view_min_ms=

<pre class="fmrb-sig"><code>view_min_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

見えの最短の間隔を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.view_min_ms = 1000
```

### FmrbAsterism::TableClient#list_every_ms

<pre class="fmrb-sig"><code>list_every_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

卓の一覧を探し直す間隔 (ms)

```ruby
@tc.list_every_ms = 10000
```

### FmrbAsterism::TableClient#list_every_ms=

<pre class="fmrb-sig"><code>list_every_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

卓の一覧を探し直す間隔を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.list_every_ms = 10000
```

### FmrbAsterism::TableClient#rescan_ms

<pre class="fmrb-sig"><code>rescan_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

一覧を探し続ける時間 (ms)

```ruby
@tc.rescan_ms = 5000
```

### FmrbAsterism::TableClient#rescan_ms=

<pre class="fmrb-sig"><code>rescan_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

一覧を探し続ける時間を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.rescan_ms = 5000
```

### FmrbAsterism::TableClient#rescan_step_ms

<pre class="fmrb-sig"><code>rescan_step_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

その間に探す間隔 (ms)

```ruby
@tc.rescan_step_ms = 500
```

### FmrbAsterism::TableClient#rescan_step_ms=

<pre class="fmrb-sig"><code>rescan_step_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

その間の探す間隔を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.rescan_step_ms = 500
```

### FmrbAsterism::TableClient#host_gone_view_ms

<pre class="fmrb-sig"><code>host_gone_view_ms() -&gt; <a href="../Integer/">Integer</a></code></pre>

ホストが去っている間の見えの間隔 (ms)

ホストが戻ったと知らせが来なくても、この間隔で見えを取りに行って確かめる。
```ruby
@tc.host_gone_view_ms = 10000
```

### FmrbAsterism::TableClient#host_gone_view_ms=

<pre class="fmrb-sig"><code>host_gone_view_ms=(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

去ったホストへの見えの間隔を決める (ms)

値は読み書きのどちらでも同じ単位。
```ruby
@tc.host_gone_view_ms = 10000
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
