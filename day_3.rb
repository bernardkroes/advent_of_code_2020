# part 1
class TreeMap
  attr_reader :size_x, :size_y

  def initialize(in_filename)
    @tree_map = []
    File.open(in_filename).each do |line|
      @tree_map << line.chomp
    end
    @size_x = @tree_map[0].size
    @size_y = @tree_map.size
  end

  def contains_tree?(in_x, in_y)
    return @tree_map[in_y][in_x % @size_x] == "#"
  end

  # always starting from 0, 0 for now
  def count_trees_for_step(in_step_x, in_step_y)
    the_x, the_y = 0, 0

    the_tree_count = 0
    while the_y < @size_y do
      the_tree_count += 1 if self.contains_tree?(the_x, the_y)
      the_x += in_step_x
      the_y += in_step_y
    end
    return the_tree_count
  end

end

#part 1

# the_map = TreeMap.new('day_3_test_input.txt')
the_map = TreeMap.new('day_3_input.txt')

puts the_map.count_trees_for_step(3,1)

#part 2

the_steps_x = [1, 3, 5, 7, 1]
the_steps_y = [1, 1, 1, 1, 2]

the_total_multiplied = 1
0.upto(4) do |i|
  the_total_multiplied *= the_map.count_trees_for_step(the_steps_x[i], the_steps_y[i])
end
puts the_total_multiplied
