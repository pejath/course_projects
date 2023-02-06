# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_accessor :trains
  attr_reader :name

  validate :name, :presence

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end

  def task_method(&block)
    @trains.each do |train|
      block.call(train)
    end
  end

  def self.all
    @@stations
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
