# Pub/Sub

!!! note
    This page is under construction.

A Publish / Subscribe mechanism for exchanging messages between applications. Provided as instance methods of `FmrbApp`.

## Methods

| Method | Purpose |
|---|---|
| `subscribe(topic)` | Start subscribing to a topic |
| `unsubscribe(topic)` | Unsubscribe |
| `publish(topic, data = nil)` | Send a message to a topic. `data` can be `Hash` / `Array` / number / `String` / `nil` |
| `send_message(dest_pid, msg_type, data)` | Direct message to the kernel or a specific process (low-level) |

`data` is automatically serialized to MessagePack internally (maximum 176 bytes).

## Receive Handler

Topic messages are received in `on_control(msg)`, not `on_event(ev)`.

```ruby
def on_control(msg)
  if msg["cmd"] == "topic_data" && msg["topic"] == "demo"
    payload = msg["data"]   # The content passed by the sender to publish
    # ...
  end
end
```

| `msg` Key | Description |
|---|---|
| `"cmd"` | `"topic_data"` (when receiving a publish on a subscribed topic) |
| `"topic"` | Topic name |
| `"data"` | Payload passed by the publisher (Hash, etc.) |

!!! note
    `subscribe`, `publish`, `unsubscribe`, and `send_message` are syntactic sugar that send commands to the kernel via `send_message(PROC_ID_KERNEL, MSG_TYPE_APP_CONTROL, ...)`. `on_control` is the entry point for all app control messages from the kernel, and Pub/Sub messages are routed through it.

## Examples

### Publisher

```ruby
class PubDemo < FmrbApp
  TOPIC = "demo"

  def on_create
    @count = 0
    redraw
  end

  def on_event(ev)
    super
    if ev[:type] == :mouse_up && ev[:button] == 1
      @count += 1
      publish(TOPIC, {"msg" => "hello", "n" => @count})
      redraw
    end
  end

  def on_update; 100; end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Sent: #{@count}", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

PubDemo.new.start
```

### Subscriber

```ruby
class SubDemo < FmrbApp
  TOPIC = "demo"

  def on_create
    @last = ""
    subscribe(TOPIC)
    redraw
  end

  def on_control(msg)
    if msg["cmd"] == "topic_data" && msg["topic"] == TOPIC
      data = msg["data"]
      @last = "n=#{data["n"]} msg=#{data["msg"]}"
      redraw
    end
  end

  def on_destroy
    unsubscribe(TOPIC)
  end

  def on_update; 100; end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4, @last, FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

SubDemo.new.start
```

`/app/demo/pub_demo.app.rb` and `sub_demo.app.rb` are a matching pair of samples that demonstrate this behavior.

## Topic Design

Topic names are arbitrary strings. They work as long as the communicating apps agree on them. There are currently no widely-used reserved names in the project.

Recommended naming conventions:

- Lowercase alphanumeric characters and underscores (e.g. `"sensor_light"`)
- Prefix app-specific messages with `"<myapp>_<event>"`
- Document any public topics shared across multiple apps

## Limitations

| Item | Value |
|---|---|
| Maximum payload size | 176 bytes (after MessagePack serialization) |
| Types accepted for `data` | `Hash`, `Array`, `Integer`, `Float`, `String`, `Boolean`, `nil` |
| Send timeout | 5 seconds (kernel internal) |

To send data larger than 176 bytes, write it to a file and `publish` only the file path, or split the data into multiple messages.

## Difference from HID Events

Keyboard / mouse / gamepad input is delivered directly to `on_event(ev)` (routed by the kernel via `MSG_TYPE_HID_EVENT`). Do not confuse this with Pub/Sub.

| Mechanism | Receive Handler | Use Case |
|---|---|---|
| HID Input | `on_event(ev)` | Physical user input |
| Pub/Sub | `on_control(msg)` | Arbitrary inter-app messages |
| Direct send | `on_control(msg)` | General kernel control messages |

## Direct Sending (`send_message`)

A low-level API for sending messages to the kernel or a specific app. `subscribe` and related methods are built on top of this.

```ruby
send_message(FmrbConst::PROC_ID_KERNEL,
             FmrbConst::MSG_TYPE_APP_CONTROL,
             {"cmd" => "subscribe", "topic" => "foo"})
```

- `dest_pid`: Destination process ID (`FmrbConst::PROC_ID_*`)
- `msg_type`: Message type (`MSG_TYPE_APP_CONTROL`, etc.)
- `data`: Any Ruby object (automatically serialized via MessagePack)
