class CargoWagon < Wagon
  attr_reader :space

  def initialize(attributes = {})
    @type = :cargo
    @full_capacity = attributes[:full_capacity]
    @space = 0
    super
  end

  def add_weight(capacity)
    raise 'Not enough space' if @space + capacity >= @full_capacity

    @space += capacity
  end

  def free_capacity
    @full_capacity - @space
  end

  def validate!
    errors = []
    errors << 'Company name can\'t be empty' if @company_name.nil?
    errors << 'Full Capacity name can\'t be empty' if @full_capacity.nil?
    raise errors.join('. ') unless errors.empty?
  end
end
