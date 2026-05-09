# 定数・システム情報 (FmrbConst / FmrbHw)

## FmrbConst

システム全体で参照される定数を提供するモジュールです。

### プラットフォーム情報

| 定数 | 値 |
|---|---|
| `FmrbConst::PLATFORM` | `"linux"` または `"esp32"` |
| `FmrbConst::OS_VERSION` | OS バージョン文字列 |
| `FmrbConst::GA_VERSION` | fmruby-graphics-audio 側のバージョン |
| `FmrbConst::LINK_VERSION` | UART リンクプロトコルバージョン |
| `FmrbConst::IDF_VERSION` | ESP-IDF のバージョン |

### ハードウェア情報

| 定数 | 内容 |
|---|---|
| `FmrbConst::MAC_ADDRESS` | MAC アドレス文字列 |
| `FmrbConst::CHIP_MODEL` | 例: `"ESP32-S3"` |
| `FmrbConst::CHIP_REVISION` | リビジョン番号 |
| `FmrbConst::CHIP_CORES` | コア数 |
| `FmrbConst::FLASH_SIZE_MB` | フラッシュ容量 (MB) |
| `FmrbConst::PSRAM_SIZE_MB` | PSRAM 容量 (MB) |
| `FmrbConst::RESET_REASON` | 直前のリセット理由 |

### プロセス管理

| 定数 | 用途 |
|---|---|
| `FmrbConst::PROC_ID_KERNEL` | カーネルプロセス ID |
| `FmrbConst::PROC_ID_HOST` | ホストプロセス ID |
| `FmrbConst::PROC_ID_SYSTEM_APP` | システムアプリ ID |
| `FmrbConst::PROC_ID_USER_APP0` / `USER_APP1` / `USER_APP2` | ユーザーアプリスロット |

#### プロセス状態

| 定数 |
|---|
| `PROC_STATE_FREE` |
| `PROC_STATE_INIT` |
| `PROC_STATE_RUNNING` |
| `PROC_STATE_SUSPENDED` |
| `PROC_STATE_STOPPING` |

### メッセージング

| 定数 | 用途 |
|---|---|
| `MSG_TYPE_APP_CONTROL` | アプリ制御メッセージ |
| `MSG_TYPE_APP_GFX` | グラフィックメッセージ |
| `MSG_TYPE_APP_AUDIO` | オーディオメッセージ |
| `MSG_TYPE_HID_EVENT` | HID イベント（キーボード等） |

#### アプリ制御コマンド

| 定数 |
|---|
| `APP_CTRL_SPAWN` |
| `APP_CTRL_KILL` |
| `APP_CTRL_SUSPEND` |
| `APP_CTRL_RESUME` |

### テーマ色（システム共通の配色）

| 定数 | 用途 |
|---|---|
| `THEME_DESKTOP_BG` | デスクトップ背景 |
| `THEME_MENU_BG` | メニュー背景 |
| `THEME_WINDOW_BG` | ウィンドウ背景 |
| `THEME_TEXT` | 通常テキスト |
| `THEME_TEXT_LIGHT` | 薄テキスト |
| `THEME_HIGHLIGHT` | 強調 |
| `THEME_BORDER` | 枠線 |
| `THEME_BUTTON` | ボタン |

これらはすべて RGB332 値です。アプリの UI を OS の配色に合わせたい場合に使います。

### その他

| 定数 | 内容 |
|---|---|
| `MAX_PATH_LEN` | パスの最大長 |

### サンプル: バージョンと環境を表示

```ruby
class SysInfo < FmrbApp
  def on_create
    clear_user_area(FmrbGfx::WHITE)
    x = @user_area_x0 + 4
    y = @user_area_y0 + 4
    @gfx.draw_text(x, y,      "OS: #{FmrbConst::OS_VERSION}", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 10, "Chip: #{FmrbConst::CHIP_MODEL}", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 20, "PSRAM: #{FmrbConst::PSRAM_SIZE_MB}MB", FmrbGfx::BLACK)
    @gfx.draw_text(x, y + 30, "MAC: #{FmrbConst::MAC_ADDRESS}", FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

SysInfo.new.start
```

## FmrbHw

ハードウェアリソース（特に GPIO ピン）の使用状況を問い合わせるモジュールです。

| メソッド | 戻り値 |
|---|---|
| `FmrbHw.pin_status(pin)` | ピンの使用状態（`Integer`、0=未使用、その他=用途別の識別子） |
| `FmrbHw.pin_available?(pin)` | 未使用なら `true` |
| `FmrbHw.pin_status_all` | `Array<Integer>`（インデックス=ピン番号、値=状態） |
| `FmrbHw.pin_count` | ピン総数 |

`pin_status` の値は内部識別子で、0 = 未使用、それ以外 = 「GPIO」「I2C」「UART」など別機能で使用中、を意味します。

### サンプル: 全ピンを表示

```ruby
status = FmrbHw.pin_status_all
status.each_with_index do |s, i|
  Log.info("pin #{i}: #{s == 0 ? 'free' : 'used'}")
end
```

### サンプル: 使う前にチェック

```ruby
PIN = 10
unless FmrbHw.pin_available?(PIN)
  Log.error("Pin #{PIN} is in use (status=#{FmrbHw.pin_status(PIN)})")
  return
end
gpio = GPIO.new(PIN, GPIO::OUT)
```

`tool/gpio_viewer.app.rb` に GUI でピン状態を可視化するサンプルがあります。

## 関連

- ピン仕様（電気的特性、外部接続）は [ハードウェア](../hardware.md) を参照
- GPIO の使い方は [周辺機器](peripherals.md#gpio) を参照
