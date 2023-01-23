print 'Ваше имя: '
name = gets.chomp.capitalize

print 'Ваш рост: '
height = gets.chomp.to_i
ideal_weight = (height - 110) * 1.15

if ideal_weight <= 0
  puts "#{name}, Ваш вес уже оптимальный"
else
  puts "#{name}, Ваш идеальный вес: #{ideal_weight}"
end
