require_relative 'helpers/exercise'
require_relative 'helpers/grid'

NORTH = [-1, 0].freeze
EAST = [0, 1].freeze
SOUTH = [1, 0].freeze
WEST = [0, -1].freeze

class Exercise10 < Exercise
  EXERCISE_NUMBER = 10

  DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze
  PIPES_TO_NORTH = ['|', 'L', 'J', 'S'].freeze
  PIPES_TO_EAST = ['-', 'F', 'L', 'S'].freeze
  PIPES_TO_SOUTH = ['|', 'F', '7', 'S'].freeze
  PIPES_TO_WEST = ['-', '7', 'J', 'S'].freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    position_s = find_character(grid, 'S')
    grid = replace_s_character_with_pipe(grid, position_s)

    path = find_path(grid, position_s)
    (path.size + 1) / 2
  end

  def run_b(data)
    grid = to_grid(data)
    position_s = find_character(grid, 'S')
    grid = replace_s_character_with_pipe(grid, position_s)
    path = find_path(grid, position_s)

    enclosed(grid, path)
  end

  def find_path(grid, position_s)
    # Depth first search to find path
    # Note: storing paths makes search a bit slower, but is required for part B
    @candidate_stack = [[position_s, 0, [position_s]]]
    @visited = Set.new
    @path_lengths = []

    until @candidate_stack.empty?
      candidate = @candidate_stack.pop

      next if @visited.include?(candidate[0])

      step(grid, position_s, candidate)
    end

    @path_lengths.max_by(&:first)[1]
  end

  def step(grid, position_s, path)
    @visited.add(path[0])

    new_positions = next_points(grid, path[0])
    if new_positions.include?(position_s)
      @path_lengths.append([path[1], path[2]])
    end

    new_positions = new_positions.reject { path.include?(_1) && _1 != position_s }
    if new_positions.empty?
      return
    end

    new_positions.map do |new_pos|
      @candidate_stack << [new_pos, path[1] + 1, path[2] + [new_pos]]
    end
  end

  def enclosed(grid, longest_path)
    (0...grid.length).map do |y|
      inside = false # Assuming left most point is outside
      (0...grid.first.length).map do |x|
        # Every time we hit a pipe ON the path, we move either out->in or in>out
        if '|JLS'.chars.include?(grid[y][x]) && longest_path.include?([y, x])
          inside = !inside
        end

        # Only enclosed when not on path
        next unless inside && !longest_path.include?([y, x])

        1
      end.flatten
    end.flatten.compact.sum
  end

  private

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

  def replace_s_character_with_pipe(grid, position)
    adjacent_points = DIRECTIONS.map { |direction| elem_addition(position, direction) }
    adjacent_chars = adjacent_points.map { |point| outside_grid(grid, point) ? '?' : grid[point[0]][point[1]] }
    adjacent_connections = [
      PIPES_TO_SOUTH.include?(adjacent_chars[0]),
      PIPES_TO_WEST.include?(adjacent_chars[1]),
      PIPES_TO_NORTH.include?(adjacent_chars[2]),
      PIPES_TO_EAST.include?(adjacent_chars[3]),
    ]
    grid[position[0]][position[1]] = case adjacent_connections
      when [true, false, false, true]
        'J'
      when [false, true, true, false]
        'F'
      when [false, false, true, true]
        '7'
      when [true, true, false, false]
        'L'
      when [true, false, true, false]
        '|'
      when [false, true, false, true]
        '-'
      else
        raise
    end
    grid
  end

  def next_points(grid, position)
    current = grid[position[0]][position[1]]
    case current
      when 'J'
        [DIRECTIONS[0], DIRECTIONS[3]]
      when 'L'
        [DIRECTIONS[0], DIRECTIONS[1]]
      when 'F'
        [DIRECTIONS[1], DIRECTIONS[2]]
      when '7'
        [DIRECTIONS[2], DIRECTIONS[3]]
      when '|'
        [DIRECTIONS[0], DIRECTIONS[2]]
      when '-'
        [DIRECTIONS[1], DIRECTIONS[3]]
    end
      .map { |direction| elem_addition(position, direction) }
      .filter_map { |pos| pos unless outside_grid(grid, pos) }
  end

  def elem_addition(array1, array2)
    array1.zip(array2).map { |a, b| a + b }
  end

  def outside_grid(grid, point)
    rows = grid.length
    columns = grid.first.length
    point[0] < 0 || point[0] >= rows || point[1] < 0 || point[1] >= columns
  end
end
