require_relative 'helpers/exercise'

class Exercise07 < Exercise
  EXERCISE_NUMBER = 7

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    hands = instructions.split("\n").map do |line|
      hand, bid = line.split
      Hand.new(hand, bid, jokers: false)
    end

    hands.sort.map.with_index { |x, index| x.bid * (index + 1) }.sum
  end

  def run_b(instructions)
    hands = instructions.split("\n").map do |line|
      hand, bid = line.split
      Hand.new(hand, bid, jokers: true)
    end

    hands.sort.map.with_index { |x, index| x.bid * (index + 1) }.sum
  end
end

module Value
  FIVE_OF_A_KIND = 7
  FOUR_OF_A_KIND = 6
  FULL_HOUSE = 5
  THREE_OF_A_KIND = 4
  TWO_PAIR = 3
  ONE_PAIR = 2
  HIGH_CARD = 1
end

class Hand
  attr_reader :hand, :bid

  def initialize(hand, bid, jokers: false)
    @hand = hand
    @bid = bid.to_i
    card_order = if jokers
      ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', '?', 'Q', 'K', 'A'].freeze
    else
      ['?', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'].freeze
    end
    @card_values = @hand.chars.map { |x| card_order.index(x) + 1 }
  end

  def <=>(other)
    strength.each_with_index do |value, index|
      comparison_result = value <=> other.strength[index]

      return comparison_result if [-1, 1].include?(comparison_result)
    end
  end

  def strength
    # Calculate strength of hand
    card_frequency = @card_values.each_with_object(Hash.new(0)) { |card, object| object[card.to_i] += 1 }
    sorted_hash = card_frequency.sort_by { |key, value| [-value, -key] }.to_h
    n_jokers = sorted_hash[1] || 0 # Joker has key 1

    if n_jokers > 0
      [score_hand_with_jokers(sorted_hash, n_jokers)] + @card_values
    else
      [score_hand_with_no_jokers(sorted_hash)] + @card_values
    end
  end

  def score_hand_with_no_jokers(sorted_hash)
    case sorted_hash.values
      when [5]
        Value::FIVE_OF_A_KIND
      when [4, 1]
        Value::FOUR_OF_A_KIND
      when [3, 2]
        Value::FULL_HOUSE
      when [3, 1, 1]
        Value::THREE_OF_A_KIND
      when [2, 2, 1]
        Value::TWO_PAIR
      when [2, 1, 1, 1]
        Value::ONE_PAIR
      when [1, 1, 1, 1, 1]
        Value::HIGH_CARD
      else
        raise
    end
  end

  def score_hand_with_jokers(sorted_hash, n_jokers)
    case sorted_hash.values
      when [5], [4, 1], [3, 2]
        Value::FIVE_OF_A_KIND
      when [3, 1, 1]
        Value::FOUR_OF_A_KIND
      when [2, 2, 1]
        case n_jokers
          when 2
            Value::FOUR_OF_A_KIND
          when 1
            Value::FULL_HOUSE
        end
      when [2, 1, 1, 1]
        Value::THREE_OF_A_KIND
      when [1, 1, 1, 1, 1]
        Value::ONE_PAIR
      else
        raise
    end
  end
end
