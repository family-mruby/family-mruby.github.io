# FmrbMic

マイクの C 側の窓口。アプリは ふつう FmrbAudio の mic_* を使う。

How to use it: [Sound](../audio.md).

## Class methods

### FmrbMic.available?

<pre class="fmrb-sig"><code>available?() -&gt; bool</code></pre>

Whether this machine has a microphone

For asking before an `FmrbAudio` exists; the same as
`FmrbAudio#mic_available?`.
```ruby
unless FmrbMic.available?
  @error = "no microphone"
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
