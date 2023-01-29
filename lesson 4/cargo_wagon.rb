class CargoWagon < Wagon
  def initialize(company)
    super
    @type = :cargo
  end
end
