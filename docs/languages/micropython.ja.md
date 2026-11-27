# MicroPython

`.py` のファイルも、他と同じアプリです。Ruby と同じ枠組みを使います。`FmrbApp` を継承し、
決められたメソッドを書き、起動します。Ruby と違い、Python のファイルは今も最後に
アプリを起動する行が要ります。

```python
class PythonDemoApp(FmrbApp):
    def on_create(self):
        Log.info("started on " + self.platform)
        self.clear_user_area()   # Ruby と同じく、(0, 0) は枠の内側の左上
        self.gfx.present()

    def on_update(self):
        return 500          # 次に呼ばれるまでのミリ秒

    def on_event(self, ev):
        if ev.get("type") == "mouse_up" and ev.get("button") == 1:
            self.next_page()

PythonDemoApp().start()
```

ウィンドウ・イベント・描画は組み込みの `_fmrb` から使えます。継承する `FmrbApp` がそれを
包んでいます。`FmrbApp` / `FmrbGfx` / `FmrbAudio` / `FmrbFile` / `SpriteImage` /
`SpriteInstance` / `Log` はアプリの名前空間に用意済みで、import は要りません。

見本は `/app/python/python.app.py` (PicoRuby デモの双子。ページを順に見せます) と
`/app/game/breakout/breakout.app.py` です。後者はゲーム 1 本まるごとで、動くものは
スプライト、動かないものはタイル、日本語の文字、主音源の曲と副音源の効果音が入って
います。ロボットエクスプローラーには Python 版の操縦もあります。

## Ruby との違い

| | Ruby | Python |
|---|---|---|
| 時刻 | `Machine.board_millis` | `ticks_ms()` か `FmrbApp.uptime_ms()` |
| 問いのメソッド | `FmrbFile.exist?(path)` | `FmrbFile.exist(path)` (`?` を落とします) |
| 文字列の長さ | `String#length` は文字数 | `len()` は**バイト数** |
| 別ファイル | `require "/app/..."` | `import mymodule` (アプリの隣か `/usr/lib/python`) |
| 別ファイルからの枠組み | 見えます | **見えません**。引数で渡します |
| タイマの callback | ブロック | 関数 (`self.set_timer(500, self.blink)`) |

アプリを複数のファイルに分けられますが、枠組みのクラスはアプリの名前空間にあり、
module の名前空間には入りません。

```python
# アプリ側
import mypanel
mypanel.draw(self, state)

# mypanel.py 側
def draw(app, state):
    app.gfx.draw_text(...)   # FmrbGfx を直接名指しせず、app 経由で使う
```

1 ファイルの大きさは 64KB までです。

## 音

内蔵音源は `FmrbAudio` から使います。形は Ruby と同じです。曲は主系、短い効果音は副系に
置くと、効果音で曲が止まりません。

```python
audio = FmrbAudio(self)
audio.load_fmsq_file(1, "/cache/app/mygame/bgm.fmsq")   # 先に sync_file で送る
audio.play_slot(1, FmrbAudio.MAIN)
audio.note_on(FmrbAudio.CH_PULSE2, 988, 12, 2, 0)       # 効果音は副系
```

効果音を止める時刻はフレーム数ではなく `ticks_ms()` の実時間で管理してください。重い
フレームがあると音が伸びます。

Ruby の `FmrbAudio` のほかのメソッドもあります。`stop`、`pause`、`resume`、`nsf_status()`
(dict か `None`)、`set_main_volume(percent)` (Ruby の `main_volume =`)、`play_wav(path)`、
`stop_wav()`、`load_fmsq(slot, data)` です。`Log.info` などは、Ruby と同じく行の頭にアプリの
名前を付けます。

## 描画

`FmrbGfx` には Ruby の描画のメソッドが全部あり、名前も引数の順も同じです。円弧・楕円・三角形を
含む図形、`get_pixel`、`blend_rect`、画像とマスク、表示範囲とスプライトの切り抜き、
`file_status`、`FmrbGfx.rgb_to_332` などです。省略できる引数を持つもの (`present`、`draw_text`、
`set_font`、`draw_image`、`draw_tile`、`sync_file` など) は、Python の既定値で受けます。

```python
self.gfx.set_font(FmrbGfx.FONT_JA, 12)
self.gfx.draw_text(4, 4, "こんにちは", FmrbGfx.BLACK)
self.gfx.draw_text(4, 20, "mixed 日本語", FmrbGfx.BLACK, mixed=True)
```

`clear` には既定値がないので、色を渡してください (`self.gfx.clear(FmrbGfx.BLACK)`)。
`canvas_id`・`origin_x`・`origin_y`・`area_width`・`area_height` は読み取り専用のプロパティです。

## 制限

MicroPython 自体の作りによる制限がいくつかあります。始める前に知っておいてください。

Python アプリは同時に 1 本だけです。MicroPython は VM の状態を全部グローバル変数に持って
いるので、mruby や Lua と違って 2 つ作れません。2 本目は起動の時点で断られ、「Another
Python app is already running.」と出ます。Ruby / Lua / BASIC のアプリとの同時実行には
制限はありません。

import できるのは組み込みのモジュールと、アプリの隣か `/usr/lib/python` にある `.py` です。
使えるものは `array` / `builtins` / `collections` / `gc` / `io` / `math` / `micropython` /
`struct` / `sys` / `random`。使えないものは `time` / `json` / `os` / `re` / `binascii` /
`hashlib` / `heapq` / `deflate` です。これらは MicroPython の `extmod/` にあり、この構成には
含まれていません。待つときは、眠るのではなく `on_update` の戻り値で間隔を指定してください。
(`random` は時計から種を取っているので毎回違う目が出ます。同じ展開を繰り返すなら
`random.seed(n)` を呼んでください。)

ファイルは、Ruby のアプリと同じモジュール `FmrbFile` で丸ごと読み書きします。
`FmrbFile.read(path)` はファイル全体を `bytes` で返し (無ければ `None`)、`write`・`append`・
`exist`・`size`・`delete`・`mkdir`・`list(dir)` もパスを取ります
([ファイル・I/O](../api/filesystem.md#パスで丸ごと読み書きする-fmrbfile) を参照)。少しずつ読む口は
ありません。`open()` はありますが、呼ぶと `OSError` になります。黙って存在しないより、
呼んで失敗するほうが分かるためです。`io.StringIO` などメモリ上のものは使えます。

整数は 64 ビットまで扱えるので、`FmrbApp.uptime_us()` は ESP32 で small int に収まる
約 18 分を過ぎても数え続けます。それより広い整数は `OverflowError` になります。

文字列はバイト列です。この構成には Unicode 文字列が入っていないので、`len("日本語")` は
9 で、添字もバイト単位です。表示幅が要るときは UTF-8 を走査する `FmrbGfx.text_width` を
使ってください。

REPL もスレッドもありません。タスクを作るのは OS の仕事で、ゲスト VM には渡していません。
アプリの中の並行処理はジェネレータで書けます。

GC のヒープは 1 アプリ 256KB 固定です。使い切ると `MemoryError` になり、捕まえなければ
traceback をログに出してアプリが終わります。Ruby のメモリ不足と同じ扱いです。

強制停止では `on_destroy` が走りません。Python の長いループの途中で止めると、バイトコードの
実行を巻き戻す形になるので、`destroy` も `on_destroy` も通りません。資源は C 側が回収するので
漏れませんが、後始末を `on_destroy` に頼らず、`on_update` の区切りで行ってください。Lua も
同じ性質です。

用意していないもの: タイルマップのクラス (`draw_tile` はあるので自分で並べます)、
`load_image` (`sync_file`・`create_image`・`draw_image` で書きます)、動画、`GfxBlock`、
追加のキャンバス、p5 互換層、マイク入力と外部への MIDI 送出。
