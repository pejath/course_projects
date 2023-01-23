def pythagoras?(a, b, c)
  sides = [a, b, c].sort
  a, b, c = sides[0], sides[1], sides[2]
  a**2 + b**2 == c**2
end

print 'Введите сторону a треугольника: '
a = gets.chomp.to_f

print 'Введите сторону b треугольника: '
b = gets.chomp.to_f

print 'Введите сторону c треугольника: '
c = gets.chomp.to_f


if a == b && b == c
  puts 'Треугольник равносторонний'
elsif pythagoras?(a, b, c)
  puts 'Прямоугольный треугольник'
elsif a == b || a == c || b == c
  puts 'Равнобедренный треугольник'
else
  puts 'Это обычный треугольник'
end
