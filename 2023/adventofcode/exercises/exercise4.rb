class Exercise4
  def run
    puts 'Exercise 4:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    instructions.map do |line|
      # Parse
      winning_numbers = line.scan(/:(.*?)\|/).flatten.first.split.map(&:to_i)
      my_numbers = line.split('| ')[1].split.map(&:to_i)
      matches = my_numbers.intersection(winning_numbers)

      points = 2.pow(matches.size - 1) if (matches.size) > 0
      points
    end.compact.sum
  end

  def run_b(instructions)
    game_map = {}
    instructions.map do |line|
      # Parse
      card_number = line.match(/Card\s{1,3}(\d{1,3}):/)[1].to_i
      winning_numbers = line.scan(/:(.*?)\|/).flatten.first.split.map(&:to_i)
      my_numbers = line.split('| ')[1].split.map(&:to_i)
      n_matches = my_numbers.intersection(winning_numbers).size

      game_map[card_number] = n_matches
    end

    # Calculate earned scratch cards per card
    cards = {}
    game_map.keys.each do |x|
      cards[x] = 1
    end

    max_card = game_map.keys.max

    (1..max_card).each do |card_number|
      won_cards = game_map[card_number]
      (1..won_cards).each do |j|
        cards[card_number + j] += (1 * cards[card_number])
      end
    end

    cards.values.sum
  end

  private

  def load_data
    File.read("#{__dir__}/../inputs/exercise4.txt").split("\n")
  end
end

Exercise4.new.run
