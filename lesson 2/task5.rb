def leap?(year)
  (year % 4).zero? && year % 100 != 0 || (year % 400).zero?
end

year = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print 'Введите день: '
d = gets.chomp.to_i
print 'Введите месяц: '
m = gets.chomp.to_i - 1
print 'Введите год: '
y = gets.chomp.to_i

res = -1
(0...m).each do |month|
  res += year[month]
end

if (m == 2 && d > 28) || m > 2 && leap?(y)
  res += d + 1
else
  res += d
end
