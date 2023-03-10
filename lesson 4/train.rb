# frozen_string_literal: true

class Train
  include Company
  include Validation
  extend Accessors
  include InstanceCounter

  attr_accessor_with_history :speed
  attr_reader :wagons, :number, :type, :route

  NUMBER_REGEX = /^\w{3}-?\w{2}$/i.freeze

  validate :number, :format, NUMBER_REGEX
  validate :number, :presence
  validate :company_name, :presence
  validate :speed, :type, Integer

  @@trains = []
  def initialize(number, company_name)
    @number = number
    @company_name = company_name
    @wagons = []
    @speed = 0
    @current_station_index = 0
    validate!
    @@trains << self
    register_instance
  end

  def self.find(num)
    @@trains.find { |train| train.number == num }
  end

  def task_method(&block)
    @wagons.each(&block)
  end

  def route=(route)
    @route = route
    route.stations[0].add_train(self)
  end

  def add_wagon(wagon)
    @speed != 0 ? (raise 'You can\'t remove wagons while moving') : @wagons << wagon
  end

  def remove_wagon(wagon)
    if @speed.zero?
      @wagons.delete(wagon)
    else
      raise 'You can\'t remove wagons while moving' unless @speed.zero? # стоило ли это переделывть с puts...
      raise 'There is no wagons' if wagons.size.zero?
    end
  end

  def move_to_next_station
    raise 'Firstly add route' if @route.nil?

    if next_station
      current_station.send_train(self)
      next_station.add_train(self)
      @current_station_index += 1
    else
      puts 'You are on the last station'
    end
  end

  def move_to_prev_station
    raise 'Firstly add route' if @route.nil?

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
