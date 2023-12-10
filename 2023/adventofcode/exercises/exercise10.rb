require_relative 'helpers/exercise'

class Exercise10 < Exercise
  EXERCISE_NUMBER = 10

  DIRECTIONS = [
    [-1, 0], # North
    [0, 1], # East
    [1, 0], # South
    [0, -1], # West
  ].freeze
  PIPES_TO_NORTH = ['|', 'L', 'J', 'S'].freeze
  PIPES_FROM_NORTH = ['|', '7', 'F'].freeze
  PIPES_TO_EAST = ['-', 'F', 'L', 'S'].freeze
  PIPES_FROM_EAST = ['-', '7', 'J'].freeze
  PIPES_TO_SOUTH = ['|', 'F', '7', 'S'].freeze
  PIPES_FROM_SOUTH = ['|', 'L', 'J'].freeze
  PIPES_TO_WEST = ['-', '7', 'J', 'S'].freeze
  PIPES_FROM_WEST = ['-', 'L', 'F'].freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    position_s = find_character(grid, 'S')
    grid[position_s[0]][position_s[1]] = s_pipe_character(grid, position_s)

    # Depth first search
    # Note: storing paths makes search a bit slower, but is required for part B
    @candidate_stack = [[position_s, 0, [position_s]]]
    @visited = Set.new
    @path_lengths = []

    until @candidate_stack.empty?
      candidate = @candidate_stack.pop

      next if @visited.include?(candidate[0])

      step(grid, position_s, candidate)
    end

    longest_path = @path_lengths.max_by { |array| array.first }
    (longest_path.first + 1) / 2
  end

  def step(grid, position_s, traverse_path)
    @visited.add(traverse_path[0])

    new_positions = connected_directions(grid, traverse_path[0])
      .map { elem_addition(traverse_path[0], _1) }

    if new_positions.include?(position_s)
      @path_lengths.append([traverse_path[1], traverse_path[2]])
    end

    new_positions = new_positions.reject { traverse_path.include?(_1) && _1 != position_s }

    if new_positions.empty?
      return
    end

    new_positions.map do |new_pos|
      @candidate_stack << [new_pos, traverse_path[1] + 1, traverse_path[2] + [new_pos]]
    end
  end

  def run_b(_data)
    0
  end

  private

  def elem_addition(array1, array2)
    array1.zip(array2).map { |a, b| a + b }
  end

  def to_grid(data)
    data.split("\n").map(&:chars)
  end

  def find_character(grid, target_char)
    rows = grid.length
    columns = grid.first.length

    (0...rows).each do |i|
      (0...columns).each do |j|
        if grid[i][j] == target_char
          return [i, j]
        end
      end
    end

    nil
  end

  def s_pipe_character(grid, position)
    case connected_directions(grid, position)
      when [[-1, 0], [0, -1]]
        'J'
      when [[0, 1], [1, 0]]
        'F'
      else
        # Not implemented
        raise
    end
  end

  # rubocop: disable Metrics/PerceivedComplexity
  def connected_directions(grid, position)
    DIRECTIONS.map.with_index do |direction, index|
      new_position = elem_addition(position, direction)

      if position_outside_grid(grid, new_position)
        nil
      else
        current = grid[position[0]][position[1]]
        other = grid[new_position[0]][new_position[1]]

        is_connected_north = index == 0 && PIPES_TO_NORTH.include?(current) && PIPES_FROM_NORTH.include?(other)
        is_connected_east = index == 1 && PIPES_TO_EAST.include?(current) && PIPES_FROM_EAST.include?(other)
        is_connected_south = index == 2 && PIPES_TO_SOUTH.include?(current) && PIPES_FROM_SOUTH.include?(other)
        is_connected_west = index == 3 && PIPES_TO_WEST.include?(current) && PIPES_FROM_WEST.include?(other)

        direction if is_connected_north || is_connected_east || is_connected_south || is_connected_west
      end
    end.compact
  end
  # rubocop: enable Metrics/PerceivedComplexity

  def position_outside_grid(grid, position)
    rows = grid.length
    columns = grid.first.length
    position[0] < 0 || position[0] >= rows || position[1] < 0 || position[1] >= columns
  end
end
