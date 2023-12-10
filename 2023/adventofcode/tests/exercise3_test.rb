require 'minitest/autorun'
require_relative '../exercises/exercise3'

class Exercise3Test < Minitest::Test
  def test_example_a
    assert_equal 4361, Exercise3.new.run_a('467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..')
  end

  def test_input_a
    assert_equal 533775, Exercise3.new.run_a(Exercise3.new.load_data)
  end

  def test_example_b
    assert_equal 467835, Exercise3.new.run_b('467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..')
  end

  def test_input_b
    assert_equal 78236071, Exercise3.new.run_b(Exercise3.new.load_data)
  end
end
