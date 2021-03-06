# 8. Learn Relational Database | リレーショナルデータベースを学ぶ

## 目次

- [データベース](#データベース)
- [リレーショナルデータモデル](#リレーショナルデータモデル)
  - [構成要素](#構成要素)
  - [一貫性制約](#一貫性制約)
  - [データ操作言語](#データ操作言語)
- [SQL](#sql)
- [データベース管理システムのアーキテクチャ](#データベース管理システムのアーキテクチャ)
- [インデックス](#インデックス)
- [トランザクション](#トランザクション)
- [正規化](#正規化)
- [ORM](#orm)

---

## データベース

> データベースとは、複数の主体で共有、利用したり、用途に応じて加工や再利用がしやすいように、一定の形式で作成、管理されたデータの集合のこと。 (IT 用語辞典)

- データ ?
- 複数の主体で共有、利用したり、用途に応じて加工や再利用がしやすい ?
- 一定の形式 ?

### データ とは

- データ = 事実の蓄積 (抽象的にいうと記号の集まり)
  - 田中
  - 30℃
  - etc.
- データ ≠ 情報
  - ある目的に沿って活用することで情報になる
    - 天気予報

### 複数の主体で共有、利用したり(ry とは

- データはファイルシステムで管理してた
  - 物理構造を意識する必要がある
  - 形式がプログラム依存
  - ゆえに データが重複、矛盾 (整合性 がない)
- データベースシステムで管理しよう
  - データベースという論理的な構造で表現
  - データがプログラムから独立
  - １つの場所で管理できる(一元管理)

### 一定の形式 とは

- データベースの構築は、概念モデリングと論理モデリングの２つの工程からなる
  - 概念モデル
    - ER 図
    - クラス図 (UML)
  - 論理モデル
    - ネットワークデータモデル
    - 階層型データモデル
    - リレーショナルデータモデル
    - オブジェクト志向データモデル etc.
- 一定の形式 = **論理モデル**

リレーショナルデータベースとは、**論理モデルにリレーショナルデータモデルを採用したデータベース**のこと

### データベースマネジメントシステム (DBMS)

> データベース管理システム（データベースかんりシステム、DBMS; 英: database management system）は、コンピュータのデータベースを構築するために必要なデータベース運用、管理のためのシステム、及びそのソフトウェアのことである。

- 人間が直接操作したらミスが起きるかも知れない
- ソフトウェアでミスを防いだり、効率良い操作をしてもらう
- 商用
  - Oracle
  - SQL Server
- オープンソース
  - MySQL
  - PostgreSQL

---

## リレーショナルデータモデル

ビジネスデータの管理において、リレーショナルモデルが他のモデルより優れている点

- モデルの平明性
- 高度な独立性
- データ操作の非手続き性
- 分散型データベースへの適合性

一般にデータモデルは、3 つの要素から成り立っている

- 構造記述: データベースの**構成要素**の記述
- 意味記述: データベースの**一貫性制約**の記述
- 操作記述: **データ操作言語**

### 構成要素

- リレーション
- ドメイン
- 属性
- タプル
- 候補キー
- 主キー
- 外部キー

#### ドメイン

- ドメイン は 集合 ( = 異なる元の集まり)
  - 人名の集合
    - ![](https://latex.codecogs.com/gif.latex?%5C%5CD_1%20%3D%20%5C%7Balice%2C%20bob%5C%7D)
  - 年齢の集合
    - ![](https://latex.codecogs.com/gif.latex?%5C%5CD_2%20%3D%20%5C%7B23%2C%205%5C%7D)
  - 最大長 10 の文字列の集合
    - ![](https://latex.codecogs.com/gif.latex?%5C%5CD_3%20%3D%20%5C%7Bx%20%7C%20x%20%5Ctext%7B%20is%20string%20of%20up%20to%2010%20chracters%7D%5C%7D)
- ドメインの直積の元を**タプル**という
  - ![](https://latex.codecogs.com/gif.latex?%5C%20D_1%20%5Ctimes%20D_2%20%3D%20%5C%7B%28alice%2C%2023%29%2C%20%28alice%2C%205%29%2C%20%28bob%2C%2023%29%2C%20%28bob%2C%205%29%5C%7D)
  - (alice, 5)はタプル

#### リレーション

- リレーション は ドメインの直積の任意の有限部分集合 (= タプルの集合)
  - リレーション ![](https://latex.codecogs.com/gif.latex?%5C%20R%20%5Csubseteq%20D_1%20%5Ctimes%20D_2%20%5Ctimes%20...%20%5C%20%5Ctimes%20D_n)
- リレーション `R = {(alice, 23), (chris, 4), (bob, 6), (mike, 5)}` をテーブルで表現すると

|       |     |
| ----- | --- |
| alice | 23  |
| chris | 4   |
| bob   | 6   |
| mike  | 5   |

- これだけだと、各リレーションをどのように解釈すればいいかわからない
  - リレーション名と属性名を定義しよう

友人 (リレーション名)

| 名前 (属性名) | 年齢 (属性名) |
| ------------- | ------------- |
| alice         | 23            |
| chris         | 4             |
| bob           | 6             |
| mike          | 5             |

リレーション名と属性名を用いたリレーションの定義

- R をリレーション名、![](https://latex.codecogs.com/gif.latex?A_1%2C%20A_2%2C...%2CA_n)を属性名、dom をドメイン関数とするとき、リレーション![](https://latex.codecogs.com/gif.latex?R%28A_1%2C%20A_2%2C...%2CA_n%29)は![](https://latex.codecogs.com/gif.latex?dom%28A_1%29%5Ctimes%20dom%28A_2%29%5Ctimes%20...%20%5Ctimes%20dom%28A_n%29)の有限部分集合である。
  - ドメイン関数 dom は![](https://latex.codecogs.com/gif.latex?dom%3A%20A_i%20%5Crightarrow%20D_i%20%5C%20%28i%20%3D%201%2C2%2C...%2Cn%29)
  - また、![](https://latex.codecogs.com/gif.latex?X%20%3D%20%5C%7BA_i_1%2C%20A_i_2%2C%20...%2C%20A_i_n%5C%7D%2C%20%281%5Cleq%20i_1%20%3C%20i_2%20%3C%20...%20%3C%20i_k%20%5Cleq%20n%29)とするとき、タプル t の X 値とは![](https://latex.codecogs.com/gif.latex?%28a_i_1%2C%20a_i_2%2C%20...%2C%20a_i_n%29)とし、![](https://latex.codecogs.com/gif.latex?t%5BX%5D)や![](https://latex.codecogs.com/gif.latex?t%5BA_i_1%2C%20A_i_2%2C...%2C%20A_i_n%5D)とあらわす

#### リレーションスキーマ

- リレーションは時間の経過によって変わっていく
  - タプルが挿入されたり、削除されたり、更新されたり
- けど、リレーション名や属性名などの枠組みは不変
- この不変な枠組みを**リレーションスキーマ**という
  - リレーションはリレーションスキーマの**インスタンス**

#### 候補キー

- 条件二つ
  - いかなるリレーションに対しても、タプルを一意識別(同定, identify)できる属性集合 - ①
  - ① の条件を満たす極小の属性集合 - ②
    - 一つでも属性を除いたら ① を満たせないということ
- 候補キーが存在しないことはない

#### 主キー

- 複数の候補キーから設計者が一つ選んで主キーとする
- データベースの一貫性を保つために、キー制約という条件がどの候補キーに課されるべきか

#### キー制約

- 候補キーの条件
- 1 つの属性も空をとらない

### 一貫性制約

- 常に実世界のデータ構造を正しく反映することは極めて重要
  - 500 才の社員とか記録されてるデータベースは信用できない
- 完全な(正しく反映している)状態を保つための制約を**一貫性制約**という
  - 上述のキー制約もその一つ
- データ定義言語(DDL)でデータベーススキーマを定義する時点で定義され、DBMS が維持する責任を持つ
  - 一貫性制約には種類があり、定義方法には**検査制約**、**表明**、**トリガー**がある

#### 検査制約

- 属性値(ドメインの元)が満たすべき制約の定義に用いる
- リレーションの定義の中で定義される
  - **リレーション単位**の制約

例.「学生は 15 才以下でなければならない」

```sql
CREATE TABLE 学生(
  名前 CHAR(12)
  年齢 INTEGER CHECK(年齢 <= 15)
)
```

#### 表明

- **複数のリレーションの結合関係**のもと、データベース全体が満たすべき制約を定義に用いる

例. リレーション 備品 と リレーション 社員において、「備品のパソコンは社員よりも多くなければならない」

```sql
CREATE ASSERSION パソコン足りないとダメ制約
  CHECK (
    (SELECT COUNT(*) FROM 備品 WEHRE 備品名 = 'パソコン') >
    (SELECT COUNT(*) FROM 社員)
  )
```

#### トリガー

- 検査制約でも表明でも指定できない一貫性制約を定義する場合に用いる
  - 基本的にリレーションの更新をトリガーにして、何かしらの SQL 手続きを起動する仕組み

例. リレーション 社員 と リレーション部門において、「リレーション社員に新入社員が挿入されたら、配属される部門の部員数を１増やさなければならない」

```sql
CREATE TRIGGER 部員数整合
  AFTER INSERT ON 社員
    UPDATE 部門
    SET 部員数 = 部員数 + 1
    WHERE 部門.部門番号 = 社員.所属
```

### データ操作言語

- データ操作 (data manipulation)
  - データベースへの質問 (query)
  - データベースの更新 (update)
  - 実リレーションから結果リレーションを導き出すこと
- データ操作言語
  - リレーショナル代数
  - リレーショナル論理

#### リレーショナル代数

合計 8 個の演算が定義

- 集合演算
  - 和集合演算
  - 差集合演算
  - 共通集合演算
  - 直積演算
- リレーショナル代数特有の演算
  - 射影演算
  - 選択演算
  - 結合演算
  - 商演算

Note: これらの演算の前提として、リレーションが和両立であることが条件だが省略

##### 和集合演算

- ![](https://latex.codecogs.com/gif.latex?R%5Ccup%20S%3D%20%5C%7Bt%5C%20%7C%5C%20t%5Cepsilon%20R%5Cvee%20t%5Cepsilon%20S%5C%7D)

##### 差集合演算

- ![](https://latex.codecogs.com/gif.latex?R-%20S%3D%20%5C%7Bt%5C%20%7C%5C%20t%5Cepsilon%20R%5Cwedge%20%5Clnot%20%28t%5Cepsilon%20S%29%5C%7D)

##### 共通集合演算

- ![](https://latex.codecogs.com/gif.latex?R%5Ccap%20S%3D%20%5C%7Bt%20%7C%20t%5Cepsilon%20R%5Cwedge%20t%5Cepsilon%20S%29%5C%7D)

##### 直積演算

- ![](https://latex.codecogs.com/gif.latex?R%5Ctimes%20S%3D%20%5C%7B%28r%2C%20s%29%20%7C%20r%5Cepsilon%20R%5Cwedge%20s%5Cepsilon%20S%29%5C%7D)
  - r = (a, b, c), s = (d, e, f) ならば (r, s) = (a, b, c, d, e, f)

##### 射影演算

- リレーションを縦方向に切り出す

NOTE: 定義式が長いので図で表現

| 名前     | 年齢 | 出身地           |
| -------- | ---- | ---------------- |
| alice    | 1    | ニュージーランド |
| ベジータ | 27   | 惑星ベジータ     |
| 田中太郎 | 9    | 日本             |

**{名前, 年齢}上の射影演算をすると**

| 名前     | 年齢 |
| -------- | ---- |
| alice    | 1    |
| ベジータ | 27   |
| 田中太郎 | 9    |

##### 選択演算

- リレーションを横方向に切り出す

| 名前     | 年齢 | 出身地           |
| -------- | ---- | ---------------- |
| alice    | 1    | ニュージーランド |
| ベジータ | 27   | 惑星ベジータ     |
| 田中太郎 | 9    | 日本             |

**年齢 > 10 の選択演算をすると**

| 名前     | 年齢 | 出身地       |
| -------- | ---- | ------------ |
| ベジータ | 27   | 惑星ベジータ |

##### 結合演算

- ある規則でリレーション同士を結合
  - θ-結合演算
  - 自然結合演算
  - 外結合演算

###### θ-結合演算

- θ は比較演算子
  - =, >, <, ...
  - ある属性同士を比較して満たすタプルを繋ぐ

リレーション 社員

| 名前     | 年齢 | 所属 |
| -------- | ---- | ---- |
| alice    | 1    | A1   |
| ベジータ | 27   | A2   |
| 田中太郎 | 9    | A3   |

リレーション 部門

| 部門番号 | 部門名       |
| -------- | ------------ |
| A1       | 人事         |
| A2       | 営業         |
| A3       | セキュリティ |

**=演算(等結合演算)をすると**

| 社員.名前 | 社員.年齢 | 社員.所属 | 部門.部門番号 | 部門.部門名  |
| --------- | --------- | --------- | ------------- | ------------ |
| alice     | 1         | A1        | A1            | 人事         |
| ベジータ  | 27        | A2        | A2            | 営業         |
| 田中太郎  | 9         | A3        | A3            | セキュリティ |

###### 自然結合演算

- 共通ドメイン(属性)でリレーションを繋ぐ

履修

| 学生名   | 科目名         |
| -------- | -------------- |
| 孫悟空   | データベース   |
| ベジータ | ネットワーク   |
| ピッコロ | セキュリティ   |
| 孫悟飯   | データベース   |
| セル     | プログラミング |

担当

| 科目名       | 教員名              |
| ------------ | ------------------- |
| データベース | モンキー・D・ルフィ |
| セキュリティ | ロロノア・ゾロ      |
| ネットワーク | サンジ              |
| アルゴリズム | チョッパー          |

**自然結合をすると**

履修 \* 担当

| 学生名   | 科目名       | 教員名              |
| -------- | ------------ | ------------------- |
| 孫悟空   | データベース | モンキー・D・ルフィ |
| ベジータ | ネットワーク | サンジ              |
| ピッコロ | セキュリティ | ロロノア・ゾロ      |
| 孫悟飯   | データベース | モンキー・D・ルフィ |

###### 外結合

- t[Ai] θ t[Bj]の関係にないタプルも存在させたい
  - 相棒のいないタプルも表せる結合
- 演算結果に相棒がいない場合は、結合する属性は空をとることにする

###### 左外結合演算

| 履修.学生名 | 履修.科目名    | 担当.科目名  | 担当.教員名         |
| ----------- | -------------- | ------------ | ------------------- |
| 孫悟空      | データベース   | データベース | モンキー・D・ルフィ |
| ベジータ    | ネットワーク   | ネットワーク | サンジ              |
| ピッコロ    | セキュリティ   | セキュリティ | ロロノア・ゾロ      |
| 孫悟飯      | データベース   | データベース | モンキー・D・ルフィ |
| セル        | プログラミング | \_           | \_                  |

###### 完全結合演算

| 履修.学生名 | 履修.科目名    | 担当.科目名  | 担当.教員名         |
| ----------- | -------------- | ------------ | ------------------- |
| 孫悟空      | データベース   | データベース | モンキー・D・ルフィ |
| ベジータ    | ネットワーク   | ネットワーク | サンジ              |
| ピッコロ    | セキュリティ   | セキュリティ | ロロノア・ゾロ      |
| 孫悟飯      | データベース   | データベース | モンキー・D・ルフィ |
| セル        | プログラミング | \_           | \_                  |
| \_          | \_             | アルゴリズム | チョッパー          |

##### 商演算

- リレーションをリレーションで割る
  - (R × S) ÷ S = R になる性質がある

リレーション 履修

| 学生名   | 科目名       |
| -------- | ------------ |
| 孫悟空   | データベース |
| ベジータ | ネットワーク |
| ベジータ | データベース |

リレーション 必要単位

| 科目名       |
| ------------ |
| データベース |
| ネットワーク |

**履修 ÷ 必要単位 すると**

結果リレーション

| 学生名   |
| -------- |
| ベジータ |

- 必要単位を全部履修している学生のみ取り出せた

---

## SQL

- 国際標準のリレーショナルデータベース言語
  - 自然な英文で初心者でも書き下せるよう考慮された設計
  - リレーショナル代数を直接ユーザに提供はしない
    - とっても難しいから。ユーザーが皆数学に長けたものではない
- データモデルの基本概念をわかりやすい概念に対応
  - 属性:列、タプル:行、リレーション:テーブル

### SQL の分類

- DML (Data Manipulation Language)
  - `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE` etc.
- TCL (Transaction Control Language)
  - `COMMIT`, `ROLLBACK`, `SET TRANSACTION`, `SAVEPOINT` etc.
- DDL (Data Definision Language)
  - `CREATE`, `ALTER`, `DROP` etc.
- DCL (Data Control Language)
  - `GRANT`, `REVOKE` etc.

### コーディングスタイル

https://www.sqlstyle.guide/

- [日本語版](https://www.sqlstyle.guide/ja/)

### DML

以降の SQL 例は以下の `講義-履修-学生データベース`を用いる

講義

| 講義番号 | 講義名       |
| -------- | ------------ |
| A01      | データベース |
| A02      | ネットワーク |
| B01      | 行列         |

履修

| 講義番号 | 学生番号 | 成績 |
| -------- | -------- | ---- |
| A01      | 1        | A    |
| A01      | 2        | B    |
| A02      | 2        | C    |
| A03      | 3        | E    |

学生

| 学生番号 | 学生名           | 学年 | メンター生 |
| -------- | ---------------- | ---- | ---------- |
| 1        | ベジータ         | 1    | 7          |
| 2        | 孫悟空           | 3    | 7          |
| 3        | ミスター・サタン | 2    | 9          |

#### 質問 : SELECT 文

- 3 種類の質問がある
  - 単純質問
  - 結合質問
  - 入れ子型質問

##### 単純質問

FROM 句に唯一の表参照が指定され、WHERE 句に再度 SELECT 文が入らない問い合わせ

- 「全学生の全データを求めよ」
  - \* は全ての列名

```sql
SELECT *
FROM 学生
```

- 「卒業した学生の学生番号を求めよ」

```sql
SELECT 学生番号
FROM 学生
```

- 「年齢が 17 歳以下の学生の全データを求めよ」

```sql
SELECT *
FROM 学生
WHERE 年齢 <= 17
```

- 「偏差値が低い学生から高い学生に順に並べよ」
  - 昇順: `asc`, 降順: `desc`

```sql
SELECT *
FROM 学生
ORDER BY 偏差値 ASC
```

- 「小テストの点数の総数を学生番号ごとに求めよ」
  - SUM は集約関数
    - グループ毎に各行の評価結果を集約する
  - GROUP BY 句を指定しないと、WHERE 句までの結果全体を 1 グループとして扱う

```sql
SELECT 学生番号, SUM(点数)
FROM 学生
GROUP BY 学生番号
```

##### 結合質問

- 「講義の講義番号と履修した講義の講義番号が等しい講義の全データを履修の全データを求めよ」
  - 表名.列名のドット記法を用いる
  - 別名を付与したければ `列名 AS 別名`
  - JOIN を直接指定し、ON 句を使っても書き表せる

```sql
SELECT 講義.*, 履修.*
FROM 講義, 履修
WHERE 講義.講義番号 = 履修.講義番号
---
SELECT *
FROM 講義 JOIN 履修
ON 講義.講義番号 = 履修.講義番号
```

- 「授業データとそれを受講した学生番号と成績を全て求めよ」

```sql
SELECT 講義.*, 履修.学生番号, 履修.成績
FROM 講義, 学生
WHERE 講義.講義番号 = 履修.講義番号
---
SELECT *
FROM 講義 NATURAL JOIN 履修
```

##### 入れ子型質問 (副問い合わせをもつ質問)

- 相関を有していない入れ子型質問
- 「講義番号 A01 の講義を履修している学生の学生番号と学生名を求めよ」

```sql
SELECT 学生番号, 学生名
FROM 学生
WHERE 学生番号 IN (
  SELECT 学生番号
  FROM 履修
  WHERE 講義番号 = 'A01'
)
---
# 結合を使っても書き表わせる
SELECT 履修.学生番号, 学生.学生名
FROM 履修, 学生
WHERE 履修.学生番号 = 学生.学生番号
AND 履修.講義番号 = 'A01'
```

- 相関を有している入れ子型質問
  - 服問い合わせを外側の表から一本ずつ行をもらいながら処理していかねばならないタイプ
- 「メンター生よりも年齢が高い学生の学生番号とそのメンター生の社員番号を求めよ」

```sql
SELECT X.学生, Y.学生
FROM 社員 X
WHERE X.年齢 > (
  SELECT Y.年齢
  FROM 社員 Y
  WHERE Y.学生番号 = X.メンター生
)
```

##### SQL はリレーショナル完備

- リレーショナル代数の独立演算: **和, 差, 直積, 射影, 選択**
- それぞれに対応する SELECT 文が存在

和: ![](https://latex.codecogs.com/gif.latex?R%5Ccup%20S%3)

```sql
SELECT *
FROM R
UNION
SELECT *
FROM S
```

差: ![](https://latex.codecogs.com/gif.latex?R-%20S%3)

```sql
SELECT *
FROM R
EXCEPT
SELECT *
FROM S
```

直積: ![](https://latex.codecogs.com/gif.latex?R%5Ctimes%20S%3)

```sql
SELECT R.*, S.*
FROM R, S
```

射影: R[Ai1, Ai2, ..., Aik]

```sql
SELECT Ai1, Ai2, ..., Aik
FROM R
```

選択: R[Ai θ Aj]

```sql
SELECT *
FROM R
WHERE Ai θ Aj
```

#### 挿入・削除・更新

- 表に対する残りの基本的なデータ操作
  - 新しい行の**挿入**
  - 不要となった行の**削除**
  - 列の**更新**

##### 行の挿入 : INSERET 文

- 「テーブル学生に (学生番号:10, 学生名: パン, 年齢: 10, メンター生:4) を追加」

```sql
INSERT
INTO 学生(学生番号, 学生名, 年齢, メンター生)
VALUES (10, 'パン', 10, 4)
```

##### 行の削除 : DELETE 文

- 「テーブル学生から学生番号:1 の行を削除」

```sql
DELETE
FROM 学生
WHERE 学生番号 = 1
```

##### 列の更新 : UPDATE 文

- 「テーブル学生の学生番号:3 の学生を年齢:13 に更新」

```sql
UPDATE 学生
SET 年齢 = 13
WHERE 学生番号 = 3
```

---

## データベース管理システムのアーキテクチャ

- DBMS はどんなアーキテクチャに則るべきか
- どのようなシステム構成にすれば DBMS といえるのか

### ANSI/X3/SPARC の 3 層スキーマ構造

- DBMS がデータベースに関してサポートすべきアーキテクチャ
- 物理的・論理的データの独立性を達成させるため
- 各スキーマ
  - 概念スキーマ
  - 内部スキーマ
  - 外部スキーマ

### 概念スキーマ

- データベースの構文的・意味的構造を記述したもの
  - データベースの設計者が実世界を認識した結果の表現
- DB に保持するデータの要素およびデータ同士の関係を定義
  - RDB においてはテーブル定義
- **「どう実装しようか」** や **「ユーザ視点をどう提供しようか」** といったことはここで考えない

### 内部スキーマ

- **どのように概念スキーマをシステム上に実装するか** を担う層
- 通常、1 つのリレーションは 1 枚のファイルとして実装
- ISAM ファイルや B+木ファイルなど

### 外部スキーマ

- **どのようなユーザ視点を提供するか** を担う層
  - ユーザによってデータベースを利用する目的は様々
- ビューも外部スキーマ
  - 概念スキーマのリレーションを使って定義
  - あくまで仮想的なリレーション

### 物理的データの独立性

- 通常、１つのリレーションは 1 枚のファイルに実装される
  - リレーション <-> ファイル
  - タプル <-> レコード
  - 属性 <-> フィールド
- ファイルから所望のレコードをいかに高速に検索できるかが重要
- **アクセス法** (ファイル中のレコードの位置決めをする方法)が変更しても、概念スキーマに影響はない
  - 効率的なアクセス法を選択することができる

### 論理的データの独立性

- 実世界の変化をデータベースに反映するため、概念スキーマをさせる場合が多々ある
  - 部や課の新設や統廃合、歩合給の導入 etc.
    - リレーション名の変更、属性名の変更、複数のリレーションを統合する etc.
- ユーザーのアプリケーションに変更が起きる ?
  - **外部スキーマを変えてあげれば変更は起きない**
  - アプリケーションから見て外部スキーマはインターフェース

---

## インデックス法

### ファイル編成

- データベースの物理配置はファイルを使って実装
  - リレーション <-> ファイル
  - タプル <-> レコード
  - 属性 <-> フィールド
- ファイルを磁気ディスクに格納するとき、複数のレコードが 1 ブロックに格納される
  - ブロック(磁気ディスク装置の入出力単位)は、512B ~ 4KB
- 基本的な編成法は 3 つ
  - ヒープ編成
    - レコードが 2 次記憶に書き込まれた時刻順にレコードに順番をつける
  - 順次編成
    - あるフィールド(**キー**)順にソートして順番をつける
  - 直接編成
    - 順番をつけない
    - レコードがどのブロックに格納されているかは、キーの値にハッシュ関数を施して求める

| 編成法     | メリット                                                                                   | デメリット                             |
| ---------- | ------------------------------------------------------------------------------------------ | -------------------------------------- |
| ヒープ編成 | 小さなファイルに対してはレコードを線形探索で高速に読み取れる                               | 大きなファイルは遅い                   |
| 順次編成   | ファイルが大きくなってもソートしたキーで探索する場合、非常に高速にレコードにアクセスできる | レコードの更新に伴い、ソートが毎回必要 |
| 直接編成   | レコードの格納場所が直接分かることによって、高速にアクセスできる                           | 範囲問い合わせに対して、非常に非効率的 |

### アクセス法

- 2 次記憶に格納されたファイルのレコードをどのように特定するか
- 基本的なアクセス法は 3 つ
  - 順次アクセス法
    - 先頭レコードから順にたどる
    - 線形探索、2 分探索、ブロック探索
  - インデックス法
    - レコードのキー値とそのレコードの格納番地の対応表(**インデックス**)を用いる
  - ハッシュ法
    - ハッシュ関数を用いて、レコードの格納番地を見つけ出す

### インデックス

- ファイルのレコードのフィールド値とそのレコードの格納番地の対応表

学生ファイル

| `格納番地` | 学生番号 | 学生名   |
| ---------- | -------- | -------- |
|            | ...      |          |
| `0xAAAA`   | 7436     | ベジータ |
|            | ...      |          |
| `0xBBBB`   | 0044     | ピッコロ |
|            | ...      |          |
| `0xDDDF`   | 3621     | 孫悟空   |
|            | ...      |          |

学生番号上のインデックス

| 学生番号 | `格納番地` |
| -------- | ---------- |
| ...      |            |
| 0044     | `0xBBBB`   |
| ...      |            |
| 3621     | `0xDDDF`   |
| ...      |            |
| 7436     | `0xAAAA`   |
| ...      |            |

- 複数のフィールド上で 1 つ定義することもできるし、異なるフィールド上で複数定義することもできる
- インデックスは第 1 フィールド値でソート順で物理的に格納
  - 順次編成ファイルなので、二分探索、ブロック探索が可能
- インデックスを用いてレコードを特定することを**インデックススキャン**という

---

## トランザクション

複数の SQL 文によるデータ更新を１つの処理としてまとめてデータベースに反映すること

- 以下の預金の振替処理を考える
  - 口座 A から 1 万円を引きだす (残高が減る)
  - 口座 B に 1 万円を振り込む (残高を増える)
- ２つの UPDATE 文が必要
  - `UPDATE 口座 SET 残高 = (残高 - 10000) WHERE 口座名 = 'A'`
  - `UPDATE 口座 SET 残高 = (残高 + 10000) WHERE 口座名 = 'B'`
- 一部がデータベースに反映されると、データが不整合になる
  - 口座 A の残高が`< 10000`の場合、前者の SQL はエラーが起き後者の SQL だけ実行される
- トランザクションを使って同時に実行する！

### (例) PostgreSQL

- `BEGIN`文または`START TRANSACTION`文でトランザクションを開始
- 中で複数の SQL 文を実行するが、データベースへの反映は保留
- `COMMIT`文でトランザクションが終了し、データの変更がデータベースへ反映される
- `ROLLBACK`文でトランザクションが終了し、データの変更がアボートされる
  - `SAVEPOINT`まで戻ることも可能

```
START TRANSACTION;

...

...

COMMIT;
```

### ACID 特性

- DBMS はトランザクションを適切に処理する必要がある
- 要件として`ACID特性`がある
  - 原子性
    - トランザクションは完全に実行されるか、全く実行されないかのどちらか
    - コミットメント制御
  - 一貫性
    - トランザクションの終了状態に関わらず、データベースの整合性が保たれる
    - 排他制御
  - 独立性
    - トランザクションを複数同時に実行しても、単独で実行した場合の処理結果を同じ
    - 排他制御
  - 耐久性
    - トランザクションの結果は、障害が発生しても失われない
    - 障害回復機能

---

## 正規化

データの冗長性を排除し、一貫性や効率性を保持するようなデータ形式にすること

### 関数従属性

- 入力 X, 出力 Y に対して`{X} -> {Y}`
  - **X に対して Y が一意に定まることを示す**
- 例. 学生番号と学生名を持つテーブルで関数従属性が成立するなら
  - `{学生番号} -> {学生名}`

### 正規形

- 正規形には 6 つの段階がある
  - 第 1 正規形
  - 第 2 正規形
  - 第 3 正規形
  - ボイスコッド正規形
  - 第 4 正規形
  - 第 5 正規形
- 一般には第 3 正規形まで理解していればいいとされている

#### 第 1 正規形

ドメインの値が、原子的な値=それ以上分解できない値

#### 第 2 正規形

主キーが複数ある場合に(`{X1, X2} -> {Y}`) が成り立つ Y に対して、
`{X1} -> {Y}` もしくは `{X2} -> {Y}` が成り立つ Y は、
別テーブルに切り出して、元テーブルから削除する。

- 例. 学生(学校番号, 学生番号, 学校名, 学生名)
  - 主キーは{学校番号, 学生番号}
  - `{学校番号, 学生番号} -> {学校名}` は成り立つ
  - **`{学校番号} -> {学校名}` は成り立つ**
- 学生(学校番号, 学生番号, 学生名), **学校(学校番号, 学校名)** に正規化
- 部分関数従属性を持たないテーブルが第 2 正規形

#### 第 3 正規化

あるテーブルで、`{X} -> {Y}`と`{Y} -> {Z}`が成り立つ場合、
Y と Z の関係を別テーブルに切り出して、元テーブルから削除する。

- 例. 学生(学校番号, 学生番号, 学生名, 部活コード, 部活名)
  - 主キーは{学校番号, 学生番号}
  - `{学校番号, 学生番号} -> {部活コード}` は成り立つ
  - `{学校番号, 学生番号} -> {部活名}` は成り立つ
  - **`{部活コード} -> {部活名}` は成り立つ**
- 学生(学校番号, 学生番号, 学生名, 部活コード), **部活(部活コード, 部活名)** に正規化
- R の全ての非キー属性は R のいかなる候補キーにも推移的に関数従属しない
  - `{X} -> {Y} -> {Z}`

---

## ORM

> O/R マッピングとは、オブジェクト指向プログラミング言語におけるオブジェクトとリレーショナルデータベース（RDB）の間でデータ形式の相互変換を行うこと。そのための機能やソフトウェアを「O/R マッパー」（O/R mapper）という。 (IT 用語辞典)

- オブジェクトとテーブルをマッピング
  - データベースからデータを読んでインスタンスを生成してくれる
- 簡単なクエリならメソッドで用意されている
  - SQL を書かなくて良い
- DBMS の違いを吸収してくれる
  - MySQL, PostgreSQL, ...
- 代表的な ORM
  - [ActiveRecord](https://rubygems.org/gems/activerecord/versions/5.0.0.1) (Ruby on Rails), [Eloquent](https://readouble.com/laravel/5.dev/ja/eloquent.html) (Laravel)

---

### 参考文献

- [リレーショナルデータベース入門, 増永良文](https://www.saiensu.co.jp/search/?isbn=978-4-7819-1390-2&y=2017)
