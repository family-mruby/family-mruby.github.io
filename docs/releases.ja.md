# リリースノート

各リリースで何が変わったかを、新しい順に記録しています。ファームウェアは
[書き込みツール](https://family-mruby.github.io/family-mruby-installer/) から入れます。
動いている版はシステムメニューの About で確認できます。
[Studio](getting_started/studio.md) は常に最新のものが動きます。

書き込むとフラッシュの内容は `/home` も含めて置き換わります。残したいものは先に取り出して
おいてください ([コンソール](getting_started/console.md))。

## 2.1.0 — 2026-09-09

対象: Modern、Retro、シミュレータ、Studio。

### 新しくできること

- **Family mruby スタジオ。** ファームウェアを WebAssembly にして公開しました。デスクトップ
  もエディタも音源も、何も入れずにブラウザのタブで動きます。
  → [Studio](getting_started/studio.md)
- **アプリの店。** ランチャーの先頭に並びます。公開されている一覧を WiFi で取ってきて、
  本体に載るものを示し、`/app/usr` に入れます。実機 2 種とブラウザのどれでも動きます。
- **本体が自分でやること (Modern)。** 小さな常駐サービスが動きます。時計はネットワークから
  自分を合わせ、本体は自分のアドレスを知らせ、頼めば喋ります。一覧は書き換えられるファイル
  です。→ [システムサービス](file_formats/services.md)
- **色を変えられる。** 窓枠・デスクトップ・エディタ・シェルが、どれもシステムのテーマから色を
  とります。どの色も `/home/colors.toml` に名前で書いて上書きできます。シェルの `color`
  コマンドが代わりに書いてくれます。→ [配色](file_formats/colors.md)
- **どのアプリが何を開くかを 1 枚の表で決める。** `.md` は資料として開き、`.nsf` は音楽
  プレーヤーで開き、`.rb` は動きます。→ [ファイルの関連付け](file_formats/associations.md)
- **新しいアプリ。** PicoRabbit は Markdown で書いた資料を発表します。Robo Explorer は
  ロボットの頭脳を書かないと解けない迷路です。Modern には動画再生・マイクの音を見るアプリ・
  6 軸センサの表示が加わりました。→ [標準アプリ](getting_started/default_apps.md)
- **エディタの日本語。** `Ctrl` + `Space` でかな入力、漢字の表示、そして全画面のエディタ。
- **全メソッドのヘルプ。** エディタの `F1` が 577 個すべてに答えます (2 段構え)。
- **UI 部品。** ボタン、一覧、チェックボックスなどをアプリから使えます。
  → [UI 部品](api/ui.md)
- **`FmrbNet.request`。** アプリを止めずに取ってきます。実機でもブラウザでも同じ書き方です。
  → [ネットワーク](api/network.md#止まらずに取ってくる-fmrbnetrequest)
- **マウスのホイール。** エディタ・シェル・ログ・ファイル選択が送れます。
- **WiFi 越しのファイルとアプリが Retro でも。** `/fs` と `/app` は 2 機種とも答えます。
  Modern だけのものは画面です。→ [遠隔画面](remote_desktop.md#retro-では)
- **実機が自分で名乗る。** MAC から作った `fmruby-XXXXXX.local` です。`fmruby.local` にも
  引き続き答えます。→ [WiFi につなぐ](getting_started/wifi.md#実機が答える名前)
- **`boot_splash` と `startup_app`。** 起動時のロゴと音をとばす、あるいはデスクトップが出たら
  すぐ 1 つのアプリを開く。→ [デスクトップ](getting_started/desktop.md#デスクトップが出るまで)
- **WAV の再生 (Modern)。** `play_wav` が音源の上にファイルを重ねて鳴らします。
- **`/home` はあなたのもの。** サンプル・スプライト・音・資料は `/usr/share` に移り、`/home`
  は空の状態で出荷します。→ [ファイル・I/O](api/filesystem.md#home-はあなたのもの)

### 変わったこと

- `on_event` で `super(ev)` を呼ぶ必要がなくなりました。基底クラスは自分の状態を `@_` 付きの
  名前に持ち、`@running` / `@name` は `running?` / `name` で読みます。2.0 向けに書いたアプリは
  そのまま動きます (古い `super(ev)` は空のメソッドに届くだけです)。
  → [FmrbApp](api/fmrb_app.md#アプリから読めるもの)
- テーマの見本は `light` / `dark` / `cyberpunk` になりました。`classic` は無くなり、それが
  指していた配色が `light` です。
- 落ちものパズルのサンプルは BlockGame になりました。変わったのは名前だけです。
- `flappy.rb` は、他のアプリと同じ `flappy.app.rb` になりました。
- Studio はページ側で配色を選ばなくなりました。本体の Config でテーマを選びます。
- Modern のアプリ用プールは 1024 KB、`large_memory = 1` で 2048 KB になりました。Retro は
  変わりません。→ [制約事項](limitations.md#ヒープのサイズ)
- `app_spawn_margin_kb` で、アプリを起動するときにシステム側へ残す内蔵 RAM を決められます。
  → [システム設定](file_formats/system_conf.md)

### 更新するときは

!!! warning "Retro は 2 つのチップとも書き込んでください"
    2 つのチップの間の通信仕様が 4 から 5 に変わり、検査は厳密です。2.0.x の
    `fmruby-graphics-audio` と 2.1.0 の `fmruby-core` の組み合わせでは起動しません。
    [書き込みツール](https://family-mruby.github.io/family-mruby-installer/) から両方を
    書き込んでください。→ [ファームウェアの更新](getting_started/firmware_update.md)

Modern は 1 チップ構成なので、Tab5 のファームウェアだけで済みます。

## 2.0.1 — 2026-08-08

保守のためのリリースです。開発機が残したキャッシュがフラッシュの中身に混ざらなくなり、
`[[launcher_exclude]]` でアプリの分類ごとランチャーから隠せるようになり、Retro の壁紙が
シミュレータと同じように WROVER へ届くようになりました。

通信仕様は 2.0.0 と同じ 4 なので、2.0.0 の実機には片方のチップだけの書き込みで足ります。

## 2.0.0 — 2026-08-07

2 つ目の機種が加わったリリースです。

### 新しくできること

- **Modern (ESP32-P4)。** 市販の M5Stack Tab5 をブラウザから書き込んで使います。内蔵の液晶、
  スピーカー、タッチ、WiFi がそのまま使えます。→ [Modern](getting_started/modern.md)
- **遠隔画面。** Tab5 が自分の画面を WiFi で配信し、同じネットワークのブラウザからパソコンの
  キーボードとマウスで操作できます。→ [遠隔画面](remote_desktop.md)
- **FMRuby BASIC。** Family BASIC 互換の言語です。専用のテキスト画面、スプライト、音を
  持ちます。→ [MicroPython と BASIC](other_languages.md)
- **MicroPython。** `.py` のファイルが普通のアプリとして動きます。
- **MIDI。** Tab5 の GROVE 端子からのシリアル MIDI 出力、Ruby からの MML、標準 MIDI ファイルの
  再生。→ [MIDI](api/midi.md)
- **実機の上のデバッガ。** エディタからブレークポイントと変数を見られます。同じものを
  パソコンから BLE や TCP 経由でも使えます。→ [デバッグ](debugging.md)
- **`Ctrl` + `Tab`。** 動いているアプリを切り替え、全画面のアプリはその場に退避します。
  → [デスクトップ](getting_started/desktop.md)
- **アプリごとのスタック。** `.app.toml` の `task_stack_kb` で、既定より多く要るアプリに
  割り当てられます。→ [アプリの設定](file_formats/app_toml.md)
- カーネルとデスクトップの標準エンジンが Spinel (事前コンパイル) になり、起動時の走査が
  13 秒から 7.8 秒になりました。
- ファイルの置き方が今の形になりました (`/app`、`/usr/share`、`/etc`、`/var`。`/data` は
  廃止)。
- Tab5 のタッチで、2 本指のタップが右クリックになりました。

### 更新するときは

Retro は 2 つのチップとも書き込んでください。通信仕様が 3 から 4 に変わっています。

## 1.0.0 — 2026-05-19

最初のリリースです。Retro (narya-board) で、デスクトップ、ランチャー、エディタ、シェル、
タイルマップ、角の丸い窓が動きます。パソコン側のブラウザで動くスプライトエディタと
マップエディタも付いています。
