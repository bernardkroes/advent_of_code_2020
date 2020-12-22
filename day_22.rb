deck1 = []
deck2 = []
init_deck1 = []
init_deck2 = []

for_player1 = true
all_lines = File.read('day_22_input.txt').split("\n").map(&:chomp)
all_lines.each do |line|
  if !line.include?("Player") && line.size > 0
    if for_player1
      deck1 << line.to_i
    else
      deck2 << line.to_i
    end
  else
    if line.include?("Player 2:")
      for_player1 = false
    end
  end
end
init_deck1 = deck1.clone
init_deck2 = deck2.clone

def deck_sum(in_deck)
  the_sum = 0
  in_deck.each_with_index do |card,i|
    the_sum += (card * (in_deck.size - i))
  end
  the_sum
end

while (deck1.size > 0) && (deck2.size > 0)
  c1 = deck1.shift
  c2 = deck2.shift
  if c1 > c2
    deck1 += [c1, c2]
  elsif c2 > c1
    deck2 += [c2, c1]
  end
end

the_sum = deck1.size > 0 ? deck_sum(deck1) : deck_sum(deck2)
puts the_sum
puts "=" * 20

# part 2
# reset the decks
deck1 = init_deck1.clone
deck2 = init_deck2.clone

def combat(deck1, deck2, games_seen) # return winner (1 or 2) or -1: no winner yet
  return 1 if games_seen.any? { |g| g[0] == deck1 && g[1] == deck2 }

  games_seen << [deck1.clone, deck2.clone]

  c1 = deck1.shift
  c2 = deck2.shift

  card_winner = -1
  if (deck1.size >= c1) && (deck2.size >= c2)
    sub_deck1 = deck1[0...(c1)].clone
    sub_deck2 = deck2[0...(c2)].clone

    sub_games_seen = []
    while card_winner < 0
      card_winner = combat(sub_deck1, sub_deck2, sub_games_seen)
    end
  else # as before
    card_winner = c1 > c2 ? 1 : 2
  end
  if card_winner == 1
    deck1 << c1
    deck1 << c2
  elsif card_winner == 2
    deck2 << c2
    deck2 << c1
  end
  return 2 if deck1.size == 0
  return 1 if deck2.size == 0

  return -1
end

games_seen = []
the_winner = -1
while the_winner < 0
  the_winner = combat(deck1, deck2, games_seen)
end

the_sum = (the_winner == 1 ? deck_sum(deck1) : deck_sum(deck2))
puts the_sum

