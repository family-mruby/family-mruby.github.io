# Asterism::Profile

端末の名乗り (Profile)

使い方は [ネットワーク](../network.md) のページにあります。

端末が自分で言う種類・名前・場所・アイコンの決まりと、PNG のアイコンを調べる関数。名乗りを変えるのは Connection#profile と Asterism.profile_defaults。

## クラスメソッド

### Asterism::Profile.png_info

<pre class="fmrb-sig"><code>png_info(untyped bytes) -&gt; <a href="../Array/">Array</a>[untyped]?</code></pre>

PNG のアイコンを調べる

名乗りに載せてよい PNG か見る: 8 バイトの印、8192 バイトまで、チャンクが
IHDR から IEND まで続くこと、一辺 256 画素まで。よければ
`[幅, 高さ, icon_hash]` (icon_hash は 8 桁の 16 進)、だめなら nil。
```ruby
w, h, hash =
  Asterism::Profile.png_info(png)
```

### Asterism::Profile.check

<pre class="fmrb-sig"><code>check(untyped h) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

受けた名乗りを整える

正しい項目 (kind・protocol・host・name・icon・icon_hash) だけを残す。
kind が正しくなければ nil。壊れたアイコンは hash ごと落ちる。
profile_of の答えはこれを通ってくる。
```ruby
p = Asterism::Profile.check(raw)
```

---

*このページは fmruby-core の develop@521eb2e7 の API の型定義 (`sig/`) から自動で作っています。*
