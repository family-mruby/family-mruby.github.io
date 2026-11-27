# IOError

入出力や機器の口が使えない

継承元: [`StandardError`](StandardError.md)

閉じた `File` への読み書き、ほかのアプリが使っている・本体のピンなどで開けない
`UART`・`GPIO` など。
```ruby
begin
  u = UART.new(unit: 2, txd_pin: 47)
rescue IOError => e
  Log.info(e.message)
end
```

---

*このページは fmruby-core の develop@41060d05 の API の型定義 (`sig/`) から自動で作っています。*
