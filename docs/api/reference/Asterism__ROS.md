# Asterism::ROS

Act as a ROS 2 node

How to use it: [Network](../network.md).

A bridge to ROS 2 (Jazzy, rmw_zenoh): make a node that publishes and
subscribes to topics and calls and serves services. It assumes the ROS 2
side shares the Zenoh router (zenohd) and uses rmw_zenoh.
**Build it on a Link's conn.session**
(`Asterism::ROS::Node.new(conn.session, "name")`). Like Asterism::Connection,
**nothing runs behind your back**: call Node#poll in every update.

Message types are files made from ROS 2 .msg / .srv files (the output
of tools/asterism_msggen.rb); /usr/share/asterism/msgs on the machine
holds std_msgs, geometry_msgs, sensor_msgs, nav_msgs and more. Give
`Asterism::ROS.require_type("std_msgs/msg/String")` or the type's name
(a String) to the methods and it is loaded. Messages travel as CDR. A
big message (an image, a point cloud) uses the machine's memory.
```ruby
node = Asterism::ROS::Node.new(
  @link.conn.session, "fmrb_node")
pub = node.publisher("/chatter",
  "std_msgs/msg/String")
pub << { data: "hi" }
```

## Constants

| Name | Type | What it is |
|---|---|---|
| <span class="fmrb-name">`DEFAULT_QOS`</span> | [`String`](String.md) | The default QoS |
| <span class="fmrb-name">`TYPE_PATH`</span> | `Array[String]` | Where require_type looks for generated types |

## Class methods

### Asterism::ROS.require_type

<pre class="fmrb-sig"><code>require_type(<a href="../String/">String</a> name) -&gt; untyped</code></pre>

Load a message or service type by its ROS name

Looks "geometry_msgs/msg/Twist" or "example_interfaces/srv/AddTwoInts"
up in TYPE_PATH, loads it and returns the type (a class, or for a
service a module). A type already loaded is not read again. The name
is `package/msg|srv/Name`: ArgumentError for another shape,
Asterism::ROS::UnknownType when there is no file.
```ruby
twist = Asterism::ROS.require_type(
  "geometry_msgs/msg/Twist")
```

### Asterism::ROS.type_path

<pre class="fmrb-sig"><code>type_path() -&gt; <a href="../Array/">Array</a>[<a href="../String/">String</a>]</code></pre>

The directories require_type searches

It returns the Array itself, so you can add a directory with `<<`.
```ruby
Asterism::ROS.type_path << "/home/msgs"
```

### Asterism::ROS.field_types

<pre class="fmrb-sig"><code>field_types(untyped type) -&gt; <a href="../Hash/">Hash</a></code></pre>

The fields of a type and of the types it is made of

Returns `{ROS name => field table}`, the type first, each type once.
A field is `[name, base, kind, nested, capacity, string_capacity]`.
For a service, its Request and Response. The type is the type itself
or its ROS name. Raises Asterism::ROS::UnknownType for a type
without a field table (written by hand, or generated long ago).
```ruby
t = Asterism::ROS.field_types(
  "std_msgs/msg/Header")
```

### Asterism::ROS.resolve

<pre class="fmrb-sig"><code>resolve(<a href="../String/">String</a> topic, <a href="../String/">String</a> namespace) -&gt; <a href="../String/">String</a></code></pre>

A full topic name from a name and a namespace

An absolute name stays; a relative one goes under the namespace. An
empty name raises ArgumentError. "~" and substitutions are not
supported.
```ruby
Asterism::ROS.resolve("chatter", "/a")
#=> "/a/chatter"
```

---

*Generated from the API signatures (`sig/`) of fmruby-core main@579eba38.*
