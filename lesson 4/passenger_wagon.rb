class PassengerWagon < Wagon
  attr_reader :passengers

  def initialize(attributes = {})
    super
    @type = :passenger
  end

  def add_passenger
    raise 'not enough seats' if @occupied_capacity + 1 > @full_capacity

    @occupied_capacity += 1
  end
end
