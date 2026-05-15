# 音声ファイルフォーマット

Family mruby が対応する音声ファイル形式と、その作成・変換方法を説明します。

| 形式 | 用途 | API |
|---|---|---|
| FMSQ | 短い BGM / SE のシーケンスデータ。スロットにロードして再生 | `FmrbAudio#load_fmsq`, `play_slot` |
| NSF | ファミコン音楽（NES Sound Format） | `FmrbAudio#play(path, track:)` |

## FMSQ

FMSQ (Family mruby Sequence) は **NES APU 互換** の音楽データを記述する独自フォーマットです。短い効果音や BGM ループに向いています。

### ファイル構造

12 バイトのヘッダ + 可変長コマンド列。すべて little-endian。

```
+------+----------------+
| 0..3 | "FMSQ"         |  magic
| 4    | version (=1)   |
| 5    | flags (=0)     |  reserved
| 6..7 | frame_count    |  total frames
| 8..9 | data_size      |  command bytes
| 10..11 | loop_offset  |  0 = no loop
+------+----------------+
| 12.. | command stream |
+------+----------------+
```

### コマンドエンコーディング

| コマンド | 形式 | 意味 |
|---|---|---|
| WAIT | `0xxxxxxx` | 1〜128 フレーム待機 (`(N & 0x7F) + 1`) |
| NOTE_ON  | `10cc0000` | チャンネル `cc` のノート開始 |
| NOTE_OFF | `10cc0001` | チャンネル `cc` のノート停止 |
| PARAM | `10cc0010` | チャンネルパラメータ更新（後続マスクとデータ） |
| REG_WRITE | `110aaaaa DATA` | APU レジスタ `$4000 + a` に直接書き込み |
| DPCM_PLAY | `0xE0 RATE_FLAGS ADDR LENGTH` | DPCM 再生 |
| DPCM_STOP | `0xE1` | DPCM 停止 |
| DPCM_RAW  | `0xE2 VALUE` | 7bit DAC 直接書き込み |
| END  | `0xFE` | データ終了 |
| LOOP | `0xFF OFFSET_LO OFFSET_HI` | 指定オフセットへループ |

### チャンネル ID

| ID | チャンネル |
|---|---|
| 0 | Pulse 1 (矩形波) |
| 1 | Pulse 2 (矩形波) |
| 2 | Triangle (三角波) |
| 3 | Noise (ノイズ) |

### 作成方法

`fmruby-graphics-audio/tools/` 以下に Ruby のジェネレータがあります（PC で実行）。

```
fmruby-graphics-audio/tools/gen_test_fmsq.rb     # スケールパターン
fmruby-graphics-audio/tools/gen_intro_fmsq.rb    # ジングル
```

これらを参考に音階・コードを記述すると `.fmsq` バイナリが生成できます。

### 再生

スロット（番号 ID）にロードしてから再生します。

```ruby
data = File.open("/sfx.fmsq", "r") { |f| f.read }
@audio.load_fmsq(0, data)   # スロット 0 に登録
@audio.play_slot(0)         # 再生
```

詳細は [FmrbAudio](../api/audio.md) を参照。

## NSF (NES Sound Format)

NES Sound Format は実機ファミコン音楽を再生する標準フォーマットです。Family mruby は NSF ファイルの再生に対応しています。

### 入手方法

- アーカイブサイト（NSFArchive 等）から入手
- 自分で作る場合は FamiTracker などの DAW から NSF エクスポート

### 再生

```ruby
@audio.play("/usr/share/music/dq.nsf", track: 1)
```

`track:` は曲番号（1 始まり）。NSF には複数曲が含まれるため、ファイル名で曲を選んだ後、track 指定で個別曲を選べます。

### 制限

- バンク切替を多用する大型 NSF は読込に時間がかかる場合があります
- NSFe 拡張は未対応の機能あり

### サンプル

`flash/app/tool/nsf_player.app.rb` に NSF 再生 GUI のサンプルがあります（曲送り・トラック選択・一時停止 / 再開 を実装）。

## WAV / MP3

**未対応** です。FMSQ または NSF に変換してください。

## 直接合成 (`note_on` / `note_off`)

ファイルを使わずに、`FmrbAudio#note_on` で APU を直接駆動できます。リズムやセリフの効果音、ボタンクリック音などに向きます。

```ruby
@audio.note_on(0, 440, 10, 2, 0)   # 矩形波 1ch で A4
sleep_ms(200)
@audio.note_off(0)
```

詳細は [FmrbAudio ▸ note_on / note_off](../api/audio.md#音声合成-note_on--note_off) を参照。

## 関連

- [FmrbAudio](../api/audio.md)
- ピアノアプリ: `flash/app/game/piano.app.rb`
- 効果音 + BGM 例: `flash/app/game/flappy.rb`
- NSF プレイヤー: `flash/app/tool/nsf_player.app.rb`
