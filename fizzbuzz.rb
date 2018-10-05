def fizzbuzz(n)
  if n % 3 == 0
    if n % 5 == 0
      return "FizzBuzz"
    else
      return "Fizz"
    end
    else
    if n % 5 == 0
      return "Buzz"
    else
      return n
    end
  end
end