require 'minitest/autorun'
require_relative '../exercises/exercise1'

class Exercise01Test < Minitest::Test
  def test_example_a
    assert_equal 12, Exercise01.new.run_a('1abc2')
    assert_equal 38, Exercise01.new.run_a('pqr3stu8vwx')
    assert_equal 15, Exercise01.new.run_a('a1b2c3d4e5f')
    assert_equal 77, Exercise01.new.run_a('treb7uchet')
  end

  def test_input_a
    assert_equal 55816, Exercise01.new.run_a(Exercise01.new.load_data)
  end

  def test_example_b
    assert_equal 83, Exercise01.new.run_b('eightwothree')
    assert_equal 88, Exercise01.new.run_b('eightavsdfsdfsd')
    assert_equal 88, Exercise01.new.run_b('avsdfsdfsd8')
  end

  def test_example_b_full
    assert_equal 281, Exercise01.new.run_b('two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen')
  end

  def test_input_b
    assert_equal 54980, Exercise01.new.run_b(Exercise01.new.load_data)
  end
end
