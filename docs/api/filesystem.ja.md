# ファイル・I/O (File / Dir / IO)

ファイル・ディレクトリ操作 API です。`File` / `Dir` / `IO` クラスと、パスを指定してファイルを丸ごと
読み書きする `FmrbFile` を提供します。

## ファイル名前空間

ユーザーから見えるパスは Unix 風の単一名前空間です。アプリは `/home/...` のようなルート相対のパス、SD カードへは `/mnt/sd/...` を `File.open` / `Dir.open` に渡せます。HAL が ESP32 / Linux 両方の実際のマウントに解決します。

| パス | デバイス | 用途 |
|---|---|---|
| `/...`（`/app`, `/home`, `/usr` 等） | 内蔵 flash（LittleFS） | システムファイル、ユーザーアプリ、永続データ |
| `/mnt/sd/...` | SD カード（FAT32） | 大容量データ、音楽、画像 |

## `/home` はあなたのもの

`/home` は空の状態から始まり、ファームウェアが持ってくるものがここに書かれることはありません。
ファームウェアに付いてくるものは、すべてこの外にあります。

| パス | |
|---|---|
| `/app` | 入っているアプリ。自分のアプリは `/app/usr` に置くとランチャーが見つけます |
| `/usr/share/samples/ruby` | 読むための小さな Ruby プログラム |
| `/usr/share/samples/slides` | 発表用アプリの資料 |
| `/usr/share/samples/services` | 写して使うサービスの一覧と本体 2 つ |
| `/usr/share/services` | システムが動かしている[サービス](../file_formats/services.md)の本体 |
| `/usr/share/sprites`, `sounds`, `music`, `backgrounds`, `icon`, `template` | 同梱アプリが描くもの・鳴らすもの |
| `/etc` | ファームウェアに付いてくる設定 |
| `/var/cache` | システムが自分で作り直すキャッシュ |

サンプルで遊ぶときは `/home` に写して、写した方を編集してください。やり直したくなったとき、
元のものがそのまま残っています。

自分の設定も同じ分け方です。システムのものは `/etc` にあり、あなたのものは `/home` に
並びます (`/home/colors.toml`、`/home/services.toml`、`/home/associations.toml`)。
付いてきた設定を書き換えるのではなく、上書きする形で勝ちます。

`/home` の中でシステムが見るのは 1 か所だけです。`/home/backgrounds` に置いた `.png` は、
`/usr/share/backgrounds` のものと並んで Config の壁紙の一覧に出ます。それ以外の場所を
システムが走査することはありません。

!!! warning "書き込み直しは話が別です"
    ここに書いたのは、動作中の本体の話です。ブラウザからファームウェアを書き込むと、
    `/home` を含めてファイルシステム全体が置き換わります。大事なものは先に取り出して
    ください。[ファームウェア更新](../getting_started/firmware_update.md) を参照。

## File クラス


### クラスメソッド

| メソッド | 用途 |
|---|---|
| `File.open(path, mode = "r", &block)` | ブロック付きで自動 close（推奨） |
| `File.new(path, mode = "r", perm = 0666)` | ファイルを開く（要 `close`） |
| `File.exist?(path)` / `File.exists?(path)` | 存在確認 |
| `File.file?(path)` | 通常ファイルか |
| `File.directory?(path)` | ディレクトリか |
| `File.size(path)` | バイトサイズ |
| `File.delete(path)` / `File.unlink(path)` | 削除 |
| `File.rename(old, new)` | リネーム / 移動 |
| `File.join(*names)` | パス結合 |
| `File.expand_path(path, default_dir = ".")` | 絶対パスに展開 |
| `File.basename(path, suffix = "")` | ファイル名抽出 |
| `File.dirname(path, level = 1)` | ディレクトリ部分抽出 |
| `File.extname(path)` | 拡張子抽出（先頭の `.` を含む） |

### モード文字列

| モード | 意味 |
|---|---|
| `"r"` | 読み込み（デフォルト） |
| `"w"` | 書き込み（既存内容は破棄） |
| `"a"` | 追記 |
| `"r+"` | 読み書き |
| `"w+"` | 読み書き（既存内容は破棄） |

### サンプル

```ruby
# 読み込み
text = File.open("/home/log.txt", "r") { |f| f.read }

# 書き込み
File.open("/home/score.txt", "w") do |f|
  f.write("score=#{@score}\n")
end

# 存在確認
if File.exist?("/usr/share/icon/ruby.icon")
  Log.info("icon found")
end

# 削除
File.delete("/home/old.dat") if File.exist?("/home/old.dat")
```

## Dir クラス

| メソッド | 用途 |
|---|---|
| `Dir.open(path)` | ディレクトリを開く |
| `dir.read` | 次のエントリ名を返す（最後で `nil`） |
| `dir.close` | クローズ |
| `dir.rewind` | 先頭に戻る |
| `Dir.mkdir(path, mode = 0777)` | ディレクトリ作成 |
| `Dir.rmdir(path)` | ディレクトリ削除（空のとき） |
| `Dir.chdir(path)` | カレントディレクトリ変更 |
| `Dir.getcwd` | カレントディレクトリ取得 |

### サンプル: ディレクトリ列挙

```ruby
def list_files(base_path)
  files = []
  dir = Dir.open(base_path)
  while (entry = dir.read)
    next if entry == "." || entry == ".."
    files << entry
  end
  dir.close
  files
rescue => e
  Log.warn("list_files failed: #{e.message}")
  []
end

list_files("/usr/share/sounds/nsf")
```

!!! note
    `Dir#seek` / `Dir#tell` は ESP32 VFS が対応しないため `ENOSYS` を返します。

## パスで丸ごと読み書きする (`FmrbFile`)

**(開発版)** パスを渡してファイル全体を一度に読み書きする関数のモジュールです。開く・閉じるは
ありません。アプリを書けるどの言語 (Ruby、Lua、MicroPython、[WebAssembly](../languages/wasm.md)) でも
同じなので、言語をまたいで読まれるアプリのファイルの扱いに向いています。`File` は今までどおりです。

| メソッド | 返り値 |
|---|---|
| `FmrbFile.read(path)` | ファイル全体を String (バイト列) で。無い・読めないときは `nil` |
| `FmrbFile.write(path, data)` | 書けたら `true`。ファイルを置き換えます |
| `FmrbFile.append(path, data)` | 書けたら `true`。無ければ作ります |
| `FmrbFile.exist?(path)` | あるかどうか |
| `FmrbFile.size(path)` | 大きさ (バイト)。無ければ `nil` |
| `FmrbFile.delete(path)` | 消せたら `true`。ファイルか空のディレクトリ |
| `FmrbFile.mkdir(path)` | 作れたか、既にあれば `true` |
| `FmrbFile.list(dir)` | ディレクトリの中の名前の配列。ディレクトリの名前は `/` で終わります。読めなければ `nil` |
| `FmrbFile.free_bytes(path)` | `path` があるファイルシステムの空き (`/tmp` なら RAM のファイルシステムの残り)。分からなければ `nil` |
| `FmrbFile.path_read_only?(path)` | Linux 版の読み取り専用の場所だけ `true`。基板・シミュレータ・Studio では常に `false` |

```ruby
FmrbFile.write("/home/memo.txt", "hello\n")
FmrbFile.append("/home/memo.txt", "one more\n")
text = FmrbFile.read("/home/memo.txt")
FmrbFile.list("/home").each { |name| Log.info(name) }
```

パスは `File` と同じで、読み書きできる場所も同じです。Lua と MicroPython では `?` を落とした名前
(`FmrbFile.exist(path)`) になり、「無い」は `nil` / `None` です。

## IO クラス

`File` の親クラス。低レベルストリーム操作のための共通インターフェイスを提供します。

| メソッド | 用途 |
|---|---|
| `read(length = nil)` | 指定バイト数（または EOF まで）読み込み |
| `write(*args)` | 書き込み（バイト数を返す） |
| `puts(*args)` | 改行付き出力 |
| `print(*args)` | 改行なし出力 |
| `close` | クローズ |
| `flush` | バッファフラッシュ |

## エラー処理

ファイル操作系は失敗時に例外を上げます（ファイルが無い、権限不足など）。`rescue` で受けるのが基本です。

```ruby
begin
  data = File.open(path, "r") { |f| f.read }
rescue => e
  Log.error("read failed: #{e.message}")
  return nil
end
```

## 関連

- 制約事項（特に `binread` 無し、ファイル数上限など）は [制約事項](../limitations.md) を参照
- BLE で PC からファイルを置く方法は [コンソール](../getting_started/console.md) を参照

<!-- BEGIN class reference links (generated by fmruby-core tools/ti/gen_site.rb; do not edit) -->
**クラスリファレンス:** [`File`](reference/File.md)、[`Dir`](reference/Dir.md)、[`IO`](reference/IO.md)、[`FmrbFile`](reference/FmrbFile.md)
<!-- END class reference links -->
