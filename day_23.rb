line = "624397158"

cups = line.split("").map(&:to_i)
min_cup, max_cup = cups.minmax
current = cups[0]

100.times do
  index = cups.index(current)
  next_three = cups.slice!((index+1)..(index+3))
  next_three += cups.slice!(0, 3 - next_three.size)

  dest_cup = current - 1
  if dest_cup < min_cup
    dest_cup = max_cup
  end
  while next_three.include?(dest_cup)
    dest_cup -= 1
    if dest_cup < min_cup
      dest_cup = max_cup
    end
  end
  # insert
  dest_index = cups.index(dest_cup)
  if dest_index < cups.size - 1
    cups = cups[0..dest_index] + next_three + cups[(dest_index + 1)..-1]
  else
    cups = cups[0..dest_index] + next_three
  end

  index = cups.index(current) + 1
  index = 0 if index >= cups.size
  current = cups[index]
end

while cups[-1] != 1
  cups = cups.rotate
end
puts cups[0...-1].join("")

# part 2
# arrays are too slow
# use a circular double-linked-list with a dictionary to access the nodes by value

class Node
  attr_accessor :prev
  attr_accessor :next
  attr_reader   :value

  def initialize(value)
    @value = value
    @prev  = nil
    @next  = nil
  end

  def to_s
    value.to_s
  end
end

class LinkedList
  attr_accessor :dict
  attr_accessor :head # useful for debugging / outputting the first part

  def initialize
    @head = nil
    @dict = {}
  end

  def append(value)
    new_node = Node.new(value)
    if @head
      tail = @head.prev
      tail.next = new_node
      new_node.next = @head
      @head.prev = new_node
      new_node.prev = tail
    else
      @head = new_node
      @head.prev = @head
      @head.next = @head
    end
    @dict[value] = new_node
  end

  def append_after(node, value)
    new_node = Node.new(value)

    new_node.next = node.next
    node.next = new_node
    new_node.prev = new_node.next.prev
    new_node.next.prev = new_node
    @dict[value] = new_node
  end

  def find(value)
    return @dict[value]
  end

  def delete(value)
    the_node = find(value)
    if the_node
      @head = the_node.next if the_node.value == @head.value # move the head if it will be removed
      the_node.prev.next = the_node.next
      the_node.next.prev = the_node.prev
    end
    @dict.delete(value)
  end
end

line = "624397158"

l = LinkedList.new()

line.split("").map(&:to_i).each do |i|
  l.append(i)
end

max_cup_label = 1000000
10.upto(1000000) do |cup|
  l.append(cup)
end

current_node = l.head
10000000.times do
  deleted_values = []
  3.times do
    v = current_node.next.value
    deleted_values << v
    l.delete(v)
  end

  dest_value = current_node.value - 1
  dest_value = max_cup_label if dest_value <= 0
  while deleted_values.include?(dest_value)
    dest_value -= 1
    dest_value = max_cup_label if dest_value <= 0
  end
  dest_node = l.find(dest_value)
  deleted_values.reverse.each do |v|
    l.append_after(dest_node, v)
  end
  current_node = current_node.next
end
puts l.find(1).next.value * l.find(1).next.next.value
