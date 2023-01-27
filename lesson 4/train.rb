class Train
  attr_accessor :speed, :route
  attr_reader :wagons, :number, :type

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @current_station_index = 0
  end

  def route=(route)
    @route = route
    route.stations[0].add_train(self)
  end

  def add_wagon(wagon)
    @speed != 0 ? puts 'train is moving' : @wagons << wagon
  end

  def remove_wagon(wagon)
    if @speed.zero?
      @wagons.delete(wagon)
    else
      puts 'check speed or wagons count'
    end
  end

  def move_to_next_station
    return 'Firstly add route' if @route.nil?

    if next_station
      current_station.send_train(self)
      next_station.add_train(self)
      @current_station_index += 1
    else
      puts 'You are on the last station'
    end
  end

  def move_to_prev_station
    return puts 'Firstly add route' if @route.nil?

    if previous_station
      current_station.send_train(self)
      previous_station.add_train(self)
      @current_station_index -= 1
    else
      puts 'You are on the first station'
    end
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def next_station
    @route.stations[@current_station_index + 1] if @current_station_index + 1 <= @route.stations.count - 1
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
