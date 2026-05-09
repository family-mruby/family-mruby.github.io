# 標準アプリ

Family mruby には主要な作業用アプリが組み込まれています。これらだけでアプリの作成・編集・実行・デバッグが一通り完結します。

## 起動方法

| 場所 | アプリ |
|---|---|
| **ランチャー**（メニューバー → `Launcher`）のアイコン | Shell, Editor |
| **メニューバー**（左上 `Family mruby` ▼） | Launcher, File Manager, Log Viewer, Monitor, Set Clock, Config, About |

## Shell

ファイル操作・スクリプト実行・対話実行をするターミナル。

| カテゴリ | コマンド |
|---|---|
| ディレクトリ | `cd [path]` / `pwd` / `ls [path]` |
| ファイル閲覧 | `cat <file>` / `less <file>` |
| ファイル操作 | `mkdir <dir>` / `rm <path...>` / `cp <src> <dst>` / `mv <src> <dst>` |
| 編集 | `edit <file>` （Editor を起動） |
| アプリ作成 | `create_app <name>` ([Hello World](hello_world.md#ショートカット-create_app-でひな型を生成する) 参照) |
| 実行 | `run <script>` / `run <script> &` （バックグラウンド） / `run <script> > <file>` （出力リダイレクト） |
| 対話 Ruby | `irb` |
| プロセス | `ps` / `kill_job <id>` |
| ヘルプ | `help` |

シェル内で **Tab** キーによる補完、↑↓ による履歴呼び出しが効きます。

### `less` の操作

`less <file>` でファイルを開いた後:

| キー | 動作 |
|---|---|
| `Space` / `PgDn` / `j` | 1 ページ進む |
| `b` / `PgUp` / `k` | 1 ページ戻る |
| `g` | 先頭へ |
| `G` | 末尾へ |
| `?` | キー一覧の表示切替 |
| `q` / `ESC` | 終了 |

## Editor

MS-DOS 風のテキストエディタ。Ruby のシンタックスハイライト対応。

- **起動**: シェルで `edit foo.app.rb` か、ランチャーの **Editor** アイコンから空ファイルで起動
- メニューバーから保存・開く・終了などの操作
- **ホットキー**は黄色文字で表示

`create_app` で生成したひな型を Editor で編集 → 右クリックでリロード、というのが基本フローです。

## File Manager

`/flash/` や `/sd/` 配下のファイルをツリー表示で閲覧・操作。BLE ファイルマネージャは PC からの操作ですが、こちらは本体から操作するものです。

## Log Viewer

システム全体の Log 出力をリアルタイム表示。

- レベル別にカラー表示（ERROR=赤 / WARN=黄 / INFO=灰 / DEBUG=暗灰）
- ツールバーで表示レベルを切替（`E/W/I` または `E/W/I/D`）
- 自分のアプリで `Log.info` などを使ったときの確認に最適

## Monitor

システム稼働状態を可視化するモニタ。下部の `<` / `>` でページ切替。

- **ページ 1**: ヒープ使用量バー（各メモリプール、IRAM、PSRAM）
- **ページ 2**: グラフィックス統計（コマンド/秒・present/秒、過去 30 秒）

アプリが重い／動かないときの診断に。

## Set Clock

RTC 時刻の手動設定ダイアログ。年月日時分秒を入力して反映。

通常は基板搭載の RX8900 RTC が時刻を保持しますが、初期設定や時刻ずれの修正用です。

## Config

システム全体の設定を変更するアプリ（テーマ色、表示マージン等）。

## About

OS バージョン、GA 側ファームウェアバージョン、IDF バージョン、MAC アドレスなどシステム情報を表示するダイアログ。

## ファイルマネージャ系の使い分け

| ツール | 場所 | 主な用途 |
|---|---|---|
| Shell の `ls` / `cd` 等 | 本体内のシェル | スクリプトでバッチ操作、コマンド派 |
| File Manager | 本体内のメニュー | GUI でファイル閲覧（ローカル） |
| BLE ファイルマネージャ | PC のブラウザ | PC からファイル転送 ([ガイド](ble_file_manager.md)) |

## 関連

- [Hello World](hello_world.md) — Shell + create_app で最初のアプリを書く
- [BLE ファイルマネージャ](ble_file_manager.md) — PC からのファイル転送
- [ログ API](../api/log.md) — Log.info などの出力 API（Log Viewer で見える）
