# frozen_string_literal: true

class CargoTrain < Train
  validate :speed, :type, Integer
  validate :company_name, :presence
  validate :number, :format, NUMBER_REGEX
  def add_wagon(wagon)
    return unless wagon.is_a? CargoWagon

    super
  end
end
