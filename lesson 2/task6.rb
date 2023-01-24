puts 'Введите по порядку название товара, цену, кол-во (для выхода введите "stop"/"стоп")'
cart = Hash.new(Hash.new(0.0))
final_price = 0.0

loop do
  item = gets.chomp
  break if ['stop', 'стоп'].include?(item)

  price = gets.chomp.to_f
  quantity = gets.chomp.to_f
  cart[item] = { price: price, quantity: quantity }
end

puts cart.inspect

cart.each do |item, value|
  final_price += (value[:price] * value[:quantity]).round(2)
  puts "#{item}: #{(value[:price] * value[:quantity]).round(2)}"
end

puts "финальная цена: #{final_price}"
