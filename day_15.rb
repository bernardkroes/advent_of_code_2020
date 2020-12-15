the_sequence = [1,17,0,10,18,11,6]

while the_sequence.size < 2020
  the_next_num = the_sequence[0..-2].reverse.index(the_sequence[-1])
  the_next_num = the_next_num.nil? ? 0 : the_next_num + 1
  the_sequence << the_next_num
end
puts the_sequence[-1]

# part 2
puts "-" * 20
the_sequence = [1,17,0,10,18,11,6]

last_pos = {}
prev_pos = {}
last_x = the_pos = 0
the_sequence.each do |x|
  prev_pos[x] = last_pos[x] if last_pos.has_key?(x)
  last_x, last_pos[x] = x, the_pos
  the_pos += 1
end
while the_pos < 30000000
  the_x = 0
  if prev_pos.has_key?(last_x)
    the_x = the_pos - prev_pos[last_x] - 1
  end
  prev_pos[the_x] = last_pos[the_x] if last_pos.has_key?(the_x)
  last_x, last_pos[the_x] = the_x, the_pos
  the_pos += 1
end
puts last_x
