signature ITEM = sig
  type item
  val isEq : item * item -> bool
  val toString : item -> string
  val add : item * item -> item
  val mul : item * item -> item
  val negate : item -> item
  val sign : item -> item
  val abs : item -> item
  val divide : item * item -> item
  val fromReal : real -> item
  val sqrt : item -> item
end 

structure RealItem = struct
  type item = real
  val isEq = Real.==
  val toString = Real.toString
  val add = Real.+
  val mul = Real.*
  val negate = Real.~
  val sign = real o Real.sign
  val abs = Real.abs
  val divide = Real./
  fun fromReal x = x
  val sqrt = Math.sqrt
end

signature VECTOR = sig
  type vector
  type item
  val vec3 : item * item * item -> vector
  val xCoor : vector -> item
  val yCoor : vector -> item
  val zCoor : vector -> item
  val toString : vector -> string
  val isEq : vector * vector -> bool
  val add : vector * vector -> vector
  val mul : vector * vector -> vector
  val negate : vector -> vector
  val abs : vector -> vector
  val sign : vector -> vector
  val sub : vector * vector -> vector
  val fromReal : real -> vector
end

functor VectorFn (Item : ITEM) : VECTOR = struct
datatype vector = NewVector of Item.item * Item.item * Item.item
type item = Item.item
fun vec3 i = NewVector i
fun xCoor (NewVector (x, _, _)) = x
fun yCoor (NewVector (_, y, _)) = y
fun zCoor (NewVector (_, _, z)) = z
fun toString i =
  "(" ^ Item.toString (xCoor i) ^ ", " 
      ^ Item.toString (yCoor i) ^ ", "
      ^ Item.toString (zCoor i) ^ ")"
fun isEq (i1, i2) =
  Item.isEq (xCoor i1, xCoor i2)
  andalso Item.isEq (yCoor i1, yCoor i2)
  andalso Item.isEq (zCoor i1, zCoor i2)
fun add (i1, i2) =
  vec3 ( Item.add (xCoor i1, xCoor i2)
       , Item.add (yCoor i1, yCoor i2)
       , Item.add (zCoor i1, zCoor i2)
       )
fun mul (i1, i2) =
  let
    val x1 = xCoor i1
    val x2 = xCoor i2
    val y1 = yCoor i1
    val y2 = yCoor i2
    val z1 = zCoor i1
    val z2 = zCoor i2
  in
    vec3 ( Item.add (Item.mul (y1, z2), Item.negate (Item.mul (y2, z1)))
         , Item.add (Item.mul (z1, x2), Item.negate (Item.mul (z2, x1)))
         , Item.add (Item.mul (x1, y2), Item.negate (Item.mul (x2, y1)))
         )
  end
fun negate i =
  vec3 (Item.negate (xCoor i), Item.negate (yCoor i), Item.negate (zCoor i))
fun abs i =
  let 
    val x = xCoor i
    val y = yCoor i
    val z = zCoor i
  in
    vec3 ( Item.sqrt ( Item.add ( Item.mul (x, x)
                                , Item.add (Item.mul (y, y), Item.mul (z, z))
                                )
                     )
         , Item.fromReal 0.0
         , Item.fromReal 0.0
         )
  end
fun sign i = 
  let
    val x = xCoor i
    val y = yCoor i
    val z = zCoor i
    val denom = Item.sqrt ( Item.add ( Item.mul (x, x)
                                     , Item.add ( Item.mul (y, y)
                                                , Item.mul (z, z)
                                                )
                                     )
                          )
  in
    vec3 ( Item.divide (x, denom)
         , Item.divide (y, denom)
         , Item.divide (z, denom)
         )
  end
fun sub (i1, i2) = add (i1, negate i2)
fun fromReal n = 
  let
    val realItem = Item.fromReal n
  in 
    vec3 (realItem, Item.fromReal 0.0, Item.fromReal 0.0)
  end
end

structure Vector = VectorFn (RealItem)

type vector = Vector.vector
type item = Vector.item
val vec3 = Vector.vec3
val i1 = vec3 (1.2, 4.1, 8.4)
val i2 = vec3 (6.7, 3.3, 9.0)
val i3 = vec3 (6.7, 3.3, 9.0)
val i1xCoor = Vector.xCoor i1
val i2yCoor = Vector.yCoor i2
val i1zCoor = Vector.zCoor i1
val i1String = Vector.toString i1
val i2String = Vector.toString i2
val i1i2isEq = Vector.isEq (i1, i2)
val i2i3isEq = Vector.isEq (i2, i3)
val i1addi2 = Vector.toString (Vector.add (i1, i2))
val i1muli2 = Vector.toString (Vector.mul (i1, i2))
val i1neg = Vector.toString (Vector.negate i1)
val i2abs = Vector.toString (Vector.abs i2)
val i1sign = Vector.toString (Vector.sign i1)
val i1subi2 = Vector.toString (Vector.sub (i2, i1))
val vector_test = Vector.fromReal 3.3
val vector_test_str = Vector.toString vector_test

structure IntItem = struct
  type item = int
  val isEq = (op =)
  val toString = Int.toString
  val add = Int.+
  val mul = Int.*
  val negate = Int.~
  val sign = Int.sign
  val abs = Int.abs
  val divide = Int.div
  val fromReal = trunc
  fun sqrt n = fromReal (Math.sqrt (real n))
end

structure IntVector = VectorFn (IntItem)
type intvector = IntVector.vector
type item = IntVector.item

val vec3 = IntVector.vec3
val it1 = vec3 (1, 4, 8)
val it2 = vec3 (6, 3, 9)
val it3 = vec3 (6, 3, 9)
val it1xCoor = IntVector.xCoor it1
val it2yCoor = IntVector.yCoor it2
val it1zCoor = IntVector.zCoor it1
val it1String = IntVector.toString it1
val i2String = IntVector.toString it2
val i1i2isEq = IntVector.isEq (it1, it2)
val i2i3isEq = IntVector.isEq (it2, it3)
val it1addi2 = IntVector.toString (IntVector.add (it1, it2))
val it1muli2 = IntVector.toString (IntVector.mul (it1, it2))
val it1neg = IntVector.toString (IntVector.negate it1)
val it2abs = IntVector.toString (IntVector.abs it2)
val it1sign = IntVector.toString (IntVector.sign it1)
val it1subi2 = IntVector.toString (IntVector.sub (it2, it1))
val vector_testt = IntVector.fromReal 3.3
val vector_testt_str = IntVector.toString vector_testt

structure VectorItem = struct
  type item = IntVector.vector
  val isEq = IntVector.isEq 
  val toString = IntVector.toString
  val add = IntVector.add
  val mul = IntVector.mul
  val negate = IntVector.negate
  val sign = IntVector.sign
  val abs = IntVector.abs
  val fromReal = IntVector.fromReal
  fun sqrt n = 
    fromReal ( Math.sqrt ( real ( IntVector.xCoor n 
                                + IntVector.yCoor n 
                                + IntVector.zCoor n
                                )
                         )
             )
  fun divide (n1, n2) = 
    fromReal ( real ( IntVector.xCoor n1 
                    + IntVector.yCoor n1 
                    + IntVector.zCoor n1
                    ) 
             / real ( IntVector.xCoor n2 
                    + IntVector.yCoor n2 
                    + IntVector.zCoor n2
                    )
             )
end
structure VectorVector = VectorFn (VectorItem)
type intvector = VectorVector.vector
type item = VectorVector.item
val vec3 = VectorVector.vec3

val int1 = vec3 (it1, it2, it3)
val int2 = vec3 (it3, it2, it2)
val int3 = vec3 (it3, it2, it2)
val int1xCoor = VectorVector.xCoor int1
val int2yCoor = VectorVector.yCoor int2
val int1zCoor = VectorVector.zCoor int1
val int1String = VectorVector.toString int1
val int2String = VectorVector.toString int2
val int1i2isEq = VectorVector.isEq (int1, int2)
val int2i3isEq = VectorVector.isEq (int2, int3)
val int1addi2 = VectorVector.toString (VectorVector.add (int1, int2))
val int1muli2 = VectorVector.toString (VectorVector.mul (int1, int2))
val int1neg = VectorVector.toString (VectorVector.negate int1)
val int2abs = VectorVector.toString (VectorVector.abs int2)
(*val int1sign = VectorVector.toString (VectorVector.sign int1)*)
val int1subi2 = VectorVector.toString (VectorVector.sub (int2, int1))
val vector_testnt = VectorVector.fromReal 3.3
val vector_testnt_str = VectorVector.toString vector_testnt