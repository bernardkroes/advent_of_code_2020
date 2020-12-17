taken = []
lines = File.read('day_17_input.txt').split("\n").map(&:chomp)

z = 0
lines.each_with_index do |l, y|
  l.chars.each_with_index do |c, x|
    if c == "#"
      taken << [x,y,z]
    end
  end
end

def array_contains_point?(in_array, p)
  in_array.any? { |e| e[0] == p[0] && e[1] == p[1] && e[2] == p[2] }
end

def count_taken_around(in_taken, p)
  occupy_count = 0
  (-1..1).each do |dx|
    (-1..1).each do |dy|
      (-1..1).each do |dz|
        next if dx == 0 && dy == 0 && dz == 0
        occupy_count += 1 if array_contains_point?(in_taken, [p[0] + dx, p[1] + dy, p[2] + dz])
      end
    end
  end
  occupy_count
end

6.times do |step|
  new_taken = []
  seen = []
  taken.each do |p|
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        (-1..1).each do |dz|
          walk_p = [p[0] + dx, p[1] + dy, p[2] + dz]
          next if array_contains_point?(seen, walk_p)

          occupy_count = count_taken_around(taken, walk_p)
          if array_contains_point?(taken, walk_p)
            new_taken << walk_p if occupy_count == 2 || occupy_count == 3
          else
            new_taken << walk_p if occupy_count == 3
          end
          seen << walk_p
        end
      end
    end
  end
  taken = new_taken.clone
end
puts taken.size
puts "=" * 20

# part 2: 4-dimensional
# arrays are too slow, use hashes
z = 0
w = 0
taken = {}

def add_to_hash(seen, p)
  hash_key = "#{p[0]}_#{p[1]}_#{p[2]}_#{p[3]}"
  seen[hash_key] = 1
end

lines.each_with_index do |l, y|
  l.chars.each_with_index do |c, x|
    if c == "#"
      add_to_hash(taken, [x,y,z,w])
    end
  end
end

def hash_count_taken_around(in_taken, p)
  occupy_count = 0
  (-1..1).each do |dx|
    (-1..1).each do |dy|
      (-1..1).each do |dz|
        (-1..1).each do |dw|
          next if dx == 0 && dy == 0 && dz == 0 && dw == 0
          occupy_count += 1 if hash_contains_points?(in_taken, [p[0] + dx, p[1] + dy, p[2] + dz, p[3] + dw])
        end
      end
    end
  end
  occupy_count
end

def hash_contains_points?(in_hash, p)
  in_hash.has_key?("#{p[0]}_#{p[1]}_#{p[2]}_#{p[3]}")
end


6.times do |step|
  new_taken = {}
  seen = {}
  taken.each do |k,v|
    p = k.to_s.split("_").map(&:to_i) # hash_key to point (array)
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        (-1..1).each do |dz|
          (-1..1).each do |dw|
            walk_p = [p[0] + dx, p[1] + dy, p[2] + dz, p[3] + dw]
            next if hash_contains_points?(seen, walk_p)

            occupy_count = hash_count_taken_around(taken, walk_p)
            if hash_contains_points?(taken, walk_p)
              add_to_hash(new_taken, walk_p) if occupy_count == 2 || occupy_count == 3
            else
              add_to_hash(new_taken, walk_p) if occupy_count == 3
            end
            add_to_hash(seen, walk_p)
          end
        end
      end
    end
  end
  taken = new_taken.clone
end

puts taken.size

