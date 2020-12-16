lines = File.read('day_16_input.txt').split("\n").map(&:chomp)
ranges_hash = {} # keys => array of pairs (lower, upper)
ticket = []
nearby_tickets = []
valid_tickets = []

# part 1
parse_step = 0 # ranges, ticket, nearby tickets
lines.each do |line|
  if line.start_with?("your ticket:")
    parse_step = 1
    next
  elsif line.start_with?("nearby tickets:")
    parse_step = 2
    next
  end
  next if line.gsub(/[^0-9,]/,"").size == 0 # skip empty lines

  if parse_step == 0
    ranges = []
    name, rr = line.split(": ")
    rr.split(" or ").each do |r|
      ranges << r.split("-").map(&:to_i)
    end
    ranges_hash[name] = ranges
  elsif parse_step == 1
    ticket = line.split(",").map(&:to_i)
  elsif parse_step == 2
    nearby_tickets << line.split(",").map(&:to_i)
  end
end

def is_in_any_range?(val, rr)
  rr.any? { |r| val >= r[0] && val <= r[1] }
end


def is_in_any_range_with_hash?(val, ranges_hash)
  ranges_hash.any? { |k, rr| is_in_any_range?(val, rr) }
end

invalid_sum = 0
nearby_tickets.each do |t|
  t_valid = true
  t.each do |v|
    if !is_in_any_range_with_hash?(v, ranges_hash)
      invalid_sum += v
      t_valid = false
    end
  end
  valid_tickets << t if t_valid
end
puts invalid_sum
puts "=" * 20

# part 2
cand = {} # pos => array of fieldnames
ticket.size.times do |pos|
  cand[pos] = []
  ranges_hash.each do |fieldname, rr|
    cand[pos] << fieldname if !valid_tickets.any? { |t| !is_in_any_range?(t[pos], rr) }
  end
end

while cand.any? { |pos, fieldnames| fieldnames.size > 1 }
  cand.each do |pos, fieldnames|
    if fieldnames.size == 1
      the_name = fieldnames[0]
      cand.each do |other_pos, other_fieldnames|
        other_fieldnames.delete(the_name) if pos != other_pos
      end
    end
  end
end

the_mult = 1
cand.each do |pos, fieldnames|
  if fieldnames[0].start_with?("departure")
    the_mult *= ticket[pos]
  end
end
puts the_mult
