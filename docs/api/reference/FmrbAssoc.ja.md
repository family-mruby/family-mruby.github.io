# FmrbAssoc

拡張子から、そのファイルを開く先を引く

ファイルマネージャのダブルクリック、シェルの `open`、ファイルを渡したいアプリが、同じ表を引くための入れ物。表は 2 層で、`/etc/associations.toml`
(ファームウェア付き) の上に `/home/associations.toml` (ユーザの) が拡張子ごとに重なる。1 行に `拡張子 = "答え"` だけを書く。

答えは次の 3 通り。パスは必ず `/` で始まるので、`FmrbAssoc::RUN`・
`FmrbAssoc::EDIT` と比べれば見分けられる。
- `"run"` そのファイル自身をアプリとして動かす
- `"edit"` エディタで開く
- `"/app/..."` そのアプリを起動して、ファイルを渡す

表は**起動した VM ごとに 1 回だけ読む**。表を書き換えたら、それを読むアプリを開き直す (読み直しの仕組みは無い)。

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`RUN`</span> | [`String`](String.md) | 答え: そのファイル自身をアプリとして動かす |
| <span class="fmrb-name">`EDIT`</span> | [`String`](String.md) | 答え: エディタで開く |
| <span class="fmrb-name">`DEFAULT`</span> | [`String`](String.md) | 表に無い拡張子の答え (EDIT と同じ) |
| <span class="fmrb-name">`SYS_PATH`</span> | [`String`](String.md) | ファームウェア付きの表のパス |
| <span class="fmrb-name">`USR_PATH`</span> | [`String`](String.md) | ユーザの表のパス |
| <span class="fmrb-name">`MAX_EXT_LEN`</span> | [`Integer`](Integer.md) | 調べる拡張子の最大の長さ (8) |

## クラスメソッド

### FmrbAssoc.resolve

<pre class="fmrb-sig"><code>resolve(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

パスから開く先を決める

戻り値は `"run"`・`"edit"`・`"/app/..."` のどれか。拡張子が無いか表に無いときは **`"edit"`** (分からないときはエディタで見せる)。
**例外は出ない**。
```ruby
FmrbAssoc.resolve("/home/hello.rb")
#=> "run"
FmrbAssoc.resolve("/home/a.txt")
#=> "edit"
```

### FmrbAssoc.extension_of

<pre class="fmrb-sig"><code>extension_of(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

パスの拡張子を取る

**最後の `.` より後ろを小文字にして**、`.` を付けずに返す。**拡張子が**
**無いときは `""`**: `.` が無い、`.` が末尾にある、`.` がディレクトリ名の中にある、後ろが 8 文字より長い、のどれか。
```ruby
FmrbAssoc.extension_of("/home/README.MD")
#=> "md"
```

### FmrbAssoc.load_table

<pre class="fmrb-sig"><code>load_table() -&gt; <a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>]</code></pre>

関連付けの表 (拡張子 => 答え)

表を返す。**最初の呼び出しで 2 つのファイルを読み、その VM の間は**
**同じ Hash を返す**。ユーザの表が同じ拡張子の分を上書きする。
```ruby
FmrbAssoc.load_table["md"]
#=> "/app/tool/picorabbit.app.rb"
```

### FmrbAssoc.forget

<pre class="fmrb-sig"><code>forget() -&gt; nil</code></pre>

読んだ表を捨てる

次の `resolve` が表を読み直す。**表を書いた直後に反映したいとき**と試験のためで、どこにも自動では結びついていない (別の端末へ移されたアプリだけ、土台が呼ぶ)。常に nil を返す。
```ruby
FmrbAssoc.forget
```

### FmrbAssoc.merge_file

<pre class="fmrb-sig"><code>merge_file(<a href="../Hash/">Hash</a>[<a href="../String/">String</a>, <a href="../String/">String</a>] table, <a href="../String/">String</a> path) -&gt; nil</code></pre>

表のファイル 1 つを Hash に重ねる

`load_table` が呼ぶ読み込みの 1 段で、**table を書き換えて nil を返す**。ファイルが無ければ何もしない。キーは前後の空白を除いて小文字にし、空でない文字列の答えだけを採る。**TOML の誤りがあるファイルは丸ごと**
**読まない** (ログに 1 行)。Spinel のデスクトップでは TOML を使わず 1 行ずつ読む。
```ruby
t = {}
FmrbAssoc.merge_file(t, "/home/a.toml")
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
