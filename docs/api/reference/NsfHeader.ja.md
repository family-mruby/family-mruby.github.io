# NsfHeader

NSF (ファミコンの曲) のファイルの題名などを読む

使い方は [音声](../audio.md) のページにあります。

## クラスメソッド

### NsfHeader.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> path) -&gt; NsfHeader?</code></pre>

曲のファイルから題名などを読む

NSF の見出しだけを読む。曲は鳴らさない。読めなければ nil。
```ruby
h = NsfHeader.parse(path)
Log.info(h.song_name) if h
```

## インスタンスメソッド

### NsfHeader#song_name

<pre class="fmrb-sig"><code>song_name() -&gt; <a href="../String/">String</a></code></pre>

曲の題名

```ruby
h.song_name
```

### NsfHeader#artist

<pre class="fmrb-sig"><code>artist() -&gt; <a href="../String/">String</a></code></pre>

作った人

```ruby
h.artist
```

### NsfHeader#copyright

<pre class="fmrb-sig"><code>copyright() -&gt; <a href="../String/">String</a></code></pre>

権利の表示

```ruby
h.copyright
```

### NsfHeader#total_songs

<pre class="fmrb-sig"><code>total_songs() -&gt; <a href="../Integer/">Integer</a></code></pre>

入っている曲の数

```ruby
n = h.total_songs
```

### NsfHeader#starting_song

<pre class="fmrb-sig"><code>starting_song() -&gt; <a href="../Integer/">Integer</a></code></pre>

最初に鳴らす曲の番号

```ruby
i = h.starting_song
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
