<<<<<<< HEAD

-- Шаблон для выполнения заданий Лабораторной работы №4 

-- ниеже перечисляются имена, доступные после загрузки данного модуля
-- (например в файле с тестами)
-- по мере реализации решений заданий снимайте комментарий 
-- с соответствующей функции
module Lab4 
  ( epsilon
  , epsilon'
  , epsilon''
  , nat
  , fibonacci
  , factorial
  , hailstone
  , hailstoneStepNum
  , hailstonePeak
  , powers
  , findCloseEnough
  , streamSum
  , expSummands
  , expStream
  , expAppr
  , derivativeAppr
  , derivativeStream
  , derivative
  , funAkStream 
  , invF
  , average
  , averageDump
  , newtonTransform
  , eitken
  , fixedPoint
  , fixedPointOfTransform
  , sqrt1
  , cubert1
  , sqrt2
  , cubert2
  , extremum
  , myPi
  ) where
--------------------------------------------------------------------------------
-- Вспомогательные определения
--------------------------------------------------------------------------------
import Data.List
epsilon  = 0.001
epsilon' = 0.00001
epsilon'' = 0.00000001
--------------------------------------------------------------------------------

-- Задание 1 nat 
nat = iterate (+1) 1
-- Задание 2 fibonacci 
fibonacci = 0 : 1 : zipWith (+) fibonacci (tail fibonacci)
-- Задание 3 factorial 
factorial = 1 : zipWith (*) factorial nat
-- Задание 4 hailstone 
hailstone x = x : hailstone y
  where
    y = if x `mod` 2 == 0
        then x `div` 2
        else 3 * x + 1
-- Задание 5 hailstoneStepNum 
hailstoneStepNum x = 
  case elemIndex 1 (hailstone x) of
    Just n -> n
-- Задание 6 hailstonePeak 
hailstonePeak x = maximum (takeWhile (>1) (hailstone x))
-- Задание 7 powers 
powers x = iterate (*x) 1
-- Задание 8 streamSum 
streamSum x = 0 : head x : zipWith (+) (tail (streamSum x)) (tail x)
-- Задание 9 findCloseEnough 
findCloseEnough eps lst = res
  where
    res = head (filter (/=0) (zipWith (f) lst (tail lst)))
    f a b = if abs (b - a) <= eps
            then b else 0
--  Задание 10 expSummands 
expSummands x = zipWith (/) (powers x) (map fromIntegral factorial)
--  Задание 11 expStream 
expStream x =  streamSum (expSummands x)
--  Задание 12 expAppr 
expAppr eps x = findCloseEnough eps (expStream x)
--  Задание 13 derivativeAppr 
derivativeAppr f dx x = (f (x + dx) - f x) / dx
--  Задание 14 derivativeStream 
derivativeStream f = map (derivativeAppr f) (iterate (/2) 1)
--  Задание 15 derivative 
derivative f x = findCloseEnough epsilon' (map (\g -> g x) (derivativeStream f))
--  Задание 16 funAkStream
funAkStream g = lst
  where 
    lst = (\x -> x) : map (\f x -> (derivative f x) / g x) lst
--  Задание 17 invF
invF f y0 x = findCloseEnough epsilon (streamSum seq)
  where
    seq = zipWith (*) (map (\g -> g y0) (funAkStream derF)) exs
    derF = derivative f
    exs = expSummands (x - f y0)
--  Задание 18 average 
average a b = (a + b) / 2
--  Задание 19 averageDump 
averageDump f x = average x (f x)
--  Задание 20 newtonTransform 
newtonTransform g x = x - (g x / derivative g x)
--  Задание 21 eitken 
eitken l = map (\z -> g z) (zipWith (,) l (zipWith (,) tailL (tail tailL)))
  where
    tailL = tail l
    g (x, (y, z)) = f x y z
    f y0 y1 y2 = (y2 * y0 - y1 * y1) / (y2 - 2 * y1 + y0)
--  Задание 22 fixedPoint 
fixedPoint f x = iterate f x
--  Задание 23 fixedPointOfTransform 
fixedPointOfTransform f g x0 = findCloseEnough epsilon' (fixedPoint (g f) x0)
--  Задание 24 sqrt1 
sqrt1 x = fixedPointOfTransform (\y -> x / y) averageDump 1.0
--  Задание 25 cubert1 
cubert1 x = fixedPointOfTransform (\y -> x / (y * y)) averageDump 1.0
--  Задание 26 sqrt2 
sqrt2 x = fixedPointOfTransform (\y -> y * y - x) newtonTransform 1.0
--  Задание 27 cubert2 
cubert2 x = fixedPointOfTransform (\y -> y * y * y - x) newtonTransform 1.0
--  Задание 28 extremum 
extremum f = (x, char)
  where
    char = if (derFF > -epsilon) && (derFF < epsilon)
           then "inflection"
           else if derFF > epsilon
                     then "minimum"
                     else "maximum"
    derF = derivative f
    derFF = derivative derF x
    x = fixedPointOfTransform derF newtonTransform 1.0
--  Задание 29 myPi 
myPi = 4 * (findCloseEnough epsilon'' (eitken (streamSum lst)))
  where
    lst = 1 : zipWith (/) numer denom
    numer = iterate (*(-1)) (-1)
=======

-- Шаблон для выполнения заданий Лабораторной работы №4 

-- ниеже перечисляются имена, доступные после загрузки данного модуля
-- (например в файле с тестами)
-- по мере реализации решений заданий снимайте комментарий 
-- с соответствующей функции
module Lab4 
  ( epsilon
  , epsilon'
  , epsilon''
  , nat
  , fibonacci
  , factorial
  , hailstone
  , hailstoneStepNum
  , hailstonePeak
  , powers
  , findCloseEnough
  , streamSum
  , expSummands
  , expStream
  , expAppr
  , derivativeAppr
  , derivativeStream
  , derivative
  , funAkStream 
  , invF
  , average
  , averageDump
  , newtonTransform
  , eitken
  , fixedPoint
  , fixedPointOfTransform
  , sqrt1
  , cubert1
  , sqrt2
  , cubert2
  , extremum
  , myPi
  ) where
--------------------------------------------------------------------------------
-- Вспомогательные определения
--------------------------------------------------------------------------------
import Data.List
epsilon  = 0.001
epsilon' = 0.00001
epsilon'' = 0.00000001
--------------------------------------------------------------------------------

-- Задание 1 nat 
nat = iterate (+1) 1
-- Задание 2 fibonacci 
fibonacci = 0 : 1 : zipWith (+) fibonacci (tail fibonacci)
-- Задание 3 factorial 
factorial = 1 : zipWith (*) factorial nat
-- Задание 4 hailstone 
hailstone x = x : hailstone y
  where
    y = if x `mod` 2 == 0
        then x `div` 2
        else 3 * x + 1
-- Задание 5 hailstoneStepNum 
hailstoneStepNum x = 
  case elemIndex 1 (hailstone x) of
    Just n -> n
-- Задание 6 hailstonePeak 
hailstonePeak x = maximum (takeWhile (>1) (hailstone x))
-- Задание 7 powers 
powers x = iterate (*x) 1
-- Задание 8 streamSum 
streamSum x = 0 : head x : zipWith (+) (tail (streamSum x)) (tail x)
-- Задание 9 findCloseEnough 
findCloseEnough eps lst = res
  where
    res = head (filter (/=0) (zipWith (f) lst (tail lst)))
    f a b = if abs (b - a) <= eps
            then b else 0
--  Задание 10 expSummands 
expSummands x = zipWith (/) (powers x) (map fromIntegral factorial)
--  Задание 11 expStream 
expStream x =  streamSum (expSummands x)
--  Задание 12 expAppr 
expAppr eps x = findCloseEnough eps (expStream x)
--  Задание 13 derivativeAppr 
derivativeAppr f dx x = (f (x + dx) - f x) / dx
--  Задание 14 derivativeStream 
derivativeStream f = map (derivativeAppr f) (iterate (/2) 1)
--  Задание 15 derivative 
derivative f x = findCloseEnough epsilon' (map (\g -> g x) (derivativeStream f))
--  Задание 16 funAkStream
funAkStream g = lst
  where 
    lst = (\x -> x) : map (\f x -> (derivative f x) / g x) lst
--  Задание 17 invF
invF f y0 x = findCloseEnough epsilon (streamSum seq)
  where
    seq = zipWith (*) (map (\g -> g y0) (funAkStream derF)) exs
    derF = derivative f
    exs = expSummands (x - f y0)
--  Задание 18 average 
average a b = (a + b) / 2
--  Задание 19 averageDump 
averageDump f x = average x (f x)
--  Задание 20 newtonTransform 
newtonTransform g x = x - (g x / derivative g x)
--  Задание 21 eitken 
eitken l = map (\z -> g z) (zipWith (,) l (zipWith (,) tailL (tail tailL)))
  where
    tailL = tail l
    g (x, (y, z)) = f x y z
    f y0 y1 y2 = (y2 * y0 - y1 * y1) / (y2 - 2 * y1 + y0)
--  Задание 22 fixedPoint 
fixedPoint f x = iterate f x
--  Задание 23 fixedPointOfTransform 
fixedPointOfTransform f g x0 = findCloseEnough epsilon' (fixedPoint (g f) x0)
--  Задание 24 sqrt1 
sqrt1 x = fixedPointOfTransform (\y -> x / y) averageDump 1.0
--  Задание 25 cubert1 
cubert1 x = fixedPointOfTransform (\y -> x / (y * y)) averageDump 1.0
--  Задание 26 sqrt2 
sqrt2 x = fixedPointOfTransform (\y -> y * y - x) newtonTransform 1.0
--  Задание 27 cubert2 
cubert2 x = fixedPointOfTransform (\y -> y * y * y - x) newtonTransform 1.0
--  Задание 28 extremum 
extremum f = (x, char)
  where
    char = if (derFF > -epsilon) && (derFF < epsilon)
           then "inflection"
           else if derFF > epsilon
                     then "minimum"
                     else "maximum"
    derF = derivative f
    derFF = derivative derF x
    x = fixedPointOfTransform derF newtonTransform 1.0
--  Задание 29 myPi 
myPi = 4 * (findCloseEnough epsilon'' (eitken (streamSum lst)))
  where
    lst = 1 : zipWith (/) numer denom
    numer = iterate (*(-1)) (-1)
>>>>>>> fd03a34f72553a012fabe6c814c809c76a202115
    denom = [3,5..]