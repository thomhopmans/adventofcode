require 'minitest/autorun'
require_relative '../exercises/exercise14'

class Exercise14Test < Minitest::Test
  INPUT_EXAMPLE = 'O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....'.freeze

  def test_example_a
    assert_equal 136, Exercise14.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 112048, Exercise14.new.run_a(Exercise14.new.load_data)
  end

  def test_example_b
    assert_equal 64, Exercise14.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 105606, Exercise14.new.run_b(Exercise14.new.load_data)
  end
end
