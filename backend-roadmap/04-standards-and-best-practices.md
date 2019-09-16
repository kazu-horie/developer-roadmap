# 4. Standards and Best Practices | 業界標準のコーディング規約と関連するツールを学ぶ

## コーディング規約

言語にはコーディング規約が存在し、様々なコミュニティ/団体が規約を定めている。コーディング規約に従って記述することで、コードの一貫性、可読性が高くなる。

### Ruby のコーディング規約

> Ruby の正式なコーディング規約はありません。しかし、複数人のプロジェクトやチームで同時にコーディングする場合や、継続的なメンテナンスが必要とされるシステム開発においては、コーディングスタイルを統一しておくことで可読性を高め保守性を向上することができます。参考となるコーディング規約を紹介します。([Ruby Association](https://www.ruby.or.jp/ja/tech/development/ruby/050_coding_rule.html) から引用)

- Ruby にはスタンダード（公式が定めるコーディング規約の基準）は存在しない
  - [定めない理由について (Matz のインタビュー記事から)](https://blog-ja.sideci.com/entry/2018/03/02/120636)
    - Ruby の思想 = Happy Hacking!
    - 好きなように楽しく書くことが重要
- 有識者が各々のベストプラクティスを公開している
  - [rubocop-hq/ruby-style-guide](https://github.com/rubocop-hq/ruby-style-guide) | [日本語](https://github.com/fortissimo1997/ruby-style-guide/blob/japanese/README.ja.md)
  - [cookpad/styleguide](https://github.com/cookpad/styleguide/blob/master/ruby.ja.md)
  - [Rubyist 前田修吾さん](https://shugo.net/ruby-codeconv/codeconv.html)

### デファクトスタンダード

[rubocop-hq/ruby-style-guide](https://github.com/rubocop-hq/ruby-style-guide)

- Rubocop のデフォルト規約
- デファクトスタンダード？ (Rubocop が Lint ツールのデファクトスタンダードであるから)

## Linter / Lint (静的解析ツール)

- 静的解析を行い、エラーを発見してくれるツール
- [RuboCop](https://rubocop.readthedocs.io/en/stable/) がデファクトスタンダード
  - 厳密には Lint 機能は Rubocop の機能の一つ (Lintcop と呼ばれる)
  - デフォルトの Rule はコーディング規約としても公開されている

## Formatter (整形ツール)

- コーディングスタイルを統一するため、自動でコードを整形してくれるツール
- Linter にもコード整形する機能は備わっているものもあるが、Fomatter には劣る
- 代表的なものは [Prettier](https://prettier.io/)

## 環境構築

### vscode

- Rubocop
  - https://marketplace.visualstudio.com/items?itemName=misogi.ruby-rubocop#installation
  - ~~設定ファイル(`.rubocop.yml`)は、カレントディレクトリから上に向かって走査し、最初に見つかったものを参照する~~
