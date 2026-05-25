# 音声ファイルフォーマット

!!! note
    内容編集中です


Family mruby が対応する音声ファイル形式と、その作成・変換方法を説明します。

| 形式 | 用途 | API |
|---|---|---|
| FMSQ | 短い BGM / SE のシーケンスデータ。スロットにロードして再生 | `FmrbAudio#load_fmsq`, `play_slot` |
| NSF | ファミコン音楽（NES Sound Format） | `FmrbAudio#play(path, track:)` |

## FMSQ

FMSQ (Family mruby Sequence) は NES APU 互換 の音楽データを記述する独自フォーマットです。短い効果音や BGM ループに向いています。

レジスタの意味は以下参照。

[https://www.nesdev.org/wiki/APU_registers](https://www.nesdev.org/wiki/APU_registers)

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

### 命令コード一覧

`cc` = チャンネル番号 (00=Pulse1, 01=Pulse2, 10=Triangle, 11=Noise)、
`aaaaa` = `$4000` からのレジスタオフセット (0x00-0x17)。

| ビットパターン | 命令 | 後続バイト | 合計サイズ |
|---|---|---|---|
| `0xxxxxxx` | WAIT (1-128フレーム) | 0 | 1 |
| `10cc0000` | NOTE_ON | チャンネル別 2-4 | 3-5 |
| `10cc0001` | NOTE_OFF | 0 | 1 |
| `10cc0010` | PARAM | MASK + 可変 | 2 以上 |
| `110aaaaa` | REG_WRITE (`$4000`+aaaaa) | 1 (DATA) | 2 |
| `11100000` | DPCM_PLAY | 3 (RATE_FLAGS, ADDR, LENGTH) | 4 |
| `11100001` | DPCM_STOP | 0 | 1 |
| `11100010` | DPCM_RAW | 1 (VALUE) | 2 |
| `11111110` | END | 0 | 1 |
| `11111111` | LOOP | 2 (OFFSET) | 3 |

APU エミュレータ側の制限: 現状の APU エミュレータ側ではDPCMの機能がサポートされてない

#### WAIT命令

```
0xxxxxxx
```

- 上位1ビット = 0 -> WAIT
- 下位7ビット = 待ちフレーム数 - 1

| 値 | 意味 |
|---|---|
| 0x00 | 1フレーム待ち |
| 0x01 | 2フレーム待ち |
| ... | ... |
| 0x7F | 128フレーム待ち |

---

#### チャンネル命令 (NOTE_ON / NOTE_OFF / PARAM)

`10ccxxxx` 形式の高レベルコマンド。`cc` がチャンネル（Pulse1=0, Pulse2=1, Triangle=2, Noise=3）、下位4ビットがサブコマンド。
NOTE_ON / NOTE_OFF は内部で `$4015`（Status）の対応ビットも更新する。

#### NOTE_ON

`10cc0000` 後続バイトはチャンネル別:

| チャンネル | 後続バイト | 書き込み順 |
|---|---|---|
| Pulse1 / Pulse2 | `TIMER_LO`, `TIMER_HI`, `VOL_ENV`, `SWEEP` (4 バイト) | `VOL` → `SWEEP` → `LO` → `HI` |
| Triangle | `TIMER_LO`, `TIMER_HI`, `LINEAR` (3 バイト) | `LINEAR` → `LO` → `HI` |
| Noise | `PERIOD_MODE`, `VOL_ENV` (2 バイト) | `VOL` → `LO` |

#### NOTE_OFF

`10cc0001` 後続バイトなし。`$4015` の該当チャンネルビットをクリアするのみ（APUレジスタ自体は変更しない）。

#### PARAM

`10cc0010 [MASK] [DATA...]`

マスクで指定したサブパラメータだけを差分更新する。マスクビットと後続データは以下:

#### Pulse PARAM (Pulse1 / Pulse2)

| mask bit | 後続データ | 書き込み先 |
|---|---|---|
| `0x01` (TIMER) | `LO`, `HI` (2 バイト) | `$4002/3` または `$4006/7` |
| `0x02` (VOL)   | `VOL_ENV` (1 バイト) | `$4000` または `$4004` |
| `0x04` (SWEEP) | `SWEEP` (1 バイト) | `$4001` または `$4005` |

#### Triangle PARAM

| mask bit | 後続データ | 書き込み先 |
|---|---|---|
| `0x01` (TIMER)  | `LO`, `HI` (2 バイト) | `$400A/B` |
| `0x02` (LINEAR) | `LINEAR` (1 バイト) | `$4008` |

#### Noise PARAM

| mask bit | 後続データ | 書き込み先 |
|---|---|---|
| `0x01` (PERIOD) | `PERIOD_MODE` (1 バイト) | `$400E` |
| `0x02` (VOL)    | `VOL_ENV` (1 バイト) | `$400C` |

マスクの bit 順に後続バイトを読み出して書き込む。指定されていないビットの後続バイトは存在しない。

#### REG_WRITE命令

```
110aaaaa [DATA]
```

APUレジスタへの直接書き込み。NSFのAPUレジスタ操作を順序・値ともに完全に保持する。

- `aaaaa`: $4000からのオフセット (0-23)
- `DATA`: 書き込む値 (1バイト)
- 合計: 2バイト/書き込み

| offset (aaaaa) | APUレジスタ | 内容 |
|----------------|-----------|------|
| 0x00 | $4000 | Pulse1 Volume/Envelope/Duty |
| 0x01 | $4001 | Pulse1 Sweep |
| 0x02 | $4002 | Pulse1 Timer Low |
| 0x03 | $4003 | Pulse1 Timer High + Length |
| 0x04 | $4004 | Pulse2 Volume/Envelope/Duty |
| 0x05 | $4005 | Pulse2 Sweep |
| 0x06 | $4006 | Pulse2 Timer Low |
| 0x07 | $4007 | Pulse2 Timer High + Length |
| 0x08 | $4008 | Triangle Linear Counter |
| 0x0A | $400A | Triangle Timer Low |
| 0x0B | $400B | Triangle Timer High + Length |
| 0x0C | $400C | Noise Volume/Envelope |
| 0x0E | $400E | Noise Period + Mode |
| 0x0F | $400F | Noise Length |
| 0x10 | $4010 | DMC Frequency/Flags |
| 0x11 | $4011 | DMC DAC (7bit) |
| 0x12 | $4012 | DMC Sample Address |
| 0x13 | $4013 | DMC Sample Length |
| 0x15 | $4015 | Status (Channel Enable) |

### 参考

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

- 自分で作る場合は [FamiStudio](https://famistudio.org/) などの DAW から NSF エクスポート

### 再生

```ruby
@audio.play("/usr/share/music/music.nsf", track: 1)
```

`track:` は曲番号（1 始まり）。NSF には複数曲が含まれるため、ファイル名で曲を選んだ後、track 指定で個別曲を選べます。

### 制限

- 再生できないNSFファイルもあります

### サンプル

`flash/app/tool/nsf_player.app.rb` に NSF 再生 GUI のサンプルがあります（曲送り・トラック選択・一時停止 / 再開 を実装）。

## WAV / MP3

未対応 です。FMSQ または NSF に変換してください。

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
