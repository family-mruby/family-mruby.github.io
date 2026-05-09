# BLE ファイルマネージャ

PC やスマートフォンから Bluetooth Low Energy (BLE) 経由で基板内のファイルを読み書きするツールです。`/flash/...` 以下のファイルを Web ブラウザから操作できます。

## 概要

- **接続方式**: Web Bluetooth API（ブラウザ標準）
- **ペアリング不要**: 都度の認証ダイアログのみ
- **デバイス名**: `Family-mruby-XXXXXX`（最後の 6 文字は MAC アドレス末尾）
- **対応操作**: ディレクトリ列挙 / ファイル取得 / ファイル送信 / 削除 / ディレクトリ作成 / 容量確認

## 必要なもの

| 項目 | 推奨 |
|---|---|
| Bluetooth 内蔵 PC または Bluetooth USB アダプタ | 必須 |
| Web Bluetooth 対応ブラウザ | **Chrome / Edge** （Firefox / Safari は不可） |
| 起動中の Family mruby 本体 | – |

!!! note "対応 OS"
    Web Bluetooth は **Windows, macOS, Linux, Android** の Chrome/Edge で動作します。**iOS は OS 制約で不可**（iOS では Chrome / Edge も内部的に Safari エンジンのため）。

## クライアントの起動

### 方法 1: Family mruby 公式 Web クライアント（リポジトリに同梱）

リポジトリの `fmruby-core/tool/web/` にクライアント HTML が同梱されています。

```bash
cd fmruby-core/tool
ruby web_server.rb        # ポート 8080 で起動
# → ブラウザで http://localhost:8080 を開く
```

または `tool/server.sh` を使うこともできます。

!!! note "Web Bluetooth は localhost か HTTPS 必須"
    Web Bluetooth API はセキュリティ上の制約で `localhost` または HTTPS でしか動きません。`web_server.rb` が `localhost` で起動するため問題ありません。

### 方法 2: GitHub Pages 等の静的ホスティング

将来的には `https://family-mruby.github.io/file-manager` 等での提供を検討中です。

## 接続手順

1. 基板の電源を入れて起動完了を待つ（数秒）
2. ブラウザでクライアントを開く（`http://localhost:8080` 等）
3. 画面の **「Connect」ボタン** をクリック
4. ブラウザの BLE デバイス選択ダイアログから **「Family-mruby-XXXXXX」** を選択
5. 「ペア設定」ボタンを押す（OS によっては「接続」と表示）

!!! warning "Windows でうまく繋がらない場合"
    Windows の Bluetooth スタックは古いペアリング情報を保持して接続を妨げる場合があります。OS の Bluetooth 設定で **既存の `Family-mruby-*` を削除** してから再接続を試してください（本機はペアリングを保持しないため）。

## 対応コマンド

| コマンド | UI 操作 | 説明 |
|---|---|---|
| `LS` | ディレクトリを開く | ファイル・ディレクトリ一覧 |
| `CD` | パンくずリストをクリック | カレントディレクトリ変更 |
| `GET` | ファイルをクリック → ダウンロード | ファイル取得 |
| `PUT` | ドラッグ&ドロップ または「アップロード」 | ファイル送信 |
| `RM` | ファイル右クリック → 削除 | ファイル / 空ディレクトリ削除 |
| `MKDIR` | 「新規ディレクトリ」 | ディレクトリ作成 |
| `STATFS` | フッターに自動表示 | 容量情報 |

## ファイルのアップロード（PC → 基板）

1. クライアントで配置先ディレクトリへ移動（例: `/flash/app/myapps/`）
2. PC のエクスプローラからファイルをブラウザにドラッグ&ドロップ
3. 進捗バーが表示されて完了を待つ

複数ファイルを一度にドロップできます。

## ファイルのダウンロード（基板 → PC）

1. クライアントでファイルを表示
2. ダウンロードアイコンをクリック
3. PC の標準のファイル保存ダイアログで保存先を指定

## アップロード後の反映

アプリファイル (`.app.rb` / `.app.toml`) を `/flash/app/<dir>/` にアップロードしただけでは、**ランチャーには即座には現れません**。次のいずれかで反映できます:

- **ランチャーを開いて右クリック** — タイトルバーが「Rescanning...」になり、1〜2 秒で新アプリが表示される
- **本体を再起動** — 起動時のスキャンで自動的に乗る

詳細は [Hello World ▸ ランチャーで反映する](hello_world.md#ランチャーで反映する) を参照。

## 通信プロトコル概要（参考）

- COBS エンコード + CRC32 のフレーム
- フレーム構造: `[cmd 1B][json_len 2B BE][json][binary][CRC32 4B]` を COBS エンコード後 `0x00` 区切り
- GATT サービス UUID: 128bit（"FMARBYBLE" の文字列が UUID オクテットにエンコードされている）
- 4 つのキャラクタリスティック:
  - Device Info（read）
  - FS RX（write、ブラウザ → 基板）
  - FS TX（notify、基板 → ブラウザ）

詳細は `fmruby-core/main/drivers/ble/ble_task.c` 内のコメントを参照。

## 注意事項

### 大きいファイル

PUT / GET の最大チャンクサイズは **2KB**。フレームサイズ上限は 4KB。大きなファイルは内部で複数チャンクに分割されますが、転送時間は数 MB で十数秒程度を想定してください。

### 同時接続

同時に接続できるクライアントは **1 台**。別のブラウザで接続する場合は先に切断してください。

### 切断時の挙動

ブラウザが切断されると、基板側は再度アドバタイズを開始します。再接続時は再度クライアントから「Connect」を押します。

### 周波数干渉

WiFi と同じ 2.4GHz 帯を使うため、混雑環境では切断が起きることがあります。再接続でほぼ復旧します。

## トラブル

### デバイスが見つからない

- 基板の電源が入っているか
- 基板を再起動して数秒待つ
- ブラウザの Bluetooth 権限を確認
- OS 側で別のブラウザ・タブが繋がっていないか

### Connect が動かない

- Chrome / Edge を使っているか（Firefox / Safari は未対応）
- HTTPS または `localhost` でクライアントを開いているか

### Windows で繰り返し失敗

- OS の Bluetooth 設定から `Family-mruby-*` の既存登録を削除
- ペアリングを残さない設計のため、毎回新規接続として扱われる

## 関連

- 自作アプリの転送先: [Hello World](hello_world.md)
- ファイルシステム構造: [ファイル・I/O](../api/filesystem.md#マウントポイント)
