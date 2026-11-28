# Shell のコマンド

Shell は Family mruby のコマンドラインです。ランチャー、デスクトップのアイコン、または
デスクトップで `S` を押して開きます。`help` で、その端末で使えるコマンドの一覧が出ます。

**(開発版)** と書いたコマンドは開発ブランチ (と [スタジオ](studio.md)) にあり、3.0.0 には
ありません。

## 操作

| キー | 働き |
|---|---|
| `Tab` | ファイル名・ディレクトリ名を補完します |
| `↑` / `↓` | 前に打った行・次の行 |
| `PgUp` / `PgDn`、マウスのホイール | 出力をさかのぼって見ます |
| `Ctrl` + `C` | Shell の中で実行中のスクリプトを止めます |
| `Ctrl` + `V` | クリップボードを行に貼り付けます |

`/` で始まらないパスは、今のディレクトリからの相対パスです。引用符はなく、引数は空白で
区切られます。

## ファイルとディレクトリ

| コマンド | 内容 | 例 |
|---|---|---|
| `cd [path]` | 今のディレクトリを変えます (`cd` だけなら `/`) | `cd /home` |
| `pwd` | 今のディレクトリを表示します | `pwd` |
| `ls [path]` | ディレクトリの中身を一覧します | `ls /app/demo` |
| `cat <file>` | ファイルの中身を表示します | `cat /etc/system_conf.toml` |
| `less <file>` | ファイルを 1 ページずつ表示します (`Space` / `b` でページ送り、`q` で終了) | `less /usr/share/doc/kanji.md` |
| `mkdir <dir>` | ディレクトリを作ります | `mkdir /home/games` |
| `rm <path...>` | ファイルと、空のディレクトリを消します | `rm old.rb notes.txt` |
| `cp <src> <dst>` | ファイルをコピーします | `cp hello.rb /home/backup.rb` |
| `mv <src> <dst>` | ファイルを移動・名前変更します | `mv draft.rb final.rb` |

## コードを書く・動かす

| コマンド | 内容 | 例 |
|---|---|---|
| `edit [-f] <file>` | ファイルをエディタで開きます。無ければ作ります。`-f` で全画面 | `edit -f /home/hello.rb` |
| `create_app <name>` | すぐ編集できるアプリのひな型 `/app/usr/<name>.app.rb` と `.app.toml` を作ります ([Hello World](hello_world.md#ショートカット-create_app-でひな型を生成する) を参照) | `create_app my_clock` |
| `run <script> [args] [&]` | スクリプトを実行します。アプリはアプリとして起動し、普通の `.rb` は Shell の中で動いて出力を Shell に出します。`&` を付けるとバックグラウンドのジョブになります | `run /home/fib.rb 20` |
| `run <script> > <file>` | 出力をファイルに書きます (`>>` で追記、`<` でファイルを入力に渡す) | `run report.rb > /home/out.txt` |
| `open <file>` | ファイルの種類に [関連付け](../file_formats/associations.md) られたアプリで開きます | `open /usr/share/samples/slides/demo.md` |
| `irb` | 対話型の Ruby。`$shell` はこの Shell のアプリです | `irb` |

## アプリ・ジョブ・サービス

| コマンド | 内容 | 例 |
|---|---|---|
| `ps` | 動いているタスク (PID、種類、エンジン、状態、名前)、バックグラウンドのジョブ、サービスを一覧します。ENGINE の欄は各アプリを動かしているもの (`mruby`・`lua`・`basic`・`python`・`wasm`・`native`) です (ENGINE は開発版から) | `ps` |
| `kill <pid>` | ユーザのアプリを終了させます (PID は `ps` で) | `kill 12` |
| `kill <service>` | [サービス](../file_formats/services.md) をこのセッションの間だけ止めます | `kill hourly_chime` |
| `kill_job <id>` | バックグラウンドのジョブを止めます (`ps` の JOB の番号) | `kill_job 1` |
| `svc list` | バックグラウンドのサービスを一覧します | `svc list` |
| `svc start` / `svc stop <name>` | サービスをこのセッションの間だけ起動・停止します | `svc start timesync` |
| `svc enable` / `svc disable <name>` | 同じことをして、再起動の後も覚えておきます | `svc disable hourly_chime` |

## 端末の間でアプリとファイルを運ぶ

運べるように書いたアプリ (`movable = true`。[動いているアプリを運ぶ](../api/fmrb_app.md#動いているアプリを運ぶ)
を参照) と、[Asterism](../api/network.md#asterism-端末をまたぐオブジェクトとトピック) を使う
コマンドです。相手の端末は Asterism のノード ID で指定します。ノード ID は `anodes` で
分かります。

| コマンド | 内容 | 例 |
|---|---|---|
| `checkpoint [-r] <pid>` | アプリをイメージ `/tmp/<name>.ckpt` に書いて閉じます。`-r` ですぐ起動し直します | `checkpoint -r 14` |
| `restore <image>` | イメージからアプリを起動します | `restore /tmp/counter.ckpt` |
| `amove <pid\|name> <node>` | 動いているアプリを別の端末へ移します。名前は `ps` に出るもの。3.0.0 では `move <pid> <node>` です **(開発版)** | `amove Counter fmruby-aaaaaa` |
| `anodes [list]` | 今 Asterism にいる端末を名前つきで一覧します。この端末には印が付きます **(開発版)** | `anodes` |
| `anodes info <node>` | 1 台の端末について、プロフィール、アプリとその状態、ファイルとアプリを受け取るかを表示します **(開発版)** | `anodes info fmruby-aaaaaa` |
| `asend <node> <file> [-o] [-s]` | ファイルを相手の端末の `/home/inbox/` に送ります。`-o` で同じ名前のファイルを上書きします (付けなければ別の名前になります)。`-s` (または `--sd`) で相手の SD カードの `/sd/inbox/` に置きます **(開発版)** | `asend fmruby-aaaaaa /home/hello.rb` |
| `asend -c` | 送っているファイルを取りやめます **(開発版)** | `asend -c` |
| `asend -l` | この端末にファイルを送ってよい相手を表示します **(開発版)** | `asend -l` |
| `asend on\|off` | 送るためにこの端末をネットワークにつないだままにし、ウィンドウのメニューの **送る** にすぐ相手が並ぶようにします。`asend` だけなら今の状態を表示します。`asend` でのファイル送信と `amove` は、これが off でも使えます **(開発版)** | `asend on` |
| `areceive` | この端末がファイルとアプリを受け取るか、誰から受け取るかを表示します **(開発版)** | `areceive` |
| `areceive on\|off` | 受け取りを始める・やめます **(開発版)** | `areceive on` |
| `areceive allow\|deny <file\|checkpoint> <node>` | ある端末にファイルを送ること (`file`) やアプリを移すこと (`checkpoint`) を許す・取り消します。`*` はネットワークの全員です **(開発版)** | `areceive allow file fmruby-aaaaaa` |

アプリを移せるのは、同じ版の端末どうしです。

### 受け取る相手: `receive.toml`

端末は、設定するまで何も受け取りません。受け取る相手は `/home/asterism/receive.toml` に
書きます。このファイルが無い間は、システムの写し `/etc/asterism/receive.toml` (何も受け取らない
設定) を読みます。`areceive` や **受け取り** のアプリ (`/app/tool`) で最初に変更したときに、
`/etc` のものを元に `/home` のファイルが作られます。

```toml
enabled = true          # 受け取るかどうか。off (か行が無い) なら、一覧に何があっても受け取らない
send_enabled = false    # 「送る」のためにネットワークにつないだままにする

[file]                  # /home/inbox (と /sd/inbox) にファイルを置いてよい相手
from = ["fmruby-aaaaaa", "fmruby-*"]

[checkpoint]            # アプリを移してよい相手
from = ["*"]            # "*": ネットワークの全員
```

一覧にはノード ID とパターン (`fmruby-*`) を書きます。アクセス制御のあるルータでは、ルータの
側でも相手を通す必要があります。端末が [コンソール](../tools/console.md) のメンバーなら、コンソールが
同じファイルに書く節で、コンソールで選んだ相手が加わります。`areceive` はその節を表示しますが、
書き換えません。2 つのスイッチのどちらかが on なら、起動時に転送のアプリが立ち上がります。

**(開発版)** `enabled` と `send_enabled` のスイッチ、`/etc` の写し、`[file]` の一覧、受け取りの
アプリは新しいものです。3.0.0 は `/home/asterism/receive.toml` だけを、それも
`[checkpoint] from` の一覧だけを読みます。

## Linux のコマンド (Linux 版だけ)

[Linux 版](linux.md) では、`!` で始まる行を Linux で実行します。場所は今のディレクトリに
対応する Linux のディレクトリです (`/mnt/host/src` なら `~/src`)。ほかの端末では、Linux が
無いと答えます。

| コマンド | 内容 | 例 |
|---|---|---|
| `!<command>` | Linux のコマンドを実行し、出力 (色つき) を Shell に出します。`Ctrl` + `C` で止めます | `!git status` |
| `!` | Linux のシェルに入ります。`exit` か `Ctrl` + `D` で戻ります | `!` |
| `Ctrl` + `Shift` + `V` | 実行中の Linux のコマンドに貼り付けます | |

`vim` や `top` のような全画面のプログラムには対応していません (`TERM=dumb`)。

## その他

| コマンド | 内容 | 例 |
|---|---|---|
| `color` | Shell の 2 つの色を表示します | `color` |
| `color bg\|text <colour>` | 背景色・文字色を [色の名前](../file_formats/color_names.md) か数値 (`0x1F`) で変えます。`/home/colors.toml` に保存します | `color bg navy` |
| `color names` / `color reset` | 色の名前を一覧します / テーマの色に戻します | `color reset` |
| `logo` | PicoRuby のロゴを描きます | `logo` |
| `help` | コマンドの一覧を表示します | `help` |

## 関連

- [標準アプリ](default_apps.md)
- [Linux 版](linux.md)
- [動いているアプリを運ぶ](../api/fmrb_app.md#動いているアプリを運ぶ)
