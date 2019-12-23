# 13. Caching | キャッシュ

## 目標

キャッシュとは何かを理解し、アプリケーションレベルでのキャッシュを実装できるようになる

## 目次

- [キャッシュとは](#キャッシュとは)
- [インメモリデータベースの種類](#インメモリデータベース)
- [Redis を使ってみる](#Redis-を使ってみる)
- [No.11の制作物 (Rails App) にキャッシュ機能を実装する](#No.11の制作物に-(Rails)-にキャッシュ機能を実装する)

## キャッシュとは

> コンピューティングにおいて、キャッシュは、データのサブセットが保存される高速のデータストレージレイヤーで、通常は一時的な性質のものです。これにより、それ以降に同じデータのリクエストが発生した場合、データのプライマリストレージロケーションにアクセスするよりも高速にデータが供給されます。キャッシュにより、以前に取得または計算されたデータを効率的に再利用できるようになります。

> 通常、データベース内のデータは完全で耐久性があるのに対して、一般的にキャッシュにはデータのサブセットが一時的に保存され、容量よりも速度が優先されます。

source: https://aws.amazon.com/jp/caching/

Web システムにおけるキャッシュの利用例

![aws-caching](/backend-roadmap/images/aws-caching.png)

source: https://aws.amazon.com/jp/caching/

アプリケーションレイヤーでは、主にインメモリデータベースをキャッシュに用いている。

## インメモリデータベースの種類

### [Memcached](https://memcached.org/)

- KVS
- 文字列で保存
- シンプル
- レプリケーションにはミドルウェアが必要

### [Redis](https://redis.io/)

- KVS
- **デファクトスタンダード**
- 様々な型で保存
- スケールアウト機能を提供

### [Riak](https://docs.riak.com/)

- KVS
- バイナリで保存

![google-trends](/backend-roadmap/images/google-trends-2.png)

### Memcached と Redis の違い

![redis-and-memcached](/backend-roadmap/images/redis-and-memcached.png)

source: https://aws.amazon.com/jp/elasticache/redis-vs-memcached/

## Redis を使ってみる

### Redis CLI

```
$ redis-cli # redis-cli 起動

$ set key-hoge value-hoge # 保存
# => "OK"

$ get key-hoge # 取得
# => "value-hoge"
```

### Ruby Client ([redis gem](https://rubygems.org/gems/redis/))

```
require 'redis'

redis = Redis.new
# redis = Redis.new(host: 'localhost', port: 6379)

redis.set('key-hoge', 'value-hoge')
# => "OK"

redis.get('key-hoge')
# => "value-hoge"
```

オブジェクトの格納

```
require 'json'

redis.set('key-hoge', ['value-hoge-1', 'value-hoge-2'].to_json)

JSON.parse(redis.get('key-hoge'))

```

## No.11 の制作物 (Rails App) にキャッシュ機能を実装する

### 実装するキャッシュの概要

記事データ (ActiveRecord) をキャッシュすることで、RDB へのアクセスを少なくし、記事の取得処理の実行時間を早くする。

Rails の SQLキャッシュとの違いは、生存期間。既存の SQL キャッシュの生存期間は同一アクション内。

### アプローチ

Rails の低レベルキャッシュ機構を用いて、ActiveRecord のキャッシュを実装する。

- `Article.find` で ActiveRecord インスタンスをキャッシュから取得、存在しない場合は SQL 実行後にキャッシュに格納
- `Article#update` で更新した場合は、新しい ActiveRecord インスタンスをキャッシュに格納

- [制作物レポジトリ](https://github.com/kazu-horie/rails-blog-app/tree/feature/activerecord-cache)

### ソースコード

```ruby
class ApplicationRecord < ActiveRecord::Base
  include RecordCache

  self.abstract_class = true
end
```

```ruby
module RecordCache
  extend ActiveSupport::Concern

  module ClassMethods
    def find(id)
      record = read_cache(id)

      return record if record

      record = super(id)

      write_cache(record)

      record
    end

    def cache_key(record_id)
      "#{to_s.downcase.pluralize}/#{record_id}"
    end

    def read_cache(record_id)
      serialized_record = Rails.cache.read(cache_key(record_id))

      return unless serialized_record

      Article.allocate.init_with(serialized_record)
    end

    def write_cache(record)
      serialized_record = {}
      record.encode_with(serialized_record)
      Rails.cache.write(cache_key(record.id), serialized_record)
    end
  end

  def update(params)
    super(params)

    self.class.write_cache(self)
  end
end

```

### テスト (実行確認)

- キャッシュ未実装時

```log
Started GET "/articles/7" for ::1 at 2019-12-14 09:54:03 +0900
Processing by ArticlesController#show as HTML
  Parameters: {"id"=>"7"}
  Article Load (0.6ms)  SELECT `articles`.* FROM `articles` WHERE `articles`.`id` = 7 LIMIT 1
  ↳ app/models/application_record.rb:16:in `find'
  Rendering articles/show.html.erb within layouts/application
  Rendered articles/show.html.erb within layouts/application (Duration: 0.4ms | Allocations: 53)
[Webpacker] Everything's up-to-date. Nothing to do
Completed 200 OK in 28ms (Views: 10.2ms | ActiveRecord: 0.6ms | Allocations: 3608)
```

- キャッシュ実装時

```log
Started GET "/articles/7" for ::1 at 2019-12-14 09:56:19 +0900
Processing by ArticlesController#show as HTML
  Parameters: {"id"=>"7"}
  Rendering articles/show.html.erb within layouts/application
  Rendered articles/show.html.erb within layouts/application (Duration: 0.4ms | Allocations: 53)
[Webpacker] Everything's up-to-date. Nothing to do
Completed 200 OK in 12ms (Views: 11.1ms | ActiveRecord: 0.0ms | Allocations: 3051)
```

**SQLが実行されていない -> キャッシュ成功**

### ベンチマーク

- MacBook Pro (Retina, 13-inch, Early 2015)
- 2.7 GHz デュアルコアIntel Core i5
- 16 GB 1867 MHz DDR3
- macOS 10.15.1

記事の詳細画面 (GET /articles/{articles}) の showアクション内で計測

```ruby
class ArticlesController < ApplicationController
  def show
    benchmark('ArticlesController#show') do
      @article = Article.find(params[:id])
    end
  end
end
```

キャッシュなし

```log
Started GET "/articles/7" for ::1 at 2019-12-14 09:54:03 +0900
...
articles#show (8.3ms)
...
Completed 200 OK in 28ms (Views: 10.2ms | ActiveRecord: 0.6ms | Allocations: 3608)
```

キャッシュあり

```log
Started GET "/articles/7" for ::1 at 2019-12-14 09:56:19 +0900
...
articles#show (1.6ms)
...
Completed 200 OK in 12ms (Views: 11.1ms | ActiveRecord: 0.0ms | Allocations: 3051)
```

- キャッシュなし
  - 大体 6 ~ 8 ms
- キャッシュあり
  - **2 ms 未満**

大幅に実行時間を早くすることに成功

### 参考

- [公式 - Rails のキャッシュ機構について](https://railsguides.jp/caching_with_rails.html#activesupport-cache-memcachestore)
- [ActiveRecord::QueryMethodsのselectメソッドについて深掘りしてみた
](https://techracho.bpsinc.jp/shin1rok/2019_08_20/79317)
- [Ruby on Railsのパーシャルとnew_record？メソッドを利用しフォームを簡素化する](https://programming-beginner-zeroichi.jp/articles/35)
