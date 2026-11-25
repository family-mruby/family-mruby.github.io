# Asterism::ROS::Node

A ROS 2 node over a Zenoh session

How to use it: [Network](../network.md).

Topics, services and timers hang off this node; closing it ends all of
them. Receiving and answering (the subscribe, every and service
blocks) run **inside Node#poll**. Do not wait in a block (a service
call or a call to another machine would stall the update): start a
call_async and look at done? later.
```ruby
node = Asterism::ROS::Node.new(
  @link.conn.session, "fmrb_node")
```

## Class methods

### Asterism::ROS::Node.new

<pre class="fmrb-sig"><code>new(
  untyped session,
  <a href="../String/">String</a> | <a href="../Symbol/">Symbol</a> name,
  ?namespace: <a href="../String/">String</a>,
  ?domain: <a href="../Integer/">Integer</a>,
  ?enclave: <a href="../String/">String</a>
) -&gt; Asterism::ROS::Node</code></pre>

Make a node on a session (it shows in `ros2 node list`)

session is an open Zenoh session (`conn.session`). name is one name
(not empty, no "/"; otherwise ArgumentError). `namespace:` ("/"
when left out), `domain:` (0; ROS_DOMAIN_ID), `enclave:` ("/").
Declares the node's liveliness at once.
```ruby
node = Asterism::ROS::Node.new(
  conn.session, "fmrb_node",
  namespace: "/fmrb")
```

## Instance methods

### Asterism::ROS::Node#poll

<pre class="fmrb-sig"><code>poll(?<a href="../Integer/">Integer</a> steps) -&gt; bool</code></pre>

Poll: receive, answer, fire the timers

Polls the session, answers the service requests that came in, hands
the messages to the subscribe blocks and fires the timers that are
due. False once the session is closed, true otherwise. `steps` (8
when left out) is the most times it repeats the session's work (it stops
early when nothing is left).
```ruby
def on_update
  @node.poll
  100
end
```

### Asterism::ROS::Node#publisher

<pre class="fmrb-sig"><code>publisher(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>
) -&gt; <a href="../Asterism__ROS__Publisher/">Asterism::ROS::Publisher</a></code></pre>

Make a publisher for a topic

topic is the topic name ("/chatter"; a relative one goes under the
node's namespace), type is the type itself or its ROS name
("std_msgs/msg/String"). `qos:` (DEFAULT_QOS when left out).
Raises Asterism::ROS::UnknownType or ArgumentError for a type that
cannot be loaded.
```ruby
pub = node.publisher("/chatter",
  "std_msgs/msg/String")
```

### Asterism::ROS::Node#subscription

<pre class="fmrb-sig"><code>subscription(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a></code></pre>

Make a subscription you take messages from

Messages that arrive wait in it and you take them with
`each_pending`. `depth:` (16 when left out) is how many can wait,
`qos:` (DEFAULT_QOS). Use subscribe to get them in a block.
```ruby
sub = node.subscription("/cmd",
  "std_msgs/msg/String")
```

### Asterism::ROS::Node#subscribe

<pre class="fmrb-sig"><code>subscribe(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) { (<a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a> msg, <a href="../Asterism__ROS__Attachment/">Asterism::ROS::Attachment</a>? info) -&gt; untyped } -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a>

subscribe(
  <a href="../String/">String</a> topic,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) -&gt; <a href="../Asterism__ROS__Subscription/">Asterism::ROS::Subscription</a></code></pre>

Receive a topic in a block (from Node#poll)

|msg, info| is called **inside Node#poll** for every message (info is
an Asterism::ROS::Attachment, or nil). Do not wait in the block.
close the returned Subscription to stop. Without a block it is the
same as subscription.
```ruby
node.subscribe("/cmd",
  "std_msgs/msg/String") do |m, i|
  got(m.data)
end
```

### Asterism::ROS::Node#service

<pre class="fmrb-sig"><code>service(
  <a href="../String/">String</a> service,
  untyped type,
  ?qos: <a href="../String/">String</a>,
  ?depth: <a href="../Integer/">Integer</a>
) { (untyped request) -&gt; untyped } -&gt; <a href="../Asterism__ROS__Service/">Asterism::ROS::Service</a></code></pre>

Serve a service (the block answers requests)

For every request the block gets it (`type::Request`)
**inside Node#poll** and returns the answer (a `type::Response` or a Hash of
its fields). `depth:` (8 when left out), `qos:` (DEFAULT_QOS).
ArgumentError without a block. When the block raises, that request
goes unanswered and the exception comes out of poll.
```ruby
add = Asterism::ROS.require_type(
  "example_interfaces/srv/AddTwoInts")
node.service("/add", add) do |r|
  { sum: r.a + r.b }
end
```

### Asterism::ROS::Node#client

<pre class="fmrb-sig"><code>client(
  <a href="../String/">String</a> service,
  untyped type,
  ?qos: <a href="../String/">String</a>
) -&gt; <a href="../Asterism__ROS__Client/">Asterism::ROS::Client</a></code></pre>

Make a client for a service

Call it with Client#call (waits) or call_async (does not). `qos:`
(DEFAULT_QOS when left out). For occasional calls Node#call makes
and keeps a client.
```ruby
cli = node.client("/add", add)
```

### Asterism::ROS::Node#call

<pre class="fmrb-sig"><code>call(
  <a href="../String/">String</a> service,
  untyped type,
  ?untyped req,
  ?request: untyped,
  ?timeout: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?,
  ?timeout_ms: <a href="../Integer/">Integer</a>?,
  **untyped fields
) -&gt; <a href="../Asterism__ROS__Message/">Asterism::ROS::Message</a></code></pre>

Call a service once and wait for the response

`node.call("/add", add, a: 2, b: 3)`. Give the request as field
keywords, or a Hash or message positionally or as `request:`. The
time limit is `timeout:` (seconds) or `timeout_ms:` (2 s when left
out). It makes one client per service name and keeps it.
**The app waits for the answer**, still answering this node's services
meanwhile (the subscribe and every blocks do not run). Raises
Asterism::ROS::TimeoutError when nothing answers in time,
Asterism::Zenoh::ClosedError when the session is closed. If a field of
the request is named timeout or timeout_ms, give the request as
`request: { ... }`.
```ruby
r = node.call("/add", add,
  a: 2, b: 3)
puts r.sum
```

### Asterism::ROS::Node#every

<pre class="fmrb-sig"><code>every(
  ?(<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)? seconds,
  ?ms: (<a href="../Integer/">Integer</a> | <a href="../Float/">Float</a>)?
) { () -&gt; untyped } -&gt; <a href="../Asterism__ROS__Timer/">Asterism::ROS::Timer</a></code></pre>

Call a block every so often (from Node#poll)

`every(1.0) { ... }` (seconds) or `every(ms: 500) { ... }`. The first
call is one period from now. Runs **inside Node#poll**. After a long
stall it does not fire the missed times at once (it counts from now).
Do not wait in the block. Returns a Timer (cancel stops it).
ArgumentError without a block or a period, with both, or with one
that is not positive.
```ruby
t = node.every(1.0) do
  pub << { data: "tick" }
end
```

### Asterism::ROS::Node#close

<pre class="fmrb-sig"><code>close() -&gt; nil</code></pre>

Withdraw the node and everything made on it

Publishers, subscriptions, services, clients and timers end with it.
Safe to call twice. Returns nil.
```ruby
node.close
```

### Asterism::ROS::Node#closed?

<pre class="fmrb-sig"><code>closed?() -&gt; bool</code></pre>

Whether the node is closed

```ruby
return if node.closed?
```

### Asterism::ROS::Node#name

<pre class="fmrb-sig"><code>name() -&gt; <a href="../String/">String</a></code></pre>

The node's name

```ruby
n = node.name
```

### Asterism::ROS::Node#namespace

<pre class="fmrb-sig"><code>namespace() -&gt; <a href="../String/">String</a></code></pre>

The node's namespace ("/" by default)

```ruby
ns = node.namespace
```

### Asterism::ROS::Node#domain

<pre class="fmrb-sig"><code>domain() -&gt; <a href="../Integer/">Integer</a></code></pre>

The ROS domain id

```ruby
d = node.domain
```

### Asterism::ROS::Node#zid

<pre class="fmrb-sig"><code>zid() -&gt; <a href="../String/">String</a></code></pre>

The Zenoh ID of the session

```ruby
id = node.zid
```

### Asterism::ROS::Node#key

<pre class="fmrb-sig"><code>key() -&gt; <a href="../String/">String</a></code></pre>

The node's liveliness key

```ruby
k = node.key
```

### Asterism::ROS::Node#session

<pre class="fmrb-sig"><code>session() -&gt; untyped</code></pre>

The Zenoh session the node is on

```ruby
s = node.session
```

### Asterism::ROS::Node#cancel_timer

<pre class="fmrb-sig"><code>cancel_timer(<a href="../Asterism__ROS__Timer/">Asterism::ROS::Timer</a> timer) -&gt; nil</code></pre>

Stop a timer made by every

The same as Timer#cancel. Returns nil.
```ruby
node.cancel_timer(t)
```

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
