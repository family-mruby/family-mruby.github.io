# String

A string (UTF-8)

Positions in `length` and `[]` count **characters**, not bytes; use
`bytesize`, `getbyte` and `byteslice` for binary data. `+` makes a new
string each time, so build in a loop with `<<`.
**There is no Regexp** here.

## Instance methods

### String#!

<pre class="fmrb-sig"><code>!() -&gt; bool</code></pre>

Return logical NOT

A string is always true, so this is always false.
```ruby
!"a"  #=> false
```

### String#*

<pre class="fmrb-sig"><code>*(<a href="../Integer/">Integer</a> count) -&gt; String</code></pre>

Repeat string specified number of times

Handy for a rule or for padding; 0 gives an empty string.
```ruby
"-" * 39
"\x00" * 16  # a 16-byte buffer
```

### String#+

<pre class="fmrb-sig"><code>+(String other) -&gt; String</code></pre>

Concatenate strings

Every `+` makes a new string; build up with `<<` inside a loop instead.
```ruby
a = "foo" + "bar"
```

### String#<

<pre class="fmrb-sig"><code>&lt;(String other) -&gt; bool</code></pre>

Check if lexicographically smaller

```ruby
"abc" < "abd"  #=> true
```

### String#<<

<pre class="fmrb-sig"><code>&lt;&lt;(String | <a href="../Integer/">Integer</a> string_or_codepoint) -&gt; String</code></pre>

Append string or character code

It changes the string in place, so it beats `+`. An integer is appended as
a character code.
```ruby
buf = ""
buf << "a"
buf << 65  # "A"
```

### String#<=

<pre class="fmrb-sig"><code>&lt;=(String other) -&gt; bool</code></pre>

Check if lexicographically less than or equal

```ruby
"abc" <= "abc"  #=> true
```

### String#<=>

<pre class="fmrb-sig"><code>&lt;=&gt;(String other) -&gt; <a href="../Integer/">Integer</a></code></pre>

Compare lexicographically. Returns -1, 0 or 1

Used as the comparison when sorting.
```ruby
"a" <=> "b"  #=> -1
```

### String#==

<pre class="fmrb-sig"><code>==(untyped other) -&gt; bool</code></pre>

Perform equality comparison

Compares the contents, not whether they are the same object.
```ruby
"abc" == "abc"  #=> true
```

### String#===

<pre class="fmrb-sig"><code>===(untyped other) -&gt; bool</code></pre>

Perform equality comparison (for case statements)

```ruby
case s
when "quit" then finish
end
```

### String#>

<pre class="fmrb-sig"><code>&gt;(String other) -&gt; bool</code></pre>

Check if lexicographically greater

```ruby
"b" > "a"  #=> true
```

### String#>=

<pre class="fmrb-sig"><code>&gt;=(String other) -&gt; bool</code></pre>

Check if lexicographically greater than or equal

```ruby
"b" >= "b"  #=> true
```

### String#[]

<pre class="fmrb-sig"><code>[](untyped index_or_range) -&gt; (String | nil)</code></pre>

Get character or substring at specified position

The position counts **characters**, not bytes; outside the string it is
nil.
```ruby
s[0]
s[0, 3]
s[1..2]
```

### String#[]=

<pre class="fmrb-sig"><code>[]=(untyped index_or_range, String replacement) -&gt; String</code></pre>

Replace the character or substring there

The length may change: one character can become three.
```ruby
s[0] = "X"
s[0, 2] = "ab"
```

### String#__ljust_rjust_argcheck

<pre class="fmrb-sig"><code>__ljust_rjust_argcheck(<a href="../Integer/">Integer</a> | String width_or_padding) -&gt; nil</code></pre>

Internal argument check for ljust and rjust

**Internal.** Not meant to be called.

### String#bytes

<pre class="fmrb-sig"><code>bytes() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

Return byte sequence of string as array

It builds an array, so it costs on a long string; for one byte use
`getbyte`.
```ruby
"AB".bytes  #=> [65, 66]
```

### String#bytesize

<pre class="fmrb-sig"><code>bytesize() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return the size in bytes, not characters

**Use this for binary data.** `length` counts a Japanese character as one,
so the two differ.
```ruby
"あ".bytesize  #=> 3
"あ".length    #=> 1
```

### String#byteslice

<pre class="fmrb-sig"><code>byteslice(<a href="../Integer/">Integer</a> start, ?<a href="../Integer/">Integer</a> length) -&gt; (String | nil)
byteslice(<a href="../Range/">Range</a> range) -&gt; (String | nil)</code></pre>

Cut out a part by byte offset and byte length

Returns length bytes from byte start as a new string.
**Both count bytes.** A Japanese character is 3 bytes (UTF-8),
so a position from `[]`, `slice`, `length` or `index` (which
count characters) lands in the wrong place once the string holds
Japanese. Pair it with `bytesize` and `getbyte`, which count bytes.

A negative start counts from the end; a length past the end stops at
the end. A start right at the end (`bytesize`) gives ""; a start past
it, or a negative length, gives **nil** (no exception), so put
`.to_s` before another string method. Cutting inside a character does
not stop it: you get the broken bytes.

Without length you get that one byte (nil from the end on). A
range of bytes (`2..4`) works too.
```ruby
s = "あいう"
s.byteslice(3, 3)   #=> "い"
s[1]                #=> "い"
s.byteslice(9, 1)   #=> ""
s.byteslice(10, 1)  #=> nil
rest = s.byteslice(3,
  s.bytesize - 3).to_s
```

### String#chars

<pre class="fmrb-sig"><code>chars() -&gt; <a href="../Array/">Array</a>[String]</code></pre>

Return characters of string as array

Japanese splits per character too.
```ruby
"あい".chars  #=> ["あ", "い"]
```

### String#chomp

<pre class="fmrb-sig"><code>chomp() -&gt; String</code></pre>

Return string with trailing newline removed

Drops the newline that `gets` leaves on.
```ruby
line.chomp
```

### String#chomp!

<pre class="fmrb-sig"><code>chomp!() -&gt; (String | nil)</code></pre>

Remove trailing newline destructively

**Returns nil when there was no newline**, not the string.
```ruby
line.chomp!
```

### String#clear

<pre class="fmrb-sig"><code>clear() -&gt; String</code></pre>

Clear string contents

Reuses the same object.
```ruby
buf.clear
```

### String#downcase

<pre class="fmrb-sig"><code>downcase() -&gt; String</code></pre>

Return string converted to lowercase

**Only ASCII letters** change.
```ruby
"ABC".downcase  #=> "abc"
```

### String#downcase!

<pre class="fmrb-sig"><code>downcase!() -&gt; (String | nil)</code></pre>

Convert to lowercase destructively

**nil when nothing changed.**
```ruby
s.downcase!
```

### String#each_byte

<pre class="fmrb-sig"><code>each_byte() { (<a href="../Integer/">Integer</a> byte) -&gt; untyped } -&gt; self</code></pre>

Execute block for each byte

**A block call costs about 0.4ms.** On a long string, `while` with
`getbyte` is faster.
```ruby
s.each_byte do |b|
  n += b
end
```

### String#each_char

<pre class="fmrb-sig"><code>each_char() { (String character) -&gt; untyped } -&gt; self</code></pre>

Execute block for each character

```ruby
s.each_char do |c|
  draw(c)
end
```

### String#each_line

<pre class="fmrb-sig"><code>each_line(
  ?String separator,
  ?chomp: bool
) { (String line) -&gt; untyped } -&gt; String</code></pre>

Execute block for each line

**`chomp: true` drops the newlines.**
```ruby
text.each_line(chomp: true) do |l|
  handle(l)
end
```

### String#empty?

<pre class="fmrb-sig"><code>empty?() -&gt; bool</code></pre>

Check if string is empty

```ruby
return if s.empty?
```

### String#end_with?

<pre class="fmrb-sig"><code>end_with?(String suffix) -&gt; bool</code></pre>

Check if ends with specified string

**There is no Regexp here**, so this is how you check a file extension.
```ruby
if path.end_with?(".rb")
```

### String#getbyte

<pre class="fmrb-sig"><code>getbyte(<a href="../Integer/">Integer</a> index) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

Get byte value at specified position

**The way to read binary data.** nil outside the string.
```ruby
b = data.getbyte(4)
```

### String#setbyte

<pre class="fmrb-sig"><code>setbyte(<a href="../Integer/">Integer</a> index, <a href="../Integer/">Integer</a> byte) -&gt; <a href="../Integer/">Integer</a></code></pre>

Set the byte value at a position

**There is no `Array#pack`**, so make a `"\x00" * n` buffer and write the
bytes in.
```ruby
buf = "\x00" * 4
buf.setbyte(0, 0x12)
```

### String#include?

<pre class="fmrb-sig"><code>include?(String other) -&gt; bool</code></pre>

Check if contains specified string

Measured at 1.7ms -- do not call it on every pass of a loop.
```ruby
if s.include?("err")
```

### String#index

<pre class="fmrb-sig"><code>index(
  String | <a href="../Integer/">Integer</a> substring_or_codepoint,
  ?<a href="../Integer/">Integer</a> offset
) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

Return first position of specified string

**nil when it is not there.** The second argument says where to start.
```ruby
i = s.index("=")
j = s.index(",", i + 1)
```

### String#rindex

<pre class="fmrb-sig"><code>rindex(String substring, ?<a href="../Integer/">Integer</a> offset) -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

Return the last position of a substring

Returns the **character** position (a Japanese character counts as 1), or **nil**
when it is not found. `offset` (the end of the string when left out) is where the
search starts; nothing after it is looked at. **Strings only** (no Regexp, no
Integer).
```ruby
path.rindex("/")      #=> 8
path.rindex(".", 5)
```

### String#inspect

<pre class="fmrb-sig"><code>inspect() -&gt; String</code></pre>

Return string representation for debugging

Adds quotes and escapes; what you want in a log line.
```ruby
p s
```

### String#intern

<pre class="fmrb-sig"><code>intern() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

Convert to symbol

The same as `to_sym`.
```ruby
"name".intern  #=> :name
```

### String#length

<pre class="fmrb-sig"><code>length() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return string length

**Counts UTF-8 characters.** For bytes, use `bytesize`.
```ruby
"あい".length  #=> 2
```

### String#size

<pre class="fmrb-sig"><code>size() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return string length

The same as `length`.
```ruby
s.size
```

### String#ljust

<pre class="fmrb-sig"><code>ljust(<a href="../Integer/">Integer</a> width, ?String padding) -&gt; String</code></pre>

Return string left-justified to specified width

For laying out a table. The width counts characters, so a mix with
Japanese will not line up.
```ruby
"id".ljust(8)
"id".ljust(8, ".")
```

### String#lstrip

<pre class="fmrb-sig"><code>lstrip() -&gt; String</code></pre>

Return string with leading whitespace removed

```ruby
"  a".lstrip  #=> "a"
```

### String#lstrip!

<pre class="fmrb-sig"><code>lstrip!() -&gt; (String | nil)</code></pre>

Remove leading whitespace destructively

**nil when nothing changed.**
```ruby
s.lstrip!
```

### String#ord

<pre class="fmrb-sig"><code>ord() -&gt; <a href="../Integer/">Integer</a></code></pre>

Return character code of first character

**The first character only.**
```ruby
"A".ord  #=> 65
```

### String#rjust

<pre class="fmrb-sig"><code>rjust(<a href="../Integer/">Integer</a> width, ?String padding) -&gt; String</code></pre>

Return string right-justified to specified width

For lining numbers up on the right.
```ruby
n.to_s.rjust(4)
"7".rjust(3, "0")  #=> "007"
```

### String#rstrip

<pre class="fmrb-sig"><code>rstrip() -&gt; String</code></pre>

Return string with trailing whitespace removed

```ruby
"a  ".rstrip  #=> "a"
```

### String#rstrip!

<pre class="fmrb-sig"><code>rstrip!() -&gt; (String | nil)</code></pre>

Remove trailing whitespace destructively

**nil when nothing changed.**
```ruby
s.rstrip!
```

### String#slice

<pre class="fmrb-sig"><code>slice(untyped index_or_range) -&gt; (String | nil)</code></pre>

Get character or substring at specified position

The same as `[]`.
```ruby
s.slice(0, 3)
```

### String#split

<pre class="fmrb-sig"><code>split(?String separator, ?<a href="../Integer/">Integer</a> limit) -&gt; <a href="../Array/">Array</a>[String]</code></pre>

Split by delimiter and return array

**With no argument it splits on whitespace.** A limit keeps the rest
together -- what you want for a `key=value` line.
```ruby
"a,b,c".split(",")
"k=a=b".split("=", 2)
```

### String#start_with?

<pre class="fmrb-sig"><code>start_with?(String prefix) -&gt; bool</code></pre>

Check if starts with specified string

```ruby
if line.start_with?("#")
```

### String#strip

<pre class="fmrb-sig"><code>strip() -&gt; String</code></pre>

Return the string without surrounding whitespace

The usual first step when reading a settings file.
```ruby
key = parts[0].strip
```

### String#strip!

<pre class="fmrb-sig"><code>strip!() -&gt; (String | nil)</code></pre>

Remove leading and trailing whitespace destructively

**nil when nothing changed.**
```ruby
s.strip!
```

### String#to_f

<pre class="fmrb-sig"><code>to_f() -&gt; <a href="../Float/">Float</a></code></pre>

Convert to floating point number

**0.0 when it does not start with a number** -- it never raises.
```ruby
"1.5".to_f  #=> 1.5
```

### String#to_i

<pre class="fmrb-sig"><code>to_i(?<a href="../Integer/">Integer</a> base) -&gt; <a href="../Integer/">Integer</a></code></pre>

Convert to integer

**0 when it does not start with a number.** Pass 16 to read hex.
```ruby
"12".to_i     #=> 12
"ff".to_i(16) #=> 255
```

### String#to_s

<pre class="fmrb-sig"><code>to_s() -&gt; String</code></pre>

Return self as string

Returns itself.
```ruby
s.to_s
```

### String#to_sym

<pre class="fmrb-sig"><code>to_sym() -&gt; <a href="../Symbol/">Symbol</a></code></pre>

Convert to symbol

**A symbol is never freed**, so do not make them from arbitrary input.
```ruby
"name".to_sym  #=> :name
```

### String#tr

<pre class="fmrb-sig"><code>tr(String source, String replacement) -&gt; String</code></pre>

Return string with characters replaced

Maps **character to character**; it does not replace a whole substring.
```ruby
"a-b".tr("-", "_")  #=> "a_b"
```

### String#tr!

<pre class="fmrb-sig"><code>tr!(String source, String replacement) -&gt; (String | nil)</code></pre>

Replace characters destructively

**nil when nothing changed.**
```ruby
s.tr!("-", "_")
```

### String#upcase

<pre class="fmrb-sig"><code>upcase() -&gt; String</code></pre>

Return string converted to uppercase

```ruby
"abc".upcase  #=> "ABC"
```

### String#upcase!

<pre class="fmrb-sig"><code>upcase!() -&gt; (String | nil)</code></pre>

Convert to uppercase destructively

**nil when nothing changed.**
```ruby
s.upcase!
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
