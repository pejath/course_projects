class Wagon
  include Company
  attr_reader :type, :number

  def initialize(attributes = {})
    @number = rand(1..100)
    @company_name = attributes[:company_name]
    validate!
  end

  def validate!
    raise 'Company name can\'t be empty' if @company_name.nil?
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
