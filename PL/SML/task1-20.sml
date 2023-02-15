fun f1 (x : real, y : real) : real =
  abs x / abs y

val test1 = f1 (~3.5, 0.5) (* 7.0 *)
val test2 = f1 (~5.0, ~1.0) (* 5.0 *)
val test3 = f1 (10.0, 4.0) (* 2.5 *) 