;((A) () (((B) ())) C () (()) (D) (E (F () (() X)) G H))
(print 
  (cons
    (cons 'A ())
    (cons ()
          (cons 
            (cons 
              (cons (cons 'B ())
                    (cons () ()))
              ())
            (cons 'C
                  (cons ()
                        (cons (cons () ()) 
                              (cons (cons 'D ())
                                    (cons 
                                      (cons 'E
                                            (cons 
                                              (cons 'F
                                                    (cons ()
                                                          (cons 
                                                            (cons ()
                                                                  (cons 'X()))
                                                            ())))
                                              (cons 'G
                                                    (cons 'H ()))))
                                      ())))))))))