z = 1
while z < 10
  n = z * 10000000000000000
  m = n
  c = 0
  while c < 100
    n = n - (n * n - m) / (n * 2)
    c = c + 1
  end
  p(n - 1)
  z = z + 1
end
