class Wagon
  include Company
  attr_reader :type

  def initialize(company_name)
    @company_name = company_name
    validate!
  end

  def validate!
    raise 'Company name can\'t be empty' if company_name.nil?
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
