# Module

クラスとモジュールの操作

クラスとモジュール (Module) の操作。`Object.const_defined?(:X)` のようにクラスが受け手になる。実装は mruby 本体の src/class.c (const_defined?) と mruby-metaprog (remove_method)。

## インスタンスメソッド

### Module#const_defined?

<pre class="fmrb-sig"><code>const_defined?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool inherit) -&gt; bool</code></pre>

定数があるか調べる

name の定数があれば true。**未定義でも例外は出さず false** (gem が入っているかの確認に使う)。
name が定数の名前の形でない (小文字で始まるなど) ときは NameError。

`inherit` (省略すると true) が true なら、親のクラスや Object の定数も数える。
false なら、その受け手に直接ある定数だけ。
```ruby
if Object.const_defined?(:Digest)
  # Digest が使える
end
```

### Module#remove_method

<pre class="fmrb-sig"><code>remove_method(*<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> names) -&gt; self</code></pre>

メソッドの定義を取り除く

**この受け手に直接定義したメソッドだけ**取り除ける。親から継承しているものは取り除けず、NameError ("method 'x' not defined in ...")。取り除くと、同じ名前のメソッドが親にあればそちらが呼ばれる。

名前は Symbol か String (ほかは TypeError)。複数を一度に渡せる。受け手 (self) を返す。凍結したクラスには FrozenError。
```ruby
self.class.remove_method(:draw_title)
```

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
