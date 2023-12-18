require 'minitest/autorun'
require_relative '../exercises/exercise18'

class Exercise18Test < Minitest::Test
  INPUT_EXAMPLE = 'R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)'.freeze

  # 10000 = 65536 in decimal, so this is a square dig plan
  CUSTOM_EXAMPLE = 'X X (#100000)
X X (#100001)
X X (#100002)
X X (#100003)'.freeze

  def test_example_a
    assert_equal 62, Exercise18.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 50465, Exercise18.new.run_a(Exercise18.new.load_data)
  end

  def test_example_b
    assert_equal 952408144115, Exercise18.new.run_b(INPUT_EXAMPLE)
  end

  def test_example_b_custom
    # 65536 x 65536 = 4294967296
    # 65536 x 4 = perimeter = 262.144
    # 262.144 / 2 = 131.072
    #   which is just one below 131.073,
    #   because corners should be accounted for 75% instead of 50%
    assert_equal 4295098369, Exercise18.new.run_b(CUSTOM_EXAMPLE)
  end

  def test_input_b
    assert_equal 82712746433310, Exercise18.new.run_b(Exercise18.new.load_data)
  end
end
