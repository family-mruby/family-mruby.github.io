# FmrbMic

The C-side entry to the microphone

How to use it: [Sound](../audio.md).

Apps normally use the mic_* methods of FmrbAudio.

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

*Generated from the API signatures (`sig/`) of fmruby-core develop@32b44bcd.*
