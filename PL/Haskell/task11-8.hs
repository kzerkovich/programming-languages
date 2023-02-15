f11 x eps n = take (n + 1) (f11Help lst)
  where
    s = sin x
    lst = 0.1 : 2.0 * cos x : s * s : elemLst lst 2
    elemLst (y0 : ys @ (y1 : y2 : _)) n = 
      (n * sin y2 + x) / (cos y1 + sin y0) : elemLst ys (n + 1)
    f11Help (y0 : ys @ (y1 : _)) = if abs (y0 - y1) < eps then [y0, y1]
                                   else y0 : f11Help ys

main = do
  let y1 = f11 0.3 0.001 500
  putStrLn "f11 0.3 0.001 500"
  print $ y1 !! 10 
  print $ y1 !! 100 
  print $ y1 !! 500 
  let y2 = f11 0.5 0.001 500
  putStrLn "f11 0.5 0.001 500"
  print $ y2 !! 10 
  print $ y2 !! 100 
  print $ y2 !! 433
  print $ y2 !! 434
  let y3 = f11 1.7 0.001 500
  putStrLn "f11 1.7 0.001 500"
  print $ y3 !! 10 
  print $ y3 !! 100 
  print $ y3 !! 500 