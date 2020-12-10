all_jolts = File.read('day_10_input.txt').split("\n").map(&:to_i).sort

all_delta_jolts = [all_jolts[0]]
all_jolts[1..-1].each_with_index do |jolt, i|
  all_delta_jolts << jolt - all_jolts[i]
end
puts all_delta_jolts.count(1) * (all_delta_jolts.count(3) + 1)

# part 2
graph = {}
all_jolts.unshift(0) # start at zero
all_jolts.each do |j|
  graph[j] = []
  (j+1).upto(j+3) { |i| graph[j] << i if all_jolts.include?(i) }
end

def count_paths(graph, src, dest, cache = {})
  cache_hashkey = "#{src}_#{dest}"

  if not cache.has_key?(cache_hashkey)
    return 1 if src == dest
    the_count = 0
    graph[src].each do |e|
      the_count += count_paths(graph, e, dest, cache)
    end
    cache[cache_hashkey] = the_count
  end
  return cache[cache_hashkey]
end

puts count_paths(graph, all_jolts[0], all_jolts[-1])
