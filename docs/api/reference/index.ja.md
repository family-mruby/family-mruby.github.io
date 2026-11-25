# クラスリファレンス

アプリから使えるクラスの、すべてのメソッド・定数・例を、API の型定義から自動で作ったページです。使い方の流れは [API リファレンス](../index.md) の各ページにあります。

## アプリ

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`FmrbApp`](FmrbApp.md)</span> | アプリの土台。 | 139 |
| <span class="fmrb-name">[`FmrbAssoc`](FmrbAssoc.md)</span> | 拡張子から、そのファイルを開く先を引く | 5 |
| <span class="fmrb-name">[`FmrbColors`](FmrbColors.md)</span> | 色の名前の表と、/home/colors.toml の読み書き | 11 |
| <span class="fmrb-name">[`FmrbConst`](FmrbConst.md)</span> | 端末・ビルド・キー・テーマの定数の入れもの | 1 |
| <span class="fmrb-name">[`FmrbI18n`](FmrbI18n.md)</span> | 日本語と英語で表示を切りかえる | 8 |
| <span class="fmrb-name">[`FmrbReceiveConf`](FmrbReceiveConf.md)</span> | ファイルや app の受け取りの設定を読み書きする | 16 |
| <span class="fmrb-name">[`FmrbSystem`](FmrbSystem.md)</span> | 端末の設定とサービス | 40 |
| <span class="fmrb-name">[`FmrbToml`](FmrbToml.md)</span> | TOML の設定を読む・行ごとに書き換える | 7 |
| <span class="fmrb-name">[`FmrbToml::Raw`](FmrbToml__Raw.md)</span> | 引用符なしで書く値の入れもの | 2 |
| <span class="fmrb-name">[`Log`](Log.md)</span> | ログ (シリアルと sim の端末に出る) | 8 |
| <span class="fmrb-name">[`Unit8Encoder`](Unit8Encoder.md)</span> | エンコーダ 8・ボタン 8・スイッチ 1・LED 9 の機器 | 12 |

## 描画

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`BMP332`](BMP332.md)</span> | RGB332 の絵 (8 ビット BMP・パレット PNG) | 7 |
| <span class="fmrb-name">[`Fmrb::Raycast`](Fmrb__Raycast.md)</span> | 格子の地図を壁までの距離で見る | 14 |
| <span class="fmrb-name">[`FmrbGfx`](FmrbGfx.md)</span> | 絵を描く画面。 | 93 |
| <span class="fmrb-name">[`FmrbHitMask`](FmrbHitMask.md)</span> | 枠なし Window の当たりの形 (画素単位) | 7 |
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
| <span class="fmrb-name">[`FmrbVideo`](FmrbVideo.md)</span> | 流している動画の取っ手 | 9 |
| <span class="fmrb-name">[`GfxBlock`](GfxBlock.md)</span> | 同じ形をくり返し描くときの下書き | 4 |
| <span class="fmrb-name">[`P5`](P5.md)</span> | p5.js 風の書き方で絵を描く | 43 |
| <span class="fmrb-name">[`SpriteImage`](SpriteImage.md)</span> | うごく絵の中身 | 10 |
| <span class="fmrb-name">[`SpriteInstance`](SpriteInstance.md)</span> | 画面に置いた一つのうごく絵 | 11 |
| <span class="fmrb-name">[`TileMap`](TileMap.md)</span> | 地図そのもの | 17 |
| <span class="fmrb-name">[`TileRing`](TileRing.md)</span> | 見えている周りだけを描き直す仕組み | 4 |
| <span class="fmrb-name">[`TileSheet`](TileSheet.md)</span> | タイルの絵をならべた一枚の絵 | 8 |

## 音声

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Fmrb`](Fmrb.md)</span> | Fmrb の名前空間 (Fft・Raycast) | 0 |
| <span class="fmrb-name">[`Fmrb::Fft`](Fmrb__Fft.md)</span> | 音のスペクトルを計算する | 14 |
| <span class="fmrb-name">[`FmrbAudio`](FmrbAudio.md)</span> | 音を鳴らす。 | 21 |
| <span class="fmrb-name">[`FmrbMic`](FmrbMic.md)</span> | マイクの C 側の窓口 | 1 |
| <span class="fmrb-name">[`FmrbMidi`](FmrbMidi.md)</span> | MIDI の入り口。 | 11 |
| <span class="fmrb-name">[`FmrbMidi::ApuTransport`](FmrbMidi__ApuTransport.md)</span> | 内蔵音源 (APU) へ MIDI を送るトランスポート | 8 |
| <span class="fmrb-name">[`FmrbMidi::MmlPlayer`](FmrbMidi__MmlPlayer.md)</span> | MML で書いた曲を鳴らす係 | 29 |
| <span class="fmrb-name">[`FmrbMidi::SmfPlayer`](FmrbMidi__SmfPlayer.md)</span> | 曲のファイル (SMF) を鳴らす係 | 37 |
| <span class="fmrb-name">[`MIDI`](MIDI.md)</span> | MIDI の名前空間。 | 0 |
| <span class="fmrb-name">[`MIDI::Device`](MIDI__Device.md)</span> | 音を出すデバイス。 | 24 |
| <span class="fmrb-name">[`NsfHeader`](NsfHeader.md)</span> | NSF (ファミコンの曲) のファイルの題名などを読む | 6 |

## ファイルと時刻

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Dir`](Dir.md)</span> | ディレクトリの一覧と操作 | 24 |
| <span class="fmrb-name">[`File`](File.md)</span> | ファイルの読み書き (File) | 20 |
| <span class="fmrb-name">[`FmrbFile`](FmrbFile.md)</span> | ファイルを丸ごと読み書きする | 11 |
| <span class="fmrb-name">[`IO`](IO.md)</span> | 入出力のストリーム | 7 |
| <span class="fmrb-name">[`Time`](Time.md)</span> | 日付と時刻 | 52 |

## データ

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Digest`](Digest.md)</span> | ハッシュの入れもの (SHA-256) | 0 |
| <span class="fmrb-name">[`Digest::SHA256`](Digest__SHA256.md)</span> | SHA-256 を計算する | 6 |
| <span class="fmrb-name">[`JSON`](JSON.md)</span> | JSON の読み書き | 2 |
| <span class="fmrb-name">[`JSON::Digger`](JSON__Digger.md)</span> | 大きな JSON から一部だけ取り出す | 3 |
| <span class="fmrb-name">[`JSON::DiggerError`](JSON__DiggerError.md)</span> | JSON::Digger の例外 | 0 |
| <span class="fmrb-name">[`JSON::GeneratorError`](JSON__GeneratorError.md)</span> | JSON.generate の例外 (NaN・無限大) | 0 |
| <span class="fmrb-name">[`JSON::JSONError`](JSON__JSONError.md)</span> | JSON の例外の親 | 0 |
| <span class="fmrb-name">[`JSON::ParserError`](JSON__ParserError.md)</span> | JSON.parse が読めなかったときの例外 | 0 |
| <span class="fmrb-name">[`MessagePack`](MessagePack.md)</span> | MessagePack で値をバイト列にし、戻す | 4 |

## ネットワーク

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`Asterism`](Asterism.md)</span> | Asterism の gem。 | 6 |
| <span class="fmrb-name">[`Asterism::AsyncProxy`](Asterism__AsyncProxy.md)</span> | 待たずに呼ぶ形 | 1 |
| <span class="fmrb-name">[`Asterism::Connection`](Asterism__Connection.md)</span> | ネットワーク上のアプリ 1 つ分のつながり | 42 |
| <span class="fmrb-name">[`Asterism::Credentials`](Asterism__Credentials.md)</span> | コンソールが渡す証明書一式 (.tar) | 12 |
| <span class="fmrb-name">[`Asterism::Credentials::Error`](Asterism__Credentials__Error.md)</span> | 証明書の .tar を読めない・形が違う | 0 |
| <span class="fmrb-name">[`Asterism::CurrentCall`](Asterism__CurrentCall.md)</span> | 今答えている呼び出し | 4 |
| <span class="fmrb-name">[`Asterism::Disconnected`](Asterism__Disconnected.md)</span> | つながっていない・切れた | 0 |
| <span class="fmrb-name">[`Asterism::EncodeError`](Asterism__EncodeError.md)</span> | 送れない値を送ろうとした | 0 |
| <span class="fmrb-name">[`Asterism::Error`](Asterism__Error.md)</span> | やり取りの失敗の元 | 1 |
| <span class="fmrb-name">[`Asterism::Future`](Asterism__Future.md)</span> | 待たずに呼んだ呼び出しの答え | 7 |
| <span class="fmrb-name">[`Asterism::Profile`](Asterism__Profile.md)</span> | 端末の名乗り (Profile) | 2 |
| <span class="fmrb-name">[`Asterism::Proxy`](Asterism__Proxy.md)</span> | ほかの端末のオブジェクトの代わり | 7 |
| <span class="fmrb-name">[`Asterism::Pubs`](Asterism__Pubs.md)</span> | トピックの宣言 (@pubs) の決まり | 7 |
| <span class="fmrb-name">[`Asterism::ROS`](Asterism__ROS.md)</span> | ROS 2 のノードのふりをする | 4 |
| <span class="fmrb-name">[`Asterism::ROS::Attachment`](Asterism__ROS__Attachment.md)</span> | 送り手が付ける添え物 | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Call`](Asterism__ROS__Call.md)</span> | 出したサービスの呼び出し (client.call_async の答え) | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Client`](Asterism__ROS__Client.md)</span> | サービスの Client (node.client の答え) | 10 |
| <span class="fmrb-name">[`Asterism::ROS::Message`](Asterism__ROS__Message.md)</span> | メッセージの土台 (生成した型の親) | 6 |
| <span class="fmrb-name">[`Asterism::ROS::Node`](Asterism__ROS__Node.md)</span> | ROS 2 のノード | 18 |
| <span class="fmrb-name">[`Asterism::ROS::Publisher`](Asterism__ROS__Publisher.md)</span> | トピックの Publisher (node.publisher の答え) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Service`](Asterism__ROS__Service.md)</span> | 提供しているサービス (node.service の答え) | 7 |
| <span class="fmrb-name">[`Asterism::ROS::Subscription`](Asterism__ROS__Subscription.md)</span> | トピックの Subscription (node.subscription・node.subscribe の答え) | 11 |
| <span class="fmrb-name">[`Asterism::ROS::TimeoutError`](Asterism__ROS__TimeoutError.md)</span> | サービスが時間内に答えなかった | 0 |
| <span class="fmrb-name">[`Asterism::ROS::Timer`](Asterism__ROS__Timer.md)</span> | 一定間隔のブロック (node.every の答え) | 4 |
| <span class="fmrb-name">[`Asterism::ROS::UnknownType`](Asterism__ROS__UnknownType.md)</span> | 型のファイルが見つからない | 0 |
| <span class="fmrb-name">[`Asterism::RemoteError`](Asterism__RemoteError.md)</span> | 相手のメソッドが例外を出した・呼べなかった | 4 |
| <span class="fmrb-name">[`Asterism::SampleInfo`](Asterism__SampleInfo.md)</span> | 受けた値に付いてくる情報 | 15 |
| <span class="fmrb-name">[`Asterism::Sequences`](Asterism__Sequences.md)</span> | 受けた値の番号の記憶 | 5 |
| <span class="fmrb-name">[`Asterism::SharedSession`](Asterism__SharedSession.md)</span> | 接続のセッションに付くモジュール | 1 |
| <span class="fmrb-name">[`Asterism::Status`](Asterism__Status.md)</span> | アプリの状態の決まり | 2 |
| <span class="fmrb-name">[`Asterism::Subscription`](Asterism__Subscription.md)</span> | 受けているトピック | 7 |
| <span class="fmrb-name">[`Asterism::TimeoutError`](Asterism__TimeoutError.md)</span> | 時間内に答えが来なかった | 0 |
| <span class="fmrb-name">[`Asterism::Topic`](Asterism__Topic.md)</span> | 出したトピック | 12 |
| <span class="fmrb-name">[`Asterism::Types`](Asterism__Types.md)</span> | トピックの値の型の名前と番号 | 2 |
| <span class="fmrb-name">[`FmrbAsterism`](FmrbAsterism.md)</span> | ほかの端末とつなぐ設定と Link | 12 |
| <span class="fmrb-name">[`FmrbAsterism::Link`](FmrbAsterism__Link.md)</span> | つなぐ・つなぎ直す・閉じる | 15 |
| <span class="fmrb-name">[`FmrbAsterism::Settings`](FmrbAsterism__Settings.md)</span> | つなぎ方の設定 | 6 |
| <span class="fmrb-name">[`FmrbAsterism::TableClient`](FmrbAsterism__TableClient.md)</span> | ゲームホストの卓につなぐ部品 | 37 |
| <span class="fmrb-name">[`FmrbNet`](FmrbNet.md)</span> | ネットワークの状態を読み、待たずに取得する | 6 |
| <span class="fmrb-name">[`FmrbNet::Request`](FmrbNet__Request.md)</span> | 取得 1 件 (FmrbNet.request が返す) | 7 |

## 本体と機器

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`FmrbHw`](FmrbHw.md)</span> | ピンの台帳を読む | 4 |
| <span class="fmrb-name">[`GC`](GC.md)</span> | ガベージコレクタの操作と統計 | 20 |
| <span class="fmrb-name">[`GPIO`](GPIO.md)</span> | 1 本のピンを入れ出力に使う | 16 |
| <span class="fmrb-name">[`GPIO::Error`](GPIO__Error.md)</span> | GPIO の周辺機器の失敗の番号と例外 | 1 |
| <span class="fmrb-name">[`I2C`](I2C.md)</span> | I2C の機器と話す | 5 |
| <span class="fmrb-name">[`Machine`](Machine.md)</span> | 時刻と待ち、機種の判別 | 24 |
| <span class="fmrb-name">[`Math`](Math.md)</span> | 三角関数・指数・対数などの数学関数 | 26 |
| <span class="fmrb-name">[`Math::DomainError`](Math__DomainError.md)</span> | 定義域の外の値を渡したときの例外 | 0 |
| <span class="fmrb-name">[`RNG`](RNG.md)</span> | 乱数の元 | 3 |

## Ruby の基本クラス

| クラス / モジュール | 中身 | メソッド数 |
|---|---|---|
| <span class="fmrb-name">[`ArgumentError`](ArgumentError.md)</span> | 引数の数か値が合わない | 0 |
| <span class="fmrb-name">[`Array`](Array.md)</span> | 要素を並べた配列 | 37 |
| <span class="fmrb-name">[`Class`](Class.md)</span> | クラス自身を表す。 | 1 |
| <span class="fmrb-name">[`Enumerable`](Enumerable.md)</span> | each を持つものに混ぜる繰り返しの道具 | 4 |
| <span class="fmrb-name">[`Exception`](Exception.md)</span> | 例外のもとになるクラス | 5 |
| <span class="fmrb-name">[`FalseClass`](FalseClass.md)</span> | 偽を表す false の型 | 0 |
| <span class="fmrb-name">[`Float`](Float.md)</span> | 小数 (浮動小数点数) | 20 |
| <span class="fmrb-name">[`FrozenError`](FrozenError.md)</span> | 凍結したオブジェクトの変更 | 0 |
| <span class="fmrb-name">[`Hash`](Hash.md)</span> | 印 (キー) で値を引く表 | 20 |
| <span class="fmrb-name">[`IndexError`](IndexError.md)</span> | 範囲の外の位置 | 0 |
| <span class="fmrb-name">[`Integer`](Integer.md)</span> | 整数 | 29 |
| <span class="fmrb-name">[`Kernel`](Kernel.md)</span> | どこからでも呼べる出力・乱数・Proc の道具 | 12 |
| <span class="fmrb-name">[`KeyError`](KeyError.md)</span> | 無いキー (Hash#fetch) | 0 |
| <span class="fmrb-name">[`Module`](Module.md)</span> | クラスとモジュールの操作 | 2 |
| <span class="fmrb-name">[`NameError`](NameError.md)</span> | 無い名前の定数・変数 | 0 |
| <span class="fmrb-name">[`NilClass`](NilClass.md)</span> | nil の型。 | 11 |
| <span class="fmrb-name">[`NoMemoryError`](NoMemoryError.md)</span> | メモリが足りない | 0 |
| <span class="fmrb-name">[`NoMethodError`](NoMethodError.md)</span> | 無いメソッドの呼び出し | 0 |
| <span class="fmrb-name">[`NotImplementedError`](NotImplementedError.md)</span> | この端末・ビルドには無い機能 | 0 |
| <span class="fmrb-name">[`Object`](Object.md)</span> | Object を受け手にする呼び方の写し | 29 |
| <span class="fmrb-name">[`Proc`](Proc.md)</span> | ブロックを値にしたもの | 2 |
| <span class="fmrb-name">[`Range`](Range.md)</span> | 範囲 (1..3 や 1...3) | 9 |
| <span class="fmrb-name">[`RangeError`](RangeError.md)</span> | 範囲の外の数 | 0 |
| <span class="fmrb-name">[`RuntimeError`](RuntimeError.md)</span> | クラスを指定しない raise の例外 | 0 |
| <span class="fmrb-name">[`ScriptError`](ScriptError.md)</span> | プログラムそのものの誤り (rescue の既定では受からない) | 0 |
| <span class="fmrb-name">[`StandardError`](StandardError.md)</span> | ふつうの例外のもと (rescue が既定で受ける) | 0 |
| <span class="fmrb-name">[`StopIteration`](StopIteration.md)</span> | 繰り返しの終わり | 0 |
| <span class="fmrb-name">[`String`](String.md)</span> | 文字列 (UTF-8) | 57 |
| <span class="fmrb-name">[`Symbol`](Symbol.md)</span> | 名前を表す Symbol (:name) | 5 |
| <span class="fmrb-name">[`SystemStackError`](SystemStackError.md)</span> | 呼び出しが深すぎる | 0 |
| <span class="fmrb-name">[`TrueClass`](TrueClass.md)</span> | 真を表す true の型 | 0 |
| <span class="fmrb-name">[`TypeError`](TypeError.md)</span> | 型が合わない | 0 |
| <span class="fmrb-name">[`ZeroDivisionError`](ZeroDivisionError.md)</span> | 整数の 0 での割り算 | 0 |

---

*このページは fmruby-core の develop@76d45150 の API の型定義 (`sig/`) から自動で作っています。*
