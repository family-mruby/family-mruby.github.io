# Family mruby ドキュメント

<div align="center">
  <img src="/images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## Family mruby とは

Family mruby は、電源を入れるとそのまま Ruby の開発環境が立ち上がる小さなコンピュータです。

キーボードとマウスを挿して画面をつなげば、デスクトップ、ランチャー、エディタ、シェルが
出てきます。書いたプログラムは、書いたその機械の上で動きます。パソコン側の開発環境も、
クロスコンパイラも、書き込みの往復も要りません。エディタで F5 を押せばその場で動きます。

<div align="center">
  <img src="/images/photo_editor_run.jpg" width="620" alt="flappy.app.rb を開いたエディタと、そこから起動したゲームが隣の窓で動いている">
  <br><em>エディタと、そこから起動したアプリ。実機の画面に並んでいます</em>
</div>

[PicoRuby](https://github.com/picoruby/picoruby) をベースに、独自の OS を載せています。
複数のアプリを同時に動かすことができ、それぞれが別々のメモリ領域を持ちます。

## 動かせる形

バージョン 2.1 は 4 つの形で動きます。同じ Ruby アプリがどれでも動きます。

| | 中身 | 入手 | 画面 | 音 | 通信 |
|---|---|---|---|---|---|
| Modern | M5Stack Tab5 (ESP32-P4 + ESP32-C6) | 市販品をブラウザから書き込む | 内蔵 1280x720 液晶 | 内蔵スピーカー | WiFi と BLE を同時に |
| Retro | narya-board (ESP32-S3 + ESP32-WROVER) | BOOTH、または自作 | NTSC コンポジット出力 | 3.5mm ライン出力 | WiFi か BLE のどちらか |
| シミュレータ | Linux (Docker) | 無料。機材は要らない | パソコンの窓 | パソコンの音 | ホスト経由 |
| Studio | ブラウザ (WebAssembly) | URL を開くだけ | ページの中。最大 852x480 | ページの中 | ページ越しに取得のみ |

機械としての本体は 2 つの基板です。シミュレータはこのシステム自体を開発している場所で、
書いたアプリは実機と同じように動きます。[Studio](getting_started/studio.md) は同じ
ファームウェアを WebAssembly にしたもので、何も持っていなくてもデスクトップとエディタを
試せます。

専用の ESP32-P4 基板 (NARYA v4) を設計中ですが、今回のリリースには入っていません。

## 2 つの機械

|  | **Modern** | **Retro** |
|---|---|---|
| ハードウェア | [M5Stack Tab5](https://docs.m5stack.com/ja/core/Tab5) | [narya-board](https://github.com/family-mruby/narya-board) (専用基板) |
| 主要チップ | ESP32-P4 (デュアルコア RISC-V) + ESP32-C6 | ESP32-S3 + ESP32-WROVER |
| 画面 | 本体内蔵の 1280x720 IPS 液晶 (MIPI-DSI) | NTSC コンポジット出力。CRT や取り込み機器へ |
| 表示バッファ | 426 x 240 を 3 倍に拡大して表示 | 320 x 240 |
| 音 | 内蔵スピーカー、ヘッドホン端子 | 3.5mm ライン出力 |
| 入力 | USB キーボード・マウス、静電容量式タッチ、Tab5 Keyboard | USB キーボード・マウス |
| 通信 | 内蔵 ESP32-C6 経由の WiFi / BLE | ESP32-S3 の WiFi / BLE |
| その他 | WiFi 越しにブラウザから画面操作、GROVE 端子 | RCA 映像出力、GROVE x2、電池で動く時計 |

Modern は作るための機械です。単体で完結していて、画面が蓋についていて、パソコンの
ブラウザから WiFi 越しに操作できます。

Retro は遊ぶための機械です。本物の NTSC コンポジット映像を CRT に映せます。256 色の絵と、
それに合う 4 音のファミコン風の音が出ます。

どちらを読めばよいか迷ったら [機種の選択](getting_started/choose_hardware.md) へ。

<div align="center">
  <img src="/images/photo_two_machines.jpg" width="700" alt="左が Retro、右が Modern。同じシェルが動いている">
  <br><em>左が Retro (narya-board をモニタにつないだところ)、右が Modern (M5Stack Tab5)。動いているシェルは同じもの</em>
</div>

## 2.1 の新機能

見どころを並べます。今回を含め、各リリースで何が変わったかは
[リリースノート](releases.md) にまとめてあります。

色を変えられる。窓枠・デスクトップ・エディタ・シェルが、どれもシステムのテーマから色を
とるようになりました。どの色も `/home/colors.toml` に名前で書いて上書きできます。シェルの
`color` コマンドが代わりに書いてくれます。
→ [配色](file_formats/colors.md)

機械が勝手にやること。Modern では小さな常駐サービスがいくつか動きます。時計はネットワークから
自分を合わせ、機械は自分のアドレスを知らせ、頼めば喋ります。一覧は書き換えられるファイルに
なっていて、自分で足すこともできます。
→ [システムサービス](file_formats/services.md)

自分のファイルと、こちらのファイルを分けた。`/home` はあなたのもので、空の状態から始まります。
ファームウェアに付いてくるサンプル・スプライト・音・資料は `/usr/share` に移りました。機械が
持ってくるものが `/home` に置かれることはありません。
→ [ファイル・I/O](api/filesystem.md#home-はあなたのもの)

どのアプリが何を開くかを 1 枚の表で決める。`.md` は資料として開き、`.nsf` は音楽プレーヤーで
開き、`.rb` は動きます。この表はファイルなので、どの行も上書きできます。
→ [ファイルの関連付け](file_formats/associations.md)

アプリの店。ランチャーの先頭に「アプリの店」が並びます。公開されている一覧を WiFi で
取ってきて、この機械に載るものを示し、`/app/usr` に入れます。ランチャーはそこを見るので、
入れたらすぐ起動できます。実機 2 種とブラウザのどれでも動きます。
→ [標準アプリ](getting_started/default_apps.md#常にあるもの)

新しいアプリ。PicoRabbit は Markdown で書いた資料を発表します。Robo Explorer はロボットの頭脳を
書かないと解けない迷路です。Modern には動画再生・マイクの音を見るアプリ・6 軸センサの表示が
加わりました。
→ [標準アプリ](getting_started/default_apps.md)

操作しやすいデスクトップ。タスクバーに開いている窓が並び、メニューバーがキーボードで操作でき、
`Ctrl+Tab` の巡回にデスクトップ自身も入りました。マウスホイールでエディタ・シェル・ログ・
ファイル選択が送れます。
→ [デスクトップ](getting_started/desktop.md)

WiFi でファイルを渡す。遠隔画面から本体のファイルを一覧・取得・送信・削除できるようになりました。
ケーブルなしでプログラムを機械に入れられます。
→ [遠隔画面](remote_desktop.md)

ブラウザの中で。ファームウェアを WebAssembly にもコンパイルしているので、デスクトップも
エディタも音源もブラウザのタブで動きます。何も入れる必要はありません。そこで作ったファイルは
ブラウザに残り、まとめて持ち出せます。ファイルやフォルダを投げ込むこともでき、パソコン側の
フォルダをつないでおけば、外で書き換えたものがそのまま機械に届きます。
→ [Family mruby スタジオ](getting_started/studio.md)

## デモ動画

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 実行環境の入手

Modern は市販の [M5Stack Tab5](https://docs.m5stack.com/ja/core/Tab5) がそのまま使えます。
改造もはんだ付けも不要です。ブラウザから書き込めば起動します。

Retro は専用基板 narya-board が必要です。[BOOTH](https://booth.pm/ja/items/8128031) で
販売しています。回路図、ガーバーデータ、BOM はすべて公開しているので、互換品を作ることも
できます。

## 次に読むもの

- [機種の選択](getting_started/choose_hardware.md) — 2 機種の違い
- [Modern (M5Stack Tab5)](getting_started/modern.md) — Tab5 を箱から出してデスクトップが出るまで
- [起動まで (Retro)](getting_started/setup.md) — narya-board の配線と初回起動
- [Hello World](getting_started/hello_world.md) — 最初のアプリ
- [WiFi につなぐ](getting_started/wifi.md) — 遠隔画面とネットワーク
- [シミュレータ](getting_started/simulator.md) — 実機なしで Linux 上で動かす
- [Family mruby スタジオ](getting_started/studio.md) — 同じシステムをブラウザのタブで
- [API リファレンス](api/index.md) — アプリから呼べるもの

## リポジトリ

- [ファームウェア](https://github.com/family-mruby/family-mruby)
- [基板データ](https://github.com/family-mruby/narya-board)
- [書き込みツール](https://github.com/family-mruby/family-mruby-installer)

## 開発の背景

昔、子供が最初に触れるプログラミング言語といえば、BASICという時代がありました。 制約は多いですが、パソコン以外にも、MSXやファミコンでBASICができるFamily BASICという製品もあり、そこからプログラミングの面白さを知り、プログラマーになった方もたくさん居られると思います。

そして現在は無料で大抵のプログラミング言語の開発環境はパソコンにインストールすることができる時代になりましたが、できることが多すぎて何をしたらよいのかわからなかったり、Hello Worldの先のゲームを作ったりするまでの環境構築ハードルが高かったり、するような気がしています。

そこで、マイコン一つでちょっとしたゲームなどをスクリプト言語で作れる環境を作ってみたい、と思って開発したのが、Family mruby です。
