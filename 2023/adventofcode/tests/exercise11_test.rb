require 'minitest/autorun'
require_relative '../exercises/exercise11'

class Exercise11Test < Minitest::Test
  INPUT_EXAMPLE_A = "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....".freeze

  def test_example_a
    assert_equal 374, Exercise11.new.run_a(INPUT_EXAMPLE_A)
  end

  def test_input_a
    assert_equal 9805264, Exercise11.new.run_a(Exercise11.new.load_data)
  end

  def test_example_b
    assert_equal 1030, Exercise11.new.run_b(INPUT_EXAMPLE_A, 10 - 1)
  end

  def test_example_b_two
    assert_equal 8410, Exercise11.new.run_b(INPUT_EXAMPLE_A, 100 - 1)
  end

  def test_input_b
    assert_equal 779032247216, Exercise11.new.run_b(Exercise11.new.load_data, 1000000 - 1)
  end
end
