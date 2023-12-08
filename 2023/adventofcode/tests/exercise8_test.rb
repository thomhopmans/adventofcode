require 'minitest/autorun'
require_relative '../exercises/exercise8'

class Exercise8Test < Minitest::Test
  def test_example_a
    assert_equal 2, Exercise8.new.run_a("RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)")
  end

  def test_example_a_extra
    assert_equal 6, Exercise8.new.run_a("LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)")
  end

  def test_input_a
    assert_equal 18023, Exercise8.new.run_a(Exercise8.new.load_data)
  end

  def test_example_b
    assert_equal 6, Exercise8.new.run_b("LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)")
  end

  def test_input_b
    assert_equal 14449445933179, Exercise8.new.run_b(Exercise8.new.load_data)
  end
end
