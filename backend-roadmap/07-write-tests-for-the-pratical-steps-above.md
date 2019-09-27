# 7. Write Tests for the pratical steps above | 実用的なステップのテストを書く

## 目次

- [fizzbuzz のテスト](#fizzbuzz-のテスト)
- [自作パッケージのテスト](#自作パッケージのテスト)
- [カバレッジ計測](#カバレッジ計測)

---

## Fizzbuzz のテスト

以下の[fizzbuzz コード](./sample/src/fizzbuzz.rb)のテストを作成する

```Ruby
def fizzbuzz(n)
  if (n % 15).zero?
    'FizzBuzz'
  elsif (n % 3).zero?
    'Fizz'
  elsif (n % 5).zero?
    'Buzz'
  else
    n.to_s
  end
end
```

### Minitest

[ソースファイルはこちら](./sample/test/fizzbuzz_test.rb)

```Ruby
require 'minitest/autorun'
require_relative '../src/fizzbuzz'

class FizzbuzzTest < Minitest::Test
  def test_fizzbuzz_with_num_dividable_15
    assert_equal 'FizzBuzz', fizzbuzz(15)
  end

  def test_fizzbuzz_with_num_dividable_3
    assert_equal 'Fizz', fizzbuzz(3)
  end

  def test_fizzbuzz_with_num_dividable_5
    assert_equal 'Buzz', fizzbuzz(5)
  end

  def test_fizzbuzz_with_other_than_that
    assert_equal '1', fizzbuzz(1)
  end
end
```

### RSpec

[ソースファイルはこちら](/ruby/samplecode/spec/fizzbuzz_spec.rb)

```Ruby
require_relative '../src/fizzbuzz'

RSpec.describe 'fizzbuzz' do
  it '15で割り切れる数に対して文字列FizzBuzzを返す' do
    expect(fizzbuzz(15)).to eq 'FizzBuzz'
  end

  it '3で割り切れる数に対して文字列FizzBuzzを返す' do
    expect(fizzbuzz(3)).to eq 'Fizz'
  end

  it '5で割り切れる数に対して文字列FizzBuzzを返す' do
    expect(fizzbuzz(5)).to eq 'Buzz'
  end

  it 'それ以外の数に対してそのまま値の文字列を返す' do
    expect(fizzbuzz(1)).to eq '1'
  end
end
```

## 自作パッケージのテスト

[対象パッケージは rubyls 0.1.4](https://github.com/kazu-horie/rubyls/tree/v0.1.4)

```Ruby
RSpec.describe Rubyls do
  describe '.ls' do
    it 'return entries' do
      allow(Dir).to receive(:entries).and_return(['.', '..', 'dir', 'file'])
      expect(Rubyls.ls(path: '.')).to eq "dir\tfile\n"
    end

    it 'return sorted entries' do
      allow(Dir).to receive(:entries).and_return(['.', '..', 'file', 'dir'])
      expect(Rubyls.ls(path: '.')).to eq "dir\tfile\n"
    end

    it 'return entries with no arguments' do
      allow(Dir).to receive(:entries).and_return(['.', '..', 'dir', 'file'])
      expect(Rubyls.ls).to eq "dir\tfile\n"
    end

    it 'throw ArgumentError when path does not exist' do
      expect { Rubyls.ls('nonexistent path') }.to raise_error(ArgumentError)
    end
  end
end
```

## カバレッジ計測

- コードカバレッジ = 命令網羅 ?

- [simplecov](https://rubygems.org/gems/simplecov)
  - gem
  - 主に自動テスト時のコードカバレッジ計測に用いる
  - 計測結果を HTML に可視化してくれる
  - デファクトスタンダード
- [coverage](https://docs.ruby-lang.org/ja/latest/library/coverage.html) (v2.6 から登場)
  - 標準ライブラリ
  - テスト時だけだけでなく、任意の実行時間の間カバレッジを計測できる
  - 配列に計測結果を格納して返してくれて、インデックスと各行が対応

### simplecov

導入手順は公式の [README](https://github.com/colszowka/simplecov/) を参考

- インストール

```
$ bundle install simplecov
```

- helper ファイルに設定

```
# 下二行を追加
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
(略)
end
```

- テスト実行

```
$ bundle exec rspec spec
```

- 計測結果が結果が`coverage/index.html`に作成される

トップ画面
![トップ画面](/backend-roadmap/images/simplecov1.png)

ファイル単位の詳細画面

- 各命令が実行されているかを緑と赤でハイライトしている

![詳細画面](/backend-roadmap/images/simplecov2.png)
