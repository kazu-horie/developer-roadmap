# Authentication/Authorization Methodologies

## 目標

1. 認証の方法論を理解し、認証機能を実装できるようになる。
1. 認可の方法論を理解し、認可機能を実装できるようになる。

## 目次

- [認証 とは](#認証-とは)
- [認証方式](#認証方式)
- [認証機能の実装](#認証機能の実装)
- [認可 とは](#認可-とは)
- [認可方式](#認可方式)
- [認可機能の実装](#認可機能の実装)

## 認証 とは

> 認証とは、対象の正当性や真正性を確かめること。ITの分野では、相手が名乗った通りの本人であると何らかの手段により確かめる本人確認（相手認証）のことを単に認証ということが多い。

source: http://e-words.jp/w/%E8%AA%8D%E8%A8%BC.html

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
