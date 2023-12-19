require_relative 'helpers/exercise'
require_relative 'helpers/grid'

class Exercise18 < Exercise
  EXERCISE_NUMBER = 18

  DIRECTIONS = [EAST, SOUTH, WEST, NORTH].freeze
  CHAR_TO_DIRECTION = { 'U' => NORTH, 'D' => SOUTH, 'L' => WEST, 'R' => EAST }.freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    perimeter = 0
    points = [[0, 0]]

    to_lines(data).each do |(direction_char, distance, _hex)|
      distance = distance.to_i
      direction = CHAR_TO_DIRECTION[direction_char]

      perimeter += distance
      points << [points[-1][0] + (distance * direction[0]), points[-1][1] + (distance * direction[1])]
    end

    lagoon_size(points, perimeter)
  end

  def run_b(data)
    perimeter = 0
    points = [[0, 0]]

    to_lines(data).each do |(_direction_char, _distance, hex)|
      # Convert hex to distance and direction
      distance = hex[2..6].to_i(16)
      direction = DIRECTIONS[hex[-2].to_i]

      perimeter += distance
      points << [points[-1][0] + (distance * direction[0]), points[-1][1] + (distance * direction[1])]
    end

    lagoon_size(points, perimeter)
  end

  private

  def to_lines(data)
    data.split("\n").map(&:split)
  end

  # Apply some tricks to correct for the lagoon pixel-block style, where
  # on average blocks are only counted for 50% if you use the inner area.
  # The +1 at the end is needed because the 4 corners count for 75% instead of 50%.
  #
  # See unit test for an example of why this makes sense.
  def lagoon_size(points, perimeter)
    inner_area = shoelace_formula(points)
    inner_area + (perimeter / 2).floor + 1
  end

  def shoelace_formula(points)
    # Inner area of polygon
    n = points.length - 1
    area = 0

    (0...n).each do |i|
      j = i + 1
      area += (points[i][0] * points[j][1])
      area -= (points[j][0] * points[i][1])
    end

    (area.abs / 2).floor
  end
end
