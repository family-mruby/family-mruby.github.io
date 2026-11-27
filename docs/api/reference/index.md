# Class reference

Every class an app can use, with every method, constant and example the API signatures carry. The pages are generated; the guides by topic are under [API Reference](../index.md).

## Application

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`FmrbApp`](FmrbApp.md)</span> | The base of every app; inherit from it | 139 |
| <span class="fmrb-name">[`FmrbAssoc`](FmrbAssoc.md)</span> | Which app opens which file | 5 |
| <span class="fmrb-name">[`FmrbColors`](FmrbColors.md)</span> | The colour-name table, and /home/colors.toml | 11 |
| <span class="fmrb-name">[`FmrbConst`](FmrbConst.md)</span> | Constants: machine, build, keys, theme | 1 |
| <span class="fmrb-name">[`FmrbI18n`](FmrbI18n.md)</span> | Switch the display between Japanese and English | 8 |
| <span class="fmrb-name">[`FmrbReceiveConf`](FmrbReceiveConf.md)</span> | Read and write the receive settings | 19 |
| <span class="fmrb-name">[`FmrbSystem`](FmrbSystem.md)</span> | The machine's settings and services | 40 |
| <span class="fmrb-name">[`FmrbToml`](FmrbToml.md)</span> | Read TOML; rewrite it by line | 7 |
| <span class="fmrb-name">[`FmrbToml::Raw`](FmrbToml__Raw.md)</span> | Holds a value to write unquoted | 2 |
| <span class="fmrb-name">[`Log`](Log.md)</span> | The log (goes to the serial port and the sim's terminal) | 8 |
| <span class="fmrb-name">[`Unit8Encoder`](Unit8Encoder.md)</span> | 8 encoders, 8 buttons, 9 LEDs | 12 |

## Drawing

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`BMP332`](BMP332.md)</span> | RGB332 pictures (8-bit BMP and palette PNG) | 7 |
| <span class="fmrb-name">[`Fmrb::Raycast`](Fmrb__Raycast.md)</span> | Ray casting over a grid map | 14 |
| <span class="fmrb-name">[`FmrbGfx`](FmrbGfx.md)</span> | A canvas: shapes, text, images, sprites | 93 |
| <span class="fmrb-name">[`FmrbHitMask`](FmrbHitMask.md)</span> | The hit shape of a frameless window, per pixel | 7 |
| <span class="fmrb-name">[`FmrbText`](FmrbText.md)</span> | Fit and wrap a text in pixels | 3 |
| <span class="fmrb-name">[`FmrbUI`](FmrbUI.md)</span> | Widget container | 30 |
| <span class="fmrb-name">[`FmrbUI::Button`](FmrbUI__Button.md)</span> | A push button | 1 |
| <span class="fmrb-name">[`FmrbUI::Enum`](FmrbUI__Enum.md)</span> | A choice picker | 1 |
| <span class="fmrb-name">[`FmrbUI::HitAreas`](FmrbUI__HitAreas.md)</span> | Click targets of a screen redrawn every time | 5 |
| <span class="fmrb-name">[`FmrbUI::Label`](FmrbUI__Label.md)</span> | A text-only widget | 1 |
| <span class="fmrb-name">[`FmrbUI::Scrollbar`](FmrbUI__Scrollbar.md)</span> | A vertical scrollbar | 7 |
| <span class="fmrb-name">[`FmrbUI::Stepper`](FmrbUI__Stepper.md)</span> | A value stepper | 8 |
| <span class="fmrb-name">[`FmrbUI::TextField`](FmrbUI__TextField.md)</span> | A one-line text field | 3 |
| <span class="fmrb-name">[`FmrbUI::Toggle`](FmrbUI__Toggle.md)</span> | An on/off toggle | 5 |
| <span class="fmrb-name">[`FmrbUI::Widget`](FmrbUI__Widget.md)</span> | What every widget has | 13 |
| <span class="fmrb-name">[`FmrbVideo`](FmrbVideo.md)</span> | A handle on the video being played | 9 |
| <span class="fmrb-name">[`GfxBlock`](GfxBlock.md)</span> | A draft for drawing the same shape over and over | 4 |
| <span class="fmrb-name">[`P5`](P5.md)</span> | Draw in the style of p5.js | 43 |
| <span class="fmrb-name">[`SpriteImage`](SpriteImage.md)</span> | The picture data of a sprite | 10 |
| <span class="fmrb-name">[`SpriteInstance`](SpriteInstance.md)</span> | One sprite placed on the screen | 11 |
| <span class="fmrb-name">[`TileMap`](TileMap.md)</span> | The map itself | 17 |
| <span class="fmrb-name">[`TileRing`](TileRing.md)</span> | Redraws only what is in view | 4 |
| <span class="fmrb-name">[`TileSheet`](TileSheet.md)</span> | One picture with tiles laid side by side | 8 |

## Sound

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Fmrb`](Fmrb.md)</span> | The Fmrb namespace (Fft, Raycast) | 0 |
| <span class="fmrb-name">[`Fmrb::Fft`](Fmrb__Fft.md)</span> | Compute the spectrum of a sound | 14 |
| <span class="fmrb-name">[`FmrbAudio`](FmrbAudio.md)</span> | Play sound: songs, effects, WAV, microphone | 21 |
| <span class="fmrb-name">[`FmrbMic`](FmrbMic.md)</span> | The C-side entry to the microphone | 1 |
| <span class="fmrb-name">[`FmrbMidi`](FmrbMidi.md)</span> | MIDI entry point: devices, songs, MML | 11 |
| <span class="fmrb-name">[`FmrbMidi::ApuTransport`](FmrbMidi__ApuTransport.md)</span> | Sends MIDI to the built-in sound chip (APU) | 8 |
| <span class="fmrb-name">[`FmrbMidi::MmlPlayer`](FmrbMidi__MmlPlayer.md)</span> | Plays a song written in MML | 29 |
| <span class="fmrb-name">[`FmrbMidi::SmfPlayer`](FmrbMidi__SmfPlayer.md)</span> | Plays a song file (SMF) | 37 |
| <span class="fmrb-name">[`MIDI`](MIDI.md)</span> | The MIDI namespace; the sender is MIDI::Device | 0 |
| <span class="fmrb-name">[`MIDI::Device`](MIDI__Device.md)</span> | A sender for sound; send notes and tones to it | 24 |
| <span class="fmrb-name">[`NsfHeader`](NsfHeader.md)</span> | Read the title of an NSF song file | 6 |

## Files and time

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Dir`](Dir.md)</span> | List and operate on directories | 24 |
| <span class="fmrb-name">[`File`](File.md)</span> | Reading and writing files (File) | 20 |
| <span class="fmrb-name">[`FmrbFile`](FmrbFile.md)</span> | Read and write whole files by path | 12 |
| <span class="fmrb-name">[`IO`](IO.md)</span> | An input/output stream | 7 |
| <span class="fmrb-name">[`Time`](Time.md)</span> | Date and time | 52 |

## Data

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Digest`](Digest.md)</span> | Container for hashes (SHA-256) | 0 |
| <span class="fmrb-name">[`Digest::SHA256`](Digest__SHA256.md)</span> | Compute SHA-256 | 6 |
| <span class="fmrb-name">[`JSON`](JSON.md)</span> | Reading and writing JSON | 2 |
| <span class="fmrb-name">[`JSON::Digger`](JSON__Digger.md)</span> | Take a part out of a big JSON | 3 |
| <span class="fmrb-name">[`JSON::DiggerError`](JSON__DiggerError.md)</span> | Raised by JSON::Digger | 0 |
| <span class="fmrb-name">[`JSON::GeneratorError`](JSON__GeneratorError.md)</span> | JSON.generate error (NaN, infinity) | 0 |
| <span class="fmrb-name">[`JSON::JSONError`](JSON__JSONError.md)</span> | Parent of the JSON errors | 0 |
| <span class="fmrb-name">[`JSON::ParserError`](JSON__ParserError.md)</span> | Raised when JSON.parse cannot read | 0 |
| <span class="fmrb-name">[`MessagePack`](MessagePack.md)</span> | Turn values into bytes with MessagePack, and back | 4 |

## Network

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Asterism`](Asterism.md)</span> | The Asterism gem; apps use it through conn | 6 |
| <span class="fmrb-name">[`Asterism::AsyncProxy`](Asterism__AsyncProxy.md)</span> | The no-wait form of a proxy | 1 |
| <span class="fmrb-name">[`Asterism::Connection`](Asterism__Connection.md)</span> | One app's connection to the network | 42 |
| <span class="fmrb-name">[`Asterism::Credentials`](Asterism__Credentials.md)</span> | The credentials .tar a console hands out | 12 |
| <span class="fmrb-name">[`Asterism::Credentials::Error`](Asterism__Credentials__Error.md)</span> | The file is missing something or holds it wrong | 0 |
| <span class="fmrb-name">[`Asterism::CurrentCall`](Asterism__CurrentCall.md)</span> | The call being answered now | 4 |
| <span class="fmrb-name">[`Asterism::Disconnected`](Asterism__Disconnected.md)</span> | Not connected, or the link dropped | 0 |
| <span class="fmrb-name">[`Asterism::EncodeError`](Asterism__EncodeError.md)</span> | A value that cannot be sent was sent | 0 |
| <span class="fmrb-name">[`Asterism::Error`](Asterism__Error.md)</span> | Parent of every Asterism failure | 1 |
| <span class="fmrb-name">[`Asterism::Future`](Asterism__Future.md)</span> | The answer of a no-wait call | 7 |
| <span class="fmrb-name">[`Asterism::Profile`](Asterism__Profile.md)</span> | A node's profile: kind, name, host, icon | 2 |
| <span class="fmrb-name">[`Asterism::Proxy`](Asterism__Proxy.md)</span> | Stand-in for an object on another machine | 7 |
| <span class="fmrb-name">[`Asterism::Pubs`](Asterism__Pubs.md)</span> | Rules for the topic declarations (@pubs) | 7 |
| <span class="fmrb-name">[`Asterism::ROS`](Asterism__ROS.md)</span> | Act as a ROS 2 node | 4 |
| <span class="fmrb-name">[`Asterism::ROS::Attachment`](Asterism__ROS__Attachment.md)</span> | The attachment of a sample: sequence, time, publisher GID | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Call`](Asterism__ROS__Call.md)</span> | A service call on its way | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Client`](Asterism__ROS__Client.md)</span> | A service client (from node.client) | 10 |
| <span class="fmrb-name">[`Asterism::ROS::Message`](Asterism__ROS__Message.md)</span> | The base of the generated message types | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Node`](Asterism__ROS__Node.md)</span> | A ROS 2 node over a Zenoh session | 18 |
| <span class="fmrb-name">[`Asterism::ROS::Publisher`](Asterism__ROS__Publisher.md)</span> | A topic's publisher (from node.publisher) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Service`](Asterism__ROS__Service.md)</span> | A served service (from node.service) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Subscription`](Asterism__ROS__Subscription.md)</span> | A topic's subscription | 11 |
| <span class="fmrb-name">[`Asterism::ROS::TimeoutError`](Asterism__ROS__TimeoutError.md)</span> | A service call got no answer in time (or nobody serves it) | 0 |
| <span class="fmrb-name">[`Asterism::ROS::Timer`](Asterism__ROS__Timer.md)</span> | A repeating timer (from node.every) | 4 |
| <span class="fmrb-name">[`Asterism::ROS::UnknownType`](Asterism__ROS__UnknownType.md)</span> | The type has no generated file in TYPE_PATH | 0 |
| <span class="fmrb-name">[`Asterism::RemoteError`](Asterism__RemoteError.md)</span> | Remote method failed or raised | 4 |
| <span class="fmrb-name">[`Asterism::SampleInfo`](Asterism__SampleInfo.md)</span> | Information that comes with a received value | 15 |
| <span class="fmrb-name">[`Asterism::Sequences`](Asterism__Sequences.md)</span> | A reader's memory of the sequence numbers | 5 |
| <span class="fmrb-name">[`Asterism::SharedSession`](Asterism__SharedSession.md)</span> | Extended onto each connection's session | 1 |
| <span class="fmrb-name">[`Asterism::Status`](Asterism__Status.md)</span> | Rules for an app's status | 2 |
| <span class="fmrb-name">[`Asterism::Subscription`](Asterism__Subscription.md)</span> | A topic being subscribed to | 7 |
| <span class="fmrb-name">[`Asterism::TimeoutError`](Asterism__TimeoutError.md)</span> | No answer came in time | 0 |
| <span class="fmrb-name">[`Asterism::Topic`](Asterism__Topic.md)</span> | A topic being published | 12 |
| <span class="fmrb-name">[`Asterism::Types`](Asterism__Types.md)</span> | Names and numbers of the built-in value types | 2 |
| <span class="fmrb-name">[`FmrbAsterism`](FmrbAsterism.md)</span> | Settings and the link to other machines | 12 |
| <span class="fmrb-name">[`FmrbAsterism::Link`](FmrbAsterism__Link.md)</span> | Keeps the app connected (connect, retry, close) | 15 |
| <span class="fmrb-name">[`FmrbAsterism::Settings`](FmrbAsterism__Settings.md)</span> | Connection settings | 6 |
| <span class="fmrb-name">[`FmrbAsterism::TableClient`](FmrbAsterism__TableClient.md)</span> | The device side of a game host's table | 37 |
| <span class="fmrb-name">[`FmrbNet`](FmrbNet.md)</span> | Read the network state; fetch | 6 |
| <span class="fmrb-name">[`FmrbNet::Request`](FmrbNet__Request.md)</span> | One fetch (what FmrbNet.request returns) | 7 |

## Machine and devices

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`FmrbHw`](FmrbHw.md)</span> | Read the table of how pins are used | 4 |
| <span class="fmrb-name">[`FmrbUart`](FmrbUart.md)</span> | The app boundary's UART functions | 15 |
| <span class="fmrb-name">[`GC`](GC.md)</span> | Control and statistics of the garbage collector | 20 |
| <span class="fmrb-name">[`GPIO`](GPIO.md)</span> | Use one pin as input or output | 16 |
| <span class="fmrb-name">[`GPIO::Error`](GPIO__Error.md)</span> | Peripheral error codes and their exceptions | 1 |
| <span class="fmrb-name">[`I2C`](I2C.md)</span> | Talk to I2C devices | 5 |
| <span class="fmrb-name">[`Machine`](Machine.md)</span> | Time, waiting, and telling platforms apart | 24 |
| <span class="fmrb-name">[`Math`](Math.md)</span> | Trigonometric, exponential and logarithmic functions | 26 |
| <span class="fmrb-name">[`Math::DomainError`](Math__DomainError.md)</span> | Raised for an argument outside the domain | 0 |
| <span class="fmrb-name">[`RNG`](RNG.md)</span> | The source of random numbers | 3 |
| <span class="fmrb-name">[`UART`](UART.md)</span> | Talk to a device over a serial line (UART) | 22 |

## Ruby core

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`ArgumentError`](ArgumentError.md)</span> | Wrong number or value of arguments | 0 |
| <span class="fmrb-name">[`Array`](Array.md)</span> | An ordered list of elements | 37 |
| <span class="fmrb-name">[`Class`](Class.md)</span> | A class itself; read its name | 1 |
| <span class="fmrb-name">[`Enumerable`](Enumerable.md)</span> | Iteration helpers for anything with each | 4 |
| <span class="fmrb-name">[`Exception`](Exception.md)</span> | The base class of every exception | 5 |
| <span class="fmrb-name">[`FalseClass`](FalseClass.md)</span> | The type of false | 0 |
| <span class="fmrb-name">[`Float`](Float.md)</span> | A floating-point number | 20 |
| <span class="fmrb-name">[`FrozenError`](FrozenError.md)</span> | Changing a frozen object | 0 |
| <span class="fmrb-name">[`Hash`](Hash.md)</span> | A table that maps keys to values | 20 |
| <span class="fmrb-name">[`IOError`](IOError.md)</span> | An I/O stream or a device port cannot be used | 0 |
| <span class="fmrb-name">[`IndexError`](IndexError.md)</span> | An index out of range | 0 |
| <span class="fmrb-name">[`Integer`](Integer.md)</span> | An integer | 29 |
| <span class="fmrb-name">[`Kernel`](Kernel.md)</span> | Output, random numbers, Proc helpers | 12 |
| <span class="fmrb-name">[`KeyError`](KeyError.md)</span> | A missing key (Hash#fetch) | 0 |
| <span class="fmrb-name">[`Module`](Module.md)</span> | Operations on classes and modules | 2 |
| <span class="fmrb-name">[`NameError`](NameError.md)</span> | An unknown constant or variable | 0 |
| <span class="fmrb-name">[`NilClass`](NilClass.md)</span> | The type of nil, meaning no value | 11 |
| <span class="fmrb-name">[`NoMemoryError`](NoMemoryError.md)</span> | Out of memory | 0 |
| <span class="fmrb-name">[`NoMethodError`](NoMethodError.md)</span> | A call of a method that does not exist | 0 |
| <span class="fmrb-name">[`NotImplementedError`](NotImplementedError.md)</span> | Not available on this device or build | 0 |
| <span class="fmrb-name">[`Object`](Object.md)</span> | A copy for calls with Object as the receiver | 29 |
| <span class="fmrb-name">[`Proc`](Proc.md)</span> | A block held as a value | 2 |
| <span class="fmrb-name">[`Range`](Range.md)</span> | A range such as 1..3 or 1...3 | 9 |
| <span class="fmrb-name">[`RangeError`](RangeError.md)</span> | A number out of range | 0 |
| <span class="fmrb-name">[`RuntimeError`](RuntimeError.md)</span> | What raise makes when no class is given | 0 |
| <span class="fmrb-name">[`ScriptError`](ScriptError.md)</span> | Program errors | 0 |
| <span class="fmrb-name">[`StandardError`](StandardError.md)</span> | Ordinary errors (what a bare rescue catches) | 0 |
| <span class="fmrb-name">[`StopIteration`](StopIteration.md)</span> | The end of an iteration | 0 |
| <span class="fmrb-name">[`String`](String.md)</span> | A string (UTF-8) | 57 |
| <span class="fmrb-name">[`Symbol`](Symbol.md)</span> | A Symbol such as :name | 5 |
| <span class="fmrb-name">[`SystemStackError`](SystemStackError.md)</span> | Calls nested too deep | 0 |
| <span class="fmrb-name">[`TrueClass`](TrueClass.md)</span> | The type of true | 0 |
| <span class="fmrb-name">[`TypeError`](TypeError.md)</span> | A value of the wrong type | 0 |
| <span class="fmrb-name">[`ZeroDivisionError`](ZeroDivisionError.md)</span> | Integer division by zero | 0 |

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@41060d05.*
