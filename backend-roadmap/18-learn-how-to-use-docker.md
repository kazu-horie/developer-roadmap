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

#### dockerfile.yml

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
