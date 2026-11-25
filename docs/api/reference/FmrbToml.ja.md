# FmrbToml

TOML の設定を読む・行ごとに書き換える

`load` でファイル、`parse` で文字列を Hash にする。**読めなかったときは例外でなく nil** で、理由は `FmrbToml.error`。書くのは `update` だけで、**指したキーの行だけを書き換える**ので、人が手で書いたコメント・順序・知らないキーが残る。
```ruby
conf = FmrbToml.load("/home/app.toml")
n = conf ? conf["name"] : nil
```

## クラスメソッド

### FmrbToml.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> text) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

文字列の TOML を Hash にする

表 (`[a]`) は Hash、配列は Array、`[[name]]` は Hash の Array。文字列・整数 (`0x..` も)・小数・true/false はそのまま。**日付と引用符の無い 1 語 (`bg = black`)** は、書かれた文字列のまま返る。

TOML でないと (1 行の誤りでも) nil。理由は `FmrbToml.error`。例外は出ない。
```ruby
FmrbToml.parse("a = 1\n[s]\nb = \"x\"\n")
#=> {"a"=>1, "s"=>{"b"=>"x"}}
```

### FmrbToml.load

<pre class="fmrb-sig"><code>load(<a href="../String/">String</a> path) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

ファイルの TOML を Hash にする

ファイルが無いと nil (ログは出さない。設定を誰も変えていない普通の状態)。読めない・
TOML でないと nil で、ログに 1 行 (`toml: パス: 理由`) が出る。どちらも理由は
`FmrbToml.error`。
```ruby
conf = FmrbToml.load("/home/app.toml")
```

### FmrbToml.error

<pre class="fmrb-sig"><code>error() -&gt; <a href="../String/">String</a>?</code></pre>

直前の読み書きが nil になった理由

成功した後は nil。
```ruby
Log.warn(FmrbToml.error) if conf.nil?
```

### FmrbToml.update

<pre class="fmrb-sig"><code>update(
  <a href="../String/">String</a> path,
  <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped] values
) -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, untyped]?</code></pre>

ファイルのキーだけ書き換える

values は `名前 => 値` の Hash。名前は先頭のキー (`"rise_mg"`) か `"表.キー"`
(`"editor.bg"`。最後の `.` で表とキーに分ける)。キーが無ければ足し (表が無ければファイルの終わりに足す)、**値が nil ならそのキーを消す**。値は文字列・Symbol (文字列で書く)・整数・小数・true/false・Array・Hash、または `FmrbToml.raw` の「引用符なし」。

書いたあとに読み直して、値が入っていれば**書いた後の Hash**を返す。ファイルがあるのに
TOML でないときは**触らずに** nil (人の文章だから)。書けない・読み戻して合わないときも nil。いずれも理由は `FmrbToml.error`。ファイルが無ければ作る。
```ruby
FmrbToml.update("/home/app.toml",
                { "editor.bg" => 36 })
```

### FmrbToml.raw

<pre class="fmrb-sig"><code>raw(<a href="../String/">String</a> text) -&gt; <a href="../FmrbToml__Raw/">FmrbToml::Raw</a></code></pre>

引用符を付けずにそのまま書く値

`update` に渡すと、文字列でも引用符を付けずに書く (色の名前 `bg = black` など)。
```ruby
FmrbToml.update(path,
  { "shell.bg" => FmrbToml.raw("black") })
```

### FmrbToml.dump_value

<pre class="fmrb-sig"><code>dump_value(untyped value) -&gt; <a href="../String/">String</a></code></pre>

値 1 つの TOML の字

文字列は引用符で囲んでエスケープし、数と true/false はそのまま、Array と Hash は 1 行のインライン形。Symbol は文字列。**それ以外は ArgumentError** ("no TOML for クラス名")。
```ruby
FmrbToml.dump_value("a\"b")  #=> "\"a\\\"b\""
```

### FmrbToml.dump_key

<pre class="fmrb-sig"><code>dump_key(<a href="../String/">String</a> key) -&gt; <a href="../String/">String</a></code></pre>

キーの TOML の字

英数字と `_`・`-` だけならそのまま、ほかは引用符で囲む。
```ruby
FmrbToml.dump_key("a b")  #=> "\"a b\""
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
