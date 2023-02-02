# frozen_string_literal: true

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(start_station, final_station)
    @stations = [start_station, final_station]
    validate!
  end

  def validate!
    raise 'Should be at least 2 stations on route' if stations.size < 2
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    @stations.insert(-2, station) unless [@stations.first, @stations.last].include?(station)
  end

  # изучив вопрос выяснилось, что .last работает быстрее [-1]
  def remove_station(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end
end
