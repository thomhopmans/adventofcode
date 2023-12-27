require_relative 'helpers/exercise'
require 'matrix'

class GridSquare
  attr_reader :positions, :grid, :size

  def initialize(input)
    @size = input.lines.count # grid is square
    @grid = Set.new
    @positions = Set.new

    input.each_line.with_index do |line, y|
      line.each_char.with_index do |c, x|
        if c == '#'
          @grid.add([x, y])
        end
        if c == 'S'
          @positions.add([x, y])
        end
      end
    end
  end

  def step
    new_pos = Set.new
    @positions.each do |p|
      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
        to_pos = [p[0] + dx, p[1] + dy]
        new_pos.add(to_pos) unless @grid.include?(wrap(to_pos))
      end
    end
    @positions = new_pos
  end

  def wrap(pos)
    [pos[0] % @size, pos[1] % @size]
  end
end

class Exercise21 < Exercise
  EXERCISE_NUMBER = 21

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data, steps: 64)
    g = GridSquare.new(data)
    steps.times do
      g.step
    end
    g.positions.count
  end

  def run_b(data, steps: 26501365)
    # 131 is length of grid, 65 is half length
    grid_width = data.split("\n").size
    steps_to_edge = (data.split("\n").size / 2).floor

    # Find how many positions one can visit within one grid, one grid further, and one more grid.
    # Possible positions grows quadratically per new grid reached.
    g = GridSquare.new(data)
    y = []

    (steps_to_edge + (grid_width * 2) + 1).times do |s|
      if s % grid_width == steps_to_edge
        y << g.positions.count
      end
      g.step
    end

    x = [0, 1, 2]
    poly = fit_polynomial_regression(x, y, 2).map(&:round)

    # Predict for the desired number of steps using the polynomial
    target = (steps - steps_to_edge) / grid_width
    (0..2).sum { |i| poly[i] * (target**i) }
  end

  def fit_polynomial_regression(x, y, degree)
    rows = x.map do |i|
      (0..degree).map { |power| (i**power).to_f }
    end
    mx = Matrix.rows(rows)
    my = Matrix.columns([y])
    ((mx.transpose * mx).inv * mx.transpose * my).transpose.row(0).to_a
  end
end
