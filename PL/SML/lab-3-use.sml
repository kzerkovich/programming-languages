(****************************************************************************** 
  Предварительные определения для выполнения заданий лабораторной работы №3
 ******************************************************************************)

(****************************************************************************** 
  Установки вывода на экран
 ******************************************************************************)
Control.Print.printDepth := 20;
Control.Print.printLength := 200;
Control.Print.stringDepth := 500;
(****************************************************************************** 
  Вспомогательные определения и функции для работы со списками
 ******************************************************************************)
(* Выдает "случайное" целое число, на основе текущего времени 
 * для использования при инициализации датчика случайных чисел *)
fun seed () = 
  IntInf.toInt (Time.toMilliseconds (Time.now ()) mod 1000) + 100

(* В списке cs элемент с номером i меняется на значение a.
 * Функция предполагает, что элемент с номером i в списке присутствует *)
fun replace (cs, i, a) =
  let 
    fun replaceIter (_ :: cs, 0, acc) = revAppend (acc, a :: cs)
      | replaceIter (c :: cs, n, acc) = replaceIter (cs, n - 1, c :: acc)
      | replaceIter _ = raise Subscript
  in
    replaceIter (cs, i, [])
  end

(* В списке cs меняются местами элементы с номерами i и j.
 * Функция предполагает, что элементы с номерами i и j в списке присутствуют *)
fun interchange (cs, i, j) =
  let 
    val a = List.nth (cs, i)
    val b = List.nth (cs, j)
    val cs' = replace(cs, i, b) 
  in replace (cs', j, a)
  end

(* Функция "перемешивает" элементы списка l.
 * Возвращает список, в котором элементы списка l следуют в случайном порядке *)
fun shuffleList l =
  let
    val seed = seed () 
    val rnd = Random.rand (seed mod 67, seed)
    val maxNum = length l - 1
    fun getNum i = Random.randRange (i, maxNum) rnd
    fun shuffleIter (~1, l) = l
      | shuffleIter (i, l)  = 
          shuffleIter (i - 1, interchange (l, i, getNum i))
  in shuffleIter (maxNum - 1, l)
  end 

(* Функция трех аргументов. Второй аргумент список. Третий - целое число.
 * Первый аргумент относится к тому же типу, что и элементы списка.
 * Функция возвращает список, полученный из второго аргумента добавлением
 * в его начало n копий первого аргумента. *)
fun addNCopies (_, l, 0) = l
  | addNCopies (a, l, n) = addNCopies (a, a :: l, n - 1)

(* Функция получает два списка одного типа и число n. 
 * Функция перекладывает из головы первого списка n элементов во второй 
 * список. В результате выдается пара получившихся списков. 
 * Функция предполагает, что в первом списке найдется n элементов. *)
fun pass (xs, ys, 0) = (xs, ys)
  | pass (x :: xs, ys, n) = pass (xs, x :: ys, n - 1)
  | pass _ = raise Match

(* Функция получает значение, список элементов того же типа, что и значение,
 * и максимальное возможное количество n элементов списка в результате.
 * Функция добавляет заданный элемент в голову списка, после чего отсекает от 
 * его хвоста столько лишних элементов, чтобы в итоговом списке осталось 
 * максимальное возможное количество элементов, не превышающее n. *)
fun shift (x, xs, maxCap) =
  let 
    fun makeAccum ([], acc, _) = acc
      | makeAccum (_, acc, 0) = acc
      | makeAccum (x :: xs, acc, n) = makeAccum (xs, x :: acc, n - 1)
  in
    rev (makeAccum (xs, [x], maxCap - 1))
  end


(****************************************************************************** 
  Вспомогательные определения и функции для работы с картами колоды UNO
 ******************************************************************************)
(* Тип данных color: "масть" или цвет рядовой карты *)
datatype color = RED | GREEN | BLUE | YELLOW
(* Список всех мастей, задающий порядок "по возрастанию" *)
val colors = [YELLOW, BLUE, GREEN, RED]

(* Тип данных rank: ранг или значение рядовой карты *)
datatype rank = SKIP 
              | DRAW_TWO 
              | REVERSE 
              | NUM of int 
(* Список всех значений рядовых карт, задающий порядок "по возрастанию" *)
val ranks = [ NUM 0, NUM 1, NUM 2, NUM 3, NUM 4
            , NUM 5, NUM 6, NUM 7, NUM 8, NUM 9
            , REVERSE, SKIP, DRAW_TWO ]

(* Тип данных card: карта колоды UNO *)
datatype card = WILD | WILD_DRAW_FOUR | CRD of rank * color

(* Тип данных direction: направление игры (по и против часовой стрелки) *)
datatype direction = CLOCKWISE | COUNTERCLOCKWISE

(* Тип данных state: состояние хода (рядовой ход, исполнить команду, 
 * заказ цвета *)
datatype state = PROCEED | EXECUTE | GIVE of color

(* Тип данных move: ход игрока (рядовой ход, 
 * ход черной картой с заказом цвета, пас *)
datatype move = SIMPLE of card | ORDER of card * color | PASS

(* Тип данных strategy: сигнатура функции стратегии игрока:
 * на вход функции подается: 
 *    состояние хода, 
 *    список всех карт игрока,
 *    список тех карт игрока, которыми можно пойти, 
 *    карта, которая лежит наверху колоды "Сброс" (Pile), 
 *    напрвление игры,
 *    история из 10 последних ходов игры, 
 *    список, в котором каждый элемент - количество карт на руках
 *      соответствующего игрока при перечислении по часовой стрелке
 *      начиная с игрока, чей ход очередной.
 * на выходе функция должна получить ход игрока.
 * Функция стратегии запускается только тогда, когда игроку есть чем
 * сделать очередной ход. Поэтому результат PASS не допускается (он возможен
 * только для стратегии игры вручную и сигнализирует о том, что необходимо
 * перейти в автоматический режим). *)
type strategy = state * card list * card list * card 
                      * direction * move list * int list -> move

(* Сигнатура модуля Player *)
signature PLAYER = sig
  (* тип элемента "Игрок" *)
  type player
  (* конструктор для игрока 
   * принимает 4 аргумента:
   *    имя игрока - строка
   *    список карт на руках игрока
   *    функция стратегии игрока
   *    true - если вместо функции стратегии используется ручное 
   *           управление игроком *)
  val make        : string * card list * strategy * bool -> player

  (* Набор селекторов для игрока *)
  val getName     : player -> string 
  val getCards    : player -> card list
  val getStrategy : player -> strategy
  val isOnManual  : player -> bool

  (* Сеттеры для игрока *)
  (* замена списка карт игрока на новый список *)
  val setCards    : player * card list -> player
  (* функция переключения игрока на автоматический режим *)
  val automate    : player -> player
end

(* Модуль Player для игрока *)
structure Player :> PLAYER = struct
  type player = { name : string
                , cards : card list
                , strat : strategy
                , manual : bool 
                }
  fun make (n, cs, f, man) : player = 
    {name= n, cards = cs, strat = f, manual = man}

  fun getName ({name = n, ...} : player) = n
  fun getCards ({cards = cs, ...} : player) = cs
  fun getStrategy ({strat = f, ...} : player) = f 
  fun isOnManual ({manual = man, ...} : player) = man

  fun setCards (p, newCs) =
    make (getName p, newCs, getStrategy p, isOnManual p)
  fun automate p =
    make (getName p, getCards p, getStrategy p, false)
end

(* синоним типа Player.player для краткости записи *)
type player = Player.player

(* Сигнатура модуля Desk (состояние игры) *)
signature DESK = sig
  (* Тип элемента Desk *)
  type desk
    (* конструктор эелемнта desk 
   * принимает 6 аргументов:
   *    список игроков
   *    список карт в колоде "Сброс" Pile
   *    список карт в колоде "Прикуп" Deck
   *    Состояние хода
   *    Направление хода игры
   *    Накопленнная память: информация о 10 последних ходах игроков *)
  val make : player list * card list * card list * state * direction * move list -> desk

  (* Набор селекторов для состояния игры *)
  val getPlayers   : desk -> player list
  val getPile      : desk -> card list
  val getDeck      : desk -> card list
  val getState     : desk -> state
  val getDirection : desk -> direction
  val getMemo      : desk -> move list

  (* Набор сеттеров для элементов состояния игры *)
  val setPlayers   : desk * player list -> desk
  val setDirection : desk * direction -> desk
  val setState     : desk * state -> desk
  val setDeck      : desk * card list -> desk
  val setPile      : desk * card list -> desk

  (* Функция добавляет очередной хок к "памяти" хода игры *)
  val addMemo      : desk * move -> desk

  (* Функция выводит на экран имя игрока, чей ход текущий *)
  val whoseTurn    : desk -> desk
end

(* Модуль Desk для состояния игры *)
structure Desk :> DESK = struct

  type desk = { players : player list
              , pile    : card list
              , deck    : card list
              , st      : state
              , dir     : direction
              , memo    : move list
              }

  fun make (ps, cs, ds, st, d, m) : desk = 
    {players = ps, pile = cs, deck = ds, st = st, dir = d, memo = m}

  fun getPlayers ({players = ps, ...} : desk) = ps
  fun getPile ({pile = cs, ...} : desk) = cs
  fun getDeck ({deck = ds, ...} : desk) = ds
  fun getState ({st = st, ...} : desk) = st
  fun getDirection ({dir = d, ...} : desk) = d
  fun getMemo ({memo = m, ...} : desk) = m

  fun setPlayers (dsk, newPlayers) =
    make ( newPlayers
         , getPile dsk
         , getDeck dsk
         , getState dsk
         , getDirection dsk
         , getMemo dsk
         )

  fun setState (dsk, newState) =
    make ( getPlayers dsk
         , getPile dsk
         , getDeck dsk
         , newState
         , getDirection dsk
         , getMemo dsk
         )

  fun setDirection (dsk, newDirection) =
    make ( getPlayers dsk
         , getPile dsk
         , getDeck dsk
         , getState dsk
         , newDirection
         , getMemo dsk
         )

  fun setDeck (dsk, newDeck) =
    make ( getPlayers dsk
         , getPile dsk
         , newDeck
         , getState dsk
         , getDirection dsk
         , getMemo dsk
         )

  fun setPile (dsk, newPile) =
    make ( getPlayers dsk
         , newPile
         , getDeck dsk
         , getState dsk
         , getDirection dsk
         , getMemo dsk
         )

  fun addMemo (dsk, newMemo) =
    make ( getPlayers dsk
         , getPile dsk
         , getDeck dsk
         , getState dsk
         , getDirection dsk
         (* В "памяти" остается не более 10 ходов  *)
         , shift (newMemo, getMemo dsk, 10)
         )

  (* Вывод на экран имени текущего игрока *)
  fun whoseTurn dsk =
    let 
      val plr :: _ = getPlayers dsk
      val _ = print ("\nThe turn of " ^ Player.getName plr ^ "\n")
    in
      dsk
    end
end

(* синоним имени типа для краткости использования *)
type desk = Desk.desk

(* Исключения, необходимые для реализации игры *)
(* Исключение "Невозможная игра" *)
exception IllegalGame
(* Исключение "Недозволенный ход" для поднятия в случае когда стратегия игрока 
 * пытается сделать ход, который нельзя сделать в текущем состоянии игры*)
exception IllegalMove of string * ( state * card list * card list * card 
                                          * direction * move list * int list )
(* Сигнатура для модуля с функцией стратегии *)
(* В модуле должна быть доступна только одна функция стратегии,
 * имя которой ownStrategy *)
signature STRATEGY = 
sig
  val ownStrategy : strategy
end

 
(* Модуль False с функцией стратегии для тестирования
 * функция False.ownStrategy берет первую попавшуюся карту игрока, 
 * предполагая, что это рядовая карта,
 * и возвращает карту с тем же значением, но зеленого цвета. *)
structure False :> STRATEGY = struct
  fun ownStrategy (_, crds, _, _, _, _, _) =
    case crds
      of CRD (rk, _) :: _ => SIMPLE (CRD (rk, GREEN))
       | _ => raise IllegalGame
end

(* Функции сравнения на равенство элементов карты *)
(* Сравнение на равенство двух значений рядовых карт *)
fun isSameRank  (r1 : rank, r2 : rank) = r1 = r2
(* Сравнение на равенство двух мастей карт *)
fun isSameColor (col1 : color, col2 : color) = col1 = col2
(* Сравнение на равенство двух карт *)
fun isSameCard  (c1 : card, c2 : card) = c1 = c2

(* Набор функций для трансформации элементов данных, связанных с игрой UNO, 
 * в строку *)
(* Преобразование в строку значения рядовой карты UNO *)
fun rankToString (NUM i) = "NUM " ^ Int.toString i
  | rankToString SKIP = "SKIP"
  | rankToString REVERSE = "REVERSE"
  | rankToString DRAW_TWO = "DRAW_TWO"
(* Преобразование в строку масти рядовой карты UNO *)
fun colorToString RED = "RED"
  | colorToString BLUE = "BLUE"
  | colorToString YELLOW = "YELLOW"
  | colorToString GREEN = "GREEN"
(* Преобразование в строку карты UNO *)
fun cardToString WILD = "WILD"
  | cardToString WILD_DRAW_FOUR = "WILD_DRAW_FOUR"
  | cardToString (CRD (rk, col)) = 
      String.concat [ "CRD ("
                    , rankToString rk
                    , ", "
                    , colorToString col
                    , ")" 
                    ]
(* Преобразование в строку состояния игры *)
fun stateToString PROCEED = "PROCEED"
  | stateToString EXECUTE = "EXECUTE"
  | stateToString (GIVE col) = "GIVE " ^ colorToString col 
(* Преобразование в строку направления хода игры *)
fun directionToString CLOCKWISE = "CLOCKWISE"
  | directionToString COUNTERCLOCKWISE = "COUNTERCLOCKWISE"
(* Преобразование в строку хода игрока *)
fun moveToString PASS = "PASS"
  | moveToString (SIMPLE (crd as CRD _)) = "SIMPLE (" ^ cardToString crd ^ ")"
  | moveToString (SIMPLE crd) = "SIMPLE " ^ cardToString crd
  | moveToString (ORDER (crd, col)) =
      String.concat [ "ORDER ("
                    , cardToString crd
                    , ", "
                    , colorToString col
                    , ")"]

(* Преобразование в строку списка элементов lst
 * f - функция преобразования одного элемента списка в строку *)
fun listToString f lst = "[" ^ String.concatWith ", " (map f lst) ^ "]"
(* Преобразование в строку списка элементов lst с выводом
 * каждого элемента спсика с новой строки
 * f - функция преобразования одного элемента списка в строку *)
fun listToStringLn f lst = "[ " ^ String.concatWith "\n, " (map f lst) ^ " ]"
