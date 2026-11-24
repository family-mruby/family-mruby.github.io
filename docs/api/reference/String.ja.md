# String

## インスタンスメソッド

### String#!

<pre class="fmrb-sig"><code>!() -&gt; bool</code></pre>

真偽を反転する

文字列はいつも真なので、これは必ず false。
```ruby
!"a"  #=> false
```

### String#*

<pre class="fmrb-sig"><code>*(<a href="../Integer/">Integer</a> count) -&gt; String</code></pre>

文字列を指定の回数くり返す

**区切り線や埋め草を作る**のに使う。0 を渡すと空になる。
```ruby
"-" * 39
"\x00" * 16  # 16 バイトの入れ物
```

### String#+

<pre class="fmrb-sig"><code>+(String other) -&gt; String</code></pre>

文字列をつなげる

**足すたびに新しい文字列ができる**ので、ループで組み立てるなら `<<`。
```ruby
a = "foo" + "bar"
```

### String#<

<pre class="fmrb-sig"><code>&lt;(String other) -&gt; bool</code></pre>

辞書順で前かどうか

```ruby
"abc" < "abd"  #=> true
```

### String#<<

<pre class="fmrb-sig"><code>&lt;&lt;(String | <a href="../Integer/">Integer</a> string_or_codepoint) -&gt; String</code></pre>

文字列か文字コードを末尾に足す

**自分を書き換える**ので `+` より速い。数を渡すと文字コードとして足す。
```ruby
buf = ""
buf << "a"
buf << 65  # "A"
```

### String#<=

<pre class="fmrb-sig"><code>&lt;=(String other) -&gt; bool</code></pre>

辞書順で前か同じかどうか

```ruby
"abc" <= "abc"  #=> true
```

### String#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(String other) -&gt; <a href="../Integer/">Integer</a></code></pre>

辞書順で比べて -1 / 0 / 1 を返す

並べ替えの比べ物に使う。
```ruby
"a" <=> "b"  #=> -1
```

### String#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

**中身を比べる**。同じ物かどうかではない。
```ruby
"abc" == "abc"  #=> true
```

### String#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

case での等しさを判定する

```ruby
case s
when "quit" then finish
end
```

### String#>

<pre class="fmrb-sig"><code>&gt;(String other) -&gt; bool</code></pre>

辞書順で後かどうか

```ruby
"b" > "a"  #=> true
```

### String#>=

<pre class="fmrb-sig"><code>&gt;=(String other) -&gt; bool</code></pre>

辞書順で後か同じかどうか

```ruby
"b" >= "b"  #=> true
```

### String#[]

<pre class="fmrb-sig"><code>[](untyped index_or_range) -&gt; (String | nil)</code></pre>

その位置の文字か部分文字列を返す

**位置は文字数**で、バイト数ではない。範囲の外は nil。
```ruby
s[0]
s[0, 3]
s[1..2]
```

### String#[]=

<pre class="fmrb-sig"><code>[]=(untyped index_or_range, String replacement) -&gt; String</code></pre>

その位置の文字や部分文字列を置き換える

**長さが変わってよい**。1 文字を 3 文字に置き換えてもよい。
```ruby
s[0] = "X"
s[0, 2] = "ab"
```

### String#__ljust_rjust_argcheck

<pre class="fmrb-sig"><code>__ljust_rjust_argcheck(<a href="../Integer/">Integer</a> | String width_or_padding) -&gt; nil</code></pre>

ljust / rjust の引数検査に使う内部メソッド

**内部用**。自分で呼ぶものではない。

### String#bytes

<pre class="fmrb-sig"><code>bytes() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

バイトの並びを配列で返す

**配列を作る**ので大きい文字列では重い。1 バイトだけなら `getbyte`。
```ruby
"AB".bytes  #=> [65, 66]
```

### String#bytesize

<pre class="fmrb-sig"><code>bytesize() -&gt; <a href="../Integer/">Integer</a></code></pre>

バイト数を返す (文字数ではない)

**バイナリを扱うならこちら**。`length` は日本語を 1 文字と数えるので食い違う。
```ruby
"あ".bytesize  #=> 3
"あ".length    #=> 1
```

### String#byteslice

<pre class="fmrb-sig"><code>byteslice(<a href="../Integer/">Integer</a> start, ?<a href="../Integer/">Integer</a> length) -&gt; (String | nil)
byteslice(<a href="../Range/">Range</a> range) -&gt; (String | nil)</code></pre>

バイトの位置と長さで切り出す

start バイト目から length バイトを、新しい文字列にして返す。
**位置も長さもバイトで数える**。日本語は 1 文字が 3 バイト (UTF-8)
なので、文字で数える `[]`・`slice`・`length`・`index` の値をそのまま渡すと、日本語の入った文字列では位置がずれる。バイトで数える `bytesize`・`getbyte` と組み合わせる。

start が負なら末尾から数える。length が残りより長ければ末尾まで。
start がちょうど末尾 (`bytesize`) なら ""。それより先か、length
が負なら **nil** (例外は出ない)。続けて文字列のメソッドを呼ぶなら
`.to_s` を挟む。文字の途中で切っても止まらず、欠けた文字のまま返る。

length を省くと、その 1 バイト (末尾から先は nil)。バイトの範囲
(`2..4`) でも呼べる。
```ruby
s = "あいう"
s.byteslice(3, 3)   #=> "い"
s[1]                #=> "い"
s.byteslice(9, 1)   #=> ""
s.byteslice(10, 1)  #=> nil
rest = s.byteslice(3,
  s.bytesize - 3).to_s
```

### String#chars

<pre class="fmrb-sig"><code>chars() -&gt; <a href="../Array/">Array</a>[String]</code></pre>

1 文字ずつの配列を返す

日本語も 1 文字ずつに分かれる。
```ruby
"あい".chars  #=> ["あ", "い"]
```

### String#chomp

<pre class="fmrb-sig"><code>chomp() -&gt; String</code></pre>

末尾の改行を取り除いた文字列を返す

`gets` で読んだ行の改行を落とすのに使う。
```ruby
line.chomp
```

### String#chomp!

<pre class="fmrb-sig"><code>chomp!() -&gt; (String | nil)</code></pre>

末尾の改行を自分から取り除く

**改行が無ければ nil** が返る (文字列ではない)。
```ruby
line.chomp!
```

### String#clear

<pre class="fmrb-sig"><code>clear() -&gt; String</code></pre>

文字列を空にする

同じ入れ物を使いまわす。
```ruby
buf.clear
```

### String#downcase

<pre class="fmrb-sig"><code>downcase() -&gt; String</code></pre>

小文字にした文字列を返す

**英字だけ**が変わる。
```ruby
"ABC".downcase  #=> "abc"
```

### String#downcase!

<pre class="fmrb-sig"><code>downcase!() -&gt; (String | nil)</code></pre>

自分自身を小文字にする

**変わらなければ nil**。
```ruby
s.downcase!
```

### String#each_byte

<pre class="fmrb-sig"><code>each_byte() { (<a href="../Integer/">Integer</a> byte) -&gt; untyped } -&gt; self</code></pre>

1 バイトずつブロックを実行する

**ブロック呼び出しは 1 回 0.4ms** かかる。長い文字列では
`while` と `getbyte` の方が速い。
```ruby
s.each_byte do |b|
  n += b
end
```

### String#each_char

<pre class="fmrb-sig"><code>each_char() { (String character) -&gt; untyped } -&gt; self</code></pre>

1 文字ずつブロックを実行する

```ruby
s.each_char do |c|
  draw(c)
end
```

### String#each_line

<pre class="fmrb-sig"><code>each_line(
  ?String separator,
  ?chomp: bool
) { (String line) -&gt; untyped } -&gt; String</code></pre>

1 行ずつブロックを実行する

**chomp: true で改行を落とせる**。
```ruby
text.each_line(chomp: true) do |l|
  handle(l)
end
```

### String#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

文字列が空かどうか

```ruby
return if s.empty?
```

### String#end_with?

<pre class="fmrb-sig"><code>end_with?(String suffix) -&gt; bool</code></pre>

その文字列で終わるかどうか

**Regexp が無い**ので、拡張子の判定はこれで書く。
```ruby
if path.end_with?(".rb")
```

### String#getbyte

<pre class="fmrb-sig"><code>getbyte(<a href="../Integer/">Integer</a> index) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

その位置のバイト値を返す

**バイナリを読む基本**。範囲の外は nil。
```ruby
b = data.getbyte(4)
```

### String#setbyte

<pre class="fmrb-sig"><code>setbyte(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> byte) -&gt; <a href="../Integer/">Integer</a></code></pre>

その位置のバイト値を書き換える

**Array#pack が無い**ので、バイト列は `"\x00" * n` を作ってここに書き込む。
```ruby
buf = "\x00" * 4
buf.setbyte(0, 0x12)
```

### String#include?

<pre class="fmrb-sig"><code>include?(String other) -&gt; bool</code></pre>

その文字列を含むかどうか

**実測 1.7ms**と重い。ループの中で毎回呼ばない。
```ruby
if s.include?("err")
```

### String#index

<pre class="fmrb-sig"><code>index(
  String | <a href="../Integer/">Integer</a> substring_or_codepoint,
  ?<a href="../Integer/">Integer</a> offset
) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

その文字列が最初に現れる位置を返す

**見つからなければ nil**。2 つめで探し始める位置を指せる。
```ruby
i = s.index("=")
j = s.index(",", i + 1)
```

### String#rindex

<pre class="fmrb-sig"><code>rindex(String substring, ?<a href="../Integer/">Integer</a> offset) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

後ろから探した位置を返す

**文字の位置**で返す (日本語は 1 文字が 1)。見つからなければ **nil**。
`offset` (省略すると末尾から) は探し始める文字の位置で、それより後ろは見ない。
**文字列だけを受ける** (Regexp も Integer も使えない)。
```ruby
path.rindex("/")      #=> 8
path.rindex(".", 5)
```

### String#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; String</code></pre>

中身が分かる形の文字列を返す

引用符と escape が付く。ログに出すときに使う。
```ruby
p s
```

### String#intern

<pre class="fmrb-sig"><code>intern() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

シンボルに変える

`to_sym` と同じ。
```ruby
"name".intern  #=> :name
```

### String#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

文字列の長さを返す

**UTF-8 の文字数**。バイト数が要るなら `bytesize`。
```ruby
"あい".length  #=> 2
```

### String#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

文字列の長さを返す

`length` と同じ。
```ruby
s.size
```

### String#ljust

<pre class="fmrb-sig"><code>ljust(<a href="../Integer/">Integer</a> width, ?String padding) -&gt; String</code></pre>

指定の幅で左に寄せた文字列を返す

表を組むときに使う。**幅は文字数**なので、日本語混じりの見た目はそろわない。
```ruby
"id".ljust(8)
"id".ljust(8, ".")
```

### String#lstrip

<pre class="fmrb-sig"><code>lstrip() -&gt; String</code></pre>

先頭の空白を取り除いた文字列を返す

```ruby
"  a".lstrip  #=> "a"
```

### String#lstrip!

<pre class="fmrb-sig"><code>lstrip!() -&gt; (String | nil)</code></pre>

先頭の空白を自分から取り除く

**変わらなければ nil**。
```ruby
s.lstrip!
```

### String#ord

<pre class="fmrb-sig"><code>ord() -&gt; <a href="../Integer/">Integer</a></code></pre>

先頭の文字コードを返す

**先頭の 1 文字だけ**。
```ruby
"A".ord  #=> 65
```

### String#rjust

<pre class="fmrb-sig"><code>rjust(<a href="../Integer/">Integer</a> width, ?String padding) -&gt; String</code></pre>

指定の幅で右に寄せた文字列を返す

数を右にそろえるのに使う。
```ruby
n.to_s.rjust(4)
"7".rjust(3, "0")  #=> "007"
```

### String#rstrip

<pre class="fmrb-sig"><code>rstrip() -&gt; String</code></pre>

末尾の空白を取り除いた文字列を返す

```ruby
"a  ".rstrip  #=> "a"
```

### String#rstrip!

<pre class="fmrb-sig"><code>rstrip!() -&gt; (String | nil)</code></pre>

末尾の空白を自分から取り除く

**変わらなければ nil**。
```ruby
s.rstrip!
```

### String#slice

<pre class="fmrb-sig"><code>slice(untyped index_or_range) -&gt; (String | nil)</code></pre>

その位置の文字か部分文字列を返す

`[]` と同じ。
```ruby
s.slice(0, 3)
```

### String#split

<pre class="fmrb-sig"><code>split(?String separator, ?<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Array/">Array</a>[String]</code></pre>

区切り文字で分けて配列にする

**引数なしだと空白で分ける**。3 つめの引数で分ける回数を抑えられる
(値を含む設定行を読むときに効く)。
```ruby
"a,b,c".split(",")
"k=a=b".split("=", 2)
```

### String#start_with?

<pre class="fmrb-sig"><code>start_with?(String prefix) -&gt; bool</code></pre>

その文字列で始まるかどうか

```ruby
if line.start_with?("#")
```

### String#strip

<pre class="fmrb-sig"><code>strip() -&gt; String</code></pre>

前後の空白を取り除いた文字列を返す

設定ファイルを読むときの定番。
```ruby
key = parts[0].strip
```

### String#strip!

<pre class="fmrb-sig"><code>strip!() -&gt; (String | nil)</code></pre>

前後の空白を自分から取り除く

**変わらなければ nil**。
```ruby
s.strip!
```

### String#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

小数に変える

**数で始まらなければ 0.0**。例外にはならない。
```ruby
"1.5".to_f  #=> 1.5
```

### String#to_i

<pre class="fmrb-sig"><code>to_i(?<a href="../Integer/">Integer</a> base) -&gt; <a href="../Integer/">Integer</a></code></pre>

整数に変える

**数で始まらなければ 0**。16 進を読むなら 16 を渡す。
```ruby
"12".to_i     #=> 12
"ff".to_i(16) #=> 255
```

### String#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; String</code></pre>

自分自身を文字列として返す

自分がそのまま返る。
```ruby
s.to_s
```

### String#to_sym

<pre class="fmrb-sig"><code>to_sym() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

シンボルに変える

**作った印は消えない**ので、外から来た文字列を次々に変えない。
```ruby
"name".to_sym  #=> :name
```

### String#tr

<pre class="fmrb-sig"><code>tr(String source, String replacement) -&gt; String</code></pre>

文字を置き換えた文字列を返す

**1 文字ずつ対応**して置き換える。文字列ごとの置換ではない。
```ruby
"a-b".tr("-", "_")  #=> "a_b"
```

### String#tr!

<pre class="fmrb-sig"><code>tr!(String source, String replacement) -&gt; (String | nil)</code></pre>

文字を自分の中で置き換える

**変わらなければ nil**。
```ruby
s.tr!("-", "_")
```

### String#upcase

<pre class="fmrb-sig"><code>upcase() -&gt; String</code></pre>

大文字にした文字列を返す

```ruby
"abc".upcase  #=> "ABC"
```

### String#upcase!

<pre class="fmrb-sig"><code>upcase!() -&gt; (String | nil)</code></pre>

自分自身を大文字にする

**変わらなければ nil**。
```ruby
s.upcase!
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
