lines = File.read('day_13_input.txt').split("\n").map(&:chomp)
the_minute = lines[0].to_i

#part 1
the_busses = lines[1].split(",").map(&:to_i)
the_busses.delete_if { |b| b == 0 }

min_wait = the_minute
min_bus = -1
the_busses.each do |bus|
  the_wait = (the_minute * 1.0 / bus).ceil() * bus - the_minute
  if the_wait < min_wait
    min_wait = the_wait
    min_bus = bus
  end
end
puts "min_wait: #{min_wait} * #{min_bus} = #{min_wait * min_bus}"

#part 2
the_busses = lines[1].split(",").map(&:to_i)
the_delta_index = the_busses[0]
the_step_size = the_busses[0].lcm(the_busses[the_busses[0]]) # the_step_size = the_busses[0] # is also fast enough when we sieve
found_steps = [the_busses[0], the_busses[the_busses[0]]]     # found_steps = [the_busses[0]]

the_bus_index_pairs = Array([])
the_busses.each_with_index do |bus, i|
  the_bus_index_pairs << [bus, i] if bus > 0
end
the_bus_index_pairs = the_bus_index_pairs.sort.reverse

the_start_min = 0
is_valid = false
while !is_valid
  the_start_min += the_step_size
  is_valid = true
  the_bus_index_pairs.each do |pair|
    if (the_start_min + pair[1] - the_delta_index) % pair[0] != 0
      is_valid = false
      break
    else
      if !found_steps.include?(pair[0])
        found_steps << pair[0]
        the_step_size *= pair[0]
      end
    end
  end
end

puts "=" * 100
puts the_start_min - the_delta_index
