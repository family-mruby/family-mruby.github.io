# ネットワーク

2.0 で追加。CRuby と同じ書き方 — `Net::HTTP`、WebSocket、その下の TLS — でアプリから
インターネットにつながります。

**両機種で使えます**。Modern は ESP32-C6 経由、Retro は ESP32-S3 自身の無線を使います。
Linux のシミュレータでも、ホストのネットワークと OpenSSL を使って動きます。

## 使う前に

実機の `/etc/wifi.toml` に接続先を書いておく必要があります。書き方は
[WiFi につなぐ](../getting_started/wifi.md) を参照してください。

!!! note "Retro は無線を 1 つずつしか使えません"
    ESP32-S3 の無線は 1 系統なので、WiFi と BLE は同時に使えません。BLE の web コンソールが
    動いていると WiFi は起動しません。**Config** で `ble_auto_start` を off にして再起動して
    ください。Modern は ESP32-C6 が両方を受け持つので、この制約はありません。

## つながっているか調べる

```ruby
if FmrbApp.wifi_connected?
  info = FmrbApp.wifi_info
  # => { connected: true, ip: "192.168.10.16", ssid: "my-ap", hostname: "fmruby" }
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
| **待ち時間** | 呼び出しは同期です。通信中はそのアプリのイベント処理が止まり、窓は再描画されず入力は溜まります。要求は短く、時間切れを設定してください |
| **応答の大きさ** | 本文はまるごとアプリのメモリ領域 (割り当てにより 512KB か 1MB) に載ります。大きなものを落とすと足りなくなります |
| **HTTP の機能** | 分割転送・リダイレクト追跡・接続の使い回しは、picoruby の `net/http` が実装している範囲までです。CRuby と同じではありません |
| **証明書** | 独自の CA やクライアント証明書は、ファイルの場所ではなく PEM の文字列で渡します |

通信中はそのアプリが止まるので、起動時か一定間隔で 1 回取得して結果を保持し、描画は
その控えから行う、という形が基本になります。

## 実例

同梱の **Weather** (`/app/demo/weather.app.rb`) は Open-Meteo から HTTPS で天気を取得し、
JSON を解析して描画します。ネットワークを待ち、最初に成功するまで再試行する作りなので、
写して始めるのに向いています。

**Net Test** (`/app/tool/net_test.app.rb`) は API を一つずつ試すもので、うまく動かないときの
切り分けに使えます。

## 関連

- [WiFi につなぐ](../getting_started/wifi.md)
- [遠隔画面](../remote_desktop.md) — WiFi でできるもう一つのこと
- [定数・システム情報](const.md) — `FmrbConst::HAS_WIFI`
