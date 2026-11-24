# Time

Date and time. Make one with `Time.now`, `Time.at` (from UNIX seconds), or
`Time.local` / `Time.gm` (from a date). `t2 - t1` is a Float of seconds.
```ruby
t = Time.now
label = "%02d:%02d" % [t.hour, t.min]
```

## Class methods

### Time.now

<pre class="fmrb-sig"><code>now() -&gt; Time</code></pre>

The current time

The system clock's now, as local time. On a machine whose clock was never set it
gives whatever the clock says (no error).
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

New Time (now, or from a date)

**No arguments gives now.** Arguments are year, month, day, hour, minute, second and
microsecond, **only the year is required**, all Integers (a String is a TypeError),
read as **local time**. ArgumentError when out of range ("argument out of range";
"invalid time" for a date that cannot be made).
```ruby
Time.new
Time.new(2026, 11, 25, 9, 30)
```

### Time.at

<pre class="fmrb-sig"><code>at(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds, ?<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> usec) -&gt; Time</code></pre>

Make a Time from UNIX seconds

Seconds since 1970-01-01 00:00:00 UTC (an Integer or a Float; the fraction becomes
fractional seconds). The second argument adds microseconds (0 when left out).
Returns local time. TypeError for anything but an Integer or a Float.
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

Make a Time from a date (local time)

Arguments as for `Time.new`. `mktime` is the same method.
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

Make a Time from a date (alias of local)

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

Make a Time from a date (UTC)

Arguments as for `Time.local`, but **read as UTC**. `utc` is the same method.
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

Make a Time from a date (alias of gm)

```ruby
Time.utc(2026, 11, 25)
```

## Instance methods

### Time#+

<pre class="fmrb-sig"><code>+(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; Time</code></pre>

Add seconds

A new Time with the seconds (an Integer or a Float) added. Adding a Time is a
TypeError ("cannot convert Time to time").
```ruby
tomorrow = Time.now + 86400
```

### Time#-

<pre class="fmrb-sig"><code>-(Time other) -&gt; <a href="../Float/">Float</a>
-(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a> seconds) -&gt; Time</code></pre>

Difference, or subtract seconds

**Subtracting a Time gives the difference in seconds (a Float).** Subtracting a
number (an Integer or a Float) gives a new Time that many seconds earlier. To time
something, `Machine.board_millis` is lighter.
```ruby
sec = t2 - t1
```

### Time#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(untyped other) -&gt; <a href="../Integer/">Integer</a>?</code></pre>

Compare

Returns -1, 0 or 1. nil for something that is not a Time.
```ruby
t1 <=> t2
```

### Time#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Whether it is the same instant

True when the seconds and nanoseconds are the same (local or UTC is not looked at). `eql?` is the same method.
```ruby
t1 == t2
```

### Time#eql?

<pre class="fmrb-sig"><code>eql?(untyped other) -&gt; bool</code></pre>

Whether it is the same instant (alias of ==)

```ruby
t1.eql?(t2)
```

### Time#hash

<pre class="fmrb-sig"><code>hash() -&gt; <a href="../Integer/">Integer</a></code></pre>

Hash value

```ruby
t.hash
```

### Time#to_i

<pre class="fmrb-sig"><code>to_i() -&gt; <a href="../Integer/">Integer</a></code></pre>

UNIX seconds as an Integer

```ruby
t.to_i
```

### Time#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

UNIX seconds as a Float

For milliseconds: `(Time.now.to_f * 1000).to_i`.
```ruby
ms = (Time.now.to_f * 1000).to_i
```

### Time#year

<pre class="fmrb-sig"><code>year() -&gt; <a href="../Integer/">Integer</a></code></pre>

Year

```ruby
t.year
```

### Time#mon

<pre class="fmrb-sig"><code>mon() -&gt; <a href="../Integer/">Integer</a></code></pre>

Month (1-12)

`month` is the same method.
```ruby
t.mon
```

### Time#month

<pre class="fmrb-sig"><code>month() -&gt; <a href="../Integer/">Integer</a></code></pre>

Month (alias of mon)

```ruby
t.month
```

### Time#day

<pre class="fmrb-sig"><code>day() -&gt; <a href="../Integer/">Integer</a></code></pre>

Day of the month (1-31)

`mday` is the same method.
```ruby
t.day
```

### Time#mday

<pre class="fmrb-sig"><code>mday() -&gt; <a href="../Integer/">Integer</a></code></pre>

Day of the month (alias of day)

```ruby
t.mday
```

### Time#hour

<pre class="fmrb-sig"><code>hour() -&gt; <a href="../Integer/">Integer</a></code></pre>

Hour (0-23)

```ruby
t.hour
```

### Time#min

<pre class="fmrb-sig"><code>min() -&gt; <a href="../Integer/">Integer</a></code></pre>

Minute (0-59)

```ruby
t.min
```

### Time#sec

<pre class="fmrb-sig"><code>sec() -&gt; <a href="../Integer/">Integer</a></code></pre>

Second (0-59)

```ruby
t.sec
```

### Time#usec

<pre class="fmrb-sig"><code>usec() -&gt; <a href="../Integer/">Integer</a></code></pre>

Microseconds (0-999999)

```ruby
t.usec
```

### Time#nsec

<pre class="fmrb-sig"><code>nsec() -&gt; <a href="../Integer/">Integer</a></code></pre>

Nanoseconds (0-999999999)

`tv_nsec` is the same method.
```ruby
t.nsec
```

### Time#tv_nsec

<pre class="fmrb-sig"><code>tv_nsec() -&gt; <a href="../Integer/">Integer</a></code></pre>

Nanoseconds (alias of nsec)

```ruby
t.tv_nsec
```

### Time#wday

<pre class="fmrb-sig"><code>wday() -&gt; <a href="../Integer/">Integer</a></code></pre>

Day of the week (Sunday is 0)

```ruby
t.wday
```

### Time#yday

<pre class="fmrb-sig"><code>yday() -&gt; <a href="../Integer/">Integer</a></code></pre>

Day of the year (1-366)

```ruby
t.yday
```

### Time#dst?

<pre class="fmrb-sig"><code>dst?() -&gt; bool</code></pre>

Whether daylight saving applies

```ruby
t.dst?
```

### Time#sunday?

<pre class="fmrb-sig"><code>sunday?() -&gt; bool</code></pre>

Whether it is Sunday

```ruby
t.sunday?
```

### Time#monday?

<pre class="fmrb-sig"><code>monday?() -&gt; bool</code></pre>

Whether it is Monday

```ruby
t.monday?
```

### Time#tuesday?

<pre class="fmrb-sig"><code>tuesday?() -&gt; bool</code></pre>

Whether it is Tuesday

```ruby
t.tuesday?
```

### Time#wednesday?

<pre class="fmrb-sig"><code>wednesday?() -&gt; bool</code></pre>

Whether it is Wednesday

```ruby
t.wednesday?
```

### Time#thursday?

<pre class="fmrb-sig"><code>thursday?() -&gt; bool</code></pre>

Whether it is Thursday

```ruby
t.thursday?
```

### Time#friday?

<pre class="fmrb-sig"><code>friday?() -&gt; bool</code></pre>

Whether it is Friday

```ruby
t.friday?
```

### Time#saturday?

<pre class="fmrb-sig"><code>saturday?() -&gt; bool</code></pre>

Whether it is Saturday

```ruby
t.saturday?
```

### Time#zone

<pre class="fmrb-sig"><code>zone() -&gt; <a href="../String/">String</a></code></pre>

The zone as text

"UTC" for a UTC Time; for a local Time the **offset text** such as "+0900" (not a
name such as "JST").
```ruby
t.zone   #=> "+0900"
```

### Time#utc_offset

<pre class="fmrb-sig"><code>utc_offset() -&gt; <a href="../Integer/">Integer</a></code></pre>

Offset from UTC in seconds

0 for a UTC Time. `gmt_offset` and `gmtoff` are the same method.
```ruby
t.utc_offset   #=> 32400
```

### Time#gmt_offset

<pre class="fmrb-sig"><code>gmt_offset() -&gt; <a href="../Integer/">Integer</a></code></pre>

Offset from UTC (alias of utc_offset)

```ruby
t.gmt_offset
```

### Time#gmtoff

<pre class="fmrb-sig"><code>gmtoff() -&gt; <a href="../Integer/">Integer</a></code></pre>

Offset from UTC (alias of utc_offset)

```ruby
t.gmtoff
```

### Time#utc?

<pre class="fmrb-sig"><code>utc?() -&gt; bool</code></pre>

Whether it is a UTC Time

`gmt?` is the same method.
```ruby
t.utc?
```

### Time#gmt?

<pre class="fmrb-sig"><code>gmt?() -&gt; bool</code></pre>

Whether it is a UTC Time (alias of utc?)

```ruby
t.gmt?
```

### Time#utc

<pre class="fmrb-sig"><code>utc() -&gt; Time</code></pre>

Turn into UTC (changes the receiver)

**Changes the receiver itself** to UTC and returns it. Use `getutc` to keep the
original. `gmtime` is the same method.
```ruby
t.utc
```

### Time#gmtime

<pre class="fmrb-sig"><code>gmtime() -&gt; Time</code></pre>

Turn into UTC (alias of utc)

```ruby
t.gmtime
```

### Time#getutc

<pre class="fmrb-sig"><code>getutc() -&gt; Time</code></pre>

A new Time in UTC

The original is not changed. `getgm` is the same method.
```ruby
u = t.getutc
```

### Time#getgm

<pre class="fmrb-sig"><code>getgm() -&gt; Time</code></pre>

A new Time in UTC (alias of getutc)

```ruby
t.getgm
```

### Time#localtime

<pre class="fmrb-sig"><code>localtime() -&gt; Time</code></pre>

Turn into local time (changes the receiver)

**Changes the receiver itself** to local time and returns it. Use `getlocal` to
keep the original.
```ruby
t.localtime
```

### Time#getlocal

<pre class="fmrb-sig"><code>getlocal() -&gt; Time</code></pre>

A new Time in local time

The receiver is left as it is.
```ruby
l = t.getlocal
```

### Time#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; <a href="../String/">String</a></code></pre>

Text like "2026-11-25 09:30:00 +0900"

A UTC Time ends with "UTC". `inspect` is the same method.
```ruby
t.to_s
```

### Time#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; <a href="../String/">String</a></code></pre>

Text form (alias of to_s)

```ruby
t.inspect
```

### Time#asctime

<pre class="fmrb-sig"><code>asctime() -&gt; <a href="../String/">String</a></code></pre>

Text like "Wed Nov 25 09:30:00 2026"

`ctime` is the same method.
```ruby
t.asctime
```

### Time#ctime

<pre class="fmrb-sig"><code>ctime() -&gt; <a href="../String/">String</a></code></pre>

Alias of asctime

```ruby
t.ctime
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
