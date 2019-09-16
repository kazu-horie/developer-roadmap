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
