# ファイル・I/O

!!! info "工事中"
    このページは整備中です。

## 概要

ファイル・ディレクトリ操作 API です。

## File

| メソッド | 用途 |
|---|---|
| `File.new(path, mode)` | ファイルを開く |
| `File.open(path, mode, &block)` | ブロック付きで開く |
| `File.join(*names)` | パスを連結 |
| `File.expand_path(path)` | パスを展開 |
| `File.basename(path, suffix)` | ファイル名取得 |
| `File.dirname(path)` | ディレクトリ部分取得 |
| `File.extname(path)` | 拡張子取得 |
| `File.exist?(path)` | 存在確認 |
| `File.file?(path)` | 通常ファイル判定 |
| `File.directory?(path)` | ディレクトリ判定 |
| `File.size(path)` | サイズ取得 |

TODO

## Dir

| メソッド | 用途 |
|---|---|
| `Dir.open(path)` | ディレクトリを開く |
| `Dir.glob(pattern)` | パターンマッチでファイル列挙 |

TODO

## IO

`IO.new(fd, mode)`, `IO#read`, `IO#write`, `IO#puts`, `IO#print`, `IO#close`, `IO#flush`, `IO#sysopen(path, mode, perm)`

TODO

## 注意事項

!!! warning "picoruby と CRuby の差分"
    `File.binread` は picoruby に存在しません。`File.open(path, "r") { |f| f.read }` を使ってください。
    詳細は [制約事項](../guide/limitations.md) を参照。

## サンプル

TODO
