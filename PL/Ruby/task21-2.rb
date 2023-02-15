class BankAccount

  # массив со всеми счетами 
  @@all_users = []
  # инициализация банковского счета
  # номер счета, владелец счета, процент - обязательные параметры
  def initialize bankaccnum, accholder, percent
    @bankaccnum = bankaccnum
    @accholder = accholder
    @percent = (100 + percent) / 100.0
    # параметр, отвечающий за количество денег на счету
    @moneyonacc = 0 
    # массив, хранящий информацию о всех операциях по счету
    @operation = []
    # массив, в котором хранятся все счета одного клиента
    @accholder.accounts.push self
    # массив, в котором хранятся все счета
    @@all_users.push self
  end

  # метод для внесения суммы на счет
  def deposit (sum)
    # если количество денег у владельца счета на руках больше или равно, чем 
    # вносимая сумма, то количество денег на счету соответсвенно увеличивается,
    # в массив операций заносится информация, у владельца уменьшается сумма
    # наличных
    if sum <= @accholder.moneyhand
      @moneyonacc += sum
      @operation.push ("Deposit to a account: #{sum}")
      @accholder.salary (-sum)
    end
    self
  end

# метод для вывода средств
  def withdraw (sum)
    # если средств на счету достаточно для вывода, то у владельца увеличивается 
    # сумма налички, уменьшается сумма на счету, в массив заносится информация 
    # об операции
    if @moneyonacc >= sum
      @accholder.salary sum
      @moneyonacc -= sum
      @operation.push ("Withdrawal from a account: #{sum}")
    end
    self
  end

# метод вывод информацию о счете клиента
  def to_s
    "Account Holder: #{@accholder}, account number: #{@bankaccnum},
     money on account: #{@moneyonacc}"
  end

# метод закрытия периода
  def self.close_period
    @@all_users.map {|i| i.close_period}
  end

# метод, выводящий информацию о всех счетах
  def self.stat
    puts @@all_users
  end
# метод, выводящий все операции по счету
  def stat
    puts @operation
  end

end

class DepositAccount < BankAccount
  # инициализация банковского счета
  # номер счета, владелец счета, процент - обязательные параметры
  def initialize bankaccnum, accholder, percent, first
    super bankaccnum, accholder, percent
    # переменная first - первый депозит, на который накладываются проценты
    @first = first
    # соответсвенно, сумма на счету будет равна первому депозиту
    @moneyonacc = @first
    # массив, хранящий информацию о всех операциях по счету
    @operation = []
    # сумма всех внесенных денег за период
    @in = 0
    # сумма всех выведенных денег за период
    @out = 0
  end

  # метод для внесения суммы на счет
  def deposit (sum)
    # если количество денег у владельца счета на руках больше или равно, чем 
    # вносимая сумма, то количество денег на счету соответсвенно увеличивается,
    # в массив операций заносится информация, у владельца уменьшается сумма
    # наличных, в переменную in заносится внесенная сумма
    if sum <= @accholder.moneyhand
      @in += sum
      @moneyonacc += sum
      @operation.push ("Deposit to a account: #{sum}")
      @accholder.salary (-sum)
    end
    self
  end

  # метод для вывода средств
  def withdraw (sum)
    # если средств на счету достаточно для вывода, то у владельца увеличивается 
    # сумма налички, уменьшается сумма на счету, в массив заносится информация 
    # об операции, в переменную out заносится выведенная сумма
    if @moneyonacc >= sum
      @out += sum
      @accholder.salary sum
      @moneyonacc -= sum
      @operation.push ("Withdrawal from a account: #{sum}")
    end
    self
  end

  # метод закрытия периода
  def close_period
    # начисленный процент, с учетом вывода
    procent = (@first - @out) * @percent
    # сумма, на которую будут начисляться проценты в следующем периоде
    @first = procent + @in
    # обновленная сумма на счету
    @moneyonacc = @first
    # обнуление счетчиков с началом нового периода
    @in = 0
    @out = 0
  end

  # метод вывод информацию о счете клиента
  def to_s
    "Account Holder: #{@accholder}, account number: #{@bankaccnum}, 
     money on account: #{@moneyonacc}"
  end

  # метод, выводящий информацию о всех счетах
  def self.stat
    puts @@all_users
  end

  # метод, выводящий все операции по счету
  def stat
    puts @operation
  end

end

class CreditAccount < BankAccount
  # инициализация банковского счета
  # номер счета, владелец счета, процент - обязательные параметры
  def initialize bankaccnum, accholder, percent
    super bankaccnum, accholder, percent
    # непогашенные проценты за прошлый период
    @outstanding_percent = 0
    # проценты, при которых блокируется счет(т.е. непогашенные проценты за
    # позапрошлый период)
    @percent_for_blocking = 0 
    # сумма на счету в данном случае используется как сумма взятого кредита,
    # который надо погасить
    @moneyonacc = 0
    # массив, хранящий информацию о всех операциях по счету
    @operation = []
  end

  # метод инициализации кредита
  def credit(sum)
    @moneyonacc = sum
  end

  # вспомогательный метод для проверки непогашенных процентов
  def deposit_plus (sum)
    # Проверяется условие непогашенных процентов за прошлый период
    # если их нет, то гасится основная часть кредита, в массив заносится 
    # информация об операции, сумма наличных у владельца уменьшается.
    # Если непогашенные проценты есть и они меньше либо равны вносимой суммы, то
    # сумма наличных у владельца уменьшается, из вносимой суммы вычитаются
    # непогашенные проценты, непогашенные проценты обнуляются, размер кредита 
    # уменьшается на оставшуюся сумму, в массив заносится информация об операции
    # Иначе, если непогашенные проценты больше, то они уменьшаются на значение 
    # sum, сумма наличных у владельца уменьшается в массив заносится 
    # информация об операции
    if sum <= @accholder.moneyhand
        if @outstanding_percent == 0
          @moneyonacc -= sum
          @operation.push ("Deposit to a account: #{sum}")
          @accholder.salary (-sum)
        else
          if @outstanding_percent <= sum
            @accholder.salary (-sum)
            sum -= @outstanding_percent
            @outstanding_percent = 0
            @moneyonacc -= sum
            @operation.push ("Deposit to a account: #{sum}")
          else
            @outstanding_percent -= sum
            @accholder.salary (-sum)
            @operation.push ("Deposit to a account: #{sum}")
          end
        end
    end
    self
  end
  # метод для внесения суммы на счет
  def deposit (sum)
    # если количество денег у владельца счета на руках больше или равно, чем 
    # вносимая сумма, то проверяется условие отсутсвия процентов за позапрошлый 
    # период и вызывается вспомогательный метод.
    if sum <= @accholder.moneyhand
      if @percent_for_blocking == 0
        deposit_plus(sum)
      else
        if @percent_for_blocking <= sum
          @percent_for_blocking = 0
          sum = sum - @percent_for_blocking
          deposit_plus(sum)
        else 
            @percent_for_blocking -= sum
            @accholder.salary (-sum)
            @operation.push ("Deposit to a account: #{sum}")
        end
      end
    end
    self
  end

  # метод для вывода средств
  def withdraw (sum)
    # если проценты для блокировки отсутствуют, то сумма наличных у владельца 
    # увеличивается, сумма кредита увеличивается, в массив заносится информация
    # об операции, иначе выдается ошибка о непогашенных процентах за позапрошлый
    # период
    if @percent_for_blocking == 0
        @accholder.salary sum
        @moneyonacc += sum
        @operation.push ("Withdrawal from a account: #{sum}")
    else
      "Error! Outstanding Percent. Account is blocked"
    end
    self
  end
  # метод закрытия периода
  def close_period
    # к непогашенным процентам за позапрошлый период прибавляются непогашенные 
    # проценты за прошлый период
    # перерасчитываются непогашенные проценты
    # сумма кредита увеличивается
    @percent_for_blocking += @outstanding_percent
    @outstanding_percent = @moneyonacc * (@percent - 1)
    @moneyonacc = @moneyonacc * @percent
  end

  # метод вывод информацию о счете клиента
  def to_s
    "Account Holder: #{@accholder}, account number: #{@bankaccnum},
    money on account: #{@moneyonacc}"
  end

  # метод, выводящий информацию о всех счетах
  def self.stat
    puts @@all_users
  end

  # метод, выводящий все операции по счету
  def stat
    puts @operation
  end

end

class Client
  # геттер для имени клиента
  attr_reader :name, :moneyhand

  attr_accessor :accounts

  # инициализация банковского счета
  # имя клиента и его деньги - обязательные параметры
  def initialize name, money
    @name = name
    @moneyhand = money
    # массив для всех счетов клиента
    @accounts = []
  end

# метод увеличения налички у клиента
  def salary (sum)
    @moneyhand += sum
    self
  end

# метод выводящий клинта и его сумму
  def to_s
    "#{@name}, cash on hand: #{@moneyhand}"
  end

# метод, выдающий все счета клиента
  def stat
    puts @accounts.map {|x| x.to_s}
  end

end

class Test

  def self.test
    # Создание клиентов
    x = Client.new("Egor", 1232)
    y = Client.new("Alexey", 8467)
    z = Client.new("Alexandr", 0)
    puts "Метод to_s"
    puts x.to_s
    puts y.to_s
    puts z.to_s
    puts "Метод salary"
    x.salary 122
    y.salary 8654
    z.salary 241
    puts x.to_s
    puts y.to_s
    puts z.to_s
    puts "============================================================="
    puts "Класс DepositAccount"
    x1 = DepositAccount.new(3421, x, 25, 34198)
    y1 = DepositAccount.new(8345, y, 45, 28310)
    z1 = DepositAccount.new(2312, z, 11, 12412)
    puts "Счёт при создании"
    puts x1.to_s
    puts y1.to_s
    puts z1.to_s
    x1.deposit 241
    x1.withdraw 777
    y1.withdraw 124
    y1.deposit 90
    z1.withdraw 865
    z1.deposit 436
    puts "Произведенные операции"
    x1.stat
    y1.stat
    z1.stat
    puts "Счет после различных операций"
    puts x1.to_s
    puts y1.to_s
    puts z1.to_s
    x1.close_period
    y1.close_period
    z1.close_period
    puts "Счет после закрытия"
    puts x1.to_s
    puts y1.to_s
    puts z1.to_s
    puts "============================================================="
    puts "Класс CreditAccount"
    x1_1 = CreditAccount.new(1124, x, 25)
    y1_1 = CreditAccount.new(7542, y, 71)
    z1_1 = CreditAccount.new(3943, z, 32)
    puts "Счёт при создании"
    puts x1_1.to_s
    puts y1_1.to_s
    puts z1_1.to_s
    puts "Оформление кредита и счёт после этого"
    x1_1.credit 120000
    y1_1.credit 200000
    z1_1.credit 64500
    puts x1_1.to_s  
    puts y1_1.to_s 
    puts z1_1.to_s 
    x1_1.deposit 32
    x1_1.withdraw 521
    y1_1.withdraw 812
    y1_1.deposit 111
    z1_1.withdraw 861
    z1_1.deposit 923
    puts "Произведенные операции"
    x1_1.stat
    y1_1.stat
    z1_1.stat
    puts "Счет после различных операций"
    puts x1_1.to_s
    puts y1_1.to_s
    puts z1_1.to_s
    x1_1.close_period
    y1_1.close_period
    z1_1.close_period
    puts "Счет после закрытия"
    puts x1_1.to_s
    puts y1_1.to_s
    puts z1_1.to_s
    puts "============================================================="
    puts "Все счета всех клиентов"
    BankAccount.stat
    BankAccount.close_period
    puts "Все счета одного клиента"
    x.stat
    y.stat
    z.stat
  end

end

puts Test.test