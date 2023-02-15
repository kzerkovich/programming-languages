(****************************************************************************** 
  Шаблон для выполнения заданий лабораторной работы №3

  НЕ СЛЕДУЕТ УДАЛЯТЬ ИЛИ ПЕРЕСТАВЛЯТЬ МЕСТАМИ ЭЛЕМЕНТЫ, 
  ПРЕДСТАВЛЕННЫЕ В ШАБЛОНЕ (ВКЛЮЧАЯ КОММЕНТАРИИ). 
  ЭЛЕМЕНТЫ РЕШЕНИЯ СЛЕДУЕТ ВПИСЫВАТЬ В ПРОМЕЖУТКИ,
  ОПРЕДЕЛЕННЫЕ КОММЕНТАРИЯМИ.
 ******************************************************************************)

(****************************************************************************** 
  Загрузка предварительных определений типов данных и вспомогательных функций 
 ******************************************************************************)
use "lab-3-use.sml";

(****************************************************************************** 
  Задание 1 precedes
 ******************************************************************************)
fun precedes f (h :: t) a1 a2 = 
    if not (f (h, a1) orelse f (h, a2))
    then precedes f t a1 a2
    else f (h, a1)
  | precedes _ [] _ _ = raise IllegalGame

(******************************************************************************)

(****************************************************************************** 
  Задание 2 colorIsLT и rankIsLT
 ******************************************************************************)
fun colorIsLT col1 col2 = precedes isSameColor colors col1 col2

fun rankIsLT r1 r2 = precedes isSameRank ranks r1 r2

(******************************************************************************)

(****************************************************************************** 
  Задание 3 isLT
 ******************************************************************************)
fun isLT (_, WILD_DRAW_FOUR) = true
  | isLT (WILD_DRAW_FOUR, _) = false
  | isLT (_, WILD) = true
  | isLT (WILD, _) = false
  | isLT (CRD (r1, c1), CRD (r2, c2)) =  
      colorIsLT c1 c2 andalso ( (not (isSameColor (c1,c2))) 
                              orelse rankIsLT r1 r2 )

(******************************************************************************)

(****************************************************************************** 
  Задание 4 cardSort
 ******************************************************************************)
fun cardSort lst = ListMergeSort.sort isLT lst

(******************************************************************************)

(****************************************************************************** 
  Задание 5 cardValue
 ******************************************************************************)
fun cardValue (CRD (NUM i,_)) = i
  | cardValue (CRD (_, _)) = 20
  | cardValue _ = 50

(******************************************************************************)

(****************************************************************************** 
  Задание 6 sumCards
 ******************************************************************************)
fun sumCards [] = 0
  | sumCards (h :: t) = cardValue h + sumCards t

(******************************************************************************)

(****************************************************************************** 
  Задание 7 oppositeDir
 ******************************************************************************)
fun oppositeDir CLOCKWISE = COUNTERCLOCKWISE 
  | oppositeDir _ = CLOCKWISE

(******************************************************************************)

(****************************************************************************** 
  Задание 8 removeCard
 ******************************************************************************)
fun removeCard (cs, c, e) = 
  let fun removeCardH ([], _, e, _) = raise e
        | removeCardH (h :: t, c, e, l) = 
          if isSameCard (h, c) 
          then List.revAppend (l, t)
          else removeCardH (t, c, e, h :: l)
  in 
    removeCardH (cs, c, e, [])
  end


(******************************************************************************)

(****************************************************************************** 
  Задание 9 cardCount
 ******************************************************************************)
fun cardCount (CRD (NUM 0, _)) = 1
  | cardCount (CRD _) = 2
  | cardCount _ = 4

(******************************************************************************)

(****************************************************************************** 
  Задание 10 deck
 ******************************************************************************)
val deck = 
  let 
    val l = (List.concat ( map (fn x=> map (fn y => CRD (x, y)) colors) ranks))
            @ [WILD, WILD_DRAW_FOUR]
  in
    foldr (fn (x, l) => addNCopies(x, l, cardCount x - 1)) l l 
  end

(*****************************************************************************)

(****************************************************************************** 
  Задание 11 deal
  Заготовка для вывода сообщения:
  
 ******************************************************************************)
fun deal [] = raise IllegalGame
  | deal (pl as (plr :: _)) = 
    let
      val _ = print ("\nPlayer " ^ Player.getName plr ^ " deals.\n")
      fun fHelp ([], acc, d) = (List.rev acc, d)
        | fHelp (plr :: p, acc, d) = 
          let 
            val (a, b) = pass (d, [], 7)
          in 
            fHelp (p, Player.setCards (plr, b) :: acc, a)
          end 
      val (plr, d1 :: dck) = fHelp (pl, [], shuffleList deck)
    in
      Desk.make (plr, [d1], dck, PROCEED, CLOCKWISE, [])
    end



(******************************************************************************)

(****************************************************************************** 
  Задание 12 nextPlayer
 ******************************************************************************)
fun nextPlayer dsk =
  Desk.whoseTurn 
    ( Desk.setPlayers ( dsk 
                      , case (Desk.getDirection dsk) 
                          of CLOCKWISE => let 
                                            val h :: t = Desk.getPlayers dsk
                                          in
                                            t @ [h]
                                          end
                           | _ => let
                                    val h :: t =
                                      List.rev (Desk.getPlayers dsk)
                                  in
                                    h :: (List.rev t)
                                  end
                      ))

(******************************************************************************)

(****************************************************************************** 
  Задание 13 deskNormalize
 ******************************************************************************)
fun deskNormalize dsk = 
  let
    val h :: _ = Desk.getPile dsk
    fun whil (h1, d1) = 
           let
             val s :: d = shuffleList (h1 :: d1)
           in
             if cardValue s = 50
             then whil (s, d)
             else nextPlayer (Desk.setPile (Desk.setDeck (dsk, d), [s]))
           end
  in
    case h
    of CRD (REVERSE, _) =>
      Desk.whoseTurn (Desk.setDirection 
                        (dsk, oppositeDir (Desk.getDirection dsk)) )
     | CRD (NUM _ , _) => nextPlayer dsk
     | CRD _ => nextPlayer (Desk.setState (dsk, EXECUTE))
     | _ => whil (h, Desk.getDeck dsk)
  end
  


(******************************************************************************)

(****************************************************************************** 
  Задание 14 draw
 ******************************************************************************)
fun draw dsk = 
  if null (Desk.getDeck dsk)
  then 
    let val h1 :: t1 = Desk.getPile dsk
    in draw (Desk.setPile (Desk.setDeck (dsk, shuffleList t1), [h1]))
    end
  else 
    let 
      val plr :: p = Desk.getPlayers dsk
      val h :: t = Desk.getDeck dsk
    in 
      Desk.setDeck 
       ( Desk.setPlayers 
           (dsk, (Player.setCards (plr, h :: (Player.getCards plr)) ) :: p)
       , t)
    end

(******************************************************************************)

(****************************************************************************** 
  Задание 15 drawTwo
 ******************************************************************************)
val drawTwo = draw o draw
(******************************************************************************)

(****************************************************************************** 
  Задание 16 drawFour
 ******************************************************************************)
val drawFour = drawTwo o drawTwo

(******************************************************************************)

(****************************************************************************** 
  Задание 17 playableWhenWild
 ******************************************************************************)
fun playableWhenWild col (CRD (_, c)) = isSameColor (c, col)
  | playableWhenWild _ _ = true

(******************************************************************************)

(****************************************************************************** 
  Задание 18 playableWhenExec
 ******************************************************************************)
fun playableWhenExec rnk (CRD (r, _)) = isSameRank (r, rnk)
  | playableWhenExec _ _ = false

(******************************************************************************)

(****************************************************************************** 
  Задание 19 playableWhenProc
 ******************************************************************************)
fun playableWhenProc (r1, c1) (CRD (r2, c2)) = isSameRank (r1, r2)
                                               orelse isSameColor (c1, c2)
  | playableWhenProc _ _ = true

(******************************************************************************)

(****************************************************************************** 
  Задание 20 cardsToPlay
 ******************************************************************************)
fun cardsToPlay dsk = 
  let 
    val plr :: _ = Desk.getPlayers dsk
  in
    case Desk.getState dsk
      of EXECUTE => 
            let 
              val (CRD (r, _)) :: _ = Desk.getPile dsk
            in List.filter (fn x => playableWhenExec r x) 
                           (Player.getCards plr)
            end
      | PROCEED => 
            let 
              val (CRD (r, c)) :: _ = Desk.getPile dsk
            in List.filter (fn x => playableWhenProc (r, c) x)
                                    (Player.getCards plr)
            end
      | GIVE c1 => List.filter (fn x => playableWhenWild c1 x) 
                            (Player.getCards plr)
  end

(******************************************************************************)

(****************************************************************************** 
  Задание 21 requiredColor
 ******************************************************************************)
fun requiredColor dsk =
  case Desk.getState dsk
    of GIVE c1 => c1
     | _ => let  
              val (CRD (_, c)) :: _ =  Desk.getPile dsk
            in c
            end

(******************************************************************************)

(****************************************************************************** 
  Задание 22 hasColor
 ******************************************************************************)
fun hasColor (clr, cs) = 
  isSome (List.find (fn CRD (_, c) => isSameColor (c,clr) | _ => false) cs)


(******************************************************************************)

(****************************************************************************** 
  Задание 23 countCards
 ******************************************************************************)
fun countCards dsk = 
  map (fn p => List.length (Player.getCards p)) (Desk.getPlayers dsk)
 
 
(******************************************************************************)

(****************************************************************************** 
  Модуль Manual с функцией стратегии для тестирования
  функция Manual.ownStrategy выводит на экран все аргументы, переданные в 
  функцию стратегии, и позволяет пользователю выбрать нужный ход вручную.
  Функция может вернуть значение PASS в случае, если пользователь
  делает некорректный выбор из предложенных списков. 

  ФУНКЦИЮ МОЖНО РАСКОММЕНТИРОВАТЬ ПОСЛЕ РЕАЛИЗАЦИИ ФУНКЦИИ cardSort
 ******************************************************************************)
structure Manual :> STRATEGY = struct
  fun ownStrategy ( st, crdsOnHand, playCrds, crdOnPile
                  , dir, lastMoveList, crdCountList ) =
    let
      val _ = print ("State: " ^ stateToString st ^ "\n")
      val crdsOnHandSorted = cardSort crdsOnHand
      val _ = print ( "All cards on hand: \n" 
                      ^ listToStringLn cardToString crdsOnHandSorted ^ "\n" )
      val playCrdsSorted = cardSort playCrds
      val _ = print ( "Playable cards: \n" 
                      ^ listToStringLn cardToString playCrdsSorted ^ "\n" )
      val _ = print ("A card on the pile: " ^ cardToString crdOnPile ^ "\n")
      val _ = print ("Game direction: " ^ directionToString dir ^ "\n")
      val _ = print ( "A list of last moves: \n" 
                      ^ listToStringLn moveToString lastMoveList ^ "\n" )
      val _ = 
        print ( "A list of the number of cards in the hands of the players: \n" 
                ^ listToString Int.toString crdCountList ^ "\n" )
      val _ = print ( "Enter the number of the selected card "
                      ^ "from the list of playable cards (from 0). \n" )
      val _ = print ( "Any other number to switch to automatic mode. \n")
      val str = valOf (TextIO.inputLine TextIO.stdIn)
      val numberOfCard = (valOf (Int.fromString str)) handle Option => ~1
      val mv = (SIMPLE (List.nth (playCrdsSorted, numberOfCard)))
                handle Subscript => PASS
    in
      case mv
        of SIMPLE (CRD _) => mv
         | PASS => mv
         | SIMPLE crd =>
             let 
               val _ = print ( "Enter the number of color from list (from 0) \n"
                               ^ listToString colorToString colors ^ "\n" )
               val _ = print ( "Any other number to switch "
                               ^ "to automatic mode. \n" )
               val str = valOf (TextIO.inputLine TextIO.stdIn)
               val numberOfCol = (valOf (Int.fromString str)) 
                                  handle Option => ~1
             in 
                (ORDER (crd, List.nth (colors, numberOfCol)))
                 handle Subscript => PASS
             end 
         | _ => raise IllegalGame 
    end
end
(******************************************************************************)

(****************************************************************************** 
  Задание 24 Naive.ownStrategy
 ******************************************************************************)
structure Naive :> STRATEGY = struct
  fun ownStrategy (_, _, playCrds, _, _, _, _) =
    let
      val h :: _ = cardSort playCrds
      val c :: _ = shuffleList colors
    in
      case h
        of (CRD _) => SIMPLE h
         | _ => ORDER (h, c)
    end
end

(******************************************************************************)

(****************************************************************************** 
  Задание 25 moveAction
 ******************************************************************************)
fun moveAction (ORDER (WILD, c), dsk, _) =
      nextPlayer (Desk.setState (dsk, GIVE c)) 
  | moveAction (SIMPLE (CRD (REVERSE, _)), dsk, _) =
      nextPlayer 
        (Desk.setDirection ( Desk.setState (dsk, PROCEED)
                           , oppositeDir (Desk.getDirection dsk)) ) 
  | moveAction (SIMPLE (CRD (NUM _, _)), dsk, _) =
      nextPlayer (Desk.setState (dsk, PROCEED))
  | moveAction (SIMPLE _, dsk, _) = nextPlayer (Desk.setState (dsk, EXECUTE))
  | moveAction (ORDER (WILD_DRAW_FOUR, c), dsk, true) = 
      nextPlayer (Desk.setState (drawFour dsk, GIVE c))
  | moveAction (ORDER (WILD_DRAW_FOUR, c), dsk, false) = 
      nextPlayer 
        (Desk.addMemo ( drawFour (nextPlayer (Desk.setState (dsk, GIVE c)))
                      , PASS) )
  | moveAction (_, dsk, _) = dsk

(******************************************************************************)

(****************************************************************************** 
  Задание 26 askPlayerForCard
 ******************************************************************************)
fun askPlayerForCard (plr, args) =
  let 
    fun m1 p = (Player.getStrategy p) args
    val pA = Player.automate plr
  in 
    if Player.isOnManual plr
    then case Manual.ownStrategy args
           of PASS => (pA, m1 pA)
            | x => (plr, x)
    else (plr, m1 plr)
  end

(******************************************************************************)

(****************************************************************************** 
  Задание 27 play
  Заготовка для вывода сообщения:
  val _ = print (playerName ^ " made move\n")
  val _ = print (moveToString mv ^ "\n")
  ( st, crdsOnHand, playCrds, crdOnPile
                  , dir, lastMoveList, crdCountList )
 ******************************************************************************)
fun play (dsk, pCrd) = 
  let
    val plr :: pt = Desk.getPlayers dsk
    val playerName = Player.getName plr
    val crd = Player.getCards plr
    val pile as (pl :: _) = Desk.getPile dsk
    val arg = ( Desk.getState dsk, crd, pCrd, pl
              , Desk.getDirection dsk
              , Desk.getMemo dsk
              , countCards dsk
              )
    val res = (playerName, arg)
    val (p1, m1) = (askPlayerForCard (plr, arg))
    val _ = print (playerName ^ " made move\n")
    val _ = print (moveToString m1 ^ "\n")
    val hod = case m1
               of PASS => raise IllegalMove res
                | SIMPLE x => x
                | ORDER (x, _) => x
    val _ = removeCard (pCrd, hod, IllegalMove res)
    val p2 = Player.setCards (p1, removeCard (crd, hod, IllegalMove res))
  in
    moveAction 
      ( m1
      , Desk.setPlayers ( Desk.setPile (Desk.addMemo (dsk, m1), hod :: pile)
                        , p2 :: pt) 
      , hasColor (requiredColor dsk, crd) )
  end

(******************************************************************************)

(****************************************************************************** 
  Задание 28 execution
 ******************************************************************************)
fun execution dsk = 
  let
    val h :: _ = Desk.getPile dsk
    val dsk1 = Desk.setState (Desk.addMemo (dsk, PASS), PROCEED)
  in
    case h
      of CRD (SKIP, _) => nextPlayer dsk1
       | CRD (DRAW_TWO, _) => nextPlayer (drawTwo dsk1)
       | _ => raise IllegalGame
  end

(******************************************************************************)

(****************************************************************************** 
  Задание 29 yourTurn
 ******************************************************************************)
fun yourTurn dsk = 
  let
    val pCrd = cardsToPlay dsk 
    val dsk1 = draw dsk
    val pC = cardsToPlay dsk1
  in
    if null pCrd 
    then 
      case Desk.getState dsk
        of EXECUTE => execution dsk
         | _ => if null pC
                then nextPlayer (Desk.addMemo (dsk1, PASS))
                else play (dsk1, pC)
    else play (dsk, pCrd)
  end

(******************************************************************************)

(****************************************************************************** 
  Задание 30 playerLoss
 ******************************************************************************)
fun playerLoss plr = (Player.getName plr, sumCards (Player.getCards plr))

(******************************************************************************)

(****************************************************************************** 
  Задание 31 checkWinner
 ******************************************************************************)
fun checkWinner dsk = 
  let
    val pl = Desk.getPlayers dsk
    val win = List.find (fn x => null (Player.getCards x)) pl
  in
    if isSome win
    then SOME ( (Player.getName o valOf) win
              , List.map playerLoss pl)
    else NONE
  end
  
(******************************************************************************)

(****************************************************************************** 
  Задание 32 game
 ******************************************************************************)
fun game plr =
  let
    val dsk = deskNormalize (deal plr)
    fun g dsk1 = 
      case checkWinner dsk1
        of NONE => g (yourTurn dsk1)
         | x => x
  in 
    g dsk
  end


(******************************************************************************)
