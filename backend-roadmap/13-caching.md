# 13. Caching | キャッシュ

## 目標

- キャッシュとは何かを理解し、アプリケーションレベルでのキャッシュを実装できるようになる

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

Rails のキャッシュ機構の詳細については、以下のリンクを参照

-> https://railsguides.jp/caching_with_rails.html#activesupport-cache-memcachestore
