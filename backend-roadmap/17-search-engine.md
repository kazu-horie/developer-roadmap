# 17. Search Engine | 全文検索エンジン

## 目標

全文検索エンジンとは何かを理解し、全文検索機能として利用できるようになる

## 目次

1. [全文検索エンジン とは](#全文検索エンジン-とは)
1. [プロダクト](#プロダクト)
1. [記事アプリに全文検索を実装する](#記事アプリに全文検索を実装する)

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

- [MySQL (の Full Text インデックス)](https://dev.mysql.com/doc/refman/5.6/ja/innodb-fulltext-index.html)
- [Mroonga](https://mroonga.org/ja/)

### 検索サーバー (全文検索に特化したデータベース)

- [Apache Solr](https://lucene.apache.org/solr/)
- [Elastic Search](https://www.elastic.co/jp/elasticsearch)

### MySQL (の Full Text インデックス)

- MySQL で用意された転置インデックス
- [全文検索関数](https://dev.mysql.com/doc/refman/5.6/ja/fulltext-search.html)
- 難点
  - 日本語未対応
  - 更新が遅い
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

### Mroonga

全文検索エンジンである Groonga をベースとした MySQL の全文検索に特化したストレージエンジン。

- 更新性能の向上
- 検索性能の向上
- 位置情報検索のサポート

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

### Elastic Search

- Elastic 社が開発している Lucene ベースの検索サーバ
- RESTful API で CRUD 操作可能 (様々なシステムと連携しやすい)
- クラスタ、スケーリングが簡単
- N-Gram と 形態素解析 の両方が使用可能

source: [全文検索エンジンについて調べてみた - 虎の穴](https://toranoana-lab.hatenablog.com/entry/2019/02/06/103709)

[詳しくはこちら - Solr vs ElasticSearch](https://sematext.com/blog/solr-vs-elasticsearch-differences/#toc-solrsolrcloud-23)

![searchengine-trends](/backend-roadmap/images/search-engine-trends.png)

## 記事アプリに全文検索を実装する
