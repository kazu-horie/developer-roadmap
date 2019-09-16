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

if __FILE__ == $0
  puts fizzbuzz(1)
  puts fizzbuzz(3)
  puts fizzbuzz(5)
  puts fizzbuzz(15)
end
