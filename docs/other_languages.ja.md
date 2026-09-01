# MicroPython と BASIC

Family mruby は Ruby を中心に作られていますが、動く言語は Ruby だけではありません。
4 つあります。Ruby、MicroPython、BASIC、Lua です。

切り替えて使う「モード」ではありません。`.py` も `.bas` も、Ruby のアプリと並んで
ランチャーに出て、同じように起動し、互いに同時に動きます。

<div align="center">
  <img src="/images/tab5_three_vms.png" width="620" alt="1 つのデスクトップに 3 つの窓。Ruby、Lua、Python のデモが同時に動いている">
  <br><em>VM が 3 つ同時に動いているところ。Ruby、Lua、MicroPython が、それぞれ別の窓と別のヒープで動きます</em>
</div>

| 拡張子 | 実行系 | 備考 |
|---|---|---|
| `.rb` | PicoRuby | 中心となる言語。[API リファレンス](api/index.md) の全部が使えます |
| `.py` | MicroPython | Ruby と同じアプリの枠組み。窓・描画・スプライト・音。同時に 1 本だけ |
| `.bas` | FMRuby BASIC | Family BASIC 互換。専用のテキスト画面とスプライトを持ちます |
| `.lua` | Lua 5.4 | |

---

# MicroPython

`.py` のファイルも、他と同じアプリです。Ruby と同じ枠組みを使います。`FmrbApp` を継承し、
決められたメソッドを書き、起動します。

```python
class PythonDemoApp(FmrbApp):
    def on_create(self):
        Log.info("started on " + self.platform)
        self.draw_window_frame()

    def on_update(self):
        return 500          # 次に呼ばれるまでのミリ秒

    def on_event(self, ev):
        super().on_event(ev)
        if ev.get("type") == "mouse_up" and ev.get("button") == 1:
            self.next_page()

app = PythonDemoApp()
app.start()
```

窓・イベント・描画は組み込みの `_fmrb` から使えます。継承する `FmrbApp` がそれを
包んでいます。`FmrbApp` / `FmrbGfx` / `FmrbAudio` / `SpriteImage` / `SpriteInstance` /
`Log` はアプリの名前空間に用意済みで、import は要りません。

見本は `/app/python/python.app.py` (PicoRuby デモの双子。ページを順に見せます) と
`/app/game/breakout/breakout.app.py` です。後者はゲーム 1 本まるごとで、動くものは
スプライト、動かないものはタイル、日本語の文字、主音源の曲と副音源の効果音が入って
います。ロボットエクスプローラーには Python 版の操縦もあります。

## Ruby との違い

| | Ruby | Python |
|---|---|---|
| 時刻 | `Machine.board_millis` | `ticks_ms()` |
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

ファイルは読めますが書けません。`open()` はありますが、呼ぶと `OSError` になります。
黙って存在しないより、呼んで失敗するほうが分かるためです。読むには
`_fmrb.read_file(path)` (丸ごと `bytes` で返します。64KB まで)、大きさだけなら
`_fmrb.file_size(path)` を使います。`io.StringIO` などメモリ上のものは使えます。

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

用意していないもの: タイルマップのクラス (`draw_tile` はあるので自分で並べます)、画像の
マスク、`GfxBlock` などの描画最適化、円弧、`get_pixel`、追加のキャンバス、p5 互換層、
マイク入力と外部への MIDI 送出。

---

# FMRuby BASIC

ファミコン向けに出ていた Family BASIC との互換を目指して作った BASIC の処理系です。
画面もスプライトも音の命令も、そこに合わせてあります。

Ruby に BASIC 風の書き方を被せたものではありません。C++ で書いた独立した処理系で、
Family BASIC の意味論、28 x 24 文字の画面、`PLAY` / `BEEP` による音を持ちます。

## BASIC のプログラムを動かす

### エディタで書いて F5

一番早い方法です。Editor を開き、プログラムを書いて `F5` を押します。

- 名前がまだ無ければ保存先を聞かれます。`/home` か `/app` の下に保存してください
  (それ以外の場所のものは実行できません)
- 動いているプログラムからエディタへ戻るのは `Ctrl` + `Q` です。全画面のものからも
  これで抜けられます。戻ればそのまま `F5` で動かし直せます

### ランチャーに並べる

`.bas` と同じ名前の `.toml` を隣に置きます。

```
/app/basic/mygame.app.bas
/app/basic/mygame.app.toml
```

```toml
app_handle_name = "mygame"
app_screen_name = "My Game"
app_screen_name_ja = "マイゲーム"
# .bas は既定で全画面。窓にしたいときだけ書きます:
#default_window_mode = "window"
```

ランチャーの一覧はデスクトップの起動時に作られるので、後から置いたものを出すには
ランチャーの中で右クリックして読み直させます。

`.toml` が無いファイルも `F5` やシェルからは実行できます。その場合はファイル名が
アプリ名になります。

## 画面

Family BASIC の画面は 28 文字 x 24 行 (224 x 192 ドット) で固定です。全画面で起動した
ときは画面の中央に置かれ、周りは黒で塗られます。元と同じ形です。

<div align="center">
  <img src="/images/tab5_basic_maze.png" width="620" alt="全画面で動く maze のサンプル。28x24 の文字画面が黒の中央に置かれている">
  <br><em><code>/app/basic</code> の <code>maze</code>。全部が文字で描かれています</em>
</div>

## 入っているもの

言語の中核、テキスト画面、自動で動くスプライト、コントローラ入力、`PLAY` と `BEEP`、
文字テーブルとパレットの選択、エラー処理、`SAVE` まで実装されています。`/app/basic` には
見本のプログラムが 3 つ (シューティング、迷路、音楽) と、BASIC のプログラムを普通の
アプリとして起動する BASIC デモが入っています。

## 互換性について

Family BASIC (V3) との違いは全件を洗い出して、解決済み・実装差として確定・データ待ち・
対象外に分類してあります。知っておくとよい「意図的な違い」を挙げます。

- `IF 式 THEN 文` は、条件が成立しないとき後続の `:` 文も飛ばします (Microsoft 系の挙動)
- `PLAY` は非同期です。音を鳴らしながらプログラムが進みます
- `LOAD` / `LOAD?` はプログラムの中では何もしません (元は直接モードの命令のため)。
  `SAVE` は実装しています
- `Ctrl` + `Q` で実行中のプログラムを止められます。元には全画面から抜ける手段が
  ありませんでした

## この MML は MIDI の MML とは別物です

BASIC の `PLAY` は Family BASIC の MML の書き方です。[MIDI](api/midi.md) の層には
Ruby アプリ用の別の MML があります。実装も書き方も別なので、片方の文字列をもう片方に
写しても鳴りません。

---

## どれを使うか

- **Ruby**: API を一通り使いたいとき (ネットワーク、MIDI、スプライト、周辺機器)。
  システムはこの言語を中心に設計されています
- **MicroPython**: Python が手に馴染んでいるとき。ただし標準ライブラリは普段より
  かなり狭く、同時に動かせるのは 1 本だけです
- **BASIC**: Family BASIC の感触が欲しいとき。当時の雑誌の投稿作品を打ち込むとき
- **Lua**: 小さくて速いスクリプトを書きたいとき

## 関連

- [標準アプリ](getting_started/default_apps.md) — 各言語の見本
- [アプリ設定ファイル (.toml)](file_formats/app_toml.md)
- [API リファレンス](api/index.md) — 他の言語が写している Ruby の API
