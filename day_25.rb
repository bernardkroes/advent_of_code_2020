# example inputs:
# pub_key1 = 5764801
# pub_key2 = 17807724

# inputs:
pub_key1 = 12092626
pub_key2 = 4707356

def transform(loop_size, subject_number, value)
  loop_size.times do
    value = (value * subject_number) % 20201227
  end
  value
end

# just bruteforce it, no pow optimization needed
the_value = 1
the_subject_number = 7
loop_count = 0
loop_size1, loop_size2 = -1, -1

while (loop_size1 < 0) || (loop_size2 < 0)
  the_value = (the_value * the_subject_number) % 20201227
  loop_count += 1
  if loop_size1 < 0 && the_value == pub_key1
    loop_size1 = loop_count
  end
  if loop_size2 < 0 && the_value == pub_key2
    loop_size2 = loop_count
  end
end

puts transform(loop_size1, pub_key2, 1)
puts transform(loop_size2, pub_key1, 1)
