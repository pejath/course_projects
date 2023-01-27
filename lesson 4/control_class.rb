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
      puts "\t1 - create station \n \t2 - create train \n \t3 - route menu \n \t4 - set route for train \n \t5 - add wagon
  \t6 - remove wagon \n \t7 - move train \n \t8 - show stations"
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
      add_wagon
    when '6'
      remove_wagon
    when '7'
      move_train
    when '8'
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

  # все классы которые ниже были отделены в private по сокльку пользователь не должен на прямую с ними взаимодействовать
  # поскольку для этого есть интерфейс
  private

  def create_station
    print 'write station name: '
    station_name = gets.chomp
    @stations << Station.new(station_name)
  end

  def create_train(command)
    return unless ['1', '2'].include?(command)

    print 'write train number: '

    case command
    when '1'
      num = gets.chomp
      @trains << PassengerTrain.new(num)
    when '2'
      num = gets.chomp
      @trains << CargoTrain.new(num)
    end
  end

  def create_route
    stations_list
    puts 'for selecting the first and the last stations'
    print 'first: '
    first = gets.chomp.to_i
    print 'last: '
    last = gets.chomp.to_i

    @routes << Route.new(@stations[first], @stations[last])
  end

  def add_route
    routes_list
    puts 'write number of route'
    route = @routes[gets.chomp.to_i]
    stations_list
    puts 'write stations you want to add separated by a space'
    stations = gets.chomp.split.map(&:to_i)
    stations.each do |station|
      next if @stations[station].nil?

      route.add_station(@stations[station])
    end
  end

  def remove_route
    routes_list
    puts 'write number of route'
    route = @routes[gets.chomp.to_i]
    puts route.stations.map(&:name)
    puts 'write stations you want to remove separated by a space'
    stations = gets.chomp.split.map(&:to_i).uniq.sort.reverse
    stations.each do |station|
      route.remove_station(route.stations[station])
    end
  end

  def add_train_route
    trains_list
    puts 'select train'
    train = @trains[gets.chomp.to_i]
    routes_list
    puts 'write number of route'
    route = @routes[gets.chomp.to_i]

    train.route = route
  end

  def add_wagon
    trains_list
    puts 'select train'
    train = @trains[gets.chomp.to_i]

    puts @wagons
    puts 'select wagon you want to add separated by spaces'
    wagons = gets.chomp.split.map(&:to_i)

    wagons.each do |num|
      train.add_wagon(@wagons[num])
    end
  end

  def remove_wagon
    trains_list
    puts 'select train'
    train = @trains[gets.chomp.to_i]

    puts train.wagons
    puts 'select wagon you want to remove separated by spaces'
    wagons = gets.chomp.split.map(&:to_i).uniq.sort.reverse

    wagons.each do |num|
      train.remove_wagon(train.wagons[num])
    end
  end

  def move_train
    trains_list
    puts 'select train'
    train = @trains[gets.chomp.to_i]

    puts 'select where train goes \'forward\', \'backward\' '
    case gets.chomp
    when 'forward'
      train.move_to_next_station
    when 'backward'
      train.move_to_prev_station
    end
  end
end
