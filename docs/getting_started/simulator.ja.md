# シミュレータ（実機なしで試す場合）

基板を持っていなくても、DockerとPC のブラウザだけで Family mruby を試すことができます。

## 必要なもの

- Docker（PC）
- 最新のブラウザ（Chromeで動作確認してます）

## 起動

```bash
docker run --rm -p 6080:6080 ghcr.io/family-mruby/fmruby-desktop:latest
```

起動後、ブラウザで以下を開きます:

[http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)

VNC ビューア（noVNC）に Family mruby のデスクトップが表示されるので、そのままマウス・キーボードで操作できます。

## 動作確認済み環境

| OS | 状況 |
|---|---|
| Linux (x86_64) | ◯ 確認済み |
| Windows (WSL2) | ◯ 確認済み |
| macOS (Apple Silicon) | △ ARM64 イメージあり、未検証 |

ARM64 のイメージも公開されているので Mac でも動くはずですが、未検証です。

## 制限

| 項目 | 状況 |
|---|---|
| 映像出力 | OK |
| キーボード入力 | OK |
| マウス入力 | OK |
| 音声出力 | N/A（VNC 環境のため） |
| ゲームパッド | N/A |
| GPIO / I2C / RMTなどのHW機能 | N/A |

音や物理ハードウェアを試したい場合は実機を使ってください。

## 終了

Docker のコンソールで `Ctrl+C` を押すか、別ターミナルで `docker stop` してください。`--rm` オプション付きで起動しているので、コンテナは自動削除されます。

## PC上で本体開発する場合

各リポジトリのReadme参照。
