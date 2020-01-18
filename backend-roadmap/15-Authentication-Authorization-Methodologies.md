# 15. Authentication/Authorization Methodologies

## 目標

1. 認証の方法論を理解し、認証機能を実装できるようになる。
1. 認可の方法論を理解し、認可を用いた機能を実装できるようになる。

## 目次

- [認証 とは](#認証-とは)
- [認証方式](#認証方式)
- [認証機能の実装](#認証機能の実装)
- [認可 とは](#認可-とは)
- [認可方式](#認可方式)
- [OpenID Connect](#OpenID-Connect)
- [認可を用いた機能の実装](#認可を用いた機能の実装)

## 認証 とは

> 認証とは、対象の正当性や真正性を確かめること。ITの分野では、相手が名乗った通りの本人であると何らかの手段により確かめる本人確認（相手認証）のことを単に認証ということが多い。

source: http://e-words.jp/w/%E8%AA%8D%E8%A8%BC.html

> 通信の相手が 誰 (何) であるかを確認すること

source: https://dev.classmethod.jp/security/authentication-and-authorization/

認証は２つの意味がある

- 二者間認証/相手認証 (Authentication)
  - 被認証者が認証者に対してパスワードやハッシュ値などの情報を提供し、認証者はそれをもとに被認証者の正当性を判断する認証
- 三者間認証/第三者認証 (Certification)
  - ディジタル署名や印鑑証明のように、被認証者の正当性を認証者が判断する際、第三者機関の管理する情報を利用する認証

source: https://www.fom.fujitsu.com/goods/pdf/security/fpt1610-2.pdf

Authentication は二者間認証を指すため、以下で取り上げる認証は二者間認証とする。

## 認証方法の分類 (WYK / WYH / WYA)

- WYK (What You Know) 認証
  - パスワードや暗証番号など、本人のみが知っている知識によって本人確認をする認証方法
- WYH (What You Have) 認証
  - ディジタル証明書やIC カードなど、本人が所有しているもので正当性を確認する認証方法
- WYA (What You Are) 認証
  - 指紋や網膜など、本人の生体情報の特徴で正当性を確認する認証方法

## 認証方式

### Basic 認証

- ID と Password を Base64 でエンコードして送信する
  - Header: `Authorization: Basic Zm9vOmJhcg==`
- [RFC 7617](https://tools.ietf.org/html/rfc7617)

#### メリット

- ほとんどの Web ブラウザ/サーバ で実装されている
- ２度目以降はブラウザがよしなにしてくれる
- 一般公開されておらず利用者が限定されている内部的なWebサービス向け

#### デメリット

- 平文がやりとりされるため、通信を覗き見されると漏洩する
- ログイン・ログアウト(認証に期間を与える)機能がない

### Digest 認証

- Basic 認証の強化版
- クライアント側で Password をハッシュ化する点が Basic 認証と異なる
- [RFC 7616](https://tools.ietf.org/html/rfc7616)

#### メリット

- パスワードそのものはやりとりされないため、Basic 認証よりはセキュリティが高い

#### デメリット

- ログイン・ログアウト(認証に期間を与える)機能がない

### Cookie 認証

- セッション (cookie) を用いて認証する
- アプリケーションレベルの認証方式

#### メリット

- ログイン・ログアウト機能が実装可能
- シングルサインオン機能を実装可能
- セッション管理が可能

#### デメリット

- アプリケーションレベルで実装が必要
- サーバがステートフルになる

### Token (Bearer) 認証

- 一度認証された者に対して、トークンを発行し以降はそのトークンを用いて認証する
- モバイルアプリでは Cookie よりも トークン認証が多数
- [RFC 6750](https://tools.ietf.org/html/rfc6750)
- トークンの形式は2種類あり、Opaque Token と Handle Token がある
  - [RFC 6819 - 3.1 Tokens](https://openid-foundation-japan.github.io/rfc6819.ja.html#section_tokens)

Opaque Token

- 意味の無いランダムな文字列からなり、データに対する参照として用いるトークン
- サーバ側でトークンとユーザ情報を保持し、チャレンジ毎にデータを参照することで認証を行う

Handle Token

- 意味がある文字列からなり、自身に必要な情報が付与されているトークン
- JWT
  - [RFC 7519](https://tools.ietf.org/html/rfc7519)

#### メリット

- ログイン・ログアウト機能が実装できる
- cookie に依存しない実装が可能
- サーバがステートレスになりスケーリングしやすい (Handle)

#### デメリット

- サーバがステートフルになる (Opaque)
- サーバ側でトークンを無効にすることができない (Handle)

## 認証機能の実装

No.11 で制作した [rails-blog-app](https://github.com/kazu-horie/rails-blog-app) に cookie 認証を実装する

### Gem

- [Devise](https://github.com/heartcombo/devise) (使用)
- [authlogic](https://github.com/binarylogic/authlogic)
- [clearance](https://github.com/thoughtbot/clearance)

### 制作物

https://github.com/kazu-horie/rails-blog-app/tree/feature/authentication

## 認可 とは

> 認証済みの利用者に対し、アクセス権の設定などを参照して本人に与えられた適切な権限による操作を許可する（権限外の利用を拒否する）こと

source: http://e-words.jp/w/%E8%AA%8D%E8%A8%BC.html

> とある特定の条件に対して、リソースアクセスの権限を与えること

source: https://dev.classmethod.jp/security/authentication-and-authorization/

- 第三者に公開する API において認可が必要
- Twitter, Google など様々なサービスが認可を用いて、自サービスのリソースを提供

## 認可方式

### API key

前もって発行した key (共通鍵) をもとに 外部 API を実行する

- アプリに対して認可を行う方法

### OAuth

認可においての標準的な仕様

- アプリのユーザごとに認可を行う方法

[OAuth 1.0 : RFC 5849](https://tools.ietf.org/html/rfc5849)

[OAuth 2.0 : RFC 6749](https://tools.ietf.org/html/rfc6749)

![oauth](/backend-roadmap/images/oauth.png)

source: https://qiita.com/sgmryk/items/0f5734a2a6991a6a1873

todo: 仕様の詳細についてまとめる

## OpenID Connect

> OpenID Connectは、OAuthのフローをベースにしており、本来、クライアント側で行っていた認証処理を、他のサーバー(OpenID Provider)にお任せして、その認証結果のみを安全な方式(JSON Web Token)でクライアントが受け取って認証する方式です。

source: https://tech-lab.sios.jp/archives/8651

OAuth に認証の機能を追加した仕様

- 単なる OAuth を認証に用いるのは危ない
  - トークン置換攻撃 など
- OpenID Connect は、アクセストークンと一緒に ID トークンを返却

source: [単なる OAuth 2.0 を認証に使うと、車が通れるほどのどでかいセキュリティー・ホールができる](https://www.sakimura.org/2012/02/1487/)

[OpenID Connect 仕様 日本語訳](https://openid-foundation-japan.github.io/openid-connect-core-1_0.ja.html)

わかりやすい記事

- [TECK.LAB - 多分わかりやすい OpenID Connect](https://tech-lab.sios.jp/archives/8651)
- [Qiita@shoichiimamura - OAuth2.0とOpenID Connect の概要](https://qiita.com/shoichiimamura/items/57129d12868bbd81f48e)
- [Qiita@TakahikoKawasaki - 一番分かりやすい OpenID Connect の説明](https://qiita.com/TakahikoKawasaki/items/498ca08bbfcc341691fe)

## 認可を用いた機能の実装

Twitter に認可した後、Twitter API の [タイムライン取得 API](https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-home_timeline) を利用する。

### Twitter API

Twitter の認証が必要な API は、アプリケーションレベルとユーザレベルで認証方法が異なる。

- アプリケーションレベル: OAuth 2.0
- ユーザレベル: OAuth 1.0

### 制作物

[rails-twitter-api-client](https://github.com/kazu-horie/rails-twitter-api-client)

### 関連 GEM

- [oauth](https://github.com/oauth-xx/oauth-ruby) (使用)
  - OAuth 1.0 を提供
- [oauth2](https://github.com/oauth-xx/oauth2)
  - OAuth 2.0 を提供
- [omniauth](https://github.com/omniauth/omniauth)
  - 各認可プロトコルへの共通インターフェースを提供
  - OAuth 1.0, OAuth 2.0, OpenID Connect の差異を吸収してくれる

### 参考

- [Qiita@riocampos - OAuth gemだけでTwitter APIを使ってみる](https://qiita.com/riocampos/items/5aaa636866af885ef1ac)
- [hawksnowlog - Twitter の OAuth を使ってログイン機能を作ってみた](https://hawksnowlog.blogspot.com/2018/10/twitter-oauth-with-sinatra.html)
