# Lua

`.lua` のアプリは、本体が C で用意するアプリシェルの上で動きます。ウィンドウを作り、枠を描き、ループを回すのは
本体で、アプリは関数を定義するだけです。形は Ruby のアプリにそろえてあります。

```lua
local seconds = 0

function on_create()            -- ウィンドウができた後に 1 回
  FmrbApp.clear_user_area()     -- 描画領域をテーマの色で塗り、枠を描き直す
  gfx:draw_text(2, 2, "Hello", FmrbApp.THEME_TEXT)
  gfx:present()
end

function on_update()            -- 返した ms の後にまた呼ばれる (数でなければ 330)
  seconds = seconds + 1
  return 1000
end

function on_event(ev)           -- 入力 1 つごと
  if ev.type == "key_down" and ev.character == string.byte("q") then
    FmrbApp.stop()
  end
end
```

- ファイルのトップレベルは最初に 1 回だけ走ります (関数と変数を定義する所)。そこではまだ
  `gfx` はありません。`on_create`・`on_update`・`on_event` のどれも定義しないファイルは起動せず、
  エラーウィンドウが出ます。
- 任意の関数: `on_destroy`、`on_suspend` / `on_resume`、`on_resize(w, h)` (アプリシェルが描画領域を塗り直して
  枠を描いた後)、`on_quit_request` (Ctrl+Q。無ければ閉じる)。
- 関数の中でエラーになると、メッセージとトレースバックのエラーウィンドウが出てアプリは終わります。
  関数の中で長く待たず、待ちは `on_update` の返り値で表します。1 秒以上戻らない関数は、
  閉じるボタンと kill で打ち切られます。
- `gfx` は Ruby の `@gfx` と同じく、枠の内側の左上を (0, 0) として描きます。メソッドは Ruby の
  `FmrbGfx` と同じ名前・同じ引数の順です: `fill_rect(x, y, w, h, c)`・`draw_line`・
  `fill_circle`・`draw_ellipse`・`draw_arc` など、`draw_text(x, y, text, c [, bg [, mixed]])`・
  `set_font(family [, size])`・`present()`。Ruby の Symbol は文字列 (`gfx:set_font("ja", 12)`)、
  記録は表になります。`gfx:clear(c)` は枠ごとキャンバス全体を消し、
  `FmrbApp.clear_user_area([c])` は描画領域を消して枠を描き直します。
- 大きさは関数で、呼んだ時点の値を返します。描画領域は `FmrbApp.user_area_width()` /
  `user_area_height()`、ウィンドウは `FmrbApp.window_width()` / `window_height()`。
- 描画のほかにも、Ruby のアプリにあるものが使えます。`FmrbAudio.new()` と `audio:note_on(...)`・
  `audio:play_wav(path)` など、`Log.info(msg)`、`FmrbApp.clipboard()`・`FmrbApp.uptime_ms()`・
  `FmrbApp.wallclock()`、ウィンドウの状態と要求 (`FmrbApp.fullscreen()`・
  `FmrbApp.request_fullscreen(on)` など)、`FmrbFile` によるファイルの丸ごとの読み書き
  (`FmrbFile.read(path)`・`FmrbFile.exist(path)` など)。Ruby で `?` で終わるメソッドは、Lua では
  `?` を落とした名前です。
- `ev` のキーは Ruby と同じで、`ev.type` は文字列です: `"key_down"`・`"key_up"`・
  `"mouse_down"`・`"mouse_up"`・`"mouse_move"`・`"mouse_wheel"`・`"gamepad_down"`・
  `"gamepad_up"`・`"gamepad_axis"`・`"kana_mode"`。マウスのイベントは `x` / `y` (描画領域) と
  `wx` / `wy` (ウィンドウ) を持ちます。閉じるボタン、タイトルバーのウィンドウのメニュー、ドラッグは
  本体が受け持ちます。
- 色は `FmrbGfx.BLACK` などの定数と、テーマの `FmrbApp.THEME_WINDOW_BG`・`THEME_TEXT`・
  `THEME_BORDER` など。

見本は `/app/lua/lua.app.lua` です。
