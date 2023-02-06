# frozen_string_literal: true

class Wagon
  include Company
  include Validation
  attr_reader :type, :number

  validate :company_name, :presence
  validate :full_capacity, :presence
  def initialize(attributes = {})
    @number = rand(1..100)
    @company_name = attributes[:company_name]
    @full_capacity = attributes[:full_capacity]
    @occupied_capacity = 0
    validate!
  end

  def empty_capacity
    @full_capacity - @occupied_capacity
  end
end
