# 開発ツール

Family mruby の端末を外から扱うためのツールです。画面を PC に映す、ファイルやアプリを送る、
アプリを止めて中を調べる、端末なしでシステム全体を動かす、といったことができます。

## 端末に接続するツール

| ツール | できること | Modern | Retro | ヘッドレス | Linux | ブラウザ | 接続 |
|---|---|---|---|---|---|---|---|
| [リモートデスクトップ](remote_desktop.md) | 端末の画面を PC のブラウザに映し、PC のキーボードとマウスで操作する | ○ | — | — | — | — | WiFi |
| [WiFi でファイルとアプリを扱う](remote_desktop.md#wifi-でファイルとアプリを扱う) | `fmrb_rd_*.rb` のツールで、ファイルの転送、アプリの起動・終了、`/home` のバックアップを行う | ○ | ○ | 開発のビルドのみ | — | — | WiFi |
| [エディタのデバッガ](debugging.md#端末だけで-エディタのデバッガ) | 端末のエディタで、ブレークポイント、ステップ実行、変数の確認を行う | mruby 版エディタのビルドのみ | mruby 版エディタのビルドのみ | — | mruby 版エディタのビルドのみ | — | 不要 |
| [リモートデバッガ](debugging.md#パソコンから-リモートデバッガ) | 同じことを PC から行う。コマンドラインのクライアントと、VS Code などのエディタ向けの DAP アダプタがある | ○ | ○ | セットアップモードのみ | ○ | — | BLE (実機)、TCP (Linux) |
| [Family mruby コンソール](console.md) | ファイルの転送、ログのリアルタイム表示、スプライトとタイルマップの編集、デバッグ用の操作をブラウザで行う | ○ | ○ | セットアップモードのみ | — | — | BLE (Web Bluetooth) |

- **Modern** は M5Stack Tab5 と P4-Nano、**Retro** は ESP32-S3 と WROVER (画面と音を担当) の
  2 チップ構成の基板、**ヘッドレス** は AtomS3R と StickS3 です。**Linux** は
  [シミュレータ](simulator.md) と [Linux 版](../getting_started/linux.md)、**ブラウザ** は
  [Family mruby スタジオ](../getting_started/studio.md) を指します。
- **リリースのビルド** (Web インストーラで書き込むもの) では、端末の持ち主が Config の遠隔操作を
  オンにして PC を登録するまで、WiFi のツールは使えません。[接続できる相手](remote_desktop.md#接続できる相手)
  を参照してください。ヘッドレスの端末には Config が無いので、WiFi のツールが使えるのは開発の
  ビルドだけです。
- **エディタのデバッガ** は、Web インストーラで書き込むエディタ (Spinel でビルドしたもの) には
  入っていません。[デバッグ](debugging.md) を参照してください。
- **Retro は無線が 1 系統** なので、WiFi と BLE はどちらか一方だけです。Modern は両方を同時に
  使えます。
- **ヘッドレスの端末** は、セットアップモードのときだけ BLE を動かします。WiFi や Asterism の
  設定はこのときに書き込みます。

BLE と TCP のサービスは、どれもパスワードを求めません。自分で管理していないネットワークで使う
前に、[セキュリティ](../limitations.md#セキュリティ) を読んでください。

## 端末なしで Family mruby を動かす

| | 内容 | 必要なもの |
|---|---|---|
| [シミュレータ](simulator.md) | システム全体を Docker のコンテナで動かし、ブラウザの VNC ビューアで表示する | Docker が動く PC |
| [Family mruby スタジオ](../getting_started/studio.md) | WebAssembly にコンパイルしたファームウェアを、ブラウザのタブで動かす | 新しい Chrome か Firefox |
| [Linux 版](../getting_started/linux.md) | Linux の PC で 1 つのプログラムとして、またはデスクトップそのものとして動かす | Linux の PC |

スタジオと Linux 版の説明は [基本的な使い方](../getting_started/choose_hardware.md#ほかの動かし方) にあります。
