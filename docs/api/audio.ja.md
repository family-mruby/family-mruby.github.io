# 音声 (FmrbAudio)

`FmrbAudio` は音声再生 API です。`FmrbAudio.new(self)` を呼んで インスタンスを作ります。

```ruby
class MyApp < FmrbApp
  def on_create
    @audio = FmrbAudio.new(self)
  end
end
```

内部的にはカーネルへ `MSG_TYPE_APP_AUDIO` メッセージを送り、fmruby-graphics-audio 側のオーディオエンジンが処理します。

!!! note "対応ファイル形式"
    対応音声ファイル形式の詳細は [音声ファイルフォーマット](../file_formats/audio_formats.md) を参照してください。

## メソッド

### ファイル再生

| メソッド | 用途 |
|---|---|
| `play(path, track: 0)` | ファイルを再生開始 |
| `stop` | 再生停止 |
| `pause` | 一時停止 |
| `resume` | 再開 |

`path` はファイルパス（例: `/usr/share/sounds/nsf/song.nsf`）。`track:` は曲番号（NSF など複数曲を含むファイルで指定）。

### 録音した音を鳴らす (`play_wav`)

```ruby
@audio.play_wav("/usr/share/sounds/sine440_16k.wav")
```

| メソッド | 用途 |
|---|---|
| `play_wav(path)` | WAV を音源の音に重ねて鳴らす。鳴り始めたら `true` |
| `stop_wav` | 止める |

PCM 16bit・モノラル・8000〜48000Hz・2MB まで。音源が鳴らしている音の上に重なるので、
喋りや録音したチャイムで曲が途切れません。同時に鳴らせるのはシステム全体で 1 本です。次を
鳴らすと入れ替わります。

!!! note "Modern のみ"
    Retro では何も送らずに `false` を返します。アプリは条件を書かずに呼んで、戻り値で
    代替に切り替えられます (時報がまさにこれで、鳴らせるなら録音、駄目なら音源の音を
    鳴らします)。Retro の音は直列線の先の WROVER にあり、鳴らす前に毎回そこへ送るのは
    遅すぎて割に合いません。

### マイク (Modern のみ)

| メソッド | 用途 |
|---|---|
| `mic_available?` | 本体にマイクがあるか |
| `mic_rate` | 1 秒あたりの標本数。ハードウェアで決まっているので、周波数分解能はここから決まります |
| `mic_enable(on = true)` | 取り込みの開始・停止 |
| `mic_read(count, timeout_ms = 200)` | 16bit の標本を `count` 個、バイト列として返します。届かなければ `nil` |

録音は残らず、外にも出ません。標本はアプリに渡るだけです。同梱の「マイクの音を見る」が
そのまま手本になります。

### FMSQ シーケンス

スロットに事前ロードしてから再生する仕組みです。短い効果音や BGM のループ再生に向きます。

| メソッド | 用途 |
|---|---|
| `load_fmsq(slot_id, binary_data)` | バイナリ列をスロットに登録します。1 メッセージの上限があるので、実用的な譜面は入りません |
| `load_fmsq_file(slot_id, path)` | 音声側にすでにあるファイルからスロットを読みます (先に `@gfx.sync_file` で送っておきます)。短い効果音より大きいものはこちらです |
| `play_slot(slot_id)` | 登録済みスロットを再生 |

```ruby
data = File.open("/sfx.fmsq", "r") { |f| f.read }
@audio.load_fmsq(0, data)
@audio.play_slot(0)
```

詳細仕様は [音声ファイルフォーマット](../file_formats/audio_formats.md#fmsq) を参照。

### 音声合成 (note_on / note_off)

NES APU 互換のチャンネルを直接駆動します。短い効果音やゲーム BGM をスクリプトから鳴らせます。

```ruby
@audio.note_on(channel, freq, volume = 10, duty = 2, sweep = 0)
@audio.note_off(channel)
```

| 引数 | 範囲・意味 |
|---|---|
| `channel` | チャンネル番号。NES APU 構成: `0` / `1` = 矩形波、`2` = 三角波、`3` = ノイズ |
| `freq` | 周波数 (Hz)。整数。ノイズチャンネルでは別の意味になることがあります |
| `volume` | 音量。`0`〜`15` 程度。デフォルト `10` |
| `duty` | 矩形波のデューティ比。`0`〜`3` |
| `sweep` | 周波数スイープ値（パッキングされた APU レジスタ値） |

#### サンプル: ピアノ風

```ruby
class MiniPiano < FmrbApp
  KEYS = {
    "a" => 261, "s" => 293, "d" => 329, "f" => 349,
    "g" => 392, "h" => 440, "j" => 493, "k" => 523
  }

  def on_create
    @audio = FmrbAudio.new(self)
    @ch = 0
  end

  def on_event(ev)
    super
    return unless ev[:character]
    if ev[:type] == :key_down && (freq = KEYS[ev[:character]])
      @audio.note_on(@ch, freq, 10, 2, 0)
    elsif ev[:type] == :key_up
      @audio.note_off(@ch)
    end
  end
end

MiniPiano.new.start
```

## トラック番号と再生制御

| 用途 | 推奨 track |
|---|---|
| BGM | `0` |
| SE（効果音） | `1` 以降 |

複数の `play(path, track:)` を異なる track で同時に呼ぶと、別トラックとして並行再生されます（実装依存）。

## NSF ファイル再生

NES Sound Format に対応しています。

```ruby
@audio.play("/usr/share/sounds/nsf/song.nsf", track: 1)
```

`tool/nsf_player.app.rb` に再生 GUI のサンプルがあります。詳細は [音声ファイルフォーマット](../file_formats/audio_formats.md#nsf-nes-sound-format) を参照。

## クリーンアップ

アプリ終了時に再生中の音を止めるため、`on_destroy` で `stop` するのが安全です。

```ruby
def on_destroy
  @audio.stop if @audio
end
```

## 関連

- [音声ファイルフォーマット](../file_formats/audio_formats.md) — FMSQ / NSF の仕様と作り方
- [MIDI](midi.md) — この音源を MIDI 経由で鳴らす、あるいは外部音源へ MIDI を送る
- [サンプル集](../examples.md) — `piano`, `flappy`, `nsf_player` ほか
