# FmrbToml::Raw

引用符なしで書く値の入れもの

普通は `FmrbToml.raw` で作る。
```ruby
r = FmrbToml::Raw.new("black")
r.text   #=> "black"
```

## クラスメソッド

### FmrbToml::Raw.new

<pre class="fmrb-sig"><code>new(untyped text) -&gt; FmrbToml::Raw</code></pre>

字を入れて作る (to_s にして持つ)

```ruby
r = FmrbToml::Raw.new("black")
```

## インスタンスメソッド

### FmrbToml::Raw#text

<pre class="fmrb-sig"><code>text() -&gt; <a href="../String/">String</a></code></pre>

持っている字

```ruby
r.text   #=> "black"
```

---

*このページは fmruby-core の main@579eba38 の API の型定義 (`sig/`) から自動で作っています。*
