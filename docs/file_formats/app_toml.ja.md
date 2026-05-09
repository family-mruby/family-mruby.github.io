# アプリ設定ファイル (.toml)

Family mruby のアプリは、`.rb` （または `.lua` / `.bas`）の本体ファイルと **同名の `.toml` ファイル** をペアで持ちます。`.toml` でアプリ名やウィンドウ設定を指定します。

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

ペアで `/flash/app/<category>/` 以下に置きます（`category` は任意のサブディレクトリ。`demo`, `game`, `tool` 等が標準）。

| 言語 | 拡張子 |
|---|---|
| mruby | `.rb` |
| Lua | `.lua` |
| BASIC | `.bas` |

## キー一覧

| キー | 型 | 必須 | デフォルト | 用途 |
|---|---|---|---|---|
| `app_handle_name` | string | 推奨 | （なし） | アプリの内部ハンドル名。本体ファイル名のベースと一致させる |
| `app_screen_name` | string | 任意 | `nil` | 画面・ランチャー上に表示する名前 |
| `default_window_mode` | string | 任意 | `"window"` | `"window"` / `"fullwindow"` / `"fullscreen"` / `"background"` |
| `default_window_width` | integer | 任意 | `100` | ウィンドウ幅 (px) |
| `default_window_height` | integer | 任意 | `100` | ウィンドウ高さ (px) |
| `default_window_pos_x` | integer | 任意 | `50` | ウィンドウ左上 X 座標 |
| `default_window_pos_y` | integer | 任意 | `50` | ウィンドウ左上 Y 座標 |
| `resizable` | integer (0/1) | 任意 | `0` | `1` でユーザーがリサイズ可能 |
| `large_memory` | integer (0/1) | 任意 | `0` | `1` で大きいヒープ領域を確保（メモリを多く使うアプリ用） |
| `launcher_visible` | bool / string | 任意 | `true` | `false` または `0` でランチャーから非表示 |
| `icon` | string | 任意 | (拡張子別の既定) | アイコンファイルパス（`.icon` 形式） |

## ウィンドウモード

| モード | 動作 | サイズ・位置 |
|---|---|---|
| `window` | タイトルバー付きのウィンドウ | `default_window_*` を使用 |
| `fullwindow` | タイトルバー無しのフルウィンドウ | `default_window_*` を使用 |
| `fullscreen` | 画面全体を占有（他アプリは中断） | サイズは画面解像度、位置は `(0, 0)` 固定 |
| `background` | 画面表示なし（headless） | 不要 |

`fullscreen` の場合、`@user_area_*` は画面全体を指します。`window` ではタイトルバー（11px）と枠線を除いた部分が `@user_area_*` です。

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
# /flash/app/demo/hello.app.rb
class HelloApp < FmrbApp
  def on_create
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello!", FmrbGfx::WHITE)
    @gfx.present
  end

  def on_update; 500; end
end

HelloApp.new.start
```

## フルスクリーンサンプル

```toml
app_handle_name = "shooter"
app_screen_name = "Shooter"
default_window_mode = "fullscreen"
```

`fullscreen` ではウィンドウサイズや位置は無視されます。

## 大量メモリを必要とする場合

`large_memory = 1` を指定すると、起動時に確保される Ruby のヒープ領域が拡大されます。raycaster やビットマップを大量に扱うアプリで使います。

```toml
app_handle_name = "raycaster"
app_screen_name = "Raycaster"
default_window_mode = "fullscreen"
large_memory = 1
```

!!! warning
    `large_memory` を有効にすると 1 つのアプリが多くの PSRAM を消費するため、同時に動かせるアプリ数が減ります。必要なときだけ使ってください。

## アイコン指定

```toml
icon = "usr/share/icon/tetris.icon"
```

- ファイルは `/flash/usr/share/icon/` 以下に置きます
- 形式は **テキスト形式**。詳細は [画像・アイコンファイル](image_formats.md#アイコンファイル) を参照
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

## 完全な例（全機能）

```toml
# 内部ハンドル名（ファイル名のベースと一致させる）
app_handle_name = "myapp"

# 画面表示名
app_screen_name = "My App"

# ウィンドウモード
default_window_mode = "window"   # window / fullwindow / fullscreen / background

# ウィンドウサイズ（fullscreen / fullwindow では無視される）
default_window_width  = 200
default_window_height = 150
default_window_pos_x  = 20
default_window_pos_y  = 30

# リサイズ可能
resizable = 1

# 大きいヒープを確保
large_memory = 0

# ランチャー表示
launcher_visible = true

# カスタムアイコン
icon = "usr/share/icon/myapp.icon"
```

## アプリの配置先

```
/flash/app/
├── demo/      # サンプル・デモ
├── game/      # ゲーム
├── tool/      # ツール
└── (任意の名前)/
    ├── myapp.app.rb
    └── myapp.app.toml
```

ランチャーは `/flash/app` 直下のすべてのサブディレクトリを再帰的にスキャンして `.toml` を検出します。

## 関連

- アプリの作り方は [Hello World](../getting_started/hello_world.md) を参照
- アイコンファイルの作り方は [画像・アイコンファイル](image_formats.md#アイコンファイル) を参照
