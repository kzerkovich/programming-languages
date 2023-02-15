class MyConditioner < Conditioner
end


class MyHeater < Heater 
  # метод изменения такта работы обогревателя
  def change_tact value
    @tact = value
  end
end


class MyClimateControl < ClimateControl

  # метод включения/выключения первого и второго обогревателей
  # Если температура ниже нормы, то включается первый обогреватель.
  # Если температура ниже нормы на 4 и более градуса включаются оба обогревателя
  # При возврате к нормальной темпертуре выключаются оба.
  def check_heater
    temp = @home.temperature
    if temp > @heater_start
      @home.first_heater.set_off
      @home.second_heater.set_off
    end
    if  temp.between?(@heater_start - 4, @heater_start)
      @home.first_heater.set_on
    end
    if temp < @heater_start - 4
      @home.first_heater.set_on
      @home.second_heater.set_on
    end
  end

end


class MyReporter < Reporter

  # формирование строки с текущими статусами обогревателей
  def heater_status_s
    "first heater: " + bool_to_on_off_s(@home.first_heater.status) +
    " second heater: " + bool_to_on_off_s(@home.second_heater.status)
  end

end


class MyWeather < Weather

  # метод создания нового циклона
  def new_cyclon
    MyCyclon.new_cyclon self
  end

end

class MyCyclon < Cyclon

  # массив циклонов из исходного массива с добавлением своих значений
  MyCyclons = Cyclons + [[-2.8, -2.1, -1.4, -0.7, 0, 0.7, 1.4, 2.1]]

  # метод создания нового циклона для симулятора погоды weather
  def self.new_cyclon weather
    MyCyclon.new(MyCyclons.sample, weather)
  end

end

class MyGlasshouse < Glasshouse

  # метод создания нового симулятора погоды
  def set_weather
    @weather = MyWeather.new
  end

  # метод установки параметров теплицы
  def set_glasshouse
    # новый кондиционер
    @conditioner = MyConditioner.new self
    # новая система климат-контроля
    @climate_control = MyClimateControl.new(self, 15, 25)
    # новая метеостанция
    @reporter = MyReporter.new self
    # первый обогреватель
    @first_heater = MyHeater.new self
    # второй обогреватель
    @second_heater = MyHeater.new self
    # изменение такта работы первого обогревателя
    @first_heater.change_tact 0.4
    # изменение такта работы второго обогревателя
    @second_heater.change_tact 0.2
  end

  #метод получения списков процессов всех устройств
  def list_of_processes
    all_system = [@weather, @conditioner, @first_heater, @second_heater,
                  @climate_control, @reporter]
    all_system.map { |syst| syst.get_runner }
  end

  # селектор первого обогревателя
  def first_heater
    @first_heater
  end

  # селектор второго обогревателя
  def second_heater
    @second_heater
  end

  # селектор температуры теплицы
  def temperature
    # складывается как изменение температуры, вследствие погоды
    # минус изменение, сгенерированное кондиционером
    # плюс изменение, сгенерированное обогревателями
    @weather.temperature - @conditioner.change +
    @first_heater.change + @second_heater.change
  end

end

