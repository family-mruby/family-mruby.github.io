# システム設定 (`/etc/system_conf.toml`, `/etc/wifi.toml`)

`/etc` にある 2 つのファイルが、システムの起動と挙動を決めています。どちらも TOML で、
実機のフラッシュにあり、実機のエディタで編集できます。

| ファイル | 内容 |
|---|---|
| `/etc/system_conf.toml` | 画面、入力、配色、自動起動、キー割り当て、遠隔画面 |
| `/etc/wifi.toml` | 接続先の名前と合言葉 |

!!! warning "書き込むと置き換わります"
    ファームウェアを書き込むと、`/etc` を含めたフラッシュ全体が書き換わります。手を入れた
    ものは先に退避してください ([コンソール](../getting_started/console.md) を参照)。

## 編集のしかた

Config ダイアログから。システムメニューの Config には、実際によく変える設定が
並んでいます (下記)。書き戻しは行単位なので、コメントやそれ以外の設定はそのまま残ります。
実機では Save & Reboot も出ます。起動時にしか効かない設定があるためです。

エディタから。ダイアログに無い項目は、Editor でファイルを開いて書き換え、保存して
**Reset** で再起動します。

## `/etc/system_conf.toml`

### 表示

| キー | 型 | 意味 |
|---|---|---|
| `system_name` | string | 起動時と About に出る名前 |
| `display_width` / `display_height` | int | 表示バッファの大きさ。Modern は 426 x 240、Retro は 320 x 240 |
| `display_margin_x` / `display_margin_y` | int | 画面の端に空けておく画素数。Retro ではブラウン管が端を隠す (オーバースキャン) ので余白が要りますが、Modern はバッファ全体が見えるのでどちらも 0 です |
| `default_user_app_width` / `default_user_app_height` | int | アプリの `.app.toml` に指定が無いときの窓の大きさ |
| `display_mode` | string | どの表示ドライバを使うか (下記) |

`display_mode` は `ntsc_ipc` (Retro、子チップ経由のコンポジット映像)、`tab5_dsi`
(Modern、内蔵の液晶)、`sdl2` (Linux のシミュレータ)、`spi_direct`、`atom_display`、
`headless` のいずれかです。

!!! warning "ここの綴り間違いは黙って通ります"
    知らない `display_mode` は、何も言わずに `ntsc_ipc` として扱われます。Modern の基板が
    起動ログで `ntsc_ipc` と言っていたら、値の綴りが違っています。

### 入力

| キー | 型 | 意味 |
|---|---|---|
| `keyboard_layout` | `"jp"` / `"us"` | 使っているキーボードの配列。合っていないと記号の位置がずれます |
| `mouse_scale_x` / `mouse_scale_y` | float | カーソルの速さ。0.5 で半分、2.0 で倍 |

### システム

| キー | 型 | 既定 | 意味 |
|---|---|---|---|
| `language` | `"en"` / `"ja"` | `"en"` | 画面の言語。`app_screen_name_<言語>` を持つアプリはこれに従います |
| `timezone` | string | | POSIX の時間帯。`JST-9`、`UTC`、`EST5` など |
| `debug_mode` | bool | `true` | ログを多めに出す |
| `ble_auto_start` | bool | `true` | 起動時に BLE を立ち上げる。Retro のみ有効で、Modern は設定によらず起動する |
| `wifi_auto_start` | bool | `false` | 起動時に WiFi を立ち上げる |

!!! note "Retro ではこの 2 つがぶつかります"
    ESP32-S3 の無線は 1 系統です。`ble_auto_start` が true なら、`wifi_auto_start` が何で
    あろうと WiFi は起動しません。Modern の ESP32-C6 は両方を同時に動かせます。
    [WiFi につなぐ](../getting_started/wifi.md) を参照してください。

### `[theme]`

9 色を、それぞれ RGB332 の 1 バイトで指定します。

```toml
[theme]
desktop_bg = 0xF6
menu_bg    = 0xC5
window_bg  = 0xFF
text       = 0x00
text_light = 0xFF
highlight  = 0xEE
border     = 0x60
button     = 0x60
dir_color  = 0x03
```

Config ダイアログには `light` / `dark` / `classic` の 3 つの見本があり、選んで保存すると
この 9 項目に展開されます。それ以外の配色にしたいときは手で書きます。

アプリからは同じ値が `FmrbConst::THEME_*` で読めるので、行儀のよいアプリはシステムの配色に
従います。[定数・システム情報](../api/const.md) を参照してください。

### `[[shortcuts]]`

デスクトップで 1 文字打つとアプリが起動する、その割り当てです。

```toml
[[shortcuts]]
key = "l"
app = "launcher"

[[shortcuts]]
key = "e"
app = "default/editor"

[[shortcuts]]
key = "n"
app = "app/tool/nsf_player.app.rb"
```

`app` には、組み込みの名前 (`launcher` / `file_manager` / `log_viewer`)、システムアプリの
場所 (`default/shell` / `default/editor`)、またはファイルの場所を書きます。
[デスクトップ](../getting_started/desktop.md) を参照してください。

### `[[sync_files]]`

起動時に core からグラフィックス側へ複製するファイルです。向こう側に置かないと使えない
素材のために使います。

```toml
[[sync_files]]
src  = "/usr/share/sounds/nsf/test.nsf"
dest = "/flash/data/test.nsf"
```

複製先の内容が既に一致していれば飛ばすので、普段の起動では時間を食いません。

### `[remote_desktop]`

Modern 専用。WiFi 越しに画面を配信する設定です。

```toml
[remote_desktop]
enable = true
mode = "h264"              # "h264" か "mjpeg"
fps_cap = 15
jpeg_quality = 80
h264_bitrate_kbps = 1000
h264_gop = 30
```

各項目の意味は [遠隔画面](../remote_desktop.md) にあります。

## `/etc/wifi.toml`

```toml
[wifi]
enable = true
ssid = "your-ssid"
password = "your-password"
hostname = "fmruby"
```

| キー | 意味 |
|---|---|
| `enable` | `false` にすると、設定は残したまま接続しません |
| `ssid` / `password` | 接続先。2.4GHz 帯のみ |
| `hostname` | mDNS の名前。`fmruby` なら `fmruby.local` |

公開しているファームウェアにこのファイルは入っていません。誰でも入手できるビルドに
合言葉を焼き込むわけにいかないためです。実機で一度だけ作ってください。手順は
[WiFi につなぐ](../getting_started/wifi.md) にあります。

!!! note "リポジトリにも入っていません"
    `flash/etc/wifi.toml` は `.gitignore` に入れてあるので、合言葉がコミットに残ることは
    ありません。自分でファームウェアをビルドする場合は `config/wifi_p4.toml` に置けば、
    ビルドがイメージに取り込みます。

## 関連

- [デスクトップ](../getting_started/desktop.md) — Config ダイアログと、そこで変わるもの
- [WiFi につなぐ](../getting_started/wifi.md)
- [アプリ設定ファイル (.app.toml)](app_toml.md) — アプリごとの設定。こちらとは別のファイル
- [定数・システム情報](../api/const.md) — アプリからこれらの値を読む
