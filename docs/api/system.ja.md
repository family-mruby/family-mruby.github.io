# Task / Machine

タスク制御・システム制御の低レベル API です。`picoruby-machine` 由来。

## Task

FreeRTOS タスクを Ruby から扱うためのモジュールです。

| メソッド | 用途 |
|---|---|
| `Task.pass` | スケジューラに制御を譲る（他のタスクが動ける機会を与える） |

`FmrbApp#main_loop` 内では `on_update` の後に `Task.pass` が呼ばれていて、別アプリやカーネルが動けるようになっています。

```ruby
loop do
  do_some_work
  Task.pass
end
```

## Machine

時計、待機、システムリセット、メモリ情報などを提供します。

### 待機

| メソッド | 用途 |
|---|---|
| `Machine.delay_ms(ms)` | FreeRTOS の `vTaskDelay` ベースで `ms` ミリ秒待機（戻り値: `ms`） |
| `Machine.busy_wait_ms(ms)` | ビジーループによる正確な待機 |
| `Machine.sleep(sec)` | 指定秒数スリープ。2 秒以上 86400 秒未満 |
| `Machine.deep_sleep(sec)` | ディープスリープ（**未実装**） |

!!! warning "`sleep_ms` の落とし穴"
    Kernel の `sleep` / `sleep_ms` は **`_spin` の外（独立タスク中）では tick が進まず止まる** ことがあります。短時間の待機は **`Machine.delay_ms`** を使ってください。詳細は [制約事項](../limitations.md) を参照。

### 時計

| メソッド | 用途 |
|---|---|
| `Machine.set_hwclock(unix_timestamp)` | ハードウェアクロックに UNIX 時刻を設定 |
| `Machine.get_hwclock` | `[tv_sec, tv_nsec]` を返す |

通常は `FmrbApp.set_wallclock(year, month, ...)` のほうが扱いやすく、それが内部で `Machine.set_hwclock` を呼びます。

### 稼働情報

| メソッド | 戻り値 |
|---|---|
| `Machine.uptime_us` | マイクロ秒単位の起動からの経過時間 |
| `Machine.board_millis` | ミリ秒単位の起動からの経過時間 |
| `Machine.uptime_formatted` | 文字列形式 (`"hhh:mm:ss"`) |
| `Machine.unique_id` | デバイス固有 ID 文字列 |

### メモリ・診断

| メソッド | 用途 |
|---|---|
| `Machine.read_memory(addr, size)` | 指定アドレスのメモリ内容（読み取り） |
| `Machine.stack_usage` | スタック使用量（バイト） |

### システム制御

| メソッド | 用途 |
|---|---|
| `Machine.exit(status = 0)` | プログラム終了 |
| `Machine._reboot` | システムリブート（POSIX では未対応） |

## サンプル

### 起動からの経過時間表示

```ruby
class UptimeView < FmrbApp
  def on_create
    redraw
  end

  def on_update
    redraw
    1000   # 1 秒ごと
  end

  private

  def redraw
    clear_user_area(FmrbGfx::WHITE)
    @gfx.draw_text(@user_area_x0 + 4, @user_area_y0 + 4,
                   "Uptime: #{Machine.uptime_formatted}",
                   FmrbGfx::BLACK)
    draw_window_frame
    @gfx.present
  end
end

UptimeView.new.start
```

### 短時間のディレイ

```ruby
# OK: FreeRTOS タスクで安全に待機
3.times do |i|
  Log.info("step #{i}")
  Machine.delay_ms(500)
end

# NG: _spin 外で sleep_ms を使うと止まる
# sleep_ms(500)  ← これは独立タスクで停止することあり
```

## 関連

- ライフサイクル（`on_update` の戻り値で待機時間制御）は [FmrbApp](fmrb_app.md#ライフサイクル) を参照
- スリープに関する制約は [制約事項](../limitations.md) を参照
