# 動作確認済み機器

Family mruby は USB HID 互換のキーボード / マウス / ゲームパッドに対応しています。実機で動作確認した機種をここに記録します。

記載していない機器も動作する可能性ありますが、USBドライバの機能に制約があるので、機器によって認識しないこともありえす。

## キーボード

| 確認結果 | メーカー | 型番 | 備考 |
|---|---|---|---|
| OK | エレコム | FCP096BK | エレコムUSBと合わせて確認 https://www.amazon.co.jp/dp/B078HT86WB |
| Failed | バッファロー | BSKBU108ENBK | US配列。USBハブ経由で認識せず https://www.amazon.co.jp/dp/B07JHK41RD |

## マウス

| 確認結果 | メーカー | 型番 | 備考 |
|---|---|---|---|
| OK | Amazon | – | エレコムUSBと合わせて確認 https://www.amazon.co.jp/dp/B005EJH6RW |

## キーボード&マウス

| 確認結果 | メーカー | 型番 | 備考 |
|---|---|---|---|
| OK | ロジクール | MK245nBK  | https://www.amazon.co.jp/dp/B01LW8E866 |
| OK | Omikamo | – | 有線接続で確認 https://www.amazon.co.jp/dp/B0GJSV522Q |

## USBハブ

| 確認結果 | メーカー | 型番 | 備考 |
|---|---|---|---|
| OK | エレコム | U3H-H042BK/E | https://www.amazon.co.jp/dp/B0DVGRKJV6 |


## ゲームパッド

| 確認結果 | メーカー | 型番 | 軸数 / ボタン数 | 備考 |
|---|---|---|---|---|
|---| _未登録_ | – | – | – |

## 接続のヒント

- USBハブ経由で複数同時接続できますが、機器ごとの相性があります（キーボード + マウス + ゲームパッド）
- ロジクールのUSB＆マウス（MK245nBK）を使うのが配線もなくて、おすすめです。

## 関連

- [ハードウェア ▸ USB](hardware.md#usb) — 接続仕様
- [起動と接続](getting_started/setup.md) — 接続手順
