# Asterism::ROS

ROS 2 のノードのふりをする

使い方は [ネットワーク](../network.md) のページにあります。

ROS 2 (Jazzy・rmw_zenoh) のノードのふりをして、トピックを出す・受ける、サービスを呼ぶ・答える。Zenoh のルータ (zenohd) を ROS 2 側と共有するのが前提で、
ROS 2 側は rmw_zenoh を使っていること。**Link の conn.session の上に作る**
(`Asterism::ROS::Node.new(conn.session, "名前")`)。Asterism::Connection と同じく
**何も裏で動かない**: Node#poll を毎回の update で呼ぶ。

メッセージの型は ROS 2 の .msg / .srv から作ったファイル (tools/asterism_msggen.rb の出力)
で、端末の /usr/share/asterism/msgs に std_msgs・geometry_msgs・sensor_msgs・
nav_msgs ほかが入っている。`Asterism::ROS.require_type("std_msgs/msg/String")` か型の名前 (String) を各メソッドに渡すと読み込む。メッセージは CDR で送る。大きなメッセージ (画像・点群) は端末のメモリを使う。

```ruby
node = Asterism::ROS::Node.new(
  @link.conn.session, "fmrb_node")
pub = node.publisher("/chatter",
  "std_msgs/msg/String")
pub << { data: "hi" }
```

## 定数

| 名前 | 型 | 中身 |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_QOS`</span> | [`String`](String.md) | 何も指定しないときの QoS |
| <span class="fmrb-name">`TYPE_PATH`</span> | `Array[String]` | 型のファイルを探す場所 |

## クラスメソッド

### Asterism::ROS.require_type

<pre class="fmrb-sig"><code>require_type(<a href="../String/">String</a> name) -&gt; untyped</code></pre>

型を読み込む

"geometry_msgs/msg/Twist" や "example_interfaces/srv/AddTwoInts" を
TYPE_PATH から探して読み、型 (クラスか、サービスならモジュール) を返す。読み込み済みなら読み直さない。名前は `パッケージ/msg|srv/名前` の形で、形が違うと ArgumentError、ファイルが無いと Asterism::ROS::UnknownType。
```ruby
twist = Asterism::ROS.require_type(
  "geometry_msgs/msg/Twist")
```

### Asterism::ROS.type_path

<pre class="fmrb-sig"><code>type_path() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

型を探す場所の一覧

配列そのものを返すので、`<<` で足せる。
```ruby
Asterism::ROS.type_path << "/home/msgs"
```

### Asterism::ROS.field_types

<pre class="fmrb-sig"><code>field_types(untyped type) -&gt; <a href="../Hash/">Hash</a></code></pre>

型と、それを作っている型の欄の表

`{ROS の名前 => 欄の表}` を、その型を先頭に 1 回ずつ返す。欄は
`[名前, 基本の型, 種類, 入れ子の型, 長さの上限, 文字列の長さの上限]`。サービスなら
Request と Response。型は型そのものか ROS の名前。欄の表が無い型
(手で書いた・古い生成) は Asterism::ROS::UnknownType。
```ruby
t = Asterism::ROS.field_types(
  "std_msgs/msg/Header")
```

### Asterism::ROS.resolve

<pre class="fmrb-sig"><code>resolve(<a href="../String/">String</a> topic, <a href="../String/">String</a> namespace) -&gt; <a href="../String/">String</a></code></pre>

トピック名を完全な名前にする

"/" で始まる名前はそのまま、そうでなければ namespace の下に置く。空の名前は ArgumentError。"~" や置き換えは使えない。
```ruby
Asterism::ROS.resolve("chatter", "/a")
#=> "/a/chatter"
```

---

*このページは fmruby-core の develop@1ff55c21 の API の型定義 (`sig/`) から自動で作っています。*
