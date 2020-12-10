require 'benchmark'

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
  return 1 if src == dest
  return cache[src] if cache.has_key?(src)

  the_count = 0
  graph[src].each do |e|
    the_count += count_paths(graph, e, dest, cache)
  end
  cache[src] = the_count
  cache[src]
end

def count_using_dp(all_jolts, i, dest, cache = {})
  return 1 if i == dest
  return cache[i] if cache.has_key?(i)

  the_count = 0
  (i+1).upto(i+3) do |j|
    if all_jolts.include?(j)
      the_count += count_using_dp(all_jolts, j, dest, cache)
    end
  end
  cache[i] = the_count
  cache[i]
end


Benchmark.bmbm do |x|
  x.report(:graph) do
    count_paths(graph, all_jolts[0], all_jolts[-1])
  end
  x.report(:dp) do
    count_using_dp(all_jolts, all_jolts[0], all_jolts[-1])
  end
end

puts count_paths(graph, all_jolts[0], all_jolts[-1])
puts count_using_dp(all_jolts, all_jolts[0], all_jolts[-1])

