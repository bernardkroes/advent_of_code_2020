all_password_lines = []
File.open('day_2_input.txt').each do |line|
  all_password_lines << line
end

# part 1
the_valid_count = 0
all_password_lines.each do |line|
  the_parts = line.split(" ")
  the_min, the_max = the_parts[0].split("-")
  the_char = the_parts[1][0]
  the_password = the_parts[2]

  the_valid_count += 1 if (the_password.count(the_char).between?(the_min.to_i, the_max.to_i))
end
puts the_valid_count

# part 2, just parse the lines again because we can
the_valid_count = 0
all_password_lines.each do |line|
  the_parts = line.split(" ")
  the_first_index, the_second_index = the_parts[0].split("-")
  the_char = the_parts[1][0]
  the_password = the_parts[2]

  the_occurence_count = 0
  the_occurence_count += 1 if (the_password[the_first_index.to_i-1] == the_char)
  the_occurence_count += 1 if (the_password[the_second_index.to_i-1] == the_char)
  the_valid_count += 1 if (the_occurence_count == 1)
end
puts the_valid_count
