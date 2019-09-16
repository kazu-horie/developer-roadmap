# 2. Practice what you learnt | 言語の基礎を学び、CLI を作成する

## 概要

- 基礎を学習
- Fizzbuzz 問題
- コマンドラインアプリケーションを作成
- チェリー本を読破する

## 基礎

## 全てがオブジェクト

すべての情報が固有のプロパティ(インスタンス変数)とアクション(メソッド)を与えることができる。

```# プリミティブ型もメソッドやインスタンス変数を与えることができる
5.times { print "Hello World!" }
```

```# 演算子はメソッドのシンタックスシュガー(糖衣構文:シンプルでわかりやすくるための別記法)
puts "Hello\s" + "World!"
# => Hello World!

puts "Hello\s".+("World!")
# => Hello World!
```

## 真偽値

- false または nil であれば偽
- それ以外はすべて真

データのある/なしで条件分岐することができる

```
puts !!nil
# => false
```

式の左から評価を開始し、式全体の真/偽が確定すると、式の評価を終了する

```
1 && 2 && 3 #=> 3
1 && false && 3 #=> false

false || nil #=> nil
nil || false #=> false
```

## if 文

```
if 条件A
  処理A
elsif 条件B
  処理B
else
  処理C
end
```

### 後置 if

```
# 処理A if 条件A
puts 'true' if true
# => true
```

## メソッド定義

- 戻り値は最後に評価された式
  - 途中で脱出したい場合は return を用いる
- カッコは省略できる

```
def add(x, y)
  x + y
end

add(1,1) #=> 2
add 1, 1 #=> 2
```

### デフォルト引数

```
def say_hello(name = 'world')
  puts "Hello #{name}!"
end
```

### ? メソッド

慣習として真偽値を返すメソッド

### ! メソッド

慣習として破壊的メソッド。レシーバの状態に作用をもたらす。

```
a = 'ruby'

a.upcase! #=> "RUBY"
a => "RUBY"
```

## 文字列

- 文字列は String クラスのオブジェクト
- %記法で文字列を作ることができる
  - `puts %q!I said "Hello World."! #=> I said "Hello World."`
- ヒアドキュメント
  - 複数行に渡る長い文字列の作成が楽
- フォーマット指定
  - `sprintf('%0.3f', 1.2) #=> 1.200`

## 数値

- Numeric クラス => 数値クラス
  - Integer => 整数
  - Float => 実数
  - Rational => 有理数
  - Complex => 複素数
- 10 進数以外の整数リテラル
  - 2 進数 `0b11111111 #=> 255`
  - 8 進数 `0377 #=> 255`
  - 16 進数 `0xff #=> 255`
- ビット演算
  - ~ : ビット反転
  - & : ビット積
- 指数表現
  - `2e-3 #=> 0.002`

## 組み込みライブラリ、標準ライブラリ、gem

- 特に利用頻度が高いライブラリは組み込みライブラリとして提供されている
  - 組み込みライブラリ ⊆ 標準ライブラリ
- 有志の開発者が作成している外部ライブラリは gem でパッケージングされている

## require

組み込みライブラリでない標準ライブラリや gem を利用する場合は、明示的にライブラリを読み込む必要がある。

```
Date.today #=> NameError: uninitialized constant Date

require 'date'
Date.today #=> #&lt;Date: 2019-07-15 ((2458680j,0s,0n),+0s,2299161j)&gt;

# 自分で作成したRubyプログラムを読み込む場合
require './sample.rb'
require './sample'
```

## load

require は一回しか読み込まない。load を用いると毎回無条件に読み込むことが可能。

```
require './sample' #=> true
require './samole' #=> false
```

```
load './sample' #=> true
load './samole' #=> true
```

### 参考文献

- [プロを目指す人のための Ruby 入門](https://www.amazon.co.jp/dp/B077Q8BXHC/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1)
- [Ruby 公式ドキュメント](https://www.ruby-lang.org/ja/documentation/)
- [Ruby 公式チュートリアル](https://www.ruby-lang.org/ja/documentation/quickstart/)

## FizzBuzz 問題

- [ソースコード](./sample/src/fizzbuzz.rb)

## コマンドラインアプリ作成

- [ls コマンド](./sample/src/ls.rb)
