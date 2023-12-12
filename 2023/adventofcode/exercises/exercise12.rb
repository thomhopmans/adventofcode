require_relative 'helpers/exercise'

class Exercise12 < Exercise
  EXERCISE_NUMBER = 12

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    data.split("\n").sum do |line|
      springs, clues = line.split
      solve_line(springs.chars, clues.split(',').map(&:to_i))
    end
  end

  def run_b(data)
    data.split("\n").sum do |line|
      springs, clues = line.split
      springs = 5.times.map { springs }.join('?')
      clues = 5.times.map { clues }.join(',')
      solve_line(springs.chars, clues.split(',').map(&:to_i))
    end
  end

  def solve_line(springs, blocks)
    @cache_map = Hash.new(0)
    partial(springs, blocks)
  end

  def partial(remaining_springs, remaining_blocks)
    cache_key = remaining_springs.join + remaining_blocks.join

    if @cache_map.key?(cache_key)
      return @cache_map[cache_key]
    end

    return 0 if remaining_blocks.empty? && remaining_springs.include?('#')
    return 1 if remaining_blocks.empty? && !remaining_springs.include?('#')

    n_arrangements = 0

    # Create all possible solutions for only the next block + the required separating dot.
    # Solutions are capped by the max position for the current block given remaining spring lengths and groups
    current_block_size = remaining_blocks.shift
    remaining_spring_spaces = remaining_blocks.sum + remaining_blocks.size
    max_position_for_current_block = remaining_springs.size - remaining_spring_spaces - current_block_size

    (0..max_position_for_current_block).each do |start_position|
      partial_solution = Array.new(start_position + current_block_size + 1, '.')
      (start_position...start_position + current_block_size).each { |i| partial_solution[i] = '#' }

      # Check if solution has a conflict with a spring at any position
      conflicts = remaining_springs.zip(partial_solution).any? do |spring_char, solution_char|
        next if spring_char.nil? || solution_char.nil?

        spring_char != solution_char && spring_char != '?'
      end

      next if conflicts

      n_arrangements += partial(remaining_springs[partial_solution.size..] || [], remaining_blocks.dup)
    end

    @cache_map[cache_key] = n_arrangements

    n_arrangements
  end
end
