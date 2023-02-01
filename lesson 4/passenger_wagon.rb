class PassengerWagon < Wagon
  attr_reader :passengers

  def initialize(attributes = {})
    @type = :passenger
    @seats_number = attributes[:seats_number]
    @passengers = 0
    super
  end

  def add_passenger
    @passengers += 1 if @passengers + 1 <= @seats_number
  end

  def empty_seats
    @seats_number - @passengers
  end

  def validate!
    errors = []
    errors << 'Company name can\'t be empty' if @company_name.nil?
    errors << 'Seats Number name can\'t be empty' if @seats_number.nil?
    raise errors.join('. ') unless errors.empty?
  end
end
