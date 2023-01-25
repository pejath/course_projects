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

  def train_types
    cargo = @trains.count { |train| train.type == 'cargo' }
    passenger = @trains.count { |train| train.type == 'passenger' }
    { cargo: cargo, passenger: passenger }
  end
end

class Route
  attr_reader :start_station, :final_station

  def initialize(start_station, final_station)
    @start_station = start_station
    @final_station = final_station
    @way_station = []
  end

  def add_station(station)
    @way_station << station
  end

  def remove_station(station_name)
    @way_station.delete_if { |station| station.name == station_name }
  end

  def full_way
    ([@start_station] << @way_station << @final_station).flatten
  end
end

class Train
  attr_accessor :speed, :route
  attr_reader :vans_count, :number, :type

  def initialize(number, type, vans_count = 0)
    @number = number
    @type = type
    @vans_count = vans_count
    @speed = 0
    @route_station = 0
  end

  def route=(route)
    @route = route
    @station = @route.full_way[@route_station]
    route.start_station.add_train(self)
  end

  def add_van
    @speed != 0 ? 'train is moving' : @vans_count += 1
  end

  def remove_van
    if @speed.zero? && @vans_count != 0
      @vans_count -= 1
    else
      'check speed or vans count'
    end
  end

  def next_station
    return 'Firstly add route' if @route.nil?

    if @route_station + 1 > @route.full_way.count - 1
      'You are on the last station'
    else
      @station.send_train(self)
      @route_station += 1
      @station = @route.full_way[@route_station]
      @station.add_train(self)
    end
  end

  def previous_station
    return 'Firstly add route' if @route.nil?

    if (@route_station - 1).negative?
      'You are on the first station'
    else
      @station.send_train(self)
      @route_station -= 1
      @station = @route.full_way[@route_station]
      @station.add_train(self)
    end
  end

  def near_stations
    puts "previous #{@route.full_way[@route_station - 1].name}" if @route_station - 1 >= 0
    puts "current #{@route.full_way[@route_station].name}"
    if @route_station + 1 <= @route.full_way.count - 1
      puts "next #{@route.full_way[@route_station + 1].name}"
    end
  end

  def speed_up
    @speed += 10
  end

  def break
    @speed = 0
  end
end
