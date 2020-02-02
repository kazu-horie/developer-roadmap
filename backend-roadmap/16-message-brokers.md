# 16. Message Brokers

## 目標

1. メッセージブローカーとは何かを理解し、メッセージング機能を実装できるようになる。

## 目次

- [メッセージ指向ミドルウェア](#メッセージ指向ミドルウェア)
- [メッセージキューイング](#メッセージキューイングキューイングシステム)
- [RabbitMQ 入門](#RabbitMQ-入門)

## メッセージ指向ミドルウェア

- 異なるソフトウェア間の非同期メッセージ転送を実現するミドルウェア
- 多くはメッセージキューイングというモデルで実現

> メッセージ指向ミドルウェア（メッセージしこうミドルウェア、英: Message-oriented middleware、MOM）とは、アプリケーションソフトウェア間のデータ通信ソフトウェアであり、一般に非同期メッセージパッシングに基づいたものを指す。

source: [メッセージ指向ミドルウェア - wikipedia](https://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8%E6%8C%87%E5%90%91%E3%83%9F%E3%83%89%E3%83%AB%E3%82%A6%E3%82%A7%E3%82%A2)

### 特徴

メッセージを送達する過程で保管、ルーティング、変換できる点

- 保管
  - 送信側と受信側が同時に接続されている必要がない
- ルーティング
  - 一つのメッセージを複数の受信者に配布可能
- 変換
  - 受信者と送信者共にメッセージ形式を考慮する必要がない

### 利点

- システムの疎結合化
- スケールアウト
- 耐障害性の向上

### メッセージングモデル

- Point-to-Point (1対1)
- Publisher / Subscriber (1対多)

## メッセージキューイング(キューイングシステム)

メッセージ指向ミドルウェアを実現する手法。

他にも、マルチキャストやブロードキャストによって実現する手法もある。

メッセージキューイングでは、メッセージブローカーなどのソフトウェアがメッセージキューと呼ばれる専用のデータ保管領域を管理することで実現。

source: [メッセージキューイング - IT用語辞典](http://e-words.jp/w/%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8%E3%82%AD%E3%83%A5%E3%83%BC%E3%82%A4%E3%83%B3%E3%82%B0.html)

### メッセージブローカー

- 一般的なモデル

![message-broker](/backend-roadmap/images/message-broker.png)

- Point-to-Point

![point-to-point](/backend-roadmap/images/point-to-point.png)

- Publisher / Subscriber

![publisher-subscriber.png](/backend-roadmap/images/publisher-subscriber.png)

- https://stackoverflow.com/questions/13202200/message-broker-vs-mom-message-oriented-middleware

### 有名なプロダクト

- [RabbitMQ](https://www.rabbitmq.com/)
  - プロトコルが豊富 (HTTP, AMQP, MQTT, STOMP)
- [Apache ActiveMQ](https://activemq.apache.org/)
  - 永続化のストレージが豊富
- [Apache Kafka](https://kafka.apache.org/)
  - メッセージ活用のための機能が豊富
- [ZeroMQ](https://zeromq.org/)
  - TCP だけでなく、 UDP, INPTOC などに対応
  - ブローカーレス

source: [ストリーム処理を支えるキューイングシステムの選び方](https://www.slideshare.net/laclefyoshi/ss-67658888)

![google-trends](/backend-roadmap/images/trends-queuing-system.png)

## RabbitMQ 入門

- [RabbitMQ 公式チュートリアル](https://www.rabbitmq.com/getstarted.html)を行う
- [ソースコード](https://github.com/kazu-horie/rabbitmq-tutorial)
- Ruby Client : [bunny GEM](https://github.com/ruby-amqp/bunny) (AMQP プロトコル実装)

### No.1 Hello World

- Queue の作成
- メッセージの送信
- メッセージの受信

![hello](/backend-roadmap/images/hello.png)

https://www.rabbitmq.com/tutorials/tutorial-one-python.html

### No.2 Work Queues

- ラウンドロビン送信
- 複数のワーカーへの分散メッセージ
- メッセージ確認の確認 (ACK)
- メッセージの永続化
- 公平な送信

![work-queue](/backend-roadmap/images/work-queue.png)

https://www.rabbitmq.com/tutorials/tutorial-two-python.html

### No.3 Publish / Subscribe

- Exchange という概念 (ルーター的役割)
  - 多くの場合は、Producer は Exchange にメッセージを送信するだけ
  - メッセージのルーティングは Exchange が担う (様々な種類: direct, topic, headers, fanout)
- Fanout タイプ
  - 全てのキューにブロードキャスト
- Exchange と キューのバインディング

![fanout-type](/backend-roadmap/images/fanout-type.png)

https://www.rabbitmq.com/tutorials/tutorial-three-python.html

### No.4 Routing

- 特定のメッセージのみをサブスクライブする方法
  - フィルタリング
- Direct タイプ
  - バインディングキーによるルーティング

![direct-type](/backend-roadmap/images/direct-type.png)

https://www.rabbitmq.com/tutorials/tutorial-four-python.html

### No.5 Topics

- より複雑な条件によるルーティングをする方法
- Topic タイプ
  - バインディングキーをドットつなぎで定義
  - バインディングキーに `#`, `*` が使用可能
  - バインディングキー次第では、実質 Fanout にも Direct にもなる

![topic-type](/backend-roadmap/images/topic-type.png)

### No.6 RPC

- RabbitMQ を用いて、スケーラブルな RPC サーバーを構築

(\* 翻訳があったので参考に)

- [RabbitMQ チュートリアル6 - Qiita](https://qiita.com/KojiOhki/items/54b743688cbcd8f3aaa1)

![rpc-system](/backend-roadmap/images/rpc-system.png)

https://www.rabbitmq.com/tutorials/tutorial-five-ruby.html

### TODO

- [プロダクトに利用する際の考慮事項](https://www.rabbitmq.com/production-checklist.html) を理解する
