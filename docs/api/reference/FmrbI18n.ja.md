# FmrbI18n

日本語と英語で表示を切りかえる。

## クラスメソッド

### FmrbI18n.add

<pre class="fmrb-sig"><code>add(<a href="../Hash/">Hash</a> table) -&gt; void</code></pre>

言葉の表を足す

アプリごとに自分の表を足す。**すでにある印を消さない**ので、デスクトップの表と並んで残る。
```ruby
FmrbI18n.add(
  "en" => { save: "Save" },
  "ja" => { save: "保存" })
```

### FmrbI18n.lang

<pre class="fmrb-sig"><code>lang() -&gt; <a href="../String/">String</a></code></pre>

今の言葉 ("ja" か "en")

アプリを別の端末へ移すと、着いた側の言葉になります。
```ruby
if FmrbI18n.lang == "ja"
  draw_ja
end
```

### FmrbI18n.t

<pre class="fmrb-sig"><code>t(<a href="../Symbol/">Symbol</a> key) -&gt; <a href="../String/">String</a></code></pre>

印から今の言葉の文を引く

印が表に無ければ印の名前がそのまま返る (落ちない)。
```ruby
@ui.set_text(:save, FmrbI18n.t(:save))
```

### FmrbI18n.text_width

<pre class="fmrb-sig"><code>text_width(<a href="../String/">String</a> str) -&gt; <a href="../Integer/">Integer</a></code></pre>

字を描いたときの横幅を測る

**日本語は 1 文字が 2 文字幅**なので、`length` では測れない。右寄せや中央寄せはこれで測る。
```ruby
w = FmrbI18n.text_width(s)
gfx.draw_text(320 - w, y, s)
```

### FmrbI18n.truncate_to

<pre class="fmrb-sig"><code>truncate_to(<a href="../String/">String</a> str, <a href="../Integer/">Integer</a> max_px, ?<a href="../String/">String</a> ellipsis) -&gt; <a href="../String/">String</a></code></pre>

幅に入るところまで切りつめる

文字の途中で切らない。切ったときは末尾に `ellipsis` (省略すると `".."`、12 ドット) を付け、付けた分も max_px に入れる。`""` を渡すと何も付けない。入るときはそのまま返す。
```ruby
s = FmrbI18n.truncate_to(name, 120)
```

### FmrbI18n.strings

<pre class="fmrb-sig"><code>strings() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../Hash/">Hash</a>[untyped, <a href="../String/">String</a>]]</code></pre>

言葉の表そのもの

言語 => 印 => 文 の Hash。`add` はここに書き込む。最初に聞かれたときに
`{ "en" => {}, "ja" => {} }` として作られる。
```ruby
FmrbI18n.strings["ja"][:save]
```

### FmrbI18n.forget

<pre class="fmrb-sig"><code>forget() -&gt; nil</code></pre>

覚えた言葉を忘れる

次の `lang` が端末の設定を読み直す。別の端末へ移されたアプリは
**土台が自分で呼ぶ**ので、ふつうのアプリは呼ばない。常に nil を返す。
```ruby
FmrbI18n.forget
```

### FmrbI18n.half_kana?

<pre class="fmrb-sig"><code>half_kana?(<a href="../String/">String</a> str, <a href="../Integer/">Integer</a> i, <a href="../Integer/">Integer</a> n) -&gt; bool</code></pre>

半角カナか

`i` バイト目からの 3 バイトが半角カタカナ (U+FF61 から U+FF9F) なら true。
**`i` は文字ではなくバイトの位置、`n` は文字列のバイト数**
(`bytesize`)。3 バイト残っていなければ false。`text_width` が半角カナを
4 ドットで数えるのに使う。
```ruby
s = "ｱ"
FmrbI18n.half_kana?(s, 0, s.bytesize)
#=> true
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
