# ファイル・I/O

ファイル・ディレクトリ操作 API です。`File` / `Dir` / `IO` クラスを提供します。

## ファイル名前空間

ユーザーから見えるパスは Unix 風の単一名前空間です。アプリは `/home/...` のようなルート相対のパス、SD カードへは `/mnt/sd/...` を `File.open` / `Dir.open` に渡せます。HAL が ESP32 / Linux 両方の実際のマウントに解決します。

| パス | デバイス | 用途 |
|---|---|---|
| `/...`（`/app`, `/home`, `/usr` 等） | 内蔵 LittleFS（16MB） | システムファイル、ユーザーアプリ、永続データ |
| `/mnt/sd/...` | SD カード（FAT32） | 大容量データ、音楽、画像 |

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

list_files("/usr/share/music")
```

!!! note
    `Dir#seek` / `Dir#tell` は ESP32 VFS が対応しないため `ENOSYS` を返します。

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
