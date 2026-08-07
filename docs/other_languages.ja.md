# BASIC と MicroPython

Family mruby は Ruby を中心に作られていますが、動く言語は Ruby だけではありません。
2.0 の時点で 4 つあります。**Ruby**、**BASIC**、**MicroPython**、**Lua** です。

切り替えて使う「モード」ではありません。`.bas` も `.py` も、Ruby のアプリと並んで
ランチャーに出て、同じように起動し、互いに同時に動きます。

| 拡張子 | 実行系 | 備考 |
|---|---|---|
| `.rb` | PicoRuby | 中心となる言語。[API リファレンス](api/index.md) の全部が使えます |
| `.bas` | FMRuby BASIC | Family BASIC 互換。専用のテキスト画面とスプライトを持ちます |
| `.py` | MicroPython | Ruby と同じアプリの枠組み。Python アプリは同時に 1 本まで |
| `.lua` | Lua 5.4 | |

---

# FMRuby BASIC

ファミコン向けに出ていた **Family BASIC** との互換を目指して作った BASIC の処理系です。
画面もスプライトも音の命令も、そこに合わせてあります。

Ruby に BASIC 風の書き方を被せたものではありません。C++ で書いた独立した処理系で、
Family BASIC の意味論、28 x 24 文字の画面、`PLAY` / `BEEP` による音を持ちます。

## BASIC のプログラムを動かす

### エディタで書いて F5

一番早い方法です。**Editor** を開き、プログラムを書いて `F5` を押します。

- 名前がまだ無ければ保存先を聞かれます。**`/home` か `/app` の下**に保存してください
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
**ランチャーの中で右クリック**して読み直させます。

`.toml` が無いファイルも `F5` やシェルからは実行できます。その場合はファイル名が
アプリ名になります。

## 画面

Family BASIC の画面は **28 文字 x 24 行 (224 x 192 ドット)** で固定です。全画面で起動した
ときは画面の中央に置かれ、周りは黒で塗られます。元と同じ形です。

## 入っているもの

言語の中核、テキスト画面、自動で動くスプライト、コントローラ入力、`PLAY` と `BEEP`、
文字テーブルとパレットの選択、エラー処理、`SAVE` まで実装されています。`/app/basic` に
見本のプログラムが入っています (かな表示、よけゲーム、シューティング、迷路、音楽、
当たり判定)。

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
包んでいます。

見本は `/app/demo/python.app.py` です。

## 制限

MicroPython 自体の作りによる制限がいくつかあります。始める前に知っておいてください。

**Python アプリは同時に 1 本だけ**。MicroPython は VM の状態を全部グローバル変数に持って
いるので、mruby や Lua と違って 2 つ作れません。2 本目は起動の時点で断られ、「Another
Python app is already running.」と出ます。Ruby / Lua / BASIC のアプリとの同時実行には
制限はありません。

**import は組み込みのものだけ**。ファイルからの import は用意していないので、
`import mymodule` は失敗します。アプリは 1 ファイルで完結させてください。

使えるもの: `array` / `builtins` / `collections` / `gc` / `io` / `math` / `micropython` /
`struct` / `sys`。

**使えないもの**: `time` / `json` / `os` / `re` / `random` / `binascii` / `hashlib` /
`heapq` / `deflate`。これらは MicroPython の `extmod/` にあり、この構成には含まれて
いません。待つときは、眠るのではなく `on_update` の戻り値で間隔を指定してください。

**REPL もスレッドもありません。**

**`open()` は必ず失敗します**。ファイルの読み書きは Python 自身のファイル層ではなく、
枠組みを通します。

**GC のヒープは 1 アプリ 256KB 固定**です。

---

## どれを使うか

- **Ruby**: API を一通り使いたいとき (ネットワーク、MIDI、スプライト、周辺機器)。
  システムはこの言語を中心に設計されています
- **BASIC**: Family BASIC の感触が欲しいとき。当時の雑誌の投稿作品を打ち込むとき
- **MicroPython**: Python が手に馴染んでいるとき。ただし標準ライブラリは普段より
  かなり狭いと思ってください
- **Lua**: 小さくて速いスクリプトを書きたいとき

## 関連

- [標準アプリ](getting_started/default_apps.md) — 各言語の見本
- [アプリ設定ファイル (.toml)](file_formats/app_toml.md)
- [API リファレンス](api/index.md) — 他の言語が写している Ruby の API
