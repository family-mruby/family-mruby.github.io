# WiFi につなぐ

両機種ともネットワークにつながります。つなぐと次のことができます。

- **[遠隔画面](../remote_desktop.md)** — パソコンのブラウザに実機の画面が出て、パソコンの
  キーボードとマウスで操作できます (Modern のみ)
- **[アプリからの通信](../api/network.md)** — `Net::HTTP`、WebSocket、TLS
- **mDNS** — 実機が `fmruby.local` で引けるようになり、アドレスを探さずに済みます

対応しているのは 2.4GHz 帯だけです。

!!! danger "ネットワークにつなぐと何が見えるか"
    どれも接続してくる相手を制限しません。ネットワークにつないだ時点で、同じネットワークに
    いる人は遠隔画面を開いて機械を操作できますし、BLE の届く範囲にいる人はファイルを
    読み書きできます。合言葉の確認はどこにもありません。下に書く接続情報も、実機の中に
    平文で保存されます。

    信頼できる環境で使ってください。知らない人と共有しているネットワークにつなぐ前に、
    [セキュリティ](../limitations.md#セキュリティ) を読んでください。

## `/etc/wifi.toml` に接続先を書く

接続先は実機の中のファイルにあります。公開しているファームウェアにはこのファイルが
入っていません。ご家庭の合言葉を、誰でも入手できるビルドに焼き込むわけにいかないためです。
実機のエディタで一度だけ作ってください。

1. **エディタ**を起動します。デスクトップで `E` を押すか、ランチャーから開きます
2. **File** → **Open** で `/etc/wifi.toml` を開きます

    無ければ、空の状態で中身を打ち込んで File → Save as で `/etc/wifi.toml` として
    保存します

3. 自分のネットワークを書きます

    ```toml
    [wifi]
    enable = true
    ssid = "your-ssid"
    password = "your-password"
    # http://<hostname>.local/ でつながるようになります
    hostname = "fmruby"
    ```

4. 保存して、システムメニューの Reset で再起動します

| 項目 | 意味 |
|---|---|
| `enable` | `false` にすると、設定は残したまま接続しません |
| `ssid` / `password` | 接続先。2.4GHz 帯のみ |
| `hostname` | mDNS の名前。`fmruby` なら `fmruby.local` で引けます |

!!! tip "実機で打ちたくない場合"
    パソコンから [web コンソール](console.md) 経由でファイルを送ることもできます。
    こちらは BLE で実機とやりとりします。

## つながったか確認する

再起動したら、システムメニューの Network を開きます。

<div align="center">
  <img src="/images/tab5_network.png" width="600" alt="割り当てられたアドレスを表示する Network ダイアログ">
</div>

接続できたか、割り当てられたアドレス、ホスト名が出ます。Refresh で読み直します。

メニューバーの時計の左にも、WiFi の状態を示す小さな印が出ます。

アプリからは次のように取れます。

```ruby
if FmrbApp.wifi_connected?
  info = FmrbApp.wifi_info
  Log.info("address: #{info[:ip]}")
end
```

## Retro は無線を 1 つずつしか使えません

ここが意外と引っかかる違いです。

| 機種 | WiFi と BLE |
|---|---|
| **Modern** (Tab5) | 同時に使えます。ESP32-C6 が両方を受け持つので、WiFi を使いながら BLE の web コンソールも使えます |
| **Retro** (narya-board) | どちらか一方です。ESP32-S3 の無線は 1 系統しかありません |

Retro では、起動時に BLE が立ち上がっていると WiFi は起動しません (ログにその旨が出ます)。
WiFi を使うには、システムメニューの Config で `ble_auto_start` を off にして再起動して
ください。BLE はその後、コンソールが必要になったときにシステムメニューから手で起動できます。

同じ画面の `wifi_auto_start` は、そもそも起動時に WiFi を立ち上げるかどうかの設定です。

## つながらないとき

- `enable = true` がファイルに入っているか確認してください
- SSID の綴りを確認してください。大文字小文字も区別されます
- **2.4GHz 帯のみ**です。5GHz しか出していないネットワークには一生つながりません
- Retro では、BLE が無線を握っていないか確認してください (上記)
- WiFi はデスクトップより後に立ち上がります。数秒待ってから判断してください。
  ネットワークを使うアプリは、つながっている前提にせず `FmrbApp.wifi_connected?` を
  待つように書きます

## 関連

- [遠隔画面](../remote_desktop.md) — 画面をブラウザに出す
- [ネットワーク](../api/network.md) — アプリ向けの API
- [Modern (M5Stack Tab5)](modern.md)
- [システム設定](../file_formats/system_conf.md) — `wifi.toml` と `system_conf.toml` の全項目
- [コンソール](console.md) — BLE でファイルを実機に送る
