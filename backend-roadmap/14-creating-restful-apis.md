# 14. Creating RESTful APIs

## 目標

REST アーキテクチャスタイルを理解し、RESTful API を実装できるようになる。

## 目次

- [REST とは](#REST-とは)
- [REST を構成するアーキテクチャスタイル](#REST-を構成するアーキテクチャスタイル)
- [RESTful API を作成する](#RESTful-API-を作成する)

## REST とは

REST（REpresentational State Transfer）

> RESTはWebのアーキテクチャスタイルです。  
アーキテクチャスタイルは別名「(マクロ)アーキテクチャパターン」とも言い、
複数のアーキテクチャに共通する性質、様式、作法あるいは流儀を差す言葉です。

> 素のクライアント/サーバアーキテクチャスタイルにいくつかの制約を加えていくと、RESTというアーキテクチャスタイルになります。

source: 山本陽平, Web を支える技術, P.25 ~ P.26

> REST は複数のアーキテクチャスタイルを組み合わせて構築した複合アーキテクチャスタイルです。

source: 山本陽平, Web を支える技術, P31

## REST を構成するアーキテクチャスタイル

### クライアント / サーバ

- HTTP でクライアントとサーバが通信するスタイル
- クライアントのマルチプラットフォーム化
- サーバを増やすことで可用性の向上

### ステートレスサーバ

- クライアントのアプリケーション状態を管理しないサーバ
- サーバ側の実装を簡略化できる
- Cookie を使ったセッション管理はステートフル

### キャッシュ

- 一度取得したリソースをクライアント側で使い回す方式 (HTTP Cache)
- クライアント・サーバ間の通信を減らすことで、より効率的に処理できる

### 統一インターフェース

- URI で指し示したリソースに対する操作を、統一した限定的なインターフェースで行うスタイル

| メソッド | 振る舞い |
| --- | --- |
| GET | リソースの表現を取得する |
| POST | リソースを作成する |
| PATCH | リソースを部分変更する |
| PUT | リソースを変更する |
| DELETE | リソースを削除する |

- 通信が単純化され、通信の可視性、クライアントとサーバの実装の独立性が向上する

### 階層化システム

- いくつかの階層にシステムを分離するアーキテクチャスタイル
- ロードバランサを配置したり、プロキシを配置したり、AP / DB サーバを配置したり
- レガシーシステムの前に web サーバを挟むことでブラウザなどと接続できる
- クライアントからはシステムの詳細を意識する必要はない

### コードオンデマンド

- プログラムをサーバからダウンロードし、クライアント側でそれを実行するアーキテクチャスタイル
  - e.g. JavaScript
- クライアントの拡張性の向上
- クライアント・サーバ間でやりとりされるリソースが不明確になる

> RESTはアーキテクチャスタイルなので、実際にシステム(Webサービスもそれ以外も含む)を設計する際はそのシステムのアーキテクチャを作らなければなりません。RESTに基づいたアーキテクチャを構築する場合でも、RESTを構成するスタイルのうち、いくつかを除外しても構いません。たとえば、ステートフルではあるけれど、そのほかはRESTの制約に従っているアーキテクチャも考えられます。

source: 山本陽平, Web を支える技術, P.37

つまり、実際のシステムに合ったアーキテクチャスタイルを選択することを念頭に置きながら、実際に価値を提供できるシステムを開発することが重要。

また、REST に則って設計されていることを **RESTful** である、と言う。

## RESTful API を作成する

No.11 のブログアプリと同機能の RESTful (JSON) API を作成する。

[制作物はこちら](https://github.com/kazu-horie/rails-blog-api)

- [API 設計書 兼 API クライアント - Swagger](https://github.com/kazu-horie/rails-blog-api/blob/master/docs/swagger.yaml)
  - issue: swagger editor が yml のシンタックスエラーをはく
- [Rails の API モード - 公式ガイド](https://railsguides.jp/api_app.html)を参考に JSON API を実装
  - `rails new {app_name} --api` を用いれば API 様のコンポーネントや設定をジェネレートしてくれる
- [CORS 対応](https://github.com/cyu/rack-cors#rails-configuration) をする
- HTTP キャッシュに対応する

### HTTP キャッシュ に対応する

- HTTP キャッシュ についての主な仕様は、[MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Caching)にまとまっている
- こちらは、[Cache の制御に用いるヘッダー一覧](https://qiita.com/anchoor/items/2dc6ab8347c940ea4648)
  - issue: ここにまとめて整理したい

> GET requests should be cachable by default – until special condition arises. 

source: https://restfulapi.net/caching/

基本的に GET リクエストに対してのリソースはキャッシュできるようにしましょう。(条件付き GET とも呼ばれる)

とのことなので、HTTP キャッシュ機能は、**記事全件取得 API** と **記事取得 API** に実装した。

### Rails の HTTP キャッシュ

- [Rails の HTTP キャッシュ - 公式ガイド](https://railsguides.jp/caching_with_rails.html#%E6%9D%A1%E4%BB%B6%E4%BB%98%E3%81%8Dget%E3%81%AE%E3%82%B5%E3%83%9D%E3%83%BC%E3%83%88)
- デフォルトで、Rack::Etag, Rack::ConditionGet Middleware が etag を用いたHTTP キャッシュを実行してくれている
  - HTTP キャッシュ既に自体はできている！

初回リクエスト

![request-1](/backend-roadmap/images/request-1.png)

2 回目リクエスト

![request-2](/backend-roadmap/images/request-2.png)

### Rails の デフォルトのHTTP キャッシュを改善！

[Qiita@cuzicさんのこの記事が全てです。](https://qiita.com/cuzic/items/326e8600dc596de6636a)

要するに、

- リソース鮮度の評価 (HTTPキャッシュの可否) はミドルウェアが担っているので、送信しないかもしれないレスポンスボディを毎回作っている
  - ネットワークのトラフィック量には恩恵があるけど、CPU 負荷や実行時間はほとんど変わらない
- リソースの鮮度の評価を、コントローラ内でやればやること少なくなる
  - HTMLのレンダリングとかJSONのシリアライズとか

-> [`ActionController::ConditionalGet#fresh_when`](https://api.rubyonrails.org/classes/ActionController/ConditionalGet.html#method-i-fresh_when) を使えば良い

```ruby
def index
  @articles = Article.all

  render json: @articles unless fresh_when(etag: @articles)
end
```

### RESTful ?

- クライアントサーバ -> OK (もちろん)
- ステートレスサーバ -> OK (ステートを持つ機能はないため)
- 統一インターフェース -> OK ([Rails のエンドポイント設計は REST 指向](https://railsguides.jp/routing.html#%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0-rails%E3%81%AE%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88))
- 階層化システム -> N/A (規模的にも必要なかったため)
- コードオンデマンド -> N/A (API のため)
- キャッシュ -> OK (上記の通り)

(おそらく) RESTful !!!

### 参考

- [Webを支える技術, 山本陽平 著](https://gihyo.jp/magazine/wdpress/plus/978-4-7741-4204-3)
- [Representational State Tranfer, Roy Thomas Fielding](https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm)
- [Qiita@uneosy - RESTful API設計におけるHTTPステータスコードの指針](https://qiita.com/uenosy/items/ba9dbc70781bddc4a491)
- [HTTP レスポンスステータスコード](https://developer.mozilla.org/ja/docs/Web/HTTP/Status)
