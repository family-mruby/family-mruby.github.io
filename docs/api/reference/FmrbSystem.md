# FmrbSystem

The machine's settings and services

How to use it: [Application](../fmrb_app.md).

Changes the machine's Wi-Fi, BLE, power, clock, audio settings and the
PC's settings. Reading the state is on FmrbApp.
```ruby
FmrbSystem.set_audio_mute(true)
```

## Class methods

### FmrbSystem.set_wallclock

<pre class="fmrb-sig"><code>set_wallclock(
  <a href="../Integer/">Integer</a> year,
  <a href="../Integer/">Integer</a> month,
  <a href="../Integer/">Integer</a> day,
  <a href="../Integer/">Integer</a> hour,
  <a href="../Integer/">Integer</a> minute,
  <a href="../Integer/">Integer</a> second
) -&gt; <a href="../Hash/">Hash</a>?</code></pre>

Set the date and time

Takes **local time** and returns the same moment in UTC.
**Only a device acts on it**; Linux and the browser do nothing.
```ruby
FmrbSystem.set_wallclock(2026, 9, 1,
                         12, 0, 0)
```

### FmrbSystem.reboot

<pre class="fmrb-sig"><code>reboot() -&gt; void</code></pre>

Restart the machine

Restarts the machine. **Does not return.** Devices only.
```ruby
FmrbSystem.reboot
```

### FmrbSystem.set_audio_mute

<pre class="fmrb-sig"><code>set_audio_mute(bool on) -&gt; void</code></pre>

Mute or unmute the whole machine

true mutes. Sound keeps playing and only the output goes silent, like a
speaker's mute. Saved, so it survives a reboot. External MIDI output is
not affected.
```ruby
FmrbSystem.set_audio_mute(true)
```

### FmrbSystem.set_audio_volume

<pre class="fmrb-sig"><code>set_audio_volume(<a href="../Integer/">Integer</a> step) -&gt; void</code></pre>

Set the machine's volume (0-10)

0 is silence, 10 the loudest. Separate from the mute: unmuting comes back
at this volume. Saved, so it survives a reboot.
```ruby
FmrbSystem.set_audio_volume(5)
```

### FmrbSystem.preview_audio_volume

<pre class="fmrb-sig"><code>preview_audio_volume(<a href="../Integer/">Integer</a> step) -&gt; void</code></pre>

Try a volume without saving it

For a settings screen's live preview. Saving is audio_conf_saved or
set_audio_volume.
```ruby
FmrbSystem.preview_audio_volume(v)
```

### FmrbSystem.audio_conf_saved

<pre class="fmrb-sig"><code>audio_conf_saved() -&gt; void</code></pre>

Say the sound settings were written

Call after writing the current mute and volume into system_conf yourself.
Drops the save that was waiting.
```ruby
FmrbSystem.audio_conf_saved
```

### FmrbSystem.remote_access

<pre class="fmrb-sig"><code>remote_access() -&gt; <a href="../Integer/">Integer</a></code></pre>

Whether the remote control is allowed

The release build's WiFi remote control. -1: not here (a development
build needs no allowing), 0: closed, 1: open (kept across restarts until
it is closed).
```ruby
FmrbSystem.remote_access
# -1, 0 or 1
```

### FmrbSystem.remote_access_code

<pre class="fmrb-sig"><code>remote_access_code() -&gt; <a href="../Integer/">Integer</a></code></pre>

The number a PC pairs with

The six-digit number shown while "Pair a PC" is open; -1 when there is
none, -2 when wrong numbers stopped pairing.
```ruby
code = FmrbSystem.remote_access_code
sprintf('%06d', code) if code >= 0
```

### FmrbSystem.set_remote_access

<pre class="fmrb-sig"><code>set_remote_access(bool on) -&gt; void</code></pre>

Open or close the remote control

Kept until it is closed, across restarts. Closing it also cuts what is
connected.
```ruby
FmrbSystem.set_remote_access(true)
```

### FmrbSystem.set_remote_pairing

<pre class="fmrb-sig"><code>set_remote_pairing(bool on) -&gt; void</code></pre>

Start or stop taking new PCs

New PCs pair only while it is on, with the number it shows. Each start
shows a new number and lifts the stop after wrong numbers. PCs already
paired work either way.
```ruby
FmrbSystem.set_remote_pairing(true)
FmrbSystem.set_remote_pairing(false)
```

### FmrbSystem.remote_access_paired

<pre class="fmrb-sig"><code>remote_access_paired() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many PCs are paired

How many PCs are paired with the release build's remote control; 0 in a build that has no such guard.
0 again once `revoke_remote_access` has forgotten them all.
```ruby
n = FmrbSystem.remote_access_paired
FmrbSystem.revoke_remote_access
FmrbSystem.remote_access_paired  #=> 0
```

### FmrbSystem.revoke_remote_access

<pre class="fmrb-sig"><code>revoke_remote_access() -&gt; bool</code></pre>

Forget every paired PC

true when the change was saved.
```ruby
FmrbSystem.revoke_remote_access
```

### FmrbSystem.ble_start

<pre class="fmrb-sig"><code>ble_start() -&gt; bool</code></pre>

Start Bluetooth

Starts BLE by hand. For Retro.
```ruby
ok = FmrbSystem.ble_start
```

### FmrbSystem.ble_state

<pre class="fmrb-sig"><code>ble_state() -&gt; <a href="../Integer/">Integer</a></code></pre>

How Bluetooth is doing

```ruby
st = FmrbSystem.ble_state
```

### FmrbSystem.ble_settings_window

<pre class="fmrb-sig"><code>ble_settings_window(<a href="../Integer/">Integer</a> seconds) -&gt; <a href="../Integer/">Integer</a></code></pre>

Open the window for settings over BLE

Opens it for that many seconds (0 closes it) and returns the seconds
left, 0 when it did not open. While it is open the BLE console may write
the WiFi and Asterism settings.

```ruby
FmrbSystem.ble_settings_window(300)
```

### FmrbSystem.ble_settings_left

<pre class="fmrb-sig"><code>ble_settings_left() -&gt; <a href="../Integer/">Integer</a></code></pre>

Seconds left in the settings window

0 when it is closed.
```ruby
left = FmrbSystem.ble_settings_left
# seconds; 0 when closed
```

### FmrbSystem.rd_stream_state

<pre class="fmrb-sig"><code>rd_stream_state() -&gt; <a href="../Integer/">Integer</a></code></pre>

Whether the screen is being streamed

Whether anyone is watching over the remote desktop.
```ruby
FmrbSystem.rd_stream_state > 0
# someone is watching
```

### FmrbSystem.power_actions

<pre class="fmrb-sig"><code>power_actions() -&gt; <a href="../Array/">Array</a></code></pre>

The power actions this machine offers

Which of `:reset`, `:exit`, `:power_off`, `:restart`, `:suspend` and
`:lock` this machine offers: `[:reset]` on a device, none in the
simulation and the browser.
```ruby
FmrbSystem.power_actions
```

### FmrbSystem.power

<pre class="fmrb-sig"><code>power(<a href="../Symbol/">Symbol</a> action) -&gt; bool</code></pre>

Do one of the power actions

false when this machine does not offer it.
```ruby
FmrbSystem.power(:reset)
```

### FmrbSystem.linux_apps

<pre class="fmrb-sig"><code>linux_apps(<a href="../Integer/">Integer</a> mode, <a href="../String/">String</a> lang) -&gt; <a href="../String/">String</a></code></pre>

The PC's applications, for the launcher

Only the native program as the compositor has them; "" elsewhere. A
header line, then for mode 0 one "name\tid\ticon" line each. Mode 1
reads them again, mode 2 gives the header only.
```ruby
FmrbSystem.linux_apps(0, "ja")
```

### FmrbSystem.linux_launch

<pre class="fmrb-sig"><code>linux_launch(<a href="../Integer/">Integer</a> id) -&gt; <a href="../Integer/">Integer</a></code></pre>

Start one of the PC's applications

0 when asked, -1 when there is no such entry. Never waits.
```ruby
FmrbSystem.linux_launch(id)
```

### FmrbSystem.linux_handlers

<pre class="fmrb-sig"><code>linux_handlers(<a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

The PC's applications that open a file

One a line; the native program only, "" elsewhere.
```ruby
FmrbSystem.linux_handlers(
  "/home/a.png")
```

### FmrbSystem.linux_open

<pre class="fmrb-sig"><code>linux_open(<a href="../Integer/">Integer</a> id, <a href="../String/">String</a> path) -&gt; <a href="../String/">String</a></code></pre>

Open a file in one of the PC's applications

"" when asked, else why not.
```ruby
FmrbSystem.linux_open(id, path)
```

### FmrbSystem.wifi_networks

<pre class="fmrb-sig"><code>wifi_networks(bool scan) -&gt; <a href="../String/">String</a></code></pre>

The Wi-Fi networks

The Wi-Fi page's text; "" where Family mruby does not choose the
network (the simulation, the browser). true also asks for a scan.
```ruby
FmrbSystem.wifi_networks(true)
```

### FmrbSystem.wifi_connect

<pre class="fmrb-sig"><code>wifi_connect(<a href="../String/">String</a> ssid, <a href="../String/">String</a> password) -&gt; bool</code></pre>

Join a Wi-Fi network

```ruby
FmrbSystem.wifi_connect("home",
                        "secret")
```

### FmrbSystem.wifi_disconnect

<pre class="fmrb-sig"><code>wifi_disconnect() -&gt; bool</code></pre>

Leave the Wi-Fi network

```ruby
FmrbSystem.wifi_disconnect
```

### FmrbSystem.wifi_forget

<pre class="fmrb-sig"><code>wifi_forget(<a href="../String/">String</a> ssid) -&gt; bool</code></pre>

Forget a saved Wi-Fi network

```ruby
FmrbSystem.wifi_forget("home")
```

### FmrbSystem.bt_devices

<pre class="fmrb-sig"><code>bt_devices() -&gt; <a href="../String/">String</a></code></pre>

The Bluetooth devices

The PC only; "" elsewhere.
```ruby
FmrbSystem.bt_devices != ""
# true on the PC
```

### FmrbSystem.bt_power

<pre class="fmrb-sig"><code>bt_power(bool on) -&gt; bool</code></pre>

Turn Bluetooth on or off

```ruby
FmrbSystem.bt_power(true)
```

### FmrbSystem.bt_connect

<pre class="fmrb-sig"><code>bt_connect(<a href="../String/">String</a> address, bool on) -&gt; bool</code></pre>

Connect or disconnect a Bluetooth device

```ruby
FmrbSystem.bt_connect(addr, true)
```

### FmrbSystem.notices_gen

<pre class="fmrb-sig"><code>notices_gen() -&gt; <a href="../Integer/">Integer</a></code></pre>

How many times the PC's notices changed

-1 where there are no notices.
```ruby
g = FmrbSystem.notices_gen
# -1: no notices here
```

### FmrbSystem.notices

<pre class="fmrb-sig"><code>notices() -&gt; <a href="../String/">String</a></code></pre>

The PC's notices

One "id\tkind\tapp\tsummary\tbody" line each; "" where there are none.
```ruby
text = FmrbSystem.notices
lines = text.split("\n")
```

### FmrbSystem.notice_dismiss

<pre class="fmrb-sig"><code>notice_dismiss(<a href="../Integer/">Integer</a> id) -&gt; void</code></pre>

Dismiss one of the PC's notices

```ruby
FmrbSystem.notice_dismiss(id)
```

### FmrbSystem.wl_window

<pre class="fmrb-sig"><code>wl_window() -&gt; (<a href="../String/">String</a> | bool | nil)</code></pre>

The stand-in's Linux window title

The title while the Linux window is there, false once it has gone, nil
when the caller is no stand-in. The native program only.
```ruby
st = FmrbSystem.wl_window
# title; false once gone; nil if no
# stand-in
```

### FmrbSystem.wl_close

<pre class="fmrb-sig"><code>wl_close() -&gt; bool</code></pre>

Ask the Linux window to close

Its program may ask about unsaved work first, or refuse. The native
program only.
```ruby
if FmrbSystem.wl_close
  redraw_close_button
end
```

### FmrbSystem.wl_key

<pre class="fmrb-sig"><code>wl_key() -&gt; <a href="../Integer/">Integer</a></code></pre>

The canvas's colour key (native only)

The colour (RGB332) the stand-in paints outside its rounded corners.
```ruby
key = FmrbSystem.wl_key
```

### FmrbSystem.linux_keyboard

<pre class="fmrb-sig"><code>linux_keyboard() -&gt; <a href="../String/">String</a></code></pre>

Linux's keyboard layout (native only)

"jp" or "us"; keyboard_layout = "auto" follows it.
```ruby
FmrbSystem.linux_keyboard
# "jp" or "us" (native only)
```

### FmrbSystem.linux_settings

<pre class="fmrb-sig"><code>linux_settings(<a href="../String/">String</a> page) -&gt; bool</code></pre>

Open the PC's settings window (native only)

On the "wifi", "bluetooth" or "display" page.
```ruby
FmrbSystem.linux_settings("wifi")
```

### FmrbSystem.settings_page

<pre class="fmrb-sig"><code>settings_page() -&gt; <a href="../Integer/">Integer</a></code></pre>

The settings page asked for

The native program only. The page in the low two bits (0 Wi-Fi, 1
Bluetooth, 2 Display), the
count of the asks above them.
```ruby
n = FmrbSystem.settings_page
page = n & 3
# 0 Wi-Fi, 1 Bluetooth, 2 Display
```

### FmrbSystem.crt_set

<pre class="fmrb-sig"><code>crt_set(
  bool crt,
  <a href="../Integer/">Integer</a> scanline,
  <a href="../Integer/">Integer</a> mask,
  <a href="../Integer/">Integer</a> glow,
  <a href="../Integer/">Integer</a> curve,
  <a href="../Integer/">Integer</a> vignette,
  <a href="../Integer/">Integer</a> ntsc,
  <a href="../Integer/">Integer</a> flicker,
  <a href="../Integer/">Integer</a> noise
) -&gt; bool</code></pre>

Set the CRT look (native only)

crt and eight strengths (scanline, mask, glow, curve, vignette, ntsc,
flicker, noise); false where it cannot be drawn.
```ruby
FmrbSystem.crt_set(true, 55, 30,
  30, 15, 40, 0, 0, 0)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@095a863f.*
