# WebAssembly のアプリ (C・TinyGo・Rust・Zig)

!!! note "3.1.0 から"
    WebAssembly のアプリは Family mruby 3.1.0 から入っています。試験的な機能で、SDK も試験的な
    ものです。名前や形はこれから変わることがあります。

本体がインタプリタを持っている言語 (Ruby、MicroPython、BASIC、Lua。[他の言語](index.md)
を参照) のほかに、**C・TinyGo・Rust・Zig** でアプリを書き、パソコンで WebAssembly に
コンパイルして動かせます。ファームウェアは `.wasm` を
[WAMR](https://github.com/bytecodealliance/wasm-micro-runtime) (のインタプリタ) で実行し、
Lua のアプリと同じアプリシェルの上で動かします。ウィンドウを作り、枠とタイトルバーを描き、
ループとタイマーを回すのは本体です。アプリはいくつかのフック (`on_create`、`on_update`、
`on_event` など) を実装し、ウィンドウの中に描きます。

WebAssembly のアプリから呼べるもの (描画、文字と日本語、画像、音、ファイル、ログ、時計、
アプリ自身の情報、入力) は、Ruby・Lua・MicroPython のアプリと同じ関数の集まりです。
ファームウェアの型定義 (RBS) の 1 か所で定義し、各言語の bindings はそこから生成して
います。その上に、それぞれの言語で自然に書けるようにする薄い手書きの層があります。

## 動く端末

| 端末 | WebAssembly のアプリ |
|---|---|
| Modern (M5Stack Tab5) とほかの ESP32-P4 の基板 | 動きます |
| [Linux 版](../getting_started/linux.md)と[シミュレータ](../getting_started/simulator.md) | 動きます |
| [Studio](../getting_started/studio.md) (ブラウザ版) | 動きます |
| Retro とほかの ESP32-S3 の基板 (StickS3、AtomS3R) | まだ動きません。起動すると `wasm apps are not in this build` と出ます |

## 書くには: SDK

SDK は別のリポジトリ
[family-mruby/family-mruby-sdk](https://github.com/family-mruby/family-mruby-sdk) にあります。
それぞれの言語で、ふだんライブラリを取り込むのと同じやり方で使います。

| 言語 | SDK の取り込み | ビルド |
|---|---|---|
| TinyGo | `go get` | SDK の target ファイルを指定して `tinygo build` |
| Rust | `cargo` (git の依存) | `cargo build --release` |
| Zig | `zig fetch` | `zig build` |
| C | ヘッダファイル 2 つ | `clang` か `zig cc` の 1 行 |

[手順書](https://github.com/family-mruby/family-mruby-sdk/blob/main/docs/getting_started.ja.md)
([English](https://github.com/family-mruby/family-mruby-sdk/blob/main/docs/getting_started.md))
が、何も入っていないパソコンから、シミュレータ、WiFi 経由の ESP32-P4 の基板、ブラウザで
自分のアプリを動かすところまでを案内します。アプリの形とフック、`.app.toml`、言語ごとの
プロジェクトとビルド、困ったときの表もそちらにあります。まずは手順書から始めてください。
このページは全体の見取り図だけです。

アプリは同じ名前の 2 つのファイルで、`/app` の下のディレクトリに置きます。

| ファイル | 内容 |
|---|---|
| `<名前>.app.wasm` | コンパイルしたアプリ。拡張子でエンジンが決まります |
| `<名前>.app.toml` | ランチャーでの名前とウィンドウ。どのアプリにもある[アプリ設定](../file_formats/app_toml.md)と同じものです |

SDK は自分の版を `.wasm` の中 (`fmrb.sdk` という名前の custom section) に書き込むので、
`.app.toml` に版を書く必要はありません。ファームウェアはアプリを起動する前に、アプリが
import している関数がすべてあるかを確認します。ファームウェアより新しい SDK で作った
アプリは、途中で失敗するのではなく、関数の名前と SDK の版を添えて起動の前に断られます
(エラーウィンドウとログに出ます)。

## 本体に入っている見本

| ディレクトリ | ランチャーに出るもの |
|---|---|
| `/app/tinygo` | TinyGo tour |
| `/app/rust` | Rust tour |
| `/app/zig` | Zig tour |
| `/app/c` | C tour |

**tour** はどの言語でも同じ中身・同じ画面 (ドット単位で同じ) のアプリです。10 ページあり、hello、図形、
文字と日本語、画像、スプライトとタイル、音と FMSQ の曲と WAV の声、ファイル、ポインタで描く線と打ったキー、
アプリの情報と時計、クリップボードとアプリ自身の wasm の数値です。1〜9 と 0 のキーで各ページに移れます。
2 つを並べて開けば、同じことを言語ごとにどう書くかを比べられます。ソースは SDK の `<言語>/examples/tour`
にあります (C 版は SDK の補助ヘッダ `c/fmrb.h` を使います)。

どのディレクトリにも、いちばん小さいアプリ `hello` (SDK の手順書で作るもの) が入っています。
ランチャーには出さないので、[Shell](../getting_started/shell.md) から
`run /app/tinygo/hello.app.wasm` のように起動します。ランチャーのアイコンは言語ごとにあり、
`.app.toml` でアイコンを指定していない `.wasm` には WebAssembly のアイコンが付きます。

## ブラウザで試す

[Studio](../getting_started/studio.md) にも同じ WAMR が入っているので、何もインストールせずに
アプリを試せます。

1. 2 つのファイルを、アプリの名前のフォルダに入れます (`hello/hello.app.wasm` と
   `hello/hello.app.toml`)。
2. フォルダを Studio のページに投げ込むか、画面の下の **Add — Folder…** で選びます。
   先頭に `.app.toml` があるフォルダは `/app/usr/<フォルダ名>/` に入ります。
3. ランチャーのタイトルバーの **Reload** (か `F5`) で一覧を読み直してダブルクリックするか、
   Shell で `run /app/usr/hello/hello.app.wasm` と打ちます。

ログはブラウザの開発者ツールのコンソールに出ます。`/app/usr` は次に来たときもブラウザに
残っています。作り直したら、もう一度フォルダを投げ込めば新しいファイルに置き換わります。

ESP32-P4 の基板なら、同じ 2 つのファイルを WiFi で送り、焼き直さずに起動できます。
[WiFi でファイルとアプリを扱う](../remote_desktop.md#wifi-でファイルとアプリを扱う) を参照してください。

## 本体での扱い

- **アプリは自分のメモリの中だけで動きます。** WebAssembly のアプリが触れるのは、自分の
  線形メモリと、ファームウェアが渡す関数だけです。メモリはアプリのふつうのメモリプールから
  64 KB のページ単位で取り、確保に応じて増えます。大きいプールがある端末では、`.app.toml` の
  `large_memory = 1` で広く使えます。
- **フックは戻る必要があります。** 1 回のフックの呼び出しで実行できるのは 20,000,000 命令
  までです。長い仕事は `on_update` の何回かに分けます。超えたアプリや、トラップした
  アプリ (範囲外の添字、panic など) は終了し、理由がエラーウィンドウに出ます。
- **WASI や libc の入出力はありません。** ファームウェアが渡すのは自分の `fmrb` の関数だけです。
  ほかのもの (C のライブラリの `printf` など) を import しているアプリは、読み込みの時点で
  断られます。
- **動いている様子。** Monitor アプリに **WASM (WAMR)** のページがあり、ランタイムが動いて
  いるか、アプリとモジュールの数、共有のプールの使用量、アプリごとのメモリのページ数・
  `.wasm` の大きさ・フックにかかった時間が見られます。Shell の `ps` は ENGINE の欄に `wasm` と
  出します。アプリからは `FmrbApp.wasm_stats` と `FmrbApp.wasm_app_stats(pid)` で同じ値を
  読めます。
- エンジンのログの行は `wasm:` で始まり、アプリ自身のログの行にはアプリの名前が付きます。

## 関連

- [family-mruby-sdk](https://github.com/family-mruby/family-mruby-sdk) — SDK、手順書、tour の仕様
- [他の言語](index.md) — ほかの言語 (Lua を含む)
- [アプリ設定ファイル (.app.toml)](../file_formats/app_toml.md)
- [Studio](../getting_started/studio.md)
