require_relative 'helpers/exercise'

class Exercise04 < Exercise
  EXERCISE_NUMBER = 4

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    instructions.split("\n").map do |line|
      # Parse
      winning_numbers = line.scan(/:(.*?)\|/).flatten.first.split.map(&:to_i)
      my_numbers = line.split('| ')[1].split.map(&:to_i)
      matches = my_numbers.intersection(winning_numbers)

      # Points calculation
      points = 2.pow(matches.size - 1) unless matches.empty?
      points
    end.compact.sum
  end

  def run_b(instructions)
    game_map = {}
    instructions.split("\n").map do |line|
      # Parse
      card_number = line.match(/Card\s{1,3}(\d{1,3}):/)[1].to_i
      winning_numbers = line.scan(/:(.*?)\|/).flatten.first.split.map(&:to_i)
      my_numbers = line.split('| ')[1].split.map(&:to_i)
      n_matches = my_numbers.intersection(winning_numbers).size

      game_map[card_number] = n_matches
    end

    # Calculate earned scratchcards per card
    cards = {}
    game_map.each_key do |x|
      cards[x] = 1
    end

    max_card = game_map.keys.max

    (1..max_card).each do |card_number|
      won_cards = game_map[card_number]
      (1..won_cards).each do |j|
        cards[card_number + j] += cards[card_number]
      end
    end

    cards.values.sum
  end
end
