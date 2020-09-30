# HTML

## Semantic HTML

プログラミングの原則として、コードの断片の役割や意味が理解しやすいことは非常に重要

加えて、機械にも理解しやすいようにするという目的がある

- 具体的には
  - 検索エンジンのクローラー → SEO の向上
  - アクセシビリティに特化したもの (e.g. スクリーンリーダー)
- 一定のルール(タグの定義)に基づいて文章を書いた方が、機械も意味を理解しやすい

source: https://developer.mozilla.org/ja/docs/Glossary/Semantics

## Forms and Validations

サーバ側だけでなく、クライアント側でも送信する値の検証をすることができる

JavaScript で如何様にも制御できるが、HTML で用意されているバリデーションもある

- required: 必須
- minlength / maxlength: データ長
- pattern: 正規表現にマッチするか
  など

### ※ CSS 豆知識

- 入力値が正常な要素は `:valid` 擬似クラスで参照可能
- 入力値が不正な要素は `:invalid` 擬似クラスで参照可能

### ※ JavaScript 豆知識

DOM にも [検証用の API が用意されており](https://wiki.developer.mozilla.org/ja/docs/Web/API/Constraint_validation)、JavaScript で検証機能を実装する際は便利

## html-best-practices

https://github.com/hail2u/html-best-practices/blob/master/README.ja.md

一度は目を通しておきたい！

### 一部抜粋

- できる限り data-\*属性は避ける
  - 使う前に標準で用意されている属性がないか調べること！
- CSS の type 属性は省略する
  - style だけでなく、あらゆる属性の初期値を確認すること！
- 真偽値を取る属性の値は省略する
