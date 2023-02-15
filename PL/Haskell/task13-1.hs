data Vector a = Vec3 (a, a, a)

xCoor (Vec3 (x, _, _)) = x
yCoor (Vec3 (_, x, _)) = x
zCoor (Vec3 (_, _, x)) = x

instance Show a => Show (Vector a) where
    show i = "(" 
             ++ show (xCoor i) 
             ++ ", " 
             ++ show (yCoor i) 
             ++ ", " 
             ++ show (zCoor i) 
             ++ ")"

instance Eq a => Eq (Vector a) where
    (==) i1 i2 = (xCoor i1 == xCoor i2) 
                 && (yCoor i1 == yCoor i2)
                 && (zCoor i1 == zCoor i2)

instance (Num a, Floating a) => Num (Vector a) where
    (+) i1 i2 = Vec3 ( xCoor i1 + xCoor i2
                     , yCoor i1 + yCoor i2
                     , zCoor i1 + zCoor i2
                     )
    (*) i1 i2 = Vec3 (a, b, c)
          where x1 = xCoor i1
                y1 = yCoor i1
                z1 = zCoor i1
                x2 = xCoor i2
                y2 = yCoor i2
                z2 = zCoor i2
                a = y1 * z2 - y2 * z1
                b = z1 * x2 - z2 * x1
                c = x1 * y2 - x2 * y1
    negate i = Vec3 (negate (xCoor i) , negate (yCoor i), negate (zCoor i))
    abs i = Vec3 (a, 0, 0)
        where x = xCoor i
              y = yCoor i
              z = zCoor i
              a = sqrt (x * x + y * y + z * z)
    signum i = Vec3 (x / denom, y / denom, z / denom)
        where x = xCoor i
              y = yCoor i
              z = zCoor i
              denom = sqrt (x * x + y * y + z * z)
    fromInteger n = Vec3 (fromInteger n, 0, 0)
instance (Num a, Floating a, Fractional a) => Fractional (Vector a) where
    (/) i1 i2 = a
          where x1 = xCoor i1
                y1 = yCoor i1
                z1 = zCoor i1
                x2 = xCoor i2
                y2 = yCoor i2
                z2 = zCoor i2
                new_vec = i2 * i1
                xn = xCoor new_vec
                yn = yCoor new_vec
                zn = zCoor new_vec
                length_new_vec = sqrt (xn * xn + yn * yn + zn * zn)
                length_i1 = sqrt (x1 * x1 + y1 * y1 + z1 * z1)
                length_i2 = sqrt (x2 * x2 + y2 * y2 + z2 * z2)
                ratio = length_i1 / (length_i2 * length_new_vec)
                a = Vec3 (ratio * xn, ratio * yn, ratio * zn)
    fromRational n = Vec3 (fromRational n, 0.0, 0.0)
instance Floating a => Floating (Vector a) where
    sqrt i = Vec3 (sqrt (xCoor i), sqrt (yCoor i), sqrt (zCoor i))

main = do 
  let i1 = Vec3 (1.2, 4.1, 8.4)
  let i2 = Vec3 (6.7, 3.3, 9.0)
  let i3 = Vec3 (6.7, 3.3, 9.0)

  print $ i1
  print $ i2
  print $ i3

  print $ xCoor i1
  print $ yCoor i1
  print $ zCoor i1
  print $ xCoor i2
  print $ yCoor i2
  print $ zCoor i2

  print $ i1 == i2
  print $ i2 == i3

  print $ i1 + i2
  print $ i1 * i2
  print $ negate i1
  print $ abs i2
  print $ signum i1
  print $ i2 - i1

  print $ i1 / i2
  print $ sqrt i1

  let i4 = Vec3 (1, 4, 8)
  let i5 = Vec3 (6, 3, 9)
  let i6 = Vec3 (6, 3, 9)

  print $ i4
  print $ i5
  print $ i6

  print $ xCoor i4
  print $ yCoor i4
  print $ zCoor i4
  print $ xCoor i5
  print $ yCoor i5
  print $ zCoor i5

  print $ i4 == i5
  print $ i5 == i6

  print $ i4 + i5
  print $ i4 * i5
  print $ negate i4
  print $ abs i5
  print $ signum i4
  print $ i5 - i4

  print $ i4 / i5
  print $ sqrt i4


  let i7 = Vec3 (i4, i5, i6)
  let i8 = Vec3 (i5, i6, i6)
  let i9 = Vec3 (i5, i6, i6)

  print $ i7
  print $ i8
  print $ i9

  print $ xCoor i7
  print $ yCoor i7
  print $ zCoor i7
  print $ xCoor i8
  print $ yCoor i8
  print $ zCoor i8

  print $ i7 == i8
  print $ i8 == i9

  print $ i7 + i8
  print $ i7 * i8
  print $ negate i7
  print $ abs i8
  print $ signum i7
  print $ i8 - i7

  print $ i7 / i8
  print $ sqrt i7