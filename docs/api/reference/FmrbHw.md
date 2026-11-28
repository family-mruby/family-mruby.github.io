# FmrbHw

Read the table of how pins are used

How to use it: [Hardware Control](../peripherals.md), [Constants & System Info](../const.md).

Which pins are system-only, and which an app's `GPIO`,
`I2C` or RMT holds. Check with `FmrbHw.pin_available?` which pins an app may use on this board.
**Only a real board marks the table.** The Linux sim, the native build
and the browser build have no pins, so every entry stays `PIN_UNUSED` (49 pins).
```ruby
if FmrbHw.pin_available?(5)
  io = GPIO.new(5, GPIO::OUT)
end
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`PIN_UNUSED`</span> | [`Integer`](Integer.md) | A pin nobody uses |
| <span class="fmrb-name">`PIN_SYSTEM_EXCLUSIVE`</span> | [`Integer`](Integer.md) | System-only pin; apps cannot use it |
| <span class="fmrb-name">`PIN_USER_GPIO`</span> | [`Integer`](Integer.md) | Held by an app as GPIO |
| <span class="fmrb-name">`PIN_USER_I2C`</span> | [`Integer`](Integer.md) | Held by I2C |
| <span class="fmrb-name">`PIN_USER_RMT`</span> | [`Integer`](Integer.md) | Held by RMT |
| <span class="fmrb-name">`PIN_USER_SPI`</span> | [`Integer`](Integer.md) | Held by SPI (a reserved value) |
| <span class="fmrb-name">`PIN_USER_PWM`</span> | [`Integer`](Integer.md) | Held by PWM (a reserved value) |
| <span class="fmrb-name">`PIN_USER_UART`</span> | [`Integer`](Integer.md) | Held by UART (a reserved value) |
| <span class="fmrb-name">`PIN_I2C1_SDA`</span> | [`Integer`](Integer.md) | Pin number of I2C1 SDA |
| <span class="fmrb-name">`PIN_I2C1_SCL`</span> | [`Integer`](Integer.md) | Pin number of I2C1 SCL |
| <span class="fmrb-name">`PIN_I2C2_SDA`</span> | [`Integer`](Integer.md) | Pin number of I2C2 SDA |
| <span class="fmrb-name">`PIN_I2C2_SCL`</span> | [`Integer`](Integer.md) | Pin number of I2C2 SCL |

## Class methods

### FmrbHw.pin_status

<pre class="fmrb-sig"><code>pin_status(<a href="../Integer/">Integer</a> pin) -&gt; <a href="../Integer/">Integer</a></code></pre>

How a pin is used (a PIN_* value)

A pin the system uses is `PIN_SYSTEM_EXCLUSIVE` even when the table does not hold it (the
same pins `GPIO` refuses). A pin number out of range does not raise: it is `PIN_UNUSED` (0).
```ruby
FmrbHw.pin_status(25) == FmrbHw::PIN_SYSTEM_EXCLUSIVE
```

### FmrbHw.pin_available?

<pre class="fmrb-sig"><code>pin_available?(<a href="../Integer/">Integer</a> pin) -&gt; bool</code></pre>

Whether an app can take the pin

true only for a `PIN_UNUSED` pin. **A number out of range is false**, and so is a
system-only pin (one `GPIO` refuses) or one somebody already holds.
```ruby
FmrbHw.pin_available?(5)   #=> true or false
```

### FmrbHw.pin_status_all

<pre class="fmrb-sig"><code>pin_status_all() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

How every pin is used

The index is the pin number and the value is a `PIN_*` (as `pin_status` gives it). The
length is `pin_count`.
```ruby
FmrbHw.pin_status_all[5]
```

### FmrbHw.pin_count

<pre class="fmrb-sig"><code>pin_count() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many pins the table has

**55 on an ESP32-P4 board** (GPIO 0..54); 49 elsewhere (S3, Linux sim, native, browser) (GPIO 0..48).
```ruby
FmrbHw.pin_count   #=> 55 or 49
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
