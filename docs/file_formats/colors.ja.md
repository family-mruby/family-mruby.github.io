# 配色 (`/home/colors.toml`)

機械全体の見た目は
[`/etc/system_conf.toml` の `[theme]`](system_conf.md#theme) が決めていて、アプリの色は
すべてそこから来ます。このファイルは、そこにアプリ 1 つだけ異を唱えるための場所です。
ビルドし直す必要も、テーマ変更のような再起動も要りません。

```toml
[editor]
bg   = "midnightblue"
text = 0xFC

[shell]
bg = "black"
```

ファイルが無い、節が無い、キーが無い — どれも「テーマに従う」という意味です。つまり
このファイルには、意図して変えたものだけが残ります。行を消せば元に戻ります。

値は色の名前か数値です。数値は RGB332 で、`system_conf.toml` と同じ書き方です。

置き場所が `/home` なのは、これがあなたのものだからです。機械が持ってくるものがここに
書かれることはありませんし、[Studio](../getting_started/studio.md) では再読み込みしても
残り、書き出すアーカイブにも一緒に入ります。

## シェルから

シェルは自分の 2 色を変えて、このファイルに書きます。

```
color                    今の 2 色を表示
color bg skyblue         背景
color text 0x1F          文字。数値でも書ける
color names              色の名前を全部並べる
color reset              テーマに戻す
```

再起動なしですぐ反映されます。

<div align="center">
  <img src="/images/colors_shell.png" width="620" alt="midnightblue の地に lightgreen の文字で描かれたシェルと、そうした 2 行の color コマンド">
  <br><em>シェルで 2 行打つだけです。次に起動しても残ります</em>
</div>

## エディタから

エディタのメニューには Colors があり、31 色を 1 つずつ選べます。書き込む先は同じ
ファイルの `[editor]` です。エディタは色を定数で持っているため、開き直すまで新しい色では
描かれません。

ダイアログに出てくる順で並べると、キーはこうなっています。

| 区分 | キー |
|---|---|
| 本文 | `bg`, `text`, `cursor`, `selection`, `gutter` |
| メニューバー | `menu_bg`, `menu_text`, `menu_key`, `menu_key_alt` |
| ステータス行 | `status_bg`, `status_text`, `saved_bg`, `saved_text` |
| ドロップダウン | `dropdown_bg`, `dropdown_text`, `dropdown_sel_bg`, `dropdown_sel_text` |
| ダイアログ | `dialog_bg`, `dialog_text`, `dialog_border`, `dialog_key` |
| 問題表示 | `problem_bg`, `problem_text` |
| 構文の色分け | `syntax_keyword`, `syntax_string`, `syntax_comment`, `syntax_number`, `syntax_symbol`, `syntax_constant`, `syntax_variable`, `syntax_method` |

`menu_key_alt` は `menu_key` と同じ役目を明るいパネルの上で果たす色です。白地に黄色は
読めないので、キー一覧だけ別の色を使います。

## 色の名前

名前は web のものを、この機械が出せる 256 色に対応づけています。対応づけると複数の名前が
同じ色になるので、一覧は 2 つに分かれています。異なる色に 1 つずつ付いた 78 個の名前と、
すでに一覧にある色に重なる 23 個の別名です。どちらも受け付けます。シェルの
`color names` が並べるのは前者の 78 個です。

全部の名前と色は [色の名前](color_names.md) にあります。

## 関連

- [システム設定 (system_conf.toml)](system_conf.md) — 機械全体のテーマ
- [定数・システム情報](../api/const.md) — アプリからテーマを読む
