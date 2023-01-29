class ControlClass
  attr_reader :stations, :trains, :wagons, :routes

  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []

    puts 'write \'help\' for additional commands'
  end

  def start
    print '-> '
    command = gets.chomp

    case command
    when 'help'
      puts "\t1 - create station \n \t2 - create train \n \t3 - route menu \n \t4 - set route for train \n \t5 - wagon menu
  \t6 - move train \n \t7 - show stations"
    when '1'
      create_station
    when '2'
      puts "select option \n \t1 - passenger train \n \t2 - cargo train \n \tENTER for exit"
      create_train(gets.chomp)
    when '3'
      puts "select option \n \t1 - create new route \n \t2 - for adding stations for existing route
  \t3 - for removing stations from route \n \tENTER for exit"
      case gets.chomp
      when '1'
        create_route
      when '2'
        add_route
      when '3'
        remove_route
      end
    when '4'
      add_train_route
    when '5'
      puts "select option \n \t1 - create new wagon \n \t2 - for adding wagon for existing train
  \t3 - for removing wagon for existing train \n \tENTER for exit"
      case gets.chomp
      when '1'
        puts "select option \n \t1 - passenger wagon \n \t2 - cargo wagon \n \tENTER for exit"
        create_wagon(gets.chomp)
      when '2'
        add_wagon
      when '3'
        remove_wagon
      end
    when '6'
      move_train
    when '7'
      @stations.each do |station|
        puts station.name
        print "\t" + station.trains.map(&:number).join(', ') + "\n"
      end
    when 'exit'
      return
    else
      return start if command.empty?

      puts "There is no command: '#{command}', write 'help' to check commands"
    end
    start
  end

  def stations_list
    puts @stations.map(&:name).join(', ')
  end

  def routes_list
    puts @routes
  end

  def trains_list
    puts @trains.map(&:number)
  end

  # все методы которые ниже были отделены в private по сокльку пользователь не должен на прямую с ними взаимодействовать
  # поскольку для этого есть интерфейс
  private

  def input_check(type = nil, &block)
    loop do
      print '-> '
      res = gets.chomp
      return nil if res == 'exit'

      if block_given? && res.match(/[a-zA-Z]+/) || res.strip.empty?
        puts 'Write correct index'
        next
      end

      res = block.call(res) if block_given?
      case res
      when String
        return res unless res.strip.empty?

        puts 'Value can\'t be empty (exit for stop)'
      when Array
        return res
      when Integer

        return type[res] unless type[res].nil?

        puts 'Write correct index'
      else
        puts 'Something went wrong'
        return nil
      end
    end
  end

  def create_station
    print 'write station name: '
    station_name = input_check
    return if station_name.nil?

    @stations << Station.new(station_name)
  end

  def create_train(command)
    return unless ['1', '2'].include?(command)

    print 'write train number: '
    num = input_check
    return if num.nil?

    name = input_check
    return if name.nil?

    case command
    when '1'
      @trains << PassengerTrain.new(num, name)
    when '2'
      @trains << CargoTrain.new(num, name)
    end
  end

  def create_route
    stations_list
    puts 'for selecting the first and the last stations'
    print 'first: '
    first = input_check(@stations, &:to_i)
    print 'last: '
    last = input_check(@stations, &:to_i)

    @routes << Route.new(first, last)
  end

  def add_route
    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)
    stations_list
    puts 'write stations you want to add separated by a space'
    lmbd = ->(str) { str.split.map(&:to_i) }
    stations = input_check(&block = lmbd)
    stations.each do |station|
      next if @stations[station].nil?

      route.add_station(@stations[station])
    end
  end

  def remove_route
    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)
    puts route.stations.map(&:name)
    puts 'write stations you want to remove separated by a space'
    lmbd = ->(str) { str.split.map(&:to_i).uniq.sort.reverse }
    stations = input_check(&block = lmbd)
    stations.each do |station|
      route.remove_station(route.stations[station])
    end
  end

  def add_train_route
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)
    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)

    train.route = route
  end
  def create_wagon(command)
    return unless ['1', '2'].include?(command)

    print 'write wagon\' company name: '
    name = input_check
    return if name.nil?

    case command
    when '1'
      @wagons << PassengerWagon.new(name)
    when '2'
      @trains << CargoWagon.new(name)
    end
  end

  def add_wagon
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)

    puts @wagons
    puts 'select wagon you want to add separated by spaces (will be added only uniq wagons)'
    lmbd = ->(str) { str.split.map(&:to_i).uniq }
    wagons = input_check(&block = lmbd)

    wagons.each do |num|
      train.add_wagon(@wagons[num])
    end
  end

  def remove_wagon
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)

    puts train.wagons
    puts 'select wagon you want to remove separated by spaces'
    lmbd = ->(str) { str.split.map(&:to_i).uniq.sort.reverse }
    wagons = input_check(&block = lmbd)

    wagons.each do |num|
      train.remove_wagon(train.wagons[num])
    end
  end

  def move_train
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)

    puts 'select where train goes \'forward\', \'backward\' '
    case gets.chomp
    when 'forward'
      train.move_to_next_station
    when 'backward'
      train.move_to_prev_station
    end
  end
end
