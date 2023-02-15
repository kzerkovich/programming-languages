signature VECTOR = sig

  type vector

  val vec3 : real * real * real -> vector
  val xCoor : vector -> real
  val yCoor : vector -> real
  val zCoor : vector -> real
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


structure Vector :> VECTOR = struct

datatype vector = NEW_VECTOR of real * real * real

fun vec3 i = NEW_VECTOR i

fun xCoor (NEW_VECTOR (x, _, _)) = x

fun yCoor (NEW_VECTOR (_, y, _)) = y

fun zCoor (NEW_VECTOR (_, _, z)) = z

fun toString i =
  "(" ^ Real.toString (xCoor i) ^ ", " 
      ^ Real.toString (yCoor i) ^ ", "
      ^ Real.toString (zCoor i) ^ ")"

fun isEq (i1, i2) =
  let
    val x1 = xCoor i1
    val x2 = xCoor i2
    val y1 = yCoor i1
    val y2 = yCoor i2
    val z1 = zCoor i1
    val z2 = zCoor i2
  in
    x1 <= x2 
    andalso x1 >= x2
    andalso y1 <= y2 
    andalso y1 >= y2 
    andalso z1 <= z2
    andalso z1 >= z2
  end

fun add (i1, i2) =
  vec3 (xCoor i1 + xCoor i2, yCoor i1 + yCoor i2, zCoor i1 + zCoor i2)

fun mul (i1, i2) =
  let
    val x1 = xCoor i1
    val x2 = xCoor i2
    val y1 = yCoor i1
    val y2 = yCoor i2
    val z1 = zCoor i1
    val z2 = zCoor i2
  in
    vec3 (y1 * z2 - y2 * z1, z1 * x2 - z2 * x1, x1 * y2 - x2 * y1)
  end

fun negate i = vec3 (Real.~ (xCoor i), Real.~ (yCoor i), Real.~ (zCoor i))

fun abs i =
  let 
    val x = xCoor i
    val y = yCoor i
    val z = zCoor i
  in
    vec3 (Math.sqrt (x * x + y * y + z * z), 0.0, 0.0)
  end

fun sign i = 
  let
    val x = xCoor i
    val y = yCoor i
    val z = zCoor i
    val denom = Math.sqrt (x * x + y * y + z * z)
  in
    vec3 (x / denom, y / denom, z / denom)
  end

fun sub (i1, i2) = add (i1, negate i2)

fun fromReal n = vec3 (n, 0.0, 0.0)

end



type vector = Vector.vector

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