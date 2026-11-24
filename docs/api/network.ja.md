# ネットワーク (Net::HTTP / WebSocket / TLS)

2.0 で追加。CRuby と同じ書き方 — `Net::HTTP`、WebSocket、その下の TLS — でアプリから
インターネットにつながります。

**両機種で使えます**。Modern は ESP32-C6 経由、Retro は ESP32-S3 自身の無線を使います。
Linux のシミュレータでも、ホストのネットワークと OpenSSL を使って動きます。

## 使う前に

実機の `/etc/wifi.toml` に接続先を書いておく必要があります。書き方は
[WiFi につなぐ](../getting_started/wifi.md) を参照してください。

!!! note "Retro は無線を 1 つずつしか使えません"
    ESP32-S3 の無線は 1 系統なので、WiFi と BLE は同時に使えません。BLE の web コンソールが
    動いていると WiFi は起動しません。Config で `ble_auto_start` を off にして再起動して
    ください。Modern は ESP32-C6 が両方を受け持つので、この制約はありません。

## つながっているか調べる

```ruby
if FmrbApp.wifi_connected?
  info = FmrbApp.wifi_info
  # => { connected: true, ip: "192.0.2.16", ssid: "my-ap", hostname: "fmruby" }
  Log.info("address: #{info[:ip]}")
end
```

| メソッド | 戻り値 |
|---|---|
| `FmrbApp.wifi_connected?` | `true` / `false`。メモリを確保しないので、繰り返し呼んでも安全です |
| `FmrbApp.wifi_info` | `:connected` / `:ip` / `:ssid` / `:hostname` を持つ Hash。WiFi の無い機種では `nil` |

WiFi はデスクトップより後に立ち上がるので、ネットワークを使うアプリは「つながっている
前提」ではなく待つように書きます。

```ruby
def on_create
  @ready = false
end

def on_update
  unless @ready
    return unless FmrbApp.wifi_connected?
    @ready = true
    fetch_data
  end
end
```

## HTTP

```ruby
require 'net/http'
require 'json'

# 単発の GET
body = Net::HTTP.get(URI.parse("http://example.com/api/status"))

# 応答オブジェクトで受ける
res = Net::HTTP.get_response(URI.parse("https://example.com/data.json"))
if res.code == "200"
  data = ::JSON.parse(res.body)
end

# フォームの POST
res = Net::HTTP.post_form(URI.parse("https://example.com/post"), { "key" => "value" })

# 接続を使い回す
http = Net::HTTP.new("example.com", 443)
http.use_ssl = true
http.start do |h|
  res = h.get("/index.html")
  res = h.post("/api", '{"a":1}', { "Content-Type" => "application/json" })
end
```

HTTPS はそのまま使えます。同梱の CA で証明書を検証するので、`https://` の URL を渡すだけで
追加の設定は要りません。

!!! warning "`JSON` ではなく `::JSON` と書いてください"
    クラスの中で `JSON` と書くと `YourClass::JSON` として探されて失敗します。頭に `::` を
    つけてください。

## 止まらずに取ってくる (`FmrbNet.request`)

2.1 からの機能です。`Net::HTTP` はサーバの返事を待ちます。実機の上でしか動かさない道具なら
それでかまいませんが、ブラウザでも動かすアプリはこちらを使います。要求は一度出すだけで、
状態は `on_update` から見ます。

```ruby
def on_create
  @req = FmrbNet.request("https://example.org/thing.json")
end

def on_update
  if @req && @req.done?
    @req.ok? ? use(@req.body) : Log.warn(@req.error)
    @req = nil
  end
  50
end
```

| | |
|---|---|
| `FmrbNet.request(url)` | 取得を 1 つ始めて、要求オブジェクトを返す |
| `done?` | 返事が届いたか。`on_update` から見ます。ここで回して待たないこと |
| `ok?` | 届いていて、状態コードも問題ないなら true |
| `status` / `body` / `error` | HTTP の状態コード、本文、失敗した理由 |

コールバックにしていないのは意図的です。今しまって後で呼ぶブロックは、外側のローカル変数を
捕まえると Spinel で壊れる形だからです。

環境によって違うのは待つ場所であって、アプリの書き方ではありません。実機では `request` の
中で取得が終わるので、そのアプリのタスクだけがそこで待ち、`done?` はすぐ true になります
(タスクは横取りされるので、システムの他の部分は動き続けます)。ブラウザでは誰も待ちません。
ページが取ってくる間も画面は描き続けます。ブラウザで「待つアプリ」が書けないのはこのため
です。

!!! note "ブラウザではページの制約がそのまま効きます"
    取得はブラウザが行うので、別のサイトからの取得を許していないサーバは Studio からは
    読めません。`Net::HTTP` や WebSocket (ソケットの側) はそもそもありません。アプリの店が
    この書き方で、だから実機でもブラウザでも動きます。

## WebSocket

```ruby
require 'net/websocket'

Net::WebSocket::Client.connect("wss://echo.example.com/ws") do |ws|
  ws.send_text("hello")
  msg = ws.receive(timeout: 5)
  ws.close
end
```

`receive` は待ち続けるのではなく定期的に確認する作りなので、待ち時間の間ずっと VM が
止まることはありません。

## CRuby との違い

書き方は CRuby に似せてありますが、動くのはマイコンです。実際に効いてくる制約は次の
とおりです。

| | |
|---|---|
| **TLS の版** | TLS 1.2 のみ。TLS 1.3 には対応していません |
| **待ち時間** | 呼び出しは同期です。通信中はそのアプリのイベント処理が止まり、ウィンドウは再描画されず入力は溜まります。要求は短く、時間切れを設定してください |
| **応答の大きさ** | 本文はまるごとアプリのメモリ領域 (割り当てにより 512KB か 1MB) に載ります。大きなものを落とすと足りなくなります |
| **HTTP の機能** | 分割転送・リダイレクト追跡・接続の使い回しは、picoruby の `net/http` が実装している範囲までです。CRuby と同じではありません |
| **証明書** | 独自の CA やクライアント証明書は、ファイルの場所ではなく PEM の文字列で渡します |

通信中はそのアプリが止まるので、起動時か一定間隔で 1 回取得して結果を保持し、描画は
その控えから行う、という形が基本になります。

## 実例

同梱の Weather (`/app/demo/weather.app.rb`) は Open-Meteo から HTTPS で天気を取得し、
JSON を解析して描画します。ネットワークを待ち、最初に成功するまで再試行する作りなので、
写して始めるのに向いています。

**Net Test** (`/app/test/net_test.app.rb`) は API を一つずつ試すもので、うまく動かないときの
切り分けに使えます。`/app/test` (シミュレータに入っています。基板にはリポジトリの `tools/fmrb_rd_fs.rb` で WiFi から入れます) の
他のものと同じくランチャーには出ないので、
エディタかシェルから起動してください。

## Asterism: 端末をまたぐオブジェクトとトピック

Asterism は、Family mruby の端末、ブラウザ版、CRuby の PC (`asterism` gem)、ROS 2 を Zenoh の上で
1 つのネットワークにします。アプリは Ruby のオブジェクトを公開して別の端末から手元のもののように呼ばせ、
トピックに値を流してほかのアプリに購読させられます。ウィンドウのメニューの **送る** (動いている
アプリを別の端末へ移す) もこのネットワークを通ります。

### 設定

端末はルータと自分の名前を `/home/asterism/config.toml` から読みます。

```toml
router = "tcp/192.0.2.2:7447"   # Zenoh ルータの場所 (TLS のルータなら tls/...)
node   = "fmruby-aaaaaa"        # この端末のノード ID (省略可)
name   = "Desk"                 # ほかの端末に見える名前 (省略可)
```

このファイルが無いときは `/etc/system_conf.toml` の `zenoh_router` を使います。ノード ID の
既定は端末の mDNS 名です。

### アプリからつなぐ

`FmrbAsterism::Link` が、Asterism のアプリに毎回要ること (WiFi を待つ、端末の設定でつなぐ、
poll する、切れたのに気づいてつなぎ直す) を引き受けます。接続は `link.conn` (`Asterism::Connection`)
です。つなぐたびに新しい接続になり、アプリが接続に載せたものは接続と一緒に消えるので、
オブジェクトやトピックはつないだあと毎回呼ばれる `link_up` で載せます。

```ruby
class StepApp < FmrbApp
  def on_create
    @steps = 0
    @link = FmrbAsterism::Link.new(self, "step")   # ネットワーク上では <node>/step
  end

  def link_up(link)          # つないだあと毎回
    c = link.conn
    c.expose("counter", self, methods: [:steps])  # ほかからは <node>/step/counter を呼ぶ
    @topic = c.publish("pedometer/step", type: :number)
    @sub = c.subscribe("*/step/pedometer/step") do |v, info|
      Log.info("#{info.node}: #{v}")
    end
  end

  def link_down(link)        # 省略可。理由は link.state と link.reason
  end

  def steps
    @steps
  end

  def on_update
    if @link.update          # poll する。つながっている間 true
      # 変わったら @topic.put(@steps)
    end
    100
  end

  def on_destroy
    @link.close
  end
end
```

別の端末からは `net["fmruby-aaaaaa/step/counter"].steps` で呼べます。接続のメソッド (`expose`・`[]`・
`publish`・`subscribe`・`status`・`profile_of`・`define_type` など) は
[asterism の README](https://github.com/ruby-asterism/asterism#the-portable-api) にあります。

!!! note "通信の決まり (wire protocol) 2"
    今のファームウェアは Asterism の wire protocol 2 (asterism gem 0.14.0 以降) で話します。
    protocol 1 とは互換が無く、ネットワーク上の端末とプログラムは一緒に入れ替えます。protocol 1 の
    ノードからもほかのノードは見えますが、両者の間の呼び出しは断られ、状態とトピックは
    見えません。相手の protocol は `net.protocol_of(node)` で分かります。

## 関連

- [WiFi につなぐ](../getting_started/wifi.md)
- [遠隔画面](../remote_desktop.md) — WiFi でできるもう一つのこと
- [定数・システム情報](const.md) — `FmrbConst::HAS_WIFI`

<!-- BEGIN class reference links (generated by fmruby-core tools/ti/gen_site.rb; do not edit) -->
**クラスリファレンス:** [`FmrbNet`](reference/FmrbNet.md)、[`FmrbNet::Request`](reference/FmrbNet__Request.md)、[`FmrbAsterism`](reference/FmrbAsterism.md)、[`FmrbAsterism::Link`](reference/FmrbAsterism__Link.md)、[`Asterism`](reference/Asterism.md)、[`Asterism::Connection`](reference/Asterism__Connection.md)
<!-- END class reference links -->
