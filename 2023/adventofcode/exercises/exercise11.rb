require_relative 'helpers/exercise'

Point = Struct.new(:x, :y)

class Exercise11 < Exercise
  EXERCISE_NUMBER = 11

  GALAXY = '#'.freeze
  EMPTY = '.'.freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data, 1000000 - 1)}"
  end

  def run_a(data)
    grid = to_grid(data)
    empty_rows = empty_array_indices(grid)
    empty_columns = empty_array_indices(grid.transpose)

    distances = galaxy_pairs(grid).map do |point1, point2|
      calculate_distance(point1, point2, empty_rows, empty_columns, 1)
    end

    distances.sum
  end

  def run_b(data, expansion_size)
    grid = to_grid(data)
    empty_rows = empty_array_indices(grid)
    empty_columns = empty_array_indices(grid.transpose)

    distances = galaxy_pairs(grid).map do |point1, point2|
      calculate_distance(point1, point2, empty_rows, empty_columns, expansion_size)
    end

    distances.sum
  end

  private

  def to_grid(data)
    data.split("\n").map(&:chars)
  end

  def galaxy_pairs(grid)
    galaxy_points(grid).combination(2).to_a
  end

  def galaxy_points(grid)
    rows = grid.length
    columns = grid.first.length

    galaxies = []

    (0...rows).each do |i|
      (0...columns).each do |j|
        if grid[i][j] == GALAXY
          galaxies << Point.new(j, i)
        end
      end
    end

    galaxies
  end

  def empty_array_indices(grid)
    grid.each_index.select { |i| grid[i].all? { |element| element == EMPTY } }
  end

  def calculate_distance(point1, point2, empty_rows, empty_columns, expansion_size)
    # Find rows and columns that require expanding and lie between the two points
    start, finish = [point1.y, point2.y].minmax
    row_expansion = empty_rows.filter_map { |i| 1 if (start..finish).cover?(i) }.sum

    start, finish = [point1.x, point2.x].minmax
    column_expansion = empty_columns.filter_map { |j| 1 if (start..finish).cover?(j) }.sum

    # Distance with expansion
    if point1.x < point2.x
      point2 = Point.new(point2.x + (row_expansion * expansion_size), point2.y)
    else
      point1 = Point.new(point1.x + (row_expansion * expansion_size), point1.y)
    end

    if point1.y < point2.y
      point2 = Point.new(point2.x, point2.y + (column_expansion * expansion_size))
    else
      point1 = Point.new(point1.x, point1.y + (column_expansion * expansion_size))
    end

    (point1.x - point2.x).abs + (point1.y - point2.y).abs
  end
end
