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
