def anyone_answer_count_for_group(answer_lines)
  answer_lines.gsub("\n","").chars.uniq.count
end

def everyone_answer_count_for_group(answer_lines)
  the_answer_set = "abcdefghijklmnopqrstuvwxyz".chars
  answer_lines.split("\n").each do |line|
    the_answer_set = the_answer_set & line.chars
  end
  the_answer_set.count
end

all_group_lines = File.read('day_6_input.txt').split("\n\n")
the_total_part1 = 0
the_total_part2 = 0
all_group_lines.each do |gl|
  the_total_part1 += anyone_answer_count_for_group(gl)
  the_total_part2 += everyone_answer_count_for_group(gl)
end

puts the_total_part1
puts the_total_part2
