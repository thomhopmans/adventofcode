require 'minitest/autorun'
require_relative '../exercises/exercise13'

class Exercise13Test < Minitest::Test
  INPUT_EXAMPLE = '#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#'.freeze

  def test_example_a
    assert_equal 405, Exercise13.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 35521, Exercise13.new.run_a(Exercise13.new.load_data)
  end

  def test_example_b
    assert_equal 400, Exercise13.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 34795, Exercise13.new.run_b(Exercise13.new.load_data)
  end
end
