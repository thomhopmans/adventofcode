require 'minitest/autorun'
require_relative '../exercises/exercise10'

class Exercise10Test < Minitest::Test
  def test_example_a_one
    assert_equal 4, Exercise10.new.run_a(".....
.S-7.
.|.|.
.L-J.
.....")
  end

  def test_example_a_two
    assert_equal 8, Exercise10.new.run_a("..F7.
.FJ|.
SJ.L7
|F--J
LJ...")
  end

  def test_example_a_noise
    assert_equal 8, Exercise10.new.run_a("..F7.
.FJ|.
SJ.L7
|F--J
LJ--J")
  end

  def test_input_a
    assert_equal 6927, Exercise10.new.run_a(Exercise10.new.load_data)
  end
end
