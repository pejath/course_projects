class Wagon
  include Company
  attr_reader :type

  def initialize(company_name)
    @company_name = company_name
  end
end
