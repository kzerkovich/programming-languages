(****************************************************************************** 
  Шаблон для выполнения заданий лабораторной работы №1
 ******************************************************************************)

(****************************************************************************** 
  Загрузка файла с лабораторной работой 
 ******************************************************************************)
use "lab-1.sml";

(****************************************************************************** 
  Вспомогательные функции
 ******************************************************************************)
(* Удаляет элемент c из списка cs *)
fun rem (cs, c) = 
  if null cs then raise List.Empty 
  else let val head = hd cs
       in if head = c then tl cs
          else head :: rem (tl cs, c)
       end

(* Проверяет, что списки l1 и l2 состоят из одних и тех же элементов *)
fun sameList (l1, l2) =
  if null l1 then 
    if null l2 then true
    else false
  else (sameList (tl l1, rem (l2, hd l1)) handle List.Empty => false)

(****************************************************************************** 
  ТЕСТЫ К РЕШЕНИЯМ
  Здесь приведены по большей части тривиальные тесты. Их успешное выполнение 
  не гарантирует того, что Ваше решение функционирует правильно.
 ******************************************************************************)
(****************************************************************************** 
  Задание 1 isLeapYear
 ******************************************************************************) 
val test1_IsLeapYear1 = isLeapYear (2000, false) = true 
val test1_IsLeapYear2 = isLeapYear (2015, false) = false
val test1_IsLeapYear3 = isLeapYear (2016, true) = true
val test1_IsLeapYear4 = isLeapYear (2020, true) = true
(* Григорианский календарь, год кратный 400 *)
val test1_IsLeapYear11 = isLeapYear (2000, false) = true 
(* Григорианский календарь, год некратный 400, некратный 100 и некратный 4 *)
val test1_IsLeapYear21 = isLeapYear (2015, false) = false
(* Юлианский календарь, год кратный 4 *)
val test1_IsLeapYear31 = isLeapYear (2016, true) = true
(* Григорианский календарь, год кратный 4 *)
val test1_IsLeapYear41 = isLeapYear (4, false) = true
(* Юлианский календарь, год не кратный 4 *)
val test_IsLeapYear51 = isLeapYear (2013, true) = false
(* Григорианский календарь, год некратный 400, кратный 100 *)
val test_IsLeapYear61 = isLeapYear (1900, false) = false
(******************************************************************************)

(****************************************************************************** 
  Задание 2 isLongMonth
 ******************************************************************************)
val test2_IsLongMonth1 = isLongMonth 12 = true 
val test2_IsLongMonth2 = isLongMonth 2 = false
val test2_IsLongMonth3 = isLongMonth 8 = true
(******************************************************************************)

(****************************************************************************** 
  Задание 3 daysInMonth
 ******************************************************************************)
val test3_DaysInMonth1 = daysInMonth ((1,9,2020), false) = 30 
val test3_DaysInMonth2 = daysInMonth ((1,1,1900), true) = 31 
val test3_DaysInMonth3 = daysInMonth ((1,2,2020), false) = 29 
val test3_DaysInMonth4 = daysInMonth ((1,2, 2800), false) = 29
val test3_DaysInMonth5 = daysInMonth ((1,2, 2400), true) = 29

(* Григорианский календарь, сентябрь - 30 дней *)
val test3_DaysInMonth11 = daysInMonth ((1,9,2020), false) = 30 
(* Юлианский календарь, январь - 31 день *)
val test3_DaysInMonth21 = daysInMonth ((1,1,1900), true) = 31
(* Григорианский календарь, февраль високосного по кратности на 4 года *)
val test3_DaysInMonth31 = daysInMonth ((1,2,2020), false) = 29 
(* Григорианский календарь, февраль високосного по кратности 400 года *)
val test3_DaysInMonth41 = daysInMonth ((1,2,2000), false) = 29 
(* Григорианский календарь, февраль невисокосного по некратности на 4 года *)
val test3_DaysInMonth51 = daysInMonth ((1,2,1999), false) = 28
(* Григорианский календарь, февраль невисокосного по кратности на 100 года *)
val test3_DaysInMonth61 = daysInMonth ((1,2,1900), false) = 28
(* Юлианский календарь, февраль невисокосного года  *)
val test3_DaysInMonth71 = daysInMonth ((1,2,2021), true) = 28
(* Юлианский календарь, ферваль високосного года *)
val test3_DaysInMonth81 = daysInMonth ((1,2,2020), true) = 29
(* Юлианский календарь, февраль високосного года *)
val test3_DaysInMonth91 = daysInMonth ((29,2,2004), true) = 29
(**********************************************************************)

(****************************************************************************** 
  Задание 4 isDayOK
 ******************************************************************************)
val test4_IsDayOK1 = isDayOK ((1,9,2020), false) = true
val test4_IsDayOK2 = isDayOK ((31,6,2020), true) = false
val test4_IsDayOK3 = isDayOK ((50,4,1534), true) = false
(*****************************************************************************)

(****************************************************************************** 
  Задание 5 isMonthOK
 ******************************************************************************)
val test5_IsMonthOK1 = isMonthOK (1,9,2020) = true
val test5_IsMonthOK2 = isMonthOK (31,6,2020) = true
val test5_IsMonthOK3 = isMonthOK (1,13,2020) = false
(*****************************************************************************)

(****************************************************************************** 
  Задание 6 isCorrectDate
 ******************************************************************************)
val test6_IsCorrectDate1 = isCorrectDate ((1,9,2016), true) = true
val test6_IsCorrectDate2 = isCorrectDate ((21,13,1900), false) = false
val test6_IsCorrectDate3 = isCorrectDate ((~12,3,1857), false) = false

(* Корректная дата *)
val test6_IsCorrectDate11 = isCorrectDate ((1,9,2016), true) = true
(* Некорректная по месяцу дата *)
val test6_IsCorrectDate21 = isCorrectDate ((21,13,1900), false) = false
(* Некорректная по отрицательному номеру дня дата *)
val test6_IsCorrectDate31 = isCorrectDate ((~12,3,1857), false) = false
(* Некорректная по високосности на 4 в фев по Григорианскому календарю дата *)
val test6_IsCorrectDate41 = isCorrectDate ((29,2,1953), false) = false
(* Некорректная по високосности на 4 в фев по Юлианскому календарю дата *)
val test6_IsCorrectDate51 = isCorrectDate ((29,2,1953), true) = false
(* Некорректная по високосности в фев на 100 по Григорианскому календарю дата *)
val test6_IsCorrectDate61 = isCorrectDate ((29,2,1900), false) = false
(* Корректная по високосности в фев на 400 по Григорианскому календарю дата *)
val test6_IsCorrectDate71 = isCorrectDate ((29,2,2000), false) = true
(* Корректная по високосности в фев на 4 по Григорианскому календарю дата *)
val test6_IsCorrectDate81 = isCorrectDate ((29,2,2004), false) = true
(* Корректная по високосности в фев на 4 по Юлианскому календарю дата *)
val test6_IsCorrectDate91 = isCorrectDate ((29,2,2004), true) = true
(* Некорректная по номеру года дата *)
val test6_IsCorrectDate101 = isCorrectDate((29, 2, ~3), true) = false
(*****************************************************************************)

(****************************************************************************** 
  Задание 7 incDateByNum
 ******************************************************************************)
val test7_IncDateByNum1 = incDateByNum ((1,1,2020), 3, true) = (4,1,2020)
val test7_IncDateByNum2 = incDateByNum ((28,2,2004), 3, false) = (2,3,2004)
val test7_IncDateByNum3 = incDateByNum ((31,12,2020), 1, false) = (1,1,2021)
val test7_IncDateByNum4 = incDateByNum ((1,10,2007), 1000, true) = (27,6,2010)
val test7_IncDateByNum5 = incDateByNum ((1,10,2007), 10000, false) = (16,2,2035)
val test7_IncDateByNum6 = incDateByNum ((1,10,2007), 100000, false) = (16,7,2281)
val test7_IncDateByNum9 = incDateByNum ((1,10,2007), 100000, true) = (14,7,2281)
val test7_IncDateByNum7 = incDateByNum ((1,10,2007), 1000000, false) = (28,8,4745)
val test7_IncDateByNum8 = incDateByNum ((1,10,2007), 1000000, true) = (7,8,4745)

(* Тривиальное увеличение *)
val test7_IncDateByNum11 = incDateByNum ((1,1,2020), 3, true) = (4,1,2020)
(* Переход в високосном феврале на новый месяц *)
val test7_IncDateByNum21 = incDateByNum ((28,2,2004), 3, false) = (2,3,2004)
(* Переход на новый год *)
val test7_IncDateByNum31 = incDateByNum ((31,12,2020), 1, false) = (1,1,2021)
(* Переход в невисокосном феврале на новый месяц *)
val test7_IncDateByNum41 = incDateByNum ((28,2,2003), 2, false) = (2,3,2003)
(* Переход в невисокосном феврале через месяц и год *)
val test7_IncDateByNum51 = incDateByNum ((28,2,2021), 307, false) = (1,1,2022)
(* Переход в високосном феврале через месяц и год *)
val test8_IncDateByNum61 = incDateByNum ((28,2,2020), 308, false) = (1,1,2021)


(*
newStyleCorrection (1, 10, 2007) = a = 13
newStyleCorrection (28, 8, 4745) = b = 34
b - a = 21 дней разницы между Юлианской датой и Григорианской.
*)




(*****************************************************************************)

(************************************5****************************************** 
  Задание 8 decDateByNum
 ******************************************************************************)
val test8_DecDateByNum1 = decDateByNum ((4,1,2020), 3, true) = (1,1,2020)
val test8_DecDateByNum2 = decDateByNum ((2,3,2004), 3, false) = (28,2,2004)
val test8_DecDateByNum3 = decDateByNum ((1,1,2021), 1, false) = (31, 12, 2020)
val test8_DecDateByNum4 = decDateByNum ((31,12,2020), 397, false) = (30,11,2019)
val test8_DecDateByNum5 = decDateByNum ((4,10,2021), 100000, false) = (20,12,1747)
val test8_DecDateByNum6 = decDateByNum ((4,10,2021), 100000, true) = (22,12,1747)

(* Тривиальное уменьшение *)
val test8_DecDateByNum11 = decDateByNum ((4,1,2020), 3, true) = (1,1,2020)
(* Переход в високосном феврале на старый месяц *)
val test8_DecDateByNum21 = decDateByNum ((2,3,2004), 3, false) = (28,2,2004)
(* Переход на старый год *)
val test8_DecDateByNum31 = decDateByNum ((1,1,2021), 1, false) = (31,12,2020)
(* Переход в невисокосном феврале на старый месяц *)
val test8_DecDateByNum41 = decDateByNum ((2,3,2021), 3, false) = (27,2,2021)
(* Переход в невисокосном феврале через месяц и год *)
val test8_DecDateByNum51 = decDateByNum ((1,1,2022), 307, false) = (28,2,2021)
(* Переход в високосном феврале через месяц и год *)
val test8_DecDateByNum61 = decDateByNum ((1,1,2021), 308, false) = (28,2,2020)

(*****************************************************************************)

(****************************************************************************** 
  Задание 9 newStyleCorrection
 ******************************************************************************)
val test9_NewStyleCorrection1 = newStyleCorrection (1,3,2016) = 13
val test9_NewStyleCorrection2 = newStyleCorrection (28,2,1600) = 10
val test9_NewStyleCorrection7 = newStyleCorrection (1,3,1600) = 10
val test9_NewStyleCorrection3 = newStyleCorrection (1,1,2021) = 13
val test9_NewStyleCorrection4 = newStyleCorrection (1, 10, 2007) = 13
val test9_NewStyleCorrection5 = newStyleCorrection (28, 8, 4745) = 34
val test9_NewStyleCorrection6 = newStyleCorrection (1, 1, 400) = 1
val test9_NewStyleCorrection8 = newStyleCorrection (29, 1, 300) = 0

(* После февраля некратного 100 месяца *)
val test9_NewStyleCorrection11 = newStyleCorrection (1,3,2016) = 13
(* До февраля некратного 100 месяца *)
val test9_NewStyleCorrection21 = newStyleCorrection (28,2,2016) = 13
(* До февраля кратного 100 месяца *)
val test9_NewStyleCorrection31 = newStyleCorrection (28,2,1700) = 10
(* После февраля кратного 100 месяца *)
val test9_NewStyleCorrection41 = newStyleCorrection (1,3,1700) = 11


(*****************************************************************************)

(****************************************************************************** 
  Задание 10 toJulianDay
 ******************************************************************************)
val test10_ToJulianDay1 = toJulianDay (7,1,2016) = (25,12,2015)
val test10_ToJulianDay2 = toJulianDay (14,1,2021) = (1,1,2021)
val test10_ToJulianDay3 = toJulianDay (28,8,4745) = (25,7,4745)
val test10_ToJulianDay4 = toJulianDay (1, 3, 300) = (29, 2, 300)

(* Переход через год при конвертации *)
val test10_ToJulianDay11 = toJulianDay (7,1,2016) = (25,12,2015)
(* Тривиальное уменьшение *)
val test10_ToJulianDay21 = toJulianDay (14,1,2021) = (1,1,2021)
(* Переход через "граничный" февраль в кратном 100 году *)
val test10_ToJulianDay31 = toJulianDay (1,3,1700) = (19,2,1700)
(* Переход через "граничный" февраль в некратном 100 году *)
val test10_ToJulianDay41 = toJulianDay (1,3,1919) = (16,2,1919)
(* Рандомный тест (не совсем) *)
val test10_ToJulianDay51 = toJulianDay (1,1,1919) = (19,12,1918)
(* Переход через "граничный" февраль в кратном 400 году *)
val test10_ToJulianDay61 = toJulianDay (3,3,1600) = (22,2,1600)
val test10_ToJulianDay71 = toJulianDay (3,3,2000) = (19,2,2000)
(*****************************************************************************)

(****************************************************************************** 
  Задание 11 toGrigorianDay
 ******************************************************************************)
val test11_ToGrigorianDay1 = toGrigorianDay (25,12,2015) = (7,1,2016)
val test11_ToGrigorianDay2 = toGrigorianDay (1,1,2021) = (14,1,2021)
val test11_ToGrigorianDay3 = toGrigorianDay (29,2,300) = (1, 3, 300)

val test11_ToGrigorianDay11 = toGrigorianDay (25,12,2015) = (7,1,2016)
val test11_ToGrigorianDay21 = toGrigorianDay (1,1,2021) = (14,1,2021)
val test11_ToGrigorianDay31 = toGrigorianDay (19,2,1700) = (1,3,1700)
val test11_ToGrigorianDay41 = toGrigorianDay (16,2,1919) = (1,3,1919)
val test11_ToGrigorianDay51 = toGrigorianDay (19,12,1918) = (1,1,1919)
val test11_ToGrigorianDay61 = toGrigorianDay (22,2,1600) = (3,3,1600)
val test11_ToGrigorianDay71 = toGrigorianDay (19,2,2000) = (3,3,2000)
(*****************************************************************************)

(****************************************************************************** 
  Задание 12 younger
 ******************************************************************************)
val test12_Younger1 = younger ((2,3,4), (1,2,3)) = true
val test12_Younger2 = younger ((1,2,3), (2,3,4)) = false
val test12_Younger3 = younger ((1,2,3), (1,1,4)) = false
val test12_Younger4 = younger ((2,2,4), (3,2,4)) = false

(* Первая дата позже второй по году *)
val test12_Younger11 = younger ((2,3,4), (1,2,3)) = true
(* Вторая дата позже первой по году *)
val test12_Younger21 = younger ((2,3,3), (1,2,4)) = false
(* Первая дата позже второй по месяцу *)
val test12_Younger31 = younger ((2,3,4), (1,2,4)) = true
(* Вторая дата позже первой по месяцу *)
val test12_Younger41 = younger ((2,2,4), (1,3,4)) = false
(* Первая дата позже второй по дню *)
val test12_Younger51 = younger ((2,3,4), (1,3,4)) = true
(* Вторая дата позже первой по дню *)
val test12_Younger61 = younger ((1,3,4), (2,3,4)) = false
(* Даты равны *)
val test12_Younger71 = younger ((2,3,4), (2,3,4)) = false
(*****************************************************************************)

(****************************************************************************** 
  Задание 13 youngest
 ******************************************************************************)
val test13_Youngest1 = 
  youngest [ ("Ivan", (1,9,1980))
           , ("Svetlana", (1,9,2015))
           , ("Alex", (1,9,1955)) ] 
  = SOME ("Svetlana", (1,9,2015))


val test13_Youngest2 = 
  youngest [ ("Ivan", (1,9,1980))
           , ("Svetlana", (1,9,2015))
           , ("Alex", (1,9,2015))
           , ("Alex", (1,9,1955)) ] 
  = SOME ("Alex", (1,9,2015)) 

val test13_Youngest5 = 
youngest [ ("Ivan", (1,9,1980))
         , ("Svetlana", (1,9,2015))
         , ("Alex", (1,9,1955))
         , ("Nina", (7,8,2016))
         , ("Marina", (7,8,2016))
         , ("Larina", (1,9,1976)) ] 
  = SOME ("Marina", (7,8,2016))
(*****************************************************************************)

(****************************************************************************** 
  Задание 14 getNthFixed
 ******************************************************************************)
val test14_GetNthFixed1 = getNthFixed (3, [25, ~615, 834, ~38, 0]) = ~38
val test14_GetNthFixed2 = getNthFixed (0, [25, ~615, 834, ~38, 0]) = 25
val test14_GetNthFixed3 = getNthFixed (1, [25, ~615, 834, ~38, 0]) = ~615
val test14_GetNthFixed4 = getNthFixed (2, [25, ~615, 834, ~38, 0]) = 834
val test14_GetNthFixed5 = getNthFixed (4, [25, ~615, 834, ~38, 0]) = 0


(*****************************************************************************)

(****************************************************************************** 
  Задание 15 numToDigits
 ******************************************************************************)
val test15_numToDigits1 = numToDigits (25313, 4) = [3, 1, 3, 5]
val test15_numToDigits2 = numToDigits (111, 5) = [1, 1, 1, 0, 0]
val test15_numToDigits3 = numToDigits (123456789, 1) = [9]
val test15_numToDigits4 = numToDigits (123456789, 2) = [9, 8]
val test15_numToDigits5 = numToDigits (123456789, 3) = [9, 8, 7]
val test15_numToDigits6 = numToDigits (123456789, 4) = [9, 8, 7, 6]
val test15_numToDigits7 = numToDigits (123456789, 5) = [9, 8, 7, 6, 5]
val test15_numToDigits8 = numToDigits (123456789, 6) = [9, 8, 7, 6, 5, 4]
val test15_numToDigits9 = numToDigits (123456789, 7) = [9, 8, 7, 6, 5, 4, 3]
val test15_numToDigits10 = numToDigits (123456789, 8) = [9, 8, 7, 6, 5, 4, 3, 2]
val test15_numToDigits11 = numToDigits (123456789, 9) = [9, 8, 7, 6, 5, 4, 3, 2, 1]

(*****************************************************************************)

(****************************************************************************** 
  Задание 16 listElements
 ******************************************************************************)
val test16_listElements1 = 
  listElements ( [3,2,5,6]
               , [ [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 ]
               ) 
  = [4, 3, 6, 7]

  val test16_listElements2 = 
  listElements ( [0,0,0,0]
               , [ [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 ]
               ) 
  = [1, 1, 1, 1]

  val test16_listElements3 = 
  listElements ( [1,1,1,1]
               , [ [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 ]
               ) 
  = [2, 2, 2, 2]

  val test16_listElements4 = 
  listElements ( [6,5,2,3]
               , [ [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 , [1,2,3,4,5,6,7]
                 ]
               ) 
  = [7, 6, 3, 4]
(*****************************************************************************)

(****************************************************************************** 
  Задание 17 listSum
 ******************************************************************************)
val test17_listSum1 = listSum [3,2,5,6] = 16
val test17_listSum2 = listSum [1,2,3,4] = 10
val test17_listSum3 = listSum [4,3,10,2] = 19
val test17_listSum4 = listSum [0,0,0,0] = 0
val test17_listSum5 = listSum [] = 0


(*****************************************************************************)

(****************************************************************************** 
  Задание 18 maxSmaller
 ******************************************************************************)
val test18_MaxSmaller1 = maxSmaller ([25, 0, 3800, 834], 3654) = 834 
val test18_MaxSmaller2 = maxSmaller ([25, 0, 3800, 834], 834) = 25
val test18_MaxSmaller3 = maxSmaller ([25, 1, 3800, 834], 25) = 1 
val test18_MaxSmaller4 = maxSmaller ([25, 1, 3800, 834], 1) = 0 

(*****************************************************************************)

(****************************************************************************** 
  Задание 19 dateToCorrectionNums
 ******************************************************************************)
val test19_dateToCorrectionNums1 = 
  dateToCorrectionNums (20, 9, 2021) = [8,1,2,0,2,1]

val test19_dateToCorrectionNums2 = 
  dateToCorrectionNums (1, 2, 1111) = [1,1,1,1,1,3]

val test19_dateToCorrectionNums3 = 
  dateToCorrectionNums (1, 2, 1112) = [1,2,1,1,1,0]

val test19_dateToCorrectionNums4 =
  dateToCorrectionNums (1,1,928) = [0, 8, 2, 9, 0, 0]

(*****************************************************************************)

(****************************************************************************** 
  Задание 20 firstNewMoon
 ******************************************************************************)
val test20_FirstNewMoon1 = firstNewMoon (1,9,2016) = SOME (170823, (1,9,2016))
val test20_FirstNewMoon2 = firstNewMoon (1,1,928) = SOME (3016941, (30,1,928))
val test20_FirstNewMoon3 = firstNewMoon (1,8,2019) = SOME (3033882, (30,8,2019))
val test20_FirstNewMoon4 = firstNewMoon (1,12,200) = SOME (2350000, (23,12,200))
val test20_FirstNewMoon5 = firstNewMoon (1,12,3741) = SOME (2103882, (21,12,3741))
val test20_FirstNewMoon6 = firstNewMoon (1,2,1900) = NONE
val test20_FirstNewMoon13 = firstNewMoon (1, 1, 928) = SOME (3016941, (30,1,928))

val test20_FirstNewMoon11 = firstNewMoon (1,9,2016) = SOME (170823, (1,9,2016))
val test20_FirstNewMoon21 = firstNewMoon (1,9,2015) = SOME (1333882, (13,9,2015))
val test20_FirstNewMoon31 = firstNewMoon (4,3,2015) = SOME (2053882, (20,3,2015))
(* Куча первых новолуний *)
val test20_FirstNewMoon51 = firstNewMoon (1,1,2014) = SOME (140823, (1,1,2014))
val test20_FirstNewMoon71 = firstNewMoon (1,12,2005) = SOME (123882, (1,12,2005))
val test20_FirstNewMoon81 = firstNewMoon (1,8,2008) = SOME (153882, (1,8,2008))
val test20_FirstNewMoon91 = firstNewMoon (1,4,2003) = SOME (190823, (1,4,2003))
val test20_FirstNewMoon101 = firstNewMoon (1,5,2003) = SOME (130823, (1,5,2003))
val test20_FirstNewMoon111 = firstNewMoon (1,2,2003) = SOME (183882, (1,2,2003))
val test20_FirstNewMoon121 = firstNewMoon (1,7,2000) = SOME (163882, (1,7,2000))
val test20_FirstNewMoon141 = firstNewMoon (1,12,2020) = SOME (1503882, (15,12,2020))
(* Отсутствие новолуния в февралях *)
val test20_FirstNewMoon131 = firstNewMoon (1,2,1995) = NONE

val test20_FirstNewMoon100 = firstNewMoon (1,12,2021) = SOME (430823, (4,12,2021))

(******************************************************************************)

(****************************************************************************** 
  Задание 21 winterSolstice
 ******************************************************************************)
val test21_WinterSolstice1 = winterSolstice 0 = (22, 12, 0) 
val test21_WinterSolstice2 = winterSolstice 3 = (23, 12, 3)
val test21_WinterSolstice3 = winterSolstice 2014 = (22, 12, 2014)
val test21_WinterSolstice7 = winterSolstice 200 = (22,12,200)
val test21_WinterSolstice4 = winterSolstice 204 = (22,12,204)
val test21_WinterSolstice5 = winterSolstice 5834 = (21,12,5834)
val test21_WinterSolstice6 = winterSolstice 3741 = (21,12,3741)


(*val test21_WinterSolstice7 = (22,12,200) : date
val test21_WinterSolstice4 = (22,12,204) : date
val test21_WinterSolstice5 = (21,12,5834) : date
val test21_WinterSolstice6 = (21,12,3741) : date*)
(*****************************************************************************)

(****************************************************************************** 
  Задание 22 chineseNewYearDate
 ******************************************************************************)
val test22_ChineseNewYearDate1 = chineseNewYearDate 2021 = (12,2,2021)
val test22_ChineseNewYearDate2 = chineseNewYearDate 5835 = (26,1,5835)
val test22_ChineseNewYearDate3 = chineseNewYearDate 200 = (1,2,200)
val test22_ChineseNewYearDate4 = chineseNewYearDate 201 = (22,1,201)
val test22_ChineseNewYearDate5 = chineseNewYearDate 202 = (9,2,202)
val test22_ChineseNewYearDate6 = chineseNewYearDate 3742 = (18,2,3742)
val test22_ChineseNewYearDate8 = chineseNewYearDate 6310 = (28,1,6310)

(******************************************************************************)

(****************************************************************************** 
  Задание 23 getNthString
 ******************************************************************************)
val test23_GetNthString1 = 
  getNthString (2, ["hi", "there", "how", "are", "you"]) = "how"

val test23_GetNthString2 = 
  getNthString (1, ["hi", "there", "how", "are", "you"]) = "there"

val test23_GetNthString3 = 
  getNthString (3, ["hi", "there", "how", "are", "you"]) = "are"

(*****************************************************************************)

(****************************************************************************** 
  Задание 24 dateToString
 ******************************************************************************)
val test24_DateToString1  = dateToString (5,5,1980) = "May 5, 1980"
val test24_DateToString2  = dateToString (1,9,2016) = "September 1, 2016"

(*****************************************************************************)

(****************************************************************************** 
  Задание 25 chineseYear
 ******************************************************************************)
val test25_ChineseYear1 = 
  chineseYear 1980 = ("Geng-Shen","White","Monkey","Metal")
val test25_ChineseYear2 = 
  chineseYear 2021 = ("Xin-Chou","White","Cow","Wrought metal")
val test25_ChineseYear3 = chineseYear 200 = ("Geng-Chen", "White", "Dragon", "Metal")
val test25_ChineseYear4 = chineseYear 201 = ("Xin-Si", "White", "Snake", "Wrought metal")
val test25_ChineseYear5 = chineseYear 202 = ("Ren-Wu", "Black", "Horse", "Running water")

(*****************************************************************************)

(****************************************************************************** 
  Задание 26 dateToChineseYear
 ******************************************************************************)
val test26_DateToChineseYear1 = 
  dateToChineseYear (1,9,1980) = ("Geng-Shen","White","Monkey","Metal")
val test26_DateToChineseYear2 = 
  dateToChineseYear (1,9,2021) = ("Xin-Chou","White","Cow","Wrought metal")
val test26_DateToChineseYear3 =
  dateToChineseYear (22, 5, 239)
val test26_DateToChineseYear3 =
  dateToChineseYear (1, 1, 214) = ("Gui-Si", "Black", "Snake", "Standing water")

(*****************************************************************************)

(****************************************************************************** 
  Задание 27 dateToAnimal
 ******************************************************************************)
val test27_DateToAnimal1 = dateToAnimal (1,9,1980) = "Monkey"
val test27_DateToAnimal2 = dateToAnimal (1,9,2021) = "Cow"
val test27_DateToAnimal3 = dateToAnimal (22, 1, 201)= "Snake"
val test27_DateToAnimal5 = dateToAnimal (1, 1, 214)= "Snake"
(*****************************************************************************)

(****************************************************************************** 
  Задание 28 animal
 ******************************************************************************)
val test28_Animal1 = animal ("Ivan", (1,9,1980)) = "Monkey"
val test28_Animal2 = animal ("Svetlana", (1,9,2021)) = "Cow"
val test28_Animal3 = animal ("Svetlana", (22, 1, 201)) = "Snake"
val test28_Animal5 = animal ("Ivan", (1, 1, 214)) = "Snake"
(*****************************************************************************)

(****************************************************************************** 
  Задание 29 extractAnimal
 ******************************************************************************)
val test29_ExtractAnimal1 = 
  extractAnimal ( [ ("Ivan", (1,9,1980))
                  , ("Svetlana", (1,9,2015))
                  ]
                , "Monkey" ) 
  = [("Ivan", (1, 9, 1980))]
val test29_ExtractAnimal2 = 
  let val tmp = extractAnimal ( [ ("Ivan", (1,9,1980))
                                , ("Svetlana", (1,9,2015))
                                , ("Alex", (1,9,1955)) 
                                ]
                              , "Sheep" )
  in
    sameList (tmp, [("Alex", (1,9,1955)), ("Svetlana", (1,9,2015))])
  end 

val test29_ExtractAnimal3 = 
extractAnimal ([("Ivan", (31, 1, 211)), ("Svetlana", (1, 9, 2015))
  , ("Alex", (1, 9, 1996)), ("Anton", (31, 8, 1995))], "Rabbit") = [("Ivan",(31,1,211))]


(******************************************************************************)

(****************************************************************************** 
  Задание 30 extractAnimals
 ******************************************************************************)
val test30_ExtractAnimals1 = 
  extractAnimals ( [ ("Ivan", (1,9,1980))
                   , ("Svetlana", (1,9,2015)) 
                   ]
                 , ["Monkey"] ) 
  = [("Ivan", (1,9,1980))]
val test30_ExtractAnimals2 = 
  let val tmp = extractAnimals ( [ ("Ivan", (1,9,1980))
                                 , ("Svetlana", (1,9,2015)) 
                                 , ("Alex", (1,9,1955)) 
                                 ]
                               , ["Monkey", "Sheep"] )
  in
    sameList ( tmp
             , [ ("Svetlana", (1,9,2015))
               , ("Ivan", (1,9,1980))
               , ("Alex", (1,9,1955))
               ]
             )
  end


val test30_ExtractAnimals3 =
extractAnimals ([("Ivan", (31, 1, 211)), ("Svetlana", (1, 9, 2015))
                , ("Alex", (1, 9, 1996)), ("Anton", (31, 8, 1995))]
                , ["Rabbit"]) = [("Ivan",(31,1,211))]

(*****************************************************************************)

(****************************************************************************** 
  Задание 31 youngestFromAnimals
 ******************************************************************************)
val test31_YoungestFromAnimals1 = 
  youngestFromAnimals ( [ ("Ivan", (1,9,1980))
                        , ("Svetlana", (1,9,2015)) 
                        , ("Alex", (1,9,1955)) 
                        ]
                      , ["Monkey", "Sheep"] ) 
  = SOME ("Svetlana", (1,9,2015))


val test31_YoungestFromAnimals2 = 
youngestFromAnimals ([("Ivan", (31, 1, 211)), ("Alexei", (3, 10, 2001))
  , ("Victor", (3, 10, 2001))], ["Rabbit"]) = SOME ("Ivan",(31,1,211))

(*****************************************************************************)

(****************************************************************************** 
  Задание 32 oldStyleStudents
 ******************************************************************************)
val test32_oldStyleStudents1 = 
  let 
    val tmp = oldStyleStudents [ ("Pushkin Alexander", (26,5,1799))
                               , ("Tolstoy Lev", (28,8,1828))
                               , ("Piotr I", (30,5,1672))
                               , ("Ivan Grozniy", (25,8,1530))
                               ]
  in
    sameList ( tmp 
             , [ ("Pushkin Alexander",(6,6,1799))
               , ("Piotr I",(9,6,1672))
               , ("Tolstoy Lev",(9,9,1828))
               , ("Ivan Grozniy",(4,9,1530)) ]
             )
  end
(*****************************************************************************)

(****************************************************************************** 
  Задание 33 youngestFromOldStyleAnimals
 ******************************************************************************)
val test33_youngestFromOldStyleAnimals1 = 
  youngestFromOldStyleAnimals ( [ ("Pushkin Alexander", (26,5,1799))
                                , ("Tolstoy Lev", (28,8,1828))
                                , ("Piotr I", (30,5,1672))
                                , ("Ivan Grozniy", (25,8,1530))
                                ]
                              , ["Rat", "Tiger"]
                              )
  = SOME ("Tolstoy Lev",(28,8,1828))


val test33_youngestFromOldStyleAnimals2 =
youngestFromOldStyleAnimals ( [ ("Ivan", (1, 9, 1980))
                              , ("Svetlana", (1, 9, 2015))
                              , ("Alex", (1, 9, 1955))
                              ]
                            , ["Horse", "Rabbit"]
                            )
  = NONE
(*****************************************************************************)

(****************************************************************************** 
  Задание 34 listOfStringDates
 ******************************************************************************)
val test34_listOfStringDates1 = 
  let 
    val tmp = listOfStringDates [ ("Pushkin Alexander", (26,5,1799))
                                , ("Tolstoy Lev", (28,8,1828))
                                , ("Piotr I", (30,5,1672))
                                , ("Ivan Grozniy", (25,8,1530))
                                ]
  in
    sameList ( tmp 
             , [ ("Piotr I","May 30, 1672")
               , ("Tolstoy Lev","August 28, 1828")
               , ("Pushkin Alexander","May 26, 1799")
               , ("Ivan Grozniy","August 25, 1530") ] 
             )
  end
(*****************************************************************************)

(****************************************************************************** 
  Задание 35 oldStyleStudentStringDates
 ******************************************************************************)
val test35_oldStyleStudentStringDates1 = 
  let 
    val tmp = oldStyleStudentStringDates [ ("Pushkin Alexander", (26,5,1799))
                                         , ("Tolstoy Lev", (28,8,1828))
                                         , ("Piotr I", (30,5,1672))
                                         , ("Ivan Grozniy", (25,8,1530))
                                         ]
  in
    sameList ( tmp 
             , [ ("Pushkin Alexander","June 6, 1799")
               , ("Tolstoy Lev","September 9, 1828")
               , ("Piotr I","June 9, 1672")
               , ("Ivan Grozniy","September 4, 1530") ]
             )
  end
(*****************************************************************************)

