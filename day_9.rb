# all_numbers = File.read('day_9_test_input.txt').split("\n").map(&:to_i)
# preamble = 5

all_numbers = File.read('day_9_input.txt').split("\n").map(&:to_i)
preamble = 25

def array_contains_sum(in_array, in_sum)
  in_array.any? { |i| (2 * i != in_sum) && in_array.include?(in_sum - i) }
end

#part 1
the_invalid_num = -1
all_numbers[preamble..-1].each_with_index do |the_num, i|
  if !array_contains_sum(all_numbers[i..(i + preamble - 1)], the_num)
    puts "Not found as sum: #{the_num}"
    the_invalid_num = the_num
  end
end

# part 2
all_numbers.each_with_index do |the_num, i| # the_num is not used, btw
  the_sum = 0
  the_walk_index = 0
  while the_sum < the_invalid_num
    the_sum += all_numbers[i + the_walk_index]
    the_walk_index += 1
  end
  if the_sum == the_invalid_num
    the_sub_array = all_numbers[i..(i + the_walk_index - 1)]
    the_min = the_sub_array.min
    the_max = the_sub_array.max
    puts "Weakness found: sum of min and max: #{the_min} +  #{the_max} = #{the_min + the_max}"
    exit
  end
end

