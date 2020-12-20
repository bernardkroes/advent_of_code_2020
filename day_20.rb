PLACEMEMTS = [0,1,2,3,4,5,6,7] # 0, 90L, 180L, 270L, flipped, flipped_then_90L, flipped_then_180L, flipped_then_270L

class Tile
  attr_accessor :size_x, :size_y, :tile_id, :borders

  def initialize(in_tile_id, in_lines)
    @tile_id = in_tile_id
    @tile_map = []
    @tile_map = in_lines

    @size_x = @tile_map[0].size
    @size_y = @tile_map.size
    @borders = [] # border to binary to num for: (clockwise):top, right, bottom, left, (anti-clockwise): top, right, bottom, left
    create_borders
  end

  def remove_borders
    @tile_map.shift
    @tile_map.pop
    @tile_map.each_with_index do |line,i|
      @tile_map[i] = line[1..-2]
    end
  end

  # original (from input) borders: clockwise
  def top_border # left to right
    @tile_map[0]
  end

  def right_border # top to bottom
    @tile_map.collect { |c| c[-1] }.join("")
  end

  def bottom_border # right to left
    @tile_map[-1].reverse
  end

  def left_border # bottom to top
    @tile_map.collect { |c| c[0] }.join("").reverse
  end

  def create_borders # border to binary
    # four clock wise
    @borders = []
    @borders << top_border.tr(".#","01").to_i(2)
    @borders << right_border.tr(".#","01").to_i(2)
    @borders.<< bottom_border.tr(".#","01").to_i(2)
    @borders.<< left_border.tr(".#","01").to_i(2)

    # four anti-clockwise
    @borders << top_border.reverse.tr(".#","01").to_i(2)
    @borders << right_border.reverse.tr(".#","01").to_i(2)
    @borders.<< bottom_border.reverse.tr(".#","01").to_i(2)
    @borders.<< left_border.reverse.tr(".#","01").to_i(2)
  end

  def line_for_placement(in_line, pl)
    case pl
    when 0
      @tile_map[in_line]
    when 1
      @tile_map.collect { |c| c[-1 - in_line] }.join("")
    when 2
      @tile_map.reverse[in_line].reverse
    when 3
      @tile_map.reverse.collect { |c| c[in_line] }.join("")
    when 4
      @tile_map[in_line].reverse
    when 5
      @tile_map.collect { |c| c[in_line] }.join("")
    when 6
      @tile_map.reverse[in_line]
    when 7
      @tile_map.reverse.collect { |c| c[-1 - in_line] }.join("")
    end
  end

  def show_tile
    puts "Tile #{@tile_id}"
    @tile_map.each do |line|
      puts line
    end
  end

  def top_border_for_placement(pl)
    return @borders[ [0,1,2,3,4,7,6,5][pl] ]
  end

  # for comparing!
  def flipped_right_border_for_placement(pl)
    return @borders[ [5,6,7,4,3,2,1,0][pl] ]
  end

  # for comparing!
  def flipped_bottom_border_for_placement(pl)
    return @borders[ [6,7,4,5,2,1,0,3][pl] ]
  end

  def left_border_for_placement(pl)
    return @borders[ [3,0,1,2,5,4,7,6][pl] ]
  end

  def has_border?(in_border)
    @borders.include(in_border)
  end

  def placements_that_fit(top_border, left_border)
    return Array(0..7) if top_border.nil? && left_border.nil?

    the_placements = []
    0.upto(7) do |pl|
      if !top_border.nil? && left_border.nil?
        the_placements << pl if top_border_for_placement(pl) == top_border
      elsif top_border.nil? && !left_border.nil?
        the_placements << pl if left_border_for_placement(pl) == left_border
      else
        the_placements << pl if (left_border_for_placement(pl) == left_border) && (top_border_for_placement(pl) == top_border)
      end
    end
    the_placements
  end
end

all_lines = File.read('day_20_input.txt').split("\n").map(&:chomp)
GRID_SIZE = 12

all_tiles = []
num_tiles = all_lines.size / 12
num_tiles.times do |i|
  the_id_line = all_lines[i * 12]
  the_tile_id = the_id_line.gsub("Tile ","").to_i
  t = Tile.new(the_tile_id, all_lines[(i*12+1)..(i*12+10)])
  all_tiles << t
end

grid = [] # array of tiles and their placements
(GRID_SIZE * GRID_SIZE).times do |i|
  grid << [-1, -1]
end

def grid_tile_taken(grid, in_tile_id)
  grid.any? { |g| g[0] == in_tile_id }
end

def find_first_complete_grid(grid, in_all_tiles, found_grid)
  # get first empty in grid:
  the_x, the_y = -1, -1
  0.upto(GRID_SIZE - 1) do |y|
    0.upto(GRID_SIZE - 1) do |x|
      if the_x == -1 && the_y == -1 && grid[y * GRID_SIZE + x][0] == -1
        the_x, the_y = x, y
      end
    end
  end
  return grid.clone if the_x == -1 && the_y == -1 # no more empties in the grid we are done!

  # get the borders that need to be matched:
  the_top_border = nil
  if the_y > 0
    the_tile_id, the_tile_placement = grid[(the_y-1) * GRID_SIZE + the_x]
    the_tile_above = in_all_tiles.select { |t| t.tile_id == the_tile_id }.first
    the_top_border = the_tile_above.flipped_bottom_border_for_placement(the_tile_placement) if the_tile_above
  end
  the_left_border = nil
  if the_x > 0
    the_tile_id, the_tile_placement = grid[the_y * GRID_SIZE + the_x - 1]
    the_tile_to_the_left = in_all_tiles.select { |t| t.tile_id == the_tile_id }.first
    the_left_border = the_tile_to_the_left.flipped_right_border_for_placement(the_tile_placement) if the_tile_to_the_left
  end
  in_all_tiles.each do |t|
    if !grid_tile_taken(grid, t.tile_id)
      t.placements_that_fit(the_top_border, the_left_border).each do |pl|
        the_grid = grid.clone
        the_grid[the_y * GRID_SIZE + the_x] = [t.tile_id, pl]
        found_grid = find_first_complete_grid(the_grid, in_all_tiles, found_grid)
      end
    end
  end
  return found_grid
end

the_in_grid = []
the_grid = find_first_complete_grid(grid, all_tiles, the_in_grid)

the_prod = 1
the_prod *= the_grid[0*GRID_SIZE + 0][0]
the_prod *= the_grid[0*GRID_SIZE + GRID_SIZE - 1][0]
the_prod *= the_grid[(GRID_SIZE - 1) * GRID_SIZE + 0][0]
the_prod *= the_grid[(GRID_SIZE - 1) * GRID_SIZE + GRID_SIZE - 1][0]
puts the_prod

puts "="* 20

# part 2
# remove borders
all_tiles.each do |t|
  t.remove_borders
end

# stitch
TILE_SIZE = 8
the_image = []
0.upto(GRID_SIZE - 1) do |y|
  TILE_SIZE.times do |line|
    the_new_line = ""
    0.upto(GRID_SIZE - 1) do |x|
      the_tile_id, the_tile_placement = the_grid[y * GRID_SIZE + x]
      the_tile = all_tiles.select { |t| t.tile_id == the_tile_id }.first
      the_new_line += the_tile.line_for_placement(line, the_tile_placement)
    end
    the_image << the_new_line
  end
end

class SeaImage
  attr_accessor :size_x, :size_y

  def initialize(in_lines)
    @sea_map = []
    @sea_map = in_lines

    @size_x = @sea_map[0].size
    @size_y = @sea_map.size
  end

  def show_sea_image
    @sea_map.each do |line|
      puts line
    end
  end

  def detect_and_mark_monsters(in_monster)
    found_monster = false
    start_x, start_y = 0, 0
    end_x = @size_x - in_monster[0].size
    end_y = @size_y - in_monster.size
    start_x.upto(end_x-1) do |x|
      start_y.upto(end_y-1) do |y|
        all_match = true
        in_monster.size.times do |my|
          in_monster[0].size.times do |mx|
            if (in_monster[my][mx] == "#")
              if (@sea_map[y + my][x + mx] != "#") && (@sea_map[y + my][x + mx] != "O")
                all_match = false
              end
            end
          end
        end
        if all_match
          # mark it
          in_monster.size.times do |my|
            in_monster[0].size.times do |mx|
              if (in_monster[my][mx] == "#")
                if (@sea_map[y + my][x + mx] == "#")
                  @sea_map[y + my][x + mx] = "O"
                end
              end
            end
          end
          found_monster = true
        end
      end
    end
    found_monster
  end

  def count_roughness
    @sea_map.inject(0) { |sum, line| sum + line.count("#") }
  end
end

sea = SeaImage.new(the_image)

# try all 4 monster variants
# the_monster = []
# the_monster << "                  # "
# the_monster << "#    ##    ##    ###"
# the_monster << " #  #  #  #  #  #   "
#
# the_monster = []
# the_monster << "                  # ".reverse
# the_monster << "#    ##    ##    ###".reverse
# the_monster << " #  #  #  #  #  #   ".reverse
#
# the_monster = []
# the_monster << " # ".reverse
# the_monster << "#  ".reverse
# the_monster << "   ".reverse
# the_monster << "   ".reverse
# the_monster << "#  ".reverse
# the_monster << " # ".reverse
# the_monster << " # ".reverse
# the_monster << "#  ".reverse
# the_monster << "   ".reverse
# the_monster << "   ".reverse
# the_monster << "#  ".reverse
# the_monster << " # ".reverse
# the_monster << " # ".reverse
# the_monster << "#  ".reverse
# the_monster << "   ".reverse
# the_monster << "   ".reverse
# the_monster << "#  ".reverse
# the_monster << " # ".reverse
# the_monster << " ##".reverse
# the_monster << " # ".reverse

the_monster = []
the_monster << " # "
the_monster << "#  "
the_monster << "   "
the_monster << "   "
the_monster << "#  "
the_monster << " # "
the_monster << " # "
the_monster << "#  "
the_monster << "   "
the_monster << "   "
the_monster << "#  "
the_monster << " # "
the_monster << " # "
the_monster << "#  "
the_monster << "   "
the_monster << "   "
the_monster << "#  "
the_monster << " # "
the_monster << " ##"
the_monster << " # "

sea.detect_and_mark_monsters(the_monster)
puts sea.count_roughness
