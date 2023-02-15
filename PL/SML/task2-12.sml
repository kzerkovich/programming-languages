fun f2 (a : real, b : real, c : real, d : real) : real =
  let
    val (comp1, comp2, comp3, comp4, comp5, comp6) =
        (a * b, a * c, a * d, b * c, b * d, c * d)
  in
    if comp1 > comp2 andalso comp1 > comp3 andalso comp1 > comp4
                     andalso comp1 > comp5 andalso comp1 > comp6
    then a + b
    else if comp2 > comp3 andalso comp2 > comp4 andalso comp2 > comp5
                          andalso comp2 > comp6
         then a + c
         else if comp3 > comp4 andalso comp3 > comp5
                               andalso comp3 > comp6
              then a + d 
              else if comp4 > comp5 andalso comp4 > comp6
                   then b + c
                   else if comp5 > comp6
                        then b + d
                        else c + d
  end

(* ТЕСТОВЫЕ ЗАПУСКИ *)
val test1 = f2 (~1.7, ~2.0, ~3.0, ~5.0) (*~8.0*)
val test2 = f2 (2.0, 1.7, 3.0, 2.5) (*5.5*)
val test3 = f2 (3.0, ~1.7, 2.0, ~6.5) (*~8.2*)
val test4 = f2 (1.7, 2.0, ~1.7, ~2.4) (*~4.1*)
val test5 = f2 (0.4, 0.4, 0.4, 0.3) (*0.8*)