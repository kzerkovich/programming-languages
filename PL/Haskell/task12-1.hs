f12 x n = res
  where
    res = [x, sumofNum x `mod` n]
          ++ f12Help (tail res)
    f12Help lst = map proc lst
    proc elem = (sumofNum elem + elem) `mod` n
    sumofNum num 
      | num == 0  = 0
      | otherwise = num `mod` 10 + sumofNum (num `div` 10)


main = do
  print $ take 10 $ f12 322 5
  print $ take 15 $ f12 115 17
  print $ take 20 $ f12 11 10
  print $ take 20 $ f12 115 3
  print $ take 20 $ f12 1234 50