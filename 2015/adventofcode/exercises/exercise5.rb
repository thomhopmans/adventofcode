require 'digest'

EXERCISE = 5

VOWELS = ['a', 'e', 'i', 'o', 'u'].freeze
MUST_NOT_CONTAIN = ['ab', 'cd', 'pq', 'xy'].freeze

class Exercise5
  def run
    puts "Exercise #{EXERCISE}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    n_nice = 0

    data.each do |line|
      has_three_vowels = line.chars.filter_map { _1 if VOWELS.include?(_1) }.size >= 3
      twice_in_row = line.chars.map.with_index { |value, index| value == line.chars[index + 1] }.any?
      no_forbidden_sequence = MUST_NOT_CONTAIN.filter_map { _1 if line.include?(_1) }.empty?

      is_nice = has_three_vowels & twice_in_row & no_forbidden_sequence

      if is_nice
        n_nice += 1
      end
    end

    n_nice
  end

  def run_b(data)
    n_nice = 0

    data.each do |line|
      characters = line.chars

      # Two Pairs?
      has_two_pairs = false
      characters.each.with_index do |value, index|
        break if characters[index + 1].nil?

        search_string = value + characters[index + 1]
        characters[(index + 2)..].each.with_index do |other_value, other_index|
          effective_other_index = other_index + 3 + index
          break if characters[effective_other_index].nil?

          other_pair = other_value + characters[effective_other_index]
          if search_string == other_pair
            has_two_pairs = true
            break
          end
        end
      end

      # One repeating letter?
      one_repeating_letter = line.chars.map.with_index { |value, index| value == line.chars[index + 2] }.any?

      is_nice = has_two_pairs & one_repeating_letter

      if is_nice
        n_nice += 1
      end
    end

    n_nice
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise#{EXERCISE}.txt").split("\n")
  end
end

Exercise5.new.run
