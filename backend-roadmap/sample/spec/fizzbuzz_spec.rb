require_relative '../src/fizzbuzz'

RSpec.describe 'fizzbuzz' do
  it '15で割り切れる数に対してFizzBuzzを返す' do
    expect(fizzbuzz(15)).to eq 'FizzBuzz'
  end

  it '3で割り切れる数に対してFizzBuzzを返す' do
    expect(fizzbuzz(3)).to eq 'Fizz'
  end

  it '5で割り切れる数に対してFizzBuzzを返す' do
    expect(fizzbuzz(5)).to eq 'Buzz'
  end

  it 'それ以外の数に対して値をそのまま返す' do
    expect(fizzbuzz(1)).to eq '1'
  end
end
