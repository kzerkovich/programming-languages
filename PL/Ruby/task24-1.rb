# подгружаются основные определения
require_relative './task24-math'
################################################################################
# Определения согласно варианту 
################################################################################

# class PI
class PI < Number
  # инициализируем число pi также как и числа в классе Number
  def initialize
    super 3.1415
  end

  # преобразование объекта PI в строку
  def to_s
    "PI"
  end

end
# class MathExpression
# для классов Variable, Multiply, Exp, Derivative вызываются методы из этого 
# класса
class MathExpression
  # создается объект Sin с содержимым - переменной
  def sin 
    Sin.new(self)
  end

  # создается объект Cos с содержимым - переменной
  def cos
    Cos.new(self)
  end
  # создается объект Negate с содержимым - переменной
  def negate
    Negate.new(self)
  end
end

# class Sin
class Sin < MathExpression
  def initialize e  # синус вычисляется от выражения е
    @e = e
  end

  # вычисление в окружении env
  def eval env
    (@e.eval env).sin
  end

  # преобразование объекта PI в строку
  def to_s
    "sin(#{@e.to_s})"
  end

  # вычисление производной от синуса
  def derivative var
    e = @e.derivative var # формируем результат по правилу 
    e.multiply Cos.new(@e) # (sin(x))'=x'*cos(x)
  end
end

# class Cos
class Cos < MathExpression
  def initialize e # косинус вычисляется от выражения е
    @e = e
  end

  # вычисление в окружении env
  def eval env
    (@e.eval env).cos
  end

  # преобразование объекта PI в строку
  def to_s
    "cos(#{@e.to_s})"
  end

  # вычисдение производной от косинуса
  def derivative var
    e = @e.derivative var # формируем результат по правилу 
    e.multiply (Sin.new(@e).negate)       # (cos(x))'=x'*(-sin(x))
  end

end

# class Number
class Number < MathExpression
  # синус числа
  def sin
    Number.new(Math::sin(@n)) # создается объект Number с содержимым -
                              # синусом переданного числа
  end

  # косинус числа
  def cos
    Number.new(Math::cos(@n)) # создается объект Number с содержимым -
                              # косинусом переданного числа
  end
end

# class Negate
class Negate < MathExpression
  # синус отрицательного выражения определяем по формуле: sin(-x) = - sin(x)
  def sin
    Sin.new(@e).negate # создается объект класса Sin с содержимым - 
                       # переданным выражением и к нему применяется метод negate
  end

  # косинус отрицательного числа определяем по формуле: cos(-x) = cos(x)
  def cos
    @e.cos # для переданного выражения вызывается метод cos
  end
end

# class Add
class Add < MathExpression
  # синус суммы определяем по формуле:
  # sin(x + y) = sin(x) * cos(y) + sin(y) * cos(x)
  def sin
    e1_s = @e1.sin # синус первого выражения
    e1_c = @e1.cos # косинус первого выражения
    e2_s = @e2.sin # синус второго выражения
    e2_c = @e2.cos # косинус второго выражения
    Add.new(Multiply.new(e1_s, e2_c), Multiply.new(e1_c, e2_s)) # синус суммы
  end

  # косинус суммы определяем по формуле:
  # cos(x + y) = cos(x) * cos(y) - sin(y) * sin(x)
  def cos
    e1_s = @e1.sin # синус первого выражения
    e1_c = @e1.cos # косинус первого выражения
    e2_s = @e2.sin # синус второго выражения
    e2_c = @e2.cos # косинус второго выражения
    # косинус суммы
    Add.new(Multiply.new(e1_c, e2_c), Negate.new(Multiply.new(e1_s, e2_s)))
  end
end

# Примеры
puts "-------------------------------------------------------------------------"
puts "Суммы синусов и косинусов"
puts Add.new(Sin.new(Number.new(3)), Sin.new(Number.new(5))).eval_exp
puts Add.new(Sin.new(Number.new(3)), Cos.new(Number.new(5))).eval_exp
puts Add.new(Cos.new(Number.new(3)), Cos.new(Number.new(5))).eval_exp
puts Add.new(Sin.new(Number.new(3)), Sin.new(Variable.new("x"))).eval_exp
puts Add.new(Sin.new(Number.new(3)), Cos.new(Variable.new("x"))).eval_exp
puts Add.new(Cos.new(Number.new(3)), Cos.new(Variable.new("x"))).eval_exp
puts "-------------------------------------------------------------------------"
puts "Произведения синусов и косинусов"
puts Multiply.new(Sin.new(Number.new(3)), Sin.new(Number.new(5))).eval_exp
puts Multiply.new(Sin.new(Number.new(3)), Cos.new(Number.new(5))).eval_exp
puts Multiply.new(Cos.new(Number.new(3)), Cos.new(Number.new(5))).eval_exp
puts Multiply.new(Sin.new(Number.new(3)), Sin.new(Variable.new("x"))).eval_exp
puts Multiply.new(Sin.new(Number.new(3)), Cos.new(Variable.new("x"))).eval_exp
puts Multiply.new(Cos.new(Number.new(3)), Cos.new(Variable.new("x"))).eval_exp
puts "-------------------------------------------------------------------------"
puts "Экспоненты синусов и косинусов"
puts Exp.new(Sin.new(Number.new(3))).eval_exp
puts Exp.new(Cos.new(Number.new(5))).eval_exp
puts Exp.new(Sin.new(Variable.new("x"))).eval_exp
puts Exp.new(Cos.new(Variable.new("x"))).eval_exp
puts "-------------------------------------------------------------------------"
puts "Отрицания синусов и косинусов"
puts Negate.new(Sin.new(Number.new(3))).eval_exp
puts Negate.new(Cos.new(Number.new(5))).eval_exp
puts Negate.new(Sin.new(Variable.new("x"))).eval_exp
puts Negate.new(Cos.new(Variable.new("x"))).eval_exp
puts "-------------------------------------------------------------------------"
puts "Производные синусов и косинусов"
puts Derivative.new(Sin.new(Variable.new("x")), "x").eval_exp
puts Derivative.new(Sin.new(Variable.new("x")), "y").eval_exp
puts Derivative.new(Cos.new(Variable.new("x")), "x").eval_exp
puts Derivative.new(Cos.new(Variable.new("x")), "y").eval_exp
puts Derivative.new(Sin.new(Multiply.new(Variable.new("x"), Number.new(2))), "x").eval_exp
puts Derivative.new(Cos.new(Multiply.new(Number.new(2), Variable.new("x"))), "x").eval_exp
puts "-------------------------------------------------------------------------"
puts "Примеры для класса PI"
puts "-------------------------------------------------------------------------"
puts "Создание числа PI"
pi_1 = PI.new
puts pi_1
puts "-------------------------------------------------------------------------"
puts "Сложение числа PI с числом и переменной"
pi_2 = Add.new(pi_1, Number.new(5))
pi_3 = Add.new(pi_1, Variable.new("x"))
puts pi_2
puts pi_2.eval_exp
puts pi_3
puts pi_3.eval_exp
puts "-------------------------------------------------------------------------"
puts "Умножение числа PI на число и переменной"
pi_4 = Multiply.new(pi_1, Number.new(3))
pi_4_1 = Multiply.new(pi_1, Variable.new("x"))
puts pi_4
puts pi_4.eval_exp
puts pi_4_1
puts pi_4_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Отрицательное число PI"
pi_5 = Negate.new(pi_1)
puts pi_5
puts pi_5.eval_exp
puts "-------------------------------------------------------------------------"
puts "Экспонента для числа PI"
pi_6 = Exp.new(pi_1)
puts pi_6
puts pi_6.eval_exp
puts "-------------------------------------------------------------------------"
puts "Производная для числа PI по переменной x"
pi_7 = Derivative.new(pi_1, "x")
puts pi_7
puts pi_7.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус для числа PI"
puts Math.sin(3.1415)
pi_8 = Sin.new(pi_1)
puts pi_8
puts pi_8.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус для числа PI"
puts Math.cos(3.1415)
pi_9 = Cos.new(pi_1)
puts pi_9
puts pi_9.eval_exp
puts "-------------------------------------------------------------------------"
puts "-------------------------------------------------------------------------"
puts "Примеры для класса Sin"
puts "-------------------------------------------------------------------------"
puts "Синус от числа"
sin_1 = Sin.new(Number.new(5))
puts sin_1
puts sin_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус от переменной"
sin_2 = Sin.new(Variable.new("y"))
puts sin_2
puts sin_2.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус от синуса"
sin_3 = Sin.new(sin_1)
puts sin_3
puts sin_3.eval_exp
sin_4 = Sin.new(sin_2)
puts sin_4
puts sin_4.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус от косинуса"
sin_5 = Sin.new(Cos.new(Number.new(2)))
puts sin_5
puts sin_5.eval_exp
sin_6 = Sin.new(Cos.new(Variable.new("z")))
puts sin_6
puts sin_6.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус суммы"
sin_7 = Sin.new(Add.new(Number.new(3), Number.new(5)))
puts sin_7
puts sin_7.eval_exp
sin_8 = Sin.new(Add.new(Number.new(3), Variable.new("x")))
puts sin_8
puts sin_8.eval_exp
sin_9 = Sin.new(Add.new(Variable.new("y"), Variable.new("x")))
puts sin_9
puts sin_9.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус произведения"
sin_10 = Sin.new(Multiply.new(Number.new(3), Number.new(5)))
puts sin_10
puts sin_10.eval_exp
sin_1_1 = Sin.new(Multiply.new(Number.new(3), Variable.new("x")))
puts sin_1_1
puts sin_1_1.eval_exp
sin_2_1 = Sin.new(Multiply.new(Variable.new("y"), Variable.new("x")))
puts sin_2_1
puts sin_2_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус экспоненты"
sin_3_1 = Sin.new(Exp.new(Number.new(5)))
puts sin_3_1
puts sin_3_1.eval_exp
sin_4_1 = Sin.new(Exp.new(Number.new(0)))
puts sin_4_1
puts sin_4_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус производной"
sin_5_1 = Sin.new(
            Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")), 
                Number.new(5)),
              "x"))
der_1 = Derivative.new(
          Add.new(
           Multiply.new(Variable.new("x"),
                        Variable.new("x")), 
           Number.new(5)),
          "x")
puts "Первая производная"
puts der_1
puts der_1.eval_exp
puts "Синус первой производной"
puts sin_5_1
puts sin_5_1.eval_exp
sin_6_1 = Sin.new(
            Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")),
                Number.new(5)),
              "y"))
der_2 = Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")),
                Number.new(5)),
              "y")
puts "Вторая производная"
puts der_2
puts der_2.eval_exp
puts "Синус второй производной"
puts sin_6_1
puts sin_6_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Синус отрицательного числа"
sin_7_1 = Sin.new(Negate.new(Number.new(5)))
puts sin_7_1
puts sin_7_1.eval_exp
sin_8_1 = Sin.new(Negate.new(Variable.new("x")))
puts sin_8_1
puts sin_8_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "-------------------------------------------------------------------------"
puts "Примеры для класса Cos"
puts "-------------------------------------------------------------------------"
puts "Косинус от числа"
cos_1 = Cos.new(Number.new(5))
puts cos_1
puts cos_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус от переменной"
cos_2 = Cos.new(Variable.new("y"))
puts cos_2
puts cos_2.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус от синуса"
cos_3 = Cos.new(sin_1)
puts cos_3
puts cos_3.eval_exp
cos_4 = Cos.new(sin_2)
puts cos_4
puts cos_4.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус от косинуса"
cos_5 = Cos.new(Cos.new(Number.new(2)))
puts cos_5
puts cos_5.eval_exp
cos_6 = Cos.new(Cos.new(Variable.new("z")))
puts cos_6
puts cos_6.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус суммы"
cos_7 = Cos.new(Add.new(Number.new(3), Number.new(5)))
puts cos_7
puts cos_7.eval_exp
cos_8 = Cos.new(Add.new(Number.new(3), Variable.new("x")))
puts cos_8
puts cos_8.eval_exp
cos_9 = Cos.new(Add.new(Variable.new("y"), Variable.new("x")))
puts cos_9
puts cos_9.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус произведения"
cos_10 = Cos.new(Multiply.new(Number.new(3), Number.new(5)))
puts cos_10
puts cos_10.eval_exp
cos_1_1 = Cos.new(Multiply.new(Number.new(3), Variable.new("x")))
puts cos_1_1
puts cos_1_1.eval_exp
cos_2_1 = Cos.new(Multiply.new(Variable.new("y"), Variable.new("x")))
puts cos_2_1
puts cos_2_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус экспоненты"
cos_3_1 = Cos.new(Exp.new(Number.new(5)))
puts cos_3_1
puts cos_3_1.eval_exp
cos_4_1 = Cos.new(Exp.new(Number.new(0)))
puts cos_4_1
puts cos_4_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус производной"
cos_5_1 = Cos.new(
            Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")), 
                Number.new(5)),
              "x"))
der_1_1 = Derivative.new(
          Add.new(
           Multiply.new(Variable.new("x"),
                        Variable.new("x")), 
           Number.new(5)),
          "x")
puts "Первая производная"
puts der_1_1
puts der_1_1.eval_exp
puts "Косинус первой производной"
puts cos_5_1
puts cos_5_1.eval_exp
cos_6_1 = Cos.new(
            Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")),
                Number.new(5)),
              "y"))
der_2_1 = Derivative.new(
              Add.new(
                Multiply.new(Variable.new("x"),
                             Variable.new("x")),
                Number.new(5)),
              "y")
puts "Вторая производная"
puts der_2_1
puts der_2_1.eval_exp
puts "Косинус второй производной"
puts cos_6_1
puts cos_6_1.eval_exp
puts "-------------------------------------------------------------------------"
puts "Косинус отрицательного числа"
cos_7_1 = Cos.new(Negate.new(Number.new(5)))
puts cos_7_1
puts cos_7_1.eval_exp
cos_8_1 = Cos.new(Negate.new(Variable.new("x")))
puts cos_8_1
puts cos_8_1.eval_exp
################################################################################
# # ПРИМЕРЫ 
# ################################################################################
# puts "-------------------------------------------------------------------------"
# puts "First example"
# exp1 = Derivative.new(
#          Multiply.new(
#            Add.new(
#              Add.new(
#                Multiply.new(Number.new(2),      
#                             Variable.new("x")), 
#                Multiply.new(Number.new(3), 
#                             Variable.new("y"))), 
#              Negate.new(Variable.new("z"))), 
#            Add.new(Number.new(5), 
#                    Variable.new("x"))), 
#          "x")
# puts exp1
# puts "-------------------------------------------------------------------------"
# puts exp1.eval_exp

# puts "-------------------------------------------------------------------------"
# puts "-------------------------------------------------------------------------"
# puts "Second example"
# exp2 = Let.new("a", Multiply.new(Number.new(2), 
#                                  Variable.new("x")),        # a = 2x
#          Let.new("b", Multiply.new(Number.new(3), 
#                                    Variable.new("y")),      # b = 3y
#            Let.new("e", Add.new(Variable.new("a"),         
#                                 Variable.new("b")),         # e = a + b
#               Multiply.new(Multiply.new(Variable.new("e"),
#                                         Variable.new("e")),
#                            Variable.new("e")))))
# puts exp2
# puts "-------------------------------------------------------------------------"

# puts exp2.eval_exp  

# puts "-------------------------------------------------------------------------"
# puts "-------------------------------------------------------------------------"
# puts "Third example"
# exp3 = Let.new("a", Multiply.new(Number.new(2), 
#                                  Variable.new("x")),   # a = 2x
#          Let.new("b", Multiply.new(Number.new(3), 
#                                    Variable.new("y")), # b = 3y
#            Let.new("cube",                             # cube(e) = e * e * e
#                    MyFunc.new(nil, "e",
#                      Multiply.new(Multiply.new(Variable.new("e"),
#                                                Variable.new("e")),
#                                   Variable.new("e"))),
#              # вычисление cube(a + b) + cube(b)
#              Add.new(Call.new(Variable.new("cube"),        # вызов cube(a + b)
#                               Add.new(Variable.new("a"), 
#                                       Variable.new("b"))),
#                      Call.new(Variable.new("cube"),        # вызов cube(b)
#                               Variable.new("b"))))))
# puts exp3
# puts "-------------------------------------------------------------------------"

# puts exp3.eval_exp  
# puts "-------------------------------------------------------------------------"

