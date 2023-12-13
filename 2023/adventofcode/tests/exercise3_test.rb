require 'minitest/autorun'
require_relative '../exercises/exercise3'

class Exercise03Test < Minitest::Test
  def test_example_a
    assert_equal 4361, Exercise03.new.run_a('467..114..
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
    assert_equal 533775, Exercise03.new.run_a(Exercise03.new.load_data)
  end

  def test_example_b
    assert_equal 467835, Exercise03.new.run_b('467..114..
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
    assert_equal 78236071, Exercise03.new.run_b(Exercise03.new.load_data)
  end
end
