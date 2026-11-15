# リリースノート

各リリースで何が変わったかを、新しい順に記録しています。ファームウェアは
[書き込みツール](https://family-mruby.github.io/family-mruby-installer/) から入れます。
動いている版はシステムメニューの About で確認できます。
[Studio](getting_started/studio.md) は常に最新のものが動きます。

書き込むとフラッシュの内容は `/home` も含めて置き換わります。残したいものは先に取り出して
おいてください ([コンソール](getting_started/console.md))。

## 開発中 (3.0.0 の後)

まだリリースには入っていません。開発中の版 (と、それから作っている [Studio](getting_started/studio.md))
の今の姿で、このサイトの各ページはこちらに合わせてあります。

### 変わったこと: アプリの書き方

3.0.0 向けに書いたアプリは、少し直す必要があります。

- **ファイルの末尾に起動のコードを書きません。** ファイルが定義した `FmrbApp` の子クラスを
  ランタイムが起動します。末尾の `MyApp.new.start` (と `begin`/`rescue`) は消してください。
  子クラスが 2 つ以上あるファイルは、記述に `class = "MyApp"` と書いて起動するものを名指しします。
  決まらないときや起動中の例外は、理由がエラーウィンドウに出ます。 → [Hello World](getting_started/hello_world.md)
- **`@gfx` はアプリの描画領域の左上から描きます。** 枠のあるウィンドウでは枠の内側、枠なしではウィンドウの左上、
  全画面では画面の左上です。`@user_area_x0` と `@user_area_y0` は無くなったので、
  `@user_area_x0 +` の足し算を消してください。マウスの `ev[:x]` / `ev[:y]`、スプライト、UI 部品も
  同じ原点です。ウィンドウの座標が要るときは `ev[:wx]` / `ev[:wy]` と `window_gfx` を使います。
  → [描画](api/fmrb_gfx.md#座標系)
- **本体を変えるメソッドは `FmrbSystem` へ。** 本体の設定を変える 34 個のクラスメソッド
  (`reboot`、`set_wallclock`、WiFi・BLE・電源・音量の設定など) は `FmrbSystem.<名前>` になりました。
  `FmrbApp.<名前>` には、アプリが読むものが残ります。 → [アプリ](api/fmrb_app.md#本体の設定-fmrbsystem)
- `clear_time` は `clear_timer` になりました。
- **記述を `.rb` の中に。** `.app.toml` のキーは、ファイル先頭の `#---fmrb` コメントにも書けます。
  両方あるときは `.app.toml` のキーが勝ちます。 → [アプリ設定](file_formats/app_toml.md#rb-ファイルの中の記述)
- **Lua のアプリ**は本体が用意するアプリシェルの上で動きます。`on_create` / `on_update` / `on_event` を
  定義し、グローバルの `gfx` で描きます。 → [ほかの言語](other_languages.md#lua)

### 新しいこと

- **漢字変換**。SD カードの辞書を使って、かな入力から変換します。
  → [デスクトップ](getting_started/desktop.md#かな入力)
- **画面から WiFi**。Network の画面から Wi-Fi のページを開き、ネットワークを選んでパスワードを
  打ちます。5 つまで覚え、届く範囲でいちばん強いものにつなぎます。 → [WiFi につなぐ](getting_started/wifi.md)
- **ウィンドウメニュー**。タイトルバーの右クリックで、送る・読み直し・閉じる。
- **枠なしのウィンドウ** (`window_frame = "none"`) と、見本のアバター。
  → [アプリ設定](file_formats/app_toml.md#枠なしのウィンドウ)
- **Asterism の通信の決まり (wire protocol) 2** (asterism gem 0.14.0)。接続がオブジェクトになり、
  トピックは型を宣言し、特定のオーナーを持たないデータは共有スペース (shared place) に置きます。3.0.0 とは通信の互換が
  ありません。 → [ネットワーク](api/network.md#asterism-端末をまたぐオブジェクトとトピック)
- **端末の間でファイルとアプリを送る** (Asterism)。受け取るかどうか、誰から受け取るかは
  「受け取り」アプリで決めます。Shell の `move` は `amove` になり、`asend`・`anodes`・`areceive` が
  加わりました。 → [Shell のコマンド](getting_started/shell.md#端末の間でアプリとファイルを運ぶ)
- **Linux 版**: 画面全体の CRT 風の表示、電源メニューのログアウト、タッチパッドのタップと
  タッチパネル、TLS のルータへの接続、arm64 のパッケージ。 → [Linux 版](getting_started/linux.md)
- `/app/test` は、リリースのイメージと公開しているブラウザ版から外しました。

## 3.0.0 — 2026-11-07

Modern、Retro、画面の無い小型機、Linux 版、Studio が対象です。

### 新しいこと

- **Linux 版**。Linux のパソコンで 1 つのプログラムとして動く Family mruby です。GitHub の
  リリースに amd64 の `.deb` (Ubuntu 26.04 以降) があり、ログイン画面で選びます。
  → [Linux 版](getting_started/linux.md)
- **画面の無い小型機**。M5Stack StickS3 と AtomS3R が、Asterism のネットワーク上で 1 つのアプリを
  動かします。Web Installer から書き込めます。
- **動いているアプリを運ぶ**。`movable = true` を宣言したアプリは、イメージに書いて、同じ端末でも
  別の端末でも続きから動かせます。 → [アプリ](api/fmrb_app.md#動いているアプリを運ぶ)
- **Asterism**。同じネットワークの端末どうしが Ruby のオブジェクトを呼び合います。ゲームのホストを使う卓の
  アプリとして、ヒデ雀 (麻雀)・オセロ・お絵かきが入りました。
  → [標準アプリ](getting_started/default_apps.md#ゲーム--appgame)
- **全画面の高解像度**。`fullscreen_hires = true` のアプリは、Modern とスタジオで全画面の間だけ
  640x360 で動きます。
- **消音と音量**。メニューバーのスピーカーを押すと本体全体が消音になり、Config に 0〜10 の
  音量があります。どちらも覚えておきます。全機種と Studio で同じです。
  → [デスクトップ](getting_started/desktop.md#音)
- **デスクトップのアイコン**。Launcher、Editor、Shell、File Manager といくつかのアプリが壁紙に
  並びます。ランチャーの右クリックのメニューで置いたり外したりできます。
  → [デスクトップ](getting_started/desktop.md#デスクトップのアイコン)
- **電源ボタン**がメニューバーの右端に付きました。Reset はシステムメニューからここへ移りました。
- **BLE設定受付**。本体で開く数分間だけ、Web コンソールが WiFi・Asterism の設定とキーを
  読み書きできます。それ以外のときにリモートから読まれることはありません。読み上げサービスの
  API キーは、サービスの一覧から `/home/secrets.toml` へ移りました。
  → [システムサービス](file_formats/services.md#読み上げ)
- **エディタのフォント**。View → Font で 8・12・16 ピクセルから選べ、`/home/editor.toml` に
  残ります。
- **クリップボードを 1 つに**。全アプリで共有し、Linux 版では PC の、Studio ではページの
  クリップボードとつながります。`FmrbApp.clipboard` / `FmrbApp.set_clipboard`。
- **アプリの画面向けの小さな道具**。`@gfx` の `fit_text`・`wrap_text`・`draw_text_lines`・
  `draw_button` と、画面をまるごと描くときの `FmrbUI::HitAreas`。
  → [描画](api/fmrb_gfx.md#幅に収める)、[UI 部品](api/ui.md#画面をまるごと描くときのクリック範囲-fmrbuihitareas)
- **アプリの設定と状態**。`app_settings` (`/home`) と `app_state` (`/tmp`)。File Manager は閉じたときの
  フォルダで開き直します。 → [アプリ](api/fmrb_app.md#設定と覚えておく状態)
- `FmrbAudio#main_volume=` で曲だけの音量を変えられます。 → [音声](api/audio.md#曲だけの音量)
- 大きさを変えられるウィンドウには、右下の角につかむための三角が出ます。File Manager は
  削除の前に確認します。
- ランチャーの探し直しは、タイトルバーの **再読込** ボタン (か `F5`) になりました。

### 変わったこと

- **ESP32-S3 の端末のアプリのメモリ**。プールは全部で 3 つ (通常 1 つと大きい方 2 つ) で、
  同時に動くユーザアプリは 3 つまでです。 → [制約事項](limitations.md#ヒープのサイズ)
- WiFi の設定は `/home/wifi.toml` を先に、無ければ `/etc/wifi.toml` を読みます。
- 実機の HTTPS は、全部入りの証明書の束ではなく、絞ったルート証明書の組を信頼します。

### 更新するとき

core と graphics-audio のファームウェアは同じ版でなければなりません。Retro では両方のチップに
書き込んでください。開発版の漢字変換で使う辞書は 3.0.0 には含まれていません。

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
- **色を変えられる。** ウィンドウ枠・デスクトップ・エディタ・シェルが、どれもシステムのテーマから色を
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
タイルマップ、角の丸いウィンドウが動きます。パソコン側のブラウザで動くスプライトエディタと
マップエディタも付いています。
