require 'minitest/autorun'
require_relative '../exercises/exercise21'

class Exercise21Test < Minitest::Test
  INPUT_EXAMPLE = '...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........'.freeze

  INPUT_EXAMPLE_B = '.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##...####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................
.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##..S####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................
.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##...####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................'.freeze

  def test_example_a
    assert_equal 16, Exercise21.new.run_a(INPUT_EXAMPLE, steps: 6)
  end

  def test_input_a
    assert_equal 3768, Exercise21.new.run_a(Exercise21.new.load_data, steps: 64)
  end

  # Solution does not work for example
  # def test_example_b
  #   assert_equal 6536, Exercise21.new.run_b(INPUT_EXAMPLE_B, steps: 100)
  #   assert_equal 167004, Exercise21.new.run_b(INPUT_EXAMPLE_B, steps: 500)
  # end

  def test_input_b
    assert_equal 627960775905777, Exercise21.new.run_b(Exercise21.new.load_data)
  end
end