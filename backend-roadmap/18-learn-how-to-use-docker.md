# 18. Learn How to Use Docker

目標: Docker を用いた開発環境と本番環境を構築できるようになる。

## 目次

1. [Docker とは](#Docker-とは)
1. [Docker を用いた開発環境を構築する](#Docker-を用いて開発環境を構築する)
1. [Docker を用いた本番環境を構築する](#Docker-を用いて本番環境を構築する)

## Docker とは

> Dockerは、コンテナと呼ばれるOSレベルの仮想化環境を提供するオープンソースソフトウェアである。VMware製品などの完全仮想化を行うハイパーバイザ型製品と比べて、ディスク使用量は少なく、仮想環境 (インスタンス) 作成や起動は速く、性能劣化がほとんどないという利点を持つ。

- コンテナ型の仮想化ソフトウェア
  - 1つの OS に「コンテナ」と呼ばれる「他のユーザーから隔離されたアプリケーション実行環境」を作り、あたかも個別独立したサーバのように使おうというのがコンテナ仮想化

![containers](/backend-roadmap/images/containers.png)

source: https://www.docker.com/resources/what-container

### 他の仮想化技術

- 仮想マシン (VM) 型
  - ホストOS型
  - ハイパーバイザー型

![vm](/backend-roadmap/images/vm.png)

source: https://www.docker.com/resources/what-container

### Docker の特徴

- 軽量
  - 仮想マシンは環境ごとにゲスト OS が必要 (数十 GB)
  - Docker はホストの Linux カーネルを共有するため必要なリソースは 数十 MB
- Infrastructure as Code
  - Dockerfile にスクリプトを書くようなシンプルさでインフラを構成することができる
- Immutable Infrastructure
  - Blue-Green Deployment
  - トラブルやダウンタイムを減らし、切り戻しもすることができる

## Docker を用いた開発環境を構築する

### ソースコード

https://github.com/kazu-horie/rails-blog-app/tree/feature/docker-dev-env/config

### 作業内容

1. Rails コンテナの作成
1. MySQL コンテナの作成
1. Redis コンテナの作成
1. Elasticsearch コンテナの作成

### 1. Rails コンテナの作成

#### Dockerfile

```Dockerfile
FROM node:13.6.0 as node
FROM ruby:2.6.3

COPY --from=node /opt/yarn-* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg

ENV ENTRYKIT_VERSION 0.4.0

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

RUN mkdir /app

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock

RUN gem install bundler

ENTRYPOINT [ \
  "prehook", "ruby -v", "--", \
  "prehook", "bundle install -j3 --quiet", "--", \
  "prehook", "yarn install", "--" ]
```

#### docker-compose.yml

```yml
ersion: '3.6'
services:
  rails:
    build:
      context: .
      dockerfile: "Dockerfile"
    command: bash -c "/wait && rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - ".:/app"
      - "bundle:/usr/local/bundle"
      - "node_modules:/app/node_modules"
    ports:
      - "4000:3000"
    tty: true
    stdin_open: true
volumes:
  bundle:
  node_modules:
```

#### multi stage build

イメージの構築時と実行時を分離できる

```dockerfile
FROM node:13.6.0 as node
FROM ruby:2.6.3

COPY --from=node /opt/yarn-* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg
```

nodejs と yarn を apt-get するより、49 MB 小さい

![multi-stage-build](/backend-roadmap/images/using-multi-stage-build.png)
![using-aptget](/backend-roadmap/images/using-aptget.png)

#### [Entrykit](https://github.com/progrium/entrykit)

- Docker の enrtypoint ツール
- Docker コンテナの起動時に色々してくれる

今回は prehook コマンドを使用

- メインプロセス起動時に複数コマンドを実行できる

```dockerfile
ENTRYPOINT [ \
  "prehook", "ruby -v", "--", \
  "prehook", "bundle install -j3 --quiet", "--", \
  "prehook", "yarn install", "--" ]
```

参考: [DockerでRails+Webpackerの開発環境を構築するテンプレート](https://qiita.com/kawasin73/items/b8b092e9b763387c6ba8)

### 2. MySQL コンテナの作成

簡単。イメージを取ってきて設定するだけ

#### docker-compose.yml

```yml
services:
  rails:
    ...
    environment:
      - "DATABASE_USERNAME=root"
      - "DATABASE_PASSWORD=password"
      - "DATABASE_HOST=db"
      - "DATABASE_PORT=3306"
    depends_on:
      - db
  db:
    image: "mysql:5.7"
    environment:
      - "MYSQL_ROOT_PASSWORD=password"
    volumes:
      - "db-data:/var/lib/mysql"
    ports:
      - "4306:3306"
volumes:
  db-data:
```

参考: https://hub.docker.com/_/mysql

### 3. Redis コンテナを作成する

簡単。

#### docker-compose.yml

```yml
version: '3.6'
services:
  rails:
    ...
    depends_on:
      ...
      - redis
  db:
    ...
  redis:
    image: "redis:5.0.7"
    ports:
      - "7379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
volumes:
  ...
  redis-data:
```

参考: https://hub.docker.com/_/redis/

### 4.Elasticsearch コンテナを作成

#### Dockerfile

```dockerfile
FROM docker.elastic.co/elasticsearch/elasticsearch:7.6.0

RUN bin/elasticsearch-plugin install analysis-kuromoji
```

#### docker-compose.yml

```yml
version: '3.6'
services:
  rails:
    ...
    environment:
      ...
      - "ELASTICSEARCH_HOST=es:9200/"
    depends_on:
      ...
      - es
  db:
    ...
  redis:
    ...
  es:
    build:
      context: ./docker/es
      dockerfile: "Dockerfile"
    environment:
      - node.name=es01
      - cluster.initial_master_nodes=es01
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - xpack.security.enabled=false
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es-data:/usr/share/elasticsearch/data
    ports:
      - 10200:9200
volumes:
  ...
  es-data:
```

#### [docker-compose-wait](https://github.com/ufoscout/docker-compose-wait)

Elasticsearch の起動が長い。2分くらい。

Rails が initialize 時に elasticsearch にインデックスを貼ろうするため、Elasticsearch が起動完了していない場合に、コネクションエラーが起きる。

- docker-compose の depends_on は起動順のみの担保で、起動完了は待ってくれない。
- そこで [docker-compose-wait](https://github.com/ufoscout/docker-compose-wait)

Rails の Dockerfile

```dockerfile
...

# elasticsearch コンテナの起動完了を待つ
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

ENTRYPOINT ...
```

docker-compose.yml

```yml
version: '3.6'
services:
  rails:
    ...
    environment:
      - "WAIT_HOSTS=es:9200"
    command: bash -c "/wait && rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
  ...
```

## Docker を用いた本番環境を構築する

本番環境のURL: http://production-rails-blog-app-lb-481350589.ap-northeast-1.elb.amazonaws.com

- Rails (ECS) + MySQL (RDS)

### 作業内容

- ソースコードの変更 (ヘルスチェック API の追加)
- ECR へ docker イメージを push
- VPC 作成
- RDS インスタンスの作成
- ELB の作成
- ECS タスクの作成
- ECS クラスターの作成
- ECS サービスの作成
- セキュリティグループのインバウンドルール変更

### ECR へ docker イメージを push

- ECR の画面からリポジトリを作成しておく

```
# docker イメージのビルド
$ docker build -t rails_blog_app-rails -f ./Dockerfile.deployment .

# イメージのタグ付け
$ docker tag {rails_blog_app-rails}:latest {リポジトリURI}:{新しく作成するタグ名}

# イメージを Push
$ docker push {リポジトリURI}:{作成したタグ名}
```

### EIP の作成

![eip](/backend-roadmap/images/eip.png)

### VPC の作成

以下のサブネット構成の VPC を作成する

| | ap-northeast-1a | ap-northeast-1c |
| --- | --- | --- |
| Public | 10.0.0.0/24 | 10.0.2.0/24 |
| Private | 10.0.1.0/24 | 10.0.3.0/24 |

VPC ウィザードの起動 -> **パブリックとプライベート サブネットを持つ VPC** を選択

以下の様な設定で、VPC と AZ ap-northeast-1a のサブネットを作成する

![vpc](/backend-roadmap/images/vpc.png)

次に**サブネットの作成**から AZ ap-northeast-1c のサブネットを作成する

- Public サブネット

![subnet-public](/backend-roadmap/images/subnet-public.png)

- Private サブネット

![subnet-private](/backend-roadmap/images/subnet-private.png)

public-1a サブネットの**自動割り当て IP 設定**を有効にする

![subnet-public-config](/backend-roadmap/images/subnet-public-config.png)

public-1c サブネットには、プライベートルートテーブルが設定されているので、 public-1a と同じパブリックルートテーブルを設定する

![subnet-route-table](/backend-roadmap/images/subnet-route-table.png)

### RDS インスタンスの作成

作成した VPC を設定すること

![rds](/backend-roadmap/images/rds.png)

### ELB の作成

Application Load Balancer を選択する

- 基本的な設定は以下
  - 構築した VPC を選択し、２つの サブネット を選択

![elb-step-1](/backend-roadmap/images/elb-step-1.png)

- セキュリティグループは新たに作成する

![elb-sg](/backend-roadmap/images/elb-sg.png)

- ルーティングの設定は以下
  - ヘルスチェックのパスは利用している Gem の okcomputer に合わせる

![elb-tg](/backend-roadmap/images/elb-tg.png)

### ECS タスクの作成

**タスクとコンテナの定義の設定**を以下に設定

- タスク起動タイプ = EC2
- ネットワークモード = bridge

![task-and-container-config](/backend-roadmap/images/task-and-container-config.png)

Rails コンテナを追加

スタンダード設定は以下

![task-standard](/backend-roadmap/images/task-standard.png)

環境設定は以下

![task-env](/backend-roadmap/images/task-env.png)

### ECS クラスタの作成

クラステンプレートは **EC2 Linux + ネットワーキング** を選択

クラスターの設定は以下

![cluster-config](/backend-roadmap/images/cluster-config.png)

ネットワーキング設定は以下

![cluster-network](/backend-roadmap/images/cluster-network.png)

### ECS サービスの作成

サービス設定は以下

![service-config](/backend-roadmap/images/service-config.png)

ネットワーク構成は以下

![network-config](/backend-roadmap/images/network-config.png)

### セキュリティグループの設定

ECS インスタンスに以下の Inbound ルールを追加

- ELB のセキュリティグループからの通信を許可
- SSH 通信を許可

![sg-ecs-instance](/backend-roadmap/images/sg-ecs-instance.png)

RDS に以下の Inbound ルールを追加

- ECS インスタンスのセキュリティグループからの 3306 への通信を許可

![sg-rds-instance](/backend-roadmap/images/sg-rds-instance.png)

### DB のマイグレート

```
# SSH 接続
$ ssh -i "{キーファイル}" ec2-user@{ECS インスタンスのURI}

# コンテナに bash で入る
$ docker exec -it {コンテナ名} /bin/bash

# マイグレート
$ bin/rails db:create
$ bin/rails db:schema:load
```

### ElastiCache クラスターの作成

クラスターエンジンを Redisに選択すること

![redis-instance](/backend-roadmap/images/redis-instance.png)

ECS タスクの環境変数に Redis インスタンスのエンドポイントを追加

![redi-url](/backend-roadmap/images/add-redis-url-task.png)

Redis インスタンスのセキュリティグループの inbound ルールに 6379 ポートを許可するよう設定

![sg-redis](/backend-roadmap/images/sg-redis.png)

### Elasticsearch Service ドメインの追加

アクセスとセキュリティの設定は以下

- VPC アクセスを選択
- VPC は作成済のVPC
- サブネットはプライベート

![es-service-network](/backend-roadmap/images/es-service-network.png)

アクセスポリシーはオープンアクセスを許可

![es-service-access-policy](/backend-roadmap/images/es-service-access-policy.png)

インバウンドルールに 80 ポートを許可するよう設定

![sg-es](/backend-roadmap/images/sg-es.png)

ECS タスクの環境変数に Elasticsearch ドメインのエンドポイントを追加

![env-es-host](/backend-roadmap/images/env-es-host.png)



## 参考

- [初心者でもできる！ ECS × ECR × CircleCIでRailsアプリケーションをコンテナデプロイ](https://qiita.com/saongtx7/items/f36909587014d746db73)
- [Rails ApplicationからAmazon Elasticsearch Serviceを使って素早く全文検索を可能にする](https://qiita.com/kyouryu_/items/061b3bc47c1d64b37818)
