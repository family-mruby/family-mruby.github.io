# Class reference

!!! note "Made from the development version"
    These pages are generated from the API signatures on the development branch of fmruby-core (sig-s7@ea56c9e9), not from a release. A method listed here may be missing from, or work differently on, the firmware you have installed; the [release notes](../../releases.md) say what each release contains.

Every class an app can use, with every method, constant and example the API signatures carry. The pages are generated; the guides by topic are under [API Reference](../index.md).

## Application

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`FmrbApp`](FmrbApp.md)</span> |  | 138 |
| <span class="fmrb-name">[`FmrbAssoc`](FmrbAssoc.md)</span> | Which app opens which file | 5 |
| <span class="fmrb-name">[`FmrbColors`](FmrbColors.md)</span> | A table of colour names, and the per-app overrides in /home/colors.toml. | 11 |
| <span class="fmrb-name">[`FmrbConst`](FmrbConst.md)</span> | Constants for the machine, the build, keys and the theme. | 1 |
| <span class="fmrb-name">[`FmrbI18n`](FmrbI18n.md)</span> | 日本語と英語で表示を切りかえる。 | 8 |
| <span class="fmrb-name">[`FmrbReceiveConf`](FmrbReceiveConf.md)</span> | Reads and writes whether this machine receives files and apps, and from whom. | 16 |
| <span class="fmrb-name">[`FmrbSystem`](FmrbSystem.md)</span> | The machine's settings and services | 40 |
| <span class="fmrb-name">[`FmrbToml`](FmrbToml.md)</span> | Read a TOML settings file, or rewrite it line by line. | 7 |
| <span class="fmrb-name">[`FmrbToml::Raw`](FmrbToml__Raw.md)</span> | Holds a value to write unquoted | 2 |
| <span class="fmrb-name">[`Log`](Log.md)</span> | ログ (シリアルと sim の端末に出る)。 | 8 |
| <span class="fmrb-name">[`Unit8Encoder`](Unit8Encoder.md)</span> | A device with 8 rotary encoders, 8 buttons, 1 switch and 9 RGB LEDs. | 12 |

## Drawing

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`BMP332`](BMP332.md)</span> | RGB332 pictures (8-bit BMP and palette PNG) | 7 |
| <span class="fmrb-name">[`Fmrb::Raycast`](Fmrb__Raycast.md)</span> | Looks at a grid map by the distance to walls (Wolfenstein 3D style). | 14 |
| <span class="fmrb-name">[`FmrbGfx`](FmrbGfx.md)</span> |  | 93 |
| <span class="fmrb-name">[`FmrbHitMask`](FmrbHitMask.md)</span> | 枠なしの Window の当たりの形 (画素単位)。 | 7 |
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
| <span class="fmrb-name">[`FmrbVideo`](FmrbVideo.md)</span> | FmrbGfx#video_open が返す、流している動画の取っ手。 | 9 |
| <span class="fmrb-name">[`GfxBlock`](GfxBlock.md)</span> | 同じ形をくり返し描くときの下書き。 | 4 |
| <span class="fmrb-name">[`P5`](P5.md)</span> |  | 43 |
| <span class="fmrb-name">[`SpriteImage`](SpriteImage.md)</span> | うごく絵の中身。 | 10 |
| <span class="fmrb-name">[`SpriteInstance`](SpriteInstance.md)</span> | 画面に置いた一つのうごく絵。 | 11 |
| <span class="fmrb-name">[`TileMap`](TileMap.md)</span> | 地図そのもの。 | 17 |
| <span class="fmrb-name">[`TileRing`](TileRing.md)</span> | 見えている周りだけを描き直して、広い地図を軽く動かす仕組み。 | 4 |
| <span class="fmrb-name">[`TileSheet`](TileSheet.md)</span> | タイルの絵をならべた一枚の絵。 | 8 |

## Sound

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Fmrb`](Fmrb.md)</span> |  | 0 |
| <span class="fmrb-name">[`Fmrb::Fft`](Fmrb__Fft.md)</span> | Computes the spectrum of a sound. | 14 |
| <span class="fmrb-name">[`FmrbAudio`](FmrbAudio.md)</span> |  | 21 |
| <span class="fmrb-name">[`FmrbMic`](FmrbMic.md)</span> | マイクの C 側の窓口。 | 1 |
| <span class="fmrb-name">[`FmrbMidi`](FmrbMidi.md)</span> |  | 11 |
| <span class="fmrb-name">[`FmrbMidi::ApuTransport`](FmrbMidi__ApuTransport.md)</span> | 内蔵音源 (APU) へ MIDI を送る口。 | 8 |
| <span class="fmrb-name">[`FmrbMidi::MmlPlayer`](FmrbMidi__MmlPlayer.md)</span> | MML で書いた曲を鳴らす係。 | 29 |
| <span class="fmrb-name">[`FmrbMidi::SmfPlayer`](FmrbMidi__SmfPlayer.md)</span> | 曲のファイル (SMF) を鳴らす係。 | 37 |
| <span class="fmrb-name">[`MIDI`](MIDI.md)</span> |  | 0 |
| <span class="fmrb-name">[`MIDI::Device`](MIDI__Device.md)</span> | 音を出す口。 | 24 |
| <span class="fmrb-name">[`NsfHeader`](NsfHeader.md)</span> | NSF (ファミコンの曲) のファイルの題名などを読む。 | 6 |

## Files and time

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Dir`](Dir.md)</span> | Directory listing and operations. | 24 |
| <span class="fmrb-name">[`File`](File.md)</span> | ファイルの読み書き (File)。 | 20 |
| <span class="fmrb-name">[`FmrbFile`](FmrbFile.md)</span> |  | 11 |
| <span class="fmrb-name">[`IO`](IO.md)</span> | An input/output stream, the parent of File. | 7 |
| <span class="fmrb-name">[`Time`](Time.md)</span> | Date and time. | 52 |

## Data

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Digest`](Digest.md)</span> | ハッシュの入れもの。 | 0 |
| <span class="fmrb-name">[`Digest::SHA256`](Digest__SHA256.md)</span> | Compute SHA-256 | 6 |
| <span class="fmrb-name">[`JSON`](JSON.md)</span> | Reading and writing JSON. | 2 |
| <span class="fmrb-name">[`JSON::Digger`](JSON__Digger.md)</span> | Take a part out of a big JSON | 3 |
| <span class="fmrb-name">[`JSON::DiggerError`](JSON__DiggerError.md)</span> | Raised by JSON::Digger | 0 |
| <span class="fmrb-name">[`JSON::GeneratorError`](JSON__GeneratorError.md)</span> | JSON.generate error (never raised) | 0 |
| <span class="fmrb-name">[`JSON::JSONError`](JSON__JSONError.md)</span> | Parent of the JSON errors | 0 |
| <span class="fmrb-name">[`JSON::ParserError`](JSON__ParserError.md)</span> | Raised when JSON.parse cannot read | 0 |
| <span class="fmrb-name">[`MessagePack`](MessagePack.md)</span> | Turns values into bytes with MessagePack and back. | 4 |

## Network

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Asterism`](Asterism.md)</span> | Asterism の gem (vendor/asterism)。 | 6 |
| <span class="fmrb-name">[`Asterism::AsyncProxy`](Asterism__AsyncProxy.md)</span> | 待たずに呼ぶ形 (Proxy#async の答え)。 | 1 |
| <span class="fmrb-name">[`Asterism::Connection`](Asterism__Connection.md)</span> | ネットワークの上のアプリ 1 つ分のつながり (link.conn) | 42 |
| <span class="fmrb-name">[`Asterism::Credentials`](Asterism__Credentials.md)</span> | The credentials .tar a console hands out | 12 |
| <span class="fmrb-name">[`Asterism::Credentials::Error`](Asterism__Credentials__Error.md)</span> | The file is missing something or holds it wrong | 0 |
| <span class="fmrb-name">[`Asterism::CurrentCall`](Asterism__CurrentCall.md)</span> | 今答えている呼び出し (conn.current_call の答え) | 4 |
| <span class="fmrb-name">[`Asterism::Disconnected`](Asterism__Disconnected.md)</span> | つながっていない・切れた | 0 |
| <span class="fmrb-name">[`Asterism::EncodeError`](Asterism__EncodeError.md)</span> | 送れない値を送ろうとした (送る前に止まる) | 0 |
| <span class="fmrb-name">[`Asterism::Error`](Asterism__Error.md)</span> | やり取りの失敗の元 (rescue ::Asterism::Error で全部受かる) | 1 |
| <span class="fmrb-name">[`Asterism::Future`](Asterism__Future.md)</span> | 待たずに呼んだ呼び出しの答え (これから届く) | 7 |
| <span class="fmrb-name">[`Asterism::Profile`](Asterism__Profile.md)</span> | A node's profile: kind, name, host, icon | 2 |
| <span class="fmrb-name">[`Asterism::Proxy`](Asterism__Proxy.md)</span> | ほかの端末のオブジェクトの代わり (conn[path] の答え) | 7 |
| <span class="fmrb-name">[`Asterism::Pubs`](Asterism__Pubs.md)</span> | Rules for the topic declarations (@pubs) | 7 |
| <span class="fmrb-name">[`Asterism::ROS`](Asterism__ROS.md)</span> | Be a ROS 2 node: topics and services | 4 |
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
| <span class="fmrb-name">[`Asterism::RemoteError`](Asterism__RemoteError.md)</span> | 相手のメソッドが例外を出した・呼べなかった | 4 |
| <span class="fmrb-name">[`Asterism::SampleInfo`](Asterism__SampleInfo.md)</span> | 受けた値に付いてくる情報 (subscribe のブロックの 2 つ目) | 15 |
| <span class="fmrb-name">[`Asterism::Sequences`](Asterism__Sequences.md)</span> | A reader's memory of the sequence numbers | 5 |
| <span class="fmrb-name">[`Asterism::SharedSession`](Asterism__SharedSession.md)</span> | Extended onto each connection's session | 1 |
| <span class="fmrb-name">[`Asterism::Status`](Asterism__Status.md)</span> | Rules for an app's status | 2 |
| <span class="fmrb-name">[`Asterism::Subscription`](Asterism__Subscription.md)</span> | 受けているトピック (conn.subscribe の答え) | 7 |
| <span class="fmrb-name">[`Asterism::TimeoutError`](Asterism__TimeoutError.md)</span> | 時間内に答えが来なかった (相手がいない・遅い) | 0 |
| <span class="fmrb-name">[`Asterism::Topic`](Asterism__Topic.md)</span> | 出したトピック (conn.publish の答え) | 12 |
| <span class="fmrb-name">[`Asterism::Types`](Asterism__Types.md)</span> | Names and numbers of the built-in value types | 2 |
| <span class="fmrb-name">[`FmrbAsterism`](FmrbAsterism.md)</span> | Settings and the link to other machines | 12 |
| <span class="fmrb-name">[`FmrbAsterism::Link`](FmrbAsterism__Link.md)</span> | Keeps the app connected (connect, retry, close) | 15 |
| <span class="fmrb-name">[`FmrbAsterism::Settings`](FmrbAsterism__Settings.md)</span> | つなぎ方の設定 (FmrbAsterism.settings の答え) | 6 |
| <span class="fmrb-name">[`FmrbAsterism::TableClient`](FmrbAsterism__TableClient.md)</span> | The device side of a game host's table | 37 |
| <span class="fmrb-name">[`FmrbNet`](FmrbNet.md)</span> | Reads the network state, and fetches without waiting. | 6 |
| <span class="fmrb-name">[`FmrbNet::Request`](FmrbNet__Request.md)</span> | One fetch (what FmrbNet.request returns) | 7 |

## Machine and devices

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`FmrbHw`](FmrbHw.md)</span> | Reads the table of how pins are used. | 4 |
| <span class="fmrb-name">[`GC`](GC.md)</span> | Control and statistics of the garbage collector. | 20 |
| <span class="fmrb-name">[`GPIO`](GPIO.md)</span> | Uses one pin as input or output. | 16 |
| <span class="fmrb-name">[`GPIO::Error`](GPIO__Error.md)</span> | Peripheral error codes and their exceptions | 1 |
| <span class="fmrb-name">[`I2C`](I2C.md)</span> | Talks to I2C devices. | 5 |
| <span class="fmrb-name">[`Machine`](Machine.md)</span> | Time, waiting, and telling the platforms apart. | 24 |
| <span class="fmrb-name">[`Math`](Math.md)</span> | Takes an Integer or a Float and always returns a Float. | 26 |
| <span class="fmrb-name">[`Math::DomainError`](Math__DomainError.md)</span> | Raised for an argument outside the domain | 0 |
| <span class="fmrb-name">[`RNG`](RNG.md)</span> | The source of random numbers. | 3 |

## Ruby core

| Class / module | What it is | Methods |
|---|---|---|
| <span class="fmrb-name">[`Array`](Array.md)</span> |  | 37 |
| <span class="fmrb-name">[`Class`](Class.md)</span> |  | 1 |
| <span class="fmrb-name">[`Enumerable`](Enumerable.md)</span> |  | 4 |
| <span class="fmrb-name">[`FalseClass`](FalseClass.md)</span> |  | 0 |
| <span class="fmrb-name">[`Float`](Float.md)</span> |  | 20 |
| <span class="fmrb-name">[`Hash`](Hash.md)</span> |  | 20 |
| <span class="fmrb-name">[`Integer`](Integer.md)</span> |  | 29 |
| <span class="fmrb-name">[`Kernel`](Kernel.md)</span> |  | 9 |
| <span class="fmrb-name">[`Module`](Module.md)</span> | クラスとモジュール (Module) の操作。 | 2 |
| <span class="fmrb-name">[`NilClass`](NilClass.md)</span> |  | 11 |
| <span class="fmrb-name">[`Object`](Object.md)</span> | Object 自身が受け手になる呼び方 (`Object.const_defined?(:X)`) のための写し。 | 29 |
| <span class="fmrb-name">[`Proc`](Proc.md)</span> |  | 2 |
| <span class="fmrb-name">[`Range`](Range.md)</span> |  | 9 |
| <span class="fmrb-name">[`String`](String.md)</span> |  | 57 |
| <span class="fmrb-name">[`Symbol`](Symbol.md)</span> |  | 5 |
| <span class="fmrb-name">[`TrueClass`](TrueClass.md)</span> |  | 0 |

---

*Generated from the API signatures (`sig/`) of fmruby-core sig-s7@ea56c9e9.*
