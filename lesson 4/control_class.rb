# frozen_string_literal: true

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
      puts "\t1 - create station \n \t2 - create train \n \t3 - route menu \n \t4 - set route for train
  \t5 - wagon menu \n \t6 - move train \n \t7 - show stations \n \t9 - show station info \n \t9 - show train info"
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
  \t3 - for removing wagon from existing train \n \t4 - for space manipulation in wagon \n \tENTER for exit"
      case gets.chomp
      when '1'
        puts "select option \n \t1 - passenger wagon \n \t2 - cargo wagon \n \tENTER for exit"
        create_wagon(gets.chomp)
      when '2'
        add_wagon
      when '3'
        remove_wagon
      when '4'
        space_manipulation
      end
    when '6'
      move_train
    when '7'
      @stations.each do |station|
        puts station.name
        print "\t#{station.trains.map(&:number).join(', ')}\n"
      end
    when '8'
      stations_list
      stations = input_check(@stations, &:to_i)
      return start if stations.nil?

      meth = proc { |train|
        puts "#{train.number}, #{train.class}, #{train.wagons.count}"
      }
      stations.task_method(meth)
    when '9'
      trains_list
      puts 'select train'
      train = input_check(@trains, &:to_i)
      return start if train.nil?

      meth = proc { |wagon|
        val = wagon.free_capacity if wagon.is_a? CargoWagon
        val = wagon.empty_seats if wagon.is_a? PassengerWagon
        puts "#{wagon.number}, #{wagon.type}, #{val}"
      }
      train.task_method(meth)
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

  # ?????? ???????????? ?????????????? ???????? ???????? ???????????????? ?? private ???? ?????????????? ???????????????????????? ???? ???????????? ???? ???????????? ?? ???????? ??????????????????????????????????
  # ?????????????????? ?????? ?????????? ???????? ??????????????????
  private

  def input_check(type = nil, &block)
    loop do
      print '-> '
      res = gets.chomp
      return nil if res == 'exit'

      if block_given? && (res.match(/[a-zA-Z]+/) || res.strip.empty?)
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
    puts "#{@stations.last} created"
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  def create_train(command)
    return unless %w[1 2].include?(command)

    print 'write train number: '
    num = input_check
    return if num.nil?

    print 'write company name: '
    name = input_check
    return if name.nil?

    case command
    when '1'
      @trains << PassengerTrain.new(num, name)
    when '2'
      @trains << CargoTrain.new(num, name)
    end
    puts "#{@trains.last} created"
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  def create_route
    stations_list
    print "for selecting the first and the last stations \n first: "
    first = input_check(@stations, &:to_i)
    return if first.nil?

    print 'last: '
    last = input_check(@stations, &:to_i)
    return if last.nil?

    @routes << Route.new(first, last)
    puts "#{@routes.last} created"
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  def add_route
    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)
    return if route.nil?

    stations_list
    puts 'write stations you want to add separated by a space'
    lmbd = ->(str) { str.split.map(&:to_i) }
    stations = input_check(&lmbd)
    return if stations.nil?

    stations.each do |station|
      next if @stations[station].nil?

      route.add_station(@stations[station])
    end
  end

  def remove_route
    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)
    return if route.nil?

    puts route.stations.map(&:name)
    puts 'write stations you want to remove separated by a space'
    lmbd = ->(str) { str.split.map(&:to_i).uniq.sort.reverse }
    stations = input_check(&lmbd)
    return if stations.nil?

    stations.each do |station|
      route.remove_station(route.stations[station])
    end
  end

  def add_train_route
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)
    return if train.nil?

    routes_list
    puts 'write number of route'
    route = input_check(@routes, &:to_i)
    return if route.nil?

    train.route = route
  end

  def create_wagon(command)
    return unless %w[1 2].include?(command)

    print 'write wagon company name: '
    name = input_check
    return if name.nil?

    print 'write wagon capacity: '
    case command
    when '1'
      seats = input_check
      return if seats.nil?

      @wagons << PassengerWagon.new(company_name: name, full_capacity: seats)
    when '2'
      capacity = input_check
      return if capacity.nil?

      @wagons << CargoWagon.new(company_name: name, full_capacity: seats)
    end
    puts "#{@wagons.last} created"
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  def space_manipulation
    puts @wagons
    puts 'select wagon you want to add passengers count/free space'
    wagon = input_check(@wagons, &:to_i)

    case wagon
    when PassengerWagon
      add_passengers(wagon)
    when CargoWagon
      puts "How much do you want to add (free space: #{wagon.empty_capacity})"
      wagon.add_weight(gets.chomp.to_i)
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
    retry
  end

  def add_passengers(wagon)
    puts "Write how many passengers you want to add (free seats: #{wagon.empty_capacity})"
    num = gets.chomp.to_i
    raise 'There is not enough seats' if num > wagon.empty_capacity

    num.times { wagon.add_passenger }
  end

  def add_wagon
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)
    return if train.nil?

    puts @wagons
    puts 'select wagon you want to add separated by spaces (will be added only uniq wagons)'
    lmbd = ->(str) { str.split.map(&:to_i).uniq }
    wagons = input_check(&lmbd)
    return if wagons.nil?

    wagons.each do |num|
      train.add_wagon(@wagons[num])
    end
  end

  def remove_wagon
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)
    return if train.nil?

    puts train.wagons
    puts 'select wagon you want to remove separated by spaces'
    lmbd = ->(str) { str.split.map(&:to_i).uniq.sort.reverse }
    wagons = input_check(&lmbd)
    return if wagons.nil?

    wagons.each do |num|
      train.remove_wagon(train.wagons[num])
    end
  end

  def move_train
    trains_list
    puts 'select train'
    train = input_check(@trains, &:to_i)
    return if train.nil?

    puts 'select where train goes \'forward\', \'backward\' '
    case gets.chomp
    when 'forward'
      train.move_to_next_station
    when 'backward'
      train.move_to_prev_station
    end
  end
end
