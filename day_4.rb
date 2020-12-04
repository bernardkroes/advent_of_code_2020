all_passports = File.read('day_4_input.txt').split("\n\n")
puts all_passports.count

the_valid_count = 0
all_passports.each do |passport|
  fields_hash = {}
  passport.gsub("\n", " ").split(" ").each do |f|
    the_key, the_value = f.split(":")
    fields_hash[the_key] = the_value
  end
  begin
    # part 1, just try to fetch the required keys, if key missing KeyError is thrown
    fields_hash.fetch_values("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")

    # part2: rules per field
    is_valid = true

    is_valid = false if !(fields_hash["byr"].size == 4 && fields_hash["byr"].to_i.between?(1920,2002))
    is_valid = false if !(fields_hash["iyr"].size == 4 && fields_hash["iyr"].to_i.between?(2010,2020))
    is_valid = false if !(fields_hash["eyr"].size == 4 && fields_hash["eyr"].to_i.between?(2020,2030))

    the_height = fields_hash["hgt"]
    if !((the_height.end_with?("in") && the_height.to_i.between?(59,76)) ||
         (the_height.end_with?("cm") && the_height.to_i.between?(150,193)))
      is_valid = false
    end
    is_valid = false if (fields_hash["hcl"] =~ /\A\#[0-9a-f]{6}\Z/).nil?
    is_valid = false if !["amb","blu","brn","gry","grn","hzl","oth"].include?(fields_hash["ecl"])
    is_valid = false if (fields_hash["pid"] =~ /\A\d{9}\Z/).nil?

    the_valid_count += 1 if is_valid
  rescue KeyError
  end
end
puts the_valid_count

__END__

byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
  If cm, the number must be at least 150 and at most 193.
  If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
