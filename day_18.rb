lines = File.read('day_18_input.txt').split("\n").map(&:chomp)
sum = 0

def calc_oper(l, oper, r)
  if oper == "+"
    return l.to_i + r.to_i
  elsif oper == "*"
    return l.to_i * r.to_i
  end
end

# only valid for lines without nested (expressions)
def calc_no_subs(line)
  val = nil
  parts = line.split(" ")
  val = parts.shift.to_i if val.nil?
  while parts.size > 1
    oper = parts.shift
    r = parts.shift
    val = calc_oper(val.to_s, oper, r)
  end
  val
end

# simplify all the deepest "+" sums
def calc_no_subs_p2(line)
  val = nil
  parts = line.split(" ")
  val = parts.shift.to_i if val.nil?
  # additions first
  m = line.match(/(?<sub>\d+ \+ \d+)/)
  while m
    val = calc_no_subs(m[:sub])
    line = line.gsub(m[:sub], val.to_s)
    m = line.match(/(?<sub>\d+ \+ \d+)/)
  end
  calc_no_subs(line) # just a multiply, really
end

def calc_p1(line)
  while line.include?("(")
    # we need to simplify the deepest nested brackets
    m = line.match(/\((?<sub>[0-9 \+\*]*)\)/)
    val = calc_no_subs(m[:sub])
    line = line.gsub("(" + m[:sub] + ")", val.to_s)
  end
  calc_no_subs(line)
end

def calc(line)
  while line.include?("(")
    # we need to simplify the deepest nested brackets
    m = line.match(/\((?<sub>[0-9 \+\*]*)\)/)
    val = calc_no_subs_p2(m[:sub])
    line = line.gsub("(" + m[:sub] + ")", val.to_s)
  end
  calc_no_subs_p2(line)
end

# puts calc("1 + (2 * 3) + (4 * (5 + 6))")
# puts calc("1 + 2 * 3 + 4 * 5 + 6")
# puts calc("2 * 3 + (4 * 5)")
# puts calc("5 + (8 * 3 + 9 + 3 * 4 * 3)")
# puts calc("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
# puts calc("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")

lines.each do |line|
  sum += calc_p1(line)
end
puts sum

# part 2
puts "=" * 20

sum = 0
lines.each do |line|
  sum += calc(line)
end
puts sum

