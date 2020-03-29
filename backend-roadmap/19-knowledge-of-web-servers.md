# 19. Knowledge of Web Servers

## 目標

Web サーバーに用いられるアーキテクチャを理解し、プロダクトを利用できるようになる。

## Web サーバー とは

Web サービスを提供するコンピュータ

= Web サーバーソフトウェアを動かしているコンピュータ

(一般にはこのソフトウェアのことを Web サーバーとも呼んでいる)

## Web サーバーソフトウェアの種類

[シェア率の調査結果](https://w3techs.com/technologies/history_overview/web_server) から

1. Apache: 約40%
2. Nginx: 約32%
3. Google Servers: 約13%
4. IIS: 約8%

![webサーバーのシェア率](/backend-roadmap/images/web-servers-share.png)

source: https://w3techs.com/technologies/history_overview/web_server

## Apache HTTP Server

- OSS
- マルチプロセスモデル (リクエストごとにプロセスをフォークする)
  - 並行にリクエストを処理できる
  - メモリを大量に消費する

## Nginx

- OSS
- イベント駆動モデル (接続管理やリクエスト処理を、イベントループにより 1 つのスレッドで実行する)
  - C10K 問題の解決

## TODO

- イベント駆動モデルについて調べる
- Nginx を制作物に組み込む
