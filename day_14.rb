lines = File.read('day_14_input.txt').split("\n").map(&:chomp)
BITLENGTH = 36

# part 1

def apply_mask_to(val, mask)
  binstr = ("0" * BITLENGTH + val.to_s(2))[-BITLENGTH..-1]
  outstr = ""
  binstr.chars.each_with_index do |c, i|
    outstr += (mask[i] == "X" ? c : mask[i])
  end
  val = outstr.to_i(2)
end

mem = {}
mask = ""

lines.each do |line|
  if line.start_with?("mask")
    mask = line.gsub(/[^0-9X]/,"")
  else
    addr, val = line.split(" = ")
    addr = addr.gsub(/[^0-9]/,"")
    mem[addr] = apply_mask_to(val.to_i, mask)
  end
end

puts mem.values.sum

# part 2

def apply_mask_v2_to(binstr, mask)
  temp_mask_str = ""
  binstr.chars.each_with_index do |c, i|
    temp_mask_str += (mask[i] == "0" ? c : mask[i])
  end
  temp_mask_str
end

def set_mem_vals_for(mem, addr, val, mask)
  binstr = ("0" * BITLENGTH + addr.to_s(2))[-BITLENGTH..-1]
  temp_mask_str = apply_mask_v2_to(binstr, mask)

  the_float_count = temp_mask_str.count("X")
  (2 ** the_float_count).times do |i|
    the_addr = temp_mask_str.clone
    the_replacement_string = ("0" * the_float_count + i.to_s(2))[-the_float_count..-1]
    the_walk_index = 0
    the_addr.chars.each_with_index do |c, i|
      if c == "X"
        the_addr[i] = the_replacement_string[the_walk_index]
        the_walk_index += 1
      end
    end
    mem[the_addr] = val # use the strings as keys, could also do the_addr.to_i
  end
end

mem = {}
mask = ""

lines.each do |line|
  if line.start_with?("mask")
    mask = line.gsub(/[^0-9X]/,"")
  else
    addr, val = line.split(" = ")
    addr = addr.gsub(/[^0-9]/,"")
    set_mem_vals_for(mem, addr.to_i, val.to_i, mask)
  end
end

puts mem.values.sum

__END__

mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1

