(****************************************************************************** 
  Шаблон для выполнения заданий лабораторной работы №2

  НЕ СЛЕДУЕТ УДАЛЯТЬ ИЛИ ПЕРЕСТАВЛЯТЬ МЕСТАМИ ЭЛЕМЕНТЫ, 
  ПРЕДСТАВЛЕННЫЕ В ШАБЛОНЕ (ВКЛЮЧАЯ КОММЕНТАРИИ). 
  ЭЛЕМЕНТЫ РЕШЕНИЯ СЛЕДУЕТ ВПИСЫВАТЬ В ПРОМЕЖУТКИ,
  ОПРЕДЕЛЕННЫЕ КОММЕНТАРИЯМИ.
 ******************************************************************************)

(****************************************************************************** 
  Определение выражений языка MUPL как конструкторов значений типа expr 
 ******************************************************************************)
datatype expr = VAR of string
              | INT of int
              | ADD of expr * expr
              | IF_GREATER of expr * expr * expr * expr
              | FUN of (string * string) * expr
              | CALL of expr * expr
              | LET of (string * expr) * expr
              | PAIR of expr * expr
              | HEAD of expr
              | TAIL of expr
              | NULL 
              | IS_NULL of expr
              | CLOSURE of (string * expr) list * expr
(******************************************************************************)

(****************************************************************************** 
  Описание исключения, которое будет подниматься в случае нарушения семантики 
  выражения языка MUPL
 ******************************************************************************)
exception Expr
(******************************************************************************)

(****************************************************************************** 
  Функция превращения строки в строку, в которой имеются знаки кавычек
 ******************************************************************************)
fun strToString str = String.concat ["\"", str, "\""]
(******************************************************************************)

(****************************************************************************** 
  Задание 1 exprToString и pairToString
 ******************************************************************************)
fun exprToString (VAR s) = String.concat ["VAR ", strToString s]
  | exprToString (INT n) = String.concat ["INT ", Int.toString n]
  | exprToString (ADD (e1, e2)) = String.concat [ "ADD ("
                                                , exprToString e1
                                                , ", "
                                                , exprToString e2
                                                , ")"
                                                ]
  | exprToString (IF_GREATER (e1, e2, e3, e4)) = String.concat [ "IF_GREATER ("
                                                               , exprToString e1
                                                               , ", "
                                                               , exprToString e2
                                                               , ", "
                                                               , exprToString e3
                                                               , ", "
                                                               , exprToString e4
                                                               , ")"
                                                               ]
  | exprToString (FUN ((s1, s2), e)) = String.concat [ "FUN (("
                                                     , strToString s1
                                                     , ", "
                                                     , strToString s2
                                                     , "), "
                                                     , exprToString e
                                                     , ")"
                                                     ]
  | exprToString (CALL (e1, e2)) = String.concat [ "CALL ("
                                                  , exprToString e1
                                                  , ", "
                                                  , exprToString e2
                                                  , ")"
                                                  ]
  | exprToString (LET ((s, e1), e2)) = String.concat [ "LET (("
                                                      , strToString s
                                                      , ", "
                                                      , exprToString e1
                                                      , "), "
                                                      , exprToString e2
                                                      , ")"]
  | exprToString (PAIR (e1, e2)) = String.concat [ "PAIR ("
                                                , exprToString e1
                                                , ", "
                                                , exprToString e2
                                                , ")"
                                                ]
  | exprToString (HEAD e) = String.concat ["HEAD (", exprToString e, ")"]
  | exprToString (TAIL e) = String.concat ["TAIL (", exprToString e, ")"]
  | exprToString (NULL) = "NULL"
  | exprToString (IS_NULL e) = String.concat ["IS_NULL (", exprToString e, ")"]
  | exprToString (CLOSURE (env, f)) = 
      String.concat [ "CLOSURE (["
                    , String.concatWith ", " (map pairToString env)
                    ,"], "
                    , exprToString f
                    , ")"]
and pairToString (var, expr) = String.concat [ "("
                                             , strToString var
                                             , ", "
                                             , exprToString expr
                                             , ")"
                                             ]
(******************************************************************************)

(****************************************************************************** 
  Функция valOfInt
 ******************************************************************************)
fun valOfInt (INT n) = n
  | valOfInt e = 
      ( print ("The expression " ^ exprToString e ^ " is not a number.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 2 funName
 ******************************************************************************)
fun funName (FUN ((s1, _), _)) = s1
  | funName e = 
      ( print ("The expression " ^ exprToString e ^ " is not a function.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 3 funArg
 ******************************************************************************)
fun funArg (FUN ((_, s2), _)) = s2
  | funArg e = 
      ( print ("The expression " ^ exprToString e ^ " is not a function.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 4 funBody
 ******************************************************************************)
fun funBody (FUN ((_, _), f)) = f
  | funBody e = 
      ( print ("The expression " ^ exprToString e ^ " is not a function.\n"); 
        raise Expr )

(******************************************************************************)

(****************************************************************************** 
  Задание 5 pairHead
 ******************************************************************************)
fun pairHead (PAIR (e1, _)) = e1
  | pairHead e = 
      ( print ("The expression " ^ exprToString e ^ " is not a pair.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 6 pairTail
 ******************************************************************************)
fun pairTail (PAIR (_, e2)) = e2
  | pairTail e = 
      ( print ("The expression " ^ exprToString e ^ " is not a pair.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 7 closureFun
 ******************************************************************************)
fun closureFun (CLOSURE (_, f)) = f
  | closureFun e = 
      ( print ("The expression " ^ exprToString e ^ " is not a closure.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 8 closureEnv
 ******************************************************************************)
fun closureEnv (CLOSURE (env, _)) = env
  | closureEnv e = 
      ( print ("The expression " ^ exprToString e ^ " is not a closure.\n"); 
        raise Expr )
(******************************************************************************)

(****************************************************************************** 
  Задание 9 envLookUp
 ******************************************************************************)
fun envLookUp ((st, ex) :: xs, str) =
      if st = str then ex
      else envLookUp (xs, str)
  | envLookUp (_, str) = 
     (print ("Unbound variable " ^ strToString str ^ ".\n" ); raise Expr)
(******************************************************************************)

(****************************************************************************** 
  Задание 10 evalUnderEnv
 ******************************************************************************)
fun evalUnderEnv (VAR name) env = envLookUp (env, name)
  | evalUnderEnv (INT n) env = INT n
  | evalUnderEnv NULL env = NULL
  | evalUnderEnv (ADD (e1, e2)) env = INT ( valOfInt (evalUnderEnv e1 env)
                                          + valOfInt (evalUnderEnv e2 env)
                                          )
  | evalUnderEnv (IF_GREATER (e1, e2, e3, e4)) env =
      if valOfInt (evalUnderEnv e1 env) > valOfInt (evalUnderEnv e2 env)
      then evalUnderEnv e3 env
      else evalUnderEnv e4 env
  | evalUnderEnv (PAIR (e1, e2)) env = 
      PAIR (evalUnderEnv e1 env, evalUnderEnv e2 env)
  | evalUnderEnv (HEAD e) env = pairHead (evalUnderEnv e env)
  | evalUnderEnv (TAIL e) env = pairTail (evalUnderEnv e env)
  | evalUnderEnv (IS_NULL e) env = 
     if evalUnderEnv e env = NULL then INT 1 else INT 0
  | evalUnderEnv (LET ((str , e1), e2)) env = 
      evalUnderEnv e2 ((str, evalUnderEnv e1 env) :: env)
  | evalUnderEnv (FUN ((name, arg), e1)) env = 
      CLOSURE (env, FUN ((name, arg), e1))
  | evalUnderEnv (CLOSURE (envs, f)) env = CLOSURE (envs, f)
  | evalUnderEnv (CALL (e1, e2)) env = 
      let
        val v1 = evalUnderEnv e1 env
        val t = closureFun v1
      in
        evalUnderEnv (funBody t) ( (funArg t, evalUnderEnv e2 env)
                                    :: (funName t, v1)
                                    :: closureEnv v1 )
      end
(******************************************************************************)

(****************************************************************************** 
  Функция evalExp
 ******************************************************************************)
fun evalExp expr = evalUnderEnv expr []
(******************************************************************************)

(****************************************************************************** 
  Задание 11 ifNull
 ******************************************************************************)
fun ifNull (e1, e2, e3) = IF_GREATER ((IS_NULL e1), INT 0, e2, e3)
(******************************************************************************)

(****************************************************************************** 
  Задание 12 mLet
 ******************************************************************************)
fun mLet (head :: tail) e = LET (head, mLet tail e)
  | mLet [] e = e
(******************************************************************************)

(****************************************************************************** 
  Задание 13 ifEq
 ******************************************************************************)
fun ifEq (e1, e2, e3, e4) = 
  LET ( ("_x", e1)
      , LET ( ("_y", e2)
            , IF_GREATER ( VAR "_x"
                         , VAR "_y"
                         , e4
                         , IF_GREATER (VAR "_y", VAR "_x", e4, e3) ) ) )
(*****************************************************************************)

(****************************************************************************** 
  Задание 14 convertListToMUPL
 ******************************************************************************)
fun convertListToMUPL (head :: tail) = PAIR (head, convertListToMUPL tail)
  | convertListToMUPL [] = NULL
(******************************************************************************)

(****************************************************************************** 
  Задание 15 convertListFromMUPL
 ******************************************************************************)
fun convertListFromMUPL (PAIR (e1, e2)) = e1 :: convertListFromMUPL e2
  | convertListFromMUPL NULL = []
(******************************************************************************)

(****************************************************************************** 
  Задание 16 mMap
 ******************************************************************************)
val mMap = FUN ( ("mMap", "fun")
               , FUN ( ("", "l")
                     , ifNull ( VAR "l", NULL
                              , PAIR ( CALL ( VAR "fun"
                                            , HEAD (VAR "l") )
                                     , CALL ( CALL ( VAR "mMap"
                                                   , VAR "fun" )
                                            , TAIL (VAR "l") ) ) ) ) )
(******************************************************************************)

(****************************************************************************** 
  Задание 17 mMapAddN
 ******************************************************************************)
fun mMapAddN n = 
  FUN ( ("", "l")
      , LET ( ("n", n)
            , CALL ( CALL (mMap, FUN (("add", "x"), ADD (VAR "x", VAR "n")))
                   , VAR "l" ) ) )
(******************************************************************************)

(****************************************************************************** 
  Задание 18 multAnyXPosY
 ******************************************************************************)
val multAnyXPosY = 
  FUN ( ("multAny", "x")
      , FUN ( ("count", "y")
            , IF_GREATER ( VAR "y"
                         , INT 0
                         , ADD ( VAR "x"
                               , CALL (VAR "count", ADD (VAR "y", INT ~1)))
                         , INT 0) ) )
(******************************************************************************)

(****************************************************************************** 
  Задание 19 fact
 ******************************************************************************)
val fact = 
  FUN ( ("factor", "x")
            , IF_GREATER ( VAR "x"
                         , INT 0
                         , CALL ( CALL (multAnyXPosY, VAR "x")
                                , CALL (VAR "factor", ADD (VAR "x", INT ~1)))
                         , INT 1) )
(******************************************************************************)

(****************************************************************************** 
  Задание 20 delDuplicates
 ******************************************************************************)

(******************************************************************************)

