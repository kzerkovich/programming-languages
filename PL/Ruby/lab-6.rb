<<<<<<< HEAD
## Шаблон для выполнения заданий Лабораторной работы №6 
## ВСЕ КОММЕНТАРИИ ПРИВЕДЕННЫЕ В ДАННОМ ФАЙЛЕ ДОЛЖНЫ ОСТАТЬСЯ НА СВОИХ МЕСТАХ
## НЕЛЬЗЯ ПЕРЕСТАВЛЯТЬ МЕСТАМИ КАКИЕ-ЛИБО БЛОКИ ДАННОГО ФАЙЛА
## решения заданий должны быть вписаны в отведенные для этого позиции 

################################################################################
# Задание 1 
# add b
################################################################################
class Array
  def add b
    map.each_with_index{|x, i| x + b[i]}
  end
end
# конец описания задания 1
################################################################################

################################################################################
# Задания 2-6 
# Класс Field
################################################################################
class Field
  FieldSize = 10

  def initialize
    @field = Array.new(FieldSize) { Array.new(FieldSize) }
  end
  # Задание 3 size (метод класса)
  def self.size
    FieldSize
  end
  # Задание 4 set!(n, x, y, hor, ship)
  def set! (n, x, y, hor, ship)
    if hor
      (1..n).each do |i| @field[x + i - 1][y] = ship end
    else
      (1..n).each do |i| @field[x][y + i - 1] = ship end
    end
  end
  # Задание 5 to_s
  def to_s
    @string = "+" + "-" * FieldSize + "+\n"
    (0..FieldSize - 1).each do |i|
      (-1..FieldSize).each do |j|
        if j == -1
          @string += "|"
        else 
          if j == FieldSize
            @string += "|\n"
          else
            if @field[i][j] == nil
              @string += " "
            else
              @string += "#{@field[i][j]}"
            end
          end
        end
      end
    end
    @string += "+" + "-" * FieldSize + "+"
  end
  # Задание 6 print_field
  def print_field
    puts self.to_s
  end
  # Задание 7 free_space?(n, x, y, hor, ship)
  def free_space?(n, x, y, hor, ship)
    mass = []
    if x.between?(0, FieldSize - 1) && y.between?(0, FieldSize - 1)
      if hor
        xn = x + n - 1
        yn = y
      else
        xn = x
        yn = y + n - 1
      end
      if xn.between?(0, FieldSize - 1) && yn.between?(0, FieldSize - 1)
        x -= 1 if x > 0
        y -= 1 if y > 0
        xn += 1 if xn < FieldSize - 1
        yn += 1 if yn < FieldSize - 1
        (x..xn).each do |i|
          (y..yn).each do |j|
            mass.push(@field[i][j])
          end
        end
        mass.all? {|x| x == nil || x == ship}
      else
        return false
      end
    else
      return false
    end
  end
end
# конец описания класса Field
################################################################################


################################################################################
# Задания 8-17 
# Класс Ship
################################################################################
class Ship
  attr_reader :len, :coord
  def initialize(field, len)
    @len = len
    @myfield = field
    @maxhealth = 100 * @len
    @minhealth = 30 * @len
    @health = @maxhealth
  end
  # Задание 9 to_s
  def to_s
    "X"
  end
  # Задание 10 clear
  def clear
    @myfield.set!(@len, @coord[0], @coord[1], @hor, nil)
  end
  # Задание 11 set!(x, y, hor)
  def set!(x, y, hor)
    if @myfield.free_space?(@len, x, y, hor, self)
      if @coord != nil
        self.clear
      end
      @myfield.set!(@len, x, y, hor, self)
      if hor
        @coord = [x, y, x + @len - 1, y]
      else
        @coord = [x, y, x, y + @len - 1]
      end
      @hor = hor
      return true
    else
      return false
    end
  end
  # Задание 12 kill
  def kill
    clear
    @coord = nil
  end
  # Задание 13 explode
  def explode
    @health -= 70
    if @health <= @minhealth
      kill
      @len
    else
      nil
    end
  end 
  # Задание 14 cure
  def cure
    @health += 30
    if @health > @maxhealth then @health = @maxhealth end
  end
  # Задание 15 health
  def health
    (@health / (@maxhealth * 1.0)).round(2) * 100
  end
  # Задание 16 move(forward)
  def move (forward)
    if forward
      if @hor
        self.set!(@coord[0] + 1, @coord[1], @hor)
      else
        self.set!(@coord[0], @coord[1] + 1, @hor)
      end
    else
      if @hor
        self.set!(@coord[0] - 1, @coord[1], @hor)
      else
        self.set!(@coord[0], @coord[1] - 1, @hor)
      end
    end
  end
  # Задание 17 rotate(n, k)
  def rotate (n, k)
    if k.between?(1, 3) && n.between?(1, @len)
      x = @coord[0]
      y = @coord[1]
      x1 = @coord[2]
      y1 = @coord[3]
      if @hor
        xc = x + n - 1
        yc = y
        if k == 1
          xn = -y1 + yc + xc
          yn = x1 - xc + yc
          return self.set!(xn, yn - @len + 1, !@hor)
        end
        if k == 2
          xn = -x1 + xc + xc
          yn = -y1 + yc + yc
          return self.set!(xn, yn, @hor)
        end
        if k == 3
          xn = y1 - yc + xc
          yn = -x1 + xc + yc
          return self.set!(xn, yn, !@hor)
        end
      else
        xc = x
        yc = y + n - 1
        if k == 1
          xn = -y1 + yc + xc
          yn = x1 - xc + yc
          return self.set!(xn , yn, !@hor)
        end
        if k == 2
          xn = -x1 + xc + xc
          yn = -y1 + yc + yc
          return self.set!(xn, yn, @hor)
        end
        if k == 3
          xn = y1 - yc + xc
          yn = -x1 + xc + yc
          return self.set!(xn - @len + 1, yn, !@hor)
        end
      end
    else
      return false
    end
  end
end
# конец описания класса Ship
################################################################################

################################################################################
# Задания 18-26
# Класс BattleField
################################################################################
class BattleField < Field
  Ships = [4,3,3,2,2,2,1,1,1,1]

  def newships
    @allships = Ships.map {|x| Ship.new(self, x)}
  end

  def initialize
    super
    newships
  end
  # Задание 19 fleet
  def fleet
    @allships.map.with_index {|x, i| [i, x.len]}
  end
  # Задание 20 place_fleet pos_list
  def place_fleet pos_list
    if pos_list.all? {|i, x, y, hor| @allships[i].set!(x, y, hor)} &&
      @allships.all? {|i| i.coord != nil}
      return true
    else
      @allships.map {|i| if i.coord != nil
                            i.kill
                         end}
      return false
    end
  end
  # Задание 21 remains
  def remains
    @allships.map.with_index {|x, i| [i, x.coord, x.len, x.health]}
  end
  # Задание 22 refresh
  def refresh
    @allships = (@field.reduce(:|)).find_all {|x| x != nil}
  end
  # Задание 23 shoot c
  def shoot c
    x = c[0]
    y = c[1]
    if @field[x][y] == nil
      "miss"
    else
      first = @field[x][y].explode
      if first == nil
        "wounded"
      else
        refresh
        "killed #{first}"
      end
    end
  end
  # Задание 24 cure
  def cure
    @allships.each {|x| x.cure}
  end
  # Задание 25 game_over?
  def game_over?
    @allships.empty?
  end
  # Задание 26 move l_move
  def move l_move
    if l_move[1] > 0 && l_move[1] < 4
      @allships[l_move[0]].rotate(l_move[2], l_move[1])
    else
      if l_move[2] == 1
        @allships[l_move[0]].move(true)
      else
        @allships[l_move[0]].move(false)
      end
    end
  end
end
# конец описания класса BattleField
################################################################################


################################################################################
# Задания 27-33
# Класс Player
################################################################################
class Player
  attr_accessor :manual

  def reset
    @allshots = []
    @lastshots = []
  end

  def initialize(name, manual = true)
    @name = name
    @manual = manual
    @lastsample = [1, 0]
    reset
  end

  # Задание 28 random_point
  def to_s
   @name
  end
  # Задание 29 random_point
  def random_point
    [rand(Field.size - 1), rand(Field.size - 1)]
  end
  # Задание 30 place_strategy ship_list

  # Дополнительный метод генерирующий случайные координаты
  def generation elem
    ran = random_point.push ([true, false].sample)
    if @h.free_space?(elem[1], ran[0], ran[1], ran[2], elem[0])
      @h.set!(elem[1], ran[0], ran[1], ran[2], elem[0])
      @mass.push ([elem[0], ran[0], ran[1], ran[2]])
    else
      generation elem
    end
  end

  def place_strategy ship_list
    @mass = []
    @h = Field.new
    sorted = ship_list.sort {|x, y| y[1] <=> x[1]}
    sorted.map {|i| generation i}
    @mass
  end
  # Задание 31 hit message
  def hit message
    @lastshots.push([@shot, message])
  end
  #            miss
  def miss
    @lastshots.push([@shot, "miss"])
    @allshots.push(@lastshots)
    @lastshots = []
  end
  # Задание 32 shot_strategy
  def shot_strategy
    if @manual
      @lastshots.each {|x| print(x, "\n")}
      puts "Make a shot. To switch off the manual mode enter -1 for any coordinate"
      while true
        print "x = "; x = gets.to_i; print x
        print " y = "; y = gets.to_i; puts y
        shot = [x,y]
        if shot.all? {|a| a.between?(-1, Field.size - 1)}
          break
        else
          puts "Incorrect input"
        end
      end
      if shot.any? {|a| a == -1}
        @manual = false
        shot_strategy
      else
        @shot = shot
      end
    else
      # Здесь необходимо разместить решение задания 30
      if @lastshots.empty? || @lastshots[-1][1].start_with?("killed")
        @shot = random_point
      else
        if @lastshots[-1][1] == "wounded"
          if @lastshots.length == 1 || @lastshots[-2][1].start_with?("killed")
            @lastsample = [[-1, 0], [0, -1], [1, 0], [0, 1]].sample
            @shot = @shot.add @lastsample
          else
            @shot = @shot.add @lastsample
          end
        end
      end
      (0..1).each do |i| 
        if !@shot[i].between?(0, Field.size - 1)
          @lastsample[i] *= -1 
          @shot = (@shot.add @lastsample).add @lastsample
        end
      end
      if @lastshots.find {|i| i[0] == @shot}
        shot_strategy
      else
        @shot
      end
      # конец решения задания 30
    end
  end

  # Задание 33 ship_move_strategy remains
  def ship_move_strategy remains
    if @manual
      puts "Ship health"
      tmp_field = Field.new
      names = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a
      ship_hash = {}
      remains.each do |ship|
        name = names[ship[0]]
        x = ship[1][0]; y = ship[1][1]
        hor = (ship[1][1] == ship[1][3])
        ship_hash[name] = [ship[0], ship[2]]
        tmp_field.set!(ship[2], x, y, hor, name)
        print(name, " - ", ship[3], "%\n") 
      end
      puts "Your ships"
      tmp_field.print_field
      puts "Make a move. To switch off the manual mode enter an incorrect ship name"
      while true
        print "Choose ship: "; 
        name = gets.strip; puts name
        if !ship_hash[name] then break end
        move = 0
        begin
          print "Enter 0 to move, 1-3 to rotate: " 
          move = gets.to_i; puts move
        end until move.between?(0,3)
        if move == 0
          print "1 - forward/any - backward): "; dir = gets.to_i
          puts dir
        else
          dir = 0
          begin
            print "Choose a center point: (1..#{ship_hash[name][1]}): "
            dir = gets.to_i; puts dir
          end until dir.between?(1,ship_hash[name][1])
        end
        break
      end
      if !ship_hash[name]
        @manual = false
        ship_move_strategy remains
      else
        [ship_hash[name][0], move, dir]
      end
    else
      # Здесь необходимо разместить решение задания 31
      remains.sort! {|x, y| x[3] <=> y[3]}
      first = remains[0]
      puts first
      [first[0], rand(0..3), rand(1..first[2])]
      # конец решения задания 31
    end
  end 

end
# конец описания класса Player
################################################################################

################################################################################
# Задания 34-35 
# Класс Game
################################################################################
class Game

  def initialize(player_1, player_2)
    @game_over = false
    @players = [[player_1, BattleField.new, 0], [player_2, BattleField.new, 0]]
    @players.map {|p| reset p}
    @players.shuffle!
  end

  def reset p
    puts "#{p[0]} game setup"
    p[0].reset
    if p[1].place_fleet (p[0].place_strategy (p[1].fleet))
      puts "Ships placed"
    else
      raise "Illegal ship placement"
    end
  end
  # Задание 35 start

  def start
    lastshots = []
    while !@game_over
      @players[0][2] += 1
      puts "Step #{@players[0][2]} of player #{@players[0][0]}"
      @players[0][1].cure
      btlfld = @players[0][0].ship_move_strategy (@players[0][1].remains)
      @players[0][1].move btlfld
      cord = @players[0][0].shot_strategy
      if lastshots.find {|i| i == cord}
        puts "Illegal shot"
        res = "miss"
      else
        lastshots.push cord
        res = @players[1][1].shoot cord
      end
      puts "#{cord} #{res}"
      if res == "miss"
        @players[0][0].miss
        @players.reverse!
        lastshots = []
      else
        @players[0][0].hit res
        @game_over = @players[1][1].game_over?
        if @game_over
            puts "Player #{@players[0][0]} wins!"
        end
      end
    end
  end
end
# конец описания класса Game
################################################################################

################################################################################
# Переустановка датчика случайных чисел
################################################################################
srand
################################################################################

#№ Пример запуска
# p1 = Player.new("Ivan", false)
# p2 = Player.new("Feodor", false)
# g = Game.new(p1,p2)
# g.start

=======
## Шаблон для выполнения заданий Лабораторной работы №6 
## ВСЕ КОММЕНТАРИИ ПРИВЕДЕННЫЕ В ДАННОМ ФАЙЛЕ ДОЛЖНЫ ОСТАТЬСЯ НА СВОИХ МЕСТАХ
## НЕЛЬЗЯ ПЕРЕСТАВЛЯТЬ МЕСТАМИ КАКИЕ-ЛИБО БЛОКИ ДАННОГО ФАЙЛА
## решения заданий должны быть вписаны в отведенные для этого позиции 

################################################################################
# Задание 1 
# add b
################################################################################
class Array
  def add b
    map.each_with_index{|x, i| x + b[i]}
  end
end
# конец описания задания 1
################################################################################

################################################################################
# Задания 2-6 
# Класс Field
################################################################################
class Field
  FieldSize = 10

  def initialize
    @field = Array.new(FieldSize) { Array.new(FieldSize) }
  end
  # Задание 3 size (метод класса)
  def self.size
    FieldSize
  end
  # Задание 4 set!(n, x, y, hor, ship)
  def set! (n, x, y, hor, ship)
    if hor
      (1..n).each do |i| @field[x + i - 1][y] = ship end
    else
      (1..n).each do |i| @field[x][y + i - 1] = ship end
    end
  end
  # Задание 5 to_s
  def to_s
    @string = "+" + "-" * FieldSize + "+\n"
    (0..FieldSize - 1).each do |i|
      (-1..FieldSize).each do |j|
        if j == -1
          @string += "|"
        else 
          if j == FieldSize
            @string += "|\n"
          else
            if @field[i][j] == nil
              @string += " "
            else
              @string += "#{@field[i][j]}"
            end
          end
        end
      end
    end
    @string += "+" + "-" * FieldSize + "+"
  end
  # Задание 6 print_field
  def print_field
    puts self.to_s
  end
  # Задание 7 free_space?(n, x, y, hor, ship)
  def free_space?(n, x, y, hor, ship)
    mass = []
    if x.between?(0, FieldSize - 1) && y.between?(0, FieldSize - 1)
      if hor
        xn = x + n - 1
        yn = y
      else
        xn = x
        yn = y + n - 1
      end
      if xn.between?(0, FieldSize - 1) && yn.between?(0, FieldSize - 1)
        x -= 1 if x > 0
        y -= 1 if y > 0
        xn += 1 if xn < FieldSize - 1
        yn += 1 if yn < FieldSize - 1
        (x..xn).each do |i|
          (y..yn).each do |j|
            mass.push(@field[i][j])
          end
        end
        mass.all? {|x| x == nil || x == ship}
      else
        return false
      end
    else
      return false
    end
  end
end
# конец описания класса Field
################################################################################


################################################################################
# Задания 8-17 
# Класс Ship
################################################################################
class Ship
  attr_reader :len, :coord
  def initialize(field, len)
    @len = len
    @myfield = field
    @maxhealth = 100 * @len
    @minhealth = 30 * @len
    @health = @maxhealth
  end
  # Задание 9 to_s
  def to_s
    "X"
  end
  # Задание 10 clear
  def clear
    @myfield.set!(@len, @coord[0], @coord[1], @hor, nil)
  end
  # Задание 11 set!(x, y, hor)
  def set!(x, y, hor)
    if @myfield.free_space?(@len, x, y, hor, self)
      if @coord != nil
        self.clear
      end
      @myfield.set!(@len, x, y, hor, self)
      if hor
        @coord = [x, y, x + @len - 1, y]
      else
        @coord = [x, y, x, y + @len - 1]
      end
      @hor = hor
      return true
    else
      return false
    end
  end
  # Задание 12 kill
  def kill
    clear
    @coord = nil
  end
  # Задание 13 explode
  def explode
    @health -= 70
    if @health <= @minhealth
      kill
      @len
    else
      nil
    end
  end 
  # Задание 14 cure
  def cure
    @health += 30
    if @health > @maxhealth then @health = @maxhealth end
  end
  # Задание 15 health
  def health
    (@health / (@maxhealth * 1.0)).round(2) * 100
  end
  # Задание 16 move(forward)
  def move (forward)
    if forward
      if @hor
        self.set!(@coord[0] + 1, @coord[1], @hor)
      else
        self.set!(@coord[0], @coord[1] + 1, @hor)
      end
    else
      if @hor
        self.set!(@coord[0] - 1, @coord[1], @hor)
      else
        self.set!(@coord[0], @coord[1] - 1, @hor)
      end
    end
  end
  # Задание 17 rotate(n, k)
  def rotate (n, k)
    if k.between?(1, 3) && n.between?(1, @len)
      x = @coord[0]
      y = @coord[1]
      x1 = @coord[2]
      y1 = @coord[3]
      if @hor
        xc = x + n - 1
        yc = y
        if k == 1
          xn = -y1 + yc + xc
          yn = x1 - xc + yc
          return self.set!(xn, yn - @len + 1, !@hor)
        end
        if k == 2
          xn = -x1 + xc + xc
          yn = -y1 + yc + yc
          return self.set!(xn, yn, @hor)
        end
        if k == 3
          xn = y1 - yc + xc
          yn = -x1 + xc + yc
          return self.set!(xn, yn, !@hor)
        end
      else
        xc = x
        yc = y + n - 1
        if k == 1
          xn = -y1 + yc + xc
          yn = x1 - xc + yc
          return self.set!(xn , yn, !@hor)
        end
        if k == 2
          xn = -x1 + xc + xc
          yn = -y1 + yc + yc
          return self.set!(xn, yn, @hor)
        end
        if k == 3
          xn = y1 - yc + xc
          yn = -x1 + xc + yc
          return self.set!(xn - @len + 1, yn, !@hor)
        end
      end
    else
      return false
    end
  end
end
# конец описания класса Ship
################################################################################

################################################################################
# Задания 18-26
# Класс BattleField
################################################################################
class BattleField < Field
  Ships = [4,3,3,2,2,2,1,1,1,1]

  def newships
    @allships = Ships.map {|x| Ship.new(self, x)}
  end

  def initialize
    super
    newships
  end
  # Задание 19 fleet
  def fleet
    @allships.map.with_index {|x, i| [i, x.len]}
  end
  # Задание 20 place_fleet pos_list
  def place_fleet pos_list
    if pos_list.all? {|i, x, y, hor| @allships[i].set!(x, y, hor)} &&
      @allships.all? {|i| i.coord != nil}
      return true
    else
      @allships.map {|i| if i.coord != nil
                            i.kill
                         end}
      return false
    end
  end
  # Задание 21 remains
  def remains
    @allships.map.with_index {|x, i| [i, x.coord, x.len, x.health]}
  end
  # Задание 22 refresh
  def refresh
    @allships = (@field.reduce(:|)).find_all {|x| x != nil}
  end
  # Задание 23 shoot c
  def shoot c
    x = c[0]
    y = c[1]
    if @field[x][y] == nil
      "miss"
    else
      first = @field[x][y].explode
      if first == nil
        "wounded"
      else
        refresh
        "killed #{first}"
      end
    end
  end
  # Задание 24 cure
  def cure
    @allships.each {|x| x.cure}
  end
  # Задание 25 game_over?
  def game_over?
    @allships.empty?
  end
  # Задание 26 move l_move
  def move l_move
    if l_move[1] > 0 && l_move[1] < 4
      @allships[l_move[0]].rotate(l_move[2], l_move[1])
    else
      if l_move[2] == 1
        @allships[l_move[0]].move(true)
      else
        @allships[l_move[0]].move(false)
      end
    end
  end
end
# конец описания класса BattleField
################################################################################


################################################################################
# Задания 27-33
# Класс Player
################################################################################
class Player
  attr_accessor :manual

  def reset
    @allshots = []
    @lastshots = []
  end

  def initialize(name, manual = true)
    @name = name
    @manual = manual
    @lastsample = [1, 0]
    reset
  end

  # Задание 28 random_point
  def to_s
   @name
  end
  # Задание 29 random_point
  def random_point
    [rand(Field.size - 1), rand(Field.size - 1)]
  end
  # Задание 30 place_strategy ship_list

  # Дополнительный метод генерирующий случайные координаты
  def generation elem
    ran = random_point.push ([true, false].sample)
    if @h.free_space?(elem[1], ran[0], ran[1], ran[2], elem[0])
      @h.set!(elem[1], ran[0], ran[1], ran[2], elem[0])
      @mass.push ([elem[0], ran[0], ran[1], ran[2]])
    else
      generation elem
    end
  end

  def place_strategy ship_list
    @mass = []
    @h = Field.new
    sorted = ship_list.sort {|x, y| y[1] <=> x[1]}
    sorted.map {|i| generation i}
    @mass
  end
  # Задание 31 hit message
  def hit message
    @lastshots.push([@shot, message])
  end
  #            miss
  def miss
    @lastshots.push([@shot, "miss"])
    @allshots.push(@lastshots)
    @lastshots = []
  end
  # Задание 32 shot_strategy
  def shot_strategy
    if @manual
      @lastshots.each {|x| print(x, "\n")}
      puts "Make a shot. To switch off the manual mode enter -1 for any coordinate"
      while true
        print "x = "; x = gets.to_i; print x
        print " y = "; y = gets.to_i; puts y
        shot = [x,y]
        if shot.all? {|a| a.between?(-1, Field.size - 1)}
          break
        else
          puts "Incorrect input"
        end
      end
      if shot.any? {|a| a == -1}
        @manual = false
        shot_strategy
      else
        @shot = shot
      end
    else
      # Здесь необходимо разместить решение задания 30
      if @lastshots.empty? || @lastshots[-1][1].start_with?("killed")
        @shot = random_point
      else
        if @lastshots[-1][1] == "wounded"
          if @lastshots.length == 1 || @lastshots[-2][1].start_with?("killed")
            @lastsample = [[-1, 0], [0, -1], [1, 0], [0, 1]].sample
            @shot = @shot.add @lastsample
          else
            @shot = @shot.add @lastsample
          end
        end
      end
      (0..1).each do |i| 
        if !@shot[i].between?(0, Field.size - 1)
          @lastsample[i] *= -1 
          @shot = (@shot.add @lastsample).add @lastsample
        end
      end
      if @lastshots.find {|i| i[0] == @shot}
        shot_strategy
      else
        @shot
      end
      # конец решения задания 30
    end
  end

  # Задание 33 ship_move_strategy remains
  def ship_move_strategy remains
    if @manual
      puts "Ship health"
      tmp_field = Field.new
      names = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a
      ship_hash = {}
      remains.each do |ship|
        name = names[ship[0]]
        x = ship[1][0]; y = ship[1][1]
        hor = (ship[1][1] == ship[1][3])
        ship_hash[name] = [ship[0], ship[2]]
        tmp_field.set!(ship[2], x, y, hor, name)
        print(name, " - ", ship[3], "%\n") 
      end
      puts "Your ships"
      tmp_field.print_field
      puts "Make a move. To switch off the manual mode enter an incorrect ship name"
      while true
        print "Choose ship: "; 
        name = gets.strip; puts name
        if !ship_hash[name] then break end
        move = 0
        begin
          print "Enter 0 to move, 1-3 to rotate: " 
          move = gets.to_i; puts move
        end until move.between?(0,3)
        if move == 0
          print "1 - forward/any - backward): "; dir = gets.to_i
          puts dir
        else
          dir = 0
          begin
            print "Choose a center point: (1..#{ship_hash[name][1]}): "
            dir = gets.to_i; puts dir
          end until dir.between?(1,ship_hash[name][1])
        end
        break
      end
      if !ship_hash[name]
        @manual = false
        ship_move_strategy remains
      else
        [ship_hash[name][0], move, dir]
      end
    else
      # Здесь необходимо разместить решение задания 31
      remains.sort! {|x, y| x[3] <=> y[3]}
      first = remains[0]
      puts first
      [first[0], rand(0..3), rand(1..first[2])]
      # конец решения задания 31
    end
  end 

end
# конец описания класса Player
################################################################################

################################################################################
# Задания 34-35 
# Класс Game
################################################################################
class Game

  def initialize(player_1, player_2)
    @game_over = false
    @players = [[player_1, BattleField.new, 0], [player_2, BattleField.new, 0]]
    @players.map {|p| reset p}
    @players.shuffle!
  end

  def reset p
    puts "#{p[0]} game setup"
    p[0].reset
    if p[1].place_fleet (p[0].place_strategy (p[1].fleet))
      puts "Ships placed"
    else
      raise "Illegal ship placement"
    end
  end
  # Задание 35 start

  def start
    lastshots = []
    while !@game_over
      @players[0][2] += 1
      puts "Step #{@players[0][2]} of player #{@players[0][0]}"
      @players[0][1].cure
      btlfld = @players[0][0].ship_move_strategy (@players[0][1].remains)
      @players[0][1].move btlfld
      cord = @players[0][0].shot_strategy
      if lastshots.find {|i| i == cord}
        puts "Illegal shot"
        res = "miss"
      else
        lastshots.push cord
        res = @players[1][1].shoot cord
      end
      puts "#{cord} #{res}"
      if res == "miss"
        @players[0][0].miss
        @players.reverse!
        lastshots = []
      else
        @players[0][0].hit res
        @game_over = @players[1][1].game_over?
        if @game_over
            puts "Player #{@players[0][0]} wins!"
        end
      end
    end
  end
end
# конец описания класса Game
################################################################################

################################################################################
# Переустановка датчика случайных чисел
################################################################################
srand
################################################################################

#№ Пример запуска
# p1 = Player.new("Ivan", false)
# p2 = Player.new("Feodor", false)
# g = Game.new(p1,p2)
# g.start

>>>>>>> fd03a34f72553a012fabe6c814c809c76a202115
