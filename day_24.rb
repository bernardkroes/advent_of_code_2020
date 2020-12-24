all_lines = File.read('day_24_input.txt').split("\n").map(&:chomp)

MOVE = { # direction => [delta_x, delta_y]
  "e"  => [ 2, 0],
  "ne" => [ 1, 1],
  "nw" => [-1, 1],
  "w"  => [-2, 0],
  "sw" => [-1,-1],
  "se" => [ 1,-1],
}

tiles = Hash.new(0) # hash_key: "x_y" => flipcount (default 0)

all_lines.each do |line|
  x, y = 0, 0
  while line.size > 0
    MOVE.each do |dir,deltas|
      if line.start_with?(dir)
        mv = "e"
        x += deltas[0]
        y += deltas[1]
        line = line[(dir.size)..-1]
      end
    end
  end
  hash_key = "#{x}_#{y}"
  tiles[hash_key] += 1
end

def count_black_tiles(in_tiles)
  black_tile_count = 0
  in_tiles.each do |k, flipcount|
    black_tile_count += 1 if flipcount % 2 == 1
  end
  black_tile_count
end

puts count_black_tiles(tiles)

# part 2
# conway again

def count_black_tiles_around(in_tiles, tile_x, tile_y)
  black_tile_count = 0
  MOVE.each do |dir, deltas|
    other_tile_x = tile_x + deltas[0]
    other_tile_y = tile_y + deltas[1]
    hash_key = "#{other_tile_x}_#{other_tile_y}"
    black_tile_count += 1 if (in_tiles[hash_key] % 2 == 1)
  end
  black_tile_count
end

def conway_step(in_tiles, out_tiles)
  in_tiles.each do |tile_key, flipcount| # check all neighbors of known tiles
    if flipcount % 2 == 1                # that are black
      tile_x, tile_y = tile_key.split("_").map(&:to_i)
      # for all neighbors
      MOVE.each do |dir, deltas|
        check_tile_x = tile_x + deltas[0]
        check_tile_y = tile_y + deltas[1]
        hash_key = "#{check_tile_x}_#{check_tile_y}"
        is_tile_black = (in_tiles[hash_key] % 2 == 1)
        black_tile_count = count_black_tiles_around(in_tiles, check_tile_x, check_tile_y)
        if is_tile_black
          out_tiles[hash_key] = 1 if black_tile_count == 1 || black_tile_count == 2
        else
          out_tiles[hash_key] = 1 if black_tile_count == 2
        end
      end
    end
  end
  out_tiles
end

100.times do |d|
  the_new_tiles = Hash.new(0)
  conway_step(tiles, the_new_tiles)
  puts "Day #{d+1}: #{count_black_tiles(the_new_tiles)}"
  tiles = the_new_tiles
end
