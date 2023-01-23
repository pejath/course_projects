print 'Введите коэффициент a: '
a = gets.chomp.to_f

print 'Введите коэффициент b: '
b = gets.chomp.to_f

print 'Введите коэффициент c: '
c = gets.chomp.to_f

d = (b**2 - 4 * a * c)
if d > 0
  puts "D= #{d} \nx1= #{(-b + Math.sqrt(d)) / (2 * a)} \nx2= #{(-b - Math.sqrt(d)) / (2 * a)}"
elsif d == 0
  puts "D= #{d} \nx= #{-b / (2 * a)}"
else
  puts 'Корней нет'
end
