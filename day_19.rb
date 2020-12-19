lines = File.read('day_19_input.txt').split("\n").map(&:chomp)
rules = {}
sols = {}

messages =[]

lines.each do |line|
  if line.include?(": ")
    index, r = line.split(": ")
    rules[index.to_i] = r.gsub("\"","")
    sols[index.to_i] = []
  elsif line.size > 0
    messages << line
  end
end

def is_solved?(sols, k)
  sols[k].size > 0
end

def can_solve(rules, sols, k)
  !rules[k].gsub("| ","").split(" ").map(&:to_i).any? { |r| !is_solved?(sols, r) }
end

def solve(rules, sols, k)
  rules[k].split("| ").each do |rpart|
    indices = rpart.split(" ").map(&:to_i)
    if indices.size == 1
      sols[k] += sols[indices[0]]
    elsif indices.size == 2
      sols[indices[0]].each do |l|
        sols[indices[1]].each do |r|
          sols[k] << (l + r)
        end
      end
    elsif indices.size == 3
      sols[indices[0]].each do |l|
        sols[indices[1]].each do |r|
          sols[indices[2]].each do |y|
            sols[k] << (l + r + y)
          end
        end
      end
    end
  end
end

rules.each do |k,v|
  sols[k] << v if v == "a" || v == "b"
end

num_solved = 1
while sols[0].size == 0 && num_solved > 0
  num_solved = 0
  rules.each do |k,v|
    if !is_solved?(sols, k) && can_solve(rules, sols, k)
      solve(rules, sols, k)
      num_solved += 1
    end
  end
end

the_count = 0
messages.each do |msg|
  the_count += 1 if sols[0].include?(msg)
end
puts the_count

# part 2:
puts "="
the_count = 0

# 0: 8 11
# 8: 42 | 42 8
# 11: 42 31 | 42 11 31
messages.each do |msg|
  did_replace_at_start = 0
  did_replace_at_end = 0

  the_str = msg.clone
  begin
    did_replace = false
    sols[42].each do |s|
      if the_str.start_with?(s)
        the_str = the_str[s.size..-1]
        did_replace = true
        did_replace_at_start += 1
      end
    end
  end while did_replace

  begin
    did_replace = false
    sols[31].each do |s|
      if the_str.end_with?(s)
        the_str = the_str[0..(-1-s.size)]
        did_replace = true
        did_replace_at_end += 1
      end
    end
  end while did_replace
  if the_str.size == 0 && did_replace_at_start > 0 && did_replace_at_end > 0 && did_replace_at_start > did_replace_at_end
    the_count += 1
  end
end
puts the_count

__END__

425: too high
