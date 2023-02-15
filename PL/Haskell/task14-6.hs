import Genealogy

f14'a x = [ y | ax <- people, parent x ax
              , y <- people, man y, parent ax y
          ] 

f14'b x = [ y | ax <- people, parent x ax
              , bx <- people, woman bx, x /= bx, parent bx ax
              , z <- people, parent z bx
              , y <- people, y /= bx, woman y, parent z y
          ]

main = do
  print $ f14'a Adam
  print $ f14'a Madonna
  print $ f14'a Diane
  print $ [ (x, y) | x <- people, let y = f14'a x, not (null y) ]
  print $ f14'b Adam
  print $ f14'b Michael
  print $ f14'b Alexander
  print $ [ (x, y) | x <- people, let y = f14'b x, not (null y) ]