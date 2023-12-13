require_relative 'helpers/exercise'

class Exercise13 < Exercise
  EXERCISE_NUMBER = 13

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    allowed_differences = 0
    to_patterns(data).map do |pattern|
      differences_horizontally_and_vertically(pattern, allowed_differences)
    end.sum
  end

  def run_b(data)
    allowed_differences = 1
    to_patterns(data).map do |pattern|
      differences_horizontally_and_vertically(pattern, allowed_differences)
    end.sum
  end

  private

  def to_patterns(data)
    data.split("\n\n").map { _1.split("\n") }
  end

  def differences_horizontally_and_vertically(pattern, allowed_differences)
    row_diffs = count_differences(pattern, allowed_differences)

    transposed_pattern = pattern.map(&:chars).transpose.map(&:join)
    column_diffs = count_differences(transposed_pattern, allowed_differences)

    (row_diffs * 100) + column_diffs
  end

  def count_differences(pattern, allowed_differences)
    (1..pattern.length - 1).each do |i|
      # Divide pattern using horizontal line at i, reverse first to recreate mirror effect
      pattern_slice_1 = pattern[0..i - 1].reverse
      pattern_slice_2 = pattern[i..]

      # Correct for different sizes
      shortest = [pattern_slice_1.size, pattern_slice_2.size].min
      pattern_slice_1 = pattern_slice_1[...shortest]
      pattern_slice_2 = pattern_slice_2[...shortest]

      # Count differences between lines
      n_differences = pattern_slice_1.zip(pattern_slice_2).sum { |l, r| l.chars.zip(r.chars).count { |x, y| x != y } }

      return i if n_differences == allowed_differences
    end
    0
  end
end
