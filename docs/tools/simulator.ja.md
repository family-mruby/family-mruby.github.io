# シミュレータ (実機なしで試す)

端末を持っていなくても、Docker と PC のブラウザだけで Family mruby を試せます。

## 必要なもの

- Docker (PC)
- 新しいブラウザ (Chrome で動作を確認しています)

## 起動

```bash
docker run --rm -p 6080:6080 ghcr.io/family-mruby/fmruby-desktop:latest
```

起動したら、ブラウザで次のアドレスを開きます。

[http://localhost:6080/vnc.html](http://localhost:6080/vnc.html)

VNC ビューア (noVNC) に Family mruby のデスクトップが表示され、そのままマウスとキーボードで操作できます。

## 動作確認済みの環境

| OS | 状況 |
|---|---|
| Linux (x86_64) | 確認済み |
| Windows (WSL2) | 確認済み |
| macOS (Apple Silicon) | ARM64 のイメージあり、未確認 |

ARM64 のイメージも公開しているので Mac でも動くはずですが、まだ確認していません。

## 制限

| 項目 | 状況 |
|---|---|
| 映像出力 | OK |
| キーボード入力 | OK |
| マウス入力 | OK |
| 音声出力 | 不可 (VNC 環境のため) |
| ゲームパッド | 不可 |
| GPIO / I2C / RMT などのハードウェア機能 | 不可 |

音やハードウェアの機能を試したい場合は、実機を使ってください。

## 終了

Docker を起動したコンソールで `Ctrl+C` を押すか、別のターミナルで `docker stop` を実行します。`--rm` オプション付きで起動しているので、コンテナは自動的に削除されます。

## PC 上で本体を開発する場合

各リポジトリの README を参照してください。

## 関連

- [開発ツール](index.md) — 開発ツールの一覧と、それぞれが使える機種
- [Family mruby スタジオ](../getting_started/studio.md) — インストールなしで、ブラウザだけで動かす
- [Linux 版](../getting_started/linux.md) — Linux の PC で 1 つのプログラムとして動かす
