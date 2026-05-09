# Hello World

「Hello, mruby!」と画面に表示する最小のアプリを動かして、自分のアプリを書く流れを掴みます。

## 最小のアプリ構成

Family mruby のアプリは **2 つのファイル** をペアで作ります。

```
hello.app.rb       # アプリ本体（Ruby）
hello.app.toml     # 設定ファイル
```

両方を `/flash/app/<好きなディレクトリ>/` 以下に置くと、ランチャーに自動的に表示されます。

## `.rb` ファイルを書く

PC のテキストエディタで `hello.app.rb` を作成します:

```ruby
# hello.app.rb
class HelloApp < FmrbApp
  def on_create
    @gfx.clear(FmrbGfx::BLACK)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Hello, mruby!", FmrbGfx::WHITE)
    @gfx.present
  end

  def on_update
    500   # 500ms ごとに on_update が呼ばれる
  end
end

HelloApp.new.start
```

何が起きているか:

| コード | 役割 |
|---|---|
| `class HelloApp < FmrbApp` | `FmrbApp` を継承するアプリクラス |
| `on_create` | 起動時に 1 回呼ばれる初期化処理 |
| `@gfx.clear(...)` | 画面を黒で塗りつぶし |
| `@gfx.draw_text(...)` | 文字を描画 |
| `@gfx.present` | バッファを画面に反映（**必須**） |
| `on_update` | フレームごとに呼ばれる。戻り値が次回までの待機 ms |
| `HelloApp.new.start` | アプリを実行 |

詳細は [FmrbApp](../api/fmrb_app.md) を参照。

## `.toml` ファイルを書く

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

タイトルバー右の × ボタンでアプリを終了できます。

## 修正してリロードする

アプリを更新したいときは:

1. PC で `hello.app.rb` を書き換え
2. BLE ファイルマネージャで再アップロード（同じ名前で上書き）
3. アプリのタイトルバーを **右クリック** すると、確認ダイアログが出てリロード

ファイル単位の再起動なので、再起動を待たずに開発できます。

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

詳細は [制約事項](../limitations.md) を参照。
