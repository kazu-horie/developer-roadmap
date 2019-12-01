# 12. Learn a NoSQL Database

## 目次

1. [NoSQL とは](#NoSQL-とは)
1. [NoSQL の位置づけ](#NoSQL-の位置づけ)
1. [NoSQL のデータモデルの種類](#NoSQL-のデータモデルの種類)

## NoSQL とは

NoSQL (Not only SQL) は、非リレーショナルデータベースを表す総称 (バズワード)。
データ処理における**3つのV**の増加による**RDBの課題**を解決するためにNoSQLが登場した。

### ３つのVの増加

- Volume (データ量) の増加
- Velocity (処理速度) の増加
- Variety (多様性) の増加

#### Volume, Velocity の増加による課題

- 大量データの処理
- 高速なデータ処理

RDBでは、スケールアップは性能の限界、スケールアウトは構造上の限界がある

#### Variety の増加による課題

- 半構造化データの処理
- 複雑なデータ間の関係を持つデータの処理

|データの分類||説明|
|---|---|---|
|非リレーショナルデータ| 非構造化データ | 構造がない (e.g. バイナリテキスト) |
|非リレーショナルデータ| 半構造化データ | 構造はあるがスキーマがない (e.g. JSON, XML) |
|リレーショナルデータ| 構造化データ | スキーマがあり、構造が変わりにくい |

RDBでは、半構造化データ、複雑な関係を持つデータの格納が困難

これらの課題を **NoSQL** が解決する

### NoSQL の種類

- KVS (キーバリューストア)
  - キーでアクセスするシンプルな使い方がメイン
  - キーバリューモデルとワイドカラムモデルの二つに大別される
- DocDB
  - KVSの特徴に加え、JSONを扱う機能が豊富
  - インデックス, JSONの特定のクエリ
- グラフDB
  - ノード間の関連からなるデータ構造
    - 多様な関係性(e.g. 友達である、フォローしている、交際している)を表現することが得意
  - スケールアウトできないが、RDB以上に複雑なデータ処理が可能

## NoSQL の位置づけ

![databases](/backend-roadmap/images/database.png)

source: https://www.slideshare.net/recruitcojp/rdbnosqlnosql?qid=eed1f48e-19cb-45a5-a053-7488409f7f22&v=&b=&from_search=25

- ターンアラウンドタイム重視
  - クエリの応答時間を重視
  - オペレーション = 任意のタイミングでクエリが発行され、一部のデータに対してCRUDを行うこと
- スループット重視
  - 単位時間あたりのデータ処理量を重視
  - 分析 = 一度だけデータを書き込んで、データ全部に対して集計や抽出をする
- スケールアウト
  - ノードを増やして処理を分散することで、データベースの性能を拡張する手法
- スケールアップ
  - ノード自体のスペックを上げて、データベースの性能を拡張する手法

### KVS / DocDB と RDB (OLTP) の違い

- とにかくスケールアウトしやすい
  - 大量のデータを高速に処理できる
- BASE 特性
  - Basically Available (基本的にどんな時でも動き)
  - Soft-state (常に整合性を保っている必要はないが)
  - Eventual Consistency (結果として整合性が取れている状態に至る)

### グラフDB と RDB (OLTP) の違い

- RDBでは表現が困難なデータの繋がりを簡単に表現できる
  - RDBでは時間がかかりすぎる結合でデータを辿っていく複雑なクエリを高速に実行できる

### CAP の定理

分散システムにおいては、 Consistency (整合性), Availability (可用性), tolerance to network Partitions (分断耐性) の3つのうち最大2つまでしか満たすことはできない。

- C (整合性): 全てのノードで同時に同じデータが見える。
- A (可用性): 単一障害など一部のノードで障害が起きても処理の継続性が失われない。
- P (分断耐性): ノード群までネットワークが分断されても、正しく動作する。

![nosql](/backend-roadmap/images/nosql.png)

source: https://blog.nahurst.com/visual-guide-to-nosql-systems

#### CA 特性

- Active-Standby のクラスタ構成のデータベース
- RDB (OLTP) が該当
- Active ノードと Standby ノードのネットワークが切れたら終わり

#### CP 特性

クラスタを構成する全てのノードに対して同じデータを見ることができ、ネットワークが分断しても正しく動作する

- ネットワークが切れた際に過半数より多いノードと通信できる集団をクラスタとして動作する
- Redis, MongoDB, HBase などが該当

#### AP 特性

クラスタを構成する全てのノードに読み書きができて、ネットワークが切れたとしても読み書きが途切れない

- Git のような分散レポジトリ
- CouchDB, Riak, Amazon DynamoDB

## NoSQL のデータモデルの種類

### キーバリュー

![key-value](/backend-roadmap/images/key-value.png)

- １つのキーに対して１つの値をとる
  - 値は様々な型をとることができる
- 値に格納できる型はプロダクトによって異なる (バイナリだけとか)
  - アプリケーションのドライバを通すことで、どんなデータでも格納できる

### ワイドカラム

![wide-column](/backend-roadmap/images/wide-column.png)

- １つのキーに対して複数の列をとる
  - RDBの列とは異なり、型が固定されておらず、列の数も自由

### ドキュメント

![document](/backend-roadmap/images/document.png)

- 階層構造データを格納することができる
- ドキュメントを入れ子にできる
- フォーマットはJSON

### グラフ

![graph](/backend-roadmap/images/graph.png)

- 点と、それらを結ぶ線を用いてデータを表す
- 点: ノード, 線: リレーション, 属性: プロパティ
  - この3つのデータをデータ構造として扱う

### 参考資料

[RDB技術者のためのNoSQLガイド](https://bookwalker.jp/ded1d645ce-db98-48cd-9f66-0f5bee079716/?adpcnt=7qM_Vsc7&gclid=EAIaIQobChMI8vHg2sSS5gIVlKuWCh2Z0wuEEAQYASABEgL3efD_BwE)
