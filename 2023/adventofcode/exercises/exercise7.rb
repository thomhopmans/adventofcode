require_relative 'helpers/range'

class Hand
  attr_reader :hand, :bid, :rank_name

  def initialize(hand, bid)
    @hand = hand
    @bid = bid.to_i
    @rank_id = nil
    @rank_name = nil
    @rank_cards = nil

    score
  end

  def to_s
    "#{@hand} #{bid} #{@rank_name} #{value} \n"
  end

  def value
    [@rank_id] + @rank_cards.map(&:to_i)
  end

  def <=>(other)
    value.each_with_index do |value, index|
      comparison_result = value <=> other.value[index]

      if comparison_result == 1
        return 1
      elsif comparison_result == -1
        return -1
      end
    end
  end

  def score
    # Count occurrences of each rank
    @rank_cards = hand.chars
      .map { |element| element == 'A' ? '14' : element }
      .map { |element| element == 'K' ? '13' : element }
      .map { |element| element == 'Q' ? '12' : element }
      .map { |element| element == 'J' ? '11' : element }
      .map { |element| element == 'T' ? '10' : element }

    rank_counts = Hash.new(0)
    @rank_cards.each { |card| rank_counts[card.to_i] += 1 }

    # Check for various hands
    sorted_hash = rank_counts.sort_by { |key, value| [-value, -key] }.to_h
    case sorted_hash.values
      when [5]
        @rank_id = 7
        @rank_name = 'Five of a Kind'
      when [4, 1]
        @rank_id = 6
        @rank_name = 'Four of a Kind'
      when [3, 2]
        @rank_id = 5
        @rank_name = 'Full House'
      when [3, 1, 1]
        @rank_id = 4
        @rank_name = 'Three of a Kind'
      when [2, 2, 1]
        @rank_id = 3
        @rank_name = 'Two Pair'
      when [2, 1, 1, 1]
        @rank_id = 2
        @rank_name = 'One Pair'
      when [1, 1, 1, 1, 1]
        @rank_id = 1
        @rank_name = 'High Card'
      else
        raise
    end
  end
end

class JokerHand
  attr_reader :hand, :bid, :rank_name

  def initialize(hand, bid)
    @hand = hand
    @bid = bid.to_i
    @rank_id = nil
    @rank_name = nil
    @rank_cards = nil

    score
  end

  def to_s
    "#{@hand} #{bid} #{@rank_name} #{value} \n"
  end

  def value
    [@rank_id] + @rank_cards.map(&:to_i)
  end

  def <=>(other)
    value.each_with_index do |value, index|
      comparison_result = value <=> other.value[index]

      if comparison_result == 1
        return 1
      elsif comparison_result == -1
        return -1
      end
    end
  end

  def score
    # Count occurrences of each rank
    @rank_cards = hand.chars
      .map { |element| element == 'A' ? '14' : element }
      .map { |element| element == 'K' ? '13' : element }
      .map { |element| element == 'Q' ? '12' : element }
      .map { |element| element == 'J' ? '1' : element }
      .map { |element| element == 'T' ? '10' : element }

    rank_counts = Hash.new(0)
    @rank_cards.each { |card| rank_counts[card.to_i] += 1 }

    # Check for various hands
    sorted_hash = rank_counts.sort_by { |key, value| [-value, -key] }.to_h
    n_jokers = sorted_hash[1] || 0

    if n_jokers > 0

      case sorted_hash.values
        when [5]
          @rank_id = 7
          @rank_name = 'Five of a Kind'
        when [4, 1]
          @rank_id = 7
          @rank_name = 'Five of a Kind'
        when [3, 2]
          @rank_id = 7
          @rank_name = 'Five of a Kind'
        when [3, 1, 1]
          @rank_id = 6
          @rank_name = 'Four of a Kind'
        when [2, 2, 1]
          case n_jokers
            when 2
              @rank_id = 6
              @rank_name = 'Four of a Kind'
            when 1
              @rank_id = 5
              @rank_name = 'Full House'
          end
        when [2, 1, 1, 1]
          @rank_id = 4
          @rank_name = 'Three of a Kind'
        when [1, 1, 1, 1, 1]
          @rank_id = 2
          @rank_name = 'One Pair'
        else
          raise
      end

    else
      case sorted_hash.values
        when [5]
          @rank_id = 7
          @rank_name = 'Five of a Kind'
        when [4, 1]
          @rank_id = 6
          @rank_name = 'Four of a Kind'
        when [3, 2]
          @rank_id = 5
          @rank_name = 'Full House'
        when [3, 1, 1]
          @rank_id = 4
          @rank_name = 'Three of a Kind'
        when [2, 2, 1]
          @rank_id = 3
          @rank_name = 'Two Pair'
        when [2, 1, 1, 1]
          @rank_id = 2
          @rank_name = 'One Pair'
        when [1, 1, 1, 1, 1]
          @rank_id = 1
          @rank_name = 'High Card'
        else
          raise
      end
    end
  end
end

class Exercise7
  def run
    puts 'Exercise 7:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    hands = instructions.split("\n").map do |line|
      line = line.split(' ')
      Hand.new(line[0], line[1])
    end

    # 253638586
    hands.sort.map.with_index { |x, index| x.bid * (index + 1) }.sum
  end

  def run_b(instructions)
    hands = instructions.split("\n").map do |line|
      line = line.split(' ')
      JokerHand.new(line[0], line[1])
    end

    # 253253225
    hands.sort.map.with_index { |x, index| x.bid * (index + 1) }.sum
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise7.txt")
  end
end

Exercise7.new.run
