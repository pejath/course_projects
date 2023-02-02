# frozen_string_literal: true

class Wagon
  include Company
  attr_reader :type, :number

  def initialize(attributes = {})
    @number = rand(1..100)
    @company_name = attributes[:company_name]
    @full_capacity = attributes[:full_capacity]
    @occupied_capacity = 0
    validate!
  end

  def validate!
    errors = []
    errors << 'Company name can\'t be empty' if @company_name.nil?
    errors << 'Full Capacity name can\'t be empty' if @full_capacity.nil?
    raise errors.join('. ') unless errors.empty?
  end

  def empty_capacity
    @full_capacity - @occupied_capacity
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
