rules = {}
all_lines = File.read('day_7_input.txt').split("\n")
all_lines.each do |rule|
  the_color, contents = rule.split(" bags contain ")
  rules[the_color] = contents
end

def colors_that_contain(rules, in_color, found_colors)
  rules.each do |color, contents|
    if contents.include?(in_color)
      colors_that_contain(rules, color, found_colors << color)
    end
  end
  found_colors
end

# part 1, all color that can contain shiny_gold
puts colors_that_contain(rules, "shiny gold", []).uniq.size

# part 2, count all contained bags
# new 'rules' needed

rules = {}
all_lines = File.read('day_7_input.txt').split("\n")
all_lines.each do |rule|
  the_color, the_contents = rule.split(" bags contain ")
  sub_bags = {}
  the_contents.split(", ").each do |color_rule|
    the_count = color_rule.gsub(/[^0-9]/,"").to_i
    the_contained_color = color_rule.gsub(/[0-9]/,"").gsub(/(bags|bag|\.)/,"").strip
    if the_count > 0
      sub_bags[the_contained_color] = the_count
    end
  end
  rules[the_color] = sub_bags unless sub_bags.empty?
end

def count_bags_contained_for(rules, in_color)
  the_count = 0
  the_contents = rules[in_color]
  if the_contents
    the_contents.each do |color, rule_count|
      the_count += rule_count
      the_count += rule_count * count_bags_contained_for(rules, color)
    end
  end
  the_count
end

puts count_bags_contained_for(rules, "shiny gold")
