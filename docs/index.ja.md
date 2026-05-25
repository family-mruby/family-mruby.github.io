# Family mruby ドキュメント

<div align="center">
  <img src="../images/topimage.png" width="500" alt="Family mruby Logo">
</div>

## Family mrubyとは

Family mruby とは、キーボード、マウス、モニターを、ESP32マイコンボードに接続して、Rubyアプリの開発を楽しめる環境です。

PicoRubyをベースとして、OSが実装されていることが特徴です。

PicoRubyでグラフィカルなアプリケーションを簡単に実装することができ、外部接続した電子デバイスを制御したり、単体でゲームを作るなど、いろいろな遊び方ができます。

### 機器を接続した様子

色々な機器を繋いでみた様子です。（販売品には付属してません）

![機器を接続した様子](images/connected.JPG)

## デモ動画

<iframe width="560" height="315" src="https://www.youtube.com/embed/9vkRaOoxJJI?si=3cVBhbfFsFDwEQny" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 実行環境

専用の基板を[BOOTH](https://booth.pm/ja/items/8128031)で販売しています。

回路図、ガーバーデータやBOMはすべて公開しているので、互換品を作ることもできます。


## 使い方

詳細は [基本的な使い方](getting_started/booth) を参照。

## リポジトリ

- [ファームウェア](https://github.com/family-mruby/family-mruby)
- [基板データ](https://github.com/family-mruby/narya-board)

## 開発の背景

昔、子供が最初に触れるプログラミング言語といえば、BASICという時代がありました。 制約は多いですが、パソコン以外にも、MSXやファミコンでBASICができるFamily BASICという製品もあり、そこからプログラミングの面白さを知り、プログラマーになった方もたくさん居られると思います。

そして現在は無料で大抵のプログラミング言語の開発環境はパソコンにインストールすることができる時代になりましたが、できることが多すぎて何をしたらよいのかわからなかったり、Hello Worldの先のゲームを作ったりするまでの環境構築ハードルが高かったり、するような気がしています。

そこで、マイコン一つでちょっとしたゲームなどをスクリプト言語で作れる環境を作ってみたい、と思って開発したのが、Family mruby です。
