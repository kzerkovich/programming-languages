fun f6 lst = 
  let
    fun f6Helper (x :: (ls as y :: z :: xt)) = 
        (x > y andalso y > z orelse x < y andalso y < z)
        andalso f6Helper ls
      | f6Helper (x :: y :: []) = true
      | f6Helper _ = raise Match
    fun f6Help [] = true
      | f6Help [x] = true
      | f6Help [x, y] = x <> y
      | f6Help l = f6Helper l
  in
    f6Help lst
  end



val test0  = f6 []
val test1  = f6 [1, 2, 3]
val test2  = f6 [1, 3, 2]
val test3  = f6 [5, 2, 1]
val test4  = f6 [1, 2, 5, 2, 1]
val test5  = f6 [5, 4, 2, 3, 1]
val test6  = f6 [5, 4, 3, 2, 1]
val test7  = f6 [1]
val test8  = f6 [1, 1]
val test9  = f6 [1, 2]
val test10 = f6 [2, 1]
