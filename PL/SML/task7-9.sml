fun f7 n =
  let
    val inSum = n - 1
    val outSum = real (n + 1)
    fun yIter (i, acc1, j, cosI, degJ, acc2) =
      let 
        val countI = i + 1.0
      in
        if i > outSum
        then acc1
        else if j > inSum
             then yIter (countI, acc1 + acc2, 1, Math.cos countI, Math.e, 0.0)
             else yIter ( i
                        , acc1
                        , j + 1
                        , cosI
                        , degJ * Math.e
                        , acc2 + cosI + Math.sin degJ
                        )
      end
  in
    yIter (~1.0, 0.0, 1, Math.cos ~1.0, Math.e, 0.0)
  end


val test1 = f7 1
val test2 = f7 2
val test3 = f7 3
val test4 = f7 4
val test5 = f7 5