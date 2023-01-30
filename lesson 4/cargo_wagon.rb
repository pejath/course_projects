class CargoWagon < Wagon
  def initialize(company_name)
    super
    @type = :cargo
  end
end
