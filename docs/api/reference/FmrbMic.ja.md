# FmrbMic

マイクの C 側の窓口

使い方は [音声](../audio.md) のページにあります。

アプリは ふつう FmrbAudio の mic_* を使う。

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

*このページは fmruby-core の develop@095a863f の API の型定義 (`sig/`) から自動で作っています。*
