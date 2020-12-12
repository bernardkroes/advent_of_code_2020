the_lines = File.read('day_12_input.txt').split("\n").map(&:chomp)

DELTA_MOVES = [[-1,0],[ 0,-1],[ 1,0], [0,1]] # W, N, E, S
WEST = 0
NORTH = 1
EAST = 2
SOUTH = 3

def move(the_x, the_y, in_direction, arg)
  return the_x + arg * DELTA_MOVES[in_direction][0], the_y + arg * DELTA_MOVES[in_direction][1]
end

the_x, the_y = 0, 0
the_dir = 2 # index in DELTA_MOVES
the_lines.each do |line|
  ins = line[0]
  arg = line[1..-1].to_i

  case ins
  when "N"
    the_x, the_y = move(the_x, the_y, NORTH, arg)
  when "S"
    the_x, the_y = move(the_x, the_y, SOUTH, arg)
  when "E"
    the_x, the_y = move(the_x, the_y, EAST, arg)
  when "W"
    the_x, the_y = move(the_x, the_y, WEST, arg)
  when "L"
    the_dir -= (arg / 90)
    the_dir = the_dir % 4
  when "R"
    the_dir += (arg / 90)
    the_dir = the_dir % 4
  when "F"
    the_x, the_y = move(the_x, the_y, the_dir, arg)
  end
end

puts "the_x: #{the_x}"
puts "the_y: #{the_y}"
puts the_x.abs + the_y.abs

# part 2
the_x, the_y = 0, 0
waypoint_x, waypoint_y = 10, -1

the_lines.each do |line|
  ins = line[0]
  arg = line[1..-1].to_i

  case ins
  when "N"
    waypoint_x, waypoint_y = move(waypoint_x, waypoint_y, NORTH, arg)
  when "S"
    waypoint_x, waypoint_y = move(waypoint_x, waypoint_y, SOUTH, arg)
  when "E"
    waypoint_x, waypoint_y = move(waypoint_x, waypoint_y, EAST, arg)
  when "W"
    waypoint_x, waypoint_y = move(waypoint_x, waypoint_y, WEST, arg)
  when "L"
    (arg/90).to_i.times do
      waypoint_x, waypoint_y = waypoint_y, -waypoint_x
    end
  when "R"
    (arg/90).to_i.times do
      waypoint_x, waypoint_y = -waypoint_y, waypoint_x
    end
  when "F"
    the_x += arg * waypoint_x
    the_y += arg * waypoint_y
  end
end

puts "-" * 20
puts "the_x: #{the_x}"
puts "the_y: #{the_y}"
puts "waypoint_x: #{waypoint_x}"
puts "waypoint_y: #{waypoint_y}"
puts the_x.abs + the_y.abs
