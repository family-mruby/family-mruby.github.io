# Object

Object を受け手にする呼び方の写し

`Object.const_defined?(:X)` のように Object 自身が受け手になる呼び方のための写し。中身は Module#const_defined? と同じ (Object は Module の一種)。

## クラスメソッド

### Object.const_defined?

<pre class="fmrb-sig"><code>const_defined?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool inherit) -&gt; bool</code></pre>

定数があるか調べる

```ruby
Object.const_defined?(:Digest)
```

### Object.methods

<pre class="fmrb-sig"><code>methods() -&gt; <a href="../Array/">Array</a>[<a href="../Symbol/">Symbol</a>]</code></pre>

メソッドの一覧を返す

**何が呼べるか調べる**ときに使う。
```ruby
p obj.methods
```

## インスタンスメソッド

### Object#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(untyped other) -&gt; <a href="../Integer/">Integer</a></code></pre>

大小を比べる

同じ物なら 0、違えば nil。
```ruby
a <=> b
```

### Object#!=

<pre class="fmrb-sig"><code>!=(untyped other) -&gt; bool</code></pre>

等しくないかどうか

```ruby
if a != b
```

### Object#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

等しいかどうか

**既定は同じ物かどうか**。中身で比べたいクラスは自分で定義する。
```ruby
if a == b
```

### Object#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

case での一致を判定する

```ruby
case v
when Integer then n
end
```

### Object#attr_accessor

<pre class="fmrb-sig"><code>attr_accessor(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

読み書きの入口を作る

**読みと書きの両方**ができるようになる。クラスの中に書く。
```ruby
class Foo
  attr_accessor :x, :y
end
```

### Object#attr_reader

<pre class="fmrb-sig"><code>attr_reader(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

読みの入口を作る

**読みだけ**。
```ruby
attr_reader :id
```

### Object#block_given?

<pre class="fmrb-sig"><code>block_given?() -&gt; bool</code></pre>

ブロックが渡されたかどうか

`yield` の前に確かめる。
```ruby
yield(v) if block_given?
```

### Object#class

<pre class="fmrb-sig"><code>class() -&gt; <a href="../Class/">Class</a></code></pre>

そのオブジェクトのクラスを返す

```ruby
obj.class.name
```

### Object#dup

<pre class="fmrb-sig"><code>dup() -&gt; self</code></pre>

複製を作る

**中の物までは写さない** (浅い写し)。配列の中の配列は共有される。
```ruby
b = a.dup
```

### Object#equal?

<pre class="fmrb-sig"><code>equal?(untyped other) -&gt; bool</code></pre>

同じ物 (同一のオブジェクト) か

**値でなく、同一のオブジェクトかを見る** (`==` とは違う)。文字列は中身が同じでも、別に作ったものは false。
```ruby
a.equal?(b)
```

### Object#exit

<pre class="fmrb-sig"><code>exit(?<a href="../Integer/">Integer</a> status) -&gt; nil</code></pre>

アプリを終える

**アプリを終える**。Window の後始末は入れ物がやる。
```ruby
exit
```

### Object#include

<pre class="fmrb-sig"><code>include(*untyped modules) -&gt; nil</code></pre>

モジュールをまぜる

**まぜたモジュールの中で裸の定数は見えない** (picoruby)。`self.class::NAME`
と書く。
```ruby
class Foo
  include Bar
end
```

### Object#extend

<pre class="fmrb-sig"><code>extend(*untyped modules) -&gt; nil</code></pre>

この物にだけモジュールを足す

**その物だけ**にモジュールを足す。
```ruby
obj.extend(Bar)
```

### Object#freeze

<pre class="fmrb-sig"><code>freeze() -&gt; self</code></pre>

変更できなくする

自分自身を返す。そのあとで文字列・配列・ハッシュを変えようとすると**FrozenError**。
Integer・Symbol・nil・true・false は何も起きない (もとから変えられない)。定数の配列やハッシュを守るのに使う。
```ruby
NAMES = ["a", "b"].freeze
```

### Object#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

中身が分かる形の文字列を返す

```ruby
p obj
```

### Object#is_a?

<pre class="fmrb-sig"><code>is_a?(untyped class_or_module) -&gt; bool</code></pre>

そのクラスかモジュールに属するか

**`defined?` は無い**ので、有無を調べるときはこれか `const_defined?`、あるいは rescue で書く。
```ruby
if v.is_a?(Integer)
```

### Object#loop

<pre class="fmrb-sig"><code>loop() { (nil value) -&gt; untyped } -&gt; nil</code></pre>

ずっとくり返す

**アプリの中で回しっぱなしにしない**。入れ物が入力を配れなくなる。
```ruby
loop do
  break if done?
end
```

### Object#nil?

<pre class="fmrb-sig"><code>nil?() -&gt; bool</code></pre>

nil かどうか

```ruby
return if v.nil?
```

### Object#private

<pre class="fmrb-sig"><code>private(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

以降を外から呼べなくする

```ruby
private
def helper
end
```

### Object#public

<pre class="fmrb-sig"><code>public(*<a href="../Symbol/">Symbol</a> names) -&gt; nil</code></pre>

以降を外から呼べるようにする

```ruby
public
```

### Object#raise

<pre class="fmrb-sig"><code>raise(?untyped exception, ?<a href="../String/">String</a> message) -&gt; bot</code></pre>

例外を投げる

**アプリの外まで上がると落ちる**。読み書きは `rescue` で受ける。
```ruby
raise "bad path"
begin
  risky
rescue => e
  Log.info(e.message)
end
```

### Object#relinquish

<pre class="fmrb-sig"><code>relinquish() -&gt; bool</code></pre>

他の仕事に順番をゆずる

**他の仕事に順番をゆずる**。長い計算の途中に挟むと画面が固まらない。
```ruby
i = 0
while i < 10000
  relinquish if i % 500 == 0
  i += 1
end
```

### Object#respond_to?

<pre class="fmrb-sig"><code>respond_to?(<a href="../Symbol/">Symbol</a> | <a href="../String/">String</a> name, ?bool include_all) -&gt; bool</code></pre>

そのメソッドを持つか

name は Symbol か String。**private かどうかは見ない** (有れば true)。メソッドが無くても、
`respond_to_missing?` が true を返せば true (`include_all` はその呼び出しに渡るだけ)。機種やビルドで有る無しが分かれる API を確かめるのに使う。
```ruby
GC.respond_to?(:reset_stat)
```

### Object#sleep

<pre class="fmrb-sig"><code>sleep(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> duration) -&gt; <a href="../Integer/">Integer</a></code></pre>

秒だけ待つ

秒で待つ。
```ruby
sleep 1
```

### Object#sleep_ms

<pre class="fmrb-sig"><code>sleep_ms(<a href="../Integer/">Integer</a> milliseconds) -&gt; <a href="../Integer/">Integer</a></code></pre>

千分の一秒だけ待つ

**アプリの中では使わない**。`_spin` の外では時計が進まず止まったままになる。待つなら `Machine.delay_ms`。
```ruby
Machine.delay_ms(50)
```

### Object#sprintf

<pre class="fmrb-sig"><code>sprintf(<a href="../String/">String</a> format, *untyped arguments) -&gt; <a href="../String/">String</a></code></pre>

書式にあてはめた文字列を作る

桁をそろえるのに使う。
```ruby
s = sprintf("%3d%%", n)
```

### Object#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

文字列にして返す

```ruby
obj.to_s
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
