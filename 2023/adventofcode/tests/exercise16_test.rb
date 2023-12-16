require 'minitest/autorun'
require_relative '../exercises/exercise16'

class Exercise16Test < Minitest::Test
  INPUT_EXAMPLE = '.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\\..
.-.-/..|..
.|....-|.\
..//.|....'.freeze

  INPUT_EXAMPLE_MIRROR_AT_FIRST = '\\|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\\..
.-.-/..|..
.|....-|.\
..//.|....'.freeze

  def test_example_a
    assert_equal 46, Exercise16.new.run_a(INPUT_EXAMPLE)
  end

  def test_example_a_mirror_at_first
    assert_equal 10, Exercise16.new.run_a(INPUT_EXAMPLE_MIRROR_AT_FIRST)
  end

  def test_input_a
    assert_equal 7517, Exercise16.new.run_a(Exercise16.new.load_data)
  end

  def test_example_b
    assert_equal 51, Exercise16.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 7741, Exercise16.new.run_b(Exercise16.new.load_data)
  end
end
