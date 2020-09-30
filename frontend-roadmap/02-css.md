# CSS

## Box Model

ボックスという基礎概念

- Content box
  - コンテンツ部分
  - 子要素もこの領域に表示
- Padding box
  - 要素内の余白
  - `padding` プロパティ
- Border box
  - 境界部分
  - `border` プロパティ
- Margin box
  - 要素外の余白
  - `margin` プロパティ

インラインボックスとブロックボックス

- `display` プロパティで適用される
- ブロックボックス
  - インライン方向に伸びる
  - 縦に積まれていくイメージ
- インラインボックス
  - 横に積まれていくイメージ

参考: [MDN: ボックスモデル](https://developer.mozilla.org/ja/docs/Learn/CSS/Building_blocks/The_box_model)

## Responsive design

同一の HTML を様々なデバイスに対応したデザインにすること

### TL;DR

- viewport の設定
  - meta viewport タグに `content="width=device-width, initial-scale=1`
- Media Queries を利用して、 特定の width, height の範囲毎にスタイルを変える

### Viewport

- 表示領域のこと
  - モバイルデバイス用の設定
- width は初期サイズの助言
  - `width=300` とすれば、仮想的な 300 ピクセルの表示領域が作成される
    - 表示領域のサイズがデバイスのブラウザの実際のサイズ(CSS ピクセル: 論理上の画面サイズのこと)より小さければよしなに拡大 / 大きければ縮小 してくれる
  - `initial-scale=x` とすれば、拡大縮小の初期値を設定できる
- Viewport を指定しないと...
  - PC と同じサイズの表示領域が作成される
  - めっちゃちっさく表示されたり、潰れたりしちゃう

### Media Queries

- 画面の幅や高さなどに基づいて、スタイルを変更することができる
- 使い方としては以下がある
  - css に記載
    - `@media (min-width: 500px) { ... }`
  - link タグに記載
    - `<link rel="stylesheet" media="(min-width: 500px)" href="min-width500px.css">`

参考: [Google Developers: レスポンシブウェブデザイン](https://developers.google.com/search/mobile-sites/mobile-seo/responsive-design?hl=ja)
