# 18. Learn How to Use Docker

目標: Docker を用いた本番環境を構築できるようになる。

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

## Docker を用いた本番環境を構築する
