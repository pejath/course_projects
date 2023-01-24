task4 = {}
i = 1

('a'..'z').each do |char|
  task4[char] = i if 'aeiou'.include? char
  i += 1
end
