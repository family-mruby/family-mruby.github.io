# Family mruby ドキュメント

<div align="center">
  <img src="/images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## Family mruby とは

Family mruby は、RubyとC言語で実装された、Rubyで書かれたアプリケーションを実行できる、マイコン向けのWindow GUI のOSです。

パソコンを利用せずとも、それ単体で、キーボードとマウス、ディスプレイをつないで、プログラミングを楽しめる環境を目指しています。

<div align="center">
  <img src="/images/photo_editor_run.jpg" width="620" alt="flappy.app.rb を開いたエディタと、そこから起動したゲームが隣の窓で動いている">
  <br><em>エディタ、そのコードを実行した結果のアプリ</em>
</div>

[PicoRuby](https://github.com/picoruby/picoruby) を FreeRTOS の上で実行しています。
FreeRTOSのタスク機能を利用して、Rubyアプリを同時に動かすことができ、それぞれが独立したメモリ領域を持ちます。

## ModernとRetro

|  | **Modern** | **Retro** |
|---|---|---|
| ハードウェア | [M5Stack Tab5](https://docs.m5stack.com/ja/core/Tab5) | [narya-board](https://github.com/family-mruby/narya-board) (専用基板) |
| 主要チップ | ESP32-P4 (デュアルコア RISC-V) + ESP32-C6 | ESP32-S3 + ESP32-WROVER |
| 画面 | 本体内蔵の 1280x720 IPS 液晶 (MIPI-DSI) | NTSC コンポジット出力 |
| 表示バッファ | 426 x 240 を 3 倍に拡大して表示 | 320 x 240 |
| 音 | 内蔵スピーカー、ヘッドホン端子 | 3.5mm ライン出力 |
| 入力 | USB キーボード・マウス、タッチパネル、Tab5 Keyboard | USB キーボード・マウス |
| 通信 | 内蔵 ESP32-C6 経由の WiFi / BLE | ESP32-S3 の WiFi / BLE |
| その他 | WiFi経由のリモートデスクトップ | RCA 映像出力、GROVE x2、RTC |

NTSC出力を持つNarya v3基板で動いていた Family mrubyは Retro と呼ぶことにしました。
Modern は、より高解像度のデジタルディスプレイを前提として、より本格的に開発環境として使うことを想定したバリエーションとして定義しています。
今はTab5で使うことができます。

[機種の選択](getting_started/choose_hardware.md) に詳細を記載しています。

<div align="center">
  <img src="/images/photo_two_machines.jpg" width="700" alt="左が Retro、右が Modern。同じOSが動いいます">
  <br><em>左が Retro (Narya v3基板 をモニタにつないできる)、右が Modern (M5Stack Tab5)</em>
</div>

## デモ動画

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 実行環境の入手

Modern は市販の [M5Stack Tab5](https://docs.m5stack.com/ja/core/Tab5) が使えます。
Tab5キーボードにも対応しています。

Retro は専用基板が必要です。[BOOTH](https://booth.pm/ja/items/8128031) で
販売しています。回路図、ガーバーデータ、BOM はすべて公開しているので、互換品を作ることも
できます。

## リポジトリ

- [ファームウェア](https://github.com/family-mruby/family-mruby)
- [基板データ](https://github.com/family-mruby/narya-board)
- [書き込みツール](https://github.com/family-mruby/family-mruby-installer)

## 開発の背景

昔、子供が最初に触れるプログラミング言語といえば、BASICという時代がありました。 制約は多いですが、パソコン以外にも、MSXやファミコンでBASICができるFamily BASICという製品もあり、そこからプログラミングの面白さを知り、プログラマーになった方もたくさん居られると思います。

そして現在は無料で大抵のプログラミング言語の開発環境はパソコンにインストールすることができる時代になりましたが、できることが多すぎて何をしたらよいのかわからなかったり、Hello Worldの先のゲームを作ったりするまでの環境構築ハードルが高かったり、するような気がしています。

そこで、マイコン一つでちょっとしたゲームなどをスクリプト言語で作れる環境を作ってみたい、と思って開発したのが、Family mruby です。
