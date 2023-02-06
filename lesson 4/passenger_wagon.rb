# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :passengers

  validate :company_name, :presence
  validate :full_capacity, :presence
  def initialize(attributes = {})
    super
    @type = :passenger
  end

  def add_passenger
    raise 'not enough seats' if @occupied_capacity + 1 > @full_capacity

    @occupied_capacity += 1
  end
end
