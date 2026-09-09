# 遠隔画面

**画面は Modern 専用**。WiFi につながっていれば、Tab5 は自分の画面を配信します。同じネットワークの
ブラウザからアドレスを開くと、画面がそのまま出て、パソコンのキーボードとマウスで実機を
操作できます。

実機での作業はこれが一番速いです。普通の大きさのキーボードで書きながら、実機が動くのを
そのまま見られますし、画面写真も液晶にカメラを向けずに撮れます。

<div align="center">
  <img src="/images/photo_remote_desktop.jpg" width="620" alt="ノートパソコンのブラウザに Tab5 の画面が出ていて、その隣に Tab5 本体がある">
  <br><em>ブラウザと実機を並べたところ。状態表示は <code>connected · mode: h264</code></em>
</div>

## 使い方

1. 先に WiFi をつなぎます。[WiFi につなぐ](getting_started/wifi.md) を参照
2. システムメニューの Network でアドレスを確認します
3. 同じネットワークのブラウザで開きます

    ```
    http://fmruby.local/
    ```

    mDNS が引けない環境では、Network ダイアログに出ている数字のアドレスを開きます

これだけです。パソコン側に入れるものはありません。

送った操作はファームウェアの通常の入力経路に合流するので、実機を触っているのと区別が
ありません。`Ctrl` + `Q` や `Ctrl` + `Tab` もそのまま効き、マウスのホイールは
キーボードの入力先になっている窓を送ります。

!!! warning "同時に触るのは 1 人まで"
    Tab5 を手に持っている人と、ブラウザを開いている人は、同じカーソルを動かします。誰かが
    実機を触っているかもしれないときは、操作を始める前に一声かけてください。

!!! danger "同じネットワークにいれば誰でも操作できます"
    合言葉の確認も、接続元の制限もありません。同じネットワークにある機械なら、どれでも
    アドレスを開いて画面を見て、操作を送り、ファイルを読み書きし、アプリを起動したり
    止めたりできます。あなたと区別する手立てがありません。
    通信は平文の HTTP なので、経路上で中身を見ることもできます。

    信頼できる環境でのみ使ってください。インターネット側から届くようにルータで転送しては
    いけません。届かないようにしたいときは、下の `enable = false` にするか WiFi を切って
    ください。[セキュリティ](limitations.md#セキュリティ) も参照してください。

## 設定

`/etc/system_conf.toml` の `[remote_desktop]` にあります。

```toml
[remote_desktop]
enable = true
mode = "h264"              # "h264" (WebCodecs 対応時) か "mjpeg"
fps_cap = 15
jpeg_quality = 80
h264_bitrate_kbps = 1000
h264_gop = 30
```

| 項目 | 意味 |
|---|---|
| `enable` | 配信の有効・無効 |
| `mode` | `h264` は H.264 を提示して駄目なら MJPEG に落ちます。`mjpeg` は常に MJPEG |
| `fps_cap` | 1 秒あたりの上限。画面が止まっていてもこの一定の間隔で送ります (変化のないフレームは数百バイトで済みます) |
| `jpeg_quality` | MJPEG の画質、0〜100 |
| `h264_bitrate_kbps`, `h264_gop` | H.264 の符号化設定 |

## MJPEG と H.264

経路は 2 つあります。MJPEG は必ず動きます。H.264 は通信量が少ないのですが、これを復号する
ブラウザの機能 (WebCodecs の `VideoDecoder`) は安全な文脈 (secure context) でしか使えず、
`http://fmruby.local/` はそれに当たりません。平文 HTTP の LAN のアドレスでは Chrome でも
`VideoDecoder` が無いことになり、表示側は黙って MJPEG に切り替わります。

どちらで見えているかは、表示側の状態表示 (`mode: mjpeg` / `mode: h264`) で分かります。

普段の作業なら MJPEG で十分です。H.264 を使いたい場合は次のどちらかを取ります。

- **Chrome にそのアドレスを信頼させる** (簡単): `chrome://flags/#unsafely-treat-insecure-origin-as-secure`
  を開き、`http://fmruby.local` (と数字のアドレス) を入れて Enabled にし、Chrome を再起動する
- **`localhost` 経由で開く** (localhost は安全な文脈として扱われます)

    ```
    socat TCP-LISTEN:8080,fork TCP:<デバイスのIP>:80
    # そのうえで http://localhost:8080/ を開く
    ```

デバイス側を HTTPS にする案も検討しましたが採りませんでした。実機での TLS の負荷と、
自己署名証明書によるブラウザの警告が、家庭内で使う機械には割に合わないためです。

## 全画面表示

表示側には、元の縦横比のままモニタいっぱいに広げる全画面表示があります。配信されるものは
同じで、表示のしかただけが変わります。

## WiFi でファイルとアプリを扱う

同じサーバがファイルの受け渡しとアプリの起動もします。ケーブルもエディタも使わずに、
プログラムを実機へ送り込めます。

```
ruby tools/fmrb_rd_fs.rb <ip> ls    /home
ruby tools/fmrb_rd_fs.rb <ip> put   my.app.rb /app/usr/my.app.rb
ruby tools/fmrb_rd_fs.rb <ip> get   /home/notes.txt
ruby tools/fmrb_rd_fs.rb <ip> pull  /mnt/sd/shots ./shots     # まとめて取得
ruby tools/fmrb_rd_fs.rb <ip> push  ./slides /home/slides
```

アドレスだけを渡すと、FTP のような対話モードになります。実機側とパソコン側に別々の
カレントディレクトリがあります (`cd`、`lcd`、`ls`、`get`、`put`、`pull`、`push`、
`cat`、`launch`、`ps`)。

扱えるのはアプリが使うパス (`/app`、`/home`、`/usr/share`、`/mnt/sd`) だけで、それ以外は
実機側が断ります。`pull` と `push` は、反対側に同じ大きさのファイルがあれば飛ばします。
`--force` を付けると全部写します。

`fmrb_rd_launch.rb`、`fmrb_rd_ps.rb`、`fmrb_rd_kill.rb` と組み合わせると、書き込み直し
なしで「送る・起動する・見る・止める」の繰り返しができます。

```
ruby tools/fmrb_rd_fs.rb     <ip> put my.app.rb /app/usr/my.app.rb
ruby tools/fmrb_rd_launch.rb <ip> /app/usr/my.app.rb
ruby tools/fmrb_rd_snap.rb   <ip> out.jpg
ruby tools/fmrb_rd_kill.rb   <ip> <pid>
```

## 手元の道具から操作する

同じ道具で画面も操作できるので、手順書や自動の検証から実機を動かせます。

```
ruby tools/fmrb_rd_input.rb <ip> click X Y | dclick X Y | key ctrl+tab | wheel N | sleep MS ...
ruby tools/fmrb_rd_snap.rb  <ip> out.jpg
```

座標は表示バッファの座標 (426 x 240) で、表示している窓の大きさとは関係ありません。
`fmrb_rd_snap.rb` は MJPEG から 1 枚取り出すもので、この文書の Tab5 の画面写真もこれで
撮っています。

## 仕組み

デバイスは小さな HTTP サーバを動かしています。`GET /stream` が MJPEG、`/ws` が入力を
運ぶ WebSocket、`/ws_video` が H.264、`/status` が状態を返します。アプリは
`POST /app/launch?path=`、`POST /app/kill?pid=`、`GET /app/list`、ファイルは
`/fs/list`、`/fs/get`、`/fs/put`、`/fs/del`、`/fs/mkdir` です。

```
$ curl -s http://fmruby.local/status
{"ip":"192.168.10.16","mode":"mjpeg","streaming":false,"fps":0.0,"kbps":0}
```

フレームの符号化は P4 のハードウェアで行います。色の変換は PPA、H.264 は専用の回路で、
ソフトウェアの繰り返し処理ではありません。配信しても本体が極端に遅くならないのはこのためです。

## Retro では

Retro に遠隔画面はありません。S3 に映像の符号化器が無く、画面はコンポジット出力として
基板の外に出るためです。2.1 からは、もう半分にあたるアプリとファイルの口が Retro でも
答えます。WiFi さえ上がっていれば `/app/launch`、`/app/kill`、`/app/list` と `/fs` 一式は
Modern と同じように動くので、ケーブルなしでプログラムを入れて起動できます。`/stream`、
`/ws`、`/ws_video` はありません。

無認証であるという注意はそのまま当てはまります。無線が 1 系統の基板ではなおさらです。

## 関連

- [Modern (M5Stack Tab5)](getting_started/modern.md)
- [ネットワーク](api/network.md)
- [デバッグ](debugging.md) — 実機に届くもう一つの遠隔手段
