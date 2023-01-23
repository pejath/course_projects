print 'Введите длинну основания треугольника: '
base = gets.chomp.to_f

print 'Введите высоту треугольника: '
height = gets.chomp.to_f

puts "Площадь треугольника: #{1.0 / 2 * base * height}"
