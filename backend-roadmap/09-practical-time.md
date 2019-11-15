# 9. Practical Time

## 目次

## 概要

フレームワークを使わずに「記事のCRUD+認証アプリ」を作成する

- 言語: Ruby
- RDBMS: MySQL
- Webサーバー: Webrick (Ruby標準ライブラリ)

## 成果物

[ruby-blog-app](https://github.com/kazu-horie/ruby-blog-app)

- 記事のCRUDサイト
- Webrick の Basic認証を搭載
- MVC アーキテクチャで実装

## 利用ライブラリ

- Rack
  - Ruby FW と APサーバー のインターフェース
  - Rackのインターフェースに従うことで、あらゆるAPサーバーに対応することができる
  - Rails, Sinatra も Rack アプリ
- MySQL2
  - MySQL とのインターフェース
  - できるだけ生のSQLを扱いたいので、ORMは利用しない
  - ActiveRecord も内部で利用している ?
- RSpec
  - テストコード
- SimpleCov
  - テスト時のコードカバレッジの測定
- Rubocop
  - Lint, Metrics, Style など
