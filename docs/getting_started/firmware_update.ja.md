# ファームウェア更新

ファームウェアはブラウザから書き込みます。何もインストールする必要はありません。

書き込みツール: [https://family-mruby.github.io/family-mruby-installer/](https://family-mruby.github.io/family-mruby-installer/)

## 必要なもの

| 項目 | 条件 |
|---|---|
| ブラウザ | Chrome / Edge / Opera (パソコン版)。Firefox と Safari には Web Serial が無いので書き込めません |
| USB ケーブル | データ通信ができるもの。充電専用ケーブルはポート選択の一覧に出てきません |

## 書き込むチップの数

ここが機種で違い、間違えやすいところです。

| 機種 | 書き込むチップ | ツール上のボタン |
|---|---|---|
| **Modern** (M5Stack Tab5) | 1 つ (ESP32-P4) | `Connect & Flash Tab5 firmware` |
| **Retro** (narya-board) | 2 つ (ESP32-S3 と ESP32-WROVER を別々に) | `Connect & Flash fmruby-core` と `Connect & Flash fmruby-graphics-audio` |

書き込む前にチップの種別 (ESP32-P4 / ESP32-S3 / ESP32) を確認するので、ボタンを押し
間違えても、壊れるのではなくエラーになります。

!!! warning "書き込むと実機のファイルは置き換わります"
    書き込むイメージにはファイル領域が含まれます。実機に置いた自作アプリや、実機上で
    書き換えた設定ファイルは出荷時の内容に戻ります。残したいものは先に退避してください
    ([コンソール](console.md) を参照)。

## Modern (M5Stack Tab5)

1. [書き込みツール](https://family-mruby.github.io/family-mruby-installer/) を開く
2. データ通信ができる USB-C ケーブルで Tab5 とパソコンをつなぐ
3. **Family mruby Modern (Tab5)** の節へ移動する
4. バージョンを選ぶ (既定で最新)
5. **Connect & Flash Tab5 firmware** を押して、ポートを選ぶ
6. 完了を待って、再起動させる

Tab5 は USB-Serial-JTAG でつながるので、**ボタンを押しながら挿す必要はありません**。
書き込み後に書き込みモードのまま止まったとき — シリアルログに `waiting for download` が
出ているとき — だけ、リセットを 1 回押してください。

## Retro (narya-board)

基板に MCU が 2 つあり、それぞれ**基板上の別々の USB-C 端子**から書き込みます。

- **ESP32-S3 側**の端子から `fmruby-core` を書き込む
- **ESP32-WROVER 側**の端子から `fmruby-graphics-audio` を書き込む

1. [書き込みツール](https://family-mruby.github.io/family-mruby-installer/) を開く
2. 書き込むチップ側の端子に、データ通信ができる USB-C ケーブルをつなぐ
3. **Family mruby Retro** の節でバージョンを選ぶ
4. 対応するボタンを押し、ブラウザのダイアログでポートを選ぶ
5. もう一方のチップも、もう一方の端子から同様に書き込む

!!! note "2 つのバージョンは揃えてください"
    両方のチップに同じバージョンを書き込んでください。新しい `fmruby-core` と古い
    `fmruby-graphics-audio` の組み合わせでは正しく起動しません。両者の間の通信仕様が
    一致している必要があります。

## うまくいかないとき

### ブラウザにシリアルポートが出てこない

- データ通信ができるケーブルを使ってください。充電専用の USB-C ケーブルは出てきません
- USB 認証品を、できるだけ短いもので使ってください
- ハブを介さず、パソコンに直接つないでください
- 別の USB 端子を試してください
- そのチップ用の USB シリアルドライバが OS に入っているか確認してください
  (最近の OS には標準で入っています)

### 途中で書き込みが止まる

- ケーブルと接続を確認してください。電力不足や接触不良が原因のことが多いです
- もう一度ボタンを押して、ポートを選び直してください
- それでも駄目なら、別のパソコンかブラウザを試してください

### 書き込んだのに画面が出ない

**Modern**: リセットを 1 回押してください。ログが `boot:0x204 (DOWNLOAD...)` と
`waiting for download` で止まっていたら、書き込みモードに留まっているだけなので、
リセットで通常起動します。

**Retro**: 2 つのチップのバージョンが揃っているか確認してください。古い `fmruby-core` と
新しい `fmruby-graphics-audio` (またはその逆) では起動しません。同じ版を両方に
書き込んでください。
