load "lab-6.rb"

class Field
  attr_reader :field
end

class BattleField
  attr_reader :allships
end

class Tests

private
  PosList = [ [0, 0, 0, true], 
              [1, 0, 2, false],
              [2, 2, 4, false],
              [3, 0, 9, true],
              [4, 3, 9, true],
              [5, 6, 9, true],
              [6, 9, 0, true],
              [7, 9, 2, true],
              [8, 9, 4, true],
              [9, 9, 6, true] ]

  @@debug = false
  def self.debug
    @@debug
  end
public

  class Task1
    def self.test_1
      [1, 2, 3].add([2, 3, 4]) == [3, 5, 7]
    end
  end

  class Task2
    # Правильный вызов new
    def self.test_1
      f = Field.new
      f.field[0][1] = 1

      f.field[1][1] == nil
    end

    # Проверка на то, что значение — константа
    def self.test_2
      f = Field.new

      f.class.const_get("FieldSize") != nil
    end 
  end

  class Task3
    # Наличие геттера
    def self.test_1
      x = Field.new

      Field.size == 10
    end
  end 

  class Task4
    # Соответствие осей
    def self.test_1
      f = Field.new
      f.set!(2, 0, 0, false, 1)

      f.field[0][0] == 1 and f.field[0][1] == 1 and f.field[0][2] == nil
    end

    # Соответствие осей
    def self.test_2
      f = Field.new
      f.set!(2, 0, 0, true, 1)

      f.field[0][0] == 1 and f.field[1][0] == 1 and f.field[2][0] == nil
    end

    # Корректность удаления
    def self.test_3
      f = Field.new
      f.set!(2, 0, 0, true, 1)
      f.set!(2, 0, 0, true, nil)

      f.field[0][0] == nil && f.field[1][0] == nil && f.field[2][0] == nil
    end
  end

  class Task5
    # Проверка сэмпла из условия
    def self.test_1
      f = Field.new
      f.set!(4, 3, 3, false, 1)
      f.set!(3, 5, 4, true, 2)
      f.set!(1, 9, 9, true, 3)

      f.to_s == "+----------+\n|          |\n|          |\n|          |\n|   1111   |\n|          |\n|    2     |\n|    2     |\n|    2     |\n|          |\n|         3|\n+----------+"
    end
  end

  class Task6
    # Проверка сэмпла (вручную)
    def self.test_1
      f = Field.new
      f.set!(4, 3, 3, false, 1)
      f.set!(3, 5, 4, true, 2)
      f.set!(1, 9, 9, true, 3)

      f.print_field
    end
  end

  class Task7
    # Проверки сэмпла
    def self.test_1
      f = Field.new
      f.set!(4, 3, 3, false, 1)
      f.set!(3, 5, 4, true, 2)
      f.set!(1, 9, 9, true, 3)

      f.free_space?(4,0,3,true,1) == true
    end

    def self.test_2
      f = Field.new
      f.set!(4, 3, 3, false, 1)
      f.set!(3, 5, 4, true, 2)
      f.set!(1, 9, 9, true, 3)

      f.free_space?(4,1,3,true,1) == false
    end

    def self.test_3
      f = Field.new
      f.set!(4, 3, 3, false, 1)
      f.set!(3, 5, 4, true, 2)
      f.set!(1, 9, 9, true, 3)

      f.free_space?(4,7,2,true,1) == false
    end

    # Граничные значения
    def self.test_4
      f = Field.new

      f.free_space?(1, 9, 9, true, 3)
    end

    def self.test_5
      f = Field.new

      f.free_space?(1, 0, 9, true, 3)
    end
  end

  class Task8
    # Проверить наличие всех нужных полей
    # и методов
  end

  class Task9
    # Тривиальная проверка
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 3)

      sh.to_s == "X"
    end
  end

  class Task10
    # Корректность очистки
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 3)
      sh.set!(0, 0, true)
      if Tests.debug
        f.print_field
      end
      sh.clear
      if Tests.debug
        f.print_field
      end

      f.field[0][0] == nil && f.field[0][1] == nil && f.field[0][2] == nil
    end
  end

  class Task11
    # Проверка на соответствие осей и вычисление координат
    # начала и конца
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 3)
      sh.set!(0, 0, false)
      fl1 = f.field[0][0] == sh and f.field[0][1] == sh and f.field[0][2] == sh
      fl2 = sh.coord == [0, 0, 0, 2]

      fl1 && fl2
    end

    # Аналогично т.1
    def self.test_2
      f = Field.new
      sh = Ship.new(f, 3)
      sh.set!(0, 0, true)
      fl1 = f.field[0][0] == sh and f.field[1][0] == sh and f.field[2][0] == sh
      fl2 = sh.coord == [0, 0, 2, 0]

      fl1 && fl2
    end
  end

  class Task12
    # Проверка на корректность удаления корабля
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 3)
      sh.set!(0, 0, true)
      sh.kill
      
      f.field[0][0] == nil && f.field[0][1] == nil && f.field[0][2] == nil && sh.coord == nil
    end
  end

  class Task13
    # Один выстрел приводит к потоплению однопалубного корабля
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 1)
      sh.set!(0, 0, true)
      len = sh.explode

      len != nil
    end

    # Двухпалубный корабль не взрывается с одного выстрела
    def self.test_2
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(0, 0, true)
      len = sh.explode

      len == nil
    end
  end

  class Task14
    # Банальная проверка
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(0, 0, true)
      sh.explode

      sh.cure
      sh.cure
      sh.cure

      sh.health == 1
    end
  end

  class Task15
    # Верьте тесту на свой страх и риск — значение взято
    # с моего решения))
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(0, 0, true)
      sh.explode

      sh.health == 0.65
    end
  end

  class Task16
    # Тривиальное передвижение
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(0, 0, true)
      if Tests.debug
        f.print_field
      end
      sh.move(true)
      if Tests.debug
        f.print_field
      end

      fl1 = sh.coord == [1, 0, 2, 0]
      fl2 = f.field[1][0] == sh && f.field[2][0] == sh

      fl1 && fl2
    end

    # Перемещение за границы 
    def self.test_2
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(0, 0, true)
      if Tests.debug
        f.print_field
      end
      ans = sh.move(false)
      if Tests.debug
        f.print_field
      end

      ans == false
    end
  end

  # Возможных поворотов достаточно много — больше
  # приведено в задании 26.
  #
  # Обращайте внимание, что тест проверяет только
  # размещение корабля и не обращает внимание
  # на внутреннее состояние. Набор не отлавливает
  # весь возможный набор проблем
  class Task17
    # Поворот против часовой на 90
    def self.test_1
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(1, 1, true)
      if Tests.debug
        f.print_field
      end
      sh.rotate(1, 1)
      if Tests.debug
        f.print_field
      end

      status = true

      f.field.each_with_index do |x, i|
        x.each_with_index do |y, j|
          if i == 1 and (j == 1 or j == 2)
            status = status && y == sh
          else
            status == status && y == nil
          end
        end
      end

      return status
    end

    # Поворот против часовой на 180
    def self.test_2
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(1, 1, true)
      if Tests.debug
        f.print_field
      end
      sh.rotate(1, 2)
      if Tests.debug
        f.print_field
      end
      status = true

      f.field.each_with_index do |x, i|
        x.each_with_index do |y, j|
          if j == 1 and (i == 0 or i == 1)
            status = status && y == sh
          else
            status = status && y == nil
          end
        end
      end

      return status
    end

    # Поворот против часовой на 270 (по часовой на 90)
    def self.test_3
      f = Field.new
      sh = Ship.new(f, 2)
      sh.set!(1, 1, true)
      if Tests.debug
        f.print_field
      end
      sh.rotate(1, 3)
      if Tests.debug
        f.print_field
      end

      f.field.each_with_index do |x, i|
        x.each_with_index do |y, j|
          if i == 1 and (j == 0 or j == 1)
            status = status && y == sh
          else
            status = status && y == nil
          end
        end
      end
    end
  end

  class Task18

    Field = BattleField.new

    # Проверка корректности отображения в корабль
    def self.test_1
      Field.allships[0].is_a?(Ship)
    end 

    # Проверка корректности отображение переменной длины
    def self.test_2
      Field.allships[0].len == 4
    end
  end

  class Task19
    Field = BattleField.new
    Fleet = Field.fleet
    # Проверка на то, что результат — массив
    def self.test_1
      Fleet[0].is_a?(Array)
    end

    # Проверка корректности отображения для четырехпалубного
    # корабля
    def self.test_2
      Fleet[0][0] == 0 && Fleet[0][1] == Field.allships[0].len
    end
  end

  class Task20
    # Проверка размещения в соответствии с изображением
    # поля, порождаемого PosList
    def self.test_1
      f = BattleField.new
      f.place_fleet(Tests::PosList)
      if Tests.debug
        f.print_field
      end
      ship1 = f.allships[0]
      ship2 = f.allships[1]
      ok1 = f.field[0][0] == ship1 && f.field[1][0] == ship1
      ok2 = f.field[0][2] == ship2 && f.field[0][3] == ship2

      ok1 && ok2
    end

  end

  class Task21
    # Проверить вручную
    def self.test_1
      f = BattleField.new
      f.place_fleet(Tests::PosList)
      print("#{f.remains}\n")
    end
  end

  class Task22
    # Проверка на удаление потопленного корабля
    def self.test_1
      f = BattleField.new
      f.place_fleet(Tests::PosList)
      if Tests.debug
        f.print_field
      end
      ship = f.allships[0]
      ship.kill
      if Tests.debug
        f.print_field
      end
      f.refresh

      f.allships.all? {|x| x != ship}
    end
  end

  class Task23
    Field = BattleField.new
    Field.place_fleet(Tests::PosList)
    if Tests.debug
      Field.print_field
    end

    # Выстрел в однопалубный корабль
    def self.test_1
      Field.shoot([9, 0]) == "killed #{1}"
    end

    # Выстрел мимо
    def self.test_2
      Field.shoot([8, 0]) == "miss"
    end

    # Выстрел в произвольный корабль длины >1
    def self.test_3
      Field.shoot([0, 0]) == "wounded"
    end
  end

  class Task24

    # Проверка того, что автоматический метод для всех
    # кораблей работаеттем же образом, что и лечение отдельного
    # корабля "вручную"
    def self.test_1
      f = BattleField.new
      f1 = BattleField.new

      f.place_fleet(Tests::PosList)
      f1.place_fleet(Tests::PosList)

      f.shoot([0, 0])
      f1.shoot([0, 0])

      if Tests.debug
        f.print_field
      end

      ship = f.field[0][0]
      ship1 = f1.field[0][0]

      ship1.cure
      f.cure

      ship.health == ship1.health
    end
  end

  class Task26
    # Всевозможные повороты
    def self.test_1
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 1, 1])
      if Tests.debug
        f.print_field
      end
    end

    def self.test_2
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 2, 1])
      if Tests.debug
        f.print_field
      end
    end
    
    def self.test_3
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 3, 1])
      if Tests.debug
        f.print_field
      end
    end

    def self.test_4
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 1, 3])
      if Tests.debug
        f.print_field
      end
    end

    def self.test_5
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 2, 3])
      if Tests.debug
        f.print_field
      end
    end

    def self.test_6
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 3, 3])
      if Tests.debug
        f.print_field
      end
    end

    def self.test_7
      f = BattleField.new
      pos_list = [[2, 2, 4, false]]
      f.place_fleet(pos_list)
      if Tests.debug
        f.print_field
      end
      f.move([2, 0, 0])
      if Tests.debug
        f.print_field
      end
    end
  end

  # Функция автоматически получает список классов
  # и методов в каждом из них и запускает в корректном
  # порядке. Каждый тест имеет один из трех вердиктов —
  # ok — тест пройден
  # error — ошибка
  # manual — система не выдает вердикт и тест нужно проверить
  # вручную на основе выведенных данных
  def self.run_tests(debug)
    @@debug = debug
    tasks = self.constants
    tasks.sort! { |a, b| a.to_s[4, 1000].to_i <=> b.to_s[4, 1000].to_i }
    tasks.each do |x| 
      
      c = self::const_get(x)
      if !c.is_a?(Class)
        next
      end
        puts ("*****#{x.to_s}*****")
      methods = c.singleton_methods(false)
      methods.sort! { |a, b| a.to_s[5, 1000].to_i <=> b.to_s[5, 1000].to_i }
      methods.each do |t| 
        rc = c::send(t)
        if rc == true
          verdict = "ok"
        elsif rc == false 
          verdict = "error"
        else
          verdict = "manual"
        end
        puts ("#{t.to_s}: #{verdict}")
      end
    end
  end

end

# 1 — выводит вспомогательную информацию (картиночки полей)
# 0 — только тесты
puts("Debug mode?")
debug = !gets.chomp.to_i.zero?

Tests.run_tests(debug)
