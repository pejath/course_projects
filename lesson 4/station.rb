class Station
  include InstanceCounter

  attr_accessor :trains
  attr_reader :name
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
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
