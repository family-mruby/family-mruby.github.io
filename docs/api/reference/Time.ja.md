# Time

日付と時刻

作るのは `Time.now` (今)、`Time.at` (UNIX 秒から)、`Time.local` / `Time.gm` (年月日から)。引き算 (`t2 - t1`) は秒の Float。
```ruby
t = Time.now
label = "%02d:%02d" % [t.hour, t.min]
```

## クラスメソッド

### Time.now

<pre class="fmrb-sig"><code>now() -&gt; Time</code></pre>

今の時刻

システム時計の今を、ローカル時刻で返す。時計が合っていない端末では、その値のまま
(エラーにならない)。
```ruby
t = Time.now
```

### Time.new

<pre class="fmrb-sig"><code>new(
  ?<a href="../Integer/">Integer</a> year,
  ?<a href="../Integer/">Integer</a> month,
  ?<a href="../Integer/">Integer</a> day,
  ?<a href="../Integer/">Integer</a> hour,
  ?<a href="../Integer/">Integer</a> min,
  ?<a href="../Integer/">Integer</a> sec,
  ?<a href="../Integer/">Integer</a> usec
) -&gt; Time</code></pre>

今の時刻 (new)

**引数なしは今**。引数は年・月・日・時・分・秒・マイクロ秒の順で、
**年だけ必須の整数** (文字列は TypeError)。**ローカル時刻**として解く。範囲外 (13 月など) は
ArgumentError ("argument out of range"、解けない日付は "invalid time")。
```ruby
Time.new
Time.new(2026, 11, 25, 9, 30)
```

### Time.at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds, ?<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> usec) -&gt; Time</code></pre>

UNIX 秒から作る

1970-01-01 00:00:00 UTC からの秒 (Integer か Float。小数は小数秒になる)。第 2 引数は追加のマイクロ秒 (省略すると 0)。ローカル時刻で返る。Integer・Float 以外は
TypeError。
```ruby
Time.at(0).to_i   #=> 0
```

### Time.local

<pre class="fmrb-sig"><code>local(
  <a href="../Integer/">Integer</a> year,
  ?<a href="../Integer/">Integer</a> month,
  ?<a href="../Integer/">Integer</a> day,
  ?<a href="../Integer/">Integer</a> hour,
  ?<a href="../Integer/">Integer</a> min,
  ?<a href="../Integer/">Integer</a> sec,
  ?<a href="../Integer/">Integer</a> usec
) -&gt; Time</code></pre>

年月日から作る (ローカル時刻)

引数は `Time.new` と同じ。`mktime` は同じ働きの別名。
```ruby
Time.local(2026, 11, 25)
```

### Time.mktime

<pre class="fmrb-sig"><code>mktime(
  <a href="../Integer/">Integer</a> year,
  ?<a href="../Integer/">Integer</a> month,
  ?<a href="../Integer/">Integer</a> day,
  ?<a href="../Integer/">Integer</a> hour,
  ?<a href="../Integer/">Integer</a> min,
  ?<a href="../Integer/">Integer</a> sec,
  ?<a href="../Integer/">Integer</a> usec
) -&gt; Time</code></pre>

年月日から作る (local の別名)

```ruby
Time.mktime(2026, 11, 25)
```

### Time.gm

<pre class="fmrb-sig"><code>gm(
  <a href="../Integer/">Integer</a> year,
  ?<a href="../Integer/">Integer</a> month,
  ?<a href="../Integer/">Integer</a> day,
  ?<a href="../Integer/">Integer</a> hour,
  ?<a href="../Integer/">Integer</a> min,
  ?<a href="../Integer/">Integer</a> sec,
  ?<a href="../Integer/">Integer</a> usec
) -&gt; Time</code></pre>

年月日から作る (UTC)

引数は `Time.local` と同じだが、**UTC として解く**。`utc` は同じ働きの別名。
```ruby
Time.gm(2026, 11, 25, 0, 0)
```

### Time.utc

<pre class="fmrb-sig"><code>utc(
  <a href="../Integer/">Integer</a> year,
  ?<a href="../Integer/">Integer</a> month,
  ?<a href="../Integer/">Integer</a> day,
  ?<a href="../Integer/">Integer</a> hour,
  ?<a href="../Integer/">Integer</a> min,
  ?<a href="../Integer/">Integer</a> sec,
  ?<a href="../Integer/">Integer</a> usec
) -&gt; Time</code></pre>

年月日から作る (gm の別名)

```ruby
Time.utc(2026, 11, 25)
```

## インスタンスメソッド

### Time#+

<pre class="fmrb-sig"><code>+(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; Time</code></pre>

秒を足す・引く

秒 (Integer か Float) を足した新しい Time。Time を足すと TypeError
("cannot convert Time to time")。
```ruby
tomorrow = Time.now + 86400
```

### Time#-

<pre class="fmrb-sig"><code>-(Time other) -&gt; <a href="../Float/">Float</a>
-(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; Time</code></pre>

差・秒を引く

**Time を引くと、差の秒数 (Float)**。数 (Integer か Float) を引くと、その秒だけ前の新しい
Time。経過時間を測るなら `Machine.board_millis` が軽い。
```ruby
sec = t2 - t1
```

### Time#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(untyped other) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

比べる

-1・0・1 を返す。Time でないものとは nil。
```ruby
t1 <=> t2
```

### Time#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

同じ時刻か

秒とナノ秒が同じなら true (ローカルか UTC かは見ない)。`eql?` は同じ働きの別名。
```ruby
t1 == t2
```

### Time#eql?

<pre class="fmrb-sig"><code>eql?(untyped other) -&gt; bool</code></pre>

同じ時刻か (== の別名)

```ruby
t1.eql?(t2)
```

### Time#hash

<pre class="fmrb-sig"><code>hash() -&gt; <a href="../Integer/">Integer</a></code></pre>

ハッシュ値

```ruby
t.hash
```

### Time#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

UNIX 秒 (整数)

```ruby
t.to_i
```

### Time#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

UNIX 秒 (小数つき)

ミリ秒にするなら `(Time.now.to_f * 1000).to_i`。
```ruby
ms = (Time.now.to_f * 1000).to_i
```

### Time#year

<pre class="fmrb-sig"><code>year() -&gt; <a href="../Integer/">Integer</a></code></pre>

年

```ruby
t.year
```

### Time#mon

<pre class="fmrb-sig"><code>mon() -&gt; <a href="../Integer/">Integer</a></code></pre>

月 (1-12)

`month` は同じ働きの別名。
```ruby
t.mon
```

### Time#month

<pre class="fmrb-sig"><code>month() -&gt; <a href="../Integer/">Integer</a></code></pre>

月 (mon の別名)

```ruby
t.month
```

### Time#day

<pre class="fmrb-sig"><code>day() -&gt; <a href="../Integer/">Integer</a></code></pre>

日 (1-31)

`mday` は同じ働きの別名。
```ruby
t.day
```

### Time#mday

<pre class="fmrb-sig"><code>mday() -&gt; <a href="../Integer/">Integer</a></code></pre>

日 (day の別名)

```ruby
t.mday
```

### Time#hour

<pre class="fmrb-sig"><code>hour() -&gt; <a href="../Integer/">Integer</a></code></pre>

時 (0-23)

```ruby
t.hour
```

### Time#min

<pre class="fmrb-sig"><code>min() -&gt; <a href="../Integer/">Integer</a></code></pre>

分 (0-59)

```ruby
t.min
```

### Time#sec

<pre class="fmrb-sig"><code>sec() -&gt; <a href="../Integer/">Integer</a></code></pre>

秒 (0-59)

```ruby
t.sec
```

### Time#usec

<pre class="fmrb-sig"><code>usec() -&gt; <a href="../Integer/">Integer</a></code></pre>

マイクロ秒 (0-999999)

```ruby
t.usec
```

### Time#nsec

<pre class="fmrb-sig"><code>nsec() -&gt; <a href="../Integer/">Integer</a></code></pre>

ナノ秒 (0-999999999)

`tv_nsec` は同じ働きの別名。
```ruby
t.nsec
```

### Time#tv_nsec

<pre class="fmrb-sig"><code>tv_nsec() -&gt; <a href="../Integer/">Integer</a></code></pre>

ナノ秒 (nsec の別名)

```ruby
t.tv_nsec
```

### Time#wday

<pre class="fmrb-sig"><code>wday() -&gt; <a href="../Integer/">Integer</a></code></pre>

曜日 (日曜が 0)

```ruby
t.wday
```

### Time#yday

<pre class="fmrb-sig"><code>yday() -&gt; <a href="../Integer/">Integer</a></code></pre>

年の何日目 (1-366)

```ruby
t.yday
```

### Time#dst?

<pre class="fmrb-sig"><code>dst?() -&gt; bool</code></pre>

夏時間か

```ruby
t.dst?
```

### Time#sunday?

<pre class="fmrb-sig"><code>sunday?() -&gt; bool</code></pre>

日曜か

```ruby
t.sunday?
```

### Time#monday?

<pre class="fmrb-sig"><code>monday?() -&gt; bool</code></pre>

月曜か

```ruby
t.monday?
```

### Time#tuesday?

<pre class="fmrb-sig"><code>tuesday?() -&gt; bool</code></pre>

火曜か

```ruby
t.tuesday?
```

### Time#wednesday?

<pre class="fmrb-sig"><code>wednesday?() -&gt; bool</code></pre>

水曜か

```ruby
t.wednesday?
```

### Time#thursday?

<pre class="fmrb-sig"><code>thursday?() -&gt; bool</code></pre>

木曜か

```ruby
t.thursday?
```

### Time#friday?

<pre class="fmrb-sig"><code>friday?() -&gt; bool</code></pre>

金曜か

```ruby
t.friday?
```

### Time#saturday?

<pre class="fmrb-sig"><code>saturday?() -&gt; bool</code></pre>

土曜か

```ruby
t.saturday?
```

### Time#zone

<pre class="fmrb-sig"><code>zone() -&gt; <a href="../String/">String</a></code></pre>

時差の名前

UTC の Time は "UTC"、ローカルの Time は "+0900" のような**時差の文字列** (地名の "JST" ではない)。
```ruby
t.zone   #=> "+0900"
```

### Time#utc_offset

<pre class="fmrb-sig"><code>utc_offset() -&gt; <a href="../Integer/">Integer</a></code></pre>

UTC との差 (秒)

UTC の Time は 0。`gmt_offset`・`gmtoff` は同じ働きの別名。
```ruby
t.utc_offset   #=> 32400
```

### Time#gmt_offset

<pre class="fmrb-sig"><code>gmt_offset() -&gt; <a href="../Integer/">Integer</a></code></pre>

UTC との差 (utc_offset の別名)

```ruby
t.gmt_offset
```

### Time#gmtoff

<pre class="fmrb-sig"><code>gmtoff() -&gt; <a href="../Integer/">Integer</a></code></pre>

UTC との差 (utc_offset の別名)

```ruby
t.gmtoff
```

### Time#utc?

<pre class="fmrb-sig"><code>utc?() -&gt; bool</code></pre>

UTC の Time か

`gmt?` は同じ働きの別名。
```ruby
t.utc?
```

### Time#gmt?

<pre class="fmrb-sig"><code>gmt?() -&gt; bool</code></pre>

UTC の Time か (utc? の別名)

```ruby
t.gmt?
```

### Time#utc

<pre class="fmrb-sig"><code>utc() -&gt; Time</code></pre>

UTC に変える (自分を書き換える)

**受け手そのものを UTC に変え**、自分を返す。元を残すなら `getutc`。`gmtime` は同じ働きの別名。
```ruby
t.utc
```

### Time#gmtime

<pre class="fmrb-sig"><code>gmtime() -&gt; Time</code></pre>

UTC に変える (utc の別名)

```ruby
t.gmtime
```

### Time#getutc

<pre class="fmrb-sig"><code>getutc() -&gt; Time</code></pre>

UTC の新しい Time

元は変えない。`getgm` は同じ働きの別名。
```ruby
u = t.getutc
```

### Time#getgm

<pre class="fmrb-sig"><code>getgm() -&gt; Time</code></pre>

UTC の新しい Time (getutc の別名)

```ruby
t.getgm
```

### Time#localtime

<pre class="fmrb-sig"><code>localtime() -&gt; Time</code></pre>

ローカル時刻に変える (自分を書き換える)

**受け手そのものを**ローカル時刻にし、自分を返す。元を残すなら `getlocal`。
```ruby
t.localtime
```

### Time#getlocal

<pre class="fmrb-sig"><code>getlocal() -&gt; Time</code></pre>

ローカル時刻の新しい Time

元は変えない。
```ruby
l = t.getlocal
```

### Time#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

"2026-11-25 09:30:00 +0900" の形の文字列

UTC の Time は末尾が "UTC"。`inspect` は同じ働きの別名。
```ruby
t.to_s
```

### Time#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

文字列にする (to_s の別名)

```ruby
t.inspect
```

### Time#asctime

<pre class="fmrb-sig"><code>asctime() -&gt; <a href="../String/">String</a></code></pre>

"Wed Nov 25 09:30:00 2026" の形の文字列

`ctime` は同じ働きの別名。
```ruby
t.asctime
```

### Time#ctime

<pre class="fmrb-sig"><code>ctime() -&gt; <a href="../String/">String</a></code></pre>

asctime の別名

```ruby
t.ctime
```

---

*このページは fmruby-core の develop@9d470992 の API の型定義 (`sig/`) から自動で作っています。*
