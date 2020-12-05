def boardingpass_to_seat_id(line)
  row, col = 0, 0
  0.upto(6) do |i|
    row += (line[i] == "B" ? 2**(6-i) : 0)
  end
  0.upto(2) do |i|
    col += (line[7+i] == "R" ? 2**(2-i) : 0)
  end
  row * 8 + col
end

puts boardingpass_to_seat_id("FBFBBFFRLR")
puts boardingpass_to_seat_id("BFFFBBFRRR")
puts boardingpass_to_seat_id("FFFBBBFRRR")
puts boardingpass_to_seat_id("BBFFBBFRLL")

all_seat_ids = File.read('day_5_input.txt').split("\n").map{ |line| boardingpass_to_seat_id(line) }

# part 1
puts "Max: #{all_seat_ids.max}"

# part 2
all_seat_ids.sort.each do |seat_id|
  if !all_seat_ids.include?(seat_id + 1) && all_seat_ids.include?(seat_id + 2)
    puts "Empty seat: #{seat_id + 1}"
  end
end

