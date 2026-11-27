# GfxBlock

同じ形をくり返し描くときの下書き

使い方は [スプライト](../sprite.md) のページにあります。

数だけ差しかえて何度も描ける。

## クラスメソッド

### GfxBlock.new

<pre class="fmrb-sig"><code>new(<a href="../FmrbGfx/">FmrbGfx</a> gfx) -&gt; GfxBlock</code></pre>

下書きを作る (ブロックに描き方を書く)

描き方を一度きり組み立てて覚えさせ、あとは数を変えて描き直す。毎回 Ruby から命令を送るより速い。

**ブロックの外側のローカル変数は掴めない** (Spinel)。渡したい値は
`draw` の引数にする。
```ruby
@blk = GfxBlock.new(gfx) do |g, w, h|
  g.draw_rect(0, 0, w, h,
              FmrbGfx::WHITE)
end
```

## インスタンスメソッド

### GfxBlock#draw

<pre class="fmrb-sig"><code>draw() -&gt; void</code></pre>

数を入れかえて描き直す

```ruby
@blk.draw(w: 100, h: 40)
```

### GfxBlock#destroy

<pre class="fmrb-sig"><code>destroy() -&gt; void</code></pre>

下書きを片づける

```ruby
@blk.destroy
```

### GfxBlock#destroyed?

<pre class="fmrb-sig"><code>destroyed?() -&gt; bool</code></pre>

片づけたあとかどうか

```ruby
return if @blk.destroyed?
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
