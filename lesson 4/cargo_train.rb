# frozen_string_literal: true

class CargoTrain < Train
  def add_wagon(wagon)
    return unless wagon.is_a? CargoWagon

    super
  end
end
