(****************************************************************************** 
  Шаблон для выполнения заданий лабораторной работы №1
 ******************************************************************************)

(****************************************************************************** 
  Загрузка файла с лабораторной работой 
 ******************************************************************************)
use "lab-2.sml";
(****************************************************************************** 
  ТЕСТЫ К РЕШЕНИЯМ
  Здесь приведены по большей части тривиальные тесты. Их успешное выполнение 
  не гарантирует того, что Ваше решение функционирует правильно.
 ******************************************************************************)

(****************************************************************************** 
  Задание 1 exprToString и pairToString
 ******************************************************************************)
val test1_exprToString = exprToString (VAR "n") = "VAR \"n\""
val test2_exprToString = 
  exprToString (CLOSURE ([("a", INT 6), ("b", INT 9)], INT 7)) 
  = "CLOSURE ([(\"a\", INT 6), (\"b\", INT 9)], INT 7)"
val test3_exprToString = 
  exprToString (PAIR (HEAD NULL, TAIL NULL)) 
  = "PAIR (HEAD (NULL), TAIL (NULL))"
val test4_exprToString = exprToString (INT 5) = "INT 5"
val test5_exprToString = exprToString (ADD (VAR "x", INT 5))
   = "ADD (VAR \"x\", INT 5)"
val test6_exprToString = exprToString (FUN ( ("", "x")
                                           , ADD (VAR "x", INT 5)
                                           ) )
  = "FUN ((\"\", \"x\"), ADD (VAR \"x\", INT 5))" 
val test7_exprToString = exprToString ( CALL ( FUN ( ("", "x")
                                                   , ADD (VAR "x", INT 5) )
                                             , INT 3 ))
  = "CALL (FUN ((\"\", \"x\"), ADD (VAR \"x\", INT 5)), INT 3)"
val test8_exprToString =
  exprToString ( LET ( ( "f"
                     , FUN ( ("", "x")
                           , ADD (VAR "x", INT 5) )
                       )
                     , CALL (VAR "f", INT 3)
                     ) ) 
  = "LET ((\"f\", FUN ((\"\", \"x\"), ADD (VAR \"x\", INT 5))), CALL (VAR \"f\", INT 3))"
val test9_exprToString = exprToString ( IF_GREATER ( INT 5
                                                   , INT 3
                                                   , INT 8
                                                   , VAR "a" ) )
  = "IF_GREATER (INT 5, INT 3, INT 8, VAR \"a\")" 
(******************************************************************************)
val test1_pairToString = pairToString ("a", INT 6) = "(\"a\", INT 6)"
val test2_pairToString = 
  pairToString ("a", HEAD (PAIR (INT 6, INT 5))) 
    = "(\"a\", HEAD (PAIR (INT 6, INT 5)))"
(******************************************************************************)

(****************************************************************************** 
  Задание 2 funName
 ******************************************************************************)
val test1_funName = funName (FUN (("", "a"), NULL)) = ""
val test2_funName = ( funName NULL = "QWA"
                        handle Expr => true
                             | _    => false )
val test3_funName = ( funName (ADD (VAR "a", VAR "a")) = "QWA"
                        handle Expr => true
                             | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 3 funArg
 ******************************************************************************)
val test1_funArg = funArg (FUN (("", "a"), NULL)) = "a"
val test2_funArg = ( funArg NULL = "QWA"
                        handle Expr => true
                             | _    => false )
val test3_funArg = ( funArg (ADD (VAR "a", VAR "a")) = "QWA"
                        handle Expr => true
                             | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 4 funBody
 ******************************************************************************)
val test1_funBody = funBody (FUN (("", "a"), NULL)) = NULL
val test2_funBody = ( funBody NULL = NULL
                        handle Expr => true
                             | _    => false )
val test3_funBody = ( funBody (ADD (VAR "a", VAR "a")) = INT 4
                        handle Expr => true
                             | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 5 pairHead
 ******************************************************************************)
val test1_pairHead = pairHead (PAIR (VAR "a", NULL)) = VAR "a"
val test2_pairHead = ( pairHead NULL = NULL
                        handle Expr => true
                             | _    => false )
val test3_pairHead = ( pairHead (ADD (VAR "a", (VAR "a"))) = NULL
                        handle Expr => true
                             | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 6 pairTail
 ******************************************************************************)
val test1_pairTail = pairTail (PAIR (VAR "a", NULL)) = NULL
val test2_pairTail = ( pairTail NULL = NULL
                          handle Expr => true
                               | _    => false )
val test3_pairTail = ( pairTail (ADD (VAR "a", VAR "a")) = NULL
                          handle Expr => true
                               | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 7 closureFun
 ******************************************************************************)
val test1_closureFun = closureFun (CLOSURE ([], FUN (("", "a"), NULL))) 
                        = FUN (("", "a"), NULL)
val test2_closureFun = ( closureFun NULL = NULL 
                            handle Expr => true
                                 | _    => false )
val test3_closureFun = ( closureFun (ADD (VAR "a", VAR "a")) = NULL 
                            handle Expr => true
                                 | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 8 closureEnv
 ******************************************************************************)
val test1_closureEnv = closureEnv (CLOSURE ([], FUN (("", "a"), NULL))) = []
val test2_closureEnv = ( closureEnv NULL = [("a", INT 5)]
                            handle Expr => true
                                 | _    => false )
val test3_closureEnv = ( closureEnv (ADD (VAR "a", VAR "a")) = []
                            handle Expr => true
                                 | _    => false )
(******************************************************************************)

(****************************************************************************** 
  Задание 9 envLookUp
 ******************************************************************************)
val test1_envLookUp = envLookUp ([("a", INT 6), ("b", INT 10)], "b") = INT 10
val test2_envLookUp = ( envLookUp ([("a", INT 6), ("b", INT 10)], "c") = INT 10
                            handle Expr => true
                                 | _    => false )
val test3_envLookUp = ( envLookUp ([], "b") = INT 10
                            handle Expr => true
                                 | _    => false )
val test4_envLookUp = envLookUp ([("b", INT 6), ("b", INT 10)], "b") = INT 6
(******************************************************************************)

(****************************************************************************** 
  Задание 10 evalUnderEnv
 ******************************************************************************)
(* Дефолтные *)
val test1_evalUnderEnv = evalUnderEnv (VAR "a") [("a", INT 5)] = INT 5
val test2_evalUnderEnv = evalUnderEnv (INT 5) [] = INT 5
val test3_evalUnderEnv = evalUnderEnv NULL [] = NULL
(* Из методички *)
val test4_evalUnderEnv = evalUnderEnv (IF_GREATER (INT 4, INT 2, VAR "a", VAR "l")) [("a", INT 6), ("l", NULL)] = INT 6
val test5_evalUnderEnv = evalUnderEnv (PAIR (VAR "a", VAR "l")) [("a", INT 6), ("l", NULL)] = PAIR (INT 6, NULL)
val test6_evalUnderEnv = evalUnderEnv (ADD (INT 4, VAR "a")) [("a", INT 6), ("l", NULL)] = INT 10
val test7_evalUnderEnv = evalUnderEnv (TAIL (PAIR (VAR "a", VAR "l"))) [("a", INT 6), ("l", NULL)] = NULL
val test8_evalUnderEnv = evalUnderEnv (HEAD (PAIR (VAR "a", VAR "l"))) [("a", INT 6), ("l", NULL)] = INT 6
val test9_evalUnderEnv = evalUnderEnv (IS_NULL (TAIL (PAIR (VAR "a", VAR "l")))) [("a", INT 6), ("l", NULL)] = INT 1
val test10_evalUnderEnv = evalUnderEnv (LET (("a", INT 7), ADD (VAR "b", VAR "a"))) [("a", INT 6), ("b", INT 10)] = INT 17
val test11_evalUnderEnv = evalUnderEnv (FUN (("", "x"), ADD (VAR "a", VAR "x"))) [("a", INT 6), ("b", INT 10)] = CLOSURE ([("a", INT 6), ("b", INT 10)], FUN (("", "x"), ADD (VAR "a", VAR "x")))
val test12_evalUnderEnv = evalUnderEnv (CALL (VAR "f", VAR "x")) [("x", INT 4), ("a", INT 8), ("f", CLOSURE ([("a", INT 6), ("x", INT 10)], FUN (("", "x"), ADD (VAR "a", VAR "x"))))] = INT 10
(* Юнит *)
val test13_evalUnderEnv = 
  evalUnderEnv (CLOSURE ([("a", INT 6), ("x", INT 10)], NULL)) []
    = CLOSURE ([("a", INT 6), ("x", INT 10)], NULL)
val test14_evalUnderEnv = 
  evalUnderEnv (ADD (ADD (INT 1, INT 2), ADD (INT 1, INT 3))) [] 
    = INT 7
val test15_evalUnderEnv =
  evalUnderEnv (PAIR (ADD (INT 1, INT 2), ADD (INT 1, INT 3))) [] 
    = PAIR (INT 3, INT 4)
val test16_evalUnderEnv =
  evalUnderEnv (HEAD (PAIR (ADD (INT 1, INT 2), ADD (INT 1, INT 3)))) []
    = INT 3
val test17_evalUnderEnv =
  evalUnderEnv (TAIL (PAIR (ADD (INT 1, INT 2), ADD (INT 1, INT 3)))) []
    = INT 4
val test18_evalUnderEnv =
  evalUnderEnv (IS_NULL (HEAD (PAIR (NULL, INT 3)))) [] 
    = INT 1
val test19_evalUnderEnv = 
  evalUnderEnv (LET (("x", INT 3), ADD (VAR "x", INT 3))) [] 
    = INT 6
(******************************************************************************)


(****************************************************************************** 
  Задание 11 ifNull
 ******************************************************************************)
val test1_ifNull = evalExp (ifNull (NULL, INT 5, INT 6)) 
  = INT 5
val test2_ifNull = evalExp (ifNull (INT 5, INT 6, NULL)) 
  = NULL
val test3_ifNull = evalExp (ifNull (HEAD (PAIR (NULL, INT 3)), INT 6, INT 5))
  = INT 6
(******************************************************************************)

(****************************************************************************** 
  Задание 12 mLet
 ******************************************************************************)
val test1_mLet = 
  mLet [ ("a", INT 5)
       , ("b", INT 6)
       , ("c", NULL)
       , ("d", PAIR (NULL, NULL))
       ]
       (IF_GREATER (VAR "a", VAR "b", VAR "d", VAR "c"))
  = LET 
      ( ("a", INT 5)
      , LET 
          ( ("b", INT 6)
          , LET 
              ( ("c", NULL)
              , LET 
                  ( ("d", PAIR (NULL, NULL)) 
                  , IF_GREATER ( VAR "a"
                               , VAR "b"
                               , VAR "d"
                               , VAR "c" ) ) ) ) )
val test2_mLet =
  mLet [] (HEAD (PAIR (INT 1, INT 2))) = HEAD (PAIR (INT 1, INT 2))
(******************************************************************************)

(****************************************************************************** 
  Задание 13 ifEq
 ******************************************************************************)
val test1_ifEq = 
  evalExp (ifEq (INT 5, INT 6, NULL, PAIR (NULL, NULL)))
    = PAIR (NULL, NULL)
val test2_ifEq =
  evalExp (ifEq (ADD (INT 1, INT 3), INT 4, ADD (INT 10, INT 1), INT 100))
    = INT 11
(******************************************************************************)

(****************************************************************************** 
  Задание 14 convertListToMUPL
 ******************************************************************************)
val test1_convertListToMUPL = convertListToMUPL [] = NULL
val test2_convertListToMUPL = convertListToMUPL [NULL] = PAIR (NULL, NULL)
val test3_convertListToMUPL = convertListToMUPL [VAR "a"] = PAIR (VAR "a", NULL)
val test4_convertListToMUPL = convertListToMUPL [VAR "a", VAR "b", VAR "c"]
  = PAIR (VAR "a", PAIR (VAR "b", PAIR (VAR "c", NULL)))
(******************************************************************************)

(****************************************************************************** 
  Задание 15 convertListFromMUPL
 ******************************************************************************)
val test1_convertListFromMUPL = convertListFromMUPL NULL = []
val test2_convertListFromMUPL = convertListFromMUPL (PAIR (NULL, NULL)) = [NULL]
val test3_convertListFromMUPL = 
  convertListFromMUPL (PAIR (VAR "a", NULL)) = [(VAR "a")]
(******************************************************************************)

(****************************************************************************** 
  Задание 16 mMap
 ******************************************************************************)
val test1_mMap = 
  evalExp 
    ( CALL 
        ( CALL ( mMap 
               , FUN ( ("", "x") 
                     , ADD (VAR "x", INT 5) ) ) 
        , PAIR (INT 1, PAIR (INT 2, PAIR (INT 3, NULL))) ) )
  = PAIR (INT 6, PAIR (INT 7, PAIR (INT 8, NULL)))
(******************************************************************************)

(****************************************************************************** 
  Задание 17 mMapAddN
 ******************************************************************************)
val test1_mMapAddN = 
  evalExp 
    ( CALL ( mMapAddN (INT 5)
           , PAIR (INT 1, PAIR (INT 2, PAIR (INT 3, NULL))) ) )
  = PAIR (INT 6, PAIR (INT 7, PAIR (INT 8, NULL)))
val test2_mMapAddN = 
  evalExp 
    ( LET ( ("x", INT 7)
          , CALL ( mMapAddN (VAR "x")
                 , PAIR (INT 1, PAIR (INT 2, PAIR (INT 3, NULL))) ) ) )
  = PAIR (INT 8, PAIR (INT 9, PAIR (INT 10, NULL)))
(******************************************************************************)

(****************************************************************************** 
  Задание 18 multAnyXPosY
 ******************************************************************************)
val test1_multAnyXPosY =
  evalExp (CALL (CALL (multAnyXPosY, INT ~5), INT 3)) = INT ~15
val test2_multAnyXPosY =
  evalExp (CALL (CALL (multAnyXPosY, INT 1), INT 0)) = INT 0
val test3_multAnyXPosy =
  evalExp (LET (("x", INT 3), CALL (CALL (multAnyXPosY, VAR "x"), INT 5))) 
    = INT 15
(******************************************************************************)

(****************************************************************************** 
  Задание 19 fact
 ******************************************************************************)
val test1_fact = evalExp (CALL (fact, INT 5)) = INT 120
val test2_fact = evalExp (CALL (fact, INT 1)) = INT 1
val test3_fact = evalExp (CALL (fact, INT 12)) = INT 479001600
val test4_fact = evalExp (CALL (fact, INT 0)) = INT 1 
(******************************************************************************)

(****************************************************************************** 
  Задание 20 delDuplicates
 ******************************************************************************)
val test1_delDuplicates = evalExp (CALL (delDuplicates, NULL)) = NULL
val test2_delDuplicates = 
  evalExp 
    ( CALL 
        ( delDuplicates
        , PAIR (INT 1, (PAIR (INT 1, PAIR (INT 1, NULL)))) ) ) 
  = PAIR (INT 1, NULL)
val test3_delDuplicates =
    evalExp 
    ( CALL 
        ( delDuplicates
        , PAIR ( INT 1
               , ( PAIR ( INT 2
                        , PAIR ( INT 2
                               , PAIR ( INT 1
                                      , PAIR ( INT 1
                                             , PAIR ( INT 7
                                                    , PAIR ( INT 7
                                                           , PAIR (INT 8, NULL) 
                                                           )
                                                                               
                                                    )
                                                                               
                                             )
                                                                               
                                      )
                               )
                        )
                   )
               )
        )
    ) 
  = PAIR (INT 1, PAIR (INT 2, PAIR (INT 1, PAIR (INT 7, PAIR (INT 8, NULL)))))
val test4_delDuplicates =
    evalExp 
    ( CALL 
        ( delDuplicates
        , PAIR ( INT 1
               , ( PAIR ( INT 2
                        , PAIR ( INT 2
                               , PAIR ( INT 1
                                      , PAIR ( INT 1
                                             , PAIR ( INT 7
                                                    , PAIR ( INT 7
                                                           , PAIR (INT 7, NULL) 
                                                           )
                                                                               
                                                    )
                                                                               
                                             )
                                                                               
                                      )
                               )
                        )
                   )
               )
        )
    ) 
  = PAIR (INT 1, PAIR (INT 2, PAIR (INT 1, PAIR (INT 7, NULL))))
(******************************************************************************)
