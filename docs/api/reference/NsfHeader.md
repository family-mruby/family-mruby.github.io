# NsfHeader

Read the title of an NSF song file

How to use it: [Sound](../audio.md).

## Class methods

### NsfHeader.parse

<pre class="fmrb-sig"><code>parse(<a href="../String/">String</a> path) -&gt; NsfHeader?</code></pre>

Read the title and the rest from a song file

Reads an NSF's header without playing it; nil when it cannot.
```ruby
h = NsfHeader.parse(path)
Log.info(h.song_name) if h
```

## Instance methods

### NsfHeader#song_name

<pre class="fmrb-sig"><code>song_name() -&gt; <a href="../String/">String</a></code></pre>

The song's title

```ruby
h.song_name
```

### NsfHeader#artist

<pre class="fmrb-sig"><code>artist() -&gt; <a href="../String/">String</a></code></pre>

Who made it

```ruby
h.artist
```

### NsfHeader#copyright

<pre class="fmrb-sig"><code>copyright() -&gt; <a href="../String/">String</a></code></pre>

The rights notice

```ruby
h.copyright
```

### NsfHeader#total_songs

<pre class="fmrb-sig"><code>total_songs() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many songs are inside

```ruby
n = h.total_songs
```

### NsfHeader#starting_song

<pre class="fmrb-sig"><code>starting_song() -&gt; <a href="../Integer/">Integer</a></code></pre>

Which song plays first

```ruby
i = h.starting_song
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9d470992.*
