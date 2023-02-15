fun f3 (a1 : int * real list, a2 : (int * real) list) 
       : real * int * real list =
  let
    val x = hd (#2 a1)
    val y = #1 (hd (tl (tl a2)))
    val xPlus5 = x + 5.0
    val xPlus8 = x + 8.0
    val yPlus5 = y + 5
    val yPlus8 = y + 8
    val expr1 = yPlus8 * yPlus5
    val expr2 = xPlus5 * xPlus5 * xPlus8 + 3.0 * xPlus8
  in
    ( expr2, expr1 * yPlus5 + 3 * yPlus8, [real expr1 / (x + 3.0), expr2] )
  end

  val test0 = f3 ( (5, [9.0, 6.0, 3.2, 4.7])
                 , [(3, 1.1), (6, 0.0), (7, 3.2), (10, 1.8)]
                 )
  val test1 = f3 ( (5, [4.5, 6.0, 3.2, 4.7])
                 , [(3, 1.1), (6, 0.0), (7, 3.2), (10, 1.8)]
                 )
  val test2 = f3 ( (5, [9.0, 6.0, 3.2, 4.7])
                 , [(3, 1.1), (6, 0.0), (3, 3.2), (10, 1.8)]
                 )
  val test3 = f3 ( (5, [4.5, 6.0, 3.2, 4.7])
                 , [(3, 1.1), (6, 0.0), (3, 3.2), (10, 1.8)]
                 )