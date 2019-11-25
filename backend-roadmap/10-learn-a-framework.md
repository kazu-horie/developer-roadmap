# 10. Learn a Framework

## 概要

### フレームワーク とは

> ソフトウェアフレームワーク（英: software framework）とは、プログラミングにおいて、アプリケーションプログラム等に必要な一般的な機能が、あらかじめ別に実装されたものである。使い方としては、クラスライブラリとして実装されている場合は、継承したクラスを作ってユーザーが選択的に上書きしたり特化させたりする（一例であって、他にもさまざまな形態がある）。文脈から明確な場合は単に「フレームワーク」としたり、「アプリケーションフレームワーク」など前や後に別の語をつなげた複合語も多い。

wikipediaより引用 (https://ja.wikipedia.org/wiki/%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0%E3%83%AF%E3%83%BC%E3%82%AF)

### Ruby の Web フレームワーク

![google trends(rails, hanami, sinatra)](/backend-roadmap/images/google-trends.png)

- [Ruby on Rails](https://rubyonrails.org/)
  - デファクトスタンダード
  - 機能が豊富
  - MVC アーキテクチャ
  - サービスを素早く実現することに向いている
- [Sinatra](http://sinatrarb.com/intro-ja.html)
  - シンプル
  - 複雑でないWebアプリケーションの作成に向いている
  - 柔軟である分、自身で基盤を拡張する必要がある
- [Hanami](https://guides.hanamirb.org/)
  - 2017年に v1.0 がリリース
  - DDD がベース
  - クリーンアーキテクチャ
  - スケーラブルで長期的なメンテナンスに向いている

## Ruby on Rails

### 基本理念

- Don't Repeat Yourself: DRY
  - ソフトウェア開発の原則の１つ
  - コードクローンを避けることで、保守・拡張しやすくし、バグを減らすことができる
- Convention Over Configuration: COC
  - フレームワークでデフォルト設定を定めておくことにより、開発者の決定事項を減らすこと
  - デフォルトが望まない場合だけ、開発者が必要な動作を設定すればよいという考え
- MVC アーキテクチャ
  - MVW (Model View Whatever) の１つ
  - [PDS (プレゼンテーションとドメインの分離)](http://bliki-ja.github.io/PresentationDomainSeparation/)を実現するパターン

## Rails の基本コンポーネント

### Active Record (ActiveRecord::Base)

- モデルに相当し、データとビジネスロジックを担う階層
- [ORM の Active Record](https://www.techscore.com/tech/Ruby/Rails/other/designpattern/1/) パターンの実装
  - データかつ、データに対する振る舞いを持つオブジェクト
  - 生SQL文を直接書く代わりに、わずかなコードからデータベースを操作できる
- 主な機能
  - モデル及びデータの表現
  - モデル同士のアソシエーションの表現 (Association)
  - データベーススキーマの継続的な変更 (Migration)
  - 永続化する前のバリデーション (Validation)
  - オブジェクトライフサイクルへのフック (Callback)
    - `after_save`, `before_validation`とか
  - クエリインターフェース

### Action View (ActionView::Base)

- レスポンスを実際のWebページにまとめる役割を担う階層
- テンプレート、パーシャル、レイアウト
  - テンプレート: テンプレートシステムの利用 (デフォルトはERB)
  - パーシャル: 共通コードを分割して書き出し、任意のテンプレートから利用できる
  - レイアウト: 全体共通のレイアウト
    - ほとんどのページは全体レイアウトの内側に埋め込まれている
- ヘルパーメソッド
  - htmlを簡潔にかけるよう用意されたヘルパー
  - [API document](https://api.rubyonrails.org/classes/ActionView/Helpers.html)

### Action Controller (ActionController::Base)

- モデルとビューの仲介を担う階層
  - リクエストから適切な出力を行う
  - ほとんどを Action Controller がデフォルトで定めた処理を行ってくれる
    - レンダリング指定がない場合とか
- アクション
  - `Applicatoin Controller`の子クラスの public メソッド
- パラメータ
  - GETデータ、POSTデータを意識する必要はなく、`params`ハッシュでアクセス可能
  - Strong Parameters による、マスアサインメントの禁止

#### Session (ActionDispatch::Session::AbstractStore)

- `session`インスタンスメソッドからアクセス
- CacheStore: データをキャッシュに保存する
- ActiveRecordStore: Active Recordを介してデータベースに保存する
  - `activerecord-session_store` gem が必要
- MemCacheStore: データを `memcached`クラスタに保存する
  - 実装が古いため、CacheStore が推奨
- CookieStore: セッション情報全てをクライアント側の cookie に保存する
  - デフォルト & Rails のおすすめ
  - 非常に軽量, 設定が不要, 改ざん防止, 漏洩防止
- コードは[ここらへん](https://github.com/rails/rails/tree/09a2979f75c51afb797dd60261a8930f84144af8/actionpack/lib/action_dispatch/middleware/session)

#### Cookie (ActionDispatch::Cookies < Object)

- `cookies`インスタンスメソッドからアクセス
- 署名済み cookie や 暗号化 cookie　など利用できる
  - https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
