class PassengerWagon < Wagon
  def initialize(company_name)
    super
    @type = :passenger
  end
end
