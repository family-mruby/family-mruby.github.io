# IOError

An I/O stream or a device port cannot be used

Inherits from: [`StandardError`](StandardError.md)

Reading or writing a closed `File`; a `UART` or `GPIO` that cannot be opened (another
app has it, a system pin ...).
```ruby
begin
  u = UART.new(unit: 2, txd_pin: 47)
rescue IOError => e
  Log.info(e.message)
end
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
