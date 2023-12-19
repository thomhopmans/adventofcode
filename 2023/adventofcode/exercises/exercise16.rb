require_relative 'helpers/exercise'
require_relative 'helpers/grid'

class Exercise16 < Exercise
  EXERCISE_NUMBER = 16
  EMPTY = '.'.freeze

  DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze
  MIRROR_RIGHT = '/'.freeze
  MIRROR_LEFT = '\\'.freeze
  SPLITTER_TOP_DOWN = '|'.freeze
  SPLITTER_LEFT_RIGHT = '-'.freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    start_candidate = [0, 0, EAST]
    tiles_energized(grid, start_candidate)
  end

  def run_b(data)
    grid = to_grid(data)
    edge_coordinates(grid).map { |sc| tiles_energized(grid, sc) }.max
  end

  private

  def edge_coordinates(grid)
    edge_coords = []

    rows = grid.length
    cols = grid.first.length

    (0...cols).each do |col|
      edge_coords << [0, col, SOUTH]           # Top edge
      edge_coords << [rows - 1, col, NORTH]    # Bottom edge
    end

    (1...(rows - 1)).each do |row|
      edge_coords << [row, 0, EAST]           # Left edge
      edge_coords << [row, cols - 1, WEST]    # Right edge
    end

    edge_coords
  end

  def tiles_energized(grid, start_candidate)
    @beam_stack = [start_candidate]
    @visited = Set.new

    until @beam_stack.empty?
      candidate = @beam_stack.pop

      next if @visited.include?(candidate)

      step(grid, candidate)
    end

    @visited.map { |x| [x[0], x[1]] }.uniq.size
  end

  def step(grid, candidate)
    current_position = [candidate[0], candidate[1]]
    current_direction = candidate[2]

    unless outside_grid?(grid, current_position)
      @visited.add(candidate)
      process_current_position(grid, current_position, current_direction)
    end
  end

  def process_current_position(grid, position, direction)
    current_position_object = grid[position[0]][position[1]]

    case current_position_object
      when EMPTY
        process_empty_position(position, direction)
      when MIRROR_RIGHT
        process_mirror_position(position, direction, 1)
      when MIRROR_LEFT
        process_mirror_position(position, direction, -1)
      when SPLITTER_TOP_DOWN
        process_splitter_position(position, direction, [NORTH, SOUTH])
      when SPLITTER_LEFT_RIGHT
        process_splitter_position(position, direction, [WEST, EAST])
    end
  end

  def process_empty_position(position, direction)
    next_position = elem_addition(position, direction)
    @beam_stack.append([next_position[0], next_position[1], direction])
  end

  def process_mirror_position(position, direction, multiplier)
    new_direction = elem_product(mirror_direction(direction), [multiplier, multiplier])
    next_position = elem_addition(position, new_direction)
    @beam_stack.append([next_position[0], next_position[1], new_direction])
  end

  def process_splitter_position(position, direction, valid_directions)
    if valid_directions.include?(direction)
      next_position = elem_addition(position, direction)
      @beam_stack.append([next_position[0], next_position[1], direction])
    else
      valid_directions.each do |dir|
        next_position = elem_addition(position, dir)
        @beam_stack.append([next_position[0], next_position[1], dir])
      end
    end
  end

  def mirror_direction(current_direction)
    case current_direction
      when EAST
        NORTH
      when SOUTH
        WEST
      when WEST
        SOUTH
      when NORTH
        EAST
    end
  end

  def elem_addition(array1, array2)
    array1.zip(array2).map { |a, b| a + b }
  end

  def elem_product(array1, array2)
    array1.zip(array2).map { |a, b| a * b }
  end

  def outside_grid?(grid, position)
    position[0].negative? || position[0] >= grid.length || position[1].negative? || position[1] >= grid[0].length
  end

  def to_grid(data)
    data.split("\n").map(&:chars)
  end

  def plot_grid(grid)
    grid.each { |row| puts row.join }
  end
end
