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

  def test_example_b_one
    assert_equal 4, Exercise10.new.run_b("...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........")
  end

  def test_example_b_two
    assert_equal 4, Exercise10.new.run_b("..........
.S------7.
.|F----7|.
.||OOOO||.
.||OOOO||.
.|L-7F-J|.
.|II||II|.
.L--JL--J.
..........")
  end

  def test_example_b_three
    assert_equal 8, Exercise10.new.run_b(".F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...")
  end

  def test_example_b_four
    assert_equal 10, Exercise10.new.run_b("FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L")
  end

  def test_input_b
    assert_equal 467, Exercise10.new.run_b(Exercise10.new.load_data)
  end
end
