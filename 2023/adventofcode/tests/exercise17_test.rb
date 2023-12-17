require 'minitest/autorun'
require_relative '../exercises/exercise17'

class Exercise17Test < Minitest::Test
  INPUT_EXAMPLE = '2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533'.freeze

  EXTRA_EXAMPLE = '111111111111
999999999991
999999999991
999999999991
999999999991'.freeze

  def test_example_a
    assert_equal 102, Exercise17.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 1244, Exercise17.new.run_a(Exercise17.new.load_data)
  end

  def test_example_b
    assert_equal 94, Exercise17.new.run_b(INPUT_EXAMPLE)
  end

  def test_example_extra
    assert_equal 47, Exercise17.new.run_b(EXTRA_EXAMPLE)
  end

  def test_input_b
    assert_equal 1367, Exercise17.new.run_b(Exercise17.new.load_data)
  end
end
