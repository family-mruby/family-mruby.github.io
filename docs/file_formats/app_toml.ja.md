# アプリ設定ファイル (.app.toml)

!!! note
    このページはアプリごとの設定です。システム自体の設定 (`/etc/system_conf.toml` と
    `/etc/wifi.toml`) は [システム設定](system_conf.md) を参照してください。

Family mruby のアプリは、`.app.rb` の本体ファイルと 同名の `.app.toml` ファイル をペアで持ちます。`.app.toml` でアプリ名やウィンドウ設定を指定します。Ruby のアプリは、同じキーを `.rb` 先頭の `#---fmrb` コメントに書くこともでき ([後述](#rb-ファイルの中の記述))、両方を使うこともできます。

## ファイル名のルール

```
<app_handle_name>.app.rb       # アプリ本体
<app_handle_name>.app.toml     # 設定ファイル
```

例:

```
my_clock.app.rb
my_clock.app.toml
```

ペアで `/app/<category>/` 以下に置きます（`category` は任意のサブディレクトリ。`demo`, `game`, `tool` 等が標準）。


!!! note "`.toml` が要るのはどの場合か"
    ファイルを直接起動するとき — ファイル管理から実体をダブルクリックするとき — は同名の
    `.app.toml` が必要です。無いと起動が断られ、理由がデスクトップに出ます。エディタの `F5`
    やシェルからは `.toml` が無くても動き、その場合はファイル名がアプリ名になります。

| 言語 | 拡張子 |
|---|---|
| mruby | `.app.rb` |
| Lua | `.app.lua` |
| BASIC | `.app.bas` |
| MicroPython | `.app.py` |

## キー一覧

| キー | 型 | 必須 | デフォルト | 用途 |
|---|---|---|---|---|
| `app_handle_name` | string | 任意 | （なし） | ハンドル名。慣例で本体ファイル名のベースと一致させる。システムは読まない |
| `app_screen_name` | string | 任意 | ファイル名 | 画面・ランチャー上に表示する名前 |
| `class` | string | 任意 | （なし） | 起動するクラス (`"MyApp"`)。無ければ、ファイルが定義した `FmrbApp` の子クラス 1 つを起動する (ほかの子の親になっているものは数えない)。2 つ以上定義するファイルでは必要 |
| `default_window_mode` | string | 任意 | `"window"` | `"window"` / `"fullscreen"` / `"background"` |
| `default_window_width` | integer | 任意 | `100` | ウィンドウ幅 (px) |
| `default_window_height` | integer | 任意 | `100` | ウィンドウ高さ (px) |
| `default_window_pos_x` | integer | 任意 | `50` | ウィンドウ左上 X 座標 |
| `default_window_pos_y` | integer | 任意 | `50` | ウィンドウ左上 Y 座標 |
| `resizable` | integer (0/1) | 任意 | `0` | `1` でユーザーがリサイズ可能 |
| `min_window_width` | integer | 任意 | `0` | ユーザーが縮められる下限の幅。`0` ならシステム既定 (64) |
| `min_window_height` | integer | 任意 | `0` | ユーザーが縮められる下限の高さ。`0` ならシステム既定 (64) |
| `large_memory` | integer (0/1) | 任意 | `0` | `1` で大きいヒープ領域を確保（メモリを多く使うアプリ用） |
| `launcher_visible` | bool / string | 任意 | `true` | `false` または `0` でランチャーから非表示 |
| `rounded_corners` | bool / string | 任意 | `true` | `false` でウィンドウ角の透過処理を無効化（fps を稼ぎたいときの最適化） |
| `app_screen_name_<lang>` | string | 任意 | （なし） | 言語別の表示名。例: `app_screen_name_ja`。システムの言語と一致するときに使われ、無ければ `app_screen_name` |
| `task_stack_kb` | integer | 任意 | 16 | アプリのタスクが使う C スタックの KB 数。スタック保護の例外が出るときだけ上げます。16〜64 に収められます |
| `fullscreen_switchable` | integer (0/1) | 任意 | `0` | 全画面アプリを `Ctrl` + `Tab` で退避・復帰させてよいなら `1`（`on_resume` で描画面を作り直す必要があります） |
| `fullscreen_hires` | bool | 任意 | `false` | 全画面の間だけ 640x360 で動かしてよい (Modern とブラウザ版)。大きさは `on_resize` で届く |
| `window_frame` | string | 任意 | `"normal"` | `"none"` で枠・タイトルバー・閉じるボタンの無いウィンドウ ([後述](#枠なしのウィンドウ)) |
| `window_drag` | string | 任意 | `"title"` (枠つき)、`"anywhere"` (枠なし) | ウィンドウをどこで掴んで動かすか: `"title"`・`"anywhere"`・`"none"` |
| `single_instance` | bool | 任意 | `false` | 同じファイルの 2 つ目の起動を断る |
| `exclusive_group` | string | 任意 | （なし） | 同じ名前 (15 バイトまで) を書いたアプリが動いている間は起動を断る。1 つしかない資源を取り合うアプリ向け |
| `movable` | bool | 任意 | `false` | イメージに書いて別の端末へ運んでよい ([動いているアプリを運ぶ](../api/fmrb_app.md#動いているアプリを運ぶ)) |
| `requires` | array | 任意 | （なし） | 運べるアプリが無いと続けられないメソッドの名前。それが無いビルドへは移らない |
| `screens` / `needs_pointer` | array / bool | 任意 | （なし） | Linux 版のキーボード専用のデスクトップ (320x170) 向け。描ける画面の形 (`["426x240", "320x170"]`) と、マウスなしで使えるなら `needs_pointer = false`。最初の `[表]` より前に書く |
| `icon` | string | 任意 | (拡張子別の既定) | アイコンファイルパス（`.icon` 形式） |

## ウィンドウモード

| モード | 動作 | サイズ・位置 |
|---|---|---|
| `window` | タイトルバー付きのウィンドウ | `default_window_*` を使用 |
| `fullscreen` | 画面全体を占有（他アプリは中断） | サイズは画面解像度、位置は `(0, 0)` 固定 |
| `background` | headless: 窓を持たずに裏で動く (`@gfx` は `nil`) | 不要 |

`fullscreen` の場合、アプリの区画は画面全体です。`window` ではタイトルバー（11px）と枠線の内側です。どちらでも `@gfx` はその左上を (0, 0) として描き、大きさは `@user_area_width` × `@user_area_height` です。

全画面のアプリは `fullscreen_switchable = 1` を宣言できます。宣言すると `Ctrl` + `Tab` で
退避して、後から同じ状態に戻れるようになります。
[デスクトップ > アプリの切り替え](../getting_started/desktop.md#アプリの切り替え) を参照してください。

## 最小サンプル

```toml
app_handle_name = "hello"
app_screen_name = "Hello"
default_window_mode = "window"
default_window_width = 160
default_window_height = 80
default_window_pos_x = 20
default_window_pos_y = 30
```

対応する Ruby ファイル:

```ruby
# /app/demo/hello.app.rb
class HelloApp < FmrbApp
  def on_create
    clear_user_area
    @gfx.draw_text(4, 4, "Hello!", theme_fg)
    @gfx.present
  end

  def on_update; 500; end
end
```

ファイルの末尾に起動のコードは要りません。ファイルが定義した `FmrbApp` の子クラスをランタイムが
起動します。

## .rb ファイルの中の記述

同じキーは `.rb` 先頭のコメントにも書けるので、1 ファイルだけのアプリなら `.app.toml` は
要りません。囲みは先頭 512 バイトの中、最初のコードの行より前に置き、各行の先頭に `# ` を
付けた TOML として書きます。

```ruby
#---fmrb
# app_screen_name = "Hello"
# default_window_width = 200
# default_window_height = 120
#---
class HelloApp < FmrbApp
```

- 両方あるときはキーごとに合わせ、**両方にあるキーは `.app.toml` が勝ちます**。コメントに
  既定を書き、`.app.toml` で一部だけ上書きできます。
- この形で読むのは `.rb` だけです (`.lua`・`.bas`・`.py` はコメントの記号が違うため)。
- コメントだけの `.app.rb` もランチャーに出ます。
- App Store で配るアプリには `.app.toml` が要ります (`app_id` など導入のためのキーはそこから読まれます)。
- Ruby からは `FmrbApp.app_meta(path)` で、合わせた記述を文字列の Hash として読めます。

## 枠なしのウィンドウ

```toml
window_frame = "none"
```

アバターやマスコットのための、枠・タイトルバー・閉じるボタンの無いウィンドウです。アプリの
区画はウィンドウ全体で、地は透けるので、アプリが描いた所だけが見えます。ウィンドウはどこを
掴んでも動かせ (`window_drag = "anywhere"`、ここでの既定)、動かさずに離せばクリック、動かさずに
1 秒押し続けると長押しです。右クリックと長押しは `on_frameless_right_click(ev)` を呼び、既定では
ウィンドウのメニュー (送る・読み直し・閉じる) が出ます。Ctrl+Q でも閉じられます。

既定ではウィンドウの四角全体がクリックを受けます。描いていない所のクリックを後ろへ通すには、
当たる形を申告します: `set_hit_shape([[x, y, w, h], ...])`、
`set_hit_mask(hit_mask_from_art(rows, transparent: ".", scale: 3), x, y)`、
`add_hit_sprite(sprite)`。その外の押下は後ろのウィンドウに届きます。見本は
`/app/demo/avatar.app.rb` です。

## フルスクリーンアプリのサンプル

```toml
app_handle_name = "shooter"
app_screen_name = "Shooter"
default_window_mode = "fullscreen"
```

`fullscreen` ではウィンドウサイズや位置は無視されます。

## 大量メモリを必要とする場合

`large_memory = 1` を指定すると、起動時に大きいメモリプールスロットが選択されます。
現在は１スロットのみ存在してます。

## アイコン指定

```toml
icon = "usr/share/icon/blockgame.icon"
```

- ファイルは `/usr/share/icon/` 以下に置きます
- 形式は テキスト形式。詳細は [画像・アイコンファイル](image_formats.md#アイコンファイル-icon) を参照
- `icon` を省略すると、本体ファイルの拡張子に応じた既定アイコンが使われます (`.rb` → ruby、`.lua` → lua、`.bas` → basic)

## ランチャーから隠す

開発中・デバッグ用アプリは `launcher_visible = false` で隠せます。

```toml
launcher_visible = false
```

## リサイズ可能なウィンドウ

```toml
resizable = 1
```

`1` でリサイズ可能。基底クラスは `on_resize(w, h)` を呼んでくれるので、サブクラスでオーバーライドして再描画してください。

## アプリの配置先

```
/app/
├── demo/                   # サンプル・デモ
├── game/                   # ゲーム
│   └── rpg_demo/           # アプリと一緒にアセットを置く形式も可
│       ├── rpg_demo.app.rb
│       ├── rpg_demo.app.toml
│       ├── world.bmp
│       └── world.map.json
├── tool/                   # ツール
└── (任意の名前)/
    ├── myapp.app.rb
    └── myapp.app.toml
```

ランチャーは `/app` 直下のサブディレクトリをスキャンして `.app.toml` を検出します。さらに 1 階層下 （`/app/<category>/<bundle>/*.app.toml`）もスキャン対象なので、画像・マップなどのアセットをアプリと同じディレクトリにまとめる形式も有効です。

!!! note "スキャンは起動時のみ"
    アプリ一覧は システム起動時に 1 回だけ スキャンされます。`create_app` や BLE で新規アプリを追加した後は、ランチャーを開いて右クリック で再スキャン、もしくは本体を再起動してください（[Hello World ▸ ランチャーで反映する](../getting_started/hello_world.md#ランチャーに反映する) 参照）。

## 関連

- アプリの作り方は [Hello World](../getting_started/hello_world.md) を参照
- アイコンファイルの作り方は [画像・アイコンファイル](image_formats.md#アイコンファイル-icon) を参照
