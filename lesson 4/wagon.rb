class Wagon
  include Company
  attr_reader :type

  def initialize(company)
    @company_name = company
  end
end
