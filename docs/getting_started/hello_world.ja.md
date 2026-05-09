# Hello World

「Hello, mruby!」と画面に表示する最小の **GUI アプリ** を動かして、自分のアプリを書く流れを掴みます。

!!! note "このページは GUI アプリのサンプルです"
    Family mruby のアプリは大きく分けて、画面に描画する **GUI アプリ** と、画面を持たない **headless アプリ**（バックグラウンドで動く処理）があります。このページでは GUI アプリの最小例を扱います。

## 最小のアプリ構成

Family mruby のアプリは **2 つのファイル** をペアで作ります。

```
hello.app.rb       # アプリ本体（Ruby）
hello.app.toml     # 設定ファイル
```

両方を `/flash/app/<好きなディレクトリ>/` 以下に置くと、ランチャーに自動的に表示されます。

## Step 1: 文字を表示するだけの最小アプリ

まずはウィンドウ管理のことを考えず、**画面に文字を出すだけ** のアプリから始めます。

### `.rb` ファイル

```ruby
# hello.app.rb
class HelloApp < FmrbApp
  def on_create
    @gfx.clear(FmrbGfx::BLACK)
    @gfx.draw_text(0, 0, "Hello, mruby!", FmrbGfx::WHITE)
    @gfx.present
  end
end

HelloApp.new.start
```

何が起きているか:

| コード | 役割 |
|---|---|
| `class HelloApp < FmrbApp` | `FmrbApp` を継承するアプリクラス |
| `on_create` | 起動時に 1 回呼ばれる初期化処理 |
| `@gfx.clear(...)` | キャンバス全体を黒で塗りつぶし |
| `@gfx.draw_text(0, 0, ...)` | ウィンドウ左上 (0, 0) に文字を描画 |
| `@gfx.present` | バッファを画面に反映（**必須**） |
| `HelloApp.new.start` | アプリを実行 |

`on_update` は省略しています（基底クラスの実装が継承され、330ms ごとに何もせず呼ばれるだけになります）。詳細は [FmrbApp](../api/fmrb_app.md) を参照。

!!! warning "このサンプルではウィンドウを閉じられません"
    `@gfx.clear` は **キャンバス全体（タイトルバーを含む）** を塗りつぶします。`FmrbApp` の基底クラスが起動時に描いてくれるタイトルバーと閉じるボタンが上書きされて消えてしまうため、**画面上に閉じるボタンが見えなくなります**。
    
    アプリを終了するには電源を入れ直すか、別のアプリから kill する必要があります。実用的に作るなら次の Step 2 に進んでください。

### `.toml` ファイル

同じディレクトリに `hello.app.toml` を作成:

```toml
app_handle_name = "hello"
app_screen_name = "Hello"
default_window_mode = "window"
default_window_width = 160
default_window_height = 60
default_window_pos_x = 30
default_window_pos_y = 40
```

| キー | 用途 |
|---|---|
| `app_handle_name` | 内部ハンドル名（`.rb` ファイル名のベースと一致させる） |
| `app_screen_name` | ランチャーやタイトルバーの表示名 |
| `default_window_mode` | `"window"` / `"fullwindow"` / `"fullscreen"` / `"background"` |
| `default_window_width/height` | ウィンドウサイズ (px) |
| `default_window_pos_x/y` | ウィンドウ左上座標 |

全キーの説明は [アプリ設定ファイル (.toml)](../file_formats/app_toml.md) を参照。

## Step 2: ウィンドウ枠を表示する

実用的な GUI アプリにするには、**タイトルバーと閉じるボタンを残す** 必要があります。コツは 2 つ:

1. 画面全体ではなく **アプリの描画可能領域 (user area) だけ** を塗りつぶす（タイトルバーや枠線を消さない）
2. 描画後に **`draw_window_frame` を呼ぶ**（基底クラスが用意したタイトルバー描画を再実行）

```ruby
# hello.app.rb (Step 2)
class HelloApp < FmrbApp
  def on_create
    redraw
  end

  def on_update
    500
  end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)   # user area を白で塗りつぶし
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello, mruby!", FmrbGfx::BLACK)
    draw_window_frame                  # タイトルバー・枠線を再描画
    @gfx.present
  end
end

HelloApp.new.start
```

| 変更点 | 理由 |
|---|---|
| `@gfx.clear(FmrbGfx::BLACK)` → `clear_user_area(FmrbGfx::WHITE)` | 描画範囲を user area に限定し、タイトルバーを保護。背景は白に |
| 文字色を `WHITE` → `BLACK` | 白背景に合わせて見やすく |
| `draw_window_frame` の追加 | 基底クラスが用意したフレームを再描画。閉じるボタンが現れる |
| 描画ロジックを `redraw` に分離 | 後で再描画しやすくするための整理 |

!!! tip "`clear_user_area(color)` ヘルパー"
    `FmrbApp` には `clear_user_area(color = FmrbGfx::BLACK)` というヘルパーが用意されており、`@gfx.fill_rect(@user_area_x0, @user_area_y0, @user_area_width, @user_area_height, color)` の糖衣として使えます。色を指定したい場合は `clear_user_area(FmrbGfx::BLUE)` のように渡してください。

これで:

- タイトルバー右上の **× ボタンをクリック** でアプリを終了できる
- タイトルバーを **右クリック** で再ロード（`request_reload`）できる
- 描画範囲は `@user_area_*` の中に収まり、枠と干渉しない

!!! tip "@user_area_* とは"
    `@user_area_x0`, `y0`, `x1`, `y1`, `width`, `height` はタイトルバーや枠線を除いた **アプリが自由に描いてよい領域** の座標です。`@fullscreen` の場合は画面全体を指します。詳細は [FmrbApp ▸ 主要インスタンス変数](../api/fmrb_app.md#主要インスタンス変数) を参照。

## ファイルを基板に送る

PC で書いた `hello.app.rb` と `hello.app.toml` を基板の `/flash/app/myapps/` 以下に転送します。

転送方法は **BLE ファイルマネージャ** が標準です。詳細は [BLE ファイルマネージャ](ble_file_manager.md) を参照。

転送後の配置イメージ:

```
/flash/app/
├── demo/
├── game/
├── tool/
└── myapps/         ← 自分で作るディレクトリ
    ├── hello.app.rb
    └── hello.app.toml
```

!!! note
    新しいディレクトリを作る場合は、BLE ファイルマネージャの「新規ディレクトリ」または `mkdir` 操作で先に作っておきます。

## 起動して画面に表示する

1. ファイル転送が完了したら、基板を **再起動** するか、デスクトップに戻る
2. ランチャーをスクロールすると新しいアプリ「Hello」のアイコンが表示
3. アイコンをダブルクリック（またはマウスでクリック → Enter）
4. 画面に「Hello, mruby!」と表示されます

Step 2 の版なら、タイトルバー右の **× ボタン** をクリックでアプリを終了できます。

## 修正してリロードする

アプリを更新したいときは:

1. PC で `hello.app.rb` を書き換え
2. BLE ファイルマネージャで再アップロード（同じ名前で上書き）
3. アプリのタイトルバーを **右クリック** すると、確認ダイアログが出てリロード

ファイル単位の再起動なので、再起動を待たずに開発できます。

## ショートカット: `create_app` でひな型を生成する

毎回 `.rb` と `.toml` を手書きするのは面倒です。Family mruby のシェルには **`create_app`** コマンドがあり、Step 2 ベースのひな型一式を一発で生成できます。

### 使い方

ランチャーから **Shell** を起動して、以下を実行:

```
> create_app my_clock
Created: /app/usr/my_clock.app.rb
Created: /app/usr/my_clock.app.toml
Tip: edit it with `edit /app/usr/my_clock.app.rb`
```

これだけで:

- `/flash/app/usr/my_clock.app.rb` — Step 2 ベース（`clear_user_area` + `draw_window_frame` 入り、全 `on_*` ライフサイクルメソッドのひな型あり）
- `/flash/app/usr/my_clock.app.toml` — 標準サイズのウィンドウ設定

の 2 ファイルが作られ、ランチャーにすぐ登場します。

### 命名規則

`<name>` は **小文字英数字とアンダースコア** のみ、先頭は英字。例:

| 入力 | 生成されるクラス名 | 表示名 |
|---|---|---|
| `hello` | `HelloApp` | `Hello` |
| `my_clock` | `MyClockApp` | `My Clock` |
| `snake01` | `Snake01App` | `Snake01` |

snake_case → CamelCase + `App` でクラス名、Title Case で表示名 (`app_screen_name`) が自動生成されます。

### 配置先

ひな型は **`/flash/app/usr/`**（自動作成）に置かれます。`demo`/`game`/`tool` などのカテゴリと混ぜたくない、ユーザー作成アプリ専用のディレクトリです。

### 既存ファイルの保護

同名のファイルが既にあると **エラーで止まります**（誤って上書きしないため）。続けるには `rm` で削除するか、別の名前を選んでください。

### テンプレートのカスタマイズ

ひな型ファイル本体は **`/flash/usr/share/template/`** に置いてあります:

```
/flash/usr/share/template/app.rb.template
/flash/usr/share/template/app.toml.template
```

このファイルを直接編集すると、以後の `create_app` の出力を自分好みにカスタマイズできます。プレースホルダ:

| プレースホルダ | 意味 |
|---|---|
| `{{name}}` | snake_case の名前 |
| `{{class}}` | CamelCase のクラス名（末尾に `App`） |
| `{{title}}` | Title Case の表示名 |

## 次のステップ

- 図形を描いてみる → [FmrbGfx](../api/fmrb_gfx.md)
- イベント処理を加える → [FmrbApp ▸ イベントハンドリング](../api/fmrb_app.md#イベントハンドリング-on_eventev)
- 既存サンプルを読む → [サンプル集](../examples.md)

## トラブル時のチェック

### ランチャーにアイコンが出ない

- `.toml` ファイルが `.rb` と同じディレクトリにあるか
- `app_screen_name` が `.toml` に書かれているか
- `launcher_visible = false` を指定していないか
- ファイルの配置先が `/flash/app/<dir>/` 以下になっているか

### 起動するがすぐ閉じる

- 例外で落ちている可能性。ログを確認:
    - `Log.info` を `on_create` に追加して進行を確認
    - `FmrbApp._get_last_error` を別アプリから呼んで直前のエラーを確認

### 画面に何も出ない

- `@gfx.present` を呼んでいるか確認
- 描画座標が `@user_area_x0 / y0 / width / height` の範囲内か確認

### 閉じるボタンが見えない

- `@gfx.clear` でキャンバス全体を消してしまっている → Step 2 のように `@user_area_*` の範囲で塗りつぶし、`draw_window_frame` を呼ぶ

詳細は [制約事項](../limitations.md) を参照。
