all_lines = File.read('day_21_input.txt').split("\n").map(&:chomp)

foods = [] # array of pairs consisting of an ingredients (index 0) and an allergenes (index 1) array
ingredients = Hash.new([])
allergenes = Hash.new([])

all_lines.each do |food|
  all_ings, all_allergs = food.split(" (contains ")
  ings = all_ings.split(" ")
  allergs = all_allergs.gsub(")","").split(", ")

  foods << [ings, allergs]
  ings.each do |ing|
    ingredients[ing] = (ingredients[ing] + allergs).uniq
  end
  allergs.each do |allerg|
    allergenes[allerg] = (allergenes[allerg] + ings).uniq
  end
end

foods.each_with_index do |food, i|
  if food[1].size == 1
    allerg = food[1].first

    allergenes[allerg] = allergenes[allerg] & food[0]
    ingredients.each_key do |k|
      ingredients[k] = ingredients[k] - [allerg] unless food[0].include?(k)
    end
  end
end

# one sweep (the following:) appears to be enough:
allergenes.each do |allerg, cands|
  cands.each do |cand| # suppose this ing contains the allergene
    foods.each_with_index do |food|
      if food[1].include?(allerg) && !food[0].include?(cand) # impossible
        ingredients[cand] -= [allerg]
        allergenes[allerg] -= [cand]
      end
    end
  end
end

# count
the_count = 0
ingredients.each do |ing, allergs|
  if allergs.size == 0
    foods.each do |f|
      the_count += f[0].count(ing)
    end
  end
end
puts the_count

# part 2
all_allergenes = allergenes.keys.sort
out_array = []

all_allergenes.each do |k|
  out_array << allergenes[k][0]
end
puts out_array.join(",")
