fun f4 (lst : real list) : bool =
  null lst
  orelse let
           val tlList = tl lst
           fun helperF4 (head : real, hdTail : real, tail : real list) : bool =
             null tail
             orelse let
                      val tlHead = hd tail
                    in
                      ( head < hdTail andalso hdTail < tlHead
                        orelse head > hdTail andalso hdTail > tlHead )
                      andalso helperF4 (hdTail, tlHead, tl tail)
                    end
         in
           helperF4 (hd lst, hd tlList, tl tlList)
         end


val test0 = f4 []
val test1 = f4 [1.0, 2.0, 3.0]
val test2 = f4 [1.0, 3.0, 2.0]
val test3 = f4 [5.0, 2.0, 1.0]
val test4 = f4 [1.0, 2.0, 5.0, 2.0, 1.0]
val test5 = f4 [5.0, 4.0, 2.0, 3.0, 1.0]
val test6 = f4 [1.0, 1.0]