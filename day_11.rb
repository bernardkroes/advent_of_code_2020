class SeatMap
  attr_reader :size_x, :size_y

  DELTA_MOVES = [[-1,-1],[ 0,-1],[ 1,-1],
                 [-1, 0],[ 1, 0],
                 [-1, 1],[ 0, 1],[ 1, 1]]

  def initialize(in_filename)
    @seat_map = []
    File.open(in_filename).each do |line|
      @seat_map << line.chomp
    end
    @size_x = @seat_map[0].size
    @size_y = @seat_map.size
  end

  def is_occupied?(in_x, in_y)
    return false if !on_map?(in_x, in_y)
    @seat_map[in_y][in_x] == "#"
  end

  def occupied_count
    the_count = 0
    @seat_map.each do |line|
      the_count += line.count("#")
    end
    the_count
  end

  def occupy(in_x, in_y)
    @seat_map[in_y][in_x] = "#"
  end

  def make_empty(in_x, in_y)
    @seat_map[in_y][in_x] = "L"
  end

  def is_seat?(in_x, in_y)
    return false if !on_map?(in_x, in_y)
    @seat_map[in_y][in_x] != "."
  end

  def on_map?(in_x, in_y)
    in_x >= 0 && in_x < @size_x && in_y >= 0 && in_y < @size_y
  end

  def show_seatmap
    puts "\e[H\e[2J" # clear the terminal for more fun
    @seat_map.each do |line|
      puts line
    end
  end

  def adjacent_occupied_count_for(x,y)
    the_count = 0
    DELTA_MOVES.each do |move|
      delta_x, delta_y = move[0], move[1]
      the_count += 1 if is_occupied?(x + delta_x, y + delta_y)
    end
    the_count
  end

  def visible_occupied_count_for(x,y)
    the_count = 0
    DELTA_MOVES.each do |move|
      delta_x, delta_y = move[0], move[1]
      the_check_x, the_check_y = x + delta_x, y + delta_y
      while on_map?(the_check_x, the_check_y) && !is_seat?(the_check_x, the_check_y)
        the_check_x += delta_x
        the_check_y += delta_y
      end
      the_count += 1 if is_occupied?(the_check_x, the_check_y)
    end
    the_count
  end

  # returns number of changed seats
  def conway_step_part1(in_src_map)
    the_change_count = 0
    0.upto(@size_x-1) do |x|
      0.upto(@size_y-1) do |y|
        if in_src_map.is_seat?(x,y)
          occupied_count = in_src_map.adjacent_occupied_count_for(x,y)
          if (occupied_count == 0) && (!in_src_map.is_occupied?(x,y))
            occupy(x,y)
            the_change_count += 1
          elsif (occupied_count >= 4) && (in_src_map.is_occupied?(x,y))
            make_empty(x,y)
            the_change_count += 1
          end
        end
      end
    end
    the_change_count
  end

  def conway_step(in_src_map)
    the_change_count = 0
    0.upto(@size_x-1) do |x|
      0.upto(@size_y-1) do |y|
        if in_src_map.is_seat?(x,y)
          occupied_count = in_src_map.visible_occupied_count_for(x,y)
          if (occupied_count == 0) && (!in_src_map.is_occupied?(x,y))
            occupy(x,y)
            the_change_count += 1
          elsif (occupied_count >= 5) && (in_src_map.is_occupied?(x,y))
            make_empty(x,y)
            the_change_count += 1
          end
        end
      end
    end
    the_change_count
  end
end

the_src_map = SeatMap.new('day_11_input.txt')
the_src_map.show_seatmap

the_changed_count = 1
while the_changed_count > 0
  the_dst_map = Marshal.load(Marshal.dump(the_src_map)) # deep copy
  # the_changed_count = the_dst_map.conway_step_part1(the_src_map)
  the_changed_count = the_dst_map.conway_step(the_src_map)

  the_dst_map.show_seatmap
  the_src_map = Marshal.load(Marshal.dump(the_dst_map))
end

puts "=" * 10
puts the_src_map.occupied_count
