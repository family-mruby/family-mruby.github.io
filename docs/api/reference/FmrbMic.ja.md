# FmrbMic

マイクの C 側の窓口。アプリは ふつう FmrbAudio の mic_* を使う。

使い方は [音声](../audio.md) のページにあります。

## クラスメソッド

### FmrbMic.available?

<pre class="fmrb-sig"><code>available?() -&gt; bool</code></pre>

マイクがあるか

`FmrbAudio` を作る前に調べるとき用で、`FmrbAudio#mic_available?` と同じ。
```ruby
unless FmrbMic.available?
  @error = "no microphone"
end
```

---

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
