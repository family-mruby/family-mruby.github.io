# Family mruby ドキュメント

<div align="center">
  <img src="../images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## Family mruby とは

Family mruby は、電源を入れるとそのまま Ruby の開発環境が立ち上がる小さなコンピュータです。

キーボードとマウスを挿して画面をつなげば、デスクトップ、ランチャー、エディタ、シェルが
出てきます。書いたプログラムは、書いたその機械の上で動きます。パソコン側の開発環境も、
クロスコンパイラも、書き込みの往復も要りません。エディタで F5 を押せばその場で動きます。

[PicoRuby](https://github.com/picoruby/picoruby) をベースに、独自の OS を載せています。
複数のアプリを同時に動かすことができ、それぞれが別々のメモリ領域を持ちます。

## 2 つの機械、1 つのシステム

バージョン 2.0 は、性格の違う 2 種類のハードウェアで動きます。同じ Ruby アプリが両方で動きます。

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

**Modern** は作るための機械です。単体で完結していて、画面が蓋についていて、パソコンの
ブラウザから WiFi 越しに操作できます。

**Retro** は遊ぶための機械です。本物の NTSC コンポジット映像を CRT に映せます。256 色の絵と、
それに合う 4 音のファミコン風の音が出ます。

どちらを読めばよいか迷ったら [機種の選択](getting_started/choose_hardware.md) へ。

<div align="center">
  <img src="../images/tab5_desktop.png" width="640" alt="M5Stack Tab5 で動く Family mruby のデスクトップ">
  <br><em>M5Stack Tab5 で動くデスクトップ</em>
</div>

## 2.0 の新機能

**2 つ目の機械**。Family mruby が M5Stack Tab5 で動くようになりました。ESP32-P4 が 1 個で
描画・音・入力・OS の全部をこなします。静電容量式タッチ、Tab5 Keyboard、日本語フォント、
内蔵スピーカーに対応しています。
→ [Modern (M5Stack Tab5)](getting_started/modern.md)

**画面をブラウザに**。Modern は自分の画面を WiFi で配信します。パソコンから本体のアドレスを
開けば、画面が見えて、パソコンのキーボードとマウスでそのまま操作できます。
→ [遠隔画面](remote_desktop.md)

**Ruby でネットワーク**。CRuby に似た書き味の `Net::HTTP`・WebSocket・TLS が入り、数行で
インターネットと話せるようになりました。両機種で使えます。
→ [ネットワーク](api/network.md)

**音を外に出す**。内蔵音源で鳴らすことも、GROVE 端子から外部音源へ MIDI を出すこともできる
MIDI 層。標準 MIDI ファイルの演奏アプリと、Ruby から使える MML も入りました。
→ [MIDI](api/midi.md)

**言語が 2 つ増えた**。`.bas` は Family BASIC 互換の FMRuby BASIC で、専用のテキスト画面と
スプライトを持ちます。`.py` は組み込みの MicroPython で動きます。どちらも Ruby のアプリと
同じようにランチャーから起動します。
→ [BASIC と MicroPython](other_languages.md)

**実機に届くデバッグ**。VS Code から TCP か BLE 越しに停止点を張れます。実機のエディタ自体にも
デバッガが入りました。
→ [デバッグ](debugging.md)

**速く、静かなシステムに**。カーネルを事前に機械語へコンパイルする方式に変えて入力の遅れが
減りました。デスクトップの起動は約 20 秒から約 6 秒に短縮。さらに、待機中のデスクトップが
メモリを一切確保しなくなったので、動かしているアプリから時間を奪わなくなりました。

## デモ動画

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 実行環境の入手

**Modern** は市販の [M5Stack Tab5](https://docs.m5stack.com/ja/core/Tab5) がそのまま使えます。
改造もはんだ付けも不要です。ブラウザから書き込めば起動します。

**Retro** は専用基板 narya-board が必要です。[BOOTH](https://booth.pm/ja/items/8128031) で
販売しています。回路図、ガーバーデータ、BOM はすべて公開しているので、互換品を作ることも
できます。

## 次に読むもの

- [機種の選択](getting_started/choose_hardware.md) — 2 機種の違い
- [Modern (M5Stack Tab5)](getting_started/modern.md) — Tab5 を箱から出してデスクトップが出るまで
- [起動まで (Retro)](getting_started/setup.md) — narya-board の配線と初回起動
- [Hello World](getting_started/hello_world.md) — 最初のアプリ
- [シミュレータ](getting_started/simulator.md) — 実機なしで Linux 上で動かす
- [API リファレンス](api/index.md) — アプリから呼べるもの

## リポジトリ

- [ファームウェア](https://github.com/family-mruby/family-mruby)
- [基板データ](https://github.com/family-mruby/narya-board)
- [書き込みツール](https://github.com/family-mruby/family-mruby-installer)

## 開発の背景

昔、子供が最初に触れるプログラミング言語といえば、BASICという時代がありました。 制約は多いですが、パソコン以外にも、MSXやファミコンでBASICができるFamily BASICという製品もあり、そこからプログラミングの面白さを知り、プログラマーになった方もたくさん居られると思います。

そして現在は無料で大抵のプログラミング言語の開発環境はパソコンにインストールすることができる時代になりましたが、できることが多すぎて何をしたらよいのかわからなかったり、Hello Worldの先のゲームを作ったりするまでの環境構築ハードルが高かったり、するような気がしています。

そこで、マイコン一つでちょっとしたゲームなどをスクリプト言語で作れる環境を作ってみたい、と思って開発したのが、Family mruby です。
