# システムサービス (`services.toml`)

サービスとは、常駐する小さな仕事のことです。タイマーで起きるか、何かが配信されたときに
起き、窓は持ちません。ネットワークから自分を合わせる時計がそうですし、文章を読み上げる
ものもそうです。

これらは全部、サービスホストという 1 つのアプリの中で動きます。小さな常駐仕事が 12 個
あっても、タスクと VM は 1 つずつで済みます。アプリとして常駐させずにサービスにする理由が
そこにあります。

!!! note "Modern 専用"
    サービスホストは Retro のファームウェアには入っていません。Retro では以下は何も
    当てはまりません。Retro のシミュレータも同じ振る舞いをします。

## 付いてくるもの

| サービス | 内容 |
|---|---|
| `clock` | 時刻を保ちます |
| `hourly_chime` | 毎正時に音を鳴らします。WAV を指定すればそれを鳴らします |
| `net` | ネットワークを見張り、`net/state` を配信します。アドレスが決まった瞬間にログに出ます |
| `timesync` | ネットワークにつながったら NTP で時計を合わせます。停電のたびに時計合わせをしなくて済みます |
| `tts` | 声に出して読みます。`tts/say` に配信されたものが読み上げられます |

[Studio](../getting_started/studio.md) には最初の 2 つが入っています。ブラウザのタブには
合わせるべき時計も、呼ぶべきスピーカーもありません。

## 一覧は 2 つある

| ファイル | 本体の置き場所 | |
|---|---|---|
| `/etc/services.toml` | `/usr/share/services/` | ファームウェアに付いてくるもの |
| `/home/services.toml` | `/home/services/` | あなたのもの。後から読まれ、項目ごとに勝ちます |

項目ごとに勝つので、利用者側の一覧は短くて済みます。付いてくるサービスを止めたいなら、
ファイルの中身はこれだけです。

```toml
[hourly_chime]
enable = false
```

## 項目

| 項目 | |
|---|---|
| `file` | 本体のファイル名。その一覧に対応する置き場所から探します |
| `class` | その中のクラス名 |
| `enable` | `false` にすると、項目は残したまま動かしません。既定は `true` |
| `interval_ms` | `on_tick` を呼ぶ間隔。話題に反応するだけのサービスでは省けます |
| `oneshot` | `true` なら起動時に `on_start` を 1 回呼び、一覧から外します |
| `[<名前>.config]` | `ctx.config` としてサービスに渡されます |

## 自分で書く

見本を写して一覧に載せます。

```
cp /usr/share/samples/services/services.toml.example /home/services.toml
cp /usr/share/samples/services/heartbeat.rb /home/services/heartbeat.rb
```

決まりごとは、任意の 5 つのメソッドだけです。

```ruby
class HeartbeatService
  def on_start(ctx)          # ctx がシステムの他の部分への唯一の出口
  def on_tick(now_ms)        # interval_ms ごと
  def on_wake(now_ms)        # ctx.wake_in の後
  def on_event(topic, data)
  def on_stop
end
```

`ctx` からは `publish`、`wake_in`、`audio`、`log`、`now_ms`、`config`、`stop_self` が
使えます。

どのメソッドも短く保ってください。サービスは 1 本のタスクの上で順番に動くので、ここで
使った時間はそのまま他のサービスの待ち時間になります (50ms を超えるとホストが警告を
出します)。例外を出したサービスは 3 回で自動的に止まります。他のサービスは巻き添えに
なりません。

## 起動時にアプリを開く

サービスの代わりにアプリを指定することもできます。

```toml
[my_game]
app = "/app/game/robo_explorer/robo_explorer.app.rb"
fullscreen = true      # アプリ自身の窓の指定より優先
delay_ms = 2000        # デスクトップが落ち着くのを待つ
restart = true         # 落ちたら起動し直す (kill したものは止まったまま)
```

## 止め方

2 通りあり、意味が違います。

| | |
|---|---|
| `svc stop <名前>` (または `kill <名前>`) | そのときだけ。再起動すると戻ります |
| `svc disable <名前>` | 覚えます。再起動しても止まったままです |

`svc start` と `svc enable` が対になります。覚えた内容は `/home/services_state.toml` に
ホストが書きます。あなたの `services.toml` が書き換えられることはありません。シェルの
`ps` はアプリと並べてサービスも出します。Monitor も同じです。

## 読み上げ

`tts` は配信された文章を音声にします。一度読んだ文章は WAV として `/tmp` に残ります。
`/tmp` はフラッシュではなく PSRAM です。音声は 1 回で数百キロバイトあり、フラッシュは
小さく、書き換えれば減るからです。2 回目からはネットワークなしでそこから鳴り、再起動すると
消えます。

音声の作り方は 2 通りあります。

```toml
[tts.config]
server = "http://192.168.10.5:50021"   # パソコンで動かす VOICEVOX
speaker = 1
timeout_ms = 3000
```

```toml
[tts.config]
api_key = "sk-..."                     # パソコンなしで、クラウドで合成する
cloud_model = "gpt-4o-mini-tts"
cloud_voice = "alloy"
cloud_timeout_ms = 10000
```

鍵はそのまま書かれます。これは個人で使う機器であり、開発版はそもそも `/home` を HTTP で
公開しています。パスワードを貼ったノートパソコンと同じ扱いをしてください。

ネットワークなしで動かすときは、`server` の行はそのままにして、単に届かない状態にして
ください。取りに行って断られてログが 1 行出るだけで、すでに読んだ文はそのまま鳴ります。
行を消すと鍵が変わり、自分のキャッシュを見つけられなくなります。

ネットワークなしで、しかも電源を切った後にも必ず鳴らしたい文は、キャッシュの仕事では
ありません。WAV を `/home/voice/` に置いて鳴らしてください。

## 関連

- [アプリ間通信](../api/pubsub.md) — サービスが使う話題
- [標準アプリ](../getting_started/default_apps.md) — 一覧を出す Monitor
