# Network (Net::HTTP / WebSocket / TLS)

New in 2.0. Apps can talk to the internet with the API you already know from CRuby:
`Net::HTTP`, WebSocket, and TLS underneath both.

Available on both machines — Modern reaches the network through the ESP32-C6, Retro
through the ESP32-S3's own radio — and in the Linux simulator, which uses the host's
network and OpenSSL.

## Before you start

The device needs Wi-Fi credentials in `/etc/wifi.toml`. See
[Connecting to Wi-Fi](../getting_started/wifi.md) for how to write that file on the device.

!!! note "Retro runs one radio at a time"
    The ESP32-S3 has a single radio, so Wi-Fi and BLE cannot both be up. If the BLE web
    console is running, Wi-Fi will not start; set `ble_auto_start` to false in Config
    and reboot. On Modern the ESP32-C6 handles both at once and there is no conflict.

## Checking the connection

```ruby
if FmrbApp.wifi_connected?
  info = FmrbApp.wifi_info
  # => { connected: true, ip: "192.168.10.16", ssid: "my-ap", hostname: "fmruby" }
  Log.info("address: #{info[:ip]}")
end
```

| Method | Returns |
|---|---|
| `FmrbApp.wifi_connected?` | `true` / `false`. Allocates nothing, so it is safe to call in a loop |
| `FmrbApp.wifi_info` | A Hash with `:connected`, `:ip`, `:ssid`, `:hostname`, or `nil` on a machine with no Wi-Fi |

An app that needs the network should wait for it rather than assume it, because Wi-Fi comes
up after the desktop does:

```ruby
def on_create
  @ready = false
end

def on_update
  unless @ready
    return unless FmrbApp.wifi_connected?
    @ready = true
    fetch_data
  end
end
```

## HTTP

```ruby
require 'net/http'
require 'json'

# One-shot GET
body = Net::HTTP.get(URI.parse("http://example.com/api/status"))

# With the response object
res = Net::HTTP.get_response(URI.parse("https://example.com/data.json"))
if res.code == "200"
  data = ::JSON.parse(res.body)
end

# Form POST
res = Net::HTTP.post_form(URI.parse("https://example.com/post"), { "key" => "value" })

# Reusing a session
http = Net::HTTP.new("example.com", 443)
http.use_ssl = true
http.start do |h|
  res = h.get("/index.html")
  res = h.post("/api", '{"a":1}', { "Content-Type" => "application/json" })
end
```

HTTPS works out of the box: certificates are verified against the bundled CA set, so a
plain `https://` URL needs no extra setup.

!!! warning "Write `::JSON`, not `JSON`"
    Inside a class body, a bare constant like `JSON` is looked up as
    `YourClass::JSON` and fails. Prefix it with `::`.

## WebSocket

```ruby
require 'net/websocket'

Net::WebSocket::Client.connect("wss://echo.example.com/ws") do |ws|
  ws.send_text("hello")
  msg = ws.receive(timeout: 5)
  ws.close
end
```

`receive` polls rather than blocking outright, so it will not freeze the VM for the whole
timeout.

## Differences from CRuby

The API is shaped like CRuby's, but this is a microcontroller. The limits that actually
bite:

| | |
|---|---|
| **TLS version** | TLS 1.2 only. There is no TLS 1.3 |
| **Blocking** | The calls are synchronous. While a request is in flight, that app processes no events — its window will not repaint and its input is queued. Keep requests short, and set timeouts |
| **Response size** | The whole body lands in your app's memory pool (512 KB or 1 MB depending on the slot). A large download will exhaust it |
| **HTTP features** | Chunked transfer, redirects and keep-alive are handled to the extent picoruby's `net/http` implements them, not to the extent CRuby does |
| **Certificates** | Custom CA or client certificates are passed as PEM strings, not file paths |

Because a request stalls the app that makes it, the usual shape is: fetch once at startup or
on a timer, keep the result, and draw from the copy.

## A worked example

The bundled Weather app (`/app/demo/weather.app.rb`) fetches a forecast over HTTPS from
Open-Meteo, parses the JSON and draws it. It waits for the network, retries until the first
success, and is a good starting point to copy.

The Net Test app (`/app/tool/net_test.app.rb`) exercises the API piece by piece and is
useful when something does not work.

## Related

- [Connecting to Wi-Fi](../getting_started/wifi.md)
- [Remote Desktop](../remote_desktop.md) — the other thing Wi-Fi gets you
- [Constants & System Info](const.md) — `FmrbConst::HAS_WIFI`
