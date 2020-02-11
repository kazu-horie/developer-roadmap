# 17. Search Engine | 全文検索エンジン

## 目標

全文検索エンジンとは何かを理解し、全文検索機能として利用できるようになる

## 目次

1. [全文検索エンジン とは](#全文検索エンジン-とは)
1. [プロダクト](#プロダクト)
1. [記事アプリに全文検索を実装する (MySQL 5.7)](#記事アプリに全文検索を実装する-mysql-57)
1. [記事アプリに全文検索を実装する (ElasticSearch 7.6.0)](#記事アプリに全文検索を実装する-ElasticSearch-760)

## 全文検索エンジン とは

[全文検索](#全文検索-とは)を行うためのソフトウェア

![search-engine](/backend-roadmap/images/search-engine.png)

source: [今日から始める全文検索 - 三井明楽](https://speakerdeck.com/toranoana/jin-ri-karashi-meruquan-wen-jian-suo)

## 全文検索 とは

> 全文検索とは、文書から文字を検索する方式の一つで、複数の文書に含まれるすべての文字を対象に検索すること。

source: http://e-words.jp/w/%E5%85%A8%E6%96%87%E6%A4%9C%E7%B4%A2.html

**検索方法は２つ**

### grep 型 (逐次検索)

- 先頭から順番に探す
- 文書量に比例して検索時間も長くなってしまう
- 膨大の文書量には向いていない

### インデックス型

- インデックスから探す
- 膨大な文書量に向いている
- **検索エンジンと言われるソフトウェアが使っているのはこっち**

### 転置インデックス

- インデックス型で用いるインデックスの形式

| 単語 | 文書 ID |
| --- | --- |
| コンピュータ | 1, 2, 5 |
| 猫 | 4 |
| アルゴリズム | 2, 3|

source: [検索サーバーの仕組み - Chopesu](https://chopesu.com/programing/elasticsearch%e3%81%a8%e3%81%af%ef%bc%88%e6%a4%9c%e7%b4%a2%e3%82%b5%e3%83%bc%e3%83%90%e3%83%bc%ef%bc%89/#i)

#### 転置インデックスの抽出には以下の技術を持ちいる

- N-gram 法
  - Nで指定した単語の長さに、先頭から1文字ずつ文字列を分割する方式
  - N = 2 「東京都」 => 東京, 京都, 京
- 形態素解析法
  - 文字列を単語の最小の構成単位にする (分かち書き)
  - I am Horie => I | am | horie
  - 日本語は空白がないため、辞書を用いる必要がある

## プロダクト

### RDBMS

- [MySQL (の Full Text インデックス)](https://dev.mysql.com/doc/refman/5.7/en/innodb-fulltext-index.html)
- [Mroonga](https://mroonga.org/ja/)

### 検索サーバー (全文検索に特化したデータベース)

- [Apache Solr](https://lucene.apache.org/solr/)
- [Elastic Search](https://www.elastic.co/jp/elasticsearch)

### MySQL (の Full Text インデックス)

- MySQL に用意された転置インデックス
- [全文検索関数](https://dev.mysql.com/doc/refman/5.7/en/fulltext-search.html)
- スキーマ例

```sql
CREATE TABLE persons (
  name CHAR(255),
  introduction TEXT,
  FULLTEXT INDEX (introduction)
) DEFAULT CHARSET=utf8mb4;
```

- 全文検索クエリ

```sql
SELECT COUNT(*) AS count
FROM persons
WHERE
  MATCH (introduction)
  AGAINST ("anime" IN NATURAL LANGUAGE MODE);
```

### 検索サーバー / エンジン

高度な検索手段をたくさん用意している

- 類義語検索
- ふりがな検索
- 関連度に基づいた検索
- スペリングミス時の検索
- 空間検索
- ファセット検索

### Apache Solr

- Apache が開発している Lucene ベースの検索サーバ
- 長年の実績があり、信頼性も高い
- ElasticSearch に比べると、クラスタ、スケーリングが面倒
- N-Gram と 形態素解析 の両方が使用可能

### ElasticSearch

- Elastic 社が開発している Lucene ベースの検索サーバ
- RESTful API で CRUD 操作可能 (様々なシステムと連携しやすい)
- クラスタ、スケーリングが簡単
- N-Gram と 形態素解析 の両方が使用可能

source: [全文検索エンジンについて調べてみた - 虎の穴](https://toranoana-lab.hatenablog.com/entry/2019/02/06/103709)

[詳しくはこちら - Solr vs ElasticSearch](https://sematext.com/blog/solr-vs-elasticsearch-differences/#toc-solrsolrcloud-23)

![searchengine-trends](/backend-roadmap/images/search-engine-trends.png)

## 記事アプリに全文検索を実装する (MySQL 5.7)

今回は N-gram を用いた FullText Index を利用する。

- [制作物](https://github.com/kazu-horie/rails-blog-app/tree/feature/full-text-search)

### 実際の画面

- 検索フォームから記事を検索

![検索フォームから記事を検索](/backend-roadmap/images/all-articles-using-mysql.png)

- title と description から全文検索でヒットした記事を表示

![検索結果](/backend-roadmap/images/search-result-using-mysql.png)

### 実装手順

1. MySQL の設定
1. マイグレーション
1. 検索処理の実装

- 参考 [RailsとMySQLでN-gram化したデータを使って全文検索をFULL TEXT INDEXで実装する](https://github.com/kazu-horie/rails-blog-app/tree/feature/full-text-search/mysql)

### MySQL の設定

- N-gram のトークンサイズの最低値を ２ に変更 (デフォルトは3)
- my.cnf に以下を記載して、MySQL を再起動

```
[mysqld]
innodb_ft_min_token_size = 2
```

### マイグレーション

- FullText Index を作成

```ruby
class AddFullTextIndexToArticles < ActiveRecord::Migration[6.0]
  def change
    add_index :articles, :title, type: :fulltext
  end
end
```

### Model

```ruby
class Article < ApplicationRecord

...

  class << self
    def search(columns:, keywords:)
      where("MATCH (#{columns.join(',')}) AGAINST (? IN BOOLEAN MODE)",keywords)
    end
  end
end
```

### Controller

```ruby
class ArticlesController < ApplicationController

...

  def index
    if params[:q]
      @articles = Article.search(columns: [:title], keywords: params[:q])
      return
    end

    @articles = Article.all
  end
```

### 参考

- [Qiita - RailsとMySQLでN-gram化したデータを使って全文検索をFULL TEXT INDEXで実装する](https://qiita.com/nabeen/items/275e46d318103ff737b0)

## 記事アプリに全文検索を実装する (ElasticSearch 7.6.0)

### 画面

- 検索フォームから記事を検索

![検索フォームから記事を検索](/backend-roadmap/images/all-articles-using-es.png)

- title と description から全文検索でヒットした記事を表示
  - 類義語: `旅館,お宿,旅亭 => ホテル`

![検索結果](/backend-roadmap/images/search-result-using-es.png)

### 実装手順

1. 環境構築
2. Gem のインストール
3. 全文検索の実装
4. 類義語検索を追加

### 環境構築

#### ElasticSearch のインストール

```
$ brew tap elastic/tap
$ brew install elastic/tap/elasticsearch-full
```

https://www.elastic.co/guide/en/elastic-stack-get-started/7.6/get-started-elastic-stack.html#install-elasticsearch

#### kuromoji (日本語形態素解析エンジン) をインストール

```
$ elasticsearch-plugin install analysis-kuromoji
```

https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-kuromoji.html

### Gem のインストール

- [elasticsearch-rails](https://github.com/elastic/elasticsearch-rails)
  - Rails 用の ElasticSearch クライアント
- [elasticsearch-model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model)
  - ActiveRecord と ElasticSeach インデックスのマッピング
  - DB のデータと同期されるようによしなに API を叩いてくれる

```
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
```

### 全文検索機能を実装

#### Model

```ruby
module ArticleSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "articles_#{Rails.env}"

    settings do
      mapping do
        indexes :id,          type: 'integer'
        indexes :user_id,     type: 'integer'
        indexes :title,       type: 'text', analyzer: 'kuromoji'
        indexes :description, type: 'text', analyzer: 'kuromoji'
      end
    end

    # コミット時に API を叩くことによって DB の内容を ES に同期
    after_commit on: [:create] do
      __elasticsearch__.index_document
    end

    after_commit on: [:update] do
      __elasticsearch__.update_document
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

    # ES の Search API で全文検索
    def self.search(columns:, keywords:)
      __elasticsearch__.search(
        query: {
          multi_match: {
            query: keywords,
            fields: columns,
            type: 'cross_fields'
          }
        }
      ).records
    end
  end

  class_methods do
    def create_index!
      client = __elasticsearch__.client

      begin
        client.indices.delete index: index_name
      rescue StandardError
        nil
      end

      client.indices.create(
        index: index_name,
        body: {
          settings: settings.to_hash,
          mappings: mappings.to_hash
        }
      )
    end
  end
end

class Article < ApplicationRecord
  include ArticleSearchable
  ...
end
```

#### Controller

```ruby
class ArticlesController < ApplicationController
  def index
    if params[:q]
      @articles = Article.search(columns: [:title, :description], keywords: params[:q])
      return
    end

    @articles = Article.all
  end

  ...
end
```

### 類義語の対応

#### kuromoji に類義語を登録

```ruby
module ArticleSearchable
  ...

  included do
    ...

    settings analysis: analyzer_settings do
      mapping do
        indexes :id,          type: 'integer'
        indexes :user_id,     type: 'integer'
        indexes :title,       type: 'text', analyzer: 'custom_kuromoji'
        indexes :description, type: 'text', analyzer: 'custom_kuromoji'
      end
    end

  ...

  class_methods do
    ...

    def analyzer_settings
      {
        analyzer: {
          custom_kuromoji: {
            type: 'custom',
            char_filter: [],
            tokenizer: 'kuromoji_tokenizer',
            filter: [
              'kuromoji_baseform',
              'kuromoji_part_of_speech',
              'cjk_width',
              'kuromoji_stemmer',
              'lowercase',
              'synonym'
            ]
          }
        },
        filter: {
          synonym: {
            type: 'synonym',
            synonyms: [
              '旅館,お宿,旅亭 => ホテル'
            ]
          }
        }
      }
    end
  end
end
```
