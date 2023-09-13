(****************************************************************************** 
  Шаблон для выполнения заданий лабораторной работы №1

  НЕ СЛЕДУЕТ УДАЛЯТЬ ИЛИ ПЕРЕСТАВЛЯТЬ МЕСТАМИ ЭЛЕМЕНТЫ, 
  ПРЕДСТАВЛЕННЫЕ В ШАБЛОНЕ (ВКЛЮЧАЯ КОММЕНТАРИИ). 
  ЭЛЕМЕНТЫ РЕШЕНИЯ СЛЕДУЕТ ВПИСЫВАТЬ В ПРОМЕЖУТКИ,
  ОПРЕДЕЛЕННЫЕ КОММЕНТАРИЯМИ.
 ******************************************************************************)

(****************************************************************************** 
  Загрузка определений модулей MyDate и Fixed и вспомогательных списков данных 
 ******************************************************************************)
use "lab-1-use.sml";

(****************************************************************************** 
  Задание 1 isLeapYear
 ******************************************************************************)
fun isLeapYear (year : int, julian : bool) : bool =
  julian andalso year mod 4 = 0
  orelse ( year mod 100 <> 0 andalso year mod 4 = 0
           orelse year mod 400 = 0 )
(******************************************************************************)

(****************************************************************************** 
  Задание 2 isLongMonth
 ******************************************************************************)
fun isLongMonth (numMonth : int) : bool =
  numMonth < 8 andalso numMonth mod 2 = 1
  orelse numMonth >= 8 andalso numMonth mod 2 = 0 
(******************************************************************************)

(****************************************************************************** 
  Задание 3 daysInMonth
 ******************************************************************************)
fun daysInMonth (fullDate : date, julian : bool) : int =
  let
    val monthDate = #2 fullDate
  in  
    if isLeapYear (#3 fullDate, julian) andalso monthDate = 2
    then 29
    else if monthDate <> 2
         then if isLongMonth (monthDate)
              then 31
              else 30
         else 28
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 4 isDayOK
 ******************************************************************************)
fun isDayOK (fullDate : date, julian : bool) : bool =
  let
    val daysMonth = #1 fullDate
  in
    daysMonth <= daysInMonth(fullDate, julian) andalso daysMonth > 0
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 5 isMonthOK
 ******************************************************************************)
fun isMonthOK (fullDate : date) : bool =
  let
    val monthDate = #2 fullDate
  in
    monthDate > 0 andalso monthDate < 13
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 6 isCorrectDate
 ******************************************************************************)
fun isCorrectDate (fullDate : date, julian : bool) : bool = 
  isDayOK (fullDate, julian) andalso isMonthOK (fullDate) andalso #3 fullDate > 0
(******************************************************************************)

(****************************************************************************** 
  Задание 7 incDateByNum
 ******************************************************************************)
fun incDateByNum (fullDate : date, days : int, julian : bool) : date =
  if #1 fullDate + days <= daysInMonth (fullDate, julian)
  then let
         val fullDate = (#1 fullDate + days, #2 fullDate, #3 fullDate)
       in
        fullDate
       end
  else if #2 fullDate <> 12
       then let
              val days = days - daysInMonth (fullDate, julian) + #1 fullDate - 1
              val fullDate = (1, #2 fullDate + 1, #3 fullDate)
            in
              incDateByNum (fullDate, days, julian)
            end
       else let
              val days = days - daysInMonth (fullDate, julian) + #1 fullDate - 1
              val fullDate = (1, 1, #3 fullDate + 1)
            in
              incDateByNum (fullDate, days, julian)
            end
(******************************************************************************)

(****************************************************************************** 
  Задание 8 decDateByNum
 ******************************************************************************)
fun decDateByNum (fullDate : date, days : int, julian : bool) : date =
  if #1 fullDate - days > 0
  then let
         val fullDate = (#1 fullDate - days, #2 fullDate, #3 fullDate)
       in
        fullDate
       end
  else if #2 fullDate <> 1
       then let
              val days = days - #1 fullDate
              val fullDate = (#1 fullDate, #2 fullDate - 1, #3 fullDate)
              val newDays = daysInMonth (fullDate, julian)
              val fullDate = (newDays, #2 fullDate, #3 fullDate)
            in
              decDateByNum (fullDate, days, julian)
            end
       else let
              val days = days - #1 fullDate
              val fullDate = (31, 12, #3 fullDate - 1)
            in
              decDateByNum (fullDate, days, julian)
            end
(******************************************************************************)

(****************************************************************************** 
  Задание 9 newStyleCorrection
 ******************************************************************************)
fun newStyleCorrection (fullDate : date) : int =
  let 
    val multipleOf100 = #3 fullDate div 100
    val multipleOf400 = #3 fullDate div 400
    val countDays = multipleOf100 - multipleOf400
  in 
    if #3 fullDate mod 400 = 0 
     then countDays - 2
     else if #3 fullDate mod 100 = 0
          then if #2 fullDate > 2
               then countDays - 2
               else countDays - 3
          else countDays - 2
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 10 toJulianDay
 ******************************************************************************)
fun toJulianDay (fullDate : date) : date =
  let
    val newStCor = newStyleCorrection fullDate
  in
    decDateByNum (fullDate, newStCor, true)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 11 toGrigorianDay
 ******************************************************************************)
fun toGrigorianDay (fullDate : date) : date =
  let
      val newStCor = if isCorrectDate (fullDate, false)
                     then newStyleCorrection fullDate
                     else newStyleCorrection (MyDate.anotherDay 
                      (fullDate, #1 fullDate - 1))
  in
      if isCorrectDate (fullDate, false)
      then incDateByNum (fullDate, newStCor, false)
      else incDateByNum (fullDate, newStCor + 1, false)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 12 younger
 ******************************************************************************)
fun younger (fullDateFirst : date, fullDateSecond : date) : bool =
  if #3 fullDateFirst > #3 fullDateSecond
  then true
  else if #3 fullDateFirst = #3 fullDateSecond
       then if #2 fullDateFirst > #2 fullDateSecond
            then true
            else if #2 fullDateFirst = #2 fullDateSecond
                 then #1 fullDateFirst > #1 fullDateSecond
                 else false
       else false
(******************************************************************************)

(****************************************************************************** 
  Задание 13 youngest
 ******************************************************************************)
fun youngest (l : (string * date) list) : (string * date) option =
  if null l 
  then NONE
  else if null (tl l) 
       then SOME ((hd l)) 
       else if younger (#2 (hd l), #2 (hd (tl l)))
            then youngest (hd l :: tl (tl l))
            else youngest (tl l)
(******************************************************************************)

(****************************************************************************** 
  Задание 14 getNthFixed
 ******************************************************************************)
fun getNthFixed (n : int, lst : fixed list) : fixed =
  if n = 0
  then hd lst
  else getNthFixed (n - 1, tl lst)
(******************************************************************************)

(****************************************************************************** 
  Задание 15 numToDigits
 ******************************************************************************)
fun numToDigits (num : int, numDigits : int) : int list =
  if numDigits <> 0
  then num mod 10 :: numToDigits(num div 10, numDigits - 1)
  else []
(******************************************************************************)

(****************************************************************************** 
  Задание 16 listElements
 ******************************************************************************)
fun listElements (lst : int list, fixedLst : fixed list list) : fixed list =
    if null lst
    then []
    else getNthFixed (hd lst, hd fixedLst) :: listElements (tl lst, tl fixedLst)
(******************************************************************************)

(****************************************************************************** 
  Задание 17 listSum
 ******************************************************************************)
fun listSum (fixedLst : fixed list) : fixed =
  if null fixedLst
  then 0
  else hd fixedLst + listSum (tl fixedLst)
(******************************************************************************)

(****************************************************************************** 
  Задание 18 maxSmaller
 ******************************************************************************)
fun maxSmaller (fixedLst : fixed list, amount : fixed) : fixed =
  if null fixedLst
  then 0
  else let
         val headTail = hd fixedLst
       in
         if headTail < amount 
            andalso maxSmaller (tl fixedLst, amount) < headTail
         then headTail
         else maxSmaller (tl fixedLst, amount)
       end
(******************************************************************************)

(****************************************************************************** 
  Задание 19 dateToCorrectionNums
 ******************************************************************************)
fun dateToCorrectionNums (fullDate : date) : int list =
  let
    val remYear = #3 fullDate mod 4 :: []
  in
    (#2 fullDate - 1) :: numToDigits (#3 fullDate, 4) @ remYear
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 20 firstNewMoon
 ******************************************************************************)
fun firstNewMoon (fullDate : date) : (fixed * date) option = 
  let
    val fnum = Fixed.fromInt (newStyleCorrection fullDate)
    val newDate =
      if #2 fullDate < 3
      then MyDate.anotherYear(fullDate, #3 fullDate - 1)
      else fullDate
    val fnum = fnum + 
           listSum (listElements (dateToCorrectionNums newDate, corrections))
    val fnum = fnum - maxSmaller (reductions, fnum - Fixed.fromInt 1)
    val fullDate = MyDate.anotherDay(fullDate, Fixed.toInt fnum)
  in
      if isCorrectDate(fullDate, false)
      then SOME (fnum, fullDate)
      else NONE
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 21 winterSolstice
 ******************************************************************************)
fun winterSolstice (year : int) : date =
  let
    val offset = 2250000 + 24220 * year 
                 - 100000 * (year div 4 - year div 100 + year div 400)
  in
    (Fixed.toInt offset, 12, year)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 22 chineseNewYearDate
 ******************************************************************************)
fun chineseNewYearDate (year : int) : date =
  let
    val preWinSol = winterSolstice (year - 1)
    val preFirNewMoon = #2 (valOf (firstNewMoon (1, 12, year - 1)))
    val dayFirNewMoon = #1 (valOf (firstNewMoon (1, 12, year - 1)))
    val sum1 = Fixed.toInt (dayFirNewMoon + 2953059)
    val sum2 = Fixed.toInt (dayFirNewMoon + 5906118)
  in
    if younger (preFirNewMoon, preWinSol)
    then incDateByNum ((1,12, year - 1), sum1 - 1, false)
    else incDateByNum ((1,12, year - 1), sum2 - 1, false)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 23 getNthString
 ******************************************************************************)
fun getNthString (n : int, lst : string list) : string =
  if n = 0
  then hd lst
  else getNthString (n - 1, tl lst)
(******************************************************************************)

(****************************************************************************** 
  Задание 24 dateToString
 ******************************************************************************)
fun dateToString (fullDate : date) : string =
  let
    val strMonth = getNthString (#2 fullDate - 1, months)
    val strDay = " " ^ Int.toString (#1 fullDate) ^ ", "
    val strYear = Int.toString (#3 fullDate)
  in
    strMonth ^ strDay ^ strYear
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 25 chineseYear
 ******************************************************************************)
fun chineseYear (year : int) : string * string * string * string =
  let
    val yearCh = (year + 2396) mod 60
    val celChi = getNthString (yearCh mod 10, celestialChi)
    val terrChi = getNthString (yearCh mod 12, terrestrialChi)
    val nameEng = getNthString (yearCh mod 10, celestialEng)
    val celCol = getNthString ((yearCh mod 10) div 2, celestialColor)
    val celEng = getNthString (yearCh mod 12, terrestrialEng)
  in
    (celChi ^ "-" ^ terrChi, celCol, celEng, nameEng)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 26 dateToChineseYear
 ******************************************************************************)
fun dateToChineseYear (fullDate : date) : string * string * string * string =
  let
    val newYearChi = chineseNewYearDate (#3 fullDate)
  in
    if younger (newYearChi, fullDate)
    then chineseYear (#3 newYearChi - 1)
    else chineseYear (#3 newYearChi)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 27 dateToAnimal
 ******************************************************************************)
fun dateToAnimal (fullDate : date) : string =
  #3 (dateToChineseYear fullDate)
(******************************************************************************)

(****************************************************************************** 
  Задание 28 animal
 ******************************************************************************)
fun animal (studentYear : string * date) : string =
  dateToAnimal (#2 studentYear)
(******************************************************************************)

(****************************************************************************** 
  Задание 29 extractAnimal
 ******************************************************************************)
fun extractAnimal (studentYear : (string * date) list, nameAnimal : string) 
  : (string * date) list =
  if null studentYear 
  then nil
  else let
         val toAnimal = animal (hd studentYear)
       in
         if toAnimal = nameAnimal 
         then hd studentYear :: extractAnimal (tl studentYear, nameAnimal)
         else extractAnimal (tl studentYear, nameAnimal)
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 30 extractAnimals
 ******************************************************************************)
fun extractAnimals (studentYear : (string * date) list, nameAnimal : string list) 
  : (string * date) list =
  if null nameAnimal then nil
  else let 
         val toAnimal = hd nameAnimal
       in 
        extractAnimal (studentYear, toAnimal) 
        @ extractAnimals (studentYear, tl nameAnimal)
       end
(******************************************************************************)

(****************************************************************************** 
  Задание 31 youngestFromAnimals
 ******************************************************************************)
fun youngestFromAnimals (stYear : (string * date) list, nAnimal : string list)
  : (string * date) option = youngest (extractAnimals (stYear, nAnimal))
(******************************************************************************)

(****************************************************************************** 
  Задание 32 oldStyleStudents
 ******************************************************************************)
fun oldStyleStudents (stYear : (string * date) list) : (string * date) list =
  if null stYear then []
  else let
         val firStud = hd stYear
       in (#1 firStud, toGrigorianDay (#2 firStud)) 
            :: oldStyleStudents (tl stYear)
       end
(******************************************************************************)

(****************************************************************************** 
  Задание 33 youngestFromOldStyleAnimals
 ******************************************************************************)
fun youngestFromOldStyleAnimals (stYear : (string * date) list
  , nAnimal : string list) : (string * date) option = 
  let
    val newStYearAni = extractAnimals (oldStyleStudents stYear, nAnimal)
  in
    if null newStYearAni
    then NONE
    else let
           val stuDent = valOf (youngest newStYearAni)
         in
           SOME (#1 stuDent, toJulianDay (#2 stuDent))
         end
  end
(******************************************************************************)

(****************************************************************************** 
  Задание 34 listOfStringDates
 ******************************************************************************)
fun listOfStringDates (stYear : (string * date) list) : (string * string) list =
  if null stYear then []
  else let
         val firStud = hd stYear
       in 
        (#1 firStud, dateToString (#2 firStud)) :: listOfStringDates (tl stYear)
       end
(******************************************************************************)

(****************************************************************************** 
  Задание 35 oldStyleStudentStringDates
 ******************************************************************************)
fun oldStyleStudentStringDates (stYear : (string * date) list)
  : (string * string) list =
  listOfStringDates (oldStyleStudents stYear)
(******************************************************************************)

