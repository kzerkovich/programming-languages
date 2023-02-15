fun f5 (x : real, n : int) : real =
  let
    val xDeg = x * x
    fun f5Iter ( i : int
               , accum : real
               , frac : real
               , count : real )
               : real =
      if i > n then accum
      else
        f5Iter ( i + 1
               , accum 
                 + frac
               , frac * xDeg / count / (count - 1.0)
               , count + 2.0 )
  in
    f5Iter (0, 0.0, x, 3.0)
  end


fun f5Test (x : real) : real = Math.sinh x


val test11 = f5 (0.3, 100)
val test12 = f5Test 0.3

val test21 = f5 (0.9, 100)
val test22 = f5Test 0.9

val test31 = f5 (1.8, 100)
val test32 = f5Test 1.8
