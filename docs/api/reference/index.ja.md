# クラスリファレンス

!!! note "開発中の版から作っています"
    これらのページは、リリースの版ではなく、fmruby-core の開発中のブランチ (sig-s7@ea56c9e9) の型定義から作っています。ここにあるメソッドが、お使いのファームウェアには無いことや、動きが違うことがあります。各リリースの中身は[リリースノート](../../releases.md) にあります。

アプリから使えるクラスの、すべてのメソッド・定数・例を、API の型定義から自動で作ったページです。使い方の流れは [API リファレンス](../index.md) の各ページにあります。

## アプリ

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`FmrbApp`](FmrbApp.md)</span> |  | 138 |
| <span class="fmrb-name">[`FmrbAssoc`](FmrbAssoc.md)</span> | 拡張子から、そのファイルを開く先を引く | 5 |
| <span class="fmrb-name">[`FmrbColors`](FmrbColors.md)</span> | 色の名前の表と、/home/colors.toml の読み書き。 | 11 |
| <span class="fmrb-name">[`FmrbConst`](FmrbConst.md)</span> | 端末・ビルド・キー・テーマの値をまとめた定数の入れもの。 | 1 |
| <span class="fmrb-name">[`FmrbI18n`](FmrbI18n.md)</span> | 日本語と英語で表示を切りかえる。 | 8 |
| <span class="fmrb-name">[`FmrbReceiveConf`](FmrbReceiveConf.md)</span> | このマシンがファイルや app を受け取るか、だれから受け取るかを読み書きする。 | 16 |
| <span class="fmrb-name">[`FmrbSystem`](FmrbSystem.md)</span> | 端末の設定とサービス | 40 |
| <span class="fmrb-name">[`FmrbToml`](FmrbToml.md)</span> | TOML の設定ファイルを読む・行ごとに書き換える。 | 7 |
| <span class="fmrb-name">[`FmrbToml::Raw`](FmrbToml__Raw.md)</span> | 引用符なしで書く値の入れもの | 2 |
| <span class="fmrb-name">[`Log`](Log.md)</span> | ログ (シリアルと sim の端末に出る)。 | 8 |
| <span class="fmrb-name">[`Unit8Encoder`](Unit8Encoder.md)</span> | ロータリエンコーダ 8 個・ボタン 8 個・スイッチ 1 個・RGB の LED 9 個の機器。 | 12 |

## 描画

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`BMP332`](BMP332.md)</span> | RGB332 の絵 (8 ビット BMP・パレット PNG) | 7 |
| <span class="fmrb-name">[`Fmrb::Raycast`](Fmrb__Raycast.md)</span> | 格子の地図を、壁までの距離で見る (Wolfenstein 3D 風)。 | 14 |
| <span class="fmrb-name">[`FmrbGfx`](FmrbGfx.md)</span> |  | 93 |
| <span class="fmrb-name">[`FmrbHitMask`](FmrbHitMask.md)</span> | 枠なしの Window の当たりの形 (画素単位)。 | 7 |
| <span class="fmrb-name">[`FmrbText`](FmrbText.md)</span> | 文字を px で測って詰める・折る道具 | 3 |
| <span class="fmrb-name">[`FmrbUI`](FmrbUI.md)</span> | 部品の入れ物 | 30 |
| <span class="fmrb-name">[`FmrbUI::Button`](FmrbUI__Button.md)</span> | 押しボタン | 1 |
| <span class="fmrb-name">[`FmrbUI::Enum`](FmrbUI__Enum.md)</span> | 選択肢を選ぶ部品 | 1 |
| <span class="fmrb-name">[`FmrbUI::HitAreas`](FmrbUI__HitAreas.md)</span> | 毎回描く画面の押せる範囲 | 5 |
| <span class="fmrb-name">[`FmrbUI::Label`](FmrbUI__Label.md)</span> | 文字だけの部品 | 1 |
| <span class="fmrb-name">[`FmrbUI::Scrollbar`](FmrbUI__Scrollbar.md)</span> | 縦のスクロールバー | 7 |
| <span class="fmrb-name">[`FmrbUI::Stepper`](FmrbUI__Stepper.md)</span> | 数を増減する部品 | 8 |
| <span class="fmrb-name">[`FmrbUI::TextField`](FmrbUI__TextField.md)</span> | 1 行の文字入力欄 | 3 |
| <span class="fmrb-name">[`FmrbUI::Toggle`](FmrbUI__Toggle.md)</span> | 入切の切替 | 5 |
| <span class="fmrb-name">[`FmrbUI::Widget`](FmrbUI__Widget.md)</span> | 部品に共通のところ | 13 |
| <span class="fmrb-name">[`FmrbVideo`](FmrbVideo.md)</span> | FmrbGfx#video_open が返す、流している動画の取っ手。 | 9 |
| <span class="fmrb-name">[`GfxBlock`](GfxBlock.md)</span> | 同じ形をくり返し描くときの下書き。 | 4 |
| <span class="fmrb-name">[`P5`](P5.md)</span> |  | 43 |
| <span class="fmrb-name">[`SpriteImage`](SpriteImage.md)</span> | うごく絵の中身。 | 10 |
| <span class="fmrb-name">[`SpriteInstance`](SpriteInstance.md)</span> | 画面に置いた一つのうごく絵。 | 11 |
| <span class="fmrb-name">[`TileMap`](TileMap.md)</span> | 地図そのもの。 | 17 |
| <span class="fmrb-name">[`TileRing`](TileRing.md)</span> | 見えている周りだけを描き直して、広い地図を軽く動かす仕組み。 | 4 |
| <span class="fmrb-name">[`TileSheet`](TileSheet.md)</span> | タイルの絵をならべた一枚の絵。 | 8 |

## 音声

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Fmrb`](Fmrb.md)</span> |  | 0 |
| <span class="fmrb-name">[`Fmrb::Fft`](Fmrb__Fft.md)</span> | 音のスペクトルを計算する。 | 14 |
| <span class="fmrb-name">[`FmrbAudio`](FmrbAudio.md)</span> |  | 21 |
| <span class="fmrb-name">[`FmrbMic`](FmrbMic.md)</span> | マイクの C 側の窓口。 | 1 |
| <span class="fmrb-name">[`FmrbMidi`](FmrbMidi.md)</span> |  | 11 |
| <span class="fmrb-name">[`FmrbMidi::ApuTransport`](FmrbMidi__ApuTransport.md)</span> | 内蔵音源 (APU) へ MIDI を送る口。 | 8 |
| <span class="fmrb-name">[`FmrbMidi::MmlPlayer`](FmrbMidi__MmlPlayer.md)</span> | MML で書いた曲を鳴らす係。 | 29 |
| <span class="fmrb-name">[`FmrbMidi::SmfPlayer`](FmrbMidi__SmfPlayer.md)</span> | 曲のファイル (SMF) を鳴らす係。 | 37 |
| <span class="fmrb-name">[`MIDI`](MIDI.md)</span> |  | 0 |
| <span class="fmrb-name">[`MIDI::Device`](MIDI__Device.md)</span> | 音を出す口。 | 24 |
| <span class="fmrb-name">[`NsfHeader`](NsfHeader.md)</span> | NSF (ファミコンの曲) のファイルの題名などを読む。 | 6 |

## ファイルと時刻

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Dir`](Dir.md)</span> | ディレクトリの一覧と操作。 | 24 |
| <span class="fmrb-name">[`File`](File.md)</span> | ファイルの読み書き (File)。 | 20 |
| <span class="fmrb-name">[`FmrbFile`](FmrbFile.md)</span> |  | 11 |
| <span class="fmrb-name">[`IO`](IO.md)</span> | 入出力のストリーム。 | 7 |
| <span class="fmrb-name">[`Time`](Time.md)</span> | 日付と時刻。 | 52 |

## データ

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Digest`](Digest.md)</span> | ハッシュの入れもの。 | 0 |
| <span class="fmrb-name">[`Digest::SHA256`](Digest__SHA256.md)</span> | SHA-256 を計算する | 6 |
| <span class="fmrb-name">[`JSON`](JSON.md)</span> | JSON の読み書き。 | 2 |
| <span class="fmrb-name">[`JSON::Digger`](JSON__Digger.md)</span> | 大きな JSON から一部だけ取り出す | 3 |
| <span class="fmrb-name">[`JSON::DiggerError`](JSON__DiggerError.md)</span> | JSON::Digger の例外 | 0 |
| <span class="fmrb-name">[`JSON::GeneratorError`](JSON__GeneratorError.md)</span> | JSON.generate の例外 (実装は出さない) | 0 |
| <span class="fmrb-name">[`JSON::JSONError`](JSON__JSONError.md)</span> | JSON の例外の親 | 0 |
| <span class="fmrb-name">[`JSON::ParserError`](JSON__ParserError.md)</span> | JSON.parse が読めなかったときの例外 | 0 |
| <span class="fmrb-name">[`MessagePack`](MessagePack.md)</span> | MessagePack で値をバイト列にし、戻す。 | 4 |

## ネットワーク

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Asterism`](Asterism.md)</span> | Asterism の gem (vendor/asterism)。 | 6 |
| <span class="fmrb-name">[`Asterism::AsyncProxy`](Asterism__AsyncProxy.md)</span> | 待たずに呼ぶ形 (Proxy#async の答え)。 | 1 |
| <span class="fmrb-name">[`Asterism::Connection`](Asterism__Connection.md)</span> | ネットワークの上のアプリ 1 つ分のつながり (link.conn) | 42 |
| <span class="fmrb-name">[`Asterism::Credentials`](Asterism__Credentials.md)</span> | コンソールが渡す証明書一式 (.tar) | 12 |
| <span class="fmrb-name">[`Asterism::Credentials::Error`](Asterism__Credentials__Error.md)</span> | 証明書の .tar を読めない・形が違う | 0 |
| <span class="fmrb-name">[`Asterism::CurrentCall`](Asterism__CurrentCall.md)</span> | 今答えている呼び出し (conn.current_call の答え) | 4 |
| <span class="fmrb-name">[`Asterism::Disconnected`](Asterism__Disconnected.md)</span> | つながっていない・切れた | 0 |
| <span class="fmrb-name">[`Asterism::EncodeError`](Asterism__EncodeError.md)</span> | 送れない値を送ろうとした (送る前に止まる) | 0 |
| <span class="fmrb-name">[`Asterism::Error`](Asterism__Error.md)</span> | やり取りの失敗の元 (rescue ::Asterism::Error で全部受かる) | 1 |
| <span class="fmrb-name">[`Asterism::Future`](Asterism__Future.md)</span> | 待たずに呼んだ呼び出しの答え (これから届く) | 7 |
| <span class="fmrb-name">[`Asterism::Profile`](Asterism__Profile.md)</span> | 端末の名乗り (Profile) | 2 |
| <span class="fmrb-name">[`Asterism::Proxy`](Asterism__Proxy.md)</span> | ほかの端末のオブジェクトの代わり (conn[path] の答え) | 7 |
| <span class="fmrb-name">[`Asterism::Pubs`](Asterism__Pubs.md)</span> | トピックの宣言 (@pubs) の決まり | 7 |
| <span class="fmrb-name">[`Asterism::ROS`](Asterism__ROS.md)</span> | ROS 2 のノードのふりをして、トピックとサービスをやり取りする | 4 |
| <span class="fmrb-name">[`Asterism::ROS::Attachment`](Asterism__ROS__Attachment.md)</span> | 送り手が付ける添え物 | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Call`](Asterism__ROS__Call.md)</span> | 出したサービスの呼び出し (client.call_async の答え) | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Client`](Asterism__ROS__Client.md)</span> | サービスを呼ぶ口 (node.client の答え) | 10 |
| <span class="fmrb-name">[`Asterism::ROS::Message`](Asterism__ROS__Message.md)</span> | メッセージの土台 (生成した型の親) | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Node`](Asterism__ROS__Node.md)</span> | ROS 2 のノード | 18 |
| <span class="fmrb-name">[`Asterism::ROS::Publisher`](Asterism__ROS__Publisher.md)</span> | トピックに出す口 (node.publisher の答え) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Service`](Asterism__ROS__Service.md)</span> | サービスを提供する口 (node.service の答え) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Subscription`](Asterism__ROS__Subscription.md)</span> | トピックを受ける口 (node.subscription・node.subscribe の答え) | 11 |
| <span class="fmrb-name">[`Asterism::ROS::TimeoutError`](Asterism__ROS__TimeoutError.md)</span> | サービスが時間内に答えなかった | 0 |
| <span class="fmrb-name">[`Asterism::ROS::Timer`](Asterism__ROS__Timer.md)</span> | 一定間隔のブロック (node.every の答え) | 4 |
| <span class="fmrb-name">[`Asterism::ROS::UnknownType`](Asterism__ROS__UnknownType.md)</span> | 型のファイルが見つからない | 0 |
| <span class="fmrb-name">[`Asterism::RemoteError`](Asterism__RemoteError.md)</span> | 相手のメソッドが例外を出した・呼べなかった | 4 |
| <span class="fmrb-name">[`Asterism::SampleInfo`](Asterism__SampleInfo.md)</span> | 受けた値に付いてくる情報 (subscribe のブロックの 2 つ目) | 15 |
| <span class="fmrb-name">[`Asterism::Sequences`](Asterism__Sequences.md)</span> | 受けた値の番号の記憶 | 5 |
| <span class="fmrb-name">[`Asterism::SharedSession`](Asterism__SharedSession.md)</span> | 接続のセッションに付くモジュール | 1 |
| <span class="fmrb-name">[`Asterism::Status`](Asterism__Status.md)</span> | アプリの状態の決まり | 2 |
| <span class="fmrb-name">[`Asterism::Subscription`](Asterism__Subscription.md)</span> | 受けているトピック (conn.subscribe の答え) | 7 |
| <span class="fmrb-name">[`Asterism::TimeoutError`](Asterism__TimeoutError.md)</span> | 時間内に答えが来なかった (相手がいない・遅い) | 0 |
| <span class="fmrb-name">[`Asterism::Topic`](Asterism__Topic.md)</span> | 出したトピック (conn.publish の答え) | 12 |
| <span class="fmrb-name">[`Asterism::Types`](Asterism__Types.md)</span> | トピックの値の型の名前と番号 | 2 |
| <span class="fmrb-name">[`FmrbAsterism`](FmrbAsterism.md)</span> | ほかの端末とつなぐ設定と Link | 12 |
| <span class="fmrb-name">[`FmrbAsterism::Link`](FmrbAsterism__Link.md)</span> | つなぐ・つなぎ直す・閉じる | 15 |
| <span class="fmrb-name">[`FmrbAsterism::Settings`](FmrbAsterism__Settings.md)</span> | つなぎ方の設定 (FmrbAsterism.settings の答え) | 6 |
| <span class="fmrb-name">[`FmrbAsterism::TableClient`](FmrbAsterism__TableClient.md)</span> | ゲームホストの卓につなぐ部品 | 37 |
| <span class="fmrb-name">[`FmrbNet`](FmrbNet.md)</span> | ネットワークの状態を読み、待たずに取得する。 | 6 |
| <span class="fmrb-name">[`FmrbNet::Request`](FmrbNet__Request.md)</span> | 取得 1 件 (FmrbNet.request が返す) | 7 |

## 本体と機器

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`FmrbHw`](FmrbHw.md)</span> | ピンの台帳を読む。 | 4 |
| <span class="fmrb-name">[`GC`](GC.md)</span> | ガベージコレクタの操作と統計。 | 20 |
| <span class="fmrb-name">[`GPIO`](GPIO.md)</span> | 1 本のピンを入れ出力に使う。 | 16 |
| <span class="fmrb-name">[`GPIO::Error`](GPIO__Error.md)</span> | GPIO の周辺機器の失敗の番号と例外 | 1 |
| <span class="fmrb-name">[`I2C`](I2C.md)</span> | I2C の機器と話す。 | 5 |
| <span class="fmrb-name">[`Machine`](Machine.md)</span> | 時刻と待ち、機種の判別。 | 24 |
| <span class="fmrb-name">[`Math`](Math.md)</span> | 三角関数・指数・対数などの数学関数。 | 26 |
| <span class="fmrb-name">[`Math::DomainError`](Math__DomainError.md)</span> | 定義域の外の値を渡したときの例外 | 0 |
| <span class="fmrb-name">[`RNG`](RNG.md)</span> | 乱数の元。 | 3 |

## Ruby の基本クラス

| クラス / モジュール | 中身 | メソッド数 |
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

*このページは fmruby-core の sig-s7@ea56c9e9 の API の型定義 (`sig/`) から自動で作っています。*
