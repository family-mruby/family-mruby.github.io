# GPIO::Error

Peripheral error codes and their exceptions

How to use it: [Hardware Control](../peripherals.md).

The constants `GPIO_ERROR_NONE` (0), `TIMEOUT` (-1), `GENERIC` (-2), `NO_DATA` (-3),
`NOT_PERMITTED` (-4), `INVALID_ARG` (-5) and `IO` (-6) are the codes.
```ruby
GPIO::Error.peripheral_error(0)   #=> 0
```

## Class methods

### GPIO::Error.peripheral_error

<pre class="fmrb-sig"><code>peripheral_error(<a href="../Integer/">Integer</a> code, ?<a href="../String/">String</a> name) -&gt; <a href="../Integer/">Integer</a></code></pre>

Turn a code into an exception

0 (`GPIO_ERROR_NONE`) returns 0. Any other code raises **IOError** (the message looks like
"Timeout error in name"; an unknown code is "Unknown error in name. code: n").
`name` is "unknown peripheral" when left out. No bundled app calls it.
```ruby
GPIO::Error.peripheral_error(-1, "uart")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@1ff55c21.*
