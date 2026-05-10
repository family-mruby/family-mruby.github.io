# シミュレータ（実機なしで試す）

基板を持っていなくても、PC のブラウザだけで Family mruby OS を試せます。Docker でシミュレータを起動する方法を紹介します。

## おすすめ: VNC デスクトップ（ブラウザで完結）

ビルド済みの Docker イメージに **すべてのバイナリと VNC サーバ** が同梱されています。1 コマンドで起動して、ブラウザで操作できます。

### 必要なもの

- Docker（PC）
- 最新のブラウザ（Chrome / Firefox / Safari どれでも可）

### 起動

```bash
docker run --rm -p 6080:6080 ghcr.io/family-mruby/fmruby-desktop:latest
```

起動後、ブラウザで以下を開きます:

[http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)

VNC ビューア（noVNC）に Family mruby OS のデスクトップが表示されるので、そのままマウス・キーボードで操作できます。

!!! tip "VNC クライアントは不要"
    noVNC が同梱されているため、ブラウザだけで完結します。専用 VNC クライアントのインストールは不要です。

### 動作確認済み環境

| OS | 状況 |
|---|---|
| Linux (x86_64) | ◯ 確認済み |
| Windows (WSL2) | ◯ 確認済み |
| macOS (Apple Silicon) | △ ARM64 イメージあり、未検証 |

ARM64 のイメージも公開されているので Mac でも動くはずですが、未検証です。

### 制限

| 項目 | 状況 |
|---|---|
| 映像出力 (画面表示) | ◯ |
| キーボード入力 | ◯ |
| マウス入力 | ◯ |
| **音声出力** | ✗ **非対応**（VNC 環境のため） |
| ゲームパッド | ✗ |
| GPIO / I2C / RMT | ✗（実機専用ペリフェラル） |

音や物理ハードウェアを試したい場合は実機を使ってください。

### 終了

Docker のコンソールで `Ctrl+C` を押すか、別ターミナルで `docker stop` してください。`--rm` オプション付きで起動しているので、コンテナは自動削除されます。

## SDL2 ローカル実行（ビルドできる人向け）

ソースからビルドして手元の Linux / WSL2 / macOS で試す方法もあります。Docker Compose 経由で SDL2 ウィンドウを起動します。

```bash
git clone --recurse-submodules https://github.com/family-mruby/family-mruby
cd family-mruby
rake fetch              # サブリポジトリ取得（初回のみ）
rake build:linux        # Linux 向けビルド
cp .env.example .env    # WSL or Ubuntu を選択
docker compose up
```

`.env` で `COMPOSE_FILE` を切り替えます:

- `docker-compose.yml:docker-compose.wsl.yml` — WSL2 + WSLg（既定）
- `docker-compose.yml:docker-compose.ubuntu.yml` — Linux ネイティブデスクトップ

詳細・前提パッケージは [親リポジトリの README](https://github.com/family-mruby/family-mruby#開発方法) を参照してください。

## どっちを使うか

| 用途 | おすすめ |
|---|---|
| とりあえず動かしたい / 配布前に確認したい | **VNC（Docker のみ）** |
| 開発中・自分でビルドしたバイナリを試したい | **SDL2（Docker Compose）** |
| 実機の代わりとして本番に近い動作を確認したい | 実機推奨 |

## 関連

- [起動と接続](setup.md) — 実機の使い方
- [コンソール](console.md) — シミュレータでは使えません（実機専用）
- [ファームウェア更新](firmware_update.md) — シミュレータには不要
- [ハードウェア](../hardware.md) — narya-board の仕様
