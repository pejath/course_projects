# frozen_string_literal: true

class CargoWagon < Wagon
  attr_reader :space

  validate :company_name, :presence
  validate :full_capacity, :presence
  def initialize(attributes = {})
    super
    @type = :cargo
  end

  def add_weight(capacity)
    raise 'Not enough space' if @occupied_capacity + capacity > @full_capacity

    @occupied_capacity += capacity
  end
end
