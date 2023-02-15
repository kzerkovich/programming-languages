(load "streams.lsp")
;; Функция drop
;; На вкод получает два аргумента - число и поток
;; Поток проверяется на пустоту, если он пустой, то выдается он сам
;; Если поток непустой, то проверяется число: если оно равно 0, то выдается 
;; поток, в противном случае рекурсивно вызывается функция от числа, 
;; уменьшенного на 1 и хвоста потока.
(defun drop (n s)
  (if (empty-stream-p s) 
      s
      (if (= n 0) s 
          (drop (- n 1) (tail s)))))
;; Функция take 
;; На вход получает два аргумента - число и поток, и имеет опциональный
;; параметр - результат работы функции. Поток проверяется на пустоту, если он
;; пустой, то выдается new-lst, в противном случае проверяется число, если оно
;; больше 0, то рекурсивно вызывается функция от числа, уменьшенного на 1,
;; хвоста потока и головы списка, занесенного в переменную new-lst.
(defun take (n s &optional new-lst)
  (if (empty-stream-p s)
      new-lst
      (if (> n 0) 
          (take (- n 1)
                (tail s)
                (cons (head s) new-lst))
          (reverse new-lst))))
;; Функция map-stream
;; На вкод получает два аргумента - функция и поток
;; Если поток пустой, то выводится глобальная переменная TES, в противном случае
;; результат применения функции к голове потока присоединяется к результату
;; рекурсирвного вызова функции от хвоста потока с той же функцией.
(defun map-stream (f stream)
  (if (empty-stream-p stream)
      TES
      (cons-stream (funcall f (head stream))
                   (map-stream f (tail stream)))))
;; Функция sum-of-num (Аналог функции sumOfNum из 12 задания)
;; На вход принимает число и считает сумму его цифр
;; Если оно равно, то функция выдает 0, в противном случае последняя цифра числа
;; суммируется с рекурсивным вызовом функции от числа без последней цифры.
(defun sum-of-num (a)
  (if (= a 0)
      0 
      (+ (mod a 10)
         (sum-of-num (floor a 10)))))
;; Функция f19
;; На вход получает два числа
;; В теле функции определяются две лямбда-функции
;; proc принимает число и выдает остаток от деления на n суммы этого числа и 
;; суммы его цифр;
;; f19helper - принимает поток и применяет к нему функцию proc.
;; Результатом работы функции будет поток, полученный объединением исходного 
;; числа, остатка от деления на n суммы цифр этого числа и вызова функции 
;; f19helper от хвоста вызова f19 от исходных значений.
(defun f19 (x n)
  (let* ((proc (lambda (elem) 
                       (mod (+ (sum-of-num elem) elem)
                            n)))
         (f19helper (lambda (lst) (map-stream proc lst))))
    (cons-stream x
                 (cons-stream (mod (sum-of-num x) n)
                              (funcall f19helper (tail (f19 x n)))))))


(print (take 10 (f19 322 5)))
(print (take 15 (f19 115 7)))
(print (take 20 (drop 10 (f19 11 10))))
(print (take 20 (f19 115 3)))
(print (take 20 (f19 1234 50)))