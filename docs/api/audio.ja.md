# FmrbAudio

`FmrbAudio` は音声再生 API です。基底クラスでは自動生成されないため、**自分で `FmrbAudio.new(self)` を呼んで** インスタンスを作ります。

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

`path` はファイルパス（例: `/usr/share/music/song.nsf`）。`track:` は曲番号（NSF など複数曲を含むファイルで指定）。

### FMSQ シーケンス

スロットに事前ロードしてから再生する仕組みです。短い効果音や BGM のループ再生に向きます。

| メソッド | 用途 |
|---|---|
| `load_fmsq(slot_id, binary_data)` | バイナリ列をスロットに登録 |
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
@audio.play("/usr/share/music/dq.nsf", track: 1)
```

`tool/nsf_player.app.rb` に再生 GUI のサンプルがあります。詳細は [音声ファイルフォーマット](../file_formats/audio_formats.md#nsf) を参照。

## クリーンアップ

アプリ終了時に再生中の音を止めるため、`on_destroy` で `stop` するのが安全です。

```ruby
def on_destroy
  @audio.stop if @audio
end
```

## 関連

- [音声ファイルフォーマット](../file_formats/audio_formats.md) — FMSQ / NSF の仕様と作り方
- [サンプル集](../examples.md) — `piano`, `flappy`, `nsf_player` ほか
