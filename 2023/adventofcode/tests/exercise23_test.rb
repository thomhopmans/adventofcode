require 'minitest/autorun'
require_relative '../exercises/exercise23'

class Exercise23Test < Minitest::Test
  INPUT_EXAMPLE = '#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#'.freeze

  INPUT_EXAMPLE_CUSTOM = '#.########
#.....####
##.##.####
##.......#
########.#'.freeze

  def test_example_a
    assert_equal 94, Exercise23.new.run_a(INPUT_EXAMPLE)
  end

  # def test_input_a
  #   assert_equal 2306, Exercise23.new.run_a(Exercise23.new.load_data)
  # end

  def test_example_b
    assert_equal 154, Exercise23.new.run_b(INPUT_EXAMPLE)
  end

  def test_example_b_extra
    assert_equal 11, Exercise23.new.run_b(INPUT_EXAMPLE_CUSTOM)
  end

  # def test_input_b
  #   assert_equal 6718, Exercise23.new.run_b(Exercise23.new.load_data)
  # end
end
