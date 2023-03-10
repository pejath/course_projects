# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  validate :stations, :type, Station
  def initialize(start_station, final_station)
    @stations = [start_station, final_station]
    validate!
  end

  def add_station(station)
    @stations.insert(-2, station) unless [@stations.first, @stations.last].include?(station)
  end

  # изучив вопрос выяснилось, что .last работает быстрее [-1]
  def remove_station(station)
    @stations.delete(station) unless [@stations.first, @stations.last].include?(station)
  end
end
