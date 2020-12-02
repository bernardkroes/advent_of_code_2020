all_entries = File.read('day_1_input.txt').split("\n").map(&:to_i)

# all_entries = []
# File.open('day_1_input.txt').each do |line|
#   all_entries << line.to_i
# end

# should output two lines (doublecheck)
all_entries.each do |e|
  if all_entries.include?(2020 - e)
    puts "#{e} + #{2020-e} = 2020, #{e} * #{2020-e} = #{e * (2020 - e)}"
  end
end

# should output three lines (triplecheck)
all_entries.each_with_index do |e1, i|
  all_entries[i+1..-1].each do |e2|
    if all_entries.include?(2020 - e1 - e2)
      puts "#{e1} + #{e2} + #{2020-e1-e2} = 2020, #{e1} * #{e2} * #{2020-e1-e2} = #{e1 * e2 * (2020 - e1 - e2)}"
    end
  end
end

