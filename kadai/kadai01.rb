# coding: utf-8

ans = rand(9)+1

puts "数当てゲーム"
puts "1-9の数値を当ててね"
print "> "

while input = gets.to_i
  if ans > input
    puts "小さい"
  elsif ans < input
    puts "大きい"
  else
    puts "正解"
    break
  end
  print "> "
end

