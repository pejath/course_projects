class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def train_count_types_by(type)
    @trains.count { |train| train.type == type }
  end

  def train_types_by(type)
    @trains.select { |train| train.type == type }
  end
end

class Route
  attr_reader :stations

  def initialize(start_station, final_station)
    @stations = [start_station, final_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  # изучив вопрос выяснилось, что .last работает быстрее [-1]
  def remove_station(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end
end

class Train
  attr_accessor :speed, :route
  attr_reader :wagons_count, :number, :type

  def initialize(number, type, wagons_count = 0)
    @number = number
    @type = type
    @wagons_count = wagons_count
    @speed = 0
    @current_station_index = 0
  end

  def route=(route)
    @route = route
    route.stations[0].add_train(self)
  end

  def add_wagon
    @speed != 0 ? 'train is moving' : @wagons_count += 1
  end

  def remove_wagon
    if @speed.zero? && @wagons_count != 0
      @wagons_count -= 1
    else
      'check speed or wagons count'
    end
  end

  def move_to_next_station
    return 'Firstly add route' if @route.nil?

    if next_station
      current_station.send_train(self)
      next_station.add_train(self)
      @current_station_index += 1
    else
      'You are on the last station'
    end
  end

  def move_to_prev_station
    return 'Firstly add route' if @route.nil?

    if previous_station
      current_station.send_train(self)
      previous_station.add_train(self)
      @current_station_index -= 1
    else
      'You are on the first station'
    end
  end

  def next_station
    @route.stations[@current_station_index + 1] if @current_station_index + 1 <= @route.stations.count - 1
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @current_station_index - 1 >= 0
  end

  def speed_up
    @speed += 10
  end

  def break
    @speed = 0
  end
end
