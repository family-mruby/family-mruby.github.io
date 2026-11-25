# Machine

Time, waiting, and telling platforms apart

How to use it: [Tasks & Timing](../system.md).

Time is `board_millis` (ms) and
`uptime_us` (microseconds), waiting is `delay_ms` and `busy_wait_ms`, and
`posix?` tells the platform.
**Some methods behave differently on an ESP32 board and on Linux or the browser build**
(noted per method).
```ruby
t0 = Machine.board_millis
```

## Class methods

### Machine.board_millis

<pre class="fmrb-sig"><code>board_millis() -&gt; <a href="../Integer/">Integer</a></code></pre>

Milliseconds since boot

Use it to measure elapsed time: take the **difference** of two readings.

The unit is milliseconds. Integers are 64-bit in every build (`MRB_INT64`), so
there is no wrap to worry about. **Where it starts counting differs**: an ESP32
counts from the board's boot, Linux and the native build from the **host's boot**
(not the app's or the simulator's), the browser build from the start of the
program. Do not give the value itself a meaning; use differences.

An app carried from another VM (checkpoint) goes on from the value it saw there
(an offset between that VM and this one is added). `uptime_us` does not get the
offset.
```ruby
t0 = Machine.board_millis
elapsed = Machine.board_millis - t0
```

### Machine.uptime_us

<pre class="fmrb-sig"><code>uptime_us() -&gt; <a href="../Integer/">Integer</a></code></pre>

Microseconds since boot

For finer measurements than `board_millis`. It starts counting where
`board_millis` does (the board's boot on an ESP32, the host's boot on Linux and
the native build, the start of the program in the browser).
**The offset of an app carried by checkpoint is not added.** Integers are 64-bit.
```ruby
t = Machine.uptime_us
work
dt = Machine.uptime_us - t
```

### Machine.uptime_formatted

<pre class="fmrb-sig"><code>uptime_formatted() -&gt; <a href="../String/">String</a></code></pre>

Uptime as a string

```ruby
Machine.uptime_formatted  #=> "0d 00:12:34.56"
```

### Machine.delay_ms

<pre class="fmrb-sig"><code>delay_ms(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Block this app for ms milliseconds

Blocks **the whole app task** for ms milliseconds. While it waits, `on_update`
and events are not handled and no other Task in the same VM runs. Unlike
`sleep_ms` (which switches Tasks), it also stops outside `_spin` (startup, for
instance).

A negative ms raises ArgumentError. It returns the ms you passed.

**How long it waits differs by platform.** The ESP32 code is FreeRTOS
`vTaskDelay(ms / 10)`, which assumes a 10 ms tick (under 10 ms it only yields).
This build's tick is 1 ms (`CONFIG_FREERTOS_HZ=1000`), so it may wait only about
a tenth of what you asked for. Linux and the native build watch the real clock
in 10 ms steps, so they wait up to about 10 ms longer.
```ruby
Machine.delay_ms(100)
```

### Machine.busy_wait_ms

<pre class="fmrb-sig"><code>busy_wait_ms(<a href="../Integer/">Integer</a> ms) -&gt; <a href="../Integer/">Integer</a></code></pre>

Busy-wait for ms milliseconds

A negative ms raises ArgumentError. It returns the ms you passed.

**On an ESP32 it spins the CPU and nothing else runs** (`ets_delay_us(1000 * ms)`).
Use `delay_ms` or `sleep_ms` for long waits. Linux and the native build call
`nanosleep` once; they do not spin, and a signal can **cut the wait short**.
```ruby
Machine.busy_wait_ms(2)
```

### Machine.sleep

<pre class="fmrb-sig"><code>sleep(<a href="../Integer/">Integer</a> sec) -&gt; <a href="../Integer/">Integer</a></code></pre>

Light-sleep for whole seconds

sec is in seconds, **2 to 86399**. A negative value or 86400 or more raises
ArgumentError. **Under 2 it does not sleep**: it prints a warning ("Cannot sleep
less than 2 sec") and returns. It also warns before sleeping. It returns the sec
you passed.

An ESP32 enters light sleep for the whole chip (`esp_light_sleep_start`).
**Linux and the native build do nothing and return at once.** Do not use it to
wait in an app; use `delay_ms` or `sleep_ms`.
```ruby
Machine.sleep(5)
```

### Machine.deep_sleep

<pre class="fmrb-sig"><code>deep_sleep(<a href="../Integer/">Integer</a> gpio_pin, bool edge, bool high) -&gt; bot</code></pre>

Deep sleep (not implemented)

**Always raises NotImplementedError in this build** (it does not look at the
arguments).
```ruby
begin
  Machine.deep_sleep(5, true, false)
rescue NotImplementedError
end
```

### Machine.unique_id

<pre class="fmrb-sig"><code>unique_id() -&gt; (<a href="../String/">String</a> | nil)</code></pre>

Return the machine's unique ID

**An ESP32 returns its MAC address as 12 hex digits (upper case).**
**Linux and the native build return the 32 digits in `/etc/machine-id`** (the host's ID).
It is **nil** when it cannot be read (the browser build has no such file).
```ruby
id = Machine.unique_id
```

### Machine.read_memory

<pre class="fmrb-sig"><code>read_memory(<a href="../Integer/">Integer</a> address, <a href="../Integer/">Integer</a> size) -&gt; <a href="../String/">String</a></code></pre>

Read raw bytes from an address

Returns size bytes from address as a new binary string.
**The address is not checked**:
an unreadable one crashes the whole firmware. For debugging.
```ruby
s = Machine.read_memory(addr, 16)
```

### Machine.stack_usage

<pre class="fmrb-sig"><code>stack_usage() -&gt; (<a href="../Integer/">Integer</a> | nil)</code></pre>

Stack usage (not supported)

**Always nil in this build** (both the ESP32 and the Linux code return 0, and 0
becomes nil).
```ruby
Machine.stack_usage  #=> nil
```

### Machine.set_hwclock

<pre class="fmrb-sig"><code>set_hwclock(<a href="../Integer/">Integer</a> tv_sec) -&gt; true</code></pre>

Set the system clock

tv_sec is UNIX time (seconds since 1970, UTC). **ESP32 only.** It returns true.
**Linux, the native build and the browser build raise NotImplementedError**
(a ScriptError, not a StandardError, so `rescue => e` does not catch it; check
`Machine.posix?` first). It does not write the RTC chip.
```ruby
Machine.set_hwclock(epoch) unless Machine.posix?
```

### Machine.get_hwclock

<pre class="fmrb-sig"><code>get_hwclock() -&gt; <a href="../Array/">Array</a>[<a href="../Integer/">Integer</a>]</code></pre>

Read the system clock

An array of `[seconds, nanoseconds]` (UNIX time, UTC). **ESP32 only.**
**Linux, the native build and the browser build raise NotImplementedError** (not caught
by `rescue => e`).
```ruby
sec, nsec = Machine.get_hwclock
```

### Machine.exit

<pre class="fmrb-sig"><code>exit(?<a href="../Integer/">Integer</a> status) -&gt; nil</code></pre>

Exit the program

**Does nothing on an ESP32** (returns nil).
**On Linux and the native build the whole firmware process exits**,
so do not call it from an app. Close an app with
`FmrbApp#stop`.
```ruby
Machine.exit(0)
# on Linux the firmware ends
```

### Machine.reboot

<pre class="fmrb-sig"><code>reboot(?<a href="../Integer/">Integer</a> wait_ms) -&gt; nil</code></pre>

Reboot (not usable in this build)

Tries to reboot after wait_ms (0 when left out).
**It raises NotImplementedError on an ESP32**
(the watchdog gem is not in the build). Linux and the native build
end the process with exit code 120. To restart the machine use
`FmrbSystem.reboot`.
```ruby
Machine.reboot(1000)
# on Linux: exit code 120
```

### Machine.posix?

<pre class="fmrb-sig"><code>posix?() -&gt; bool</code></pre>

Whether this is a POSIX build

**True on Linux, the native build and the browser build; false on an ESP32 board**
(true unless `RUBY_PLATFORM` is "ESP32"). Use it to separate calls that
only a board has (`set_hwclock` and so on).
```ruby
if Machine.posix?
  # simulator
end
```

### Machine.wifi_available?

<pre class="fmrb-sig"><code>wifi_available?() -&gt; bool</code></pre>

Whether Wi-Fi is available

True when `Network::WiFi` is defined.
**Family mruby has no such definition, so it is always false**
(ask `FmrbApp` and `FmrbNet` about Wi-Fi instead).
```ruby
Machine.wifi_available?  #=> false
```

### Machine.tud_task

<pre class="fmrb-sig"><code>tud_task() -&gt; nil</code></pre>

Run one USB device task step

**Empty in this build** (an ESP32 and Linux both do nothing and return nil).
```ruby
Machine.tud_task  #=> nil
```

### Machine.tud_mounted?

<pre class="fmrb-sig"><code>tud_mounted?() -&gt; bool</code></pre>

Whether USB is mounted

**Always false on an ESP32, always true on Linux and the native build** (it does
not look at a real connection).
```ruby
Machine.tud_mounted?
# false on ESP32, true on Linux
```

### Machine.bootsel_pressed?

<pre class="fmrb-sig"><code>bootsel_pressed?() -&gt; bool</code></pre>

Whether BOOTSEL is pressed (unavailable)

A feature of RP2 boards. **Always raises NotImplementedError in this build.**
```ruby
begin
  Machine.bootsel_pressed?
rescue NotImplementedError
end
```

### Machine.check_signal

<pre class="fmrb-sig"><code>check_signal() -&gt; nil</code></pre>

Raise a pending Ctrl-C as an exception

Raises Interrupt ("SIGINT") when Ctrl-C was received, SignalException ("SIGTSTP")
for Ctrl-Z, and returns nil when nothing is pending. Only
**the standard input of Linux and the native build**
receives them (nothing sets it on an ESP32, so
it is always nil there).
```ruby
begin
  Machine.check_signal
rescue Interrupt
end
```

### Machine.poll_signal

<pre class="fmrb-sig"><code>poll_signal() -&gt; (<a href="../Symbol/">Symbol</a> | nil)</code></pre>

Return a pending Ctrl-C as a Symbol

`check_signal` without the exception: `:INT` for Ctrl-C, `:TSTP` for Ctrl-Z, nil
when nothing is pending.
```ruby
case Machine.poll_signal
when :INT then stop
end
```

### Machine.signal_self_manage

<pre class="fmrb-sig"><code>signal_self_manage() -&gt; true</code></pre>

Mark that this program handles signals

Only raises a flag, which `pop_signal_self_manage` reads and clears.
```ruby
Machine.signal_self_manage  #=> true
```

### Machine.pop_signal_self_manage

<pre class="fmrb-sig"><code>pop_signal_self_manage() -&gt; bool</code></pre>

Read and clear the signal flag

Returns true when `signal_self_manage` raised the flag, and clears it.
```ruby
Machine.signal_self_manage
Machine.pop_signal_self_manage #=> true
```

### Machine.debug_puts

<pre class="fmrb-sig"><code>debug_puts(*untyped messages) -&gt; nil</code></pre>

Write a diagnostic line to stderr

Writes each argument's `to_s` on its own line. **ESP32 only**: Linux, the native
build and the browser build do not have this method (NoMethodError).
```ruby
Machine.debug_puts("x=#{x}")
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@9274e3b8.*
