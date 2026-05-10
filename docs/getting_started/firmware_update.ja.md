# ファームウェア更新

ブラウザだけでファームウェアを書き込める **Web ベースのインストーラ** が公開されています。配布された基板に最新版を書き込みたい時、または 2 つの MCU のうちどちらかが壊れた時に使います。

公開 URL: [https://family-mruby.github.io/family-mruby-installer/](https://family-mruby.github.io/family-mruby-installer/)

リポジトリ: [https://github.com/family-mruby/family-mruby-installer](https://github.com/family-mruby/family-mruby-installer)

## 必要なもの

| 項目 | 推奨 |
|---|---|
| Web Serial 対応ブラウザ | **Chrome / Edge / Opera** （デスクトップ版）。Firefox / Safari は不可 |
| USB Type-C ケーブル | データ通信対応のもの（充電専用ケーブルでは書き込めません） |
| 書き込み対象の MCU | fmruby-core (ESP32-S3) または fmruby-graphics-audio (ESP32-WROVER) |

## 書き込み手順

Family mruby 基板には **MCU が 2 つ** 載っており（メイン処理の fmruby-core と、映像／音声の fmruby-graphics-audio）、それぞれ独立にフラッシュ書き込みします。インストーラ画面に各 MCU 用のボタンが用意されています。

1. ブラウザで [インストーラ](https://family-mruby.github.io/family-mruby-installer/) を開く
2. 基板を **USB Type-C ケーブルで PC に接続**（ケーブルはデータ対応のものを使用）
3. ドロップダウンから書き込みたい **バージョン** を選択
4. 書き込み対象に応じて以下のいずれかをクリック:
    - **`fmruby-core`** ボタン: メイン MCU を書き込む
    - **`fmruby-graphics-audio`** ボタン: 映像/音声 MCU を書き込む
5. ブラウザのダイアログで **シリアルポート** を選択
6. 自動的にチップ判定が行われ、**書き込み開始**

!!! warning "対象 MCU を間違えるとどうなる？"
    インストーラはチップファミリ（ESP32-S3 / ESP32）を **自動チェック** します。誤った MCU を書き込もうとすると拒否されるので、機材を壊す心配はありません。

!!! note "両方の MCU を更新するとき"
    新しいバージョンに揃える場合は、`fmruby-core` と `fmruby-graphics-audio` の両方を順番にフラッシュしてください。プロトコルバージョンが揃わないと起動時にエラーになります（[アーキテクチャ](../architecture.md) 参照）。

## どの USB に繋ぐか

基板には用途別の USB Type-C ポートがあります:

- **fmruby-core 側 USB-C** に繋ぐと → fmruby-core を書き込み可能
- **fmruby-graphics-audio 側 USB-C** に繋ぐと → fmruby-graphics-audio を書き込み可能

両方の MCU を更新するときは USB ケーブルを差し替える必要があります。

## ブラウザの対応状況

| OS | Chrome / Edge | Firefox | Safari |
|---|---|---|---|
| Windows | ◯ | ✗ | – |
| macOS | ◯ | ✗ | ✗ |
| Linux | ◯ | ✗ | – |
| Android | ◯ | ✗ | – |
| iOS / iPadOS | ✗ | ✗ | ✗ |

iOS は OS 制約で Web Serial が使えません。デスクトップから書き込んでください。

## トラブル時のチェック

### ブラウザがシリアルポートを認識しない

- ケーブルが **データ通信対応** か確認（充電専用 USB-C ケーブルでは認識しません）
- USB ハブを介さず PC に直接挿す
- 別の USB ポートを試す
- ESP32 チップ用の USB シリアルドライバが OS にインストールされているか確認（最近の OS は標準で入っています）

### 書き込み中に失敗する

- USB ケーブルや接続を疑う（電力不足や接触不良が原因のことが多い）
- もう一度クリック → ポート選択 で再試行
- それでも失敗するなら、別の PC やブラウザを試す

### 書き込み後に画面が出ない

- **両方の MCU が同じプロトコルバージョン** か確認。古い fmruby-core × 新しい fmruby-graphics-audio などの組み合わせは起動に失敗します
- 両方とも最新版に揃えて書き込む

## 関連

- [起動と接続](setup.md) — 書き込み後の動作確認
- [アーキテクチャ](../architecture.md) — fmruby-core と fmruby-graphics-audio の役割
- [BLE ファイルマネージャ](ble_file_manager.md) — アプリファイル（`.app.rb` 等）の更新は BLE 経由が便利
