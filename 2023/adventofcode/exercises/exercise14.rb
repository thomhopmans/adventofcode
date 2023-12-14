require_relative 'helpers/exercise'

class Exercise14 < Exercise
  EXERCISE_NUMBER = 14

  CUBE_ROCK = '#'.freeze
  ROUNDED_ROCK = 'O'.freeze
  MAX_CYCLE_ITERATIONS = 1_000_000_000

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    new_grid = roll_rocks(grid.transpose).transpose
    score(new_grid)
  end

  def run_b(data)
    grid = to_grid(data)

    # Find repeating states every N cycles
    state_per_iteration = {}
    cycle_length, cycle_start_iteration = find_iteration_cycle(grid, state_per_iteration)
    remaining_cycle_iterations = MAX_CYCLE_ITERATIONS - cycle_start_iteration
    remaining_iterations = remaining_cycle_iterations % cycle_length

    # Calculate score for state of identical iteration
    mirror_size = grid.first.size
    iteration_with_same_state = cycle_start_iteration - cycle_length + remaining_iterations
    score(state_per_iteration.find { |_key, value| value == iteration_with_same_state }.first.scan(/.{#{mirror_size}}/).map(&:chars))
  end

  private

  def to_grid(data)
    data.split("\n").map(&:chars)
  end

  def find_iteration_cycle(grid, state_per_iteration)
    (1..MAX_CYCLE_ITERATIONS).each do |iteration|
      grid = cycle(grid)
      state_key = grid.flatten.join

      if state_per_iteration.key?(state_key)
        return iteration - state_per_iteration[state_key], iteration
      else
        state_per_iteration[state_key] = iteration
      end
    end

    [nil, nil] # Return nil if no cycle is found
  end

  def cycle(grid)
    # Could be more efficient using one-step transformations instead of step-by-step
    grid = roll_rocks(grid.transpose).transpose.transpose.transpose  # North
    grid = roll_rocks(grid.transpose.transpose).transpose.transpose  # West
    grid = roll_rocks(grid.reverse.transpose).transpose.reverse # South
    roll_rocks(grid.map(&:reverse)).map(&:reverse) # East
  end

  def score(grid)
    mirror_size = grid.first.size
    grid.transpose
      .map { |line| line.each_index.select { |i| line[i] == ROUNDED_ROCK } }
      .map { |line| line.map { |x| mirror_size - x }.sum }.sum
  end

  def roll_rocks(grid)
    mirror_size = grid.first.size # grid is square

    grid.map do |line|
      indices_of_cube_rocks = [-1] + line.each_index.select { |i| line[i] == CUBE_ROCK }
      indices_of_rounded_rocks = line.each_index.select { |i| line[i] == ROUNDED_ROCK }

      # Find the highest element in the cube rocks array that is lower than the element in the rounded rocks array
      max_lower_values = indices_of_rounded_rocks.map { |el| indices_of_cube_rocks.select { |x| x < el } }.map(&:max).map { _1 + 1 }
      new_positions = increase_equals(max_lower_values)

      # Recreate line, could be more efficient using sparse matrix rotations
      line_shifted = Array.new(mirror_size, '.')
      new_positions.each { |i| line_shifted[i] = ROUNDED_ROCK }
      indices_of_cube_rocks[1..].each { |i| line_shifted[i] = CUBE_ROCK }

      line_shifted
    end
  end

  def increase_equals(array)
    occurrences = Hash.new(0)
    array.each_with_index do |num, index|
      occurrences[num] += 1
      array[index] += occurrences[num] - 1
    end
    array
  end
end
